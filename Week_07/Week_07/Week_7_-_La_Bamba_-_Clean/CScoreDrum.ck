// Title: Assignment_7_La_Bamba

public class CScoreDrum
{
    BPM m_tempo;
    fun void set_tempo(int _tempo) { m_tempo.tempo(_tempo); };
    
    32 => static int MAX_BARS;
    16 => static int MAX_BEATS;
    
    0 => int nb_bars_loaded;
    
    int score[MAX_BARS][MAX_BEATS];
    
    fun int add_bar( int _score_bar[] )
    {
        0 => int result;
        if( nb_bars_loaded < MAX_BARS )
        {
            if( _score_bar.cap() < MAX_BEATS )
            {
                _score_bar @=> score[nb_bars_loaded];
                nb_bars_loaded++;
                1 => result;
            }
        }
        
        return result;
    }
    
    fun int add_bars( int _score_bars[][] )
    {
        0 => int result;
        0 => int cur_id_bar;
        0 => int nb_bars_added;
        while( nb_bars_loaded < MAX_BARS && cur_id_bar < _score_bars.cap() )
        {            
            add_bar( _score_bars[cur_id_bar] ) +=> nb_bars_added;
            cur_id_bar++;
        }
        //<<< "nb_bars_added: ", nb_bars_added >>>;
        //<<< "_score_bars.cap(): ", _score_bars.cap() >>>;
        if( nb_bars_added == _score_bars.cap() )
            1 => result;
        
        return result;
    }
    
    fun int add_bars_repeat( int _score_bars[][], int _nb_repeat )
    {
        0 => int id_repeat;
        while( id_repeat < _nb_repeat && add_bars(_score_bars) )
            id_repeat++;
        return 1;
    }
    
    fun int add_bar_repeat( int _score_bar[], int _nb_repeat )
    {
        0 => int id_repeat;
        while( id_repeat < _nb_repeat && add_bar(_score_bar) )
            id_repeat++;
        return 1;
    }

    fun int test_for_playing( int _id_bar, int _id_beat )
    {
        false => int b_result_test;
        
        if( _id_bar < nb_bars_loaded )
        {
            score[_id_bar].size() => int max_tests;
            0 => int id_test;
            while( !b_result_test && (id_test < max_tests) )
            {
                //<<< score_drum[_id_bar][id_test], _id_beat  >>>;
                (score[_id_bar][id_test] == _id_beat) => b_result_test;
                id_test ++;
            }
        }
        //<<< "b_result_test:", b_result_test >>>;
        return b_result_test;
    }
}