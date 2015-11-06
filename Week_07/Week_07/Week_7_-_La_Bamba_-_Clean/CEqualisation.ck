// Title: Assignment_7_La_Bamba

public class CEqualisation
{
    Pan2 pan => dac;
    
    fun void set_pan_CEQ(float _pan) 
	{ 
		_pan => pan.pan; 
	}
	
    fun void connect_CEQ( CSampleManager _samples_manager, float _initial_gain )
    {
        update_gain( _samples_manager, _initial_gain );
        
        for( 0 => int i; i < _samples_manager.nb_samples_loaded; i++ )
        {
            _samples_manager.connectTo(pan);
            
        }
    }	
    
    fun void connect_CEQ( CSampleManager _samples_manager ) 
	{ 
		connect_CEQ( _samples_manager, 1.00 ); 
	}

	fun void connect_CEQ( UGen _in, float _initial_gain )
    {
        _in => pan;
        _initial_gain => pan.gain;
    }
	
    fun void update_gain_CEQ( CSampleManager _samples_manager )
    {    
        1.00 / _samples_manager.nb_samples_loaded => pan.gain;
    }
    
    fun void update_gain_CEQ( CSampleManager _samples_manager, float _initial_gain )
    {
        _initial_gain / _samples_manager.nb_samples_loaded => pan.gain;
    }
    
	
	// ------------------------------------------------------------------------------------------
	// FX
	// ------------------------------------------------------------------------------------------
    fun void add_reverb_CEQ( float _mix )
    {
        pan => PRCRev reverb => dac;
        _mix => reverb.mix;
    }
    fun void add_reverb_CEQ() { add_reverb_CEQ(0.2); }
	
	fun void add_delay_CEQ( UGen _in, UGen _out, dur _delay, float _gain )
	{
		// Sound chain to add feedback effect
		_in => Gain feedBack => Delay delay => _out;
		// Set the effect
		_delay => delay.max;
		_delay => delay.delay;
		// normalize the gain of feedback
		( 1.0/_in.gain() ) * _gain => feedBack.gain;
	}
	fun void add_delay_CEQ( dur _delay, float _gain ) { add_delay_CEQ( pan, pan, _delay, _gain ); }
	fun void add_delay_CEQ() { add_delay_CEQ( pan, pan, 50::ms, 0.75 ); }

	//
	fun void connect( CSampleManager _samples_manager )  { connect_CEQ(_samples_manager); }	
	fun void connect( CSampleManager _samples_manager, float _initial_gain ) { connect_CEQ(_samples_manager, _initial_gain); }
	fun void connect( UGen _in, float _initial_gain ) { connect_CEQ(_in,_initial_gain); }
	fun void set_pan(float _pan) { set_pan_CEQ(_pan); }
    fun void update_gain( CSampleManager _samples_manager ) { update_gain_CEQ(_samples_manager); }
    fun void update_gain( CSampleManager _samples_manager, float _initial_gain ) { update_gain_CEQ(_samples_manager, _initial_gain); }
    fun void add_reverb( float _mix ) { add_reverb_CEQ(_mix); }
    fun void add_reverb() { add_reverb_CEQ(); }
	fun void add_delay( UGen _in, UGen _out, dur _delay, float _gain ) { add_delay_CEQ( _in, _out, _delay, _gain ); };
	fun void add_delay( dur _delay, float _gain ) { add_delay_CEQ( _delay, _gain ); };
	fun void add_delay() { add_delay_CEQ(); };
}