Gain g => dac;
1.0 => g.gain;

SinOsc s => g;

// Map our interval midi notes
50 - 1*12 => int start_midi_note;
62 - 1*12 => int end_midi_note;

// loop on this interval
for( start_midi_note => int id_midi_note; id_midi_note <= end_midi_note; id_midi_note++ )
{    
    Std.mtof( id_midi_note ) => s.freq;    
    <<< "midi note: ", id_midi_note, "- frequence: ", s.freq() >>>;
 
    1.0 => s.gain; // constant gain   
    0.5::second => now;
    0.0 => s.gain; // constant gain
    0.5::second => now;
}


1::second => now;