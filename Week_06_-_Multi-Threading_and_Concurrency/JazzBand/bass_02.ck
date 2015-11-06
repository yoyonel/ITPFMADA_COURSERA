// flute.ck
// Insert the title of your piece here

now => time start_composition;

Pan2 pan2_instrument => ADSR envelope_instrument => ADSR envelope_song => dac ;

-0.25 => pan2_instrument.pan;

1.00 => pan2_instrument.gain;

(0::second, 0::second, 1.00, 5::ms) => envelope_song.set; // Fade-Out (very small, just to avoid crack/pop sound at the end)
(50::ms, 10::ms, 0.90, 10::ms) => envelope_instrument.set;

//_______________________________________________________________________________
// 'Make quarter Notes (main compositional pulse) 0.75::second in your composition'
0.625::second => dur quarter_duration;

// 'Create a 30 second composition'
30::second => dur dur_length_composition;
//_______________________________________________________________________________

//_______________________________________________________________________________
// --------------------------------------------------
// Instruments - MIDI Engine
// --------------------------------------------------
100 => int nb_notes_for_instrument;
//
int array_dates_instrument[nb_notes_for_instrument];
int array_midi_notes_instrument[nb_notes_for_instrument];
int array_durations_instrument[nb_notes_for_instrument];
//
load_instrument();

[ 
	array_dates_instrument
] @=> int array_dates_instruments[][];

[ 
	array_midi_notes_instrument
] @=> int array_midi_notes_instruments[][];

[ 
	array_durations_instrument
] @=> int array_durations_instruments[][];

array_dates_instruments.cap() => int nb_instruments;
//_______________________________________________________________________________

//_______________________________________________________________________________
480 => int TPQ; // Ticks Per Quarter
quarter_duration / (TPQ $ float) => dur tick_duration;

Std.ftoi( Math.floor(tick_duration / 1::samp) * 0.5 ) => int nb_samp_for_1_tick;

tick_duration / nb_samp_for_1_tick => dur step_time_for_ChucK;
//_______________________________________________________________________________

//_______________________________________________________________________________
// --------------------------------------------------
// MIDI Engine
// --------------------------------------------------
int compteur_samp;
int id_instrument;
// use arrays to allow IN/OUT (reference) passing arguments (in methods/functions)
int id_note[nb_instruments];
int play_note[nb_instruments];
int current_duration_for_midi_note[nb_instruments];
time time_for_Release[nb_instruments];
//
init_MIDI_Engine();

//_______________________________________________________________________________
// --------------------------------------------------
// Instruments: instrument samplers
// --------------------------------------------------

SinOsc osc_bass_1, osc_bass_4;
TriOsc osc_bass_2, osc_bass_3;
Pan2 pan_bass_1, pan_bass_2, pan_bass_3, pan_bass_4;

float gain_for_instrument;
float pan_for_instrument;

false => int bUseChorus;
false => int bUseReverb;
false => int bUsePitShift;
false => int bUseDelay;
true  => int bUseEnvelope;

//_______________________________________________________________________________


//_______________________________________________________________________________
// Global equalisation
1.0 => float global_gain_for_instruments_instrument;
//
//init_instrument_stk( global_gain_for_instruments_instrument, current_type_instrument );
init_instrument( pan2_instrument );
init_fx_instrument( pan2_instrument ) => envelope_instrument;
//_______________________________________________________________________________

//_______________________________________________________________________________
// MAIN

now => time start;

0 => int current_tick;

array_dates_instrument[array_dates_instrument.cap() - 1] + array_durations_instrument[array_durations_instrument.cap()-1] => int endPart;

1 => envelope_song.keyOn;

while( current_tick < endPart )
{
	//update_midi_instruments_stk( current_tick, current_type_instrument );	
	update_midi_instruments( current_tick , 1 );
	update_chuck_audio_engine();
}

if( (now - start_composition) < 30::second )
{
	30::second - (now - start_composition) => now;
}

cout_duration("Length of this composition", now - start_composition );

<<< "Merci pour l'ecoute! :-D" >>>;

//_______________________________________________________________________________

