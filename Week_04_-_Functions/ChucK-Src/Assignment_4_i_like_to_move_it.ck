now => time start ;

Pan2 master => dac ; // Use of Panning
1.00 => master.gain;

// ------------------------------------------------------------------
// Initialisation : CONSTANTES
// ------------------------------------------------------------------
// 2.000 = ronde <=> x2
// 1.000 = blanche <=> x1
// 0.500 = noire <=> /2
// 0.250 = croche <=> /4
// 0.125 = double croche <=> /8
4 => int ID_WHOLE_NOTE;
3 => int ID_HALF_NOTE;
2 => int ID_QUARTER_NOTE;
1 => int ID_EIGHTH_NOTE;
0 => int ID_SIXTEENTH_NOTE;
//5 => int ID_THIRTY_SECOND_NOTE;
[ 0.125, 0.25, 0.5, 1, 2 ] @=> float arr_durations_notes_values[];
// using scale : D Dorian (<=> same notes of C-Maj) -> 1t 1/2t 1t 1t 1t 1/2t 1t
[ 1.0, 0.5, 1.0, 1.0, 1.0, 0.5, 1.0 ] @=> float arr_scale_D_Dorian[];
//
16 => int nb_notes_generated;
int arr_MidiNotes_Scale[nb_notes_generated];
50 - 12*1 => int root_midi_note;
root_midi_note => arr_MidiNotes_Scale[0];
//
for( 1 => int i; i < nb_notes_generated; i++ )
{
    arr_MidiNotes_Scale[i-1] + Std.ftoi(2 * arr_scale_D_Dorian[(i-1) % arr_scale_D_Dorian.cap()]) => arr_MidiNotes_Scale[i];
}

// Midi Indice For Silence (MIFS)
0 => int MIFS;

(arr_durations_notes_values[ID_QUARTER_NOTE] * 4)::second => dur dur_Bar;    // temps pour une mesure
4096 => int NB_SAMPLE_FX; // exprimé en fonction d'une double croche (unité de temps de la battérie) (semble fonctionner même avec un nombre 'irrationnel' ou "non multiple")
(arr_durations_notes_values[ID_SIXTEENTH_NOTE] / NB_SAMPLE_FX)::second => dur dur_FX;

4 => int MAX_INSTRUS;

SinOsc instrus_osc[MAX_INSTRUS];
0.075 => float initial_gain_for_instrus;
for( 0 => int i; i < instrus_osc.cap(); i++ )
{
	0.0 => instrus_osc[i].gain;
	instrus_osc[i] => master ;
}
	
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

// 15 mesures = 30 secondes

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
//Std.getenv( "CHUCK_AUDIO_PATH" ) + "/audio/" => string path;
Std.getenv( "CHUCK_DATA_PATH" ) + "/audio/" => string path;

8 => int NB_MAX_SAMPLES_PER_SEC;

Gain master_drum => master;

//
Gain master_kick => master_drum;
Gain master_hihat => master_drum;
Gain master_hihat_break => master_drum;
Gain master_snare => master_drum;
Gain master_snare_rim_shot => master_drum;
Gain master_clap => master_drum;
//
SndBuf kick[NB_MAX_SAMPLES_PER_SEC];
SndBuf hihat[NB_MAX_SAMPLES_PER_SEC];
SndBuf hihat_break[NB_MAX_SAMPLES_PER_SEC];
SndBuf snare[NB_MAX_SAMPLES_PER_SEC];
SndBuf snare_rim_shot[NB_MAX_SAMPLES_PER_SEC];
SndBuf clap[NB_MAX_SAMPLES_PER_SEC];
//

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

0.25*0.14 => master_drum.gain;

0.125 => master_hihat.gain;
0.800 => master_hihat_break.gain;
1.000 => master_kick.gain;
1.000 => master_snare.gain;
1.000 => master_snare_rim_shot.gain;
0.250 => master_clap.gain;
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

// 
Math.min( bars_hihat.cap(), 
    Math.min(  bars_hihat_break.cap(), 
        Math.min( bars_snare.cap(), 
            Math.min( bars_clap.cap(), bars_kick.cap() ) 
        ) 
    ) 
) $ int => int min_bars;

[ kick, hihat, hihat_break, snare, snare_rim_shot, clap ] @=> SndBuf arr_SndBuf_Drums[][];
[ bars_kick, bars_hihat, bars_hihat_break, bars_snare, bars_snare_rim_shot, bars_clap ] @=> int arr_bars_drums[][][];

arr_durations_notes_values[ID_SIXTEENTH_NOTE]::second => dur dur_Beat_Drum;
dur_Beat_Drum * (4*4) => dur dur_Bar_Drum;

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
// set the FX parameters
0.0 => float fx_fade_in_start;
0.025 => float fx_fade_in_end; // 1%
0.66 => float fx_fade_out_start;
1.0 => float fx_fade_out_end; // 25%

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

[ id_cur_sample_hihat, id_cur_sample_hihat_break, id_cur_sample_snare, id_cur_sample_snare_rim_shot, id_cur_sample_kick, id_cur_sample_clap ] @=> int arr_id_cur_samples[];

// ------------------------------------------------------------------

// ------------------------------------------------------------------

// ------------------------------------------------------------------
dur dur_cur_step_time_for_chuck;
// ------------------------------------------------------------------

