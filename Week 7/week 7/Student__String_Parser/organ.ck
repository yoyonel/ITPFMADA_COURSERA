// organ.ck

public class Organ
{
    NoteParser np; // expose the note parser class
    
    [ 
        [ "e5", "a5", "c6"],
        [ "e5", "g5", "c6"],
        [ "e5", "f5", "a5", "c6"],
        [ "d5", "f5", "a5", "c6"],
        [ "c5", "f5", "c6"]
    ] @=> string p[][]; // array to hold each of the chords
    
    // sound chain set up
    SawOsc s[4];
    Gain mGain;
    LPF filter;
    .2 => filter.gain;
    4 => filter.Q;
    .2 => mGain.gain;  
    
    // Attach the sound chain for this intrument to whatever the caller set up
    fun void connect( UGen ugen)
    {
        for ( 0 => int i; i < 4; i++)
        {
            s[i] => filter => mGain => ugen;
            0 => s[i].freq => s[i].gain; // while we're here, make sure there's no sound until we want it
        }
    }


    fun void play( int chord, dur t )
    {
        // Set the chord frequencies
        for (0=>int i; i < p[chord].cap(); i++) 
        {
            Std.mtof(np.parseNote(p[chord][i])) => s[i].freq;
            .15 => s[i].gain;
        }
        
        // play the chord and sweep the cutoff freqs for all the voices
        float sr;
        (now + t) => time nd;
        while ( now < (nd - 20::ms))
        {
            300 + Std.fabs(Math.sin(sr)) * 8000 => filter.freq;
            .0005 +=> sr;
            .5::ms => now;
        }
        
        // make a little separation between consecutive notes
        for (0=> int i; i < s.cap(); i++)
        {
            0 => s[i].gain => s[i].freq;
        }
        20::ms => now;
    }
}
