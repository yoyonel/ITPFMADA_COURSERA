// Assignment 5: Unit Generators
// Composition Name: 'Débit Frigide'
// Author: mysterious_dude ^^
// Date: 2013 - 11 - 25

now => time start_composition;

Pan2 master => ADSR masterEnv => dac;
//0.50 * 1.06 => master.gain;
0.73 => master.gain;
(0::second, 0::second, 1.00, 5::ms) => masterEnv.set; // Fade-Out (very small, just to avoid crack/pop sound at the end)

//_______________________________________________________________________________
0 => int ID_WHOLE_NOTE;
1 => int ID_HALF_NOTE;
2 => int ID_QUARTER_NOTE;
3 => int ID_EIGHTH_NOTE;
4 => int ID_SIXTEENTH_NOTE;
5 => int ID_THIRTY_SECOND_NOTE;

// 'Make quarter Notes (main compositional pulse) 0.75::second in your composition'
0.75::second => dur quarter_duration;

// 'Create a 30 second composition'
30::second => dur dur_length_composition;

// compute the notes values using for this composition
(ID_THIRTY_SECOND_NOTE+1) => int max_subdivision_for_notes_values;
dur array_notes_values[max_subdivision_for_notes_values];
compute_notes_values( quarter_duration, max_subdivision_for_notes_values );
//_______________________________________________________________________________

//_______________________________________________________________________________
// --------------------------------------------------
// Drum section
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

//_______________________________________________________________________________
// --------------------------------------------------
// Instruments - MIDI Engine
// --------------------------------------------------
100 => int nb_notes_for_instru_1;
//
int array_dates_instru_1[nb_notes_for_instru_1];
int array_midi_notes_instru_1[nb_notes_for_instru_1];
int array_durations_instru_1[nb_notes_for_instru_1];
//
load_instrument_1();

160 => int nb_notes_for_instru_2;
//
int array_dates_instru_2[nb_notes_for_instru_2];
int array_midi_notes_instru_2[nb_notes_for_instru_2];
int array_durations_instru_2[nb_notes_for_instru_2];
//
load_instrument_2();

74 => int nb_notes_for_instru_3;
//
int array_dates_instru_3[nb_notes_for_instru_3];
int array_midi_notes_instru_3[nb_notes_for_instru_3];
int array_durations_instru_3[nb_notes_for_instru_3];
//
load_instrument_3();

102 => int nb_notes_for_instru_4;
//
int array_dates_instru_4[nb_notes_for_instru_4];
int array_midi_notes_instru_4[nb_notes_for_instru_4];
int array_durations_instru_4[nb_notes_for_instru_4];
//
load_instrument_4();

[ 
	array_dates_instru_1, 
	array_dates_instru_2, 
	array_dates_instru_3,
	array_dates_instru_4
] @=> int array_dates_instruments[][];
[ 
	array_midi_notes_instru_1, 
	array_midi_notes_instru_2, 
	array_midi_notes_instru_3,
	array_midi_notes_instru_4
] @=> int array_midi_notes_instruments[][];
[ 
	array_durations_instru_1, 
	array_durations_instru_2, 
	array_durations_instru_3,
	array_durations_instru_4
] @=> int array_durations_instruments[][];

array_dates_instruments.cap() => int nb_instruments;
//_______________________________________________________________________________

//_______________________________________________________________________________
480 => int TPQ; // Ticks Per Quarter
quarter_duration / (TPQ $ float) => dur tick_duration;

Std.ftoi( Math.floor(tick_duration / 1::samp) * 0.5 ) => int nb_samp_for_1_tick;

tick_duration / nb_samp_for_1_tick => dur step_time_for_ChucK;
//_______________________________________________________________________________

//_______________________________________________________________________________
// --------------------------------------------------
// MIDI Engine
// --------------------------------------------------
int compteur_samp;
int id_instrument;
int id_note[nb_instruments];
int play_note[nb_instruments];
int current_duration_for_midi_note[nb_instruments];
time time_for_Release[nb_instruments];
//
init_MIDI_Engine();

