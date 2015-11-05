// Title: Final-Projet_Tekufah

// CScoreFretsMIDI derived from CScoreMIDI
// and add 2 new features/composents : fret and string
// to simulate a fret-guitar with strings
// No comments in the class because they are the same for CScoreMIDI (refer to this class if we need more informations)
public class CScoreFretsMIDI extends CScoreMIDI
{    
	// ------------------------------------------------------------------------
	// Members + Constructor
	// ------------------------------------------------------------------------
	
    int arr_frets[0];
    int arr_strings[0];

    int cur_fret[MAX_NOTES_IN_SAME_TIME];
    int cur_string[MAX_NOTES_IN_SAME_TIME];
    
    for( 0 => int i; i < MAX_NOTES_IN_SAME_TIME; i++ )
    {
		0 => cur_fret[i] => cur_string[i];
    }
    
	
	// ------------------------------------------------------------------------
	// - Methods/Functions -
	// ------------------------------------------------------------------------
	
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
    
    fun void update_and_play_CSFM()
    {
        update_midi_engine_CSFM();
        play();
    }
 
    fun int append( int _arr_dates[], int _arr_midi[], int _arr_duration[], int _arr_fret[], int _arr_string[] )
    {
        0 => int i_result;

        min_sizes( [_arr_dates, _arr_midi, _arr_duration, _arr_fret] ) => int min_size;
   
        arr_dates.cap() => int id_old_cap;
   
		id_old_cap + min_size => int new_size;
        
        arr_dates.size(new_size);
        arr_midis.size(new_size);
        arr_durations.size(new_size);
        arr_frets.size(new_size);
        arr_strings.size(new_size);
 
        id_old_cap => int new_indice;
        for( 0 => int i; i < min_size; i++ )
        {
            _arr_dates[i] => arr_dates[new_indice];
            _arr_midi[i] => arr_midis[new_indice];
            _arr_duration[i] => arr_durations[new_indice];
            _arr_fret[i] => arr_frets[new_indice];
            _arr_string[i] - 1 => arr_strings[new_indice]; // mog
            //
            new_indice++;
        }        
        
        1 => i_result;
        
        return i_result;
    }    

	
	// ------------------------------------------------------------------------
	// Hard to deal with inheritance and overloading
	// This part is to manage manually and avoid issues
	// using a local name with suffix: CSFM - Class Score Frets Midi
	// and a generic name (overloading) for inheritance (but depend of the inclusions ... so not very stable functionality)	
	fun void update_midi_engine() { update_midi_engine_CSFM(); }
	fun void update_midi_engine(int _id_note) { update_midi_engine_CSFM(_id_note); }
	fun void update_and_play() { update_and_play_CSFM(); }
}
