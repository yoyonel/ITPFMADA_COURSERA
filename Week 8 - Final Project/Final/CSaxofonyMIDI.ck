// Title: Final-Projet_Tekufah

// Class derived/extent from CInstrumentMIDI
public class CSaxoFonyMIDI extends CInstrumentMIDI
{
	// STK Saxofony instrument using for our instrument
    Saxofony sax;

	// current frequency
    float freq;

	// Offset scale (midi scale) for instrument
    2 => int offset_midi_scale; // x12

	// Set the default preset
	preset(0);

	// Definition of our default preset for this instrument
    fun void set_preset_0_CSFM()
    {
		// desactivate the sax
        1 => sax.noteOff;
		// set a shorts fades-in-out
		env.set(5::ms, 0::ms, 1.00, 5::ms);
		// set the offset
        2 => offset_midi_scale;
    }

	// Connection to global env (to DAC)
    fun void connect_CSFM( float _gain )
   {
        sax => env;
        connect_CIM( env, _gain );
    }
    fun void connect_CSFM()
    {
        connect_CSFM(1.0);
    }

	// Set a note for this instrument
    fun void set_note_from_midi_CSFM( int _midi_note )
    {
		// convert midi to frequency
        Std.mtof( _midi_note + offset_midi_scale*12 ) => freq;
		// set the instrument frequency
        freq => sax.freq;
		// random attack to play the note
		Math.random2f(0.75, 1.00) => sax.noteOn;
    }

    // no mechanism to call parent method/function (with overloading)
    // need to have a different name (i.e prototype)
    fun void play_CSFM()
    {        
        update_CSFM();
        // call a parent-class 'play' method (CSM : CScoreMidi)
        play_CSM();
    }

	// Update MIDI Engine, and manage the current state result
    fun void update_CSFM()
    {
        // update the midi engine
        update_midi_engine();

        // search the first attack note
		get_first_id_current_playing_note() => int i;
		
		//
        if( i < state.cap() )
        {
            if( attack_note(i) ) // time to play a new note ?
            {
                set_note_from_midi( get_current_note_midi(i) );
                1 => env.keyOn;
            }
            else if( release_note(i) ) // to to stop the current note playing ?
            {
                1 => env.keyOff;
            }
        }
    }

	// ------------------------------------------------------------------------
	// Hard to deal with inheritance and overloading
	// This part is to manage manually and avoid issues
	// using a local name with suffix: CSFM - Class Saxofony Midi
	// and a generic name (overloading) for inheritance (but depend of the inclusions ... so not very stable functionality)
	// ------------------------------------------------------------------------
    fun void set_preset_0() { set_preset_0_CSFM(); }
    fun void connect( float _gain ) { connect_CSFM(_gain); }
    fun void connect() { connect_CSFM(); }
    fun void set_note_from_midi( int _midi_note ) { set_note_from_midi_CSFM(_midi_note); }
    fun void play() { play_CSFM(); }
    fun void update() { update_CSFM(); }
}