// Title: Assignment_7_La_Bamba

public class CSampleManager
{
    8 => static int MAX_SAMPLES;

    //0 => int nb_samples;

    //me.dir(-1) + "/audio/" => string path_audio;
    Std.getenv("CHUCK_DATA_PATH") + "/audio/" => string path_audio;
    

    string name_wavs[MAX_SAMPLES];
    0 => int nb_samples_loaded;
    
    0 => int id_cur_sample;
    
    SndBuf sndbufs[MAX_SAMPLES];
    
    fun int read_sample( int _id_sample )
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
                //sndbufs[_id_sample] => gain;
                //1.00 / (_id_sample+1) => gain.gain;
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
            if( read_sample(nb_samples_loaded) )
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
    
    fun void connectTo( UGen _out )
    {
        for( 0 => int i; i < nb_samples_loaded; i++ )
        {
            sndbufs[i] => _out;
        }
    }
    
    fun void reset_pos_sample( int _id_sample )
    {
        0 => sndbufs[_id_sample % nb_samples_loaded].pos;
    }
    
    fun void update_sample()
    {
        id_cur_sample ++;
    }
    
    fun void play_sample()
    {
        reset_pos_sample(id_cur_sample);
        update_sample();
    }
}
