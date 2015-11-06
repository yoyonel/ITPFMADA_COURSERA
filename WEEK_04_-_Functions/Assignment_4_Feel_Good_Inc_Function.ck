now => time start ;

Pan2 master => dac ; // Use of Panning
1.00 => master.gain;

// ------------------------------------------------------------------
// DECLARATION: CONSTANTS
// ------------------------------------------------------------------
dur quarter_note;
float f_quarter_note;
int root_midi_note;
int ID_WHOLE_NOTE, ID_HALF_NOTE, ID_QUARTER_NOTE, ID_EIGHTH_NOTE, ID_SIXTEENTH_NOTE;
float arr_durations_notes_values[5];
float array_scale_Eb_Mixolydian[7];
16 => int nb_notes_generated;
int arr_MidiNotes_Scale[nb_notes_generated];

4 => int MAX_INSTRUS;
SinOsc instrus_osc[MAX_INSTRUS];
float initial_gain_for_instrus;

// Midi Indice For Silence (MIFS)
int MIFS;
dur dur_FX, dur_Bar;

init_constants_for_assigment_number_4();

// ------------------------------------------------------------------

// ----------------------
// array of values note
// array of degrees

// 1 Mesure de Silence
[ MIFS, MIFS, MIFS, MIFS ]	@=> int 	bar_Degrees_Silent[];
[ 2.0, 2.0, 2.0, 2.0 ]		@=> float 	bar_NotesValues_Silent[];

// Feel Good Inc
// Riff 1
[ 1, MIFS, 1, 2, 3, 6 ] @=> int bar_1_1_Degrees_FeelGoodInc[];
[ 2.0, 1.0, 1.0, 1.0, 2.0, 1.0 ] @=> float bar_1_1_NotesValues_FeelGoodInc[];
[ 6, 5, MIFS, 9, MIFS, 8, MIFS ] @=> int bar_1_2_Degrees_FeelGoodInc[];
[ 1.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0 ] @=> float bar_1_2_NotesValues_FeelGoodInc[];
[ 4, 4, 6, 5, 3 ] @=> int bar_1_3_Degrees_FeelGoodInc[];
[ 2.5, 1.0, 1.0, 2.0, 1.0 ] @=> float bar_1_3_NotesValues_FeelGoodInc[];
[ 3, 1, MIFS, 9, MIFS, 8, MIFS ] @=> int bar_1_4_Degrees_FeelGoodInc[];
[ 1.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0 ] @=> float bar_1_4_NotesValues_FeelGoodInc[];
// Riff 2
[ 1, 5, 1, 5, 1, 5, 1, 5 ] @=> int bar_2_1_Degrees_FeelGoodInc[];
[ 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 ] @=> float bar_2_1_NotesValues_FeelGoodInc[];
[ 5, 7, 5, 7, 5, 7, 5, 7 ] @=> int bar_2_2_Degrees_FeelGoodInc[];
bar_2_1_NotesValues_FeelGoodInc @=> float bar_2_2_NotesValues_FeelGoodInc[];
[ 4, 1, 4, 1, 4, 1, 4, 1 ] @=> int bar_2_3_Degrees_FeelGoodInc[];
bar_2_1_NotesValues_FeelGoodInc @=> float bar_2_3_NotesValues_FeelGoodInc[];
[ 5, 1, 1, 1, 5, 1 ] @=> int bar_2_4_Degrees_FeelGoodInc[];
[ 1.0, 2.0, 2.0, 1.0, 1.0, 1.0 ] @=> float bar_2_4_NotesValues_FeelGoodInc[];
// Riff 3
[ 1, 8, 1, 8, 1, 8, 1, 8 ] @=> int bar_3_1_Degrees_FeelGoodInc[];
[ 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 ] @=> float bar_3_1_NotesValues_FeelGoodInc[];
[ 5, 12, 5, 12, 5, 12, 5, 12 ] @=> int bar_3_2_Degrees_FeelGoodInc[];
bar_3_1_NotesValues_FeelGoodInc @=> float bar_3_2_NotesValues_FeelGoodInc[];
[ 4, 11, 4, 11, 3, 10, 2, 9 ] @=> int bar_3_3_Degrees_FeelGoodInc[];
bar_3_1_NotesValues_FeelGoodInc @=> float bar_3_3_NotesValues_FeelGoodInc[];
[ 1, 8, 1, 8, 1, 8, 14 ] @=> int bar_3_4_Degrees_FeelGoodInc[];
[ 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0 ] @=> float bar_3_4_NotesValues_FeelGoodInc[];

