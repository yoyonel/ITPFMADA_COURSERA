// Title: Final-Projet_Tekufah
// score.ck

now => time start;

// on the fly drumming with global BPM conducting
BPM tempo;
tempo.tempo(200.0);

// List of instruments adding in this compostion
[
	// - Melody part : Brass	
	/**/
	"instrument_organ",
	"instrument_sax",
	"instrument_trumpet",
	// - Melodico-Rythm part : Guitar + Bass	
    "instrument_guitar_rythm", 	
	"instrument_bass_osc",
	/**/
    // - Rythmic part : Drums + 'conga' + 'clave'
	/**/
    "instrument_drum_hihats", "instrument_drum_hihat_ride_middle", "instrument_drum_hihat_splash",	
    "instrument_drum_kicks",
	"instrument_drum_clave", "instrument_drum_conga",
    "instrument_drum_other_parts"
	/**/
] @=> string shreds_names[];

// IDs for shreds
int shredID[shreds_names.cap()];

// Add to VM-ChucK differents shreds
for( 0 => int i; i < shreds_names.cap(); i++)
{
    Machine.add( me.dir() + "/" + shreds_names[i] + ".ck") => shredID[i];
}

// Play the song (or wait the playing)
60::second => now;

// Release the shreds
for( 0 => int i; i < shreds_names.cap(); i++)
{
    Machine.remove(shredID[i]);
}

// Output at the end of the program
// Check the length of this song
<<< "Length of this song: ", (now - start) / 1::second >>>;
// Thx for listenning my work ^^
<<< "Merci pour l'ecoute ! :-D" >>>;