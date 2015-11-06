public class CKeyboardBeeThreeMIDI extends CInstrumentMIDI
{
	// ---------------------------------
	// Attributes/Members
	// ---------------------------------
	10 =>  static int nb_fingers;

	ADSR keyboard_envs[nb_fingers];
    Pan2 keyboard_gains[nb_fingers];
	
	BeeThree BeeThree_fingers[nb_fingers];

    0 => int offset_midi_scale;

    float freqs[nb_fingers];
    
    int midi_chords[0][nb_fingers]; // array of chords

	// ---------------------------------
	// Constructor
	// ---------------------------------
	set_preset_0();
	//
	for( 0 => int i; i<nb_fingers; i++)
		0.0 => freqs[i];

	// ---------------------------------
	// Methods/Functions
	// ---------------------------------
    fun void preset_CKBTM( int _preset )
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
	

    fun void set_preset_0_CKBTM()
    {
		//<<< "set_preset_0 : CKeyboardMIDI" >>>;
		
        env.set(5::ms, 0::ms, 1.00, 5::ms);

        1 => offset_midi_scale;

        for(0 => int i; i<nb_fingers; i++)
        {
            keyboard_envs[i].set(5::ms, 0::ms, 1.00, 5::ms);
            //1.0 / nb_fingers => keyboard_gains[i].gain;
			1.0 => keyboard_gains[i].gain;
			// sound chain
            BeeThree_fingers[i] => keyboard_gains[i] => keyboard_envs[i];
        }
    }

    fun void connect_CKBTM( float _gain )
    {
		//<<< "connect ! " >>>;
        for(0 => int i; i<nb_fingers; i++)
        {
            keyboard_envs[i] => env;
        }
        // we have a ADSR for each string
        // => we can pass through the global ADSR
        1 => env.keyOn;
		//
        connect_CIM(env, _gain);
    }

    fun void connect_CKBTM()
    {
        connect_CKBTM(1.0);
    }	

    fun void set_note_from_midi_CKBTM( int _midi_note, int _finger )
    {
        Std.mtof( _midi_note + offset_midi_scale*12 ) => freqs[_finger];
		//
		freqs[_finger] => BeeThree_fingers[_finger].freq;
        Math.random2f( 0.5, 1.0 ) => BeeThree_fingers[_finger].noteOn;
    }
	

    fun void update_CKBTM()
    {
        // update the midi engine
        update_midi_engine();

        //
        0 => int i;
        for( 0 => int i; i < state.cap(); i++ )
        {
            if( attack_note(i) )
            {
                set_note_from_midi( get_current_note_midi(i), i );
                1 => keyboard_envs[i].keyOn;
				//<<< "attack note !" >>>;
            }
            else if( release_note(i) )
            {
                1 => keyboard_envs[i].keyOff;
            }
        }
    }	

    // no mechanism to call parent method/function (with overloading)
    // need to have a different name (i.e prototype)
    fun void play_CKBTM()
    {
        //<<< "CKBTM", "-> play()" >>>;
		//
        update_CKBTM();
        // call the parent-class 'play' method
        play_CSM();
    }

	// -------------------------------------------------------------------
	// Overloads -Parent/Childs classes
	// -------------------------------------------------------------------
	fun void preset(int _preset) { preset_CKBTM(_preset); }	
	fun void play() { play_CKBTM(); }
	fun void update() { update_CKBTM(); }
	fun void set_note_from_midi( int _midi_note, int _finger )  { set_note_from_midi_CKBTM(  _midi_note,  _finger ); 	}
	fun void connect() { connect_CKBTM(); }
	fun void set_preset_0() { set_preset_0_CKBTM(); }
	fun void connect(float _gain) { connect_CKBTM(_gain); }
}
