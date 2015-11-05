WvOut2 wav_out2;
write_audio_in_wav( wav_out2, "test_resonZ" );

Gain master => dac;
0.05 => master.gain;

1 => int nb_instruments;

Impulse impulse[nb_instruments];
ResonZ filt[nb_instruments];
ADSR env[nb_instruments];
//
for( 0 => int i; i < nb_instruments; i++ )
{	
	// chuck envelop to gain (master)
	env[i] => master;
	
	// set a envelope
	Set_Envelope( env[i], 0 );
	
	// chuck a envelop
	Add_Envelope_to_Filter( env[i], filt[i] );
	
	impulse[i] => filt[i];
}

0 => int keyOnPressOneTime;
0 => int currentNoteIsSilence;

dur dur_AttackDecay;
dur dur_Release;

time time_for_Release[nb_instruments];
1::second => dur dur_Substain;

0.625::second / 4 => dur dur_note;

1::samp => dur step_time_for_chuck;

//<<< 10::ms / step_time_for_chuck >>>;

0 => int id_current_instrument;
0 => int nb_iters;
while( (!keyOnPressOneTime || env[id_current_instrument].state() != 4) && nb_iters < 50 )
{
	//0.75::second / Math.random2f( 2, 8 ) => dur_note;
	//1::second => dur_note;
	
	update_envelopes_instruments( id_current_instrument, dur_note, filt, env, time_for_Release );

	if( keyOnPressOneTime || env[id_current_instrument].state() == 4 )
	{
		0 => keyOnPressOneTime;
		nb_iters++;
	}

	step_time_for_chuck => now ;
}
<<< "fini" >>>;

end_write_audio_in_wav( wav_out2 );

fun void Set_Envelope( ADSR _envelope, int _type_envelope )
{
	if( _type_envelope == 0 )
	{
		(50::ms, 5::ms, 0.95, 10::ms) => _envelope.set;
	}
	else
	{
		(0::ms, 0::ms, 1.0, 0::ms) => _envelope.set;
	}
}

fun void Add_Envelope_to_Filter( ADSR _envelope, ResonZ _filter )
{
	_filter => _envelope;
}

/**
*
*/
fun void update_envelopes_instruments( int _id_current_instrument, dur _dur_note, ResonZ _filter[], ADSR _env[], time _time_for_Release[] )
//fun void update_envelopes_instruments( int _id_current_instrument, dur _dur_note, PulseOsc _osc[], ADSR _env[], time _time_for_Release[] )
{
	if( env[id_current_instrument].state() == 4 ) // done
	{
		<<< "[ENVELOPE] - Key On -" >>>;
		//
		(_dur_note*0.50, _dur_note*0.20, 0.80, _dur_note*0.05) => _env[_id_current_instrument].set;
		//
		1 => _env[id_current_instrument].keyOn;
		1 => keyOnPressOneTime;
		//
		compute_timing_for_release_envelope( _env[id_current_instrument], _dur_note ) => _time_for_Release[id_current_instrument];

		Math.random2( 44*2, 88*2 ) => _filter[_id_current_instrument].freq;
		//Math.random2( 100, 400 ) => _filter[_id_current_instrument].Q;
		500 => _filter[_id_current_instrument].Q;
		50000 => impulse[_id_current_instrument].next;

		if( Math.random2(0, 10) > 5 && true )
		{
			<<< "[OSCILATOR] - Silence -" >>>;
			//0.0 => _osc[id_current_instrument].gain;
			1 => _env[id_current_instrument].keyOff;
		}
		else
		{
			//1.0 => _osc[id_current_instrument].gain;
		}
	}
	if(
		_env[id_current_instrument].state() == 2 &&
		now >= _time_for_Release[id_current_instrument]
	)
	{
		<<< "[ENVELOPE] - Key Off -" >>>;
		//
		1 => _env[id_current_instrument].keyOff;
	}
}

/**
*
*/
fun time compute_timing_for_release_envelope( ADSR _env, dur _dur_note )
{
	return now + ( _dur_note - _env.releaseTime() );
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
