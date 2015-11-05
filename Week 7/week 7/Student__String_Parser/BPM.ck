// BPM.ck

public class BPM 
{
    // global variables
    dur myDuration[6];
    static dur wholeNote, halfNote, quarterNote, eighthNote, sixteenthNote, thirtysecondNote;
    
    fun void tempo (float beat)
    {
        60.0/beat => float SPB; // seconds per beat
        SPB::second => quarterNote;
        (SPB*4.0)::second => wholeNote;
        (SPB*2.0)::second => halfNote;
        (SPB/2.0)::second => eighthNote;
        (SPB/4.0)::second => sixteenthNote;
        (SPB/8.0)::second => thirtysecondNote;
        
        // store in array for handy reference
        [wholeNote, halfNote, quarterNote, eighthNote, sixteenthNote, thirtysecondNote] @=> myDuration;
    }
}