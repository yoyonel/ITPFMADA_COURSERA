<<< " William Dilworth - beatmaker@sbcglobal.net " >>>;
<<< " Funky stereo with drums.ck - 10/26/13 " >>>;

/* Took some code I typed up while reading the book,
edited it and threw it together with this. Hell yeah. */

// SndBufs for kick and snare
SndBuf kick => Gain master => dac;
SndBuf snare => master;

// load up some samples of those

"C:/Program Files (x86)/ChucK/examples/book/digital-artists/chapter3/audio/kick_01.wav" => kick.read;
"C:/Program Files (x86)/ChucK/examples/book/digital-artists/chapter3/audio/snare_01.wav" => snare.read;

snare.samples() => snare.pos;
kick.samples() => kick.pos;

0.5 => master.gain;

fun void bd (int a)
{
    if (a==1)
    {
        // Beat 1, play kick drum alone
        0 => kick.pos;

    }
}

fun void sn (int a)
{
    if (a==1)
    {
        // Beat 1, play snare drum alone
        0 => snare.pos;

    }
}

<<< " William Dilworth - beatmaker@sbcglobal.net " >>>;
<<< " Funky stereo with drums.ck - 10/26/13 " >>>;

/* This is no way intended to be funky, despite the name */

/* Single SawOsc fed into left and right chorus, each with 
differnt mod amounts, making the sound stereo.*/

SawOsc s => LPF lowpass => NRev verb => Chorus chorL => Gain gL => dac.left;
verb => Chorus chorR => Gain gR => dac.right;

0.6 => gL.gain => gR.gain;

SinOsc lfo => blackhole;

0.025 => verb.mix;

0.01 => chorL.mix;
35 => chorL.modFreq;
0.8 => chorL.modDepth;

0.01 => chorL.mix;
35 => chorL.modFreq;
0.9 => chorL.modDepth;

75 => float mult;
225 => float base;
0.3 => lfo.freq;
2 => lowpass.Q;


0.469 * second => dur quarter;
quarter * 1/2 => dur eighth;
quarter * 1/4 => dur sixteenth;
quarter * 1/8 => dur thirtysecond;

/* int a chooses our midi note. int b chooses our duration (4/8/16/32).
mult is our lfo amount, lfo.last() grabs the last sample of the SinOsc
lfo. Sampling 100 times per note; resolution varies based on our note
length */
fun void funkon (int a, int b)
{
    Std.mtof(a) => s.freq;
    0.5 => s.gain;
    
    
    if (b == 4)
    {
        for (0 => int i; i < 100; i++)
        {
            mult * lfo.last() + base => lowpass.freq;
            quarter / 100 => now;
        }
    }
    if (b == 8)
    {
        for (0 => int i; i < 100; i++)
        {
            mult * lfo.last() + base => lowpass.freq;
            eighth / 100 => now;
        }
    }
    if (b == 16)
    {
        for (0 => int i; i < 100; i++)
        {
            mult * lfo.last() + base => lowpass.freq;
            sixteenth / 100 => now;
        }
    }
      if (b == 32)
    {
        for (0 => int i; i < 100; i++)
        {
            mult * lfo.last() + base => lowpass.freq;
            thirtysecond / 100 => now;
        }
    }
    
}

/* Off notes function */

fun void funkoff (int b)
{
    0.0 => s.gain;
    
    if (b == 4)
    {
        quarter => now;
    }
    if (b == 8)
    {
        eighth => now;
    }
    if (b == 16)
    {
        sixteenth => now;
    }
      if (b == 32)
    {
        thirtysecond => now;
    }
    
}

/* So here's the riff... it's messy and could be a lot cleaner
for readability, but it's getting late and this is just an 
expirement from a noob at programming. I change the verb manually
throughout the riff to get some pseudo modulation. It was popping 
a lot more before I added the in between verb.mix value changes,
like 0.07 => verb.mix; . I also threw in some lfo.freq adjustments
to vary the lfo at the end of the while (true) */
fun void riff (int a)
{
    while (true)
    {
        0.3 => lfo.freq;
        
        0.09 => verb.mix; bd (1); funkon (25, 8); 0.07 => verb.mix; funkon (25, 16); 0.05 => verb.mix;  funkoff (16);

        0.04 => verb.mix; bd (1); sn (1); funkon (25, 8); 0.02 => verb.mix; bd (1); funkon (25, 16); 0.00 => verb.mix; funkoff (16);

        bd (1); funkon (25, 8); funkon (27, 8); 

        bd (1); sn (1);funkon (27, 16); funkon (27, 16); funkon (27, 16); funkoff (16); 
        
        
        0.04 => verb.mix; bd (1); funkon (25, 8); funkon (25, 16); 0.03 => verb.mix; funkoff (16);

        0.02 => verb.mix; bd (1); sn (1); funkon (25, 8); 0.01 => verb.mix;  funkon (25, 16); 0.00 => verb.mix; funkoff (16);

        bd (1);  funkon (25, 8); funkon (27, 8); 

        bd (1); sn (1); funkon (39, 16); funkon (39, 16); bd (1);  funkon (39, 16); 400 => base; funkon (27, 16); 
        
        225 => base;
        
        0.04 => verb.mix; bd (1); funkon (25, 8); funkon (25, 16); 0.03 => verb.mix; funkoff (16);

        0.02 => verb.mix; bd (1); sn (1); funkon (25, 8); 0.01 => verb.mix;  funkon (25, 16); 0.00 => verb.mix; funkoff (16);

        bd (1); funkon (25, 8); funkon (27, 8); 

        bd (1); sn (1); funkon (27, 16); funkon (27, 16);  funkon (27, 16); funkoff (16); 
        
        
        0.04 => verb.mix; bd (1); funkon (25, 8); funkon (25, 16); 0.03 => verb.mix; funkoff (16);

        0.02 => verb.mix; bd (1); sn (1); funkon (25, 8); 0.01 => verb.mix;  funkon (25, 16); 0.00 => verb.mix; funkoff (16);

        bd (1); funkon (25, 8); funkon (27, 8); 3 => lfo.freq;

        bd (1); sn (1); 0.02 => verb.mix; funkon (37, 16); 0.03 => verb.mix; funkon (37, 16); 6 => lfo.freq; 0.05 => verb.mix; bd (1); funkon (37, 16); 0.07 => verb.mix; sn (1); funkon (27, 16); 
    }
}

/*This is where all the majic happens! riff() is called*/
riff(1);
 