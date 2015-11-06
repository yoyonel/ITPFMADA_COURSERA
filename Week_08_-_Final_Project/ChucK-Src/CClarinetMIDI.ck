// Title: Final-Projet_Tekufah

// Class derived from CInstrumentMIDI
public class CClarinetMIDI extends CInstrumentMIDI
{

	// ------------------------------------------------------------------------
	// Members + Constructor
	// ------------------------------------------------------------------------
	
	// STK Clarinet instrument using for our instrument
    Clarinet clarinet;

	// Current frequency
    float freq;

	// Offset Scale using for this instrument (midi scale)
    1 => int offset_midi_scale; // x12

	// set initial preset
	preset(0);

	// Definitions of presets
    fun void set_preset_0_CCM()
    {
		// desactivate clarinet
        1 => clarinet.noteOff;
		// set a default envelope: shorts fades-in-out
        env.set(5::ms, 0::ms, 1.00, 5::ms);
		// offset scale : 1 => +12 (midi scale)
        1 => offset_midi_scale;
    }

	// Connection with EQualisation
    fun void connect_CCM( float _gain )
    {
        clarinet => env;
		
        connect_CIM( env, _gain );
    }
    fun void connect_CCM()
    {
        connect_CCM(1.0);
    }

	// Set a frequency for this instrument
    fun void set_note_from_midi_CCM( int _midi_note )
    {
        Std.mtof( _midi_note + offset_midi_scale*12 ) => freq;
        freq => clarinet.freq;
		// Random attack for this instrument
		Math.random2f(0.75, 1.00) => clarinet.noteOn;
    }

    // no mechanism to call parent method/function (with overloading)
    // need to have a different name (i.e prototype)
    fun void play_CCM()
    {        
        update_CCM();
        // call a parent-class 'play' method (CSM : CScoreMidi)
        play_CSM();
    }

	// Update the instrument
	// update: the MIDI Engine associate to this instrument
    fun void update_CCM()
    {
        // update the midi engine
        update_midi_engine();

        // search the first attack note
		// need to clean
		// play 1 note (only)
        0 => int i;
        while( i < state.cap() && silent_note(i) )
        {
            i++;
        }
		
        if( i < state.cap() )
        {
			// if new note, activate the clarinet
            if( attack_note(i) )
            {
				// set the frequency
                set_note_from_midi( get_current_note_midi(i) );
				// activate the clarinet
                1 => env.keyOn;
            }
            else if( release_note(i) ) // time to end (the current note) ?
            {
				// releaase the note
                1 => env.keyOff;
            }
        }
    }

	// ------------------------------------------------------------------------
	// Hard to deal with inheritance and overloading
	// This part is to manage manually and avoid issues
	// using a local name with suffix: CCM - Class Clarinet MIDI
	// and a generic name (overloading) for inheritance (but depend of the inclusions ... so not very stable functionality)
    fun void set_preset_0() { set_preset_0_CCM(); }
    fun void connect( float _gain ) { connect_CCM(_gain); }
    fun void connect() { connect_CCM(); }
    fun void set_note_from_midi( int _midi_note ) { set_note_from_midi_CCM(_midi_note); }
    fun void play() { play_CCM(); }
    fun void update() { update_CCM(); }
}