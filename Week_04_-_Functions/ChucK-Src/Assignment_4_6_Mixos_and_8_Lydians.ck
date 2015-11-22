// Assignment 4: Function Junction
// Composition Name: '6 Mixos and 8 Lydians'
// Author: mysterious_dude ^^
// Date: 2013 - 11 - 18

// ------------------------------------------------------------------------------------------------
// GLOBALS VARIABLES
// ------------------------------------------------------------------------------------------------

// Technical/Code score: 'Use of Panning'
Pan2 master => dac ;
1.0 => float initial_gain_composition;
initial_gain_composition => master.gain;

//
1.0 => float TONE; 
0.5 => float SEMITONE;
//
0 => int ID_WHOLE_NOTE;
1 => int ID_HALF_NOTE;
2 => int ID_QUARTER_NOTE;
3 => int ID_EIGHTH_NOTE;
4 => int ID_SIXTEENTH_NOTE;
5 => int ID_THIRTY_SECOND_NOTE;

-1 => int MIFS;

// Assigment 4: Constraints
// 'make quarter Notes (main compositional pulse) 0.6::second in your composition'
0.6::second => dur quarter_note;
// Scale: 'the Eb Mixolydian mode'
51 => int root_midi_note;	// midi(51) = 'Eb' note
// Describe the scale
[ TONE, TONE, SEMITONE, TONE, TONE, SEMITONE, TONE ] @=> float array_intervals_scale[];
// Length of the composition
30::second => dur dur_length_composition;

// compute the notes values using for this composition
(ID_THIRTY_SECOND_NOTE+1) => int max_subdivision_for_notes_values;
dur array_notes_values[max_subdivision_for_notes_values];
compute_notes_values( quarter_note, max_subdivision_for_notes_values );

// ------------------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------------------
// --------------------------------------------------
// Instrument 1 : Bass
// --------------------------------------------------
[ 
	// Intro
	"G",	"A#",	"G",	"G",	"A#",	"G",
	"F",	"C",	"F",	"F",	"C",	"F",
	"D#",	"C",	"D#",	"D#",	"C",	"D#", 
	"F",	"C",	"F",	"F",	"A#",
	// Verse
	"G",	"A",	"G",	"A",	"G",	"A",	"G",
	"F",	"C",	"F",	"C",	"F",	"C",	"F",
	"D#",	"C",	"D#",	"C",	"D#",	"C",	"D#",
	"F",	"C",	"F",	"F",	"A#",
	// Bridge
	"G",	"C",	"G",	"C",	"G",	"D#",	"G",	"D#",
	"G",	"F",	"G",	"F",	"G",	"D#",	"G",	"D#",
	"G",	"C",	"G",	"C",	"G",	"D#",	"G",	"D#",
	"G",	"F",	"G",	"F",	"G",	"D#",	"G",	"D#",
	"G",	"C",	"C",	"S",
	// Outro
	"G",	"A#",	"G",	"G",	"A#",	"G",
	"F",	"C",	"F",	"F",	"C",	"F",
	"D#",	"C",	"D#",	"D#",	"C",	"D#", 
	"F",	"C",	"F",	"S",	"S#"
	
] @=> string array_string_notes_bass_1[];

[
	// [0-22]
	"E",	"S",	"E",	"S",	"S",	"S",
	"E",	"S",	"E",	"S",	"S",	"S",
	"E",	"S",	"E",	"S",	"S",	"S",
	"E",	"S",	"E",	"S",	"E",
	// [23-49]
	"E",	"S",	"S",	"S",	"S",	"S",	"S",
	"E",	"S",	"S",	"S",	"S",	"S",	"S",
	"E",	"S",	"S",	"S",	"S",	"S",	"S",
	"E",	"S",	"S",	"E",	"E",
	// [49-85]
	"S",	"S",	"S",	"S",	"S",	"S",	"S",	"S",
	"S",	"S",	"S",	"S",	"S",	"S",	"S",	"S",
	"S",	"S",	"S",	"S",	"S",	"S",	"S",	"S",
	"S",	"S",	"S",	"S",	"S",	"S",	"S",	"S",
	"S",	"E",	"Q",	"S",
	// 
	"E",	"S",	"E",	"S",	"S",	"S",
	"E",	"S",	"E",	"S",	"S",	"S",
	"E",	"S",	"E",	"S",	"S",	"S",
	"E",	"S",	"S",	"S",	"S"	
] @=> string array_string_notes_values_bass_1[];
set_all_augmented_in_array_note_value(array_string_notes_values_bass_1);

int array_int_octaves_bass_1[array_string_notes_bass_1.cap()];
3 => int root_octave;
fill_array_int( root_octave, array_int_octaves_bass_1 ) ;
update_array_octaves( ["C"], root_octave+1, 0, array_string_notes_bass_1.cap(), array_string_notes_bass_1, array_int_octaves_bass_1 );
update_array_octaves( ["D#", "F"], root_octave+1, 49, 85, array_string_notes_bass_1, array_int_octaves_bass_1 );

// --------------------------------------------------

