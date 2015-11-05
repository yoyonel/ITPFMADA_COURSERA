Pan2 pan2_instrument => dac ;

-0.25 => pan2_instrument.pan;

Gain gain_instrument;

false => int use_fx_reverb;
PRCRev rev;

0.10 => float scale_gain_instrument;

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

array_notes_values[ ID_SIXTEENTH_NOTE ] => dur step_time;

16 * nb_bars_for_this_song => int nb_beats_for_this_song;

int array_int_notes[nb_beats_for_this_song];
dur array_dur_notes_values[nb_beats_for_this_song];

int id_current_sample;

1 => int nb_instruments;

int array_int_id_current_samples[nb_instruments];

int array_int_notes_instruments[nb_instruments][nb_beats_for_this_song];

dur array_dur_notes_values_instruments[nb_instruments][nb_beats_for_this_song];

0 => int start_id_insrument;
nb_instruments => int end_id_insrument;

dur array_current_note_value_instruments[nb_instruments];
int array_current_note_is_silent_instruments[nb_instruments];
int array_current_id_note_for_instruments[nb_instruments];
dur array_duration_for_next_note_for_instruments[nb_instruments];

8 => int NB_MAX_SAMPLES;

// Technical/Code score: 'Use of SndBuf'
SndBuf samples_wav_instrument[NB_MAX_SAMPLES];
//
SndBuf array_sndbuf_instruments[nb_instruments][NB_MAX_SAMPLES];

load_instruments( find_audios_path(-1) );

init_instrument( scale_gain_instrument );

// ____________________________________________________________________________________________________________________________________
// ------------------------------------------------------------------------------------------------
// ____________________________________________________________________________________________________________________________________

// Useful to control the timing of our composition
now => time time_start_composition;	

// Play the first notes (for all instruments)
// to set correctly the instruments (at the beginning)
update(step_time) ;
play_composition( step_time ) ;

while( is_end_composition() )
{
	update(step_time) ;
	play_composition(step_time) ;
}

// ____________________________________________________________________________________________________________________________________
// ------------------------------------------------------------------------------------------------
// ____________________________________________________________________________________________________________________________________



// ____________________________________________________________________________________________________________________________________
/**
*
*/
fun void init_instrument( float _scale_gain_instrument )
{
	1.0 / nb_instruments => gain_instrument.gain;
	_scale_gain_instrument * gain_instrument.gain() => gain_instrument.gain;
	
	gain_instrument => pan2_instrument;

	set_equalisation( 0 ); // normal settings
		
	if( use_fx_reverb )
	{
		0.30 => rev.mix;
		gain_instrument => rev => pan2_instrument;
	}
	
	fill_array_dur( 0::second, array_current_note_value_instruments );
	fill_array_int( false, array_current_note_is_silent_instruments );
	fill_array_int( 0, array_current_id_note_for_instruments );
	fill_array_dur( 0::second, array_duration_for_next_note_for_instruments );	

	0 => id_current_sample;
	
	[
		id_current_sample
	] @=> array_int_id_current_samples;

	[ 		
		array_int_notes
	] @=> array_int_notes_instruments;

	[
		array_dur_notes_values
	] @=> array_dur_notes_values_instruments;
	
	[ 
		samples_wav_instrument
	] @=> array_sndbuf_instruments;
}

/**
*
*/
fun void load_instruments( string _path_audio_files )
{
	_path_audio_files => string path;
	
	[ "hihat_01.wav", "hihat_02.wav" ] @=> string array_string_wav_samples[];
	
	for( 0 => int i; i < NB_MAX_SAMPLES; i++ )
	{
		samples_wav_instrument[i] => gain_instrument;		
				
		path + array_string_wav_samples[i % array_string_wav_samples.cap()] => samples_wav_instrument[i].read;
		
		samples_wav_instrument[i].samples() => samples_wav_instrument[i].pos;
	
		// Technical/Code score: 'Random Number'
		1.00  => samples_wav_instrument[i].rate; // lower rate => lower frequency
	}
	
	// --------------------------------------------------
	// 
	[
		1, 0, 1, 1, 0, 0, 0, 1,	1, 0, 0, 0,		1, 0, 1, 1, 0, 0, 0, 1,	1, 0, 1, 0,
		1, 0, 1, 1, 0, 0, 0, 1,	1, 0, 0, 0,		1, 0, 1, 1, 0, 0, 0, 1,	1, 0, 1, 0,		
		1, 0, 1, 1, 0, 0, 0, 1,	1, 0, 0, 0,		1, 0, 1, 1, 0, 0, 0, 1,	1, 0, 1, 0,
		1, 0, 1, 1, 0, 0, 0, 1,	1, 0, 0, 0,		1, 0, 1, 1, 0, 0, 0, 1,	1, 0, 1, 0,		
		
		1, 0, 1, 1, 0, 0, 0, 1,	1, 0, 0, 0,		1, 0, 1, 1, 0, 0, 0, 1,	1, 0, 1, 0,
		1, 0, 1, 1, 0, 0, 0, 1,	1, 0, 0, 0,		1, 0, 1, 1, 0, 0, 0, 1,	1, 0, 1, 0,		
		1, 0, 1, 1, 0, 0, 0, 1,	1, 0, 0, 0,		1, 0, 1, 1, 0, 0, 0, 1,	1, 0, 1, 0,
		
		1, 0, 1, 1, 0, 0, 0, 0,	0, 0, 0, 0,		0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0
	] @=> array_int_notes;
	
	fill_array_dur( decode_note_value_from_string("S"), array_dur_notes_values );
}