//_______________________________________________________________________________
// --------------------------------------------------
// Instruments: Mandolins samplers
// --------------------------------------------------
// 'using Unit Generators'
// 'Use of at least one STK instrument'
Mandolin mando[nb_instruments];
ADSR env[nb_instruments];

float gain_for_mandolins[nb_instruments];
float pan_for_mandolins[nb_instruments];
//_______________________________________________________________________________


//_______________________________________________________________________________
// Global equalisation
3.00 => float global_gain_for_drum;
1.20 => float global_gain_for_instruments_mandolins;
//
init_Drum( find_audios_path(), global_gain_for_drum );
init_mandolin_instruments( global_gain_for_instruments_mandolins );
//_______________________________________________________________________________

//_______________________________________________________________________________
// MAIN
// // uncomment this lines (below) 
// // if you want to save the result of this composition in a wav file (can be useful to study the wav form of my sound)
WvOut2 wav_out2;
write_audio_in_wav( wav_out2, "test_assigment_5" );

now => time start;
0 => int current_tick;
19200 => int endPart;

1 => masterEnv.keyOn;

while( current_tick < endPart )
{
	update_midi_instruments(current_tick);	
	update_chuck_audio_engine();
}

if( (now - start_composition) < 30::second )
{
	30::second - (now - start_composition) => now;
}

cout_duration("Length of this composition", now - start_composition );

<<< "Merci pour l'ecoute! :-D" >>>;

// // uncomment this line to save the result in wav file (can work without the line)
end_write_audio_in_wav( wav_out2 );


//_______________________________________________________________________________

/**
*
*/
fun void fade_out_for_the_end()
{
	// masterEnv.state() == 2 => sustain state for masterEnv
	if( (now - start_composition) >= (dur_length_composition - masterEnv.releaseTime()) && (masterEnv.state() == 2) )
	{
		1 => masterEnv.keyOff;
	}
}

/**
*
*/
fun void update_chuck_audio_engine()
{
	// Subdivise time to have a better quality for wav creation from ChucK engine
	for( 0 => int i; i < nb_samp_for_1_tick; i++ )
	{
		update_drum(step_time_for_ChucK);	// update drum engine
		fade_out_for_the_end();	// fade-out at the end
		step_time_for_ChucK => now ;	// advanced time for ChucK	
	}
}

/**
*
*/
fun void update_midi_instruments( int _current_tick )
{
	// for each 'midi' instruments
	for( 0 => int id_instrument; id_instrument < nb_instruments; id_instrument++ )
	{
		// get the current state, and update the midi note
		update_midi_instrument( 
			id_instrument, _current_tick, id_note, 
			current_duration_for_midi_note, play_note,
			array_dates_instruments, array_midi_notes_instruments, array_durations_instruments
		) => int stateMidi;
		
		// state machine for midi engine
		if( stateMidi == 0 )
		{
			// New note ! Attack
			array_midi_notes_instruments[id_instrument][id_note[id_instrument]-1] => int midi_note;
			//
			Std.mtof( midi_note + 12*1 ) => mando[id_instrument].freq;
			1 => env[id_instrument].keyOn => mando[id_instrument].noteOn; // pluck strings : velocity [0.0, 1.0]
		}
		else if( stateMidi == 1 )
		{			
			// New silence !
			1 => env[id_instrument].keyOff;
			0.01 => mando[id_instrument].noteOff; // pluck strings : velocity [0.0, 1.0]
		}
		else if( stateMidi == 2 )
		{
			// Playing a note. Stay
		}
		else if( stateMidi == 3 )
		{
			// Silence ... Stay
		}
	}
	current_tick++;	// advanced tick/time for midi engine
}

