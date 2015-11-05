[ 
    [ 3840, 4080, 4560, 4800, 5040, 5520, 5760, 6000, 6480, 6960, 7440, 7680, 7920, 8400, 8640, 8880, 9360, 9600, 9840, 10320, 10560, 10800, 11040, 11280, 11520, 11760, 12240, 12480, 12720, 13200, 13440, 13680, 13920, 14160, 14400, 14640, 14880, 15120, 15360, 15600, 16080, 16320, 16560, 17040, 17280, 17520, 18000, 18240, 18480, 18720, 18960, 19200, 19440, 19920, 20160, 20400, 20880, 21120, 21360, 21840, 22320, 22800, 23040, 23280, 23760, 24000, 24240, 24720, 24960, 25200, 25680, 25920, 26160, 26400, 26640, 26880, 27120, 27600, 27840, 28080, 28560, 28800, 29040, 29280, 29520, 29760, 30000, 30240, 30480, 30720, 30960, 31440, 31680, 31920, 32400, 32640, 32880, 33360, 33600, 33840, 34080, 34320, 34560 ]
] @=> int arrays_dates_instrument[][];
[ 
    [ 36, 36, 36, 29, 29, 29, 31, 31, 31, 31, 31, 36, 36, 36, 29, 29, 29, 31, 31, 31, 43, 31, 43, 31, 36, 36, 36, 29, 29, 29, 31, 43, 31, 43, 31, 43, 31, 31, 36, 36, 48, 29, 29, 41, 31, 31, 43, 31, 31, 43, 31, 36, 36, 36, 29, 29, 29, 31, 31, 31, 31, 31, 36, 36, 36, 29, 29, 29, 31, 31, 31, 43, 31, 43, 31, 36, 36, 36, 29, 29, 29, 31, 43, 31, 43, 31, 43, 31, 31, 36, 36, 48, 29, 29, 41, 31, 31, 43, 31, 31, 43, 31, 36 ]
] @=> int arrays_midi_notes_instrument[][];
[ 
    [ 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 480 ]
] @=> int arrays_durations_instrument[][];

CBassRhodeyMIDI midis[arrays_durations_instrument.cap()];

midis[0] @=> CBassRhodeyMIDI midi;

midi.set_tempo(144);
midi.update_timing_from_bpm();

for( 0 => int id_instrument; id_instrument < arrays_dates_instrument.cap(); id_instrument++)
{
    midis[id_instrument] @=> midi;
    
    arrays_dates_instrument[id_instrument] @=> int array_dates_instrument[];
    arrays_midi_notes_instrument[id_instrument] @=> int array_midi_notes_instrument[];
    arrays_durations_instrument[id_instrument] @=> int array_durations_instrument[];

    midi.append( array_dates_instrument, array_midi_notes_instrument, array_durations_instrument);
    
    midi.connect(1.0/arrays_durations_instrument.cap());
}


while(true)
{    
    for( 0 => int id_instrument; id_instrument < arrays_dates_instrument.cap(); id_instrument++)
    {
        midis[id_instrument] @=> midi;
        midi.update();
    }
    midi.play(); // consume time and update tick for midi engine
}