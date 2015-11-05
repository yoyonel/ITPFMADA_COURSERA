// Title: Assignment_7_La_Bamba

public class CInstrumentFretsMIDI extends CScoreFretsMIDI
{
    CEqualisation m_eq;
    
    // INTERFACE
    // -> Equalisation
    fun void connect_CIFM( UGen _in, float _initial_gain ) 
	{ 
		m_eq.connect(_in, _initial_gain); 
	}
    fun void connect_CIFM( UGen _in ) 
	{ 
		m_eq.connect(_in, 1.0); 
	}
	fun CEqualisation get_eq_CIFM() 
	{ 
		return m_eq; 
	}
    fun void set_global_pan_CIFM( float _pan ) 
	{ 
		m_eq.set_pan(_pan); 
	}
	
	
	fun void connect( UGen _in, float _initial_gain )  { connect_CIFM( _in, _initial_gain ) ; }
	fun void connect( UGen _in )  { connect_CIFM(_in); }
	fun CEqualisation get_eq() { return get_eq_CIFM(); } 
	fun void set_global_pan( float _pan ) { set_global_pan_CIFM(_pan); }
}