// ----------------------

[ 
	bar_1_1_Degrees_FeelGoodInc, bar_1_2_Degrees_FeelGoodInc, 
	bar_1_3_Degrees_FeelGoodInc, bar_1_4_Degrees_FeelGoodInc, 
	bar_1_1_Degrees_FeelGoodInc, bar_1_2_Degrees_FeelGoodInc, 
	bar_1_3_Degrees_FeelGoodInc, bar_1_4_Degrees_FeelGoodInc, 
	bar_1_1_Degrees_FeelGoodInc, bar_1_2_Degrees_FeelGoodInc, 
	bar_1_3_Degrees_FeelGoodInc, bar_1_4_Degrees_FeelGoodInc, 
	bar_Degrees_Silent, bar_Degrees_Silent, 
	bar_Degrees_Silent
] @=> int arr_Bars_Degrees_Instru_1[][];
[ 
	bar_1_1_NotesValues_FeelGoodInc, bar_1_2_NotesValues_FeelGoodInc, 
	bar_1_3_NotesValues_FeelGoodInc, bar_1_4_NotesValues_FeelGoodInc, 
	bar_1_1_NotesValues_FeelGoodInc, bar_1_2_NotesValues_FeelGoodInc, 
	bar_1_3_NotesValues_FeelGoodInc, bar_1_4_NotesValues_FeelGoodInc, 
	bar_1_1_NotesValues_FeelGoodInc, bar_1_2_NotesValues_FeelGoodInc, 
	bar_1_3_NotesValues_FeelGoodInc, bar_1_4_NotesValues_FeelGoodInc, 
	bar_NotesValues_Silent, bar_NotesValues_Silent, 
	bar_NotesValues_Silent
] @=> float arr_Bars_NotesValues_Instru_1[][];

[ 
	bar_Degrees_Silent, bar_Degrees_Silent, 
	bar_Degrees_Silent, bar_Degrees_Silent,
	bar_2_1_Degrees_FeelGoodInc, bar_2_2_Degrees_FeelGoodInc, 
	bar_2_3_Degrees_FeelGoodInc, bar_2_4_Degrees_FeelGoodInc, 
	bar_2_1_Degrees_FeelGoodInc, bar_2_2_Degrees_FeelGoodInc, 
	bar_2_3_Degrees_FeelGoodInc, bar_2_4_Degrees_FeelGoodInc, 
	bar_2_1_Degrees_FeelGoodInc, bar_2_2_Degrees_FeelGoodInc,
	bar_2_3_Degrees_FeelGoodInc
] @=> int arr_Bars_Degrees_Instru_2[][];
[ 
	bar_NotesValues_Silent, bar_NotesValues_Silent, 
	bar_NotesValues_Silent, bar_NotesValues_Silent,
	bar_2_1_NotesValues_FeelGoodInc, bar_2_2_NotesValues_FeelGoodInc, 
	bar_2_3_NotesValues_FeelGoodInc, bar_2_4_NotesValues_FeelGoodInc, 
	bar_2_1_NotesValues_FeelGoodInc, bar_2_2_NotesValues_FeelGoodInc, 
	bar_2_3_NotesValues_FeelGoodInc, bar_2_4_NotesValues_FeelGoodInc, 
	bar_2_1_NotesValues_FeelGoodInc, bar_2_2_NotesValues_FeelGoodInc, 
	bar_NotesValues_Silent
] @=> float arr_Bars_NotesValues_Instru_2[][];

