// Title: Final-Projet_Tekufah
// initialize.ck

// Find a path to local sources
// If we are under miniAudicle, this function use me.dir()
// else we are using locals paths (Windows or Linux forms)
find_path() => string me_dir;

// List of classes using in this program
// Order is important for inclusions
[ 
	// Class for tempo
	"BPM",
	// Classes for MIDI scores, manage (and play) midi datas (1)
	"CScoreMIDI", "CScoreFretsMIDI", "CScoreDrum",
	// Class for samples wav
	"CSampleManager", 
	// Class for equalisation, (global) control paning
	"CEqualisation",
	// Classes (derived for (1)) for MIDI instruments (2)
	"CInstrumentDrum", "CInstrumentMIDI", "CInstrumentFretsMIDI",
	// Implementations of (2) for different kind of MIDI instruments
	"CBassRhodeyMIDI", "CKeyboardRhodeyMIDI", "CKeyboardBeeThreeMIDI",
	"CGuitarMandolinMIDI", "CBassOscMIDI",
	"CSaxofonyMIDI", "CClarinetMIDI",
	// the socre of this song
	"score"
] @=> string classes_framework[];
	
// Loading the classes into VM-ChucK
for( 0 => int i; i < classes_framework.cap(); i++ )
{
	add_ck_into_machine( classes_framework[i], me_dir );
}

/**
* Find a path to local source of this program
*/
fun string find_path()
{
	// ask to ChucK environement the local path
	// if we are under miniAudicle, me.dir() return the local path (where we invoke 'miniAudicle' at the first time)
	me.dir() => string path;
	//<<< "me.dir():", me.dir() >>>;
	
	// but if we are under a local-server of VM-ChucK ('chuck --loop')
	// me.dir() == "", and we have no information about the local path
	if( path == "" )
	{
		// We need to specify by hand (or other manual method) the 'good' path
		//
		// On Linux: local path
		//"/media/atty/Seagate Expansion Drive1/__SOUND__/__COURSERA__/Introduction to Programming for Musicians and Digital Artists/Week 7/week 7/Week 7 - La Bamba - Clean" => path;
		// On Windows: local path
		//"F:/__SOUND__/__COURSERA__/Introduction to Programming for Musicians and Digital Artists/Week 8 - Final Project/ChucK-Src" => path;
		"F:/__SOUND__/__COURSERA__/Introduction to Programming for Musicians and Digital Artists/Week 8 - Final Project/Final" => path;
		//<<< "path:", path >>>;
	}
	// return the path
	return path;
}
/**
*	Add a shred to VM-ChucK
*/
fun void add_ck_into_machine( string _name, string _path )
{
	// build the shred filename from a _name and a _path (we add a extension '.ck')
	_path + "/" + _name + ".ck" => string filename_shred;
	// Add the shred to VM-ChucK
	Machine.add(filename_shred);
}