/**
*	state:
*	- 0 : new note
*	- 1 : new silence
*	- 2 : playing a note
*	- 3 : 'playing' a silence
*/
fun int update_midi_instrument(	
	int _id_instrument,	// IN
	int _current_tick,	// IN
	int _id_note[],	// IN-OUT
	int _duration_for_midi_note[],	// OUT
	int _play_note[],	// OUT
	int _array_dates_instruments[][],	// IN
	int _array_midi_notes_instruments[][],	// IN
	int _array_durations_instruments[][]	// IN	
)
{
	0 => int state;
	
	// ALIAS (for reading)
	_id_note[_id_instrument] @=> int id_note;
	_array_dates_instruments[_id_instrument] @=> int array_dates[];
	_array_midi_notes_instruments[_id_instrument] @=> int array_midi_notes[];
	_array_durations_instruments[_id_instrument] @=> int array_durations[];
	
	// Time to play a new note ?
	if( array_dates[id_note] == _current_tick )
	{	
		// New note !
		0 => state;
		
		array_durations[id_note] => _duration_for_midi_note[_id_instrument];

		1 => _play_note[_id_instrument];

		array_midi_notes.cap()-1 %=> _id_note[_id_instrument];
		_id_note[_id_instrument]++; // update midi note
	}
	else if( _play_note[_id_instrument] ) // are we playing a note ?
	{
		if( _duration_for_midi_note[_id_instrument] == 0 ) // duration counter is finish ?
		{
			// go inside a silence note
			1 => state;
			0 => _play_note[_id_instrument];
		}
		else
		{
			// we playing a note			
			2 => state;
			_duration_for_midi_note[_id_instrument]--;
		}
	}
	else
	{
		// we are inside a silence note
		3 => state;
	}
	
	return state;
}

/**
* Initialisation of MIDI engine
*/
fun void init_MIDI_Engine()
{
	0 => compteur_samp;
	0 => id_instrument;

	for( 0 => int i; i < id_note.cap(); i++ )
	{	
		0 => id_note[i] => play_note[i] => current_duration_for_midi_note[i];
	}
}

/**
* Loading midi note for instrument 1
*/
fun void load_instrument_1()
{
	[ 
	 0, 240, 360, 600, 720, 960, 1200, 1320, 1440, 1680, 1800, 1920, 2160, 2280, 2520, 2640, 2880, 3120, 3240, 3360, 3600, 3720, 3840, 4080, 4200, 4440, 4560, 4800, 5040, 5160, 5280, 5520, 5640, 5760, 6000, 6120, 6360, 6480, 6720, 6960, 7080, 7200, 7440, 7560, 7680, 7920, 8040, 8280, 8520, 8640, 9000, 9120, 9360, 9480, 9600, 9840, 9960, 10200, 10440, 10560, 10920, 11040, 11160, 11280, 11400, 11520, 11760, 11880, 12120, 12360, 12480, 12840, 12960, 13080, 13200, 13320, 13440, 13680, 13800, 14040, 14280, 14400, 14760, 14880, 15000, 15120, 15240, 15360, 15720, 16080, 16320, 17040, 17160, 17280, 17640, 18000, 18240, 18600, 18960, 19080
	] @=> array_dates_instru_1;
	[ 
	 25, 32, 37, 32, 37, 38, 37, 35, 37, 32, 32, 25, 32, 37, 32, 37, 38, 37, 35, 37, 32, 25, 23, 30, 35, 30, 35, 37, 35, 33, 35, 30, 30, 23, 30, 35, 30, 35, 37, 35, 37, 32, 30, 32, 25, 32, 37, 37, 38, 40, 38, 40, 38, 37, 25, 32, 37, 37, 38, 40, 38, 40, 37, 38, 32, 25, 32, 37, 37, 38, 40, 38, 40, 37, 38, 37, 25, 32, 37, 37, 38, 40, 38, 40, 37, 38, 32, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37
	] @=> array_midi_notes_instru_1;
	[ 
	 240, 120, 240, 120, 240, 240, 120, 120, 240, 120, 120, 240, 120, 240, 120, 240, 240, 120, 120, 240, 120, 120, 240, 120, 240, 120, 240, 240, 120, 120, 240, 120, 120, 240, 120, 240, 120, 240, 240, 120, 120, 240, 120, 120, 240, 120, 240, 240, 120, 360, 120, 240, 120, 120, 240, 120, 240, 240, 120, 360, 120, 120, 120, 120, 120, 240, 120, 240, 240, 120, 360, 120, 120, 120, 120, 120, 240, 120, 240, 240, 120, 360, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120
	] @=> array_durations_instru_1;
}