// ------------------------------------------------------------------
// Initialisation : DYNAMIQUES
// ------------------------------------------------------------------
// INSTRUS Part
3 => int nb_instrus;
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
// ------------------------------------------------------------------
// ------------------------------------------------------------------
// 'pointeurs' vers les tableaux courants pour lire les notes
[ arr_Bars_Degrees_Instru_1, arr_Bars_Degrees_Instru_2, arr_Bars_Degrees_Instru_3 ] @=> int arrays_degrees[][][];
[ arr_Bars_NotesValues_Instru_1, arr_Bars_NotesValues_Instru_2, arr_Bars_NotesValues_Instru_3 ] @=> float arrays_notes_values[][][];
// ------------------------------------------------------------------
int cur_array_degrees[];
float cur_array_notes_values[];
// ------------------------------------------------------------------

(now-start) => dur temps_passe;

true => int b_is_firt_time;

while( (temps_passe+dur_cur_step_time_for_chuck) <= 30::second )
{
	(!b_is_firt_time) * dur_FX => dur_cur_step_time_for_chuck;
	
	// consomme le temps audio
	 dur_cur_step_time_for_chuck => now ;
	
	// update le temps passé
	(now - start) => temps_passe;	
	
	// For each 'instrument'
	for( 0 => int id_cur_instru; id_cur_instru < nb_instrus; id_cur_instru++)
	{
		if( false )
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
	
		// update durations counters
		dur_cur_step_time_for_chuck -=> dur_update_Note_FX[id_cur_instru];		
		dur_cur_step_time_for_chuck -=> dur_update_Note[id_cur_instru];
		dur_cur_step_time_for_chuck -=> dur_update_Bar[id_cur_instru];		
		
		// Est ce la fin ? (Subdivision FX sur note, Note, Mesure)
		dur_update_Note_FX[id_cur_instru] == 0::second => int b_end_of_cur_note_fx;
		dur_update_Note[id_cur_instru] == 0::second => int b_end_of_cur_note;	
		dur_update_Bar[id_cur_instru] == 0::second => int b_end_of_cur_bar;	

		false => int b_cur_note_is_silence;
		
		if( b_end_of_cur_note_fx )
		{
			// update indice for FX
			id_cur_Note_FX[id_cur_instru]++;
			
			// update ratio % for FX on note
			id_cur_Note_FX[id_cur_instru] / (max_id_cur_Note_FX[id_cur_instru] $ float) => ratio_01_cur_Note_FX[id_cur_instru];
			// update ratio for Fade-IN/OUT
			Math.min( 1.0, (ratio_01_cur_Note_FX[id_cur_instru] - fx_fade_in_start) / (fx_fade_in_end - fx_fade_in_start) ) => ratio_01_fade_in[id_cur_instru];			
			Math.max( 0.0, (ratio_01_cur_Note_FX[id_cur_instru] - fx_fade_out_start) / (fx_fade_out_end - fx_fade_out_start) ) => ratio_01_fade_out[id_cur_instru];
			
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
					// update indice for Bar
					id_cur_Bar[id_cur_instru]++;

					// updtate the bar
					arr_Bars_Degrees_Instru_1.cap() %=> id_cur_Bar[id_cur_instru];				
					
					// reset counter for Bar
					dur_Bar => dur_update_Bar[id_cur_instru];
					
					// reset id for Note
					0 => id_cur_Note[id_cur_instru];
				}
								
				// Set the pointers
				arrays_degrees[id_cur_instru][id_cur_Bar[id_cur_instru]] @=> cur_array_degrees;
				arrays_notes_values[id_cur_instru][id_cur_Bar[id_cur_instru]] @=> cur_array_notes_values;
				
				// update the note
				{
					int cur_note_midi;
					float cur_note_freq;
					
					// Decode note        
					// Is a silent note ?
					(cur_array_degrees[id_cur_Note[id_cur_instru]] == MIFS) => b_cur_note_is_silence;					
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
				}
				
				// update the counter for Note Value
				// => MAJ : dur_update_Note[id_cur_instru]
				{
					cur_array_notes_values[ id_cur_Note[id_cur_instru] ] => float f_cur_note_value;
					// Decode note value
					Std.ftoi( f_cur_note_value ) => int i_cur_note_value;
					//
					arr_durations_notes_values[ i_cur_note_value ] * (1 + (f_cur_note_value - i_cur_note_value)) => f_cur_note_value; // float : in second
					//arr_durations_notes_values[2]::second => dur_update_Note[id_cur_instru]; // MOG: exemple			
					f_cur_note_value::second => dur_update_Note[id_cur_instru];					
					// Project on FX scale time
					Std.ftoi( dur_update_Note[id_cur_instru] / dur_FX ) => max_id_cur_Note_FX[id_cur_instru];
				}
				
				// reset id for FX
				0 => id_cur_Note_FX[id_cur_instru];
				0.0 => ratio_01_cur_Note_FX[id_cur_instru];
				// reset counter for FX
				dur_FX => dur_update_Note_FX[id_cur_instru];
			}
		}
		
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
	/**/
	
	// DRUM part
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
	
	false => b_is_firt_time;
}

<<< "temps passe:", ( now - start ) / 1::second >>>;
