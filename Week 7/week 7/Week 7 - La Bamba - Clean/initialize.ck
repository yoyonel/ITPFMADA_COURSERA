// Title: Assignment_7_La_Bamba
// initialize.ck

"/media/atty/Seagate Expansion Drive1/__SOUND__/__COURSERA__/Introduction to Programming for Musicians and Digital Artists/Week 7/week 7/Week 7 - La Bamba - Clean" => string me_dir;
//"F:/__SOUND__/__COURSERA__/Introduction to Programming for Musicians and Digital Artists/Week 7/week 7/Week 7 - La Bamba - Clean" => string me_dir;

// our conductor/beat-timer class
Machine.add( me_dir + "/BPM.ck" );

// Classes definitions
Machine.add( me_dir + "/CScoreMIDI.ck" );
Machine.add( me_dir + "/CScoreFretsMIDI.ck" );
Machine.add( me_dir + "/CScoreDrum.ck" );

Machine.add( me_dir + "/CSampleManager.ck" );
Machine.add( me_dir + "/CEqualisation.ck" );

Machine.add( me_dir + "/CInstrumentDrum.ck" );
Machine.add( me_dir + "/CInstrumentMIDI.ck" );
Machine.add( me_dir + "/CInstrumentFretsMIDI.ck" );

Machine.add( me_dir + "/CBassOscMIDI.ck" );
Machine.add( me_dir + "/CBassRhodeyMIDI.ck" );
Machine.add( me_dir + "/CKeyboardRhodeyMIDI.ck" );
Machine.add( me_dir + "/CKeyboardBeeThreeMIDI.ck" );
Machine.add( me_dir + "/CGuitarMandolinMIDI.ck" );

// our score
Machine.add( me_dir +"/score.ck" );

write_result_in_wav( "output", 30::second );

fun void write_result_in_wav( string _filename, dur _length_record )
{
	dac => WvOut2 w => blackhole;
	_filename => w.wavFilename;
	1 => w.record;
	_length_record => now;
	0 => w.record;
	w.closeFile();
}