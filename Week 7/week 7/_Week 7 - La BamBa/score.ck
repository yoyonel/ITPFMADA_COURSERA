// score.ck
// on the fly drumming with global BPM conducting
BPM tempo;
tempo.tempo(144.0);

[ 
    //
    "test_CScoreFretsMIDI",
    //
    "test_BassRhodeyMIDI",
    //
    "kick_with_drum_class",
    "snare_with_drum_class",
    "hihat_with_drum_class",
    "tom_with_drum_class"
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
