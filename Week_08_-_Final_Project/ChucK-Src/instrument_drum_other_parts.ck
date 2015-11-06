// Title: Final-Projet_Tekufah
// other_parts.ck

// volume for this instrument
0.075 => float volume;
// local reverb fx
0.90 => float fx_reverb;

// Instance of Drum Instrument
// 'other parts' is a drum instrument
CInstrumentDrum other_parts;

// names of (drum) samples
[ "snare_01", "hihat_01", "hihat_03", "hihat_04" ] @=> string names_wavs_other_parts[];

// add these samples to our manager samples for this (drum) instrument
other_parts.add_samples(names_wavs_other_parts);
// connect the samples manager to the EQualisation (manager)
other_parts.connect(volume);
// Add fx to our instrument
other_parts.get_eq().add_reverb(fx_reverb);
other_parts.get_eq().add_fades_in_out( 10::second, 4::second, 60::second );
// set global panoramic
other_parts.set_global_pan(-0.15);

// Define the score for this instrument
int riffs_drum[9][0];
// 'other parts' riffs for this composition
other_parts.create_drum_bar_from_score( [ "S", "Q", "S", "Q", "S", "Q", "S", "Q", "S", "Q", "S", "Q" ], riffs_drum[0] ); // riff 0 : empty
other_parts.create_drum_bar_from_score( [ "S", "Q.", "S", "Q.", "B", "E", "B", "E", "B", "Q", "B", "Q" ], riffs_drum[1] ); // riff 1
other_parts.create_drum_bar_from_score( [ "S", "Q.", "S", "Q.", "S", "Q", "B", "Q", "B", "Q" ], riffs_drum[2] ); // riff 2
other_parts.create_drum_bar_from_score( [ "S", "Q.", "S", "Q.", "B", "E", "B", "E", "B", "E", "B", "E", "B", "Q" ], riffs_drum[3] ); // riff 3
other_parts.create_drum_bar_from_score( [ "S", "Q.", "S", "Q.", "S", "Q", "B", "E", "B", "E", "B", "Q" ], riffs_drum[4] ); // riff 4
other_parts.create_drum_bar_from_score( [ "S", "Q.", "S", "Q.", "S", "Q", "B", "E", "B", "E", "B", "E", "B", "E" ], riffs_drum[5] ); // riff 5
other_parts.create_drum_bar_from_score( [ "S", "Q.", "S", "Q.", "B", "E", "B", "E", "B", "Q", "B", "E", "S", "E" ], riffs_drum[6] ); // riff 6
other_parts.create_drum_bar_from_score( [ "S", "Q.", "S", "Q.", "S", "Q", "B", "E", "B", "E", "B", "E", "S", "E" ], riffs_drum[7] ); // riff 7
other_parts.create_drum_bar_from_score( [ "S", "Q.", "S", "Q.", "S", "Q", "B", "E", "S", "E", "B", "Q" ], riffs_drum[8] ); // riff 8

// Score other_parts-drum part
[
	1, 2, 1, 3, 4, 5, 1, 4, 1, 6,
	4, 6, 1, 7, 0, 0, 0, 0, 0, 0,
	1, 8, 1, 7, 4, 6, 1, 7, 0, 0,
	1, 1, 4, 6
] @=> int other_parts_score[];

// Compose/create the score
for( 0 => int i; i < other_parts_score.cap(); i++ )
{
	other_parts.add_bar( riffs_drum[other_parts_score[i]] );
}

// The rythmic signature is: 6/4, 6 quarter for 1 bar
6*4 => int nb_beat_per_bar;

// (Main) Loop for other_parts
0 => int id_bar;
while (1)  
{
    // play a measure of sixteenth note other_partss
    for (0 => int beat; beat < nb_beat_per_bar; beat++)  
    {
        other_parts.play( id_bar, beat );
    }
    //
    id_bar ++;
}