/**
*
*/
fun void fade_out_for_the_end()
{
	// envelope_song.state() == 2 => sustain state for envelope_song
	if( (now - start_composition) >= (dur_length_composition - envelope_song.releaseTime()) && (envelope_song.state() == 2) )
	{
		1 => envelope_song.keyOff;
	}
}

/**
*
*/
fun void update_chuck_audio_engine()
{
	// Subdivise time to have a better quality for wav creation from ChucK engine
	for( 0 => int i; i < nb_samp_for_1_tick; i++ )
	{
		fade_out_for_the_end();	// fade-out at the end
		step_time_for_ChucK => now ;	// advanced time for ChucK	
	}
}

/**
*
*/
//fun void update_midi_instruments( int _current_tick, int _offset_scale, UGen _instrument, int _type_instrument )
fun void update_midi_instruments( int _current_tick, int _offset_scale )
{
	// for each 'midi' instruments
	for( 0 => int id_instrument; id_instrument < nb_instruments; id_instrument++ )
	{
		// get the current state, and update the midi note
		update_midi_instrument( 
			id_instrument, _current_tick, id_note, 
			current_duration_for_midi_note, play_note,
			array_dates_instruments, array_midi_notes_instruments, array_durations_instruments
		) => int stateMidi;
		
		// state machine for midi engine
		if( stateMidi == 0 )
		{
			// New note ! Attack
			1 => envelope_instrument.keyOn;			
			array_midi_notes_instruments[id_instrument][id_note[id_instrument]-1] => int midi_note;
			12*_offset_scale +=> midi_note;

			set_midi_note( midi_note );			
		}
		else if( stateMidi == 1 )
		{			
			// New silence !
			1 => envelope_instrument.keyOff;
		}
		else if( stateMidi == 2 )
		{
			// Playing a note. Stay
		}
		else if( stateMidi == 3 )
		{
			// Silence ... Stay
		}
	}
	current_tick++;	// advanced tick/time for midi engine
}

/**
*	state:
*	- 0 : new note
*	- 1 : new silence
*	- 2 : playing a note
*	- 3 : 'playing' a silence
*/
fun int update_midi_instrument(	
	int _id_instrument,	// IN
	int _current_tick,	// IN
	int _id_note[],	// IN-OUT
	int _duration_for_midi_note[],	// OUT
	int _play_note[],	// OUT
	int _array_dates_instruments[][],	// IN
	int _array_midi_notes_instruments[][],	// IN
	int _array_durations_instruments[][]	// IN	
)
{
	0 => int state;
	
	// ALIAS (for reading)
	_id_note[_id_instrument] @=> int id_note;
	_array_dates_instruments[_id_instrument] @=> int array_dates[];
	_array_midi_notes_instruments[_id_instrument] @=> int array_midi_notes[];
	_array_durations_instruments[_id_instrument] @=> int array_durations[];
	
	// Time to play a new note ?
	if( array_dates[id_note] == _current_tick )
	{	
		// New note !
		0 => state;
		
		array_durations[id_note] => _duration_for_midi_note[_id_instrument];

		1 => _play_note[_id_instrument];

		array_midi_notes.cap()-1 %=> _id_note[_id_instrument];
		_id_note[_id_instrument]++; // update midi note
	}
	else if( _play_note[_id_instrument] ) // are we playing a note ?
	{
		if( _duration_for_midi_note[_id_instrument] == 0 ) // duration counter is finish ?
		{
			// go inside a silence note
			1 => state;
			0 => _play_note[_id_instrument];
		}
		else
		{
			// we playing a note			
			2 => state;
			_duration_for_midi_note[_id_instrument]--;
		}
	}
	else
	{
		// we are inside a silence note
		3 => state;
	}
	
	return state;
}

/**
* Initialisation of MIDI engine
*/
fun void init_MIDI_Engine()
{
	0 => compteur_samp;
	0 => id_instrument;

	for( 0 => int i; i < id_note.cap(); i++ )
	{	
		0 => id_note[i] => play_note[i] => current_duration_for_midi_note[i];
	}
}