// --------------------------------------------------
// Instrument 2 : Bass
// --------------------------------------------------
[ 
	// [ 0 - 25 ]
	"G",	"G",	"G",	"S",	"G",	"G",	"G",
	"F",	"F",	"F",	"S",	"F",	"S",	"F",
	"D#",	"D#",	"D#",	"S",	"D#",	"D#",	"D#",
	"F",	"S",	"F",	"G#",	"F"
	, // Verse [ 25 - 54 ]
	"G",	"G",	"S",	"F",	"G",	"G",	"S",	"G",
	"F",	"F",	"S",	"D#",	"F",	"F",	"S",	"F",
	"D#",	"D#",	"S",	"D#",	"D#",	"D#",	"D#",	"D#",
	"F",	"F",	"F",	"G#",	"F"
	, // Bridge [ 54 - 90 ]
	"G",	"S",	"S",	"S",	"A",	"S",	"S",	"S",
	"A#",	"S",	"S",	"S",	"A",	"S",	"S",	"S",
	"G",	"S",	"S",	"S",	"A",	"S",	"S",	"S",
	"A#",	"S",	"S",	"S",	"A",	"S",	"S",	"S",
	"F",	"F",	"F",	"S"
	, // Outro [ 90 - 96 ]
	"G", 	"F",
	"D#",	"F",	"S",	"S"
] @=> string array_string_notes_bass_2[];

[
	"S",	"E",	"S",	"S",	"S",	"S",	"S",
	"S",	"E",	"S",	"S",	"S",	"S",	"S",
	"S",	"E",	"S",	"S",	"S",	"S",	"S",
	"S",	"E",	"S",	"E",	"E"
	,
	"S",	"S",	"S",	"S",	"S",	"S",	"S",	"S",
	"S",	"S",	"S",	"S",	"S",	"S",	"S",	"S",
	"S",	"S",	"S",	"S",	"S",	"S",	"S",	"S",
	"E",	"S",	"S",	"E",	"E"
	,
	"S",	"S",	"S",	"S",	"S",	"S",	"S",	"S",
	"S",	"S",	"S",	"S",	"S",	"S",	"S",	"S",
	"S",	"S",	"S",	"S",	"S",	"S",	"S",	"S",
	"S",	"S",	"S",	"S",	"S",	"S",	"S",	"S",
	"S",	"E",	"Q",	"S"
	, // Outro
	"H", 	"H",
	"H",	"S",	"Q",	"S"
] @=> string array_string_notes_values_bass_2[];

set_all_augmented_in_array_note_value(array_string_notes_values_bass_2);

int array_int_octaves_bass_2[array_string_notes_bass_2.cap()];
fill_array_int( root_octave, array_int_octaves_bass_2 ) ;

// --------------------------------------------------

// --------------------------------------------------
// Instrument 3-a : Bass
// --------------------------------------------------
[ 
	// Intro [ 0 - 25 ]
	"G",	"S",	"G",	"S",	"S",	"G",	"G",
	"F",	"S",	"F",	"S",	"S",	"F",	"F",
	"D#",	"S",	"D#",	"S",	"S",	"D#",	"D#",
	"F",	"S",	"F",	"S",	"F",	"S",	"F",	"S"	
	, // Verse [ 25 - 54 ]
	"G",	"S",	"G",	"S",	"G",	"G",	"G",
	"F",	"S",	"F",	"F",	"F",	"F",	"F",
	"D#",	"S",	"D#",	"S",	"D#",	"D#",	"D#",
	"F",	"S",	"F",	"F",	"F",	"S",	"F",	"F"
	, // Bridge [ 54 - 90 ]	
	"G",	"S",	"G",	"S",	"A#",	"S",	"A#",	"S",
	"C",	"S",	"C",	"S",	"A#",	"S",	"A#",	"S",
	"G",	"S",	"G",	"S",	"A#",	"S",	"A#",	"S",
	"C",	"S",	"C",	"S",	"A#",	"S",	"A#",	"S",
	"S",	"F",	"F",	"S"	
	, // Outro [ 90 - 96 ]
	"S",	"S",	"S",	"S"	,	"S",	"S"
] @=> string array_string_notes_bass_3_a[];

[
	"S",	"S",	"S",	"S",	"S",	"E",	"S",
	"S",	"S",	"S",	"S",	"S",	"E",	"S",
	"S",	"S",	"S",	"S",	"S",	"E",	"S",
	"S",	"S",	"S",	"S",	"S",	"S",	"S",	"S"	
	,
	"S",	"S",	"S",	"S",	"S",	"E",	"S",
	"S",	"S",	"S",	"S",	"S",	"E",	"S",
	"S",	"S",	"S",	"S",	"S",	"E",	"S",
	"S",	"S",	"S",	"S",	"S",	"S",	"S",	"S"
	,
	"S",	"S",	"S",	"S",	"S",	"S",	"S",	"S",
	"S",	"S",	"S",	"S",	"S",	"S",	"S",	"S",
	"S",	"S",	"S",	"S",	"S",	"S",	"S",	"S",
	"S",	"S",	"S",	"S",	"S",	"S",	"S",	"S",
	"S",	"E",	"Q",	"S"
	, // Outro
	"Q",	"Q",	"Q",	"Q"	,	"Q",	"Q"
] @=> string array_string_notes_values_bass_3_a[];

set_all_augmented_in_array_note_value(array_string_notes_values_bass_3_a);

int array_int_octaves_bass_3_a[array_string_notes_bass_3_a.cap()];
fill_array_int( root_octave+1, array_int_octaves_bass_3_a ) ;

// --------------------------------------------------

// --------------------------------------------------
// Instrument 3-b : Bass
// --------------------------------------------------
[ 
	// Intro [ 0 - 25 ]
	"A#",	"S",	"A#",	"S",	"S",	"A#",	"A#",
	"C",	"S",	"C",	"S",	"S",	"C",	"C",
	"C",	"S",	"C",	"S",	"S",	"C",	"C",
	"C",	"S",	"C",	"S",	"A#",	"S",	"A#",	"S"	
	, // Verse [ 25 - 54 ]
	"A#",	"S",	"A#",	"S",	"A#",	"A#",	"A#",
	"C",	"S",	"C",	"C",	"C",	"C",	"C",
	"C",	"S",	"C",	"S",	"C",	"C",	"C",
	"C",	"S",	"C",	"A#",	"A#",	"S",	"A#",	"A#"	
	, // Bridge [ 54 - 90 ]	
	"C",	"S",	"C",	"S",	"D#",	"S",	"D#",	"S",
	"F",	"S",	"F",	"S",	"D#",	"S",	"D#",	"S",
	"C",	"S",	"C",	"S",	"D#",	"S",	"D#",	"S",
	"F",	"S",	"F",	"S",	"D#",	"S",	"D#",	"S",
	"A#",	"C",	"C",	"S"	
	, // Outro [ 90 - 96 ]
	"S",	"S",	"S",	"S"	,	"S",	"S"
] @=> string array_string_notes_bass_3_b[];

