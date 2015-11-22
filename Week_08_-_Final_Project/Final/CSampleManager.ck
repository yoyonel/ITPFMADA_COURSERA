// Title: Final-Projet_Tekufah

public class CSampleManager
{
	// ------------------------------------------------------------------------
	// Members + Constructor
	// ------------------------------------------------------------------------
	
	// Number of samples in the same time
    8 => static int MAX_SAMPLES;

	// path for audio wav files
    //me.dir(-1) + "/audio/" => string path_audio;
    Std.getenv("CHUCK_DATA_PATH") + "/audio/" => string path_audio;

	
	// array to store the name of the samples
    string name_wavs[MAX_SAMPLES];
	// nb samples loaded
    0 => int nb_samples_loaded;
    
	// id current sample
    0 => int id_cur_sample;
    
	// array to store the SoundBuffer for the samples
    SndBuf sndbufs[MAX_SAMPLES];
	
	// current rate for samples (global parameter, class scope)
	1.0 => float cur_rate;

    
	// ------------------------------------------------------------------------
	// - Methods/Functions -
	// ------------------------------------------------------------------------
	
	//
	// Read a sample
	// load the sample identify by the _id_sample
	// return:
	// - true: if the sample is loaded (and not empty)
	// - false: if fail => problem
    fun int read_sample( int _id_sample )
    {        
        false => int b_result;
        if( _id_sample < MAX_SAMPLES )
        {
            path_audio + name_wavs[_id_sample] + ".wav" => sndbufs[_id_sample].read;
            if( sndbufs[_id_sample].samples() > 0 )
            {
                true => b_result;
                sndbufs[_id_sample].samples() => sndbufs[_id_sample].pos;
				cur_rate => sndbufs[_id_sample].rate;
            }
            sndbufs[_id_sample].samples() > 0 => b_result;
        }
        return b_result;
    }
    
	//
	// Add a sample to our manager
	// we pass the name of the file
	// return: ...
    fun int add_sample( string _name_wav )
    {
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
    
	//
	// Add multiples samples to our manager
	// we pass a array of names of samples
	// return: ...
    fun int add_samples( string _names_wavs[] )
    {
        true => int b_result;
        for( 0 => int i; i < _names_wavs.cap(); i ++ )
        {
            add_sample(_names_wavs[i]) &=> b_result;
        }
        return b_result;
    }
    
	// Connect samples (loaded) to UGen out (can be: dac, master, pan, ...)
	// Useful to deal with generic Chuck components
    fun void connectTo( UGen _out )
    {
        for( 0 => int i; i < nb_samples_loaded; i++ )
        {
            sndbufs[i] => _out;
        }
    }
    
	// Reset the position of a sample to begin to play
	// i.e. .pos = 0 (begin of the audio file)
    fun void reset_pos_sample( int _id_sample )
    {
        0 => sndbufs[_id_sample % nb_samples_loaded].pos;
    }
    
	// Update id for sample
	// i.e. +1 to index
    fun void update_sample()
    {
        id_cur_sample ++;
    }
    
	// Play the current sample
	// Reset the position, i.e. go to the beginning
	// and update the index sample, i.e. next index sample in 'circular map' of index
    fun void play_sample()
    {
        reset_pos_sample(id_cur_sample);
        update_sample();
    }
}