[ 
	bar_Degrees_Silent, bar_Degrees_Silent, 
	bar_Degrees_Silent, bar_Degrees_Silent,
	bar_Degrees_Silent, bar_Degrees_Silent, 
	bar_Degrees_Silent, bar_Degrees_Silent,
	bar_3_1_Degrees_FeelGoodInc, bar_3_2_Degrees_FeelGoodInc, 
	bar_3_3_Degrees_FeelGoodInc, bar_3_4_Degrees_FeelGoodInc, 
	bar_3_1_Degrees_FeelGoodInc, bar_3_2_Degrees_FeelGoodInc,
	bar_3_3_Degrees_FeelGoodInc
] @=> int arr_Bars_Degrees_Instru_3[][];
[ 
	bar_NotesValues_Silent, bar_NotesValues_Silent, 
	bar_NotesValues_Silent, bar_NotesValues_Silent,
	bar_NotesValues_Silent, bar_NotesValues_Silent, 
	bar_NotesValues_Silent, bar_NotesValues_Silent,
	bar_3_1_NotesValues_FeelGoodInc, bar_3_2_NotesValues_FeelGoodInc, 
	bar_3_3_NotesValues_FeelGoodInc, bar_3_4_NotesValues_FeelGoodInc, 
	bar_3_1_NotesValues_FeelGoodInc, bar_3_2_NotesValues_FeelGoodInc, 
	bar_3_3_NotesValues_FeelGoodInc
] @=> float arr_Bars_NotesValues_Instru_3[][];

// ------------------------------------------------------------------
// ------------------------------------------------------------------

Gain master_drum;
//
Gain master_kick, master_hihat, master_hihat_break;
Gain master_snare, master_snare_rim_shot, master_clap;

8 => int NB_MAX_SAMPLES_PER_SEC;
//
SndBuf kick[NB_MAX_SAMPLES_PER_SEC];
SndBuf hihat[NB_MAX_SAMPLES_PER_SEC];
SndBuf hihat_break[NB_MAX_SAMPLES_PER_SEC];
SndBuf snare[NB_MAX_SAMPLES_PER_SEC];
SndBuf snare_rim_shot[NB_MAX_SAMPLES_PER_SEC];
SndBuf clap[NB_MAX_SAMPLES_PER_SEC];
//

//
[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] @=> int bar_empty[];

[ 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0 ] @=> int bar_1_hithat_eighth[];
[ 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 ] @=> int bar_1_snare_eighth[];
[ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 ] @=> int bar_1_kick_eighth[];

//
[ 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0 ] @=> int bar_2_hithat_break_eighth[];
[ 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0 ] @=> int bar_2_snare_eighth[];
[ 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0 ] @=> int bar_2_kick_eighth[];

//
[ 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0 ] @=> int bar_3_hithat_break_eighth[];
[ 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0 ] @=> int bar_3_snare_eighth[];
[ 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0 ] @=> int bar_3_kick_eighth[];

[ 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0 ] @=> int bar_4_hithat_eighth[];
//
[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 ] @=> int bar_4_snare_eighth[];
[ 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0 ] @=> int bar_4_kick_eighth[];

//
//
[ 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 ] @=> int bar_5_snare_eighth[];
[ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 ] @=> int bar_5_kick_eighth[];

[ 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0 ] @=> int bar_clap_eighth[];

//
// I Like To Move It (drum)
[ 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0 ] @=> int bar_6_hithat_eighth[];
[ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0 ] @=> int bar_6_snare_hit_eighth[];
[ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0 ] @=> int bar_6_snare_rim_shot_eighth[];
[ 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0 ] @=> int bar_6_kick_eighth[];


[ 
    bar_1_hithat_eighth, 
    bar_1_hithat_eighth,
    bar_1_hithat_eighth,
    bar_1_hithat_eighth,
    bar_1_hithat_eighth,
    //
    bar_6_hithat_eighth
] @=> int bars_hihat[][];

[ 
    bar_empty,
    bar_2_hithat_break_eighth,
    bar_3_hithat_break_eighth,
    bar_empty,
    bar_empty,
    //
    bar_empty
] @=> int bars_hihat_break[][];

[ 
    bar_1_snare_eighth, 
    bar_2_snare_eighth,
    bar_3_snare_eighth,
    bar_4_snare_eighth,
    bar_5_snare_eighth,
    //
    bar_6_snare_hit_eighth//,
] @=> int bars_snare[][];

[ 
    bar_empty, 
    bar_empty,
    bar_empty,
    bar_empty,
    bar_empty,
    //
    bar_6_snare_rim_shot_eighth//,
] @=> int bars_snare_rim_shot[][];

[ 
    bar_1_kick_eighth, 
    bar_2_kick_eighth,
    bar_3_kick_eighth,
    bar_4_kick_eighth,
    bar_5_kick_eighth,
    //
    bar_6_kick_eighth//,
] @=> int bars_kick[][];

