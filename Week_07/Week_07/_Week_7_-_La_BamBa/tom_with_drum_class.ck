// tom.ck

CInstrumentDrum tom;

tom.set_tempo(144); 

[ 
    "click_05", 
    "click_01", 
    "clap_01", 
    "kick_02"
] @=> string name_wav_tom[];

<<< "tom.add_samples(name_wav_tom): ", tom.add_samples(name_wav_tom) >>>;
tom.connect( 1.00 / 4 );

[ 16 ] @=> int score_drum_intro_bar_1[]; // empty
[ 15, 14, 13, 12 ] @=> int score_drum_intro_bar_2[];
[ score_drum_intro_bar_1, score_drum_intro_bar_2 ] @=> int score_drum[][];
//
<<< "tom.add_bars( score_drum ): ", tom.add_bars( score_drum ) >>>;

0 => int beat;
0 => int id_bar;

while(1)  
{
    // play a measure of sixteenth note toms
    for (0 => int beat; beat < 16; beat++)  
    {
        tom.play( id_bar, beat );
    }
    //
    id_bar ++;
}