/**
*
*/
fun void set_equalisation( int _id_type_eq )
{
	if( _id_type_eq == 0 )
	{
		0.075 => pan2_instrument.gain;
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
fun void update( dur step_time )
{
	for( start_id_insrument => int id_instrument; id_instrument < end_id_insrument; id_instrument++ )
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
	if( array_duration_for_next_note_for_instruments[_id_instrument] <= 0::second )
	{
		// Update 'Note'
		update_current_note_for_instrument(_id_instrument);
		// Update current indice note -> next note		
		update_current_id_note_for_instrument(_id_instrument);
		// reset the position of the sample for playing
		update_position_sample_instrument(_id_instrument);		
	}
}

/**
*
*/
fun void update_position_sample_instrument( int _id_instrument )
{
	array_int_id_current_samples[_id_instrument] @=> int id_cur_sample_instrument;
	
	if( !array_current_note_is_silent_instruments[_id_instrument] )
	{
		// time to reset the sample and play it
		0 => array_sndbuf_instruments[_id_instrument][id_cur_sample_instrument].pos;
	}
	
	// allow multi-samples for the same wav without cut/crap the sound
	// change the id for sample for each 16th beat
	(array_int_id_current_samples[_id_instrument] + 1) % array_sndbuf_instruments[_id_instrument].cap() => array_int_id_current_samples[_id_instrument];
}

/**
*	Update duration counter for instrument
*/
fun void update_timers_for_instrument( int _id_instrument, dur _step_time )
{
	_step_time -=> array_duration_for_next_note_for_instruments[_id_instrument];
}

/**
*
*/
fun void update_current_note_for_instrument( int _indice_instrument )
{
	array_current_id_note_for_instruments[_indice_instrument] @=> int id_current_note;
	
	update_note_from_parameters_instrument( 
		_indice_instrument,
		id_current_note,
		array_int_notes_instruments,
		array_dur_notes_values_instruments
	) => int id_result;
	
	// update duration counter
	array_current_note_value_instruments[_indice_instrument] => array_duration_for_next_note_for_instruments[_indice_instrument];
}

/**
*
*/
fun void update_current_id_note_for_instrument( int _indice_instrument )
{	
	array_current_id_note_for_instruments[_indice_instrument]++;	
	array_int_notes_instruments[_indice_instrument].cap() %=> array_current_id_note_for_instruments[_indice_instrument]; // prevent to not go over the max indice of this array
}

/**
*	update_note_from_parameters_instrument : update 'array_current_note_value_instruments'
*/
fun int update_note_from_parameters_instrument( int _indice_instrument, int _id_current_note, int _array_notes[][], dur _array_notes_values[][] )
{
	0 => int id_result;
	
	_array_notes[_indice_instrument][_id_current_note] @=> int note;
	
	_array_notes_values[_indice_instrument][_id_current_note] @=> dur dur_note_value;
	dur_note_value @=> array_current_note_value_instruments[_indice_instrument];
		
	(note == 0) => array_current_note_is_silent_instruments[_indice_instrument] => id_result;
			
	return id_result;
}

/**
*
*/
fun int is_end_composition()
{
	return ( now - time_start_composition ) + step_time <= dur_length_composition;
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
fun string find_audios_path( int _depth_path )
{
	//
	me.dir( _depth_path ) => string root_path; // local root path, work in miniAudicle application
	//
	if( root_path == "" )
	{
		// No definition path for me.dir()
		// the user using a network connection to communicate with ChucK
		// we need a way to localise the path for audio file
		// i'm using a environment variable 'CHUCK_AUDIO_PATH' to define a local path to find this files
		Std.getenv( "CHUCK_AUDIO_PATH" ) => root_path; // using setenv variable (Windows system)
	}
	//
	root_path + "/" + "audio/" => string result_path;
    
    <<< ">>> Result path for audio files: ", result_path >>>;
	
	if( root_path == "" )
	{
		<<< "!!! You need to put this script in a 'good' folder (need to access to 'audio/') !!!" >>>;
		<<< "!!! This script will run without wav samples :'( !!!" >>>;
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
