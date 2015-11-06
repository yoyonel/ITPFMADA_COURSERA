// Title: Final-Projet_Tekufah

public class CScoreDrum
{
	// ------------------------------------------------------------------------
	// Members + Constructor
	// ------------------------------------------------------------------------
	// Deal with global tempo
    BPM m_tempo;
    fun void set_tempo(int _tempo) { m_tempo.tempo(_tempo); };
    
	// static values for sizes of arrays in this class
	// not very subtil ... need to clean (to manager dynamics sizes)
    64 => static int MAX_BARS;
    (6*4*8) => static int MAX_BEATS;
	
	// IDs for beat values: Whole to Sixteenth
	16 => int WHOLE_BEAT_VALUE;
	8 => int HALF_BEAT_VALUE;
	4 => int QUARTER_BEAT_VALUE;
	2 => int EIGHTH_BEAT_VALUE;
	1 => int SIXTEENTH_BEAT_VALUE;
    
	// number bars loaded
    0 => int nb_bars_loaded;
    
	// score for our drum
    int score[MAX_BARS][MAX_BEATS];    
	
	
	// ------------------------------------------------------------------------
	// - Methods/Functions -
	// ------------------------------------------------------------------------
	
	//
	// Tools to add a bar to our structure
	//
	
	// Add 1 bar
	// return:
	// - 1: no problem, all bars loaded
	// - 0: if problem (not enougth space)
    fun int add_bar( int _score_bar[] )
    {
        0 => int result;
        if( nb_bars_loaded < MAX_BARS )
        {
            if( _score_bar.cap() < MAX_BEATS )
            {
                _score_bar @=> score[nb_bars_loaded];
                nb_bars_loaded++;
                1 => result;
            }
        }
        return result;
    }    
	
	// Add multiples bars
	// return: ...
    fun int add_bars( int _score_bars[][] )
    {
        0 => int result;
        0 => int cur_id_bar;
        0 => int nb_bars_added;
        while( nb_bars_loaded < MAX_BARS && cur_id_bar < _score_bars.cap() )
        {            
            add_bar( _score_bars[cur_id_bar] ) +=> nb_bars_added;
            cur_id_bar++;
        }
        if( nb_bars_added == _score_bars.cap() )
            1 => result;
        
        return result;
    }
    
	// Add multiples bars repeat _nb_repeat times the process
	// return: ...	
    fun int add_bars_repeat( int _score_bars[][], int _nb_repeat )
    {
        0 => int id_repeat;
        while( id_repeat < _nb_repeat && add_bars(_score_bars) )
            id_repeat++;
        return (id_repeat==_nb_repeat);
    }
    
	// Add 1 bar repeat _nb_repeat times
	// return: ...	
    fun int add_bar_repeat( int _score_bar[], int _nb_repeat )
    {
        0 => int id_repeat;
        while( id_repeat < _nb_repeat && add_bar(_score_bar) )
            id_repeat++;
        return 1;
    }

	// Test to know if it's time to play the drum
	// depending of a id bar and id beat (where we are in the score)
	// return:
	// - 1: if we need to play the drum
	// - 0: no need to play
    fun int test_for_playing( int _id_bar, int _id_beat )
    {
        false => int b_result_test;
		// test the boundaries of our arrays
		// can we play in the part of the score
        if( _id_bar < nb_bars_loaded )
        {
			// no optimal !
			// test if a value respond to our request
			// it's not a direct test ! :-/
			// maximum test to do
            score[_id_bar].size() => int max_tests;
            0 => int id_test;
			// loop until we find a 'good' result
            while( !b_result_test && (id_test < max_tests) )
            {
                (score[_id_bar][id_test] == _id_beat) => b_result_test;
                id_test ++;
            }
        }
		// return the result test
        return b_result_test;
    }
	
	// Tool: decode a value from a string representation
	// Useful for editing/write tabs drum
	fun int decode_string_value( string _s_note_value )
	{
		0 => int value;
		
		if( _s_note_value == "WHOLE" || _s_note_value == "W" )
			WHOLE_BEAT_VALUE => value;		
		else if( _s_note_value == "WHOLE." || _s_note_value == "W." )
			Std.ftoi(WHOLE_BEAT_VALUE * 1.5) => value;		
		else if( _s_note_value == "HALF" || _s_note_value == "H" )
			HALF_BEAT_VALUE => value;		
		else if( _s_note_value == "HALF." || _s_note_value == "H." )
			Std.ftoi(HALF_BEAT_VALUE * 1.5) => value;			
		else if( _s_note_value == "QUARTER" || _s_note_value == "Q" )	
			QUARTER_BEAT_VALUE => value;
		else if( _s_note_value == "QUARTER." || _s_note_value == "Q." )
			Std.ftoi(QUARTER_BEAT_VALUE * 1.5) => value;
		else if( _s_note_value == "EIGHTH" || _s_note_value == "E" )
			EIGHTH_BEAT_VALUE => value;
		else if( _s_note_value == "EIGHTH." || _s_note_value == "E." )
			Std.ftoi(EIGHTH_BEAT_VALUE * 1.5) => value;
		else if( _s_note_value == "SIXTEENTH" || _s_note_value == "S" )
			SIXTEENTH_BEAT_VALUE => value;
		
		return value;
	}
	
	// append a note with string representation in our structures
	// "B": for 'Beat'
	// "S": for 'Silent' (note)
	// "W" -> "S" : Whole to Sixteenth for values notes
	// return the new indice in the current building bar drum
	fun int append_drum_note( string _type, string _value, int _bar_drum[], int _id_cur_beat )
	{
		// decode the string value and store the value for offset (use at the end)
		decode_string_value(_value) => int value;
		// test
		if( _type == "B" ) // a beat
		{
			// resize the bar (+1)
			_bar_drum.size( _bar_drum.cap() + 1 );
			// add this beat in the bar
			_id_cur_beat => _bar_drum[_bar_drum.cap() - 1];
		}
		// else is a silence == "S"
		// return the new index in the bar
		return value;
	}
	
	// Create a bar from strings representation: [ 'type', 'value', 'type', 'value', ... ]
	// type: "B" for a beat, "S" for silence
	// value: "W" -> "S" for values (Whote to Sixteenth)
	fun void create_drum_bar_from_score( string _sequence_beats_score[], int _result_drum_bar[] )
	{	
		_sequence_beats_score.cap() / 2 => int nb_drum_notes;		
		// loop for each pair of 'type' + 'value'
		0 => int id_cur_beat;		
		for( 0 => int i; i < nb_drum_notes; i++ )
		{
			// Get the current beat string representation
			// pair of type, value
			_sequence_beats_score[i*2] => string drum_note_type;
			_sequence_beats_score[i*2+1] => string drum_note_value;
			// append this beat drum to our resultat drum bar
			// update the current index beat
			append_drum_note( drum_note_type, drum_note_value, _result_drum_bar, id_cur_beat ) +=> id_cur_beat;
		}
	}
	
	// Tool debug: print out a drum bar
	fun void print_bar( int _drum_bar[] )
	{
		for(0 => int i; i < _drum_bar.cap(); i++)
		{
			<<< "- ", _drum_bar[i] >>>;
		}
	}
	
	// ------------------------------------------------------------------------
	// Hard to deal with inheritance and overloading
	// This part is to manage manually and avoid issues
	// using a local name with suffix: CSD - Class Score Drum
	// and a generic name (overloading) for inheritance (but depend of the inclusions ... so not very stable functionality)
	// ------------------------------------------------------------------------
}