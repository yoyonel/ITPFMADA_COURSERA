// Title: Final-Projet_Tekufah

// Class derived/extent from CScoreDrum
public class CInstrumentDrum extends CScoreDrum
{
	// Instances of: Equalisation and samples manager
    CEqualisation m_eq;
    CSampleManager m_samples_manager;    
    
	// Play the instrument drum
    fun void play( int _id_bar, int _id_beat )
    {
        // update our basic beat each measure
        m_tempo.sixteenthNote => dur sixteenth;
        // need to play a sample/beat drum ?
        if( test_for_playing( _id_bar, _id_beat) )
        {
			// Play the sample/beat drum (use the sample manager)
            m_samples_manager.play_sample();
        }
        // Consume time for VM-ChucK audio rendering
        sixteenth => now;
    }
	
    // INTERFACE
    // -> Sample Manager
    fun int read_sample( int _id_sample ) { return m_samples_manager.read_sample(_id_sample); }
    fun int add_sample( string _name_wav ) { return m_samples_manager.add_sample(_name_wav); }
    fun int add_samples( string _names_wavs[] ) { return m_samples_manager.add_samples(_names_wavs); }
    fun void reset_pos_sample( int _id_sample ) { return m_samples_manager.reset_pos_sample(_id_sample); }
    fun void connectTo( UGen _out ) { m_samples_manager.connectTo(_out); }
    fun void update_sample() { m_samples_manager.update_sample(); }
    fun void play_sample() { m_samples_manager.play_sample(); }
	fun void set_rate( float _rate ) { _rate => m_samples_manager.cur_rate; }
    // -> Equalisation
    fun CEqualisation get_eq() { return m_eq; }
    fun void connect(float _initial_gain) { return m_eq.connect(m_samples_manager, _initial_gain); }
    fun void connect() { return m_eq.connect(m_samples_manager); }
    fun void updateGain() { return m_eq.update_gain(m_samples_manager); }    
	
	// Set the global panaramic for this instrument drum
	fun void set_global_pan_CID( float _pan ) { m_eq.set_pan(_pan); }	
	fun void set_global_pan( float _pan ) { set_global_pan_CID(_pan); }
}