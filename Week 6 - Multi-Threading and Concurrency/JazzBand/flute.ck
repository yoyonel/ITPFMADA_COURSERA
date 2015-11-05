// flute.ck
// Insert the title of your piece here

now => time start_composition;

Pan2 pan2_instrument => ADSR envelope_instrument => dac ;

0.0 => pan2_instrument.pan;

0.28 => pan2_instrument.gain;

(0::second, 0::second, 1.00, 5::ms) => envelope_instrument.set; // Fade-Out (very small, just to avoid crack/pop sound at the end)

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

0 => int TYPE_INSTRUMENT_MANDOLIN;
1 => int TYPE_INSTRUMENT_SAXOFONY;
2 => int TYPE_INSTRUMENT_CLARINET;

//TYPE_INSTRUMENT_SAXOFONY => int current_type_instrument;
//TYPE_INSTRUMENT_MANDOLIN => int current_type_instrument;
TYPE_INSTRUMENT_CLARINET => int current_type_instrument;

// 'using Unit Generators'
// 'Use of at least one STK instrument'
Mandolin mando;
Saxofony sax;
Clarinet cla;

ADSR env;

float gain_for_instrument;
float pan_for_instrument;

true => int bUseChorus;
true => int bUseReverb;
false => int bUsePitShift;
false => int bUseDelay;
true  => int bUseEnvelope;

//_______________________________________________________________________________


//_______________________________________________________________________________
// Global equalisation
1.0 => float global_gain_for_instruments_instrument;
//
init_instrument_stk( global_gain_for_instruments_instrument, current_type_instrument );

//_______________________________________________________________________________

//_______________________________________________________________________________
// MAIN

now => time start;

0 => int current_tick;

array_dates_instrument[array_dates_instrument.cap() - 1] + array_durations_instrument[array_durations_instrument.cap()-1] => int endPart;

1 => envelope_instrument.keyOn;