[
	"S",	"S",	"S",	"S",	"S",	"E",	"S",
	"S",	"S",	"S",	"S",	"S",	"E",	"S",
	"S",	"S",	"S",	"S",	"S",	"E",	"S",
	"S",	"S",	"S",	"S",	"S",	"S",	"S",	"S"	
	,
	"S",	"S",	"S",	"S",	"S",	"E",	"S",
	"S",	"S",	"S",	"S",	"S",	"E",	"S",
	"S",	"S",	"S",	"S",	"S",	"E",	"S",
	"S",	"S",	"S",	"S",	"S",	"S",	"S",	"S"
	,
	"S",	"S",	"S",	"S",	"S",	"S",	"S",	"S",
	"S",	"S",	"S",	"S",	"S",	"S",	"S",	"S",
	"S",	"S",	"S",	"S",	"S",	"S",	"S",	"S",
	"S",	"S",	"S",	"S",	"S",	"S",	"S",	"S",
	"S",	"E",	"Q",	"S"
	, // Outro
	"Q",	"Q",	"Q",	"Q"	,	"Q",	"Q"
] @=> string array_string_notes_values_bass_3_b[];

set_all_augmented_in_array_note_value(array_string_notes_values_bass_3_b);

int array_int_octaves_bass_3_b[array_string_notes_bass_3_b.cap()];
fill_array_int( root_octave+1, array_int_octaves_bass_3_b ) ;

// --------------------------------------------------

// --------------------------------------------------
// Arrays of Instruments
// --------------------------------------------------
[ 
	array_string_notes_bass_1, 
	array_string_notes_bass_2, 
	array_string_notes_bass_3_a,
	array_string_notes_bass_3_b
] @=> string array_string_notes_instruments[][];
[ 
	array_string_notes_values_bass_1, 
	array_string_notes_values_bass_2, 
	array_string_notes_values_bass_3_a,
	array_string_notes_values_bass_3_b
] @=> string array_string_notes_values_instruments[][];
[ 
	array_int_octaves_bass_1, 
	array_int_octaves_bass_2, 
	array_int_octaves_bass_3_a,
	array_int_octaves_bass_3_b
] @=> int array_int_octaves_instruments[][];

array_string_notes_instruments.cap() => int nb_instruments;
0 => int start_id_insrument;
nb_instruments => int end_id_insrument;

dur array_current_note_value_instruments[nb_instruments];
int array_current_midi_note_instruments[nb_instruments];
int array_current_note_is_silent[nb_instruments];
int array_current_id_note_for_instrus[nb_instruments];
dur array_duration_for_next_note_for_instrus[nb_instruments];

//
float array_fx_ratio_over_a_note_for_instrus[nb_instruments];
//
float array_fx_fade_in_begin_time[nb_instruments];
float array_fx_fade_in_end_time[nb_instruments];
float array_fx_fade_in_ratio[nb_instruments];
//
float array_fx_fade_out_begin_time[nb_instruments];
float array_fx_fade_out_end_time[nb_instruments];
float array_fx_fade_out_ratio[nb_instruments];
//

float fx_ratio_over_the_composition;
//
float fx_fade_in_composition_begin;
float fx_fade_in_composition_end;
float fx_fade_in_composition_ratio;
//
float fx_fade_out_composition_begin;
float fx_fade_out_composition_end;
float fx_fade_out_composition_ratio;

float NB_SAMPLES_FX_FOR_MINIMAL_NOTE_VALUE;
dur min_step_time_fx;

// ------------------------------------------------------------------------------------------------

// Technical/Code score: 'Use of Oscillator'
SinOsc osc_instruments[nb_instruments];
float gain_for_instrus[nb_instruments];

Pan2 pan2_instruments[nb_instruments];

// ------------------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------------------
// --------------------------------------------------
// Drum
// --------------------------------------------------

// --------------------------------------------------
// HIHAT
[
	// Intro
	1, 1, 1, 1, 1, 1, 1, 1, 	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 	1, 1, 1, 1, 1, 1, 1, 1
	, // Verse
	1, 1, 1, 1, 1, 1, 1, 1, 	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 	1, 1, 1, 1, 1, 1, 1, 1
	, /// Bridge
	1, 1, 1, 1, 1, 1, 1, 1, 	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 	1, 1, 1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 0, 0, 0, 0
	, // Outro
	1, 1, 1, 1, 1, 1, 1, 1, 	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 	1, 1, 1, 1, 0, 0, 0, 0
] @=> int array_int_notes_hihat[];
string array_string_notes_values_hihat[array_int_notes_hihat.cap()];
fill_array_string( "S", array_string_notes_values_hihat ); // SIXTEENTH note value for every note
set_all_augmented_in_array_note_value(array_string_notes_values_hihat); // add '.' to every string note value

