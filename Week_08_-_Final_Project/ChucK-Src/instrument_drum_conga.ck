// Title: Final-Projet_Tekufah
// conga.ck

// volume for this instrument
0.10 => float volume;
// local reverb fx
0.75 => float fx_reverb;

// instance of drum instrument
// Conga is a drum instrument
CInstrumentDrum conga;

// names of (drum) samples
[ "kick_03", "kick_03", "click_01", "click_02", "kick_03" ] @=> string names_wavs_conga[];
// add these samples to our manager samples for this (drum) instrument
conga.add_samples(names_wavs_conga);
// connect the samples manager to the EQualisation (manager)
conga.connect(volume);
// Add fx to our instrument
conga.get_eq().add_reverb(fx_reverb);
conga.get_eq().add_delay( 250::ms, 0.80 );
conga.get_eq().add_fades_in_out( 5::second, 4::second, 60::second );
// set global panoramic
conga.set_global_pan(0.05);

// Define the score for this instrument
int riffs_drum[4][0];
// Conga riffs for this composition
conga.create_drum_bar_from_score( [ "S", "Q", "S", "Q", "S", "Q", "S", "Q", "S", "Q", "S", "Q" ], riffs_drum[0] ); // riff 0 : empty
conga.create_drum_bar_from_score( [ "B", "Q", "B", "E", "B", "E", "B", "Q", "B", "Q", "B", "E", "B", "E", "B", "Q" ], riffs_drum[1] ); // riff 1
conga.create_drum_bar_from_score( [ "B", "Q", "B", "E", "B", "E", "B", "Q", "B", "Q", "B", "E", "B", "E", "B", "E", "B", "E" ], riffs_drum[2] ); // riff 2
conga.create_drum_bar_from_score( [ "B", "Q", "B", "E", "B", "E", "B", "Q", "B", "Q", "B", "E", "B", "E", "S", "E", "B", "Q" ], riffs_drum[3] ); // riff 3
// Score conga-drum part
[
	Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3),
	Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3),
	Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3),
	Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3), Math.random2(1, 3)
] @=> int conga_score[];
// Compose/create the score
for( 0 => int i; i < conga_score.cap(); i++ )
{
	conga.add_bar( riffs_drum[conga_score[i]] );
}

// Our composition rythmic signature is: 6/4, 6 quarter for 1 bar
6*4 => int nb_beat_per_bar;

// (Main) Loop for conga
0 => int id_bar;
while (1)  
{
    // play a measure of sixteenth note congas
    for (0 => int beat; beat < nb_beat_per_bar; beat++)  
    {
        conga.play( id_bar, beat );
    }
    //
    id_bar ++;
}