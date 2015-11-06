public class CDrum extends CScore
{
    8 => static int MAX_SAMPLES;
    32 => static int MAX_BARS;
    16 => static int MAX_BEATS;
    
    0 => int nb_samples;
    
    me.dir(-1) + "/audio/" => string path_audio;
    
    string name_wavs[MAX_SAMPLES];
    
    Gain gain => dac;
    
    SndBuf sndbufs[MAX_SAMPLES];
    
    BPM m_tempo;
    
    int score_drum[MAX_BARS][MAX_BEATS];
    
    0 => int nb_samples_loaded;
    0 => int nb_bars_loaded;

    fun int read( int _id_sample )
    {        
        //<<< "read" >>>;
        false => int b_result;
        
        if( _id_sample < MAX_SAMPLES )
        {
            path_audio + name_wavs[_id_sample] + ".wav" => sndbufs[_id_sample].read;
            //<<< "sndbufs[_id_sample].length() :", sndbufs[_id_sample].length() / 1::second >>>;
            if( sndbufs[_id_sample].samples() > 0 )
            {
                true => b_result;
                sndbufs[_id_sample] => gain;
                1.00 / (_id_sample+1) => gain.gain;
                sndbufs[_id_sample].samples() => sndbufs[_id_sample].pos;
            }
            sndbufs[_id_sample].samples() > 0 => b_result;
        }
        
        return b_result;
    }
    
    fun int add_sample( string _name_wav )
    {
        //<<< "add_sample" >>>;
        false => int b_result;
        
        if( nb_samples_loaded < MAX_SAMPLES )
        {
            _name_wav => name_wavs[nb_samples_loaded];
            if( read(nb_samples_loaded) )
            {
                nb_samples_loaded ++;
                true => b_result;
            }
        }
        
        return b_result;
    }
    
    fun int add_samples( string _names_wavs[] )
    {
        true => int b_result;
        for( 0 => int i; i < _names_wavs.cap(); i ++ )
        {
            add_sample(_names_wavs[i]) &=> b_result;
        }
        return b_result;
    }
    
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
            0 => sndbufs[nb_samples % nb_samples_loaded].pos;
            nb_samples++;
        }
        
        sixteenth => now;
    }
}

