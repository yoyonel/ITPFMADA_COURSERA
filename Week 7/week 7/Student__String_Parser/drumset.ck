// drumset.ck
public class DrumSet 
{
    // define hihat
    SndBuf hihat => Gain mGain;
    me.dir(-1) + "/audio/hihat_02.wav" => hihat.read;
    hihat.samples() => hihat.pos;
        
    // Define Bassdrum
    SndBuf bassDrum => mGain;
    me.dir(-1) + "/audio/kick_03.wav" => bassDrum.read;
    bassDrum.samples() => bassDrum.pos;

    // define snare drum
    SndBuf snare => mGain;;
    me.dir(-1) + "/audio/snare_02.wav" => snare.read;
    snare.samples() => snare.pos;

    0.2 => mGain.gain;
    
    public void connect( UGen ugen ) 
    {
        mGain => ugen;
    }

    public void hh() {
        0 => hihat.pos;
    }

    public void bd() {
        0 => bassDrum.pos;
    }

    public void sn() {
        0 => snare.pos;
    }
}