// --------------------------------------------------
// KICK
[
	// Intro
	1, 0, 0, 0, 0, 1, 0, 0, 	1, 0, 0, 0, 0, 1, 0, 0,
	1, 0, 0, 0, 0, 1, 0, 0, 	1, 0, 0, 0, 0, 1, 1, 0
	, // Verse
	1, 0, 0, 0, 0, 1, 0, 0, 	1, 0, 0, 1, 0, 1, 1, 0,
	1, 0, 0, 0, 1, 0, 1, 0, 	1, 0, 0, 0, 0, 1, 1, 0
	, /// Bridge
	1, 0, 1, 0, 1, 0, 1, 0, 	1, 0, 1, 0, 1, 0, 1, 0,
	1, 0, 1, 0, 1, 0, 1, 0, 	1, 0, 1, 0, 1, 0, 1, 0,
	1, 1, 0, 0, 0, 0, 1, 1
	, // Outro
	1, 0, 0, 0, 0, 1, 0, 0, 	1, 0, 0, 0, 0, 1, 0, 0,
	1, 0, 0, 0, 0, 1, 0, 0, 	1, 0, 0, 0, 0, 0, 0, 0
] @=> int array_int_notes_kick[];
string array_string_notes_values_kick[array_int_notes_kick.cap()];
fill_array_string( "S", array_string_notes_values_kick ); // SIXTEENTH note value for every note
set_all_augmented_in_array_note_value(array_string_notes_values_kick); // add '.' to every string note value

// --------------------------------------------------
// SNARE
[
	// Intro
	0, 0, 1, 0, 0, 0, 1, 0, 	0, 0, 1, 0, 0, 0, 1, 0,
	0, 0, 1, 0, 0, 0, 1, 0, 	0, 0, 1, 0, 0, 0, 1, 0
	, // Verse
	0, 0, 1, 0, 0, 0, 1, 0, 	0, 0, 1, 0, 0, 0, 1, 0,
	0, 0, 1, 0, 0, 1, 0, 0, 	1, 0, 1, 1, 1, 0, 1, 0
	, /// Bridge
	0, 1, 0, 1, 0, 0, 0, 0, 	0, 1, 0, 0, 0, 1, 0, 0,
	0, 1, 0, 1, 0, 0, 0, 0, 	0, 1, 0, 0, 0, 1, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0
	, // Outro
	0, 0, 1, 0, 0, 0, 1, 0, 	0, 0, 1, 0, 0, 0, 1, 0,
	0, 0, 1, 0, 0, 0, 1, 0, 	0, 0, 1, 0, 0, 0, 0, 0
] @=> int array_int_notes_snare[];
string array_string_notes_values_snare[array_int_notes_snare.cap()];
fill_array_string( "S", array_string_notes_values_snare ); // SIXTEENTH note value for every note
set_all_augmented_in_array_note_value(array_string_notes_values_snare); // add '.' to every string note value

// --------------------------------------------------

int id_current_sample_hithat_drum;
int id_current_sample_kick_drum;
int id_current_sample_snare_drum;

[ 
	id_current_sample_kick_drum,
	id_current_sample_hithat_drum,
	id_current_sample_snare_drum
] @=> int array_int_id_current_samples_drum[];

[ 
	array_int_notes_kick,
	array_int_notes_hihat,
	array_int_notes_snare
] @=> int array_int_notes_drum[][];

[
	array_string_notes_values_kick,
	array_string_notes_values_hihat,
	array_string_notes_values_snare
] @=> string array_string_notes_values_drum[][];

array_int_notes_drum.cap() => int nb_instruments_drum;
0 => int start_id_insrument_drum;
3 => int end_id_insrument_drum;

dur array_current_note_value_instruments_drum[nb_instruments_drum];
int array_current_note_is_silent_instruments_drum[nb_instruments_drum];
int array_current_id_note_for_instruments_drum[nb_instruments_drum];
dur array_duration_for_next_note_for_instruments_drum[nb_instruments_drum];

// --------------------------------------------------

Gain master_drum;
//
Gain master_kick, master_hihat, master_snare;

0 => int ID_KICK_FOR_DRUM;
1 => int ID_HIHAT_FOR_DRUM;
2 => int ID_SNARE_FOR_DRUM;

8 => int NB_MAX_SAMPLES_FOR_DRUM;

// Technical/Code score: 'Use of SndBuf'
SndBuf kick[NB_MAX_SAMPLES_FOR_DRUM];
SndBuf hihat[NB_MAX_SAMPLES_FOR_DRUM];
SndBuf snare[NB_MAX_SAMPLES_FOR_DRUM];
//
[ 
	kick, 
	hihat, 
	snare
] @=> SndBuf array_SndBuf_Drums[][];

// ------------------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------------------
// MAIN PROGRAM
// ------------------------------------------------------------------------------------------------

// // uncomment this lines (below) 
// // if you want to save the result of this composition in a wav file (can be useful to study the wav form of my sound)
//WvOut2 wav_out2;
//write_audio_in_wav( wav_out2, "test_assigment_4" );

// INIT
// Iniialisation of instruments: bass guitars
init_Instruments();
//  Inialisation of FX (fades in/out)
init_FX( 512*4 ); // set the quality of the rendering FX (audio)
//  Iniialisation of Drum
//init_Drum( find_audios_path(), 1.0/3.0 );
init_Drum( find_audios_path(), 3.0/4.0 );

// Useful to control the timing of our composition
now => time time_start_composition;	

min_step_time_fx => dur min_step_time;

// Play the first notes (for all instruments)
// to set correctly the instruments (at the beginning)
update_instruments(min_step_time) ;
update_drum(min_step_time) ;
play_composition(min_step_time) ;