/**
* Loading midi note for instrument 2
*/
fun void load_instrument_2()
{
	[ 
	 0, 120, 240, 360, 480, 600, 720, 840, 960, 1080, 1200, 1320, 1440, 1560, 1680, 1800, 1920, 2040, 2160, 2280, 2400, 2520, 2640, 2760, 2880, 3000, 3120, 3240, 3360, 3480, 3600, 3720, 3840, 3960, 4080, 4200, 4320, 4440, 4560, 4680, 4800, 4920, 5040, 5160, 5280, 5400, 5520, 5640, 5760, 5880, 6000, 6120, 6240, 6360, 6480, 6600, 6720, 6840, 6960, 7080, 7200, 7320, 7440, 7560, 7680, 7800, 7920, 8040, 8160, 8280, 8400, 8520, 8640, 8760, 8880, 9000, 9120, 9240, 9360, 9480, 9600, 9720, 9840, 9960, 10080, 10200, 10320, 10440, 10560, 10680, 10800, 10920, 11040, 11160, 11280, 11400, 11520, 11640, 11760, 11880, 12000, 12120, 12240, 12360, 12480, 12600, 12720, 12840, 12960, 13080, 13200, 13320, 13440, 13560, 13680, 13800, 13920, 14040, 14160, 14280, 14400, 14520, 14640, 14760, 14880, 15000, 15120, 15240, 15360, 15480, 15600, 15720, 15840, 15960, 16080, 16200, 16320, 16440, 16560, 16680, 16800, 16920, 17040, 17160, 17280, 17400, 17520, 17640, 17760, 17880, 18000, 18120, 18240, 18360, 18480, 18600, 18720, 18840, 18960, 19080
	] @=> array_dates_instru_2;
	[ 
	 25, 32, 37, 32, 25, 32, 37, 32, 25, 32, 37, 32, 25, 32, 37, 32, 25, 32, 37, 32, 25, 32, 37, 32, 25, 32, 37, 32, 25, 32, 37, 32, 23, 30, 35, 30, 23, 30, 35, 30, 23, 30, 35, 30, 23, 30, 35, 30, 23, 30, 35, 30, 23, 30, 35, 30, 23, 30, 35, 30, 23, 30, 35, 30, 25, 32, 37, 26, 33, 38, 33, 38, 28, 40, 35, 33, 40, 33, 38, 33, 25, 32, 37, 26, 33, 38, 33, 38, 28, 40, 35, 33, 40, 33, 38, 33, 25, 32, 37, 26, 33, 38, 33, 38, 28, 40, 35, 33, 40, 33, 38, 33, 25, 32, 37, 26, 33, 38, 33, 38, 28, 40, 35, 33, 40, 33, 38, 33, 25, 32, 37, 25, 32, 37, 25, 32, 37, 25, 37, 37, 25, 32, 37, 25, 32, 37, 25, 32, 37, 25, 32, 37, 25, 37, 37, 25, 32, 37, 25, 25
	] @=> array_midi_notes_instru_2;
	[ 
	 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120
	] @=> array_durations_instru_2;
}

