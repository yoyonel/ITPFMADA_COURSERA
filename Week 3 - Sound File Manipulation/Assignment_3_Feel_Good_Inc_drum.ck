true => int bSaveTheSongInWavFile;
WvOut w;
if( bSaveTheSongInWavFile )
{
    // url: http://chuck.cs.princeton.edu/doc/examples/basic/rec-auto-stereo.ck
    // pull samples from the dac
    // WvOut2 -> stereo operation
    dac => w => blackhole;

    // copie locale du wav (gros fichier potentiel)
    "C:/Users/atty/Music/__COURSERA__/" => string path_for_saving_wav_file;
    
    path_for_saving_wav_file + "Assessment3-" => w.autoPrefix;
    
    "special:auto" => w.wavFilename;
    
    <<<"writing to file: ", w.filename()>>>;
    
    // temporary workaround to automatically close file on remove-shred
    null @=> w;
}

//
me.dir() + "/audio/" => string path;

8 => int NB_MAX_SAMPLES_PER_SEC;

Gain master => dac;
//
Gain master_kick => master;
Gain master_hihat => master;
Gain master_hihat_break => master;
Gain master_snare => master;
Gain master_clap => master;
//
SndBuf kick[NB_MAX_SAMPLES_PER_SEC];
SndBuf hihat[NB_MAX_SAMPLES_PER_SEC];
SndBuf hihat_break[NB_MAX_SAMPLES_PER_SEC];
SndBuf snare[NB_MAX_SAMPLES_PER_SEC];
SndBuf clap[NB_MAX_SAMPLES_PER_SEC];
//
for( 0 => int i; i < NB_MAX_SAMPLES_PER_SEC; i++ )
{
    kick[i] => master_kick;
    hihat[i] => master_hihat;
    hihat_break[i] => master_hihat_break;
    snare[i] => master_snare;
    clap[i] => master_clap;
    
    path + "kick_04.wav" => kick[i].read;
    path + "hihat_02.wav" => hihat[i].read;
    path + "hihat_03.wav" => hihat_break[i].read;
    path + "snare_01.wav" => snare[i].read;
    path + "cowbell_01.wav" => clap[i].read;
    
    kick[i].samples() => kick[i].pos;
    hihat[i].samples() => hihat[i].pos;
    hihat_break[i].samples() => hihat_break[i].pos;
    snare[i].samples() => snare[i].pos;
    clap[i].samples() => clap[i].pos;

    0.45 => kick[i].rate;  // lower rate => lower frequency
    1.00 => hihat[i].rate; // normal rate
    0.75 => hihat_break[i].rate; // normal rate
    1.25 => snare[i].rate; // faster rate => higher frequency
    1.00 => clap[i].rate;
}

0.125 => master_hihat.gain;
0.800 => master_hihat_break.gain;
1.000 => master_kick.gain;
1.000 => master_snare.gain;
0.250 => master_clap.gain;
//
0.5*0.14 => master.gain;

0 => int counter;

[ 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0 ] @=> int bar_1_hithat_eighth[];
[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] @=> int bar_1_hithat_break_eighth[];
[ 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 ] @=> int bar_1_snare_eighth[];
[ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 ] @=> int bar_1_kick_eighth[];

//
[ 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0 ] @=> int bar_2_hithat_break_eighth[];
[ 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0 ] @=> int bar_2_snare_eighth[];
[ 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0 ] @=> int bar_2_kick_eighth[];

//
[ 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0 ] @=> int bar_3_hithat_break_eighth[];
[ 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0 ] @=> int bar_3_snare_eighth[];
[ 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0 ] @=> int bar_3_kick_eighth[];

[ 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0 ] @=> int bar_4_hithat_eighth[];
//
[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 ] @=> int bar_4_snare_eighth[];
[ 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0 ] @=> int bar_4_kick_eighth[];

