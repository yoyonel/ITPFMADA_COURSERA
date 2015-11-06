public class CGuitarMandolinMIDI extends CInstrumentFretsMIDI
{
    6 => static int nb_strings;

    Mandolin mando_strings[nb_strings];
    ADSR mando_envs[nb_strings];
    Pan2 mando_gains[nb_strings];
    
    0 => int offset_midi_scale;
    
    float freqs[nb_strings];
    for( 0 => int i; i<nb_strings; i++) 0.0 => freqs[i];

    set_preset_0();
    
    int midi_chords[0][nb_strings]; // array of chords
    
    
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
        env.set(5::ms, 0::ms, 1.00, 5::ms);
        1 => offset_midi_scale;
        
        for(0 => int i; i<mando_strings.cap(); i++)
        {
            0.025 => mando_strings[i].bodySize;
            0.050 => mando_strings[i].stringDetune;
            0.900 => mando_strings[i].pluckPos;
            
            mando_envs[i].set(5::ms, 0::ms, 1.00, 5::ms);
            
            1.0 / nb_strings => mando_gains[i].gain;
            
            mando_strings[i] => mando_gains[i] => mando_envs[i];
        }
    }
    
    fun void connect( float _gain )
    {
        for(0 => int i; i<mando_strings.cap(); i++)
        {
            mando_envs[i] => env;
        }
        
        // we have a ADSR for each string
        // => we can pass through the global ADSR 
        1 => env.keyOn;
        
        connect(env, _gain);
    }

    fun void connect()
    {
        this.connect(1.0);
    }
    
    fun void set_note_from_midi( int _midi_note, int _string )
    {
        Std.mtof( _midi_note + offset_midi_scale*12 ) => freqs[_string];
                
        freqs[_string] => mando_strings[_string].freq;
        Math.random2f( 0.5, 1.0 ) => mando_strings[_string].noteOn;
        
        //<<< "current_tick: ", cur_tick, "_midi_note: ", _midi_note, "- freq:", freq >>>;
    }
    
    fun void update()
    {
        // update the midi engine
        update_midi_engine();        

        // search the first attack note
        0 => int i;
        for( 0 => int i; i < state.cap(); i++ )
        {
            <<< "i:", i >>>;
            if( attack_note(i) )
            {
                set_note_from_midi( get_current_note_midi(i), get_current_string(i) );
                1 => mando_envs[i].keyOn;
            }
            else if( release_note(i) )
            {                
                1 => mando_envs[i].keyOff;
            }
        }
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
    
    
    
    // Tools for editing chords (not full implemented, like ChucK style :p)
    fun int add_chord( int _midi_notes_chord[] )
    {
        midi_chords.cap() => int id_last_element;
        midi_chords.size(id_last_element + 1); // resize the array
        
        _midi_notes_chord @=> midi_chords[id_last_element];
        
        return id_last_element;
    }
    
    fun int[] get_chord( int _id_chord )
    {
        //if( _id_chord < midi_chords.cap() )
        {
            return midi_chords[_id_chord];
        }
    }
}