// MAIN loop
while( is_end_composition() )
{
	// compute the minimal step time needed to respect the update of our all instruments (guitar-bass + drums)
	// That's compute 'dt' = 'differential timing'
	compute_minimal_step_time_for_instruments() => dur min_step_time ;
	
	// Update instruments timers with 'dt'
	update_instruments(min_step_time) ;
		
	// Update drum timers with 'dt'
	update_drum(min_step_time) ;
	
	// Update the FX for our composition
	// this update depend of the timing in the track
	update_track_fx();
	
	// Play 
	play_composition(min_step_time) ;
}

cout_length_composition();

// // uncomment this line to save the result in wav file (can work without the line)
//end_write_audio_in_wav( wav_out2 );

// ------------------------------------------------------------------------------------------------



// ------------------------------------------------------------------------------------------------
// METHODS/FUNCTIONS DEFINITIONS
// ------------------------------------------------------------------------------------------------

/**
*
*/
fun void init_Instruments()
{
	// reset/init arrays
	fill_array_dur( 0::second, array_current_note_value_instruments );
	fill_array_int( 0, array_current_midi_note_instruments );
	fill_array_int( false, array_current_note_is_silent );
	fill_array_int( 0, array_current_id_note_for_instrus );
	fill_array_dur( 0::second, array_duration_for_next_note_for_instrus );	
	
	// init panoramics attributes for instruments (2D spatialization of the sound)
	init_pan2_for_instruments( pan2_instruments, master );
	// init oscillators (sinus) for instruments
	init_oscillators_for_instruments( pan2_instruments );
}

/**
*
*/
fun void init_FX( float _NB_SAMPLES )
{
	//	
	setup_fx_fades_for_instrument( 0, 0 );
	setup_fx_fades_for_instrument( 1, 1 );
	setup_fx_fades_for_instrument( 2, 1 );
	setup_fx_fades_for_instrument( 3, 1 );
	
	//
	0.0 => fx_ratio_over_the_composition;
	//
	0.00 => fx_fade_in_composition_begin;
	(1::second/dur_length_composition) => fx_fade_in_composition_end; // 2 second for fade-in opening composition
	1.00 => fx_fade_in_composition_ratio;
	//
	(1.00 - (2::second/dur_length_composition)) => fx_fade_out_composition_begin; // 2 second before the end of the composition
	1.00 => fx_fade_out_composition_end; // 2 second for fade-in opening composition
	0.00 => fx_fade_out_composition_ratio;
	
	//
	_NB_SAMPLES => NB_SAMPLES_FX_FOR_MINIMAL_NOTE_VALUE;
	compute_min_step_time_for_fx(NB_SAMPLES_FX_FOR_MINIMAL_NOTE_VALUE) => min_step_time_fx;
}

/**
*
*/
fun void setup_fx_fades_for_instrument( int _id_instru, int _id_type_instru )
{
	if( _id_type_instru == 1 )
	{
		// ~ Flute style
		//<<< "fx : Flute style" >>>;
		// Fade-In
		0.00 => array_fx_fade_in_begin_time[_id_instru];
		3.0/4.0 => array_fx_fade_in_end_time[_id_instru];
		1.00 => array_fx_fade_in_ratio[_id_instru];
		// Fade-Out
		9.0/10.0 => array_fx_fade_out_begin_time[_id_instru];
		1.00 => array_fx_fade_out_end_time[_id_instru];
		0.00 => array_fx_fade_out_ratio[_id_instru];
	}
	else if( _id_type_instru == 2 )
	{
		// ~ Stacato
		//<<< "fx : Stacato style" >>>;
		// Fade-In
		0.00 => array_fx_fade_in_begin_time[_id_instru];
		5.0/100.0 => array_fx_fade_in_end_time[_id_instru];
		1.00 => array_fx_fade_in_ratio[_id_instru];
		// Fade-Out
		50.0/100.0 => array_fx_fade_out_begin_time[_id_instru];
		2.0/3.0 => array_fx_fade_out_end_time[_id_instru];
		0.00 => array_fx_fade_out_ratio[_id_instru];
	}
	else if( _id_type_instru == -1 )
	{
		//<<< "fx : mute style" >>>;
		// Fade-In
		0.00 => array_fx_fade_in_begin_time[_id_instru];
		0.00 => array_fx_fade_in_end_time[_id_instru];
		1.00 => array_fx_fade_in_ratio[_id_instru];
		// Fade-Out
		0.00 => array_fx_fade_out_begin_time[_id_instru];
		0.00 => array_fx_fade_out_end_time[_id_instru];
		0.00 => array_fx_fade_out_ratio[_id_instru];
	}
	else	// == 0 or not defined
	{
		//<<< "fx : normal style" >>>;
		// Fade-In
		0.00 => array_fx_fade_in_begin_time[_id_instru];
		5.0/100.0 => array_fx_fade_in_end_time[_id_instru];
		1.00 => array_fx_fade_in_ratio[_id_instru];
		// Fade-Out
		2.0/3.0 => array_fx_fade_out_begin_time[_id_instru];
		1.00 => array_fx_fade_out_end_time[_id_instru];
		0.00 => array_fx_fade_out_ratio[_id_instru];
	}
}

/**
*
*/
fun dur compute_min_step_time_for_fx( float _NB_SAMPLES )
{
	return array_notes_values[array_notes_values.cap()-1] / _NB_SAMPLES;
}

/**
*
*/
fun void init_pan2_for_instruments( Pan2 _masters[], Pan2 _master )
{
	// connect pan instruments to the pan master (connected to dac)
	for( start_id_insrument => int id_instru; id_instru < end_id_insrument; id_instru++ )			
		_masters[id_instru] => _master;
	
	// EQualisation for instruments (bass-guitar)
	// add some spatialisation to the sound
	// try to balance low/high frequencies in 2D spectrum
	-0.33 => _masters[0].pan; // bass 1
	 0.00 => _masters[1].pan; // bass 2 
	 0.15 => _masters[2].pan; // bass 3 - a (high notes for chords)
	-0.15 => _masters[3].pan; // bass 3 - b ("low" notes for chords)
}