while( current_tick < endPart )
{
	update_midi_instruments_stk( current_tick, current_type_instrument );	
	
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
	// envelope_instrument.state() == 2 => sustain state for envelope_instrument
	if( (now - start_composition) >= (dur_length_composition - envelope_instrument.releaseTime()) && (envelope_instrument.state() == 2) )
	{
		1 => envelope_instrument.keyOff;
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

fun void update_midi_instruments_stk( int _current_tick, int _type_instrument )
{
	if( current_type_instrument == TYPE_INSTRUMENT_MANDOLIN )
	{
		update_midi_instruments( _current_tick, 1, mando, _type_instrument );
	}
	else if( current_type_instrument == TYPE_INSTRUMENT_SAXOFONY )
	{
		update_midi_instruments( _current_tick, 2, sax, _type_instrument );
	}
	else if( current_type_instrument == TYPE_INSTRUMENT_CLARINET )
	{
		update_midi_instruments( _current_tick, 2, cla, _type_instrument );
	}
}

/**
*
*/
fun void update_midi_instruments( int _current_tick, int _offset_scale, UGen _instrument, int _type_instrument )
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
			1 => env.keyOn;
			//
			array_midi_notes_instruments[id_instrument][id_note[id_instrument]-1] => int midi_note;		
			Std.mtof( midi_note + 12*_offset_scale ) => float freq_note;
			set_frequency_instrument( freq_note, true, _instrument, _type_instrument );
			
			//cout_duration( "noteOn position time", now - start );
		}
		else if( stateMidi == 1 )
		{			
			// New silence !
			1 => env.keyOff;
			//
			//set_note_off_instrument( _instrument, _type_instrument );
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
*
*/
fun void set_frequency_instrument( float _freq, int _b_note_on, UGen _instrument, int _type_instrument )
{
	if( _type_instrument == TYPE_INSTRUMENT_MANDOLIN )
	{
		_instrument $ Mandolin @=> Mandolin mandolinSTK;
		//
		if( _b_note_on ) 1 => mandolinSTK.noteOn; // pluck strings : velocity [0.0, 1.0]
		_freq => mandolinSTK.freq;
	}
	else if( _type_instrument == TYPE_INSTRUMENT_SAXOFONY )
	{
		_instrument $ Saxofony @=> Saxofony saxofonySTK;
		//
		if( _b_note_on ) 1 => saxofonySTK.noteOn;
		_freq => saxofonySTK.freq;
	}
	else if( _type_instrument == TYPE_INSTRUMENT_CLARINET )
	{
		_instrument $ Clarinet @=> Clarinet clarinetSTK;
		//
		if( _b_note_on ) 1 => clarinetSTK.noteOn;
		_freq => clarinetSTK.freq;
	}
}

/**
*
*/
fun void set_note_off_instrument( UGen _instrument, int _type_instrument )
{
	if( _type_instrument == TYPE_INSTRUMENT_MANDOLIN )
	{
		_instrument $ Mandolin @=> Mandolin mandolinSTK;
		0.01 => mandolinSTK.noteOff;
	}
	else if( _type_instrument == TYPE_INSTRUMENT_SAXOFONY )
	{
		_instrument $ Saxofony @=> Saxofony saxofonySTK;				
		1.00 => saxofonySTK.noteOff;
	}
	else if( _type_instrument == TYPE_INSTRUMENT_CLARINET )
	{
		_instrument $ Clarinet @=> Clarinet clarinetSTK;				
		1.00 => clarinetSTK.noteOff;
	}
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
		0, 480, 1320, 1440, 1560, 1800, 1920, 2400, 3240, 3360, 3480, 3720, 3840, 4200, 4680, 5160, 5280, 5400, 5640, 5760, 6240, 6960, 7080, 7200, 7320, 7560, 7680, 8040, 8520, 9000, 9120, 9240, 9480, 9600, 11520, 11640, 11880, 12000, 12240, 12360, 12600, 12840, 13200, 13320, 13440, 13560, 13800, 13920, 14280, 15360, 15480, 15720, 15840, 16080, 16200, 16440, 16680, 17040, 17160, 17280, 17400, 17640, 18120, 18240, 19200, 19320, 19560, 19680, 19920, 20040, 20280, 20520, 20880, 21000, 21120, 21360, 21480, 21600, 21840, 21960, 22080, 22200, 22440, 22680, 22800
	] @=> array_dates_instrument;
	[ 
		25, 25, 22, 25, 22, 17, 22, 22, 22, 24, 25, 29, 29, 29, 29, 22, 25, 22, 17, 22, 22, 22, 20, 22, 24, 25, 25, 25, 25, 22, 25, 22, 17, 22, 29, 30, 29, 30, 29, 25, 24, 22, 22, 20, 22, 24, 25, 25, 25, 29, 30, 29, 30, 29, 25, 24, 22, 24, 25, 29, 34, 30, 30, 30, 29, 30, 29, 30, 29, 25, 24, 22, 24, 25, 29, 25, 24, 22, 22, 24, 25, 24, 22, 20, 17
	] @=> array_midi_notes_instrument;
	[ 
		480, 840, 120, 120, 240, 120, 480, 840, 120, 120, 240, 120, 360, 480, 480, 120, 120, 240, 120, 480, 720, 120, 120, 120, 240, 120, 360, 480, 480, 120, 120, 240, 120, 1920, 120, 120, 120, 120, 120, 240, 240, 120, 120, 120, 120, 240, 120, 360, 840, 120, 120, 120, 120, 120, 240, 240, 120, 120, 120, 120, 240, 480, 120, 720, 120, 120, 120, 120, 120, 240, 120, 120, 120, 120, 240, 120, 120, 120, 120, 120, 120, 120, 120, 120, 240
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
* Set a STK-Mandolin instrument from parameters
*/
fun void set_mandolin_instrument( float _pluckPos, float _bodySize, float _stringDetune, UGen _mandolin )
{	
	_mandolin $ Mandolin @=> Mandolin mandolin;
	
	_pluckPos 		=> mandolin.pluckPos;	// [0.0, 1.0]
	_bodySize 		=> mandolin.bodySize; // percentage
	_stringDetune 	=> mandolin.stringDetune; // detuning of string pair [0.0, 1.0]
}

/**
* Set a STK-Saxophony instrument from parameters
*/
fun void set_saxophony_instrument( UGen _saxofony )
{	
	_saxofony $ Saxofony @=> Saxofony saxo;
	
	saxo.clear(0.0);
	
	<<< saxo.blowPosition() >>>;
	<<< saxo.noiseGain() >>>;
	<<< saxo.pressure() >>>;
	
	//0.5 => saxo.vibratoFreq;
	//1.0 => saxo.vibratoGain;
	//
	//0.50 => saxo.noiseGain;	
	//0.00 => saxo.pressure;
	
}

fun void init_instrument_stk( float _scale_gain, int _type_instrument )
{
	if( _type_instrument == TYPE_INSTRUMENT_MANDOLIN )
	{
		init_instrument( _scale_gain, mando, TYPE_INSTRUMENT_MANDOLIN );
	}
	else if( _type_instrument == TYPE_INSTRUMENT_SAXOFONY )
	{
		init_instrument( _scale_gain, sax, TYPE_INSTRUMENT_SAXOFONY );
	}
	else if( _type_instrument == TYPE_INSTRUMENT_CLARINET )
	{
		init_instrument( _scale_gain, cla, TYPE_INSTRUMENT_CLARINET );
	}
}

/**
*
*/
fun void init_instrument( float _scale_gain, UGen _instrument, int _type_instrument )
{
	0.50 => gain_for_instrument;	
	0.000 => pan_for_instrument;

	0 => int i;
	{
		Pan2 mandoPan;
		pan_for_instrument => mandoPan.pan;
		
		Gain gainInstrument;
		gain_for_instrument => gainInstrument.gain;
		scale_gain_UGen( gainInstrument, 1.0 );
		
		gainInstrument @=> UGen endUGen;
		_instrument @=> UGen lastUGen;
		
		if( bUsePitShift ) 	add_fx_pitshift( 0.40, 0.15, lastUGen ) @=> lastUGen;		
		if( bUseChorus ) 	add_fx_chorus( 0.05, 0.33, 0.33, lastUGen ) @=> lastUGen;
		if( bUseReverb ) 	add_fx_reverb( 0.15, lastUGen ) @=> lastUGen;
		if( bUseDelay )		add_fx_delay( 0.50, 200::ms, lastUGen ) @=> lastUGen;
		if( bUseEnvelope )	set_and_add_fx_envelope( env, 5::ms, 0::ms, 1.00, 5::ms, lastUGen ) @=> lastUGen;

		// final ChucK links
		lastUGen => endUGen => mandoPan => pan2_instrument;
	}
	
	if( _type_instrument == TYPE_INSTRUMENT_MANDOLIN )
	{
		set_mandolin_instrument( 0.10, 0.15, 0.00, _instrument );
	}
	else if( _type_instrument == TYPE_INSTRUMENT_SAXOFONY )
	{
		set_saxophony_instrument( _instrument );
	}
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
