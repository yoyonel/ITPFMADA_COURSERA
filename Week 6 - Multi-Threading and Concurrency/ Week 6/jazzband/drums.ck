// drums.ck

// sound chain
SndBuf hihat => dac;

find_audios_path() => string path_audios;

// me.dirUp 
//me.dir(-1) + "/audio/hihat_01.wav" => hihat.read;
path_audios + "/audio/hihat_01.wav" => hihat.read;

// parameter setup
.5 => hihat.gain;

// loop 
while( true )  
{
    Math.random2f(0.1,.3) => hihat.gain;
    Math.random2f(.9,1.2) => hihat.rate;
    (Math.random2(1,2) * 0.2) :: second => now;
    0 => hihat.pos;
}


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
	root_path => string result_path;
    
    <<< ">>> Result path for audio files: ", result_path >>>;
	
	if( root_path == "" )
	{
		<<< "!!! You need to put this script in a 'good' folder (need to access to 'audio/') !!!" >>>;
		<<< "!!! This script will run without Drums (track) :'( !!!" >>>;
	}
		
    return result_path;
}