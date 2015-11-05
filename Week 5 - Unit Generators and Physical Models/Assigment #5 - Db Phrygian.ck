Gain master => dac;
0.25 => master.gain;

//_______________________________________________________________________________
131 => int nb_notes_for_instru_1;
//
int array_dates_instru_1[nb_notes_for_instru_1];
int array_midi_notes_instru_1[nb_notes_for_instru_1];
int array_durations_instru_1[nb_notes_for_instru_1];
//
load_instrument_1();

208 => int nb_notes_for_instru_2;
//
int array_dates_instru_2[nb_notes_for_instru_2];
int array_midi_notes_instru_2[nb_notes_for_instru_2];
int array_durations_instru_2[nb_notes_for_instru_2];
//
load_instrument_2();

98 => int nb_notes_for_instru_3;
//
int array_dates_instru_3[nb_notes_for_instru_3];
int array_midi_notes_instru_3[nb_notes_for_instru_3];
int array_durations_instru_3[nb_notes_for_instru_3];
//
load_instrument_3();

[ 
	array_dates_instru_1, 
	array_dates_instru_2, 
	array_dates_instru_3
] @=> int array_dates_instruments[][];
[ 
	array_midi_notes_instru_1, 
	array_midi_notes_instru_2, 
	array_midi_notes_instru_3 
] @=> int array_midi_notes_instruments[][];
[ 
	array_durations_instru_1, 
	array_durations_instru_2, 
	array_durations_instru_3 
] @=> int array_durations_instruments[][];

array_dates_instruments.cap() => int nb_instruments;

SinOsc oscillators[nb_instruments];
ADSR envs[nb_instruments];

for( 0 => int i; i < oscillators.cap(); i++ )
{
	oscillators[i] => envs[i] => master;
	0.0 => oscillators[i].gain;
}

80 => int BPM;
60::second / (BPM $ float) => dur quarter_duration;

480 => int TPQ; // Ticks Per Quarter
quarter_duration / (TPQ $ float) => dur tick_duration;
//<<< tick_duration / 1::samp >>>;

2 => int nb_samp_for_1_tick;
tick_duration / nb_samp_for_1_tick => dur step_time_for_ChucK;
0 => int compteur_samp;

0 => int id_instrument;

int id_note[nb_instruments];
int play_note[nb_instruments];
int current_duration_for_midi_note[nb_instruments];
time time_for_Release[nb_instruments];
for( 0 => int i; i < id_note.cap(); i++ )
{	
	0 => id_note[i] => play_note[i] => current_duration_for_midi_note[i];
}

0.5 => float gain_for_midi_play;

//_______________________________________________________________________________
// MAIN
// // uncomment this lines (below) 
// // if you want to save the result of this composition in a wav file (can be useful to study the wav form of my sound)
WvOut2 wav_out2;
write_audio_in_wav( wav_out2, "test_assigment_5" );

now => time start;
0 => int current_tick;
//24960 => int endPart;
5000 => int endPart;
while( current_tick < endPart )
{	
	//for( 0 => int i; i < nb_instruments; i++ )
	for( 2 => int i; i < 3; i++ )
	{
		play_midi_instrument( 
			i, current_tick, id_note, 
			array_dates_instruments, array_midi_notes_instruments, array_durations_instruments, 
			current_duration_for_midi_note,
			time_for_Release,
			oscillators, envs, play_note 
		);
		update_midi_instrument( 
			i, play_note, 
			current_duration_for_midi_note,
			time_for_Release,
			oscillators, envs
		);
	}
	
	// Subdivision du pas de temps (midi engine) pour la discrétisation de la courbe wav par ChucK
	Std.ftoi( Math.floor(tick_duration / 1::samp) * 0.5 ) => int nb_samp_for_1_tick;
	tick_duration / (nb_samp_for_1_tick $ float ) => dur step_time_for_ChucK;
	for( 0 => int i; i < nb_samp_for_1_tick; i++ )
		step_time_for_ChucK => now ;	// advanced time for ChucK	
	
	current_tick++;			// advanced tick/time for midi engine
}

<<< "fini" >>>;

// // uncomment this line to save the result in wav file (can work without the line)
end_write_audio_in_wav( wav_out2 );

//_______________________________________________________________________________

