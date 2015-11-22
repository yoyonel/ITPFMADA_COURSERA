0 => int ID_WHOLE_NOTE;
1 => int ID_HALF_NOTE;
2 => int ID_QUARTER_NOTE;
3 => int ID_EIGHTH_NOTE;
4 => int ID_SIXTEENTH_NOTE;
5 => int ID_THIRTY_SECOND_NOTE;

// 'make quarter Notes (main compositional pulse) 0.6::second in your composition'
0.75::second => dur quarter_duration;

// Length of the composition
30::second => dur dur_length_composition;

// compute the notes values using for this composition
(ID_THIRTY_SECOND_NOTE+1) => int max_subdivision_for_notes_values;
dur array_notes_values[max_subdivision_for_notes_values];
compute_notes_values( quarter_duration, max_subdivision_for_notes_values );

array_notes_values[ ID_SIXTEENTH_NOTE ] => dur step_time_for_drum;


// ------------------------------------------------------------------------------------------------
// --------------------------------------------------
// Drum
// --------------------------------------------------

16*10 => int nb_notes_for_drum;

int array_int_notes_hihat[nb_notes_for_drum];
int array_int_notes_kick[nb_notes_for_drum];
int array_int_notes_snare[nb_notes_for_drum];
int array_int_notes_tomlow[nb_notes_for_drum];

int id_current_sample_hithat_drum;
int id_current_sample_kick_drum;
int id_current_sample_snare_drum;
int id_current_sample_tomlow_drum;

4 => int nb_instruments_drum;
int array_int_id_current_samples_drum[nb_instruments_drum];
int array_int_notes_drum[nb_instruments_drum][nb_notes_for_drum];
string array_string_notes_values_drum[nb_instruments_drum][nb_notes_for_drum];

0 => int start_id_insrument_drum;
nb_instruments_drum => int end_id_insrument_drum;

dur array_current_note_value_instruments_drum[nb_instruments_drum];
int array_current_note_is_silent_instruments_drum[nb_instruments_drum];
int array_current_id_note_for_instruments_drum[nb_instruments_drum];
dur array_duration_for_next_note_for_instruments_drum[nb_instruments_drum];

Gain master_drum;
Gain master_kick, master_hihat, master_snare, master_tomlow;

0 => int ID_KICK_FOR_DRUM;
1 => int ID_HIHAT_FOR_DRUM;
2 => int ID_SNARE_FOR_DRUM;
3 => int ID_TOMLOW_FOR_DRUM;

8 => int NB_MAX_SAMPLES_FOR_DRUM;

// Technical/Code score: 'Use of SndBuf'
SndBuf kick[NB_MAX_SAMPLES_FOR_DRUM];
SndBuf hihat[NB_MAX_SAMPLES_FOR_DRUM];
SndBuf snare[NB_MAX_SAMPLES_FOR_DRUM];
SndBuf tomlow[NB_MAX_SAMPLES_FOR_DRUM];
//
SndBuf array_SndBuf_Drums[nb_instruments_drum][NB_MAX_SAMPLES_FOR_DRUM];

load_drum_instruments();

// --------------------------------------------------

Pan2 master => dac ;

// ------------------------------------------------------------------------------------------------
init_Drum( find_audios_path(), 1.0 );

// Useful to control the timing of our composition
now => time time_start_composition;	

// Play the first notes (for all instruments)
// to set correctly the instruments (at the beginning)
update_drum(step_time_for_drum) ;
play_composition(step_time_for_drum) ;

while( is_end_composition() )
{
	update_drum(step_time_for_drum) ;
	play_composition(step_time_for_drum) ;
}



