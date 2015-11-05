Gain master => dac ;
0.5 => master.gain;

Mandolin mando;
ADSR env;

(50::ms, 5::ms, 0.95, 10::ms) => env.set;

mando => env;

env => master;

440 => mando.freq;

1 => env.keyOn;
1.0 => mando.noteOn;
1.0::second => now ;

1 => env.keyOff;
//1.0 => mando.noteOff;
1.0::second => now ;
