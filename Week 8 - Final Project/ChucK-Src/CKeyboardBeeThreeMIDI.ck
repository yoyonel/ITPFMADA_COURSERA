// Title: Final-Projet_Tekufah

// Class derived from CInstrumentMIDI
public class CKeyboardBeeThreeMIDI extends CInstrumentMIDI
{

	// ---------------------------------
	// Attributes/Members
	// ---------------------------------
	
	// nb fingers manage in the same time
	2 =>  static int nb_fingers;

	// for each finger we associate a keyboard structure
	ADSR keyboard_envs[nb_fingers];
    Pan2 keyboard_gains[nb_fingers];	
	BeeThree BeeThree_fingers[nb_fingers];

	// Offset scale for this instrument
    0 => int offset_midi_scale;

	// frequencies for each fingers
    float freqs[nb_fingers];
    
	// Tool to construct chords
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
		// enveloppe: shorts fades-in-out for each note (global env)
        env.set( 5::ms, 0::ms, 1.00, 5::ms );

		// offset for this instrument
        1 => offset_midi_scale;

		// for each finger ...
        for(0 => int i; i<nb_fingers; i++)
        {
			// local env. for each finger
            keyboard_envs[i].set(5::ms, 0::ms, 1.00, 5::ms);
			// no normalisation gain (need to clean)
			1.0 => keyboard_gains[i].gain;
			// (local) sound chain (for 1 finger)
            BeeThree_fingers[i] => keyboard_gains[i] => keyboard_envs[i];
        }
    }

	// connect all fingers to global env.
    fun void connect_CKBTM( float _gain )
    {
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

	// Set a note for a specify finger
    fun void set_note_from_midi_CKBTM( int _midi_note, int _finger )
    {
		// convert midi to frequency
        Std.mtof( _midi_note + offset_midi_scale*12 ) => freqs[_finger];
		// set the finger
		freqs[_finger] => BeeThree_fingers[_finger].freq;
		// activate the note
        Math.random2f( 0.5, 1.0 ) => BeeThree_fingers[_finger].noteOn;
    }
	
	// Update MIDI Engine
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
        update_CKBTM();
        // call the parent-class 'play' method
        play_CSM();
    }

	// ------------------------------------------------------------------------
	// Hard to deal with inheritance and overloading
	// This part is to manage manually and avoid issues
	// using a local name with suffix: CKBTM - Class Keyboard BeeThree Midi
	// and a generic name (overloading) for inheritance (but depend of the inclusions ... so not very stable functionality)	
	fun void preset(int _preset) { preset_CKBTM(_preset); }	
	fun void play() { play_CKBTM(); }
	fun void update() { update_CKBTM(); }
	fun void set_note_from_midi( int _midi_note, int _finger )  { set_note_from_midi_CKBTM(  _midi_note,  _finger ); }
	fun void connect() { connect_CKBTM(); }
	fun void set_preset_0() { set_preset_0_CKBTM(); }
	fun void connect(float _gain) { connect_CKBTM(_gain); }
}
