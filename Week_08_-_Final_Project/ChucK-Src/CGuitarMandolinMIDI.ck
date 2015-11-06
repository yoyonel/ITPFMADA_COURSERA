// Title: Final-Projet_Tekufah

// Class derived from CInstrumentFretsMIDI
public class CGuitarMandolinMIDI extends CInstrumentFretsMIDI
{

	// ------------------------------------------------------------------------
	// Members + Constructor
	// ------------------------------------------------------------------------
	
	// nb strings for simulate guitar (mandolin) instrument
    6 => int nb_strings;

	// STK Mandolin instrument to simulate guitar
	// Using 6 STK-instruments for each strings
    Mandolin mando_strings[nb_strings];
	// envelopes for each strings
    ADSR mando_envs[nb_strings];
	// Panoramic for each strings
    Pan2 mando_gains[nb_strings];

	// Offset scale for this instrument
    0 => int offset_midi_scale;
    
	// frequencies for each strings
    float freqs[nb_strings];
	// initialisation
    for( 0 => int i; i<nb_strings; i++) 0.0 => freqs[i];

	// set the default preset
    set_preset_0();
    
	// tool to build chord for this instrument
	// dynamic array
    int midi_chords[0][nb_strings]; // array of chords
    
	
	// ------------------------------------------------------------------------
	// Methods/Functions
	// ------------------------------------------------------------------------
		
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
			// initial definition for STK-Mandolin instrument (for simulate guitar)
            0.025 => mando_strings[i].bodySize;
            0.050 => mando_strings[i].stringDetune;
            0.900 => mando_strings[i].pluckPos;
            // default enveloppe: shorts fades-in-out
            mando_envs[i].set(5::ms, 0::ms, 1.00, 5::ms);
			// normalize gain: balance volume to have a global equalisation for each string
            1.0 / nb_strings => mando_gains[i].gain;
			// Sound chain for our instrument
            mando_strings[i] => mando_gains[i] => mando_envs[i];
        }
    }
    
	// Connect our instrument sound chain to global enveloppe
    fun void connect( float _gain )
    {
        for(0 => int i; i<mando_strings.cap(); i++)
        {
            mando_envs[i] => env;
        }
        // we have a ADSR for each string
        // => we can pass through the global ADSR 
        1 => env.keyOn;
		// connect to global env (to DAC)
        connect(env, _gain);
    }
    fun void connect()
    {
        this.connect(1.0);
    }
    
	// set a note and activate the instrument
    fun void set_note_from_midi( int _midi_note, int _string )
    {
        Std.mtof( _midi_note + offset_midi_scale*12 ) => freqs[_string];                
        freqs[_string] => mando_strings[_string].freq;
        Math.random2f( 0.5, 1.0 ) => mando_strings[_string].noteOn;
    }
    
	// Update the MIDI engine
    fun void update_CGMM()
    {
        // update the midi engine
        update_midi_engine_CSFM();        

        // for each string
        0 => int i;
        for( 0 => int i; i < state.cap(); i++ )
        {
			// need to plug the string ?
            if( attack_note(i) )
            {
				// plug it !
                set_note_from_midi( get_current_note_midi(i), get_current_string(i) );
                1 => mando_envs[get_current_string(i)].keyOn;
            }
            else if( release_note(i) ) // need to release/unplug/mute the string 
            {                
                1 => mando_envs[get_current_string(i)].keyOff;
            }
        }
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
        if( _id_chord < midi_chords.cap() )
        {
            return midi_chords[_id_chord];
        }
    }
	
	
	// ------------------------------------------------------------------------
	// Hard to deal with inheritance and overloading
	// This part is to manage manually and avoid issues
	// using a local name with suffix: CGMM - Class Guitar Mandolin MIDI
	// and a generic name (overloading) for inheritance (but depend of the inclusions ... so not very stable functionality)	
	fun void update() { update_CGMM(); }
}
