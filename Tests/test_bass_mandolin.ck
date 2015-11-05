// sound chain (mandolin for bass)
Mandolin bass => Dyno d => LPF f => PRCRev r => ADSR env => dac;

(10::ms, 5::ms, 0.90, 10::ms) => env.set;

// parameter setup

// low-pass filter to suppress higher mando overtone freqs & make more bass-like
200 => f.freq;
200.0 => f.Q;

// try some dynamics processing -- not sure how effective this is
d.compress();
2 => d.gain;

0.05 => r.mix;

0.05 => bass.stringDamping;
0.025 => bass.stringDetune;
0.01 => bass.bodySize;

240 => bass.freq;

repeat(10)
{
	1 => bass.noteOn;
	1 => env.keyOn;
	250::ms => now;

	1 => bass.noteOff;
	1 => env.keyOff;
	250::ms => now;
}