fun void play_midi_instrument(	
	int _id_instrument,	// IN
	int _current_tick,	// IN
	int _id_note[],	// IN-OUT
	int _array_dates_instruments[][],	// IN
	int _array_midi_notes_instruments[][],	// IN
	int _array_durations_instruments[][],	// IN
	int _duration_for_midi_note[],	// OUT
	time _time_for_Release[],
	SinOsc _oscillators[],	// OUT
	ADSR _envs[],	// OUT
	int _play_note[]	// OUT
)
{
	// ALIAS (for reading)
	_id_note[_id_instrument] @=> int id_note;
	_array_dates_instruments[_id_instrument] @=> int array_dates[];
	_array_midi_notes_instruments[_id_instrument] @=> int array_midi_notes[];
	_array_durations_instruments[_id_instrument] @=> int array_durations[];
	
	// Time to play a new note ?
	if( array_dates[id_note] == _current_tick )
	{
		1 => _play_note[_id_instrument]; // play a note			
		
		Std.mtof( array_midi_notes[id_note] ) + 12*4 => _oscillators[_id_instrument].freq;
		1.0 => _oscillators[_id_instrument].gain;
		
		array_durations[id_note] => _duration_for_midi_note[_id_instrument];
		
		_duration_for_midi_note[_id_instrument] * tick_duration => dur dur_note;
		
		//
		0.075 => float ratio_attack_timing; // [0.075 -> 1.000]
		0.330 => float ratio_release_timing; // [0.05 -> 0.85]
		1.0 - (ratio_attack_timing+ratio_release_timing) => float ratio_decay_timing;
		//		
		( dur_note * ratio_attack_timing, dur_note * ratio_decay_timing, 0.25, dur_note * ratio_release_timing ) => _envs[_id_instrument].set;

		// compute the timing to activate the release key (keyOff) (Decrease)
		compute_timing_for_release_envelope( _envs[_id_instrument], dur_note ) => _time_for_Release[_id_instrument];

		1 => envs[_id_instrument].keyOn; // activate the enveloppe (Attack-Release-Stay)
		<<< "[ENVELOPE] - Key On -" >>>;		
		
		_id_note[_id_instrument]++;		
		array_midi_notes.cap() %=> _id_note[_id_instrument];			
	}
}

fun void update_midi_instrument(
	int _id_instrument,	// IN
	int _play_note[],	// IN-OUT
	int _duration_for_midi_note[],	// IN-OUT
	//int _duration_for_env[],	// IN-OUT	
	time _time_for_Release[],
	SinOsc _oscillator[],	// OUT
	ADSR _envs[]	// OUT
)
{		
	if( _play_note[_id_instrument] )
	{
		if( _envs[_id_instrument].state() == 2 && 
			now >= _time_for_Release[_id_instrument] )
		{			
			1 => _envs[_id_instrument].keyOff;		
			<<< "[ENVELOPE] - Key Off -" >>>;
		}
		if( _duration_for_midi_note[_id_instrument] == 0 )
		{
			0	=> _play_note[_id_instrument];			
			0.0 => _oscillator[_id_instrument].gain;
			<<< "[OSCILATOR] - Silence -" >>>;
		}
		
		_duration_for_midi_note[_id_instrument]--;
	}
}

