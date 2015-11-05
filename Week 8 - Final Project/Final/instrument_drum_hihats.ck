// Title: Final-Projet_Tekufah
// kick.ck

// volume for this instrument
0.125 => float gain;
// local reverb fx
0.05 => float fx_reverb;

// Instance of Drum Instrument
// snare is a drum instrument
CInstrumentDrum snare;

// names of (drum) samples
[ "hihat_01" ] @=> string names_wavs_snare[];
// set a local rate for samples
snare.set_rate(1.2);
// add these samples to our manager samples for this (drum) instrument
snare.add_samples(names_wavs_snare);
// connect the samples manager to the EQualisation (manager)
snare.connect(gain);
// Add fx to our instrument
snare.get_eq().add_reverb(fx_reverb);
snare.get_eq().add_fades_in_out( 4::second, 4::second, 60::second );
// set global panoramic
snare.set_global_pan(-0.15);

// Define the score for this instrument
int riffs_drum[9][0];
// snare riffs for this composition
snare.create_drum_bar_from_score( [ "B", "Q", "B", "E", "B", "Q", "B", "E", "B", "Q", "S", "E", "B", "E", "B", "E", "B", "E" ], riffs_drum[0] ); // riff 1
snare.create_drum_bar_from_score( [ "B", "Q", "B", "E", "B", "Q", "B", "E", "B", "Q", "S", "Q", "B", "Q" ], riffs_drum[1] ); // riff 2
snare.create_drum_bar_from_score( [ "B", "Q", "B", "E", "B", "Q", "B", "E", "B", "Q", "S", "Q", "B", "E", "B", "E" ], riffs_drum[2] ); // riff 3
snare.create_drum_bar_from_score( [ "B", "Q", "B", "E", "B", "Q", "B", "E", "B", "Q", "S", "Q", "S", "E", "B", "E" ], riffs_drum[3] ); // riff 4
snare.create_drum_bar_from_score( [ "B", "Q", "B", "E", "B", "Q", "B", "E", "B", "E", "B", "E", "B", "E", "S", "E", "S", "Q" ], riffs_drum[4] ); // riff 5
snare.create_drum_bar_from_score( [ "B", "Q", "B", "E", "B", "Q", "B", "E", "B", "Q", "B", "E", "S", "E", "B", "Q" ], riffs_drum[5] ); // riff 6
snare.create_drum_bar_from_score( [ "B", "Q", "B", "Q", "S", "Q", "B", "E", "B", "E", "S", "Q", "B", "Q" ], riffs_drum[6] ); // riff 7
snare.create_drum_bar_from_score( [ "B", "Q", "B", "Q", "S", "Q", "B", "E", "B", "E", "S", "Q", "B", "Q" ], riffs_drum[7] ); // riff 8
snare.create_drum_bar_from_score( [ "B", "Q", "B", "E", "B", "Q", "B", "E", "B", "Q", "B", "Q", "B", "Q" ], riffs_drum[8] ); // riff 9
// Score hihat-drum part
[
	0, 1, 2, 3, 4, 5, 2, 1, 4, 3,
	0, 4, 1, 0, 6, 7, 6, 7, 8, 8,
	2, 1, 4, 3, 0, 4, 1, 0, 6, 7,
	1, 1, 1, 1
] @=> int hihat_score[];
// Compose/create the score
for( 0 => int i; i < hihat_score.cap(); i++ )
{
	snare.add_bar( riffs_drum[hihat_score[i]] );
}

// The rythmic signature is: 6/4, 6 quarter for 1 bar
6*4 => int nb_beat_per_bar;

0 => int id_bar;
while (1)  
{
    // play a measure of sixteenth note kicks
    for (0 => int beat; beat < nb_beat_per_bar; beat++)  
    {
        snare.play( id_bar, beat );
    }
    //
    id_bar ++;
}