/**
*
*/
fun void init_oscillators_for_instruments( Pan2 _masters[] )
{
	1.0 / nb_instruments => float initial_gain_for_instrus; 
	0.50 *=> initial_gain_for_instrus;
	
	for( start_id_insrument => int id_instru; id_instru < end_id_insrument; id_instru++ )
	{
		osc_instruments[id_instru] => _masters[id_instru] ; //
		initial_gain_for_instrus => gain_for_instrus[id_instru] => osc_instruments[id_instru].gain ;
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
fun void update_instruments( dur step_time )
{
	for( start_id_insrument => int id_instru; id_instru < end_id_insrument; id_instru++ )
	{
		//
		update_instrument(id_instru);
		//
		update_fx_instrument( id_instru ) ;
		//
		update_gain_for_instru_sinosc( id_instru, osc_instruments[id_instru] );
		//
		update_timers_for_instrument( id_instru, step_time );
	}
}

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
fun dur compute_minimal_step_time_for_instruments()
{
	min_step_time_fx => dur step_time; // first step time equal to our min sub step time
	dur min_step_time;
	
	// Search the minimal duration for all instruments
	for( start_id_insrument => int id_instru; id_instru < end_id_insrument; id_instru++ )
	{
		// if the duration is not 0 (end of the current note for this instrument)
		if( array_duration_for_next_note_for_instrus[id_instru] != 0::second )
			// update the minimal step time
			min_dur( min_step_time, array_duration_for_next_note_for_instrus[id_instru] - step_time ) => min_step_time;
	}

	// if min_step_time is negativ, 1 instrument (at least) 'need' a step time below our minimal step time (fx step time)
	if( min_step_time < (0.0::second ) )
	{
		min_step_time +=> step_time;
	}
	
	return step_time;
}

/**
*
*/
fun dur min_dur( dur _dur_1, dur _dur_2 )
{
	if( _dur_1 < _dur_2 )
		return _dur_1;
	else
		return _dur_2;
}

/**
*
*/
fun int is_instrument_on_fx_time_zone( int _id_instru )
{
	return is_instrument_on_fx_fade_in_time_zone(_id_instru) || is_instrument_on_fx_fade_out_time_zone(_id_instru) ;
}

/**
*
*/
fun int is_instrument_on_fx_fade_in_time_zone( int _id_instru )
{
	return array_fx_fade_in_ratio[_id_instru] != 1.0;
}

/**
*
*/
fun int is_instrument_on_fx_fade_out_time_zone( int _id_instru )
{
	return array_fx_fade_out_ratio[_id_instru] != 0.0;
}

/**
*
*/
fun void update_instrument( int _id_instru )
{
	// It's time to update note ?
	if( array_duration_for_next_note_for_instrus[_id_instru] <= 0::second )
	{
		// Update Note
		update_current_note_for_instru(_id_instru);
		// Update current indice note -> next note		
		update_current_id_note_for_instru(_id_instru);
		// Update Frequency
		update_frequency_for_instru_sinosc( _id_instru, osc_instruments[_id_instru] );
	}
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
*
*/
fun void update_fx_instrument( int _id_instru )
{
	//   0% at the start (ratio == 1.0)
	// 100% at the end (ratio == 0.0)
	1.0 - array_duration_for_next_note_for_instrus[_id_instru] / array_current_note_value_instruments[_id_instru] => array_fx_ratio_over_a_note_for_instrus[_id_instru];	
	
	update_fx_fade_in_instrument( _id_instru );
	update_fx_fade_out_instrument( _id_instru );
}

/**
*
*/
fun void update_track_fx( )
{
	(now - time_start_composition) / (dur_length_composition) => fx_ratio_over_the_composition;
	
	update_fx_fade_in_composition();
	update_fx_fade_out_composition();
	
	// apply fade-in/out on composition
	initial_gain_composition => float gain_composition;
	
	fx_fade_in_composition_ratio *=> gain_composition;
	
	(1.00 - fx_fade_out_composition_ratio) *=> gain_composition;
	
	gain_composition => master.gain;
}

/**
*
*/
fun void update_fx_fade_in_instrument( int _id_instru )
{
	(array_fx_ratio_over_a_note_for_instrus[_id_instru] - array_fx_fade_in_begin_time[_id_instru]) / (array_fx_fade_in_end_time[_id_instru] - array_fx_fade_in_begin_time[_id_instru]) => array_fx_fade_in_ratio[_id_instru];
	Math.max( 0.0, Math.min( 1.0, array_fx_fade_in_ratio[_id_instru] ) ) => array_fx_fade_in_ratio[_id_instru];
}

/**
*
*/
fun void update_fx_fade_out_instrument( int _id_instru )
{
	(array_fx_ratio_over_a_note_for_instrus[_id_instru] - array_fx_fade_out_begin_time[_id_instru]) / (array_fx_fade_out_end_time[_id_instru] - array_fx_fade_out_begin_time[_id_instru]) => array_fx_fade_out_ratio[_id_instru];
	Math.min( 1.0, Math.max( 0.0, array_fx_fade_out_ratio[_id_instru] ) ) => array_fx_fade_out_ratio[_id_instru];
}

/**
*
*/
fun void update_fx_fade_in_composition()
{
	(fx_ratio_over_the_composition - fx_fade_in_composition_begin) / (fx_fade_in_composition_end - fx_fade_in_composition_begin) => fx_fade_in_composition_ratio;
	Math.max( 0.0, Math.min( 1.0, fx_fade_in_composition_ratio ) ) => fx_fade_in_composition_ratio;
}

/**
*
*/
fun void update_fx_fade_out_composition()
{
	(fx_ratio_over_the_composition - fx_fade_out_composition_begin) / (fx_fade_out_composition_end - fx_fade_out_composition_begin) => fx_fade_out_composition_ratio;
	Math.max( 0.0, Math.min( 1.0, fx_fade_out_composition_ratio ) ) => fx_fade_out_composition_ratio;
}

/**
*	Update duration counter for instrument
*/
fun void update_timers_for_instrument( int _id_instru, dur _step_time )
{
	_step_time -=> array_duration_for_next_note_for_instrus[_id_instru];
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
fun int decode_note_from_string( string _s_note )
{
	-1 => int result_midi_note;
	
	// C4 major scale : 1t 1t 1/2t 1t 1t 1t 1/2t
	if( _s_note == "C" || _s_note == "B#" )
		48 => result_midi_note;
	else if( _s_note == "C#" || _s_note == "Db" )
		49 => result_midi_note;
	else if( _s_note == "D" )
		50 => result_midi_note;
	else if( _s_note == "D#" || _s_note == "Eb" )
		51 => result_midi_note;
	else if( _s_note == "E" || _s_note == "Fb" )
		52 => result_midi_note;
	else if( _s_note == "F" || _s_note == "E#" )
		53 => result_midi_note;
	else if( _s_note == "F#" || _s_note == "Gb" )
		54 => result_midi_note;
	else if( _s_note == "G" )
		55 => result_midi_note;
	else if( _s_note == "G#" || _s_note == "Ab")
		56 => result_midi_note;
	else if( _s_note == "A" )
		57 => result_midi_note;
	else if( _s_note == "A#" || _s_note == "Bb" )
		58 => result_midi_note;
	else if( _s_note == "B" || _s_note == "Cb" )
		59 => result_midi_note;
	else if( _s_note == "S" || _s_note == "SILENT" )
		MIFS => result_midi_note;
		
	return result_midi_note;
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
fun void update_frequency_for_instru_sinosc( int _indice_instru, SinOsc _osc )
{
	Std.mtof( array_current_midi_note_instruments[_indice_instru] ) => _osc.freq ;
}

/**
*
*/
fun void update_gain_for_instru_sinosc( int _indice_instru, SinOsc _osc )
{	
	gain_for_instrus[_indice_instru] => float gain_instru;
	
	!array_current_note_is_silent[_indice_instru] *=> gain_instru;
	array_fx_fade_in_ratio[_indice_instru] *=> gain_instru;
	1.0 - array_fx_fade_out_ratio[_indice_instru] *=> gain_instru;
	
	gain_instru => _osc.gain ;
}

/**
*
*/
fun void update_gain_for_instrument_drum( int _indice_instrument_drum )
{
}

/**
*
*/
fun void update_current_note_for_instru( int _indice_instru )
{
	array_current_id_note_for_instrus[_indice_instru] @=> int id_current_note;
	
	decode_note_from_parameters_instrument( 
		_indice_instru,
		id_current_note,
		array_string_notes_instruments, 
		array_string_notes_values_instruments, 
		array_int_octaves_instruments
	) => int id_result;
	
	// update duration counter
	array_current_note_value_instruments[_indice_instru] => array_duration_for_next_note_for_instrus[_indice_instru];
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
fun void update_current_id_note_for_instru( int _indice_instru )
{
	array_current_id_note_for_instrus[_indice_instru]++;
	
	array_string_notes_instruments[_indice_instru].cap() %=> array_current_id_note_for_instrus[_indice_instru]; // prevent to not go over the max indice of this array
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
* decode_note_from_parameters : update 'cur_midi_note' and 'cur_note_value'
*/
fun int decode_note_from_parameters_instrument( int _indice_instru, int _id_current_note, string _array_notes[][], string _array_notes_values[][], int _array_octavs[][] )
{
	0 => int id_result;
	
	_array_notes[_indice_instru][_id_current_note] @=> string string_note;
	_array_notes_values[_indice_instru][_id_current_note] @=> string string_note_value;
	_array_octavs[_indice_instru][_id_current_note] @=> int _octav;
		
	decode_note_value_from_string( string_note_value ) => array_current_note_value_instruments[_indice_instru];
	decode_note_from_string( string_note ) => array_current_midi_note_instruments[_indice_instru];	
	array_current_midi_note_instruments[_indice_instru] == MIFS => array_current_note_is_silent[_indice_instru];
	
	if( !array_current_note_is_silent[_indice_instru] )
	{
		(_octav - 4 ) * (7 * 2) +=> array_current_midi_note_instruments[_indice_instru];
		1 => id_result;
	}
	else
	{
		0 => id_result;
	}
			
	return id_result;
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
fun float convert_duration_to_float( dur _duration, dur _base_time )
{
	return _duration / _base_time ;
}

/**
*
*/
fun void cout_duration( string _prefix_msg , dur _duration )
{
	<<< ">>> " + _prefix_msg + ":" , convert_duration_to_float( _duration, 1::second ), "second" >>> ;
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
fun void cout_notes_values( int _max_subdivision )
{
	// Quarter - Half - Whole notes
	for( ID_WHOLE_NOTE => int i; (i < _max_subdivision) && (i < array_notes_values.cap()) ; i++ )
	{
		cout_duration( "Duration", array_notes_values[ i ] );
	}
}

/**
*
*/
fun void cout_var_f( string _var, float var )
{
	<<< ">>> " +_var + ":", var >>>;
}

/**
*
*/
fun void cout_var_i( string _var, int var )
{
	<<< ">>> " +_var + ":", var >>>;
}

/**
*
*/
fun int compute_midi_note_from_degree_on_scale( int _degree, int _root_midi_note, float _array_intervals_scale[] )
{
	int result_midi_note;
	float offset;
	
	Math.trunc( _degree / (_array_intervals_scale.cap()+1) ) => float integer_part;
	
	(Math.abs(_degree) % (_array_intervals_scale.cap()+1)) $ int => int id_interval;
	
	0 => offset;
	for( 0 => int i; i < id_interval; i++ )
		_array_intervals_scale[i] +=> offset;
		
	Math.sgn(_degree) $ int *=> offset;
	
	// 7 tones for a scale
	7*integer_part +=> offset;
	
	(_root_midi_note + offset*2) $ int => result_midi_note;
	
	return result_midi_note;
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
fun void fill_array_int( int _val, int _array[] )
{	
	for( 0 => int i ; i < _array.cap() ; i++ )
		_val => _array[i] ;
}

/**
*
*/
fun void fill_aray_int_indices( int _val, int _array[], int _array_indices[] )
{
	for( 0 => int i ; i < _array_indices.cap() ; i++ )
		_val => _array[_array_indices[i]] ;
}

/**
*
*/
fun void fill_array_float( float _val, float _array[] )
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
fun void set_all_augmented_in_array_note_value( string _array_string_notes_values[] )
{
	for( 0 => int i; i < _array_string_notes_values.cap(); i++ )	
		_array_string_notes_values[i] + "." => _array_string_notes_values[i];
}

/**
*
*/
fun void update_array_octaves( string array_string_notes_to_modify[], int new_octave, int id_start_array_notes, int id_end_array_notes, string array_string_notes[], int array_int_octaves[] )
{
	for( id_start_array_notes => int i; i < id_end_array_notes; i++ )	
	{
		for( 0 => int j; j < array_string_notes_to_modify.cap(); j++ )
		{
			if( array_string_notes_to_modify[j] == array_string_notes[i] )
			{
				new_octave => array_int_octaves[i];
			}
		}
	}
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
	
	for( 0 => int i; i < NB_MAX_SAMPLES_FOR_DRUM; i++ )
	{
		kick[i] => master_kick;
		hihat[i] => master_hihat;		
		snare[i] => master_snare;
				
		path + array_kick[i % array_kick.cap()] => kick[i].read;
		path + array_hihat[i % array_hihat.cap()] => hihat[i].read;
		path + array_snare[i % array_snare.cap()] => snare[i].read;
		
		kick[i].samples()       => kick[i].pos;
		hihat[i].samples()      => hihat[i].pos;
		snare[i].samples()      => snare[i].pos;

		// Technical/Code score: 'Random Number'
		1.15 + Std.rand2f(-0.15, 0.15) => kick[i].rate;  // higher rate => higher frequency
		0.80 + Std.rand2f(-0.05, 0.05) => hihat[i].rate; // lower rate => lower frequency
		1.00 => snare[i].rate; // normal rate
	}
	
	1.0 / nb_instruments_drum => master_drum.gain;
	_scale_gain * master_drum.gain() => master_drum.gain;

	set_equalisation_for_drum( 0 ); // normal settings
	//set_equalisation_for_drum( -1 ); // mute settings
	
	master_drum => master;
	//
	master_kick => master_drum;
	master_hihat => master_drum;	
	master_snare => master_drum;
		
	fill_array_dur( 0::second, array_current_note_value_instruments_drum );
	fill_array_int( false, array_current_note_is_silent_instruments_drum );
	fill_array_int( 0, array_current_id_note_for_instruments_drum );
	fill_array_dur( 0::second, array_duration_for_next_note_for_instruments_drum );	

	0 => id_current_sample_kick_drum => id_current_sample_hithat_drum => id_current_sample_snare_drum;
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
	}
	else if ( _id_type_eq == -1 )
	{
		0.00 => master_hihat.gain => master_kick.gain => master_snare.gain;
	}
	else
	{
		1.000 => master_hihat.gain;
		1.000 => master_kick.gain;
		1.000 => master_snare.gain;
	}
}

/**
*
*/
fun string find_audios_path()
{
	//
//	me.dir() => string root_path; // local root path, work in miniAudicle application
	"" => string root_path; // local root path, work in miniAudicle application
	if( root_path == "" )
	{
		// No definition path for me.dir()
		// the user using a network connection to communicate with ChucK
		// we need a way to localise the path for audio file
		// i'm using a environment variable 'CHUCK_AUDIO_PATH' to define a local path to find this files
		//Std.getenv( "CHUCK_AUDIO_PATH" ) => root_path; // using setenv variable (Windows system)
		Std.getenv( "CHUCK_DATA_PATH" ) => root_path; // 
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
*
*/
fun int is_end_composition()
{
	return ( now - time_start_composition ) + min_step_time <= dur_length_composition;
}

/**
*
*/
fun void cout_length_composition()
{
	30::second - (now - time_start_composition) => now;
	cout_duration("Length of this composition", now - time_start_composition );
	
	<<< "Merci pour l'ecoute! :-D" >>>;
}

/**
*
*/
fun void write_audio_in_wav( WvOut2 _wave_out, string _filename_audio )
{
	// url: http://chuck.cs.princeton.edu/doc/examples/basic/rec-auto-stereo.ck
	// pull samples from the dac
	// WvOut2 -> stereo operation
	dac => _wave_out => blackhole;
	find_audios_path() + "../" + _filename_audio => _wave_out.wavFilename;
}

/**
*
*/
fun void end_write_audio_in_wav( WvOut2 _wave_out )
{
	// temporary workaround to automatically close file on remove-shred
    null @=> _wave_out;
}
