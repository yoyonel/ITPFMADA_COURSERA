// take us to your leader (talk into the mic)
// gewang, prc

// n channels
dac.channels() => int N;
// print
<<< "dac has", N, "channels..." >>>;

// our patch - feedforward part
adc => Gain g;

// set delays
for( int i; i < N; i++ )
{
    // feedfoward
    g => dac.chan(i);
}

// set parameters
0.75 => g.gain;

// time loop
while( true ) 1::samp => now;
