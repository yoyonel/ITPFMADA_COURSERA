// Title: Final-Projet_Tekufah

// Class derived from CInstrumentMIDI
public class CBrassMIDI extends CInstrumentMIDI
{
    Brass brass;

    float freq;

    0 => int offset_midi_scale;

	preset(0);

    fun void set_preset_0_CBM()
    {
        1 => brass.noteOff;

        env.set(5::ms, 0::ms, 1.00, 5::ms);

        1 => offset_midi_scale;
    }

    fun void connect_CBM( float _gain )
    {
        brass => env;
		
        connect_CIM( env, _gain );
    }

    fun void connect_CBM()
    {
        connect_CBM(1.0);
    }

    fun void set_note_from_midi_CBM( int _midi_note )
    {
        Std.mtof( _midi_note + offset_midi_scale*12 ) => freq;

        freq => brass.freq;
		
		Math.random2f(0.75, 1.00) => brass.noteOn;
    }

    // no mechanism to call parent method/function (with overloading)
    // need to have a different name (i.e prototype)
    fun void play_CBM()
    {
        update_CBM();
        // call a parent-class 'play' method (CSM : CScoreMidi)
        play_CSM();
    }

    fun void update_CBM()
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
                set_note_from_midi( get_current_note_midi(i) );
                1 => env.keyOn;
            }
            else if( release_note(i) )
            {
                1 => env.keyOff;
            }
        }
    }

	//
    fun void set_preset_0() { set_preset_0_CBM(); }
    fun void connect( float _gain ) { connect_CBM(_gain); }
    fun void connect() { connect_CBM(); }
    fun void set_note_from_midi( int _midi_note ) { set_note_from_midi_CBM(_midi_note); }
    fun void play() { play_CBM(); }
    fun void update() { update_CBM(); }
}