[
    bar_clap_eighth,
    bar_clap_eighth,
    bar_clap_eighth,
    bar_clap_eighth,
    bar_clap_eighth,
    //
    bar_clap_eighth
] @=> int bars_clap[][];

[ kick, hihat, hihat_break, snare, snare_rim_shot, clap ] @=> SndBuf arr_SndBuf_Drums[][];
[ bars_kick, bars_hihat, bars_hihat_break, bars_snare, bars_snare_rim_shot, bars_clap ] @=> int arr_bars_drums[][][];

int min_bars;
dur dur_Beat_Drum;
dur dur_Bar_Drum;

// ------------------------------------------------------------------

dur dur_update_Bar[MAX_INSTRUS];
dur dur_update_Note[MAX_INSTRUS];
dur dur_update_Note_FX[MAX_INSTRUS];
//
int id_cur_Bar[MAX_INSTRUS];
int id_cur_Note[MAX_INSTRUS];
int id_cur_Note_FX[MAX_INSTRUS];
//
int max_id_cur_Note_FX[MAX_INSTRUS];
float ratio_01_cur_Note_FX[MAX_INSTRUS];
// FADES
float ratio_01_fade_in[MAX_INSTRUS];
float ratio_01_fade_out[MAX_INSTRUS];

// ------------------------------------------------------------------
// FX parameters

float fx_fade_in_start, fx_fade_in_end, fx_fade_out_start, fx_fade_out_end;

// ------------------------------------------------------------------
// DRUM
dur dur_update_Beat_Drum;
dur dur_update_Bar_Drum;
//
int id_cur_beat_drum;
int id_cur_bar_drum;
//
int id_cur_sample_hihat;
int id_cur_sample_hihat_break;
int id_cur_sample_snare;
int id_cur_sample_snare_rim_shot;
int id_cur_sample_kick;
int id_cur_sample_clap;

[ 
	id_cur_sample_hihat, 
	id_cur_sample_hihat_break, 
	id_cur_sample_snare, 
	id_cur_sample_snare_rim_shot, 
	id_cur_sample_kick, 
	id_cur_sample_clap 
] @=> int arr_id_cur_samples[];

// ------------------------------------------------------------------

// ------------------------------------------------------------------
dur dur_cur_step_time_for_chuck;
// ------------------------------------------------------------------

// ------------------------------------------------------------------
// Initialisation : DYNAMIQUES
// ------------------------------------------------------------------

// INSTRUS Part
3 => int nb_instrus;

// ------------------------------------------------------------------

// ------------------------------------------------------------------
// 'pointeurs' vers les tableaux courants pour lire les notes
[ arr_Bars_Degrees_Instru_1, arr_Bars_Degrees_Instru_2, arr_Bars_Degrees_Instru_3 ] @=> int arrays_degrees[][][];
[ arr_Bars_NotesValues_Instru_1, arr_Bars_NotesValues_Instru_2, arr_Bars_NotesValues_Instru_3 ] @=> float arrays_notes_values[][][];
// ------------------------------------------------------------------
int cur_array_degrees[];
float cur_array_notes_values[];
// ------------------------------------------------------------------

init_FX();
init_Instruments_Parts();
init_Drum();
init_Drum_Parts();

// ------------------------------------------------------------------------------------------------
// MAIN PROGRAM
// ------------------------------------------------------------------------------------------------

(now-start) => dur temps_passe;

true => int b_is_firt_time;

play_song();

while( (temps_passe+dur_FX) <= 30::second )
{
	dur_FX => dur_cur_step_time_for_chuck;
	
	// consomme le temps audio
	dur_cur_step_time_for_chuck => now ;
	
	// update le temps passé
	(now - start) => temps_passe;	
	
	play_song();
}

<<< "time elapsed for this song:", ( now - start ) / 1::second >>>;

// ------------------------------------------------------------------------------------------------
// FUNCTIONS DEFINITIONS
// ------------------------------------------------------------------------------------------------