/**
* Loading midi note for instrument 1
*/
fun void load_instrument()
{
	[ 
		0, 480, 960, 1080, 1200, 1440, 1920, 2160, 2280, 2520, 2640, 2880, 3360, 3600, 3720, 3960, 4080, 4320, 4800, 5040, 5160, 5400, 5520, 5640, 5760, 6240, 6720, 6840, 6960, 7200, 7680, 7920, 8040, 8280, 8400, 8640, 9120, 9360, 9480, 9720, 9840, 10080, 10560, 10800, 10920, 11160, 11280, 11400, 11520, 12000, 12480, 12600, 12720, 12960, 13440, 13680, 13800, 14040, 14160, 14400, 14880, 15120, 15240, 15480, 15600, 15840, 16320, 16560, 16680, 16920, 17040, 17160, 17280, 17760, 18240, 18360, 18480, 18720, 19200, 19440, 19560, 19800, 19920, 20160, 20640, 20880
	] @=> array_dates_instrument;
	[ 
		22, 22, 17, 20, 22, 22, 22, 22, 17, 17, 22, 22, 22, 22, 17, 17, 22, 22, 22, 22, 17, 17, 22, 17, 22, 22, 17, 20, 22, 22, 22, 22, 17, 17, 22, 22, 22, 22, 17, 17, 22, 22, 22, 22, 17, 17, 22, 17, 22, 22, 17, 20, 22, 22, 22, 22, 17, 17, 22, 22, 22, 22, 17, 17, 22, 22, 22, 22, 17, 17, 22, 17, 22, 22, 17, 20, 22, 22, 22, 22, 17, 17, 22, 22, 22, 22
	] @=> array_midi_notes_instrument;
	[ 
		240, 240, 120, 120, 240, 360, 240, 120, 240, 120, 240, 360, 240, 120, 240, 120, 240, 360, 240, 120, 240, 120, 120, 120, 240, 240, 120, 120, 240, 360, 240, 120, 240, 120, 240, 360, 240, 120, 240, 120, 240, 360, 240, 120, 240, 120, 120, 120, 240, 240, 120, 120, 240, 360, 240, 120, 240, 120, 240, 360, 240, 120, 240, 120, 240, 360, 240, 120, 240, 120, 120, 120, 240, 240, 120, 120, 240, 360, 240, 120, 240, 120, 240, 360, 240, 240
	] @=> array_durations_instrument;
}

/**
* Adding a PitShift effect
*/
fun UGen add_fx_pitshift( float _shift, float _mix, UGen _entry )
{
	PitShift pshift;
	
	// PitShift Effect
	_shift => pshift.shift;
	_mix => pshift.mix;
	//
	_entry => pshift;
	return pshift;
}

/**
* Adding a Chorus effect
*/
fun UGen add_fx_chorus( float _modFreq, float _modDepth, float _mix, UGen _entry )
{
	// Chorus Effect
	Chorus chorus;
	// settings
	_mix => chorus.mix;
	_modFreq => chorus.modFreq;
	_modDepth => chorus.modDepth;
	// link ugen fx
	_entry => chorus;
	// _out_ugen
	return chorus;
}

/**
* Adding a Reverb effect
*/
fun UGen add_fx_reverb( float _mix, UGen _entry )
{
	// Chorus Effect
	//NRev reverb;
	PRCRev reverb;
	
	// settings
	_mix => reverb.mix;
	// link ugen fx
	_entry => reverb;
	// _out_ugen
	return reverb;
}

/**
* * Adding a Vibrato effect (don't work)
*/
fun UGen add_fx_vibrato( float _gain, float _freq, UGen _entry )
{
	// Chorus Effect
	SinOsc vibrato;
	// settings
	_gain => vibrato.gain;
	_freq => vibrato.freq;
	// link ugen fx
	vibrato => _entry;
	// _out_ugen
	return _entry;
}
/**
* * Adding a Echo effect (don't work)
*/
fun UGen add_fx_delay( float _gain, dur _delay, UGen _entry )
{
	// UGen for Delay effect
	_entry => Delay d => d;
	
	// settings
	_delay => d.max => d.delay;
	_gain => d.gain;
	
	return d;
}