/**
* Loading midi note for instrument 3
*/
fun void load_instrument_3()
{
	[ 
	 0, 240, 840, 960, 1200, 1920, 2160, 2760, 2880, 3120, 3360, 3720, 3840, 4080, 4680, 4800, 5040, 5760, 6000, 6600, 6720, 6960, 7680, 7920, 8040, 8280, 8520, 8640, 9120, 9360, 9600, 9840, 9960, 10200, 10440, 10560, 11040, 11280, 11520, 11760, 11880, 12120, 12360, 12480, 12960, 13200, 13440, 13680, 13800, 14040, 14280, 14400, 14880, 15120, 15360, 15600, 15720, 15960, 16080, 16320, 16440, 16680, 16800, 17040, 17280, 17520, 17640, 17880, 18000, 18240, 18360, 18600, 18720, 18960
	] @=> array_dates_instru_3;
	[ 
	 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 25, 25, 26, 26, 26, 28, 28, 26, 25, 25, 26, 26, 26, 28, 26, 26, 25, 25, 26, 26, 26, 28, 26, 26, 25, 25, 26, 26, 26, 28, 26, 26, 25, 26, 25, 23, 25, 26, 25, 23, 25, 25, 25, 26, 25, 23, 25, 26, 25, 23, 25, 25
	] @=> array_midi_notes_instru_3;
	[ 
	 120, 360, 120, 240, 360, 120, 360, 120, 240, 240, 240, 120, 120, 360, 120, 240, 360, 120, 360, 120, 240, 360, 240, 120, 240, 240, 120, 480, 240, 240, 240, 120, 240, 240, 120, 480, 240, 240, 240, 120, 240, 240, 120, 480, 240, 240, 240, 120, 240, 240, 120, 480, 240, 240, 240, 120, 240, 120, 240, 120, 240, 120, 240, 240, 240, 120, 240, 120, 240, 120, 240, 120, 240, 240
	] @=> array_durations_instru_3;
}

/**
* Loading midi note for instrument 4
*/
fun void load_instrument_4()
{
	[ 
	 0, 240, 360, 600, 720, 960, 1080, 1560, 1680, 1800, 1920, 2160, 2280, 2520, 2640, 2880, 3000, 3480, 3600, 3720, 3840, 4080, 4200, 4440, 4560, 4800, 4920, 5400, 5520, 5640, 5760, 6000, 6120, 6360, 6480, 6720, 6840, 7320, 7440, 7560, 7680, 7920, 8040, 8280, 8520, 8640, 9000, 9120, 9240, 9480, 9600, 9840, 9960, 10200, 10440, 10560, 10920, 11040, 11160, 11280, 11400, 11520, 11760, 11880, 12120, 12360, 12480, 12840, 12960, 13080, 13320, 13440, 13680, 13800, 14040, 14280, 14400, 14760, 14880, 15000, 15120, 15240, 15360, 15600, 15720, 15960, 16080, 16320, 16440, 16680, 16800, 17040, 17280, 17520, 17640, 17880, 18000, 18240, 18360, 18600, 18720, 18960
	] @=> array_dates_instru_4;
	[ 
	 25, 37, 25, 37, 25, 37, 25, 25, 25, 25, 25, 37, 25, 37, 25, 37, 25, 37, 25, 25, 23, 35, 23, 35, 23, 35, 23, 23, 23, 23, 23, 35, 23, 35, 23, 35, 23, 23, 35, 23, 25, 25, 26, 26, 26, 28, 26, 28, 26, 26, 25, 25, 26, 26, 26, 28, 26, 28, 26, 26, 26, 25, 25, 26, 26, 26, 28, 26, 28, 26, 26, 25, 25, 26, 26, 26, 28, 26, 28, 26, 26, 26, 25, 23, 25, 23, 25, 23, 25, 23, 25, 25, 25, 23, 25, 23, 25, 23, 25, 23, 25, 25
	] @=> array_midi_notes_instru_4;
	[ 
	 240, 120, 240, 120, 240, 120, 240, 120, 120, 120, 240, 120, 240, 120, 240, 120, 240, 120, 120, 120, 240, 120, 240, 120, 240, 120, 240, 120, 120, 120, 240, 120, 240, 120, 240, 120, 240, 120, 120, 120, 240, 120, 240, 240, 120, 360, 120, 60, 240, 120, 240, 120, 240, 240, 120, 360, 120, 60, 120, 120, 120, 240, 120, 240, 240, 120, 360, 120, 60, 240, 120, 240, 120, 240, 240, 120, 360, 120, 60, 120, 120, 120, 240, 120, 240, 120, 240, 120, 240, 120, 120, 120, 240, 120, 240, 120, 240, 120, 240, 120, 120, 120
	] @=> array_durations_instru_4;
}

