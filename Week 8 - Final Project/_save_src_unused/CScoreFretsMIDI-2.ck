// Title: Final-Projet_Tekufah

public class CScoreFretsMIDI extends CScoreMIDI
{    
	// ------------------------------------------------------------------------
	// Members + Constructor
	// ------------------------------------------------------------------------
	// Deal with global tempo    
    //BPM m_tempo;
    //fun void set_tempo(int _tempo) { m_tempo.tempo(_tempo); };
	
	// envelope for the instrument
	//ADSR env;
    
    // TPQ: Ticks per Quarter
	/**
    480 => int TPQ;	// 1 quarter = 480 ticks
    0::second => dur tick_duration;	// convert the tick (MIDI) duration in time (ChucK reference)
    0 => int nb_samp_for_1_tick;	// number (ChucK) sample(s) for 1 tick (MIDI)
    0::second => dur step_time_for_ChucK;	// delta time for ChucK rendering
    0 => int cur_tick;	// id to current tick (MIDI)
	/**/

	// ID for Midi Engine
	/**
	// represent differents states of the engine
    0 => static int ME_ID_ATTACK_NOTE;
    1 => static int ME_ID_RELEASE_NOTE;
    2 => static int ME_ID_STAY_NOTE;
    3 => static int ME_ID_SILENT_NOTE;
    /**/
	
    // Pointer on dynamic arrays
	/**
    int arr_dates[0];
    int arr_midis[0];
    int arr_durations[0];
	/**/
    int arr_frets[0];
    int arr_strings[0];

	/**
    2 => int MAX_NOTES_IN_SAME_TIME;
    
    0 => int cur_midi_note;
    0 => int next_midi_note;
    
    int cur_counter_duration[MAX_NOTES_IN_SAME_TIME];
    int cur_midi[MAX_NOTES_IN_SAME_TIME];
    int playing_a_note[MAX_NOTES_IN_SAME_TIME]; // bool
	/**/
	
    int cur_fret[MAX_NOTES_IN_SAME_TIME];
    int cur_string[MAX_NOTES_IN_SAME_TIME];
    
	/**
    int state[MAX_NOTES_IN_SAME_TIME];
    /**/
	
    for( 0 => int i; i < MAX_NOTES_IN_SAME_TIME; i++ )
    {
        //0 => cur_counter_duration[i] => cur_midi[i];
		0 => cur_fret[i] => cur_string[i];
        //false => playing_a_note[i];
        //3 => state[i];
    }
    
	/**
    //
    fun int current_tick() { return cur_tick; }    
    //
    fun int attack_note( int _id_note ) { return state[_id_note] == ME_ID_ATTACK_NOTE; }
    fun int release_note( int _id_note ) { return state[_id_note] == ME_ID_RELEASE_NOTE; }
    fun int stay_note( int _id_note ) { return state[_id_note] == ME_ID_STAY_NOTE; }
    fun int silent_note( int _id_note ) { return state[_id_note] == ME_ID_SILENT_NOTE; }
    //
    fun int get_current_note_midi( int _id_note ) { return cur_midi[_id_note]; }
	/**/
    fun int get_current_fret( int _id_note ) { return cur_fret[_id_note]; }
    fun int get_current_string( int _id_note ) { return cur_string[_id_note]; }
    //
    	
    fun void update_midi_engine_CSFM()
    {
        for( 0 => int i; i < MAX_NOTES_IN_SAME_TIME; i++ )
        {
            update_midi_engine_CSFM(i);
        }
    }
	
    fun void update_midi_engine_CSFM( int _id_note )
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
            arr_frets[cur_midi_note] => cur_fret[_id_note];
            arr_strings[cur_midi_note] => cur_string[_id_note];
            //
            dtot(env.releaseTime()) -=> cur_counter_duration[_id_note];
            //
            true => playing_a_note[_id_note];
        }
        else if( playing_a_note[_id_note] )
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
    
	/**
    fun void play()
    {        
        //<<< this, "-> play()" >>>;
        // Subdivise time to have a better quality for wav creation from ChucK engine
        for( 0 => int i; i < nb_samp_for_1_tick; i++ )
        {
            //fade_out_for_the_end();	// fade-out at the end
            step_time_for_ChucK => now ;	// advanced time for ChucK	
        }
        cur_tick++;
    }
	/**/
    	
    fun void update_and_play_CSFM()
    {
        update_midi_engine_CSFM();
        play();
    }
    
	/**
    fun void update_timing_from_bpm()
    {        
        m_tempo.quarterNote => dur quarter_duration;
        quarter_duration / (TPQ $ float) => tick_duration;
        Std.ftoi( Math.floor(tick_duration / 1::samp) * 0.5 ) => nb_samp_for_1_tick;
        tick_duration / nb_samp_for_1_tick => step_time_for_ChucK;
        
        //<<< "quarter_duration: ", quarter_duration/1::second >>>;
        //<<< "step_time_for_ChucK: ", step_time_for_ChucK/1::second >>>;
    }
    
    // dur to tick
    fun int dtot( dur _dur )
    {        
        return Std.ftoi(Math.floor(_dur/tick_duration));
    }
    /**/
	
    fun int append( int _arr_dates[], int _arr_midi[], int _arr_duration[], int _arr_fret[], int _arr_string[] )
    {
        0 => int i_result;

        min_sizes( [_arr_dates, _arr_midi, _arr_duration, _arr_fret] ) => int min_size;
        //<<< "min_size: ", min_size >>>;
        //if( _arr_dates.cap() != _arr_midi.cap() || _arr_dates.cap() != _arr_duration.cap() )
            //return -1;
                
        arr_dates.cap() => int id_old_cap;
        //<<< "arr_dates.cap():", arr_dates.cap() >>>;
        
        //id_old_cap + _arr_dates.cap() => int new_size;
        id_old_cap + min_size => int new_size;
        
        arr_dates.size(new_size);
        arr_midis.size(new_size);
        arr_durations.size(new_size);
        arr_frets.size(new_size);
        arr_strings.size(new_size);
        //<<< "arr_dates.cap():", arr_dates.cap() >>>;

        id_old_cap => int new_indice;
        for( 0 => int i; i < min_size; i++ )
        {
            //<<< "i: ", i >>>;
            _arr_dates[i] => arr_dates[new_indice];
            _arr_midi[i] => arr_midis[new_indice];
            _arr_duration[i] => arr_durations[new_indice];
            _arr_fret[i] => arr_frets[new_indice];
            _arr_string[i] - 1 => arr_strings[new_indice]; // mog
            //
            new_indice++;
        }        
        
        //<<< "after affectation ..." >>>;
        1 => i_result;
        
        return i_result;
    }
    
	/**
    fun int min_sizes( int _arrays[][] )
    {
        0 => int i_result;
        if( _arrays.cap() )
        {
            _arrays[0].cap() => int min_size;
            for( 1 => int i; i < _arrays.cap(); i++ )
            {
                if( _arrays[i].cap() < min_size ) _arrays[i].cap() => min_size;
            }
            min_size => i_result;
        }        
        return i_result;
    }
	/**/
	

	fun void update_midi_engine() { update_midi_engine_CSFM(); }
	fun void update_midi_engine(int _id_note) { update_midi_engine_CSFM(_id_note); }
	fun void update_and_play() { update_and_play_CSFM(); }
}
