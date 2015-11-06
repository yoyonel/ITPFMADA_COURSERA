// Title: Assignment_7_La_Bamba
// score.ck

now => time start;

// on the fly drumming with global BPM conducting
BPM tempo;
tempo.tempo(144.0);

[
    "instrument_guitar_solo",
    "instrument_guitar_rythm",
    "instrument_bass_osc",
    "instrument_bass_rhodey",
    //
    "instrument_drum_hihats",
    "instrument_drum_kicks",
    "instrument_drum_snares",
    "instrument_drum_toms"
] @=> string shreds_names[];

int shredID[shreds_names.cap()];

for( 0 => int i; i < shreds_names.cap(); i++)
{
    Machine.add( me.dir() + "/" + shreds_names[i] + ".ck") => shredID[i];
}

30::second => now;

for( 0 => int i; i < shreds_names.cap(); i++)
{
    Machine.remove(shredID[i]);
}

<<< "Length of this song: ", (now - start) / 1::second >>>;

<<< "Merci pour l'ecoute ! :-D" >>>;