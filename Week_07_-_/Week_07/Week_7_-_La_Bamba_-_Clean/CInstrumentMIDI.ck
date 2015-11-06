// Title: Assignment_7_La_Bamba

public class CInstrumentMIDI extends CScoreMIDI
{
    CEqualisation m_eq;    

    fun void preset_CSM( int _preset )
    {
        if( _preset == 0 )
        {
            set_preset_0();
        }
        else
        {
            set_preset_0();
        }
    }
	//
	fun void preset( int _preset ) { preset_CSM(_preset); }    
	// Pure Virtual Method
    fun void set_preset_0_CSM() { };	fun void set_preset_0() { set_preset_0_CSM(); }
	
	// ---------------------------------
    // INTERFACES
	// ---------------------------------
    // -> Equalisation
    fun void connect_CIM( UGen _in, float _initial_gain ) 
	{ 
		m_eq.connect(_in, _initial_gain); 
	}
    fun void connect_CIM( UGen _in ) 
	{ 
		m_eq.connect(_in, 1.0); 
	}
	
	fun CEqualisation get_eq_CIM() 
	{ 
		return m_eq; 
	}
    fun void set_global_pan_CIM( float _pan ) 
	{ 
		m_eq.set_pan(_pan); 
	}
	
	// -------------------------------------------------------------------
	// Overloads -Parent/Childs classes
	// -------------------------------------------------------------------
	fun void connect( UGen _in, float _initial_gain )  { connect_CIM( _in, _initial_gain ) ; }
	fun void connect( UGen _in )  { connect_CIM(_in); }
	fun CEqualisation get_eq() { return get_eq_CIM(); } 
	fun void set_global_pan( float _pan ) { set_global_pan_CIM(_pan); }
}