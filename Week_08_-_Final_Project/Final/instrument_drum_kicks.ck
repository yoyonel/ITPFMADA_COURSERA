// Title: Final-Projet_Tekufah
// kick.ck

// volume for this instrument
0.55 => float volume;
// local reverb fx
0.20 => float fx_reverb;

// Instance of Drum Instrument
// kick is a drum instrument
CInstrumentDrum kick;

// names of (drum) samples
[ "kick_01", "kick_02", "kick_04", "kick_05" ] @=> string names_wavs_kick[];

// add these samples to our manager samples for this (drum) instrument
kick.add_samples(names_wavs_kick);
// connect the samples manager to the EQualisation (manager)
kick.connect(volume);
// Add fx to our instrument
kick.get_eq().add_reverb(fx_reverb);
kick.get_eq().add_delay( 750::ms, 0.95 );
kick.get_eq().add_fades_in_out( 2::second, 4::second, 60::second );
// set global panoramic
kick.set_global_pan(-0.10);

// Define the score for this instrument
int riffs_drum[7][0];
// Kick riffs for this composition
kick.create_drum_bar_from_score( [ "B", "Q.", "B", "Q.", "S", "Q.", "S", "Q." ], riffs_drum[1] ); // riff 1
kick.create_drum_bar_from_score( [ "B", "Q.", "B", "Q.", "B", "Q", "S", "Q", "S", "Q" ], riffs_drum[2] ); // riff 2
kick.create_drum_bar_from_score( [ "B", "Q.", "B", "Q.", "B", "E", "B", "E", "S", "Q", "S", "Q" ], riffs_drum[3] ); // riff 3
kick.create_drum_bar_from_score( [ "B", "Q.", "B", "Q.", "B", "E", "B", "E", "S", "E", "B", "E", "S", "Q" ], riffs_drum[4] ); // riff 4
kick.create_drum_bar_from_score( [ "B", "Q.", "B", "Q.", "B", "E", "S", "Q", "S", "Q", "B", "E" ], riffs_drum[5] ); // riff 5
kick.create_drum_bar_from_score( [ "B", "Q.", "B", "Q.", "S", "Q", "S", "Q", "B", "E", "B", "E" ], riffs_drum[6] ); // riff 6

// Score kick-drum part
[
	1, 2, 1, 3, 2, 3, 1, 4, 1, 5,
	2, 6, 1, 5, 1, 1, 1, 1, 1, 1,
	1, 4, 1, 5, 2, 6, 1, 5, 1, 1,
	1, 1, 2, 6
] @=> int kick_score[];

// Compose/create the score
for( 0 => int i; i < kick_score.cap(); i++ )
{
	kick.add_bar( riffs_drum[kick_score[i]] );
}

// The rythmic signature is: 6/4, 6 quarter for 1 bar
6*4 => int nb_beat_per_bar;

// (Main) Loop for Kick
0 => int id_bar;
while (1)  
{
    // play a measure of sixteenth note kicks
    for (0 => int beat; beat < nb_beat_per_bar; beat++)  
    {
        kick.play( id_bar, beat );
    }
    //
    id_bar ++;
}