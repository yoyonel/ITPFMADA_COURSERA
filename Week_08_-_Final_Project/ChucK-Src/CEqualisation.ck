// Title: Final-Projet_Tekufah

// Class to deal with:
// - Equalisation
// - Adding FX
// A instance of this class is present in every instruments
public class CEqualisation
{
	// Sound chain
	// Master: pan2, deal with globals volume and panoramic
	// fades_inout: manage fades in out for instrument (don't work perfectly :-/ )
	Pan2 master => ADSR fades_inout => dac;

	// pre-initialisation of fade-in/out
	fades_inout.set( 0::second, 0::second, 1.0, 0::second);
	fades_inout.keyOn();
	
	// Sound chain
	// local master/pan for CEqualisation
	// help to deal with FX later (need to clean !)
	// obscur inheritance of 'old' code :-p
	Pan2 pan => master;		
    
	// ------------------------------------------------------------------------
	// - Methods/Functions -
	// ------------------------------------------------------------------------
	
	// Set global pan for equalisation
    fun void set_pan_CEQ(float _pan) 
	{ 
		_pan => pan.pan; 
	}
	
	// Connect samples manager to our equalisation sound chain
	// manager initial gain for normalize the gain of the samples manager
    fun void connect_CEQ( CSampleManager _samples_manager, float _initial_gain )
    {
        update_gain( _samples_manager, _initial_gain );
        
        for( 0 => int i; i < _samples_manager.nb_samples_loaded; i++ )
        {
            _samples_manager.connectTo(pan);
            
        }
    }	
    
	// Connect samples manager to our equalisation sound chain
	// default initial gain = 1.00
    fun void connect_CEQ( CSampleManager _samples_manager ) 
	{ 
		connect_CEQ( _samples_manager, 1.00 ); 
	}

	// Connect generic UGen to our equalisation sound chain
	// use initial gain
	fun void connect_CEQ( UGen _in, float _initial_gain )
    {
        _in => pan;
        _initial_gain => pan.gain;
    }
	
	
	// Normalize the gain for samples manager (depend of the number of samples loaded)
    fun void update_gain_CEQ( CSampleManager _samples_manager )
    {    
        1.00 / _samples_manager.nb_samples_loaded => pan.gain;
    }
    
	// Normalize the gain for samples manager (depend of the number of samples loaded)
	// with initial gain for normalisation (scale)
    fun void update_gain_CEQ( CSampleManager _samples_manager, float _initial_gain )
    {
        _initial_gain / _samples_manager.nb_samples_loaded => pan.gain;
    }
    
	
	// ------------------------------------------------------------------------------------------
	// FX : manage FX
	// ------------------------------------------------------------------------------------------
	
	// Add reverb FX on sound chain
    fun void add_reverb_CEQ( float _mix )
    {
        //pan => PRCRev reverb => dac;
		pan => PRCRev reverb => master;
        _mix => reverb.mix;
    }
    fun void add_reverb_CEQ() { add_reverb_CEQ(0.2); }
	
	// Add delay FX on sound chain
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
	
	// Add fades in-out on sound chain
	fun void add_fades_in_out( dur _fade_in, dur _fade_out, dur _length_song )
	{
		// set the effect
		fades_inout.set( _fade_in, 0::second, 1.00, _fade_out );
		//<<< "FX: fade-in ..." >>>;
		// activate fade in
		fades_inout.keyOn();
		// use spork to check the end of the composition
		// and activate the fade out in the right time (end - time to fade out)
		spork ~ fade_out( fades_inout, _length_song );
	}
	
	// method useful in spork invocation
	// to check if it's time to apply a fade out on this composition (on this instrument)
	fun void fade_out( ADSR _env, dur _length )
	{
		// compute the time need to wait before launching the fade out (outro)
		_length - _env.releaseTime() => dur wait_time_for_launch_fade_out;
		// wait this time
		wait_time_for_launch_fade_out => now;
		// launch the fade-out
		_env.keyOff();
	}
	
	
	// ------------------------------------------------------------------------
	// Hard to deal with inheritance and overloading
	// This part is to manage manually and avoid issues
	// using a local name with suffix: CEQ - Class EQualisation
	// and a generic name (overloading) for inheritance (but depend of the inclusions ... so not very stable functionality)
	// ------------------------------------------------------------------------	
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