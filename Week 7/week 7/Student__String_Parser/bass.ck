// bass.ck
public class Bass {
    // bass with gnarly distortion
    // Sin + Saw played at 1 octave interval
    Mix2 m;
    SinOsc s => NRev r => Gain g => m.left;
    SawOsc t => r => g => m.right;
    
    // balance the gains
    0 => s.freq => t.freq;
    .1 => r.mix;
    .8 => r.gain;
    .04 => s.gain => t.gain;
    .38 => g.gain;
    .6 => m.gain;
    
    public void connect( UGen u ) 
    {
        m.left => u;
        m.right => u;
    }

    public void bass( int tone, dur noteTime ) 
    {
        Std.mtof(tone) => s.freq;
        Std.mtof(tone - 12) => t.freq;
        (noteTime / 1.5) => now;
        0 => s.freq => t.freq;
        
    }
}

