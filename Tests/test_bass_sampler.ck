62 => int midi_note;
0*12 +=> midi_note;

//
1.0::second => dur value_note;

Pan2 pan_master_bass;
0.50 => pan_master_bass.gain;


// ------------------------------------------------------------------------------------
// Définition du sampler BASS
// -> 4 sons d'oscillateurs fusionnés
// -> BASS lourde !
// ------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------
SinOsc osc_bass_1, osc_bass_4;
TriOsc osc_bass_2, osc_bass_3;
Pan2 pan_bass_1, pan_bass_2, pan_bass_3, pan_bass_4;

init_instrument( pan_master_bass );

// ------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------

pan_master_bass => dac;

set_midi_note( midi_note );

// On joue le son 
value_note => now;



// ------------------------------------------------------------------------------------
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