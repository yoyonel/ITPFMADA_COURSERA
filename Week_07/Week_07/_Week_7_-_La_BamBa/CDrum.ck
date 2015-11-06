public class CDrum extends CInstrumentDrum
{    
    BPM m_tempo;
    
    fun void tempo( int _tempo )
    {
        m_tempo.tempo(_tempo);
    }
    
    fun void play( int _id_bar, int _id_beat )
    {
        // update our basic beat each measure
        m_tempo.sixteenthNote => dur sixteenth;
        
        if( test_for_playing( _id_bar, _id_beat) )
        {
            play_sample();
        }
        
        sixteenth => now;
    }
}

