public class CInstrumentFretsMIDI extends CScoreFretsMIDI
{
    CEqualisation m_eq;    
    
    // INTERFACE
    // -> Equalisation
    fun void connect( UGen _in, float _initial_gain ) { m_eq.connect(_in, _initial_gain); }
    fun void connect( UGen _in ) { m_eq.connect(_in, 1.0); }
}