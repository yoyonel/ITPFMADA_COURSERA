// Title: Assignment_7_La_Bamba
// kick.ck

0.050 => float gain;
0.800 => float fx_reverb;

CInstrumentDrum snare;

[ "snare_03", "snare_03", "snare_02", "snare_01" ] @=> string names_wavs_snare[];

snare.add_samples(names_wavs_snare);
snare.connect(gain);
snare.get_eq().add_reverb(fx_reverb);

[ 4 ] @=> int score_drum_intro_bar_1[];
[ 0, 2, 3, 4, 5, 6, 8, 9, 10, 11 ] @=> int score_drum_intro_bar_2[];
// Score for Snare
snare.add_bar(score_drum_intro_bar_2);
snare.add_bar_repeat( score_drum_intro_bar_1, 15 );

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