/**
*
*/
fun void init_constants_for_assigment_number_4()
{
	// ------------------------------------------------------------------
	// Initialisation : CONSTANTES
	// ------------------------------------------------------------------
	// Contraintes de l'assignment 4
	// 'make quarter Notes (main compositional pulse) 0.6::second in your composition'
	0.6::second => quarter_note;
	quarter_note / 1::second => f_quarter_note;
	// Scale: 'the Eb Mixolydian mode'
	51 => root_midi_note;

	4 => ID_WHOLE_NOTE;
	3 => ID_HALF_NOTE;
	2 => ID_QUARTER_NOTE;
	1 => ID_EIGHTH_NOTE;
	0 => ID_SIXTEENTH_NOTE;

	[ f_quarter_note/4.0, f_quarter_note/2.0, f_quarter_note, 2*f_quarter_note, 4*f_quarter_note ] @=> arr_durations_notes_values;
	// using scale : the Eb Mixolydian mode -> 1t 1t 1/2t 1t 1t 1/2t 1t
	[ 1.0, 1.0, 0.5, 1.0, 1.0, 0.5, 1.0 ] @=> array_scale_Eb_Mixolydian;

	//
	12*1 -=> root_midi_note;
	root_midi_note => arr_MidiNotes_Scale[0];
	//
	for( 1 => int i; i < nb_notes_generated; i++ )
	{
		arr_MidiNotes_Scale[i-1] + Std.ftoi(2 * array_scale_Eb_Mixolydian[(i-1) % array_scale_Eb_Mixolydian.cap()]) => arr_MidiNotes_Scale[i];
	}	

	(arr_durations_notes_values[ID_QUARTER_NOTE] * 4)::second => dur_Bar;    // temps pour une mesure
	4096 => int NB_SAMPLE_FX; // exprimé en fonction d'une double croche (unité de temps de la battérie) (semble fonctionner même avec un nombre 'irrationnel' ou "non multiple")
	(arr_durations_notes_values[ID_SIXTEENTH_NOTE] / NB_SAMPLE_FX)::second => dur_FX;
	
	0.075 => initial_gain_for_instrus;
	for( 0 => int i; i < instrus_osc.cap(); i++ )
	{
		0.0 => instrus_osc[i].gain;
		instrus_osc[i] => master ;
	}
	
	// Midi Indice For Silence (MIFS)
	0 => MIFS;
}

/**
*
*/
fun void init_Drum()
{
	Std.getenv( "CHUCK_AUDIO_PATH" ) + "/audio/" => string path;
	for( 0 => int i; i < NB_MAX_SAMPLES_PER_SEC; i++ )
	{
		kick[i] => master_kick;
		hihat[i] => master_hihat;
		hihat_break[i] => master_hihat_break;
		snare[i] => master_snare;
		clap[i] => master_clap;
		
		path + "kick_04.wav"    => kick[i].read;
		path + "hihat_02.wav"   => hihat[i].read;
		path + "hihat_03.wav"   => hihat_break[i].read;
		path + "snare_01.wav"   => snare[i].read;
		path + "snare_03.wav"   => snare_rim_shot[i].read;
		path + "cowbell_01.wav" => clap[i].read;
		
		kick[i].samples()       => kick[i].pos;
		hihat[i].samples()      => hihat[i].pos;
		hihat_break[i].samples()=> hihat_break[i].pos;
		snare[i].samples()      => snare[i].pos;
		snare_rim_shot[i].samples() => snare_rim_shot[i].pos;
		clap[i].samples()       => clap[i].pos;

		//0.45 => kick[i].rate;  // lower rate => lower frequency
		1.00 => kick[i].rate;  // lower rate => lower frequency
		1.00 => hihat[i].rate; // normal rate
		0.75 => hihat_break[i].rate; // negativ rate (Use of negative .rate on SndBuf for reverse)
		1.25 => snare[i].rate; // faster rate => higher frequency
		0.75 => snare_rim_shot[i].rate; // lower rate => lower frequency
		1.00 => clap[i].rate; // normal rate
	}

	0.20*0.14 => master_drum.gain;

	0.125 => master_hihat.gain;
	0.800 => master_hihat_break.gain;
	1.000 => master_kick.gain;
	1.000 => master_snare.gain;
	1.000 => master_snare_rim_shot.gain;
	0.250 => master_clap.gain;
	
	// 
	Math.min( bars_hihat.cap(), 
	Math.min(  bars_hihat_break.cap(), 
		Math.min( bars_snare.cap(), 
			Math.min( bars_clap.cap(), bars_kick.cap() ) 
		) 
	) 
	) $ int => min_bars;

	arr_durations_notes_values[ID_SIXTEENTH_NOTE]::second => dur_Beat_Drum;
	dur_Beat_Drum * (4*4) => dur_Bar_Drum;
	
	master_drum => master;
	//
	master_kick => master_drum;
	master_hihat => master_drum;
	master_hihat_break => master_drum;
	master_snare => master_drum;
	master_snare_rim_shot => master_drum;
	master_clap => master_drum;
}

