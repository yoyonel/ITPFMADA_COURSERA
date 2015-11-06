public class CInstrument
{
    CScoreDrum m_score;
    CEqualisation m_eq;
    CSampleManager m_samples_manager;
    
    // INTERFACE
    // -> Score
    fun int add_bar( int _score_bar[] ) { return m_score.add_bar(_score_bar); }
    fun int add_bars( int _score_bars[][] ) { return m_score.add_bars(_score_bars); }
    fun int add_bars_repeat( int _score_bars[][], int _nb_repeat ) { return m_score.add_bars_repeat(_score_bars,_nb_repeat); }
    fun int add_bar_repeat( int _score_bar[], int _nb_repeat ) { return m_score.add_bar_repeat(_score_bar,_nb_repeat); }
    fun int test_for_playing( int _id_bar, int _id_beat ) { return m_score.test_for_playing(_id_bar, _id_beat); }
    // -> Sample Manager
    fun int read_sample( int _id_sample ) { return m_samples_manager.read_sample(_id_sample); }
    fun int add_sample( string _name_wav ) { return m_samples_manager.add_sample(_name_wav); }
    fun int add_samples( string _names_wavs[] ) { return m_samples_manager.add_samples(_names_wavs); }
    fun void reset_pos_sample( int _id_sample ) { return m_samples_manager.reset_pos_sample(_id_sample); }
    fun void connectTo( UGen _out ) { m_samples_manager.connectTo(_out); }
    fun void update_sample() { m_samples_manager.update_sample(); }
    fun void play_sample() { m_samples_manager.play_sample(); }
    // -> Equalisation
    fun void connect(float _initial_gain) { return m_eq.connect(m_samples_manager, _initial_gain); }
    fun void connect() { return m_eq.connect(m_samples_manager); }
    fun void updateGain() { return m_eq.updateGain(m_samples_manager); }
    
}