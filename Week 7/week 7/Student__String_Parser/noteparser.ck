// noteparser.ck

public class NoteParser
{
/*
    fun int parseNote(string note)
    -- parse a note name string 
       returns a corresponding midi note value or -1 if note value is out of range.
       
       note must take the form ['A'..'G'||'a'..'g']{'#'|'b'}[0-9]
       examples: "C4" will return 48
                 "Ab3" will return 44
                 "f#6" will return 78
                 
       Note names are case insensitive, However, it's easier to see the flat symbol ("b") if uppercase is used.

       Unusual results - while the code is robust enough to detect incorrect note name characters 
       (in which case the return value is -1), it is possible to input incorrect parameters for the #/b which
       will cause improper results. While Midi accepts values from 0 - 127, this function will only return values
       from 0 to 120 (accomplished by issuing "B#9"). I'll fix this once I have more docs on string functions.
       
       Also note that piano C4 (midi note 60) will be parsed as C5
*/
    fun int parseNote(string note)
    {
        [0, 2, 4, 5, 7, 9, 11] @=> int baseNotes[]; // C D E F G A B
        0 => int noteVal;
        0 => int pNote;
        
        // The scale begins at C, so handle the A & B separately
        if (note.substring(pNote,1) == "a" || note.substring(pNote) == "A")
        {
            baseNotes[5] => noteVal;
            pNote++;
        }
        else if (note.substring(pNote,1) == "b" || note.substring(pNote) == "B")
        {
            baseNotes[6] => noteVal;
            pNote++;
        }
        else 
        {
            if  (!(note.substring(pNote,1).charAt(0) - 65 < 7) && (!(note.substring(pNote,1).charAt(0) - 97 < 7)) )
            {
                -1 => noteVal;
                return noteVal;
            }
            baseNotes[note.charAt(pNote) - 67 - (32*(note.charAt(pNote) > 72))] => noteVal;
            pNote++;
        } 
        
        // handle sharp or flat
        if (note.substring(pNote,1) == "#" || note.substring(pNote,1) == "b")
        {
            if (note.substring(pNote,1) == "#")
                noteVal++;
            else
                noteVal--;
            pNote++;
        }
        
        // calculate the octave
        Std.atoi(note.substring(pNote,1)) * 12 + noteVal => noteVal;
        
        return noteVal;
    }
    
    
    /*
        fun string midi2Note( int m, int sflag)
        -- convert an integer midi note value to it's string representation
           m is the value of interest
           sflag determines sharp or flat scale to be used. 
    
           midi2Note( 49, true ) will return "C#4"
           midi2Note( 49, false ) will return "Db4"
    */
    fun string midi2Note( int m, int sflag )
    {
        ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"] @=> string noteSharpNames[];
        ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"] @=> string noteFlatNames[];
        
        if (sflag)
            return (noteSharpNames[m % 12] + Std.itoa(m / 12));
        else
            return (noteFlatNames[m % 12] + Std.itoa(m / 12));
        // Should never get here...
        return "Unexpected problem with function midi2Note";    
    }
}
