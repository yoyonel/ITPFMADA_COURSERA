// Title: Final-Projet_Tekufah
// clave.ck

// volume for this instrument
0.05 => float volume;
// local reverb fx
0.90 => float fx_reverb;

// instance of clave instrument
// is a instrument drum
CInstrumentDrum clave;

// names of (drum) samples
[ "click_02", "cowbell_01", "click_01" ] @=> string names_wavs_clave[];
// add these samples to our manager samples for this (drum) instrument
clave.add_samples(names_wavs_clave);
// connect the samples manager to the EQualisation (manager)
clave.connect(volume);
// Add fx to our instrument
clave.get_eq().add_reverb(fx_reverb);
clave.get_eq().add_delay( 750::ms, 0.95 );
clave.get_eq().add_fades_in_out( 5::second, 4::second, 60::second );
// set global panoramic
clave.set_global_pan(0.33); 

// Define the score for this instrument
int riffs_drum[5][0];
// Clave riffs for this composition
clave.create_drum_bar_from_score( [ "S", "Q", "S", "Q", "S", "Q", "S", "Q", "S", "Q", "S", "Q" ], riffs_drum[0] ); // riff 0 : empty
clave.create_drum_bar_from_score( [ "B", "Q.", "B", "Q.", "S", "E", "B", "E", "B", "E", "S", "E", "B", "E", "B", "E" ], riffs_drum[1] ); // riff 1
clave.create_drum_bar_from_score( [ "B", "Q.", "B", "Q.", "B", "E", "B", "E", "B", "E", "S", "E", "B", "E", "B", "E" ], riffs_drum[2] ); // riff 2
clave.create_drum_bar_from_score( [ "B", "Q.", "B", "Q.", "B", "E", "S", "E", "B", "E", "S", "E", "B", "E", "B", "E" ], riffs_drum[3] ); // riff 3
clave.create_drum_bar_from_score( [ "B", "Q.", "B", "Q.", "S", "Q", "B", "E", "S", "Q", "B", "E" ], riffs_drum[4] ); // riff 4
// Score clave-drum part
[
	0, 0, 1, 1, 1, 2, 3, 1, 2, 4,
	3, 1, 2, 4, 1, 2, 1, 2, 1, 1,
	3, 1, 2, 4, 3, 1, 2, 4, 1, 2,
	0, 0, 0, 0
] @=> int clave_score[];
// Compose/create the score
for( 0 => int i; i < clave_score.cap(); i++ )
{
	clave.add_bar( riffs_drum[clave_score[i]] );
}

// Our composition rythmic signature is: 6/4, 6 quarter for 1 bar
6*4 => int nb_beat_per_bar;

// (Main) Loop for clave
0 => int id_bar;
while (1)  
{
    // play a measure of sixteenth note claves
    for (0 => int beat; beat < nb_beat_per_bar; beat++)  
    {
        clave.play( id_bar, beat );
    }
    //
    id_bar ++;
}