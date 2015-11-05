WvOut2 wav_out2;
write_audio_in_wav( wav_out2, "test_mandolin" );

Gain master => dac ;
0.50 => master.gain;

Mandolin mando;
Gain mandoGain;
//
PitShift pshift;
Chorus chorus;
NRev rev;

false => int bUseChorus;
false => int bUseReverb;
false => int bUsePitShift;
false => int bUseEcho;

mandoGain @=> UGen endUGen;
mando @=> UGen lastUGen;
	
if( bUsePitShift )
{
	// PitShift Effect
	0.33 => pshift.shift;
	0.90 => pshift.mix;
	//
	lastUGen => pshift;
	pshift @=> lastUGen;
}

if( bUseChorus )
{
	// Chorus Effect
	0.66 => chorus.mix;
	0.33 => chorus.modFreq;
	0.33 => chorus.modDepth;
	//
	lastUGen => chorus;
	chorus @=> lastUGen;
}

if( bUseReverb )
{
	// Reverb
	0.5 => rev.mix;
	//
	lastUGen => rev;
	rev @=> lastUGen;
}
	
if( bUseEcho )
{
	// Echo Effect sur l'instru sans effets
	mandoGain => Gain mandoGainFeedBack => Echo echo => mandoGain;
	0.50 => mandoGainFeedBack.gain;
	0.10::second => echo.max => echo.delay;
	0.66 => echo.mix;
}

// final ChucK links
lastUGen => endUGen => master;

440 / 4 => mando.freq;

0.50 => mando.pluckPos;	// [0.0, 1.0], varie la frequence et le gain (l'énergie de l'attaque)
0.25 => mando.bodySize; // percentage
0.00 => mando.stringDetune; // detuning of string pair [0.0, 1.0]

1.0 => mando.noteOn; // pluck strings : velocity [0.0, 1.0]
1.0::second => now; 

0.0001 => mando.noteOff; // petite valeur pour avoir un effet d'atténuation (visible) sur la courbe wav
1.0::second => now; 

//1.00 => mando.noteOn; // pluck strings : velocity [0.0, 1.0]
//1.0::second => now; 

end_write_audio_in_wav( wav_out2 );

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