//
//
[ 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 ] @=> int bar_5_snare_eighth[];
[ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 ] @=> int bar_5_kick_eighth[];

[ 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0 ] @=> int bar_clap_eighth[];

[ 
    bar_1_hithat_eighth, 
    bar_1_hithat_eighth,
    bar_1_hithat_eighth,
    bar_1_hithat_eighth,
    bar_1_hithat_eighth
] @=> int bars_hithat[][];

[ 
    bar_1_hithat_break_eighth, 
    bar_2_hithat_break_eighth,
    bar_3_hithat_break_eighth,
    bar_1_hithat_break_eighth,
    bar_1_hithat_break_eighth//,
] @=> int bars_hithat_break[][];

[ 
    bar_1_snare_eighth, 
    bar_2_snare_eighth,
    bar_3_snare_eighth,
    bar_4_snare_eighth,
    bar_5_snare_eighth//,
] @=> int bars_snare[][];

[ 
    bar_1_kick_eighth, 
    bar_2_kick_eighth,
    bar_3_kick_eighth,
    bar_4_kick_eighth,
    bar_5_kick_eighth//,
] @=> int bars_kick[][];

[
    bar_clap_eighth,
    bar_clap_eighth,
    bar_clap_eighth,
    bar_clap_eighth,
    bar_clap_eighth
] @=> int bars_clap[][];
    

// 
Math.min( bars_hithat.cap(), 
    Math.min(  bars_hithat_break.cap(), 
        Math.min( bars_snare.cap(), 
            Math.min( bars_clap.cap(), bars_kick.cap() ) 
        ) 
    ) 
) $ int => int min_bars;
        
-1 => int counter_bars;

0 => int id_cur_sample_hihat;
0 => int id_cur_sample_hihat_break;
0 => int id_cur_sample_snare;
0 => int id_cur_sample_kick;
0 => int id_cur_sample_clap;

now => time start;

while( (now-start) < 30::second )
{
    counter % 16 => int beat_eighth;
    (counter/2) % 8 => int beat;    
    
    !beat_eighth +=> counter_bars;
    min_bars %=> counter_bars;
    //4 => counter_bars;

    /**
    0 => int id_cur_sample_hihat;
    0 => int id_cur_sample_hihat_break;
    0 => int id_cur_sample_snare;
    0 => int id_cur_sample_kick;
    0 => int id_cur_sample_clap;
    /**/
    
    //
    if( bars_hithat[counter_bars][beat_eighth] )
    {
        0 => hihat[id_cur_sample_hihat].pos;
        (id_cur_sample_hihat+1) % NB_MAX_SAMPLES_PER_SEC => id_cur_sample_hihat;
    }
    if( bars_hithat_break[counter_bars][beat_eighth] )
    {
        0 => hihat_break[id_cur_sample_hihat_break].pos;
        (id_cur_sample_hihat_break+1) % NB_MAX_SAMPLES_PER_SEC => id_cur_sample_hihat_break;
    }
    if( bars_snare[counter_bars][beat_eighth] )
    {
        0 => snare[id_cur_sample_snare].pos;
        (id_cur_sample_snare+1) % NB_MAX_SAMPLES_PER_SEC => id_cur_sample_snare;
    }
    if( bars_kick[counter_bars][beat_eighth] )
    {
        0 => kick[id_cur_sample_kick].pos;    
        (id_cur_sample_kick+1) % NB_MAX_SAMPLES_PER_SEC => id_cur_sample_kick;
    }
    //
    if( bars_clap[counter_bars][beat_eighth] )
    {
        0 => clap[id_cur_sample_clap].pos;
        (id_cur_sample_clap+1) % NB_MAX_SAMPLES_PER_SEC => id_cur_sample_clap;
    }
    
    counter++;
    
    //<<< beat >>>;
    
    (250.0/2.0)::ms => now;
    //(250.0/4.0)::ms => now;
}

if( bSaveTheSongInWavFile )
{
    //w.closeFile;
}