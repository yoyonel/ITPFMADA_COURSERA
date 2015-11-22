public class CBassRhodeyMIDI extends CInstrumentMIDI
{
    Rhodey keyboard;
    
    float freq;
    
    0 => int offset_midi_scale;
    
    set_preset_0();
    
    fun void preset( int _preset )
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
    
    fun void set_preset_0()
    {
        0 => keyboard.freq;
        1.0 => keyboard.noteOff;
        
        env.set(5::ms, 0::ms, 1.00, 5::ms);
        
        0 => offset_midi_scale;
    }
        
    fun void connect( float _gain )
    {
        keyboard => env;
        connect(env, _gain);
    }

    fun void connect()
    {
        this.connect(1.0);
    }
    
    fun void set_note_from_midi( int _midi_note )
    {
        Std.mtof( _midi_note + offset_midi_scale*12 ) => freq;
        
        freq => keyboard.freq;
        
        //<<< "current_tick: ", cur_tick, "_midi_note: ", _midi_note, "- freq:", freq >>>;
    }
    
    // no mechanism to call parent method/function (with overloading)
    // need to have a different name (i.e prototype)
    fun void _play()
    {
        //<<< this, "-> play()" >>>;
        
        update();
        
        // call the parent-class 'play' method
        play();
    }
    
    fun void update()
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
                Math.random2f( 0.5, 1.0) => keyboard.noteOn;
                1 => env.keyOn;
            }
            else if( release_note(i) )
            {
                1 => env.keyOff;
            }
        }
    }
}