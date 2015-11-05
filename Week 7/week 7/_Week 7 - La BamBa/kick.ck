// kick.ck

me.dir(-1) + "/audio/" => string path_audio;

[ 
    "kick_04", 
    "kick_04" 
] @=> string name_wav_kicks[];

name_wav_kicks.cap() => int nb_samples;

// on the fly drumming with global BPM conducting
SndBuf sndbuf_kicks[nb_samples];

Gain gain_kicks => dac;

// EQ
1.0 / nb_samples => gain_kicks.gain;

for( 0 => int i; i < nb_samples; i++ )
{
    path_audio + name_wav_kicks[i] + ".wav" => sndbuf_kicks[i].read;
    sndbuf_kicks[i] => gain_kicks;
}

// make a conductor for our tempo 
// this is set and updated elsewhere
BPM tempo;

tempo.tempo(144);

0 => int id_bar;

[ 0, 6, 8, 14 ] @=> int score_drum_intro_bar_1[];
[ 6, 8 ] @=> int score_drum_main_bar_2[];
[
    // Intro
    score_drum_intro_bar_1, [7, 9],
    // Main Riff
    score_drum_intro_bar_1, score_drum_main_bar_2,
    score_drum_intro_bar_1, score_drum_main_bar_2,
    score_drum_intro_bar_1, score_drum_main_bar_2,
    score_drum_intro_bar_1, score_drum_main_bar_2,
    score_drum_intro_bar_1, score_drum_main_bar_2,
    score_drum_intro_bar_1, score_drum_main_bar_2,
    score_drum_intro_bar_1, score_drum_main_bar_2,
    score_drum_intro_bar_1, score_drum_main_bar_2
    // Outro
    // empty: no kick for outro
] @=> int score_drum[][];

0 => int id_sample;

while (1)  
{
    // update our basic beat each measure
    tempo.sixteenthNote => dur sixteenth;

    // play a measure of sixteenth note kicks
    for (0 => int beat; beat < 16; beat++)  
    {
        if( activate_drum(id_bar, beat, score_drum) )
        {
            0 => sndbuf_kicks[id_sample % nb_samples].pos;
            id_sample ++;
        }
        
        sixteenth => now;
    }
    
    id_bar ++;
}    
    
fun int activate_drum( int _id_bar, int _id_beat, int _score_drum[][] )
{
    false => int b_result_test;
    if( _id_bar < _score_drum.cap() )
    {
        _score_drum[_id_bar].size() => int max_tests;
        0 => int id_test;
        while( !b_result_test && (id_test < max_tests) )
        {
            (_score_drum[_id_bar][id_test] == _id_beat) => b_result_test;
            id_test ++;
        }
    }
    return b_result_test;
}
