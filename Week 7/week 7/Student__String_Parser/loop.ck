// loop.ck
// main execution loop

BPM bpmTempo; 
bpmTempo.tempo(96); // set overall tempo

NoteParser noteTable; // look up functions for the individual notes
Pan2 pdrum => dac;
DrumSet drm;
drm.connect( pdrum );
0.25 => drm.mGain.gain;
-0.5 => pdrum.pan;

Pan2 pbass => dac;
Bass bass;
bass.connect( pbass );
.75 => bass.g.gain;
0.5 => pbass.pan;

Organ organ;
organ.connect( dac );
.1 => organ.mGain.gain;

[ "F3", "F4", "F3", "F4"] @=> string bline[];


0 => int measure; // measure counter
0 => int count;   // beat counter


30::second => dur songLength;   // set tune length
now => time startTime;
while (now < (startTime + songLength))
{
    spork ~ drm.hh();  // fire a hi hat on every beat
    if ( count % 2 == 0 ) 
    { 
        spork ~ drm.bd(); // fire the kick
    } 
    if ( count % 4 == 2 ) 
    { 
        spork ~ drm.sn(); // snare on the off beat
    } 

    if (measure > 1) // play the bass line
    { 
        if ( count % 4 == 0 || count % 4 == 1) 
            { spork ~ bass.bass( noteTable.parseNote(bline[measure % 4]), bpmTempo.sixteenthNote); }
        if ( count % 4 == 2 || count % 4 == 3 ) 
            { spork ~ bass.bass( 12 + noteTable.parseNote(bline[measure % 4]), bpmTempo.eighthNote); }
        
    }
    
    // the rest of this just plays the organ part
    if (measure == 4 || measure == 6 || measure == 8)
    {
        if (count % 8 == 0)
        {
            spork ~ organ.play(0, bpmTempo.halfNote);
        }
        
        if (count % 8 == 4)
        {
            spork ~organ.play(1, bpmTempo.halfNote);
        }
            
    }
    
    if (measure == 9)
    {
        if (count % 8 == 0)
        {
            spork ~ organ.play(2, bpmTempo.halfNote);
        }
        if (count % 8 == 4)
        {
            spork ~ organ.play(3, bpmTempo.halfNote);
        }
    }
    
    if (measure == 10)
    {
        if (count % 8 == 0)
        {
            spork ~ organ.play( 4, bpmTempo.wholeNote);
        }
    }
    
    if (measure >= 11)
    {
        if (count % 2 == 1 && count % 8 < 5)
        {
            spork ~ organ.play( 4, bpmTempo.eighthNote);
        }
    }

    1 + count => count;
    if ( count % 8 == 0 ) 
    { 
        measure++; 
    }
    
    bpmTempo.eighthNote => now;
}