// Title: Assignment_7_La_Bamba
// tom.ck

0.050 => float gain;

CInstrumentDrum tom;

[ "click_05", "click_01", "clap_01", "kick_02" ] @=> string names_wavs_tom[];

tom.add_samples(names_wavs_tom);
tom.connect(gain);

[ 15, 14, 13, 12 ] @=> int score_drum_intro_bar_2[];
// Score for Tom
tom.add_bar( score_drum_intro_bar_2 );

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