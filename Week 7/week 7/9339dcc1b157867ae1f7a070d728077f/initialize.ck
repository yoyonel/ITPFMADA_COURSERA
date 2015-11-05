/*
Course: Music Programming
Date: 09Dec2013
Assignment #7: SomethingNice
*/

//List of files:
//score.ck  initialize.ck  
//BPM.ck    SFA.ck
//drums.ck  flute.ck  multi.ck  piano.ck


<<< "Assignment_7_SomethingNice" >>>;
// Add all classes here!
me.dir() + "/BPM.ck" => string BPMPath;
Machine.add(BPMPath);

//add SFA.ck custom class
me.dir() + "/SFA.ck" => string SFAPath;
Machine.add(SFAPath);


// add score.ck
me.dir() + "/score.ck" => string scorePath;
Machine.add(scorePath);


write_result_in_wav( me.dir() + "/output", 30::second );


/**
*
*/
fun void write_result_in_wav( string _filename, dur _length_record )
{
	dac => WvOut2 w => blackhole;
	_filename => w.wavFilename;
	1 => w.record;
	_length_record => now;
	0 => w.record;
	w.closeFile();
}