/**
*
*/
fun void init_FX()
{
	0.0 => fx_fade_in_start;
	0.025 => fx_fade_in_end; // 1%
	0.66 => fx_fade_out_start;
	1.0	=> fx_fade_out_end; // 25%
}

/**
*
*/
fun void init_Instruments_Parts()
{
	dur_FX => dur_cur_step_time_for_chuck;
	for( 0 => int id_cur_instru; id_cur_instru < nb_instrus; id_cur_instru++)
	{
		// (*) -1 because we have 1 tour for initialisation (-1 + 1 = 0)
		-1 => id_cur_Note[id_cur_instru];
		-1 => id_cur_Bar[id_cur_instru];
		-1 => id_cur_Note_FX[id_cur_instru];
		//
		1 => max_id_cur_Note_FX[id_cur_instru];
		0.0 => ratio_01_cur_Note_FX[id_cur_instru];
		
		// (*) 1 tour for initialisation (dur_FX - dur_cur_step_time_for_chuck = 0)
		dur_FX => dur_update_Bar[id_cur_instru];
		dur_FX => dur_update_Note[id_cur_instru];
		dur_FX => dur_update_Note_FX[id_cur_instru];
	}
}

/**
*
*/
fun void init_Drum_Parts()
{
	// DRUM Part
	0 => id_cur_bar_drum;
	0 => id_cur_beat_drum;
	//
	0 => id_cur_sample_hihat;
	0 => id_cur_sample_hihat_break;
	0 => id_cur_sample_snare;
	0 => id_cur_sample_snare_rim_shot;
	0 => id_cur_sample_kick;
	0 => id_cur_sample_clap;
	//
	dur_Beat_Drum => dur_update_Beat_Drum;
	dur_Bar_Drum => dur_update_Bar_Drum;
}

/**
*
*/
fun void cout_debug_infos( int _debug, int id_cur_instru )
{
	if( _debug )
	{
		<<< "b_is_firt_time: ", b_is_firt_time >>>;
		<<< "dur_update_Bar[id_cur_instru]: ", dur_update_Bar[id_cur_instru]/1::second, "- ", "id_cur_Bar[id_cur_instru]: ", id_cur_Bar[id_cur_instru] >>>;
		<<< "dur_update_Note[id_cur_instru]: ", dur_update_Note[id_cur_instru]/1::second, "- ", "id_cur_Note[id_cur_instru]: ", id_cur_Note[id_cur_instru] >>>;
		<<< "dur_update_Note_FX[id_cur_instru]: ", dur_update_Note_FX[id_cur_instru]/1::second, "- ", "id_cur_Note_FX[id_cur_instru]: ", id_cur_Note_FX[id_cur_instru] >>>;
		<<< "ratio_01_cur_Note_FX[id_cur_instru]: ", ratio_01_cur_Note_FX[id_cur_instru] >>>;
		<<< "ratio_01_fade_in[id_cur_instru]: ", ratio_01_fade_in[id_cur_instru] >>>;
		<<< "ratio_01_fade_out[id_cur_instru]: ", ratio_01_fade_out[id_cur_instru] >>>;
		<<< "dur_cur_step_time_for_chuck: ", dur_cur_step_time_for_chuck/1::second >>>;
		<<< "dur_update_Bar_Drum: ", dur_update_Bar_Drum/1::second, "- ", "id_cur_bar_drum", id_cur_bar_drum >>>;
		<<< "dur_update_Beat_Drum: ", dur_update_Beat_Drum/1::second, "- ", "id_cur_beat_drum", id_cur_beat_drum >>>;
		<<< "" >>>;
	}
}