/**
* Adding a PitShift effect
*/
fun UGen add_fx_pitshift( float _shift, float _mix, UGen _entry )
{
	PitShift pshift;
	
	// PitShift Effect
	_shift => pshift.shift;
	_mix => pshift.mix;
	//
	_entry => pshift;
	return pshift;
}

/**
* Adding a Chorus effect
*/
fun UGen add_fx_chorus( float _modFreq, float _modDepth, float _mix, UGen _entry )
{
	// Chorus Effect
	Chorus chorus;
	// settings
	_mix => chorus.mix;
	_modFreq => chorus.modFreq;
	_modDepth => chorus.modDepth;
	// link ugen fx
	_entry => chorus;
	// _out_ugen
	return chorus;
}

/**
* Adding a Reverb effect
*/
fun UGen add_fx_reverb( float _mix, UGen _entry )
{
	// Chorus Effect
	NRev reverb;
	// settings
	_mix => reverb.mix;
	// link ugen fx
	_entry => reverb;
	// _out_ugen
	return reverb;
}

/**
* * Adding a Vibrato effect (don't work)
*/
fun UGen add_fx_vibrato( float _gain, float _freq, UGen _entry )
{
	// Chorus Effect
	SinOsc vibrato;
	// settings
	_gain => vibrato.gain;
	_freq => vibrato.freq;
	// link ugen fx
	vibrato => _entry;
	// _out_ugen
	return _entry;
}
/**
* * Adding a Echo effect (don't work)
*/
fun void add_fx_echo_chain( float _gain, dur _delay, float _mix, UGen _entry_and_exit )
{
	// UGen for Echo effects (Gain FeedBack and Echo FX)
	Gain gain_feedback;
	Echo echo;
	// settings
	_gain => gain_feedback.gain;
	_delay => echo.max => echo.delay;
	_mix => echo.mix;
	// Set the circular link to doing the Echo effect
	_entry_and_exit => gain_feedback => echo => _entry_and_exit;
}

/**
* Adding a Envelope effect
*/
fun UGen set_and_add_fx_envelope( ADSR _envelope, dur _attack, dur _decrease, float _stay, dur _release, UGen _entry )
{	
	// settings
	( _attack, _decrease, _stay, _release ) => _envelope.set; // Fade-Out
	
	// link ugen fx
	_entry => _envelope;
	
	// return the out UGen
	return _envelope;
}

/**
* Set a STK-Mandolin instrument from parameters
*/
fun void set_mandolin_instrument( float _pluckPos, float _bodySize, float _stringDetune, Mandolin _mandolin )
{	
	_pluckPos 		=> _mandolin.pluckPos;	// [0.0, 1.0]
	_bodySize 		=> _mandolin.bodySize; // percentage
	_stringDetune 	=> _mandolin.stringDetune; // detuning of string pair [0.0, 1.0]
}

/**
*
*/
fun void scale_gain_UGen( UGen _ugen, float _scale_gain )
{
	_ugen.gain() * _scale_gain => _ugen.gain;
}

