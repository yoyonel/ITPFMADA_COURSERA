// Title: Final-Projet_Tekufah

// Class derived from CInstrumentMIDI
public class CBassRhodeyMIDI extends CInstrumentMIDI
{

	// ------------------------------------------------------------------------
	// Members + Constructor
	// ------------------------------------------------------------------------
	
	// STK Rhody instrument for our instrument
    Rhodey keyboard;
    	
    float freq;
    
    0 => int offset_midi_scale;
        
    preset(0);

    fun void set_preset_0_CBRM()
    {
        0 => keyboard.freq;
        1.0 => keyboard.noteOff;
        
        env.set(5::ms, 0::ms, 1.00, 5::ms);
        
        0 => offset_midi_scale;
    }
        
    fun void connect_CBRM( float _gain )
    {
        keyboard => env;
        connect(env, _gain);
    }

    fun void connect_CBRM()
    {
        connect_CBRM(1.0);
    }
    
    fun void set_note_from_midi_CBRM( int _midi_note )
    {
        Std.mtof( _midi_note + offset_midi_scale*12 ) => freq;
        freq => keyboard.freq;
    }
    
    // no mechanism to call parent method/function (with overloading)
    // need to have a different name (i.e prototype)
    fun void play_CBRM()
    {
        update_CBRM();
        // call the parent-class 'play' method
        play_CSM();
    }
    
    fun void update_CBRM()
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
                set_note_from_midi_CBRM( get_current_note_midi(i) );
				// random attack for this note
                Math.random2f( 0.5, 1.0) => keyboard.noteOn;
                1 => env.keyOn;
            }
            else if( release_note(i) )
            {
                1 => env.keyOff;
            }
        }
    }
	
	// ------------------------------------------------------------------------
	// Hard to deal with inheritance and overloading
	// This part is to manage manually and avoid issues
	// using a local name with suffix: CBRM - Class Bass Rhodey MIDI
	// and a generic name (overloading) for inheritance (but depend of the inclusions ... so not very stable functionality)
	fun void set_preset_0() { set_preset_0_CBRM(); }
}