/**
*
*/
fun void update_drum()
{

	dur_cur_step_time_for_chuck -=> dur_update_Beat_Drum;
	dur_cur_step_time_for_chuck -=> dur_update_Bar_Drum;
	//
	dur_update_Beat_Drum == 0::second => int b_end_of_cur_beat_drum;
	dur_update_Bar_Drum == 0::second => int b_end_of_cur_bar_drum;
	
	if( b_end_of_cur_beat_drum )
	{
		// reset the counter for Drum
		dur_Beat_Drum => dur_update_Beat_Drum;
		
		// add +1 to the beat counter
		id_cur_beat_drum++;
		
		// End of this bar ?
		if( b_end_of_cur_bar_drum )
		{
			// next bar
			id_cur_bar_drum++;
			// updtate the bar
			min_bars %=> id_cur_bar_drum; // MOG: pour l'instant cycle sur les mesures de batteries disponibles
			// reset counter for Bar
			dur_Bar_Drum => dur_update_Bar_Drum;
			// reset the counter beat's
			0 => id_cur_beat_drum;
		}
		
		//
		for( 0 => int id_drum_instrus; id_drum_instrus < arr_bars_drums.cap(); id_drum_instrus++ )
		{
			// activate this samples/instrus drum ?
			if( arr_bars_drums[id_drum_instrus][id_cur_bar_drum][id_cur_beat_drum] )
			{
				// reset the position of the sample for playing
				0 => arr_SndBuf_Drums[id_drum_instrus][arr_id_cur_samples[id_drum_instrus]].pos;
				// allow multi-samples for the same wav without cut/crap the sound 
				(arr_id_cur_samples[id_drum_instrus] + 1) % NB_MAX_SAMPLES_PER_SEC => arr_id_cur_samples[id_drum_instrus];
			}
		}
	}
}

/**
*
*/
fun void update_FX( int id_cur_instru )
{
	// update indice for FX
	id_cur_Note_FX[id_cur_instru]++;
	
	// update ratio % for FX on note
	id_cur_Note_FX[id_cur_instru] / (max_id_cur_Note_FX[id_cur_instru] $ float) => ratio_01_cur_Note_FX[id_cur_instru];
	
	// update ratio for Fade-IN/OUT
	Math.min( 1.0, (ratio_01_cur_Note_FX[id_cur_instru] - fx_fade_in_start) / (fx_fade_in_end - fx_fade_in_start) ) => ratio_01_fade_in[id_cur_instru];			
	Math.max( 0.0, (ratio_01_cur_Note_FX[id_cur_instru] - fx_fade_out_start) / (fx_fade_out_end - fx_fade_out_start) ) => ratio_01_fade_out[id_cur_instru];
}

/**
*
*/
fun void update_Bar( int id_cur_instru )
{
	// update indice for Bar
	id_cur_Bar[id_cur_instru]++;

	// updtate the bar
	arr_Bars_Degrees_Instru_1.cap() %=> id_cur_Bar[id_cur_instru];				
	
	// reset counter for Bar
	dur_Bar => dur_update_Bar[id_cur_instru];
	
	// reset id for Note
	0 => id_cur_Note[id_cur_instru];
}

/**
*
*/
fun void update_Current_Note_Pointers( int id_cur_instru )
{
	// Set the pointers
	arrays_degrees[id_cur_instru][id_cur_Bar[id_cur_instru]] @=> cur_array_degrees;
	arrays_notes_values[id_cur_instru][id_cur_Bar[id_cur_instru]] @=> cur_array_notes_values;
}

/**
*
*/
fun int update_Note( int id_cur_instru )
{
	// update the note
	
	int cur_note_midi;
	float cur_note_freq;
	
	// Decode note        
	// Is a silent note ?
	(cur_array_degrees[id_cur_Note[id_cur_instru]] == MIFS) => int b_cur_note_is_silence;
	
	// if not
	if( !b_cur_note_is_silence )
	{
		// get the midi note from the id degree not
		arr_MidiNotes_Scale[ cur_array_degrees[id_cur_Note[id_cur_instru]] - 1 ] => cur_note_midi;
		// convert midi note to frequency (wave)
		Std.mtof( cur_note_midi ) => cur_note_freq;
		
		// Set the instru parameters (for oscillator attach)
		cur_note_freq => instrus_osc[id_cur_instru].freq ;
		initial_gain_for_instrus => instrus_osc[id_cur_instru].gain ;
	}
	else // silent note
	{
		// no frequency, no gain ... just desperation :'(
		0.0 => instrus_osc[id_cur_instru].freq ;
		0.0 => instrus_osc[id_cur_instru].gain ;
	}
	
	return b_cur_note_is_silence;
}

