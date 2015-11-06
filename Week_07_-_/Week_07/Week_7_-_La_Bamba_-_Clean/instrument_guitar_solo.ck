// Title: Assignment_7_La_Bamba
// instrument_guitar_solo.ck

2*(6.0/1.0 * 0.5) => float gain;

CGuitarMandolinMIDI guitar;
guitar.update_timing_from_bpm();
// connection and setting gain (volume)
guitar.connect(gain);
//
guitar.set_global_pan(0.1);

// Datas
[ 
    1680, 2040, 2280, 2640, 2760, 2880, 3240, 3600, 3840, 4080, 4320, 4440, 4560, 4800, 5040, 5280, 5520, 5760, 6000, 6480, 6600, 6720, 6960, 7200, 7440, 7920, 8160, 8400, 8640, 8880, 9120, 9240, 9360, 9600, 9840, 10080, 10320, 10560, 10800, 11040, 11160, 11280, 11400, 11520, 11760, 12000, 12240, 12480, 12840, 13200, 13440, 13800, 14160, 14400, 14760, 15120, 15600, 15840, 16320, 16560, 16800, 17040, 17280, 17640, 18000, 18240, 18360, 18480, 18600, 18720, 18960, 19080, 19200, 19440, 19560, 19680, 19920, 20040, 20160, 20400, 20520, 20640, 20880, 21000, 21120, 21360, 21480, 21600, 21840, 22080, 22440, 22800, 23040, 23280, 23520, 23760, 24000, 24240, 24480, 24720, 24960, 25080, 25200, 25320, 25440, 25560, 25680, 25800, 25920, 26040, 26160, 26280, 26400, 26520, 26640, 26760, 26880, 27000, 27120, 27240, 27360, 27480, 27600, 27720, 27840, 27960, 28080, 28200, 28320, 28440, 28560, 28680, 28800, 28920, 29040, 29160, 29280, 29400, 29520, 29640, 29760, 29880, 30000, 30120, 30240, 30360, 30480, 30600, 30720, 30840, 30960, 31080, 31200, 31320, 31440, 31560, 31680, 31920, 32040, 32160, 32400, 32640
] @=> int array_dates_instrument[];
[ 
    43, 43, 45, 45, 43, 41, 40, 41, 43, 45, 45, 43, 41, 40, 38, 40, 38, 40, 38, 36, 38, 36, 33, 31, 31, 31, 35, 38, 41, 43, 43, 45, 48, 47, 48, 43, 48, 47, 48, 48, 50, 48, 47, 48, 43, 47, 43, 43, 43, 43, 43, 43, 41, 40, 38, 36, 31, 31, 35, 31, 43, 43, 52, 52, 52, 52, 50, 50, 50, 50, 48, 48, 48, 47, 47, 47, 45, 45, 45, 43, 43, 43, 41, 41, 41, 40, 40, 40, 41, 43, 45, 43, 43, 43, 43, 43, 43, 52, 52, 52, 52, 53, 52, 50, 52, 53, 52, 50, 52, 53, 52, 50, 52, 53, 52, 50, 52, 53, 52, 50, 52, 53, 52, 50, 52, 53, 52, 50, 52, 53, 52, 50, 52, 53, 52, 50, 52, 50, 48, 50, 48, 45, 48, 45, 43, 45, 43, 40, 43, 40, 38, 40, 38, 36, 38, 36, 40, 43, 40, 43, 45, 48
] @=> int array_midi_notes_instrument[];
[ 
    240, 240, 360, 120, 120, 360, 360, 240, 240, 120, 120, 120, 240, 240, 240, 240, 240, 240, 360, 120, 120, 240, 240, 240, 360, 240, 240, 240, 240, 240, 120, 120, 240, 240, 240, 240, 240, 240, 240, 120, 120, 120, 120, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 360, 360, 480, 120, 480, 240, 240, 120, 120, 360, 360, 240, 120, 120, 120, 120, 120, 120, 120, 240, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 240, 360, 360, 120, 120, 120, 120, 240, 120, 120, 120, 240, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 240, 120, 120, 240, 240, 240
] @=> int array_durations_instrument[];
[ 
    0, 0, 2, 2, 0, 3, 2, 3, 0, 2, 2, 0, 3, 2, 0, 2, 0, 2, 0, 3, 0, 3, 0, 3, 3, 3, 2, 0, 3, 0, 0, 2, 1, 0, 1, 0, 1, 0, 1, 1, 3, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 3, 2, 0, 3, 3, 3, 2, 3, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 1, 1, 1, 0, 0, 0, 2, 2, 2, 0, 0, 0, 3, 3, 3, 2, 2, 2, 3, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 3, 0, 1, 0, 3, 0, 1, 0, 3, 0, 1, 0, 3, 0, 1, 0, 3, 0, 1, 0, 3, 0, 1, 0, 3, 0, 1, 0, 3, 0, 1, 0, 3, 0, 3, 1, 3, 1, 2, 1, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 3, 0, 3, 2, 0, 2, 0, 2, 1
] @=> int array_frets_instrument[];
[ 
    3, 3, 3, 3, 3, 4, 4, 4, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 5, 4, 5, 5, 6, 6, 6, 5, 4, 4, 3, 3, 3, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2, 2, 3, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 5, 6, 6, 5, 6, 3, 3, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 2, 1, 2, 2, 2, 2, 3, 2, 3, 3, 3, 3, 4, 3, 4, 4, 4, 4, 5, 4, 5, 4, 3, 4, 3, 3, 2
] @=> int array_strings_instrument[];

// Load Data
guitar.append( array_dates_instrument, array_midi_notes_instrument, array_durations_instrument, array_frets_instrument, array_strings_instrument );

// MAIN LOOP
while(true)
{        
    guitar.update();    
    guitar.play(); // consume time and update tick for midi engine
}