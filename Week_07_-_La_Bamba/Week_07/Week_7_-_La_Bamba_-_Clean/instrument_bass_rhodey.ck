// Title: Assignment_7_La_Bamba
// instrument_bass_rhodey.ck

0.15 => float gain;

// Instance
//CBassRhodeyMIDI bass_rhodey;
//CKeyboardRhodeyMIDI bass_rhodey;
CKeyboardBeeThreeMIDI bass_rhodey;

// Init
bass_rhodey.update_timing_from_bpm();
bass_rhodey.connect(gain);
bass_rhodey.set_global_pan(-0.1);

bass_rhodey.get_eq().add_delay( 200::ms, 0.50 );

// Datas
[ 
	1920, 2160, 2640, 2880, 3120, 3600, 3840, 4080, 4560, 5040, 5520, 5760, 6000, 6480, 6720, 6960, 7440, 7680, 7920, 8400, 8640, 8880, 9120, 9360, 9600, 9840, 10320, 10560, 10800, 11280, 11520, 11760, 12000, 12240, 12480, 12720, 12960, 13200, 13440, 13680, 14160, 14400, 14640, 15120, 15360, 15600, 16080, 16320, 16560, 16800, 17040, 17280, 17520, 18000, 18240, 18480, 18960, 19200, 19440, 19920, 20400, 20880, 21120, 21360, 21840, 22080, 22320, 22800, 23040, 23280, 23760, 24000, 24240, 24480, 24720, 24960, 25200, 25680, 25920, 26160, 26640, 26880, 27120, 27360, 27600, 27840, 28080, 28320, 28560, 28800, 29040, 29520, 29760, 30000, 30480, 30720, 30960, 31440, 31680, 31920, 32160, 32400, 32640
] @=> int array_dates_instrument[];
[ 
	36, 36, 36, 29, 29, 29, 31, 31, 31, 31, 31, 36, 36, 36, 29, 29, 29, 31, 31, 31, 43, 31, 43, 31, 36, 36, 36, 29, 29, 29, 31, 43, 31, 43, 31, 43, 31, 31, 36, 36, 48, 29, 29, 41, 31, 31, 43, 31, 31, 43, 31, 36, 36, 36, 29, 29, 29, 31, 31, 31, 31, 31, 36, 36, 36, 29, 29, 29, 31, 31, 31, 43, 31, 43, 31, 36, 36, 36, 29, 29, 29, 31, 43, 31, 43, 31, 43, 31, 31, 36, 36, 48, 29, 29, 41, 31, 31, 43, 31, 31, 43, 31, 36
] @=> int array_midi_notes_instrument[];
[ 
	240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 480
] @=> int array_durations_instrument[];

bass_rhodey.append( array_dates_instrument, array_midi_notes_instrument, array_durations_instrument);   

while(true)
{       
    bass_rhodey.update();
    bass_rhodey.play(); // consume time and update tick for midi engine
}