/**
*
*/
fun void update_Note_Value( int id_cur_instru )
{
	// update the counter for Note Value
	cur_array_notes_values[ id_cur_Note[id_cur_instru] ] => float f_cur_note_value;
	// Decode note value
	Std.ftoi( f_cur_note_value ) => int i_cur_note_value;
	//
	f_cur_note_value - i_cur_note_value != 0.0 => int is_augmented;
	//
	arr_durations_notes_values[ i_cur_note_value ] => f_cur_note_value;
	f_cur_note_value * is_augmented * 0.5 +=> f_cur_note_value; // float : in second
	
	f_cur_note_value::second => dur_update_Note[id_cur_instru];					
	
	// Project on FX scale time
	Std.ftoi( dur_update_Note[id_cur_instru] / dur_FX ) => max_id_cur_Note_FX[id_cur_instru];
}

/**
*
*/
fun void reset_FX( int id_cur_instru )
{
	// reset id for FX
	0 => id_cur_Note_FX[id_cur_instru];
	0.0 => ratio_01_cur_Note_FX[id_cur_instru];
	// reset counter for FX
	dur_FX => dur_update_Note_FX[id_cur_instru];
}

/**
*
*/
fun void apply_FX( int id_cur_instru, int b_cur_note_is_silence )
{
	if( !b_cur_note_is_silence )
	{
		initial_gain_for_instrus => instrus_osc[id_cur_instru].gain ;
		instrus_osc[id_cur_instru].gain() * ratio_01_fade_in[id_cur_instru] * (1.0 - ratio_01_fade_out[id_cur_instru]) => instrus_osc[id_cur_instru].gain;
	}
	else
	{
		0.0 => instrus_osc[id_cur_instru].freq ;
		0.0 => instrus_osc[id_cur_instru].gain ;
	}
}

/**
*
*/
fun void update_instrument( int id_cur_instru )
{
	cout_debug_infos( false, id_cur_instru );
	
	// update durations counters
	dur_cur_step_time_for_chuck -=> dur_update_Note_FX[id_cur_instru];		
	dur_cur_step_time_for_chuck -=> dur_update_Note[id_cur_instru];
	dur_cur_step_time_for_chuck -=> dur_update_Bar[id_cur_instru];		
	
	// Est ce la fin ? (Subdivision FX sur note, Note, Mesure)
	dur_update_Note_FX[id_cur_instru] <= 0::second => int b_end_of_cur_note_fx;
	dur_update_Note[id_cur_instru] <= 0::second => int b_end_of_cur_note;	
	dur_update_Bar[id_cur_instru] <= 0::second => int b_end_of_cur_bar;	

	false => int b_cur_note_is_silence;
	
	if( b_end_of_cur_note_fx )
	{
		update_FX( id_cur_instru );
		
		// On continue l'effet si on ne change pas de note
		if( !b_end_of_cur_note )
		{
			// reset counter for FX
			dur_FX => dur_update_Note_FX[id_cur_instru];
		}
		else
		{			
			// update indice for Note
			id_cur_Note[id_cur_instru]++;
			
			// Est ce la fin de la mesure courante ?
			if( b_end_of_cur_bar )
			{
				update_Bar( id_cur_instru );
			}
			
			update_Current_Note_Pointers( id_cur_instru );			
			
			update_Note( id_cur_instru ) => b_cur_note_is_silence;
			
			update_Note_Value( id_cur_instru ) ;
			
			reset_FX( id_cur_instru );
		}
	}
	
	apply_FX( id_cur_instru, b_cur_note_is_silence );
}

/**
*
*/
fun void play_song()
{
	// For each 'instrument'
	for( 0 => int id_cur_instru; id_cur_instru < nb_instrus; id_cur_instru++)
	{
		// update instument track
		update_instrument( id_cur_instru );
	}
	// DRUM part
	update_drum();
}