// ____________________________________________________________________________________________________________________________________
fun void update_drum( dur step_time )
{
	for( start_id_insrument_drum => int id_instrument_drum; id_instrument_drum < end_id_insrument_drum; id_instrument_drum++ )
	{		
		//
		update_instrument_drum(id_instrument_drum);
		//
		update_timers_for_instrument_drum( id_instrument_drum, step_time );			
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
fun void update_instrument_drum( int _id_instrument_drum )
{
	// It's time to update note ?
	if( array_duration_for_next_note_for_instruments_drum[_id_instrument_drum] <= 0::second )
	{
		// Update 'Note'
		update_current_note_for_instrument_drum(_id_instrument_drum);
		// Update current indice note -> next note		
		update_current_id_note_for_instrument_drum(_id_instrument_drum);
		// reset the position of the sample for playing
		update_position_sample_instrument_drum(_id_instrument_drum);		
	}
}

/**
*
*/
fun void update_position_sample_instrument_drum( int _id_instrument_drum )
{
	array_int_id_current_samples_drum[_id_instrument_drum] @=> int id_cur_sample_instrument_drum;
	
	if( !array_current_note_is_silent_instruments_drum[_id_instrument_drum] )
	{
		// time to reset the sample and play it
		0 => array_SndBuf_Drums[_id_instrument_drum][id_cur_sample_instrument_drum].pos;
	}
	
	// allow multi-samples for the same wav without cut/crap the sound
	// change the id for sample for each 16th beat
	(array_int_id_current_samples_drum[_id_instrument_drum] + 1) % array_SndBuf_Drums[_id_instrument_drum].cap() => array_int_id_current_samples_drum[_id_instrument_drum];
}

/**
*	Update duration counter for instrument
*/
fun void update_timers_for_instrument_drum( int _id_instrument_drum, dur _step_time )
{
	_step_time -=> array_duration_for_next_note_for_instruments_drum[_id_instrument_drum];
}

/**
*
*/
fun void update_current_note_for_instrument_drum( int _indice_instrument_drum )
{
	array_current_id_note_for_instruments_drum[_indice_instrument_drum] @=> int id_current_note_drum;
	
	decode_note_from_parameters_instrument_drum( 
		_indice_instrument_drum,
		id_current_note_drum,
		array_int_notes_drum,
		array_string_notes_values_drum
	) => int id_result;
	
	// update duration counter
	array_current_note_value_instruments_drum[_indice_instrument_drum] => array_duration_for_next_note_for_instruments_drum[_indice_instrument_drum];
}

/**
*
*/
fun void update_current_id_note_for_instrument_drum( int _indice_instrument_drum )
{	
	array_current_id_note_for_instruments_drum[_indice_instrument_drum]++;	
	array_int_notes_drum[_indice_instrument_drum].cap() %=> array_current_id_note_for_instruments_drum[_indice_instrument_drum]; // prevent to not go over the max indice of this array
}

/**
*	decode_note_from_parameters : update 'array_current_note_value_instruments_drum'
*/
fun int decode_note_from_parameters_instrument_drum( int _indice_instrument_drum, int _id_current_note_drum, int _array_notes_drum[][], string _array_notes_values_drum[][] )
{
	0 => int id_result;
	
	_array_notes_drum[_indice_instrument_drum][_id_current_note_drum] @=> int note_drum;
	
	_array_notes_values_drum[_indice_instrument_drum][_id_current_note_drum] @=> string string_note_value_drum;
	
	decode_note_value_from_string( string_note_value_drum ) => array_current_note_value_instruments_drum[_indice_instrument_drum];
	
	(note_drum == 0) => array_current_note_is_silent_instruments_drum[_indice_instrument_drum] => id_result;
			
	return id_result;
}

/**
*
*/
fun void init_Drum( string _path_audio_files, float _scale_gain )
{
	_path_audio_files => string path;
	
	[ "hihat_01.wav", "hihat_02.wav", "hihat_03.wav", "hihat_01.wav", "hihat_02.wav", "hihat_04.wav" ] @=> string array_hihat[];
	[ "kick_04.wav", "kick_02.wav", "kick_02.wav", "kick_04.wav" ] @=> string array_kick[];
	[ "snare_01.wav", "snare_03.wav", "snare_03.wav" ] @=> string array_snare[];
	[ "kick_05.wav" ] @=> string array_tomlow[];
	
	for( 0 => int i; i < NB_MAX_SAMPLES_FOR_DRUM; i++ )
	{
		kick[i] => master_kick;
		hihat[i] => master_hihat;		
		snare[i] => master_snare;
		tomlow[i] => master_tomlow;
				
		path + array_kick[i % array_kick.cap()] => kick[i].read;
		path + array_hihat[i % array_hihat.cap()] => hihat[i].read;
		path + array_snare[i % array_snare.cap()] => snare[i].read;
		path + array_tomlow[i % array_tomlow.cap()] => tomlow[i].read;
		
		kick[i].samples()       => kick[i].pos;
		hihat[i].samples()      => hihat[i].pos;
		snare[i].samples()      => snare[i].pos;
		tomlow[i].samples()     => tomlow[i].pos;

		// Technical/Code score: 'Random Number'
		1.15 + Std.rand2f(-0.15, 0.15) => kick[i].rate;  // higher rate => higher frequency
		0.80 + Std.rand2f(-0.05, 0.05) => hihat[i].rate; // lower rate => lower frequency
		1.00 => snare[i].rate; // normal rate
		0.75 => tomlow[i].rate; // low rate
	}
	
	1.0 / nb_instruments_drum => master_drum.gain;
	_scale_gain * master_drum.gain() => master_drum.gain;

	set_equalisation_for_drum( 0 ); // normal settings
	//set_equalisation_for_drum( -1 ); // mute settings
			
	master_kick => master_drum;
	master_hihat => master_drum;	
	master_snare => master_drum;
	master_tomlow => master_drum;
		
	fill_array_dur( 0::second, array_current_note_value_instruments_drum );
	fill_array_int( false, array_current_note_is_silent_instruments_drum );
	fill_array_int( 0, array_current_id_note_for_instruments_drum );
	fill_array_dur( 0::second, array_duration_for_next_note_for_instruments_drum );	

	0 => id_current_sample_kick_drum => id_current_sample_hithat_drum => id_current_sample_snare_drum => id_current_sample_tomlow_drum;
	
	master_drum => NRev rev => master;
	0.05 => rev.mix;
}

/**
*
*/
fun void set_equalisation_for_drum( int _id_type_eq )
{
	if( _id_type_eq == 0 )
	{
		0.075 => master_hihat.gain;
		1.000 => master_kick.gain;
		0.500 => master_snare.gain;
		1.500 => master_tomlow.gain;
	}
	else if ( _id_type_eq == -1 )
	{
		0.00 => master_hihat.gain => master_kick.gain => master_snare.gain => master_tomlow.gain ;
	}
	else
	{
		1.000 => master_hihat.gain;
		1.000 => master_kick.gain;
		1.000 => master_snare.gain;
		1.000 => master_tomlow.gain;
	}
}

/**
*
*/
fun int is_end_composition()
{
	return ( now - time_start_composition ) + step_time_for_drum <= dur_length_composition;
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
fun string find_audios_path()
{
	//
	//me.dir() => string root_path; // local root path, work in miniAudicle application
	"" => string root_path;
	if( root_path == "" )
	{
		// No definition path for me.dir()
		// the user using a network connection to communicate with ChucK
		// we need a way to localise the path for audio file
		// i'm using a environment variable 'CHUCK_AUDIO_PATH' to define a local path to find this files
		//Std.getenv( "CHUCK_AUDIO_PATH" ) => root_path; // using setenv variable (Windows system)
		Std.getenv( "CHUCK_DATA_PATH" ) => root_path; // using setenv variable (Windows system)
	}
	//
	root_path + "/" + "audio/" => string result_path;
    
    <<< ">>> Result path for audio files: ", result_path >>>;
	
	if( root_path == "" )
	{
		<<< "!!! You need to put this script in a 'good' folder (need to access to 'audio/') !!!" >>>;
		<<< "!!! This script will run without Drums (track) :'( !!!" >>>;
	}
		
    return result_path;
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

fun void load_drum_instruments()
{
	// --------------------------------------------------
	// HIHAT
	[
		0, 0, 0, 0, 0, 0, 0, 1,		0, 0, 0, 0, 0, 0, 1, 1,
		0, 0, 0, 0, 0, 0, 0, 1,		0, 0, 0, 0, 0, 1, 0, 0,
		0, 0, 0, 0, 0, 0, 1, 0,		0, 0, 0, 0, 0, 0, 0, 1,
		0, 0, 0, 0, 0, 0, 0, 1,		0, 0, 0, 0, 1, 0, 0, 1,
		0, 0, 1, 0, 0, 0, 1, 0,		0, 0, 0, 0, 1, 0, 1, 0,
		0, 0, 1, 0, 0, 0, 1, 0,		0, 0, 0, 0, 1, 0, 1, 0,
		0, 0, 1, 0, 0, 0, 1, 0,		0, 0, 0, 0, 1, 0, 1, 0,
		0, 0, 1, 0, 0, 0, 1, 0,		0, 0, 0, 0, 1, 0, 1, 0,
		0, 0, 0, 0, 0, 0, 0, 0,		0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0,		0, 0, 0, 0, 0, 0, 0, 0
	] @=> array_int_notes_hihat;
	string array_string_notes_values_hihat[array_int_notes_hihat.cap()];
	fill_array_string( "S", array_string_notes_values_hihat ); // SIXTEENTH note value for every note

	// --------------------------------------------------
	// KICK
	[
		1, 0, 0, 0, 0, 0, 0, 0,		1, 0, 1, 0, 0, 0, 0, 0,
		1, 0, 1, 0, 0, 0, 0, 0,		1, 0, 0, 1, 1, 0, 0, 0,
		1, 0, 0, 0, 0, 0, 0, 1,		0, 1, 0, 0, 0, 0, 0, 0,
		1, 0, 1, 0, 0, 0, 0, 0,		1, 0, 1, 0, 1, 0, 0, 0,
		1, 0, 0, 0, 1, 0, 0, 0,		1, 0, 0, 1, 0, 1, 0, 0,
		1, 0, 0, 0, 1, 0, 0, 0,		1, 0, 0, 1, 0, 1, 0, 1,
		1, 0, 0, 0, 1, 0, 0, 0,		1, 0, 0, 1, 0, 1, 0, 0,
		1, 0, 0, 0, 1, 0, 0, 0,		1, 0, 0, 1, 0, 1, 0, 1,
		0, 0, 0, 0, 0, 0, 0, 0,		1, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0,		1, 0, 0, 0, 0, 0, 0, 0
	] @=> array_int_notes_kick;
	string array_string_notes_values_kick[array_int_notes_kick.cap()];
	fill_array_string( "S", array_string_notes_values_kick ); // SIXTEENTH note value for every note

	// --------------------------------------------------
	// SNARE
	[
		0, 0, 0, 0, 1, 0, 0, 0,		0, 0, 0, 0, 1, 0, 0, 0,
		0, 0, 0, 0, 1, 0, 0, 0,		0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 1, 0, 0, 0,		0, 0, 0, 0, 1, 0, 0, 0,
		0, 0, 0, 0, 1, 0, 0, 0,		0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 1, 0, 0, 0, 1,		0, 0, 1, 0, 0, 0, 0, 0,
		0, 0, 0, 1, 0, 0, 0, 1,		0, 0, 1, 0, 0, 0, 1, 0,
		0, 0, 0, 1, 0, 0, 0, 1,		0, 0, 1, 0, 0, 0, 0, 0,
		0, 0, 0, 1, 0, 0, 0, 1,		0, 0, 1, 0, 0, 0, 1, 0,
		0, 0, 0, 0, 0, 0, 0, 0,		0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0,		0, 0, 0, 0, 0, 0, 0, 0
	] @=> array_int_notes_snare;
	string array_string_notes_values_snare[array_int_notes_snare.cap()];
	fill_array_string( "S", array_string_notes_values_snare ); // SIXTEENTH note value for every note

	// --------------------------------------------------
	// TOM-LOW
	[
		0, 0, 0, 0, 0, 0, 0, 0,		0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0,		0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0,		0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0,		0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0,		0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0,		0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0,		0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0,		0, 0, 0, 0, 0, 0, 0, 0,
		1, 0, 0, 1, 0, 0, 1, 0,		0, 0, 0, 0, 1, 0, 1, 0,
		1, 0, 0, 1, 0, 0, 1, 0,		0, 0, 0, 0, 1, 0, 1, 0
	] @=> array_int_notes_tomlow;
	string array_string_notes_values_tomlow[array_int_notes_tomlow.cap()];
	fill_array_string( "S", array_string_notes_values_tomlow ); // SIXTEENTH note value for every note

	[ 
		id_current_sample_kick_drum,
		id_current_sample_hithat_drum,
		id_current_sample_snare_drum,
		id_current_sample_tomlow_drum
	] @=> array_int_id_current_samples_drum;

	[ 
		array_int_notes_kick,
		array_int_notes_hihat,
		array_int_notes_snare,
		array_int_notes_tomlow
	] @=> array_int_notes_drum;

	[
		array_string_notes_values_kick,
		array_string_notes_values_hihat,
		array_string_notes_values_snare,
		array_string_notes_values_tomlow
	] @=> array_string_notes_values_drum;
	
	[ 
		kick, 
		hihat, 
		snare,
		tomlow
	] @=> array_SndBuf_Drums;
}