fun void load_instrument_1()
{
	[ 
	 0, 240, 360, 600, 720, 960, 1200, 1320, 1440, 1680, 1800, 1920, 2160, 2280, 2520, 2640, 2880, 3120, 3240, 3360, 3600, 3720, 3840, 4080, 4200, 4440, 4560, 4800, 5040, 5160, 5280, 5520, 5640, 5760, 6000, 6120, 6360, 6480, 6720, 6960, 7080, 7200, 7440, 7560, 7680, 7920, 8040, 8280, 8520, 8640, 9000, 9120, 9360, 9480, 9600, 9840, 9960, 10200, 10440, 10560, 10920, 11040, 11160, 11280, 11400, 11520, 11760, 11880, 12120, 12360, 12480, 12840, 12960, 13200, 13320, 13440, 13680, 13800, 14040, 14280, 14400, 14760, 14880, 15000, 15120, 15240, 15360, 15600, 15720, 15960, 16200, 16320, 16680, 16800, 17040, 17160, 17280, 17520, 17640, 17880, 18120, 18240, 18600, 18720, 18840, 18960, 19080, 19200, 19440, 19560, 19800, 20040, 20160, 20520, 20640, 20760, 20880, 21000, 21120, 21480, 21840, 22080, 22800, 22920, 23040, 23400, 23760, 24000, 24360, 24720, 24840
	] @=> array_dates_instru_1;
	[ 
	 25, 32, 37, 32, 37, 38, 37, 35, 37, 32, 32, 25, 32, 37, 32, 37, 38, 37, 35, 37, 32, 25, 23, 30, 35, 30, 35, 37, 35, 33, 35, 30, 30, 23, 30, 35, 30, 35, 37, 35, 37, 32, 30, 32, 25, 32, 37, 37, 38, 40, 38, 40, 38, 37, 25, 32, 37, 37, 38, 40, 38, 40, 37, 38, 32, 25, 32, 37, 37, 38, 40, 38, 40, 38, 37, 25, 32, 37, 37, 38, 40, 38, 40, 37, 38, 32, 25, 32, 37, 37, 38, 40, 38, 40, 38, 37, 25, 32, 37, 37, 38, 40, 38, 40, 37, 38, 32, 25, 32, 37, 37, 38, 40, 38, 40, 37, 38, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37
	] @=> array_midi_notes_instru_1;
	[ 
	 240, 120, 240, 120, 240, 240, 120, 120, 240, 120, 120, 240, 120, 240, 120, 240, 240, 120, 120, 240, 120, 120, 240, 120, 240, 120, 240, 240, 120, 120, 240, 120, 120, 240, 120, 240, 120, 240, 240, 120, 120, 240, 120, 120, 240, 120, 240, 240, 120, 360, 120, 240, 120, 120, 240, 120, 240, 240, 120, 360, 120, 120, 120, 120, 120, 240, 120, 240, 240, 120, 360, 120, 240, 120, 120, 240, 120, 240, 240, 120, 360, 120, 120, 120, 120, 120, 240, 120, 240, 240, 120, 360, 120, 240, 120, 120, 240, 120, 240, 240, 120, 360, 120, 120, 120, 120, 120, 240, 120, 240, 240, 120, 360, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120
	] @=> array_durations_instru_1;
}

fun void load_instrument_2()
{
	[ 
	 0, 120, 240, 360, 480, 600, 720, 840, 960, 1080, 1200, 1320, 1440, 1560, 1680, 1800, 1920, 2040, 2160, 2280, 2400, 2520, 2640, 2760, 2880, 3000, 3120, 3240, 3360, 3480, 3600, 3720, 3840, 3960, 4080, 4200, 4320, 4440, 4560, 4680, 4800, 4920, 5040, 5160, 5280, 5400, 5520, 5640, 5760, 5880, 6000, 6120, 6240, 6360, 6480, 6600, 6720, 6840, 6960, 7080, 7200, 7320, 7440, 7560, 7680, 7800, 7920, 8040, 8160, 8280, 8400, 8520, 8640, 8760, 8880, 9000, 9120, 9240, 9360, 9480, 9600, 9720, 9840, 9960, 10080, 10200, 10320, 10440, 10560, 10680, 10800, 10920, 11040, 11160, 11280, 11400, 11520, 11640, 11760, 11880, 12000, 12120, 12240, 12360, 12480, 12600, 12720, 12840, 12960, 13080, 13200, 13320, 13440, 13560, 13680, 13800, 13920, 14040, 14160, 14280, 14400, 14520, 14640, 14760, 14880, 15000, 15120, 15240, 15360, 15480, 15600, 15720, 15840, 15960, 16080, 16200, 16320, 16440, 16560, 16680, 16800, 16920, 17040, 17160, 17280, 17400, 17520, 17640, 17760, 17880, 18000, 18120, 18240, 18360, 18480, 18600, 18720, 18840, 18960, 19080, 19200, 19320, 19440, 19560, 19680, 19800, 19920, 20040, 20160, 20280, 20400, 20520, 20640, 20760, 20880, 21000, 21120, 21240, 21360, 21480, 21600, 21720, 21840, 21960, 22080, 22200, 22320, 22440, 22560, 22680, 22800, 22920, 23040, 23160, 23280, 23400, 23520, 23640, 23760, 23880, 24000, 24120, 24240, 24360, 24480, 24600, 24720, 24840
	] @=> array_dates_instru_2;
	[ 
	 25, 32, 37, 32, 25, 32, 37, 32, 25, 32, 37, 32, 25, 32, 37, 32, 25, 32, 37, 32, 25, 32, 37, 32, 25, 32, 37, 32, 25, 32, 37, 32, 23, 30, 35, 30, 23, 30, 35, 30, 23, 30, 35, 30, 23, 30, 35, 30, 23, 30, 35, 30, 23, 30, 35, 30, 23, 30, 35, 30, 23, 30, 35, 30, 25, 32, 37, 26, 33, 38, 33, 38, 28, 40, 35, 33, 40, 33, 38, 33, 25, 32, 37, 26, 33, 38, 33, 38, 28, 40, 35, 33, 40, 33, 38, 33, 25, 32, 37, 26, 33, 38, 33, 38, 28, 40, 35, 33, 40, 33, 38, 33, 25, 32, 37, 26, 33, 38, 33, 38, 28, 40, 35, 33, 40, 33, 38, 33, 25, 32, 37, 26, 33, 38, 33, 38, 28, 40, 35, 33, 40, 33, 38, 33, 25, 32, 37, 26, 33, 38, 33, 38, 28, 40, 35, 33, 40, 33, 38, 33, 25, 32, 37, 26, 33, 38, 33, 38, 28, 40, 35, 33, 40, 33, 38, 33, 25, 32, 37, 25, 32, 37, 25, 32, 37, 25, 37, 37, 25, 32, 37, 25, 32, 37, 25, 32, 37, 25, 32, 37, 25, 37, 37, 25, 32, 37, 25, 25
	] @=> array_midi_notes_instru_2;
	[ 
	 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120
	] @=> array_durations_instru_2;
}

