Gain master => dac;
0.10 => master.gain;

me.dir() + "/audio/" => string path;
"kick_04.wav" => string name_of_wav;

SndBuf wav[16];

for( 0 => int i; i < wav.cap(); ++i )
{
    path + name_of_wav => wav[i].read;   // chargement d'un WAV
    
    wav[i].samples() => wav[i].pos;
    1.0 => wav[i].rate;
    1.0 => wav[i].gain;
    wav[i] => master;
}

//1::second / 64.0 => dur note_value;
1::second / 16.0 => dur note_value;
//1::second / 4.0 => dur note_value;
//1::second / 2.0 => dur note_value;

false => int use_pop_version;
true => int use_accumulate_version;

for( 0 => int i; i < wav.cap()*use_pop_version; ++i )
{
    0 => wav[0].pos;
    note_value => now;
}

for( 0 => int i; i < wav.cap()*use_accumulate_version; ++i )
{
    0 => wav[i].pos;
    note_value => now;
}