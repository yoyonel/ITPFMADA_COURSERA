// Title: Final-Projet_Tekufah

public class CScoreMIDI
{

	// ------------------------------------------------------------------------
	// Members + Constructor
	// ------------------------------------------------------------------------
	
	// Deal with global tempo
    BPM m_tempo;
    fun void set_tempo(int _tempo) { m_tempo.tempo(_tempo); };
	
	// envelope for the instrument
    ADSR env;    
    
	// TPQ: Ticks per Quarter
    480 => int TPQ;	// 1 quarter = 480 ticks
    0::second => dur tick_duration;	// convert the tick (MIDI) duration in time (ChucK reference)
    0 => int nb_samp_for_1_tick;	// number (ChucK) sample(s) for 1 tick (MIDI)
    0::second => dur step_time_for_ChucK;	// delta time for ChucK rendering
    0 => int cur_tick;	// id to current tick (MIDI)

	// ID for Midi Engine
	// represent differents states of the engine
    0 => static int ME_ID_ATTACK_NOTE;
    1 => static int ME_ID_RELEASE_NOTE;
    2 => static int ME_ID_STAY_NOTE;
    3 => static int ME_ID_SILENT_NOTE;
    
    // Pointers on dynamic arrays
    int arr_dates[0];	// dates for notes
    int arr_midis[0];	// id midis for notes
    int arr_durations[0];	// durations for notes
    
	// Maximum notes deal in the same time (same date)
    2 => int MAX_NOTES_IN_SAME_TIME;
    	
    0 => int cur_midi_note;	// current id for Engine Midi
    0 => int next_midi_note;	// next midi note
    
    int cur_counter_duration[MAX_NOTES_IN_SAME_TIME];	// counter (duration) for the current midi note
    int cur_midi[MAX_NOTES_IN_SAME_TIME];	// IDs for current midis notes
    int playing_a_note[MAX_NOTES_IN_SAME_TIME];	// boolean indicate if we are playing a note
    
    int state[MAX_NOTES_IN_SAME_TIME];	// State(s) for Midi-Engine
    
	// Initialisation of Midi Engine
    for( 0 => int i; i < MAX_NOTES_IN_SAME_TIME; i++ )
    {
        0 => cur_counter_duration[i] => cur_midi[i];
        false => playing_a_note[i];
        ME_ID_SILENT_NOTE => state[i];
    }
    
	
	// ------------------------------------------------------------------------
	// - Methods/Functions -
	// ------------------------------------------------------------------------
	
    // current tick (MIDI)
    fun int current_tick() { return cur_tick; }    
    // current state
    fun int attack_note( int _id_note ) { return state[_id_note] == ME_ID_ATTACK_NOTE; }
    fun int release_note( int _id_note ) { return state[_id_note] == ME_ID_RELEASE_NOTE; }
    fun int stay_note( int _id_note ) { return state[_id_note] == ME_ID_STAY_NOTE; }
    fun int silent_note( int _id_note ) { return state[_id_note] == ME_ID_SILENT_NOTE; }
    // current midi note
    fun int get_current_note_midi( int _id_note ) { return cur_midi[_id_note]; }
	
    // Update the Midi Engine
	// Global method, call the local method for each different possible in the same time (if we need)
    fun void update_midi_engine_CSM()
    {
		// update midi engine for all different note
        for( 0 => int i; i < MAX_NOTES_IN_SAME_TIME; i++ )
        {
            update_midi_engine_CSM(i);
        }
    }
    
