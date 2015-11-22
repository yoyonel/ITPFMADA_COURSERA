// kick.ck

CInstrumentDrum snare;

snare.set_tempo(144); 

[ 
    "snare_03", 
    "snare_03", 
    "snare_02", 
    "snare_01"
] @=> string name_wav_snare[];

<<< "snare.add_samples(name_wav_snare): ", snare.add_samples(name_wav_snare) >>>;
snare.connect( 1.00 / 4 );

[ 4 ] @=> int score_drum_intro_bar_1[];
[ 0, 2, 3, 4, 5, 6, 8, 9, 10, 11 ] @=> int score_drum_intro_bar_2[];
[ score_drum_intro_bar_1, score_drum_intro_bar_2 ] @=> int score_drum_intro[][];
//
<<< "snare.add_bars( score_drum_intro ): ", snare.add_bars( score_drum_intro ) >>>;
<<< "snare.add_bar_repeat( score_drum_intro_bar_1, 15 ): ", snare.add_bar_repeat( score_drum_intro_bar_1, 15 ) >>>;

0 => int beat;
0 => int id_bar;

while (1)  
{
    // play a measure of sixteenth note kicks
    for (0 => int beat; beat < 16; beat++)  
    {
        snare.play( id_bar, beat );
    }
    //
    id_bar ++;
}