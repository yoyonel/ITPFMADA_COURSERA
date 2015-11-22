public class CEqualisation
{
    Pan2 pan => dac;
    
    fun void connect( CSampleManager _samples_manager, float _initial_gain )
    {
        updateGain( _samples_manager, _initial_gain );
        
        for( 0 => int i; i < _samples_manager.nb_samples_loaded; i++ )
        {
            _samples_manager.connectTo(pan);
            
        }
    }
    
    fun void connect( CSampleManager _samples_manager ) { connect( _samples_manager, 1.00 ); }
    
    fun void updateGain( CSampleManager _samples_manager )
    {    
        1.00 / _samples_manager.nb_samples_loaded => pan.gain;
    }
    
    fun void updateGain( CSampleManager _samples_manager, float _initial_gain )
    {
        _initial_gain / _samples_manager.nb_samples_loaded => pan.gain;
    }
    
        
    fun void connect( UGen _in, float _initial_gain )
    {
        _in => pan;
        _initial_gain => pan.gain;
    }
}