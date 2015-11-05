// Title: Assignment_7_La_Bamba
// kick.ck

0.0250 => float gain;

CInstrumentDrum hihat;

//hihat.set_tempo(144); 

[ "hihat_03", "hihat_03", "hihat_02", "hihat_01", "hihat_04" ] @=> string names_wavs_hihat[];

hihat.add_samples(names_wavs_hihat);
hihat.connect(gain);

[ 0, 4, 8, 10, 14 ] @=> int score_drum_bar_1[];
[ 2, 6, 8, 10, 12 ] @=> int score_drum_bar_2[];
//
[ score_drum_bar_1, score_drum_bar_2 ] @=> int score_drum[][];
hihat.add_bar(score_drum_bar_2);
hihat.add_bars_repeat( score_drum, 8 );

0 => int id_bar;

while (true)
{
    // play a measure of sixteenth note kicks
    for (0 => int beat; beat < 16; beat++)  
    {
        hihat.play( id_bar, beat );
    }
    //
    id_bar ++;
}