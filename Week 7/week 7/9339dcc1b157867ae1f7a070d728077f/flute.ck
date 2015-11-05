/*
Course: Music Programming
Date: 09Dec2013
Assignment #7: SomethingNice
*/

// flute.ck
// Our famous headliner flute solo (with EFX)
Flute solo => JCRev rev => dac;
0.1 => rev.mix;
solo => Delay d => d => rev;
0.8 :: second => d.max => d.delay;
0.5 => d.gain;
0.5 => solo.gain;

// shared scale data
[48, 50, 52, 53, 55, 57, 59, 60] @=> int scale[]; 

// then our main loop headliner flute soloist
while (1)  {
    (Math.random2(1,5) * 0.2) :: second => now;
    if (Math.random2(0,3) > 1) {
        Math.random2(0,scale.cap()-1) => int note;
        Math.mtof(24+scale[note])=> solo.freq;
        Math.random2f(0.3,1.0) => solo.noteOn;
    }
    else 1 => solo.noteOff;
}