/**
* Initialisation of STK-Instrument Mandolin
*/
fun void init_mandolin_instruments( float _scale_gain_mando )
{
	true => int bUseChorus;
	true => int bUseReverb;
	true => int bUsePitShift;
	false => int bUseEcho;
	//true => int bUseVibrato;
	
	true => int bUseEnvelope;

	1.0 / (mando.cap()) => float normalise_gain_for_mandolin_instruments;
	_scale_gain_mando *=> normalise_gain_for_mandolin_instruments;
	
	[ 
		0.80,	
		0.50,	
		1.50,	
		1.50
	] @=> gain_for_mandolins;
	[ 
		0.000,
		0.330,
		0.160,
		-0.50
	] @=> pan_for_mandolins;
	
	for( 0 => int i; i < mando.cap(); i++ )
	{
		Pan2 mandoPan;
		pan_for_mandolins[i] => mandoPan.pan;
		
		Gain mandoGain;
		gain_for_mandolins[i] => mandoGain.gain;
		scale_gain_UGen( mandoGain, normalise_gain_for_mandolin_instruments );
		
		set_mandolin_instrument( 0.10, 0.15, 0.00, mando[i] );	
		
		mandoGain 	@=> UGen endUGen;
		mando[i]	@=> UGen lastUGen;
		
		if( bUsePitShift ) 	add_fx_pitshift( 0.40, 0.15, lastUGen ) @=> lastUGen;		
		if( bUseChorus ) 	add_fx_chorus( 0.05, 0.33, 0.33, lastUGen ) @=> lastUGen;
		if( bUseReverb ) 	add_fx_reverb( 0.15, lastUGen ) @=> lastUGen;
		//if( bUseVibrato )	add_fx_vibrato( 10.0, 6.0, lastUGen ) @=> lastUGen;
		//if( bUseEcho )		add_fx_echo_chain( 0.50, 10::ms, 0.5, mandoGain );		
		if( bUseEnvelope )	set_and_add_fx_envelope( env[i], 10::ms, 0::ms, 1.00, 50::ms, lastUGen ) @=> lastUGen;

		// final ChucK links
		lastUGen => endUGen => mandoPan => master;
	}
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

//_______________________________________________________________________________
/**
*
*/
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
fun dur decode_note_value_from_string( string _s_note_value )
{
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
		1, 0, 0, 0, 0, 0, 0, 0,		0, 0, 0, 0, 0, 0, 0, 0,
		1, 0, 0, 0, 0, 0, 0, 0,		0, 0, 0, 0, 0, 0, 0, 1,
		1, 0, 0, 0, 0, 0, 0, 0,		0, 0, 0, 0, 0, 0, 0, 1,
		1, 1, 0, 0, 0, 0, 0, 0,		0, 0, 0, 0, 0, 0, 0, 0,
		1, 0, 0, 0, 1, 0, 0, 0,		1, 0, 0, 0, 1, 1, 0, 0,
		1, 0, 0, 0, 1, 0, 0, 0,		1, 0, 0, 0, 1, 1, 0, 0,
		1, 0, 0, 0, 1, 0, 0, 0,		1, 0, 0, 0, 1, 1, 0, 0,
		1, 0, 0, 0, 1, 0, 0, 0,		1, 0, 0, 0, 1, 1, 0, 0,
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
		1.00 + Std.rand2f(-0.15, 0.15) => kick[i].rate;  // higher rate => higher frequency
		0.80 + Std.rand2f(-0.05, 0.05) => hihat[i].rate; // lower rate => lower frequency
		1.00 => snare[i].rate; // normal rate
		0.75 => tomlow[i].rate; // low rate
	}
	
	1.0 / nb_instruments_drum => master_drum.gain;
	_scale_gain * master_drum.gain() => master_drum.gain;

	set_equalisation_for_drum( 0 ); // normal settings
			
	master_kick => master_drum;
	master_hihat => master_drum;	
	master_snare => master_drum;
	master_tomlow => master_drum;
		
	fill_array_dur( 0::second, array_current_note_value_instruments_drum );
	fill_array_int( false, array_current_note_is_silent_instruments_drum );
	fill_array_int( 0, array_current_id_note_for_instruments_drum );
	fill_array_dur( 0::second, array_duration_for_next_note_for_instruments_drum );	

	0 => id_current_sample_kick_drum => id_current_sample_hithat_drum => id_current_sample_snare_drum => id_current_sample_tomlow_drum;
	
	// add fx
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
		0.200 => master_hihat.gain;
		0.250 => master_kick.gain;
		0.550 => master_snare.gain;
		1.000 => master_tomlow.gain;
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
    //null @=> _wave_out;
	_wave_out.closeFile();
	<<< "Write file:", _wave_out.filename() >>>;
}

/**
*
*/
fun string find_audios_path()
{
	//
	me.dir() => string root_path; // local root path, work in miniAudicle application
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
		<<< "!!! This script will run without Drums (track) :'( !!!" >>>;
	}
		
    return result_path;
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
