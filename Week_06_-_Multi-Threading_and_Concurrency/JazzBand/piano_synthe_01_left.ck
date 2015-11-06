Pan2 pan2_instrument => dac ;

0.25 => pan2_instrument.pan;

Gain gain_instrument;

0.050 => float scale_gain_for_instrument;

5 => int nb_fingers_for_one_hand;
Rhodey piano[nb_fingers_for_one_hand];

PRCRev rev;
true => int b_use_fx_reverb;
0.20 => float rev_mix_for_instrument;

-2 => int offset_scale_midi_note;

0 => int ID_WHOLE_NOTE;
1 => int ID_HALF_NOTE;
2 => int ID_QUARTER_NOTE;
3 => int ID_EIGHTH_NOTE;
4 => int ID_SIXTEENTH_NOTE;
5 => int ID_THIRTY_SECOND_NOTE;

// 'make quarter Notes (main compositional pulse) 0.6::second in your composition'
0.625::second => dur quarter_duration;

// Length of the composition
30::second => dur dur_length_composition;

// signature rythmique : 3 / 4 
Std.ftoi( dur_length_composition / (3 * quarter_duration) ) => int nb_bars_for_this_song;

// compute the notes values using for this composition
(ID_THIRTY_SECOND_NOTE+1) => int max_subdivision_for_notes_values;
dur array_notes_values[max_subdivision_for_notes_values];
compute_notes_values( quarter_duration, max_subdivision_for_notes_values );

array_notes_values[ ID_SIXTEENTH_NOTE ] => dur step_time_for_instrument;

16 * nb_bars_for_this_song => int nb_beats_for_this_song;

[
	[ 46,		0,		0,		0,		0 ] ,	// first chord
	[ 46,		53, 	58, 	0,		0 ]		// 2nd chord
] @=> int array_midis_notes_for_chords[][];

int array_int_id_chords[nb_beats_for_this_song];
dur array_dur_notes_values[nb_beats_for_this_song];

1 => int nb_instrument;

int array_int_id_chords_instrument[nb_instrument][nb_beats_for_this_song];

dur array_dur_notes_values_instrument[nb_instrument][nb_beats_for_this_song];

0 => int start_id_instrument;
nb_instrument => int end_id_insrument;

int array_current_id_note_for_instrument[nb_instrument];
int array_current_note_for_instrument[nb_instrument];
dur array_current_note_value_instrument[nb_instrument];
int array_current_note_is_silent_instrument[nb_instrument];
dur array_duration_for_next_note_for_instrument[nb_instrument];

load_instruments();

init_instrument( scale_gain_for_instrument );

// ____________________________________________________________________________________________________________________________________
// ------------------------------------------------------------------------------------------------
// ____________________________________________________________________________________________________________________________________

// Useful to control the timing of our composition
now => time time_start_composition;	

// Play the first notes (for all instruments)
// to set correctly the instruments (at the beginning)
update_instrument(step_time_for_instrument) ;
play_composition( step_time_for_instrument ) ;

while( is_end_composition() )
{
	update_instrument(step_time_for_instrument) ;
	play_composition(step_time_for_instrument) ;
}

// ____________________________________________________________________________________________________________________________________
// ------------------------------------------------------------------------------------------------
// ____________________________________________________________________________________________________________________________________



// ____________________________________________________________________________________________________________________________________
/**
*
*/
fun void init_instrument( float _scale_gain )
{
	1.0 / nb_instrument => gain_instrument.gain;
	_scale_gain * gain_instrument.gain() => gain_instrument.gain;

	for( 0 => int i; i < piano.cap(); i++ )
	{
		piano[i] => gain_instrument;
	}
	
	set_equalisation_for_instrument( 0 ); // normal settings	
	
	gain_instrument => pan2_instrument;
	
	fill_array_dur( 0::second, array_current_note_value_instrument );
	fill_array_int( false, array_current_note_is_silent_instrument );
	fill_array_int( 0, array_current_id_note_for_instrument );
	fill_array_int( 0, array_current_note_for_instrument );
	fill_array_dur( 0::second, array_duration_for_next_note_for_instrument );	
	
	if( b_use_fx_reverb )
	{
		rev_mix_for_instrument => rev.mix;
		gain_instrument => rev => pan2_instrument;
	}

	[ 		
		array_int_id_chords
	] @=> array_int_id_chords_instrument;

	[		
		array_dur_notes_values
	] @=> array_dur_notes_values_instrument;
}

