// Title: Final-Projet_Tekufah
// kick.ck

// volume for this instrument
0.100 => float gain;
// local reverb fx
0.800 => float fx_reverb;

// Instance of Drum Instrument
// splash is a drum instrument
CInstrumentDrum splash;

// names of (drum) samples
[ "hihat_04" ] @=> string names_wavs_splash[];

// add these samples to our manager samples for this (drum) instrument
splash.add_samples(names_wavs_splash);
// connect the samples manager to the EQualisation (manager)
splash.connect(gain);
// Add fx
splash.get_eq().add_reverb(fx_reverb);
splash.get_eq().add_fades_in_out( 5::second, 4::second, 60::second );
// set global panoramic
splash.set_global_pan(-0.20);

// Define the score for this instrument
int riffs_drum[3][0];
// Splash riffs for this composition
splash.create_drum_bar_from_score( [ "S", "Q", "S", "Q", "S", "Q", "S", "Q", "S", "Q", "S", "Q" ], riffs_drum[0] ); // riff 0 : empty
splash.create_drum_bar_from_score( [ "S", "Q", "S", "Q", "S", "Q", "S", "Q", "B", "Q", "S", "Q" ], riffs_drum[1] ); // riff 1
splash.create_drum_bar_from_score( [ "S", "Q", "S", "Q", "B", "Q", "S", "Q", "S", "Q", "S", "Q" ], riffs_drum[2] ); // riff 2
// Score splash-drum part
[
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 1, 2, 1, 2, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 1, 2,
	0, 0, 0, 0
] @=> int splash_score[];
// Compose/create the score
for( 0 => int i; i < splash_score.cap(); i++ )
{
	splash.add_bar( riffs_drum[splash_score[i]] );
}

// The rythmic signature is: 6/4, 6 quarter for 1 bar
6*4 => int nb_beat_per_bar;

0 => int id_bar;
while (1)  
{
    // play a measure of sixteenth note kicks
    for (0 => int beat; beat < nb_beat_per_bar; beat++)  
    {
        splash.play( id_bar, beat );
    }
    //
    id_bar ++;
}