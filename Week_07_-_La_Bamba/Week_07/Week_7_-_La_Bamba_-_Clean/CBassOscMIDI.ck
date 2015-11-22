// Title: Assignment_7_La_Bamba

public class CBassOscMIDI extends CInstrumentMIDI
{
    SinOsc osc1;
    TriOsc osc2;
    
    float freq;
    
    0 => int offset_midi_scale;

	preset(0);

    fun void set_preset_0_CBOM()
    {
        0 => osc1.freq;
        0.5 => osc1.gain;
        0 => osc2.freq;
        0.5 => osc2.gain;
        
        env.set(5::ms, 0::ms, 1.00, 5::ms);
        
        1 => offset_midi_scale;
    }
        
    fun void connect_CBOM( float _gain )
    {
        osc1 => env;
		osc2 => env;

        connect_CIM( env, _gain );
    }

    fun void connect_CBOM()
    {
        connect_CBOM(1.0);
    }
    
    fun void set_note_from_midi_CBOM( int _midi_note )
    {
        Std.mtof( _midi_note + offset_midi_scale*12 ) => freq;
        
        freq => osc1.freq;
        freq => osc2.freq;
        
        //<<< "current_tick: ", cur_tick, "_midi_note: ", _midi_note, "- freq:", freq >>>;
    }
    
    // no mechanism to call parent method/function (with overloading)
    // need to have a different name (i.e prototype)
    fun void play_CBOM()
    {
        //<<< this, "-> play()" >>>;
        update_CBOM();        
        // call a parent-class 'play' method (CSM : CScoreMidi)
        play_CSM();
    }
    
    fun void update_CBOM()
    {
        // update the midi engine
        update_midi_engine();        

        // search the first attack note
        0 => int i;
        while( i < state.cap() && silent_note(i) )
        {
            i++;
        }
        
        if( i < state.cap() )
        {
            if( attack_note(i) )
            {
                //<<< "i:", i >>>;
                set_note_from_midi( get_current_note_midi(i) );
                1 => env.keyOn;
            }
            else if( release_note(i) )
            {
                1 => env.keyOff;
            }
        }
    }
	
	//
	//fun void preset( int _preset ) { preset_CBOM(_preset); }
    fun void set_preset_0() { set_preset_0_CBOM(); }
    fun void connect( float _gain ) { connect_CBOM(_gain); }
    fun void connect() { connect_CBOM(); }
    fun void set_note_from_midi( int _midi_note ) { set_note_from_midi_CBOM(_midi_note); }
    fun void play() { play_CBOM(); }
    fun void update() { update_CBOM(); }
}