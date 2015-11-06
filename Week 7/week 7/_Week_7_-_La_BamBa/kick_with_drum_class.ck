// kick.ck

CInstrumentDrum kick;

kick.set_tempo(144); 

[ 
    "kick_04", 
    "kick_02" 
] @=> string name_wav_kicks[];

<<< "kick.add_samples(name_wav_kicks): ", kick.add_samples(name_wav_kicks) >>>;
kick.connect( 1.00 / 4 );

[ 0, 6, 8, 14 ] @=> int score_drum_intro_bar_1[];
[ 6, 8 ] @=> int score_drum_main_bar_2[];
//
[ score_drum_intro_bar_1, [7, 9] ] @=> int score_drum_intro[][];
[ score_drum_intro_bar_1, score_drum_main_bar_2 ] @=> int score_drum_main_riff[][];

<<< "kick.add_bars( score_drum_intro ): ", kick.add_bars( score_drum_intro ) >>>;
<<< "kick.add_bars_repeat( score_drum_main_riff, 8 ): ", kick.add_bars_repeat( score_drum_main_riff, 8 ) >>>;

0 => int beat;
0 => int id_bar;

while (1)  
{
    // play a measure of sixteenth note kicks
    for (0 => int beat; beat < 16; beat++)  
    {
        kick.play( id_bar, beat );
    }
    //
    id_bar ++;
}