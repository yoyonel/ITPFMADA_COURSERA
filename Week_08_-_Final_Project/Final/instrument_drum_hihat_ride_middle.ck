// Title: Final-Projet_Tekufah
// kick.ck

// volume for this instrument
0.15 => float gain;
// local reverb fx
0.05 => float fx_reverb;

// Instance of Drum Instrument
// ride_middle is a drum instrument
CInstrumentDrum ride_middle;

// names of (drum) samples
[ "hihat_03" ] @=> string names_wavs_ride_middle[];
// add these samples to our manager samples for this (drum) instrument
ride_middle.add_samples(names_wavs_ride_middle);
// connect the samples manager to the EQualisation (manager)
ride_middle.connect(gain);
// Add fx to our instrument
ride_middle.get_eq().add_reverb(fx_reverb);
ride_middle.get_eq().add_fades_in_out( 5::second, 4::second, 60::second );
// set global panoramic
ride_middle.set_global_pan(-0.10);

// Define the score for this instrument
int riffs_drum[5][0];
// Ride_Middle riffs for this composition
ride_middle.create_drum_bar_from_score( [ "S", "Q", "S", "Q", "S", "Q", "S", "Q", "S", "Q", "S", "Q" ], riffs_drum[0] ); // riff 0 : empty
ride_middle.create_drum_bar_from_score( [ "S", "Q", "S", "Q", "S", "Q", "S", "Q", "B", "E", "S", "E", "S", "Q" ], riffs_drum[1] ); // riff 1
ride_middle.create_drum_bar_from_score( [ "S", "Q", "S", "Q", "S", "Q", "S", "Q", "S", "Q", "B", "E", "S", "E" ], riffs_drum[2] ); // riff 2
ride_middle.create_drum_bar_from_score( [ "S", "Q", "S", "Q", "B", "Q", "S", "Q", "S", "Q", "S", "Q" ], riffs_drum[3] ); // riff 3
ride_middle.create_drum_bar_from_score( [ "S", "Q", "S", "Q", "S", "Q", "S", "Q", "B", "Q", "S", "Q" ], riffs_drum[4] ); // riff 4

// Score ride_middle-drum part
[
	0, 0, 0, 1, 2, 0, 0, 0, 0, 1,
	0, 2, 0, 0, 3, 4, 3, 4, 0, 0,
	0, 0, 2, 1, 0, 2, 0, 0, 3, 4,
	0, 0, 0, 0
] @=> int ride_middle_score[];

// Compose/create the score
for( 0 => int i; i < ride_middle_score.cap(); i++ )
{
	ride_middle.add_bar( riffs_drum[ride_middle_score[i]] );
}

// The rythmic signature is: 6/4, 6 quarter for 1 bar
6*4 => int nb_beat_per_bar;

0 => int id_bar;
while (1)  
{
    // play a measure of sixteenth note kicks
    for (0 => int beat; beat < nb_beat_per_bar; beat++)  
    {
        ride_middle.play( id_bar, beat );
    }
    //
    id_bar ++;
}