/**
*
*/
fun void load_instruments()
{
	// --------------------------------------------------
	// Indices for chords (0 for silence, 1 for the first, 2 for the second chord)
	[
		1, 0, 0, 2, 0, 1, 0, 2, 0, 2, 0, 1, 	0, 1, 0, 2, 0, 2, 0, 1, 0, 1, 0, 2,
		0, 1, 0, 2, 0, 1, 0, 2, 0, 2, 0, 1, 	0, 1, 0, 2, 0, 1, 0, 2, 0, 2, 0, 1,
		0, 1, 0, 2, 0, 1, 0, 2, 0, 2, 0, 1,  	0, 1, 0, 2, 0, 1, 0, 2, 0, 2, 0, 1,
		0, 1, 0, 2, 0, 1, 0, 2, 0, 2, 0, 1,  	0, 1, 0, 2, 0, 1, 0, 2, 0, 2, 0, 1,
		
		0, 1, 0, 2, 0, 1, 0, 2, 0, 2, 0, 1,  	0, 1, 0, 2, 0, 1, 0, 2, 0, 2, 0, 1,
		0, 1, 0, 2, 0, 1, 0, 2, 0, 2, 0, 1,  	0, 1, 0, 2, 0, 1, 0, 2, 0, 2, 0, 1,
		0, 1, 0, 2, 0, 1, 0, 2, 0, 2, 0, 1,  	0, 1, 0, 2, 0, 1, 0, 2, 0, 2, 0, 1,
		
		0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	] @=> array_int_id_chords;
			
	fill_array_dur( decode_note_value_from_string("S"), array_dur_notes_values ); // SIXTEENTH note value for every note
}

/**
*
*/
fun void set_equalisation_for_instrument( int _id_type_eq )
{
	if( _id_type_eq == 0 )
	{
		0.75 => pan2_instrument.gain;
	}
	else if ( _id_type_eq == -1 )
	{
		0.00 => pan2_instrument.gain ;
	}
	else
	{
		1.000 => pan2_instrument.gain;
	}
}

/**
*
*/
fun void update_instrument( dur step_time )
{
	for( start_id_instrument => int id_instrument; id_instrument < end_id_insrument; id_instrument++ )
	{		
		//
		update_instrument(id_instrument);
		//
		update_timers_for_instrument( id_instrument, step_time );			
	}
}

/**
*
*/
fun void play_composition( dur step_time )
{
	// Update: Chuck audio
	step_time => now ;
}
	
/**
*
*/
fun void update_instrument( int _id_instrument )
{
	// It's time to update note ?
	if( array_duration_for_next_note_for_instrument[_id_instrument] <= 0::second )
	{
		// Update 'Note'
		update_current_note_for_instrument(_id_instrument);
		
		// Update current indice note -> next note		
		update_current_id_note_for_instrument(_id_instrument);
		
		// 
		update_audio_rendering_for_instrument(_id_instrument);		
	}
}

/**
*
*/
fun void update_audio_rendering_for_instrument( int _id_instrument )
{	
	array_current_id_note_for_instrument[ _id_instrument ] - 1 @=> int id_current_note_instrument;
	//<<< id_current_note_instrument >>>;
	
	// Is a silence ?
	if( !array_current_note_is_silent_instrument[_id_instrument] )
	{
		//<<< "not a silence note" >>>;
		array_current_note_for_instrument[ _id_instrument ] - 1 @=> int id_chord_instrument;		
		array_midis_notes_for_chords[id_chord_instrument] @=> int midis_notes_for_chord[];
		for( 0 => int i; i < midis_notes_for_chord.cap(); i++ )
		{
			if( midis_notes_for_chord[i] )
			{
				Std.mtof( midis_notes_for_chord[i] + offset_scale_midi_note*12 ) => piano[i].freq;
				Math.random2f( 0.5, 1.0 ) => piano[i].noteOn;
				//1.0 => piano[i].noteOn;
				//cout_duration( "noteOn position time", now - time_start_composition );
			}
		}
		//
		//<<< "id_chord_instrument:", id_chord_instrument >>>;
	}
	else
	{	
		for( 0 => int i; i < piano.cap(); i++ )
		{
			1.0 => piano[i].noteOff;
		}
	}
}

/**
*	Update duration counter for instrument
*/
fun void update_timers_for_instrument( int _id_instrument, dur _step_time )
{
	_step_time -=> array_duration_for_next_note_for_instrument[_id_instrument];
}

/**
*
*/
fun void update_current_note_for_instrument( int _indice_instrument )
{
	array_current_id_note_for_instrument[_indice_instrument] @=> int id_current_note_instrument;	
	
	update_note_from_parameters_instrument( 
		_indice_instrument,
		id_current_note_instrument,
		array_int_id_chords_instrument,
		array_dur_notes_values_instrument
	) => int id_result;		
	
	// update duration counter
	array_current_note_value_instrument[_indice_instrument] => array_duration_for_next_note_for_instrument[_indice_instrument];
}

/**
*
*/
fun void update_current_id_note_for_instrument( int _indice_instrument )
{	
	array_current_id_note_for_instrument[_indice_instrument]++;	
	array_int_id_chords_instrument[_indice_instrument].cap() %=> array_current_id_note_for_instrument[_indice_instrument]; // prevent to not go over the max indice of this array
}

/**
*	decode_note_from_parameters : update 'array_current_note_value_instrument'
*/
fun int update_note_from_parameters_instrument( 
	int _indice_instrument, 
	int _id_current_note_instrument, 
	int _array_notes_instrument[][], 
	dur _array_notes_values_instrument[][] 
)
{
	0 => int id_result;
	
	_array_notes_instrument[_indice_instrument][_id_current_note_instrument] @=> int note_instrument;
	
	note_instrument => array_current_note_for_instrument[_indice_instrument];
	
	// is a silence ?
	(note_instrument == 0) => array_current_note_is_silent_instrument[_indice_instrument] => id_result;
	
	// Note Value decoding/interpreting
	_array_notes_values_instrument[_indice_instrument][_id_current_note_instrument] @=> dur dur_note_value_instrument;
	dur_note_value_instrument => array_current_note_value_instrument[_indice_instrument];	
			
	return id_result;
}

/**
*
*/
fun int is_end_composition()
{
	return ( now - time_start_composition ) + step_time_for_instrument <= dur_length_composition;
}

/**
*
*/
fun dur decode_note_value_from_string( string _s_note_value )
{
	//<<< "decode_note_value_from_string" >>>;
	
	-1 => int result_id;
	0::second => dur result_cur_value;
	false => int is_augmented;
	
	if( _s_note_value == "WHOLE" || _s_note_value == "W" )
		ID_WHOLE_NOTE => result_id;
	else if( _s_note_value == "WHOLE." || _s_note_value == "W." )
	{
		ID_WHOLE_NOTE => result_id;
		true => is_augmented;
	}
	else if( _s_note_value == "HALF" || _s_note_value == "H" )
		ID_HALF_NOTE => result_id;
	else if( _s_note_value == "HALF." || _s_note_value == "H." )
	{
		ID_HALF_NOTE => result_id;
		true => is_augmented;
	}
	else if( _s_note_value == "QUARTER" || _s_note_value == "Q" )	
		ID_QUARTER_NOTE => result_id;
	else if( _s_note_value == "QUARTER." || _s_note_value == "Q." )
	{
		ID_QUARTER_NOTE => result_id;
		true => is_augmented;
	}
	else if( _s_note_value == "EIGHTH" || _s_note_value == "E" )
		ID_EIGHTH_NOTE => result_id;
	else if( _s_note_value == "EIGHTH." || _s_note_value == "E." )
	{
		ID_EIGHTH_NOTE => result_id;
		true => is_augmented;
	}
	else if( _s_note_value == "SIXTEENTH" || _s_note_value == "S" )
		ID_SIXTEENTH_NOTE => result_id;
	else if( _s_note_value == "SIXTEENTH." || _s_note_value == "S." )
	{
		ID_SIXTEENTH_NOTE => result_id;
		true => is_augmented;
	}
	else if( _s_note_value == "THIRTY" || _s_note_value == "T" )
		ID_THIRTY_SECOND_NOTE => result_id;
	else if( _s_note_value == "THIRTY." || _s_note_value == "T." )
	{
		ID_THIRTY_SECOND_NOTE => result_id;
		true => is_augmented;
	}
		
	if( result_id != -1 )
	{		
		array_notes_values.cap() %=> result_id;				
		array_notes_values[result_id] => result_cur_value;
		result_cur_value * is_augmented * 0.5 +=> result_cur_value;
	}
	
	return result_cur_value;
}

/**
*	compute_notes_values : update the global array 'array_notes_values'
*/
fun void compute_notes_values( dur _quarter_note, int _max_subdivision )
{
	// Quarter - Half - Whole notes
	for( ID_WHOLE_NOTE => int i; (i < _max_subdivision) && (i < array_notes_values.cap()) ; i++ )
	{
		_quarter_note * Math.pow(2, ID_QUARTER_NOTE - i) => array_notes_values[ i ] ;
	}
}

/**
*
*/
fun void fill_array_string( string _val, string _array[] )
{	
	for( 0 => int i ; i < _array.cap() ; i++ )
		_val => _array[i] ;
}

/**
*
*/
fun void fill_array_dur( dur _val, dur _array[] )
{	
	for( 0 => int i ; i < _array.cap() ; i++ )
		_val => _array[i] ;
}

/**
*
*/
fun void fill_array_int( int _val, int _array[] )
{	
	for( 0 => int i ; i < _array.cap() ; i++ )
		_val => _array[i] ;
}

/**
*
*/
fun void cout_duration( string _prefix_msg , dur _duration )
{
	<<< ">>> " + _prefix_msg + ":" , convert_duration_to_float( _duration, 1::second ), "second" >>> ;
}

/**
*
*/
fun float convert_duration_to_float( dur _duration, dur _base_time )
{
	return _duration / _base_time ;
}