	// Update Midi Engine for a specific note
    fun void update_midi_engine_CSM( int _id_note )
    {
        // Time to play a new note ?
        if( next_midi_note < arr_dates.cap() && arr_dates[next_midi_note] == cur_tick )
        {
            ME_ID_ATTACK_NOTE => state[_id_note];
            //
            next_midi_note => cur_midi_note;
            next_midi_note++;
            //
            arr_midis[cur_midi_note] => cur_midi[_id_note];
            arr_durations[cur_midi_note] => cur_counter_duration[_id_note];
            dtot(env.releaseTime()) -=> cur_counter_duration[_id_note];
            //
            true => playing_a_note[_id_note];
        }
        else if( playing_a_note[_id_note] )	// Are we playing a note ?
        {
            if( cur_counter_duration[_id_note] == 0 ) // duration counter is finish ?
            {
                ME_ID_RELEASE_NOTE => state[_id_note];
                //
                false => playing_a_note[_id_note];
            }
            else
            {                
                ME_ID_STAY_NOTE => state[_id_note]; // we playing a note
                //
                cur_counter_duration[_id_note]--;
            }
        }
        else
        {
            ME_ID_SILENT_NOTE => state[_id_note];   // we are inside a silence note
        }
    }
    
	// Play: udpdate VM-ChucK audio rendering
	// update the tick (MIDI) counter 
    fun void play_CSM()
    {        
        // Subdivise time to have a better quality for wav creation from ChucK engine
        for( 0 => int i; i < nb_samp_for_1_tick; i++ )
        {
            step_time_for_ChucK => now ;	// advanced time for ChucK	
        }
		// advande the tick (MIDI)
        cur_tick++;
    }
    
	// Update and play with Midi Engine and VM-ChucK
    fun void update_and_play_CSM()
    {
        update_midi_engine_CSM();
        play_CSM();
    }
    
	// Update the tempo from (global) class BPM
    fun void update_timing_from_bpm_CSM()
    {        
        m_tempo.quarterNote => dur quarter_duration;
        quarter_duration / (TPQ $ float) => tick_duration;
        Std.ftoi( Math.floor(tick_duration / 1::samp) * 0.5 ) => nb_samp_for_1_tick;
        tick_duration / nb_samp_for_1_tick => step_time_for_ChucK;
    }
    
    // dur to tick
    fun int dtot( dur _dur )
    {        
        return Std.ftoi(Math.floor(_dur/tick_duration));
    }
    
	// Tools to append score/datas to Midi arrays
	// this tool deal with dynamics arrays (sizes)
	// and add/append datas to our arrays (with dynamic resize)
    fun int append( int _arr_dates[], int _arr_midi[], int _arr_duration[] )
    {
        0 => int i_result;

		// get the minimal size of the 3 arrays
        min_sizes( [_arr_dates, _arr_midi, _arr_duration] ) => int min_size;
		
		// save the old size
        arr_dates.cap() => int id_old_cap;
        
		// compute the new size for arrays
		id_old_cap + min_size => int new_size;
        
		// Resize arrays
        arr_dates.size(new_size);
        arr_midis.size(new_size);
        arr_durations.size(new_size);
        
		// offset for indice
        id_old_cap => int new_indice;
        for( 0 => int i; i < min_size; i++ )
        {
			// store values
            _arr_dates[i] => arr_dates[new_indice];
            _arr_midi[i] => arr_midis[new_indice];
            _arr_duration[i] => arr_durations[new_indice];
			// next values
            new_indice++;
        }        
        
        //<<< "after affectation ..." >>>;
        1 => i_result;
        
        return i_result;
    }
    
	// Find the minimal size of the array of (int) arrays
    fun int min_sizes( int _arrays[][] )
    {
        0 => int i_result;
		// if the global array is not empty
        if( _arrays.cap() )
        {
			// find the minimal size
            _arrays[0].cap() => int min_size;
            for( 1 => int i; i < _arrays.cap(); i++ )
            {
                if( _arrays[i].cap() < min_size ) _arrays[i].cap() => min_size;
            }
            min_size => i_result;
        }        
        return i_result;
    }
	
	// ------------------------------------------------------------------------
	// Hard to deal with inheritance and overloading
	// This part is to manage manually and avoid issues
	// using a local name with suffix: CSM - Class Score Midi
	// and a generic name (overloading) for inheritance (but depend of the inclusions ... so not very stable functionality)
	// ------------------------------------------------------------------------
	fun void play() { play_CSM(); }
	fun void update_midi_engine() { update_midi_engine_CSM(); }
	fun void update_timing_from_bpm() { update_timing_from_bpm_CSM(); }
	fun void update_and_play() { update_and_play_CSM(); }
}
