// declare bass oscillators
TriOsc osc[3];
ADSR env => Gain o => LPF f => dac;

// set envelope 
(0.005::second, 0.7::second, 0.0, 0.0001::second) => env.set;

1.0 / 3.0 => o.gain;    // set bass gain to 0 - no sound yet  
1200  => f.freq;
10 => f.Q;

// use array to connect oscillators to master and set gains 
for ( 0 => int i; i < osc.cap(); i++ )
{
    osc[i] => env;
    1.0 / osc.cap() => osc[i].gain; 
}
// bass function 
fun void synth (int note)
{
    Std.mtof(note -12) => osc[0].freq;
    Std.mtof(note) => osc[1].freq;
    Std.mtof(note -5) => osc[2].freq;
    1 => env.keyOn;
}

while(true)
{
    synth(Math.random2(48, 72));
    0.25::second => now;
}