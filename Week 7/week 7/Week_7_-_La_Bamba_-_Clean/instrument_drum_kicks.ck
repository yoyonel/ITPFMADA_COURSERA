// Title: Assignment_7_La_Bamba
// kick.ck

0.15 => float volume;
0.50 => float fx_reverb;

CInstrumentDrum kick;

//kick.set_tempo(144); 

[ "kick_05", "kick_04", "kick_02" ] @=> string names_wavs_kick[];

kick.add_samples(names_wavs_kick);
kick.connect(volume);
kick.get_eq().add_reverb(fx_reverb);

[ 0, 6, 8, 14 ] @=> int score_drum_intro_bar_1[];
[ 6, 8 ] @=> int score_drum_main_bar_2[];
//
[ [7, 9] ] @=> int score_drum_intro[][];
[ score_drum_intro_bar_1, score_drum_main_bar_2 ] @=> int score_drum_main_riff[][];

// Score for Kick
kick.add_bars( score_drum_intro );
kick.add_bars_repeat( score_drum_main_riff, 8 );

// (Main) Loop for Kick
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