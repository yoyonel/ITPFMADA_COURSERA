// Title: Final-Projet_Tekufah

// Class derived from CInstrumentMIDI
public class CKeyboardRhodeyMIDI extends CInstrumentMIDI
{
	// ---------------------------------
	// Attributes/Members
	// ---------------------------------
	2 =>  static int nb_fingers;

	// for each finger, we associate a structure instrument
	ADSR keyboard_envs[nb_fingers];
    Pan2 keyboard_gains[nb_fingers];		
	Rhodey rhodey_fingers[nb_fingers];
	float freqs[nb_fingers];

	// offset scale for our instrument
    0 => int offset_midi_scale;
    
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
    fun void preset_CKRM( int _preset )
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

    fun void set_preset_0_CKRM()
    {
        env.set(5::ms, 0::ms, 1.00, 5::ms);

        1 => offset_midi_scale;

        for(0 => int i; i<nb_fingers; i++)
        {
			// shorts fades-in-out
            keyboard_envs[i].set(5::ms, 0::ms, 1.00, 5::ms);
            // no normalisation gain
			// need to clean
			1.0 => keyboard_gains[i].gain;
			// sound chain
            rhodey_fingers[i] => keyboard_gains[i] => keyboard_envs[i];
        }
    }

	// COnnect our instrument (fingers) to global env. (to DAC)
    fun void connect_CKRM( float _gain )
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
    fun void connect_CKRM()
    {
        connect_CKRM(1.0);
    }	

	// set the note for 1 finger
    fun void set_note_from_midi_CKRM( int _midi_note, int _finger )
    {
		// convert midi note to frequency
        Std.mtof( _midi_note + offset_midi_scale*12 ) => freqs[_finger];
		// set the finger instrument
		freqs[_finger] => rhodey_fingers[_finger].freq;
		// activate the finger instrument with random attack note
        Math.random2f( 0.5, 1.0 ) => rhodey_fingers[_finger].noteOn;
    }
	
	// Update the MIDI Engine, and manage the current state
    fun void update_CKRM()
    {
        // update the midi engine
        update_midi_engine();

        // for each finger/state, manage the MIDI Engine
        0 => int i;
        for( 0 => int i; i < state.cap(); i++ )
        {
            if( attack_note(i) ) // time to play a new note (for this finger) ?
            {
                set_note_from_midi( get_current_note_midi(i), i );
                1 => keyboard_envs[i].keyOn;
            }
            else if( release_note(i) ) // time to stop to play (for this finger) ?
            {
                1 => keyboard_envs[i].keyOff;
            }
        }
    }	

    // no mechanism to call parent method/function (with overloading)
    // need to have a different name (i.e prototype)
    fun void play_CKRM()
    {
		// udpate the MIDI Engine
        update_CKRM();
        // call the parent-class 'play' method
        play_CSM();
    }

	// ------------------------------------------------------------------------
	// Hard to deal with inheritance and overloading
	// This part is to manage manually and avoid issues
	// using a local name with suffix: CKRM - Class Keyboard Rhodey MIDI
	// and a generic name (overloading) for inheritance (but depend of the inclusions ... so not very stable functionality)
	// ------------------------------------------------------------------------
	fun void preset(int _preset) { preset_CKRM(_preset); }	
	fun void play() { play_CKRM(); }
	fun void update() { update_CKRM(); }
	fun void set_note_from_midi( int _midi_note, int _finger )  { set_note_from_midi_CKRM(  _midi_note,  _finger ); }
	fun void connect() { connect_CKRM(); }
	fun void set_preset_0() { set_preset_0_CKRM(); }
	fun void connect(float _gain) { connect_CKRM(_gain); }
}