fun void load_instrument_3()
{
	[ 
	 0, 240, 840, 960, 1200, 1920, 2160, 2760, 2880, 3120, 3360, 3720, 3840, 4080, 4680, 4800, 5040, 5760, 6000, 6600, 6720, 6960, 7680, 7920, 8040, 8280, 8520, 8640, 9120, 9360, 9600, 9840, 9960, 10200, 10440, 10560, 11040, 11280, 11520, 11760, 11880, 12120, 12360, 12480, 12960, 13200, 13440, 13680, 13800, 14040, 14280, 14400, 14880, 15120, 15360, 15600, 15720, 15960, 16200, 16320, 16800, 17040, 17280, 17520, 17640, 17880, 18120, 18240, 18720, 18960, 19200, 19440, 19560, 19800, 20040, 20160, 20640, 20880, 21120, 21360, 21480, 21720, 21840, 22080, 22200, 22440, 22560, 22800, 23040, 23280, 23400, 23640, 23760, 24000, 24120, 24360, 24480, 24720
	] @=> array_dates_instru_3;
	[ 
	 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 25, 25, 26, 26, 26, 28, 28, 26, 25, 25, 26, 26, 26, 28, 26, 26, 25, 25, 26, 26, 26, 28, 28, 26, 25, 25, 26, 26, 26, 28, 26, 26, 25, 25, 26, 26, 26, 28, 28, 26, 25, 25, 26, 26, 26, 28, 26, 26, 25, 25, 26, 26, 26, 28, 26, 26, 25, 26, 25, 23, 25, 26, 25, 23, 25, 25, 25, 26, 25, 23, 25, 26, 25, 23, 25, 25
	] @=> array_midi_notes_instru_3;
	[ 
	 120, 360, 120, 240, 360, 120, 360, 120, 240, 240, 240, 120, 120, 360, 120, 240, 360, 120, 360, 120, 240, 360, 240, 120, 240, 240, 120, 480, 240, 240, 240, 120, 240, 240, 120, 480, 240, 240, 240, 120, 240, 240, 120, 480, 240, 240, 240, 120, 240, 240, 120, 480, 240, 240, 240, 120, 240, 240, 120, 480, 240, 240, 240, 120, 240, 240, 120, 480, 240, 240, 240, 120, 240, 240, 120, 480, 240, 240, 240, 120, 240, 120, 240, 120, 240, 120, 240, 240, 240, 120, 240, 120, 240, 120, 240, 120, 240, 240
	] @=> array_durations_instru_3;
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
fun time compute_timing_for_release_envelope( ADSR _env, dur _dur_note )
{
	return now + ( _dur_note - _env.releaseTime() );
}