/**
* Adding a Envelope effect
*/
fun UGen set_and_add_fx_envelope( ADSR _envelope, dur _attack, dur _decrease, float _stay, dur _release, UGen _entry )
{	
	// settings
	( _attack, _decrease, _stay, _release ) => _envelope.set; // Fade-Out
	
	// link ugen fx
	_entry => _envelope;
	
	// return the out UGen
	return _envelope;
}

/**
*
*/
fun void scale_gain_UGen( UGen _ugen, float _scale_gain )
{
	_ugen.gain() * _scale_gain => _ugen.gain;
}

/**
*
*/
fun void init_instrument( Pan2 _pan_instrument )
{
	osc_bass_1 => pan_bass_1 => _pan_instrument;
	osc_bass_2 => pan_bass_2 => _pan_instrument;
	//
	osc_bass_3 => pan_bass_3 => _pan_instrument;
	osc_bass_4 => pan_bass_4 => _pan_instrument;

	0.00 => float PAN_CENTER;
	 1.0 => float PAN_RIGHT;
	-1.0 => float PAN_LEFT;
	
	// Reglage des oscillateurs

	// Partie basse (middle-low + low ambiance)
	//
	// Bass 1 : low low
	// low (low) frequency (pour l'ambiance "globale" du son)
	// - set the gain
	0.25 => osc_bass_1.gain;	
	// - pan: center (on centre le son pour créer une ambiance)
	PAN_CENTER => pan_bass_1.pan;
	//
	// Bass 2 : middle low
	// - set the gain
	0.25 => osc_bass_2.gain;
	// - pan : 
	PAN_RIGHT * 1.0 => pan_bass_2.pan;

	// Partie basse (middle + high)
	//
	// Bass 3 : middle
	// - set the gain
	0.025 => osc_bass_3.gain;
	// - pan: center (on centre le son pour créer une ambiance)
	PAN_LEFT * 0.50 => pan_bass_3.pan;
	//
	// Bass 4 : high
	// - set the gain
	0.025 => osc_bass_4.gain;
	// - pan : 
	PAN_RIGHT * 0.50 => pan_bass_4.pan;
}

/**
*
*/
fun UGen init_fx_instrument( UGen _instrument )
{
	_instrument @=> UGen lastUGen;
	
	if( bUsePitShift ) 	add_fx_pitshift( 0.40, 0.15, lastUGen ) @=> lastUGen;		
	if( bUseChorus ) 	add_fx_chorus( 0.05, 0.33, 0.33, lastUGen ) @=> lastUGen;
	if( bUseReverb ) 	add_fx_reverb( 0.15, lastUGen ) @=> lastUGen;
	if( bUseDelay )		add_fx_delay( 0.50, 200::ms, lastUGen ) @=> lastUGen;
	if( bUseEnvelope )	set_and_add_fx_envelope( env, 5::ms, 0::ms, 1.00, 5::ms, lastUGen ) @=> lastUGen;

	// final ChucK links
	return lastUGen;
}

/**
*
*/
fun void set_midi_note( int _midi_note )
{
	//
	Std.mtof( _midi_note + 1*12 ) => float frequency_high_note;
	Std.mtof( _midi_note + 0*12 ) => float frequency_middle_note;
	Std.mtof( _midi_note - 2*12 ) => float frequency_midlow_note;
	Std.mtof( _midi_note - 3*12 ) => float frequency_low_note;

	// Partie basse (middle-low + low ambiance)
	//
	// Bass 1 : low low
	// low (low) frequency (pour l'ambiance "globale" du son)
	// - set frequency
	frequency_low_note => osc_bass_1.freq;

	//
	// Bass 2 : middle low
	// - set frequency
	frequency_midlow_note => osc_bass_2.freq;	

	// Partie basse (middle + high)
	//
	// Bass 3 : middle
	// middle frequency
	// - set frequency
	frequency_middle_note => osc_bass_3.freq;
	
	// Bass 4 : high
	// - set frequency
	frequency_high_note => osc_bass_4.freq;
}

/**
*
*/
fun void cout_duration( string _prefix_msg , dur _duration )
{
	<<< ">>> " + _prefix_msg + ":" , convert_duration_to_float( _duration, 1::second ), "second" >>> ;
}

/**
*
*/
fun float convert_duration_to_float( dur _duration, dur _base_time )
{
	return _duration / _base_time ;
}
