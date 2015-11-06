// Title: Final-Projet_Tekufah

// Class derived from CInstrumentMIDI
public class CBassOscMIDI extends CInstrumentMIDI
{

	// ------------------------------------------------------------------------
	// Members + Constructor
	// ------------------------------------------------------------------------

	// Oscillators using for simulate audio-bass
    SinOsc osc1;
    TriOsc osc2;
    
	// Current Frequency for our instrument
    float freq;
    
	// offset scale using for this instrument
    0 => int offset_midi_scale;

	// set the default preset for this instrument
	preset(0);

	
	// ------------------------------------------------------------------------
	// Methods/Functions
	// ------------------------------------------------------------------------
	
	// Definitions of presets
    fun void set_preset_0_CBOM()
    {
		// set the oscillators
		// no frequency
		// balance the volume
        0 => osc1.freq => osc2.freq;
        0.5 => osc1.gain => osc2.gain;
        
		// set the envlope
		// for each note: shorts fade in-out
        env.set(5::ms, 0::ms, 1.00, 5::ms);
        
		// offset scale to 1 (+12 midi scale) for this bass instrument
        1 => offset_midi_scale;
    }
        
	// Connect ours oscillators to the envelope (and EQualisation)
    fun void connect_CBOM( float _gain )
    {
        osc1 => env;
		osc2 => env;
		// Connect envelope to EQualisation (to DAC)
        connect_CIM( env, _gain );
    }
	// same without initial gain
    fun void connect_CBOM()
    {
        connect_CBOM(1.0);
    }
    
	// Change the frequency for our instrument
    fun void set_note_from_midi_CBOM( int _midi_note )
    {
		// Convert midi note (with offset scale) to frequency 
        Std.mtof( _midi_note + offset_midi_scale*12 ) => freq;
		// Set the frequencies for ours oscillators
        freq => osc1.freq => osc2.freq;
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
    
	// Update the midi engine and play note
    fun void update_CBOM()
    {
        // update the midi engine
        update_midi_engine();        

        // Search the first attack note
		// (need to clean)
        0 => int i;
        while( i < state.cap() && silent_note(i) )
        {
            i++;
        }
        
		// Need to play a note ?
        if( i < state.cap() )
        {
			// new note to play ? so attack !
            if( attack_note(i) )
            {
				// set the note
                set_note_from_midi( get_current_note_midi(i) );
				// activate the key
                1 => env.keyOn;
            }
            else if( release_note(i) )	// time to stop play the current note ?
            {
				// release the key
                1 => env.keyOff;
            }
        }
    }
	
	// ------------------------------------------------------------------------
	// Hard to deal with inheritance and overloading
	// This part is to manage manually and avoid issues
	// using a local name with suffix: CBOM - Class Bass Oscillators MIDI
	// and a generic name (overloading) for inheritance (but depend of the inclusions ... so not very stable functionality)
    fun void set_preset_0() { set_preset_0_CBOM(); }
    fun void connect( float _gain ) { connect_CBOM(_gain); }
    fun void connect() { connect_CBOM(); }
    fun void set_note_from_midi( int _midi_note ) { set_note_from_midi_CBOM(_midi_note); }
    fun void play() { play_CBOM(); }
    fun void update() { update_CBOM(); }
}