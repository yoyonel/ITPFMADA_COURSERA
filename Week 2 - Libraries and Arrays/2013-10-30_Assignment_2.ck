// "3. Make quarter Notes (main compositional pulse) .25::second in your composition."
// double croche, croche, noire, blanche, ronde
[ 0.125, 0.25, 0.5, 1, 2 ] @=> float arr_Durations_NotesValues[];    


// "Make sure to ONLY use these MIDI Notes in your composition: 50, 52, 53, 55, 57, 59, 60, 62"
// "(for musicians, this is a D Dorian scale)"
// using scale : D Dorian
[ 50, 52, 53, 55, 57, 59, 60, 62 ] @=> int arr_MidiNotes_Assessment_2[];

0 => int mifs;

//
// Song: express in degrees relativ to the scale
//
//
// Intro + variations
//
[   
    1,    mifs,  1,  mifs,  2,  mifs,  mifs,      
    1,    mifs,  1,  mifs,  2,  5,  5,    5,  5,  mifs   
] @=> int arr_Degrees_Intro_1[];
[   
    1.0,  0.0,1.0,0.0,1.0,2.0,2.0,    
    1.0,  0.0,1.0,0.0,1.0,0.0,1.5,  0.0,1.0,0.0 
] @=> float arr_NotesValues_Intro_1[];
//
[   
    1,    mifs,  1,  mifs,  2,  mifs,  mifs,      
    1,    mifs,  1,  mifs,  2,  5,  4,    3,  2   
] @=> int arr_Degrees_Intro_2[];
[   
    1.0,  0.0,1.0,0.0,1.0,2.0,2.0,    
    1.0,  0.0,1.0,0.0,1.0,1.0,1.0,  1.0,1.0 
] @=> float arr_NotesValues_Intro_2[];
//
[   
    1,    mifs,  1,  mifs,  2,  mifs,  mifs,      
    1,    mifs,  1,  mifs,  2,  mifs,  5,    mifs,  5   
] @=> int arr_Degrees_Intro_3[];
[   
    1.0,  0.0,1.0,0.0,1.0,2.0,2.0,    
    1.0,  0.0,1.0,0.0,1.0,1.0,1.0,  1.0,1.0 
] @=> float arr_NotesValues_Intro_3[];
//
[   
    1,    mifs,  1,  mifs,  2,  mifs,  mifs,      
    1,    mifs,  1,  mifs,  2,  5,  mifs,    3,  3,  5  
] @=> int arr_Degrees_Intro_4[];
//
[   
    1.0,  0.0,1.0,0.0,1.0,2.0,2.0,    
    1.0,  0.0,1.0,0.0,1.0,1.0,0.0,  0.0,1.0,1.0 
] 
    @=> float arr_NotesValues_Intro_4[];
    
// Save the length of arrays (using in for loops after)
[
arr_Degrees_Intro_1.cap(),
arr_Degrees_Intro_2.cap(),
arr_Degrees_Intro_3.cap(),
arr_Degrees_Intro_4.cap()
] @=> int arr_Cap_Intros[];

// Main Riff + variations
//
[ 1,    2,  3,  5,  3,  5,  2,  1,  2,  5,  3,  2   ] @=> int arr_Degrees_Main[];
[ 1.5,  1.5,2.0,1.0,1.0,1.0,1.5,1.5,2.0,1.0,1.0,1.0 ] @=> float arr_NotesValues_Main[];
//

// Outro + variations
//

// "using Sine Waves (SineOsc), Triangle Waves (TriOsc)"
// "Include Panning (moving sound from left to right)."
SinOsc osc1 => Pan2 osc1_pan => dac;
//TriOsc osc1 => dac;

0.5 => float initial_gain;
initial_gain => osc1.gain;

float duration;

// offset
0*12 => int offset_degree_midi;

// INTRO
for( 0 => int repetition_intro; repetition_intro < 4; repetition_intro++)
{
    // "Use tools from the standard library, including random numbers"
    Std.rand2( 0, arr_Cap_Intros.cap() - 1 ) => int id_intro;
    
    //Std.rand2f( -0.5, 0.5 ) => osc1_pan.pan;
    
    for( 0 => int i; i < arr_Cap_Intros[id_intro]; i++ )
    {
        int degree;
        float fNoteValue;
        // get the degree of the note
        // get the value of the note
        if( id_intro == 0 )
        {            
            arr_Degrees_Intro_1[i] => degree;
            arr_NotesValues_Intro_1[i] => fNoteValue;
        }
        else if( id_intro == 1)
        {
            arr_Degrees_Intro_2[i] => degree;
            arr_NotesValues_Intro_2[i] => fNoteValue;
        }
        else if( id_intro == 2)
        {
            arr_Degrees_Intro_3[i] => degree;
            arr_NotesValues_Intro_3[i] => fNoteValue;
        } 
        else if( id_intro == 3)
        {
            arr_Degrees_Intro_4[i] => degree;
            arr_NotesValues_Intro_4[i] => fNoteValue;
        }   
        
        // convert the float value to int value
        Std.ftoi( fNoteValue ) => int iNoteValue;        
        
        // get the value note and add the "augmented" value 
        // we use the float part of the note value (float part of the value)
        // and use it like a ratio on the int note value
        // that's simulate the '.' notation in solfege (augmented note value)
        arr_Durations_NotesValues[ iNoteValue ] * (1 + (fNoteValue-iNoteValue)) => float note_value;          
        // copy the result note value
        note_value => duration;
        
        // is a silence note ?
        if( degree == mifs )
        { // yes
            //if( osc1.gain() < initial_gain*0.5 )
            if( true )
            {
                // set to 0.0 the gain
                //0.0 => osc1.gain;
                // "play" the silence (sound of silence ;-))
                duration::second => now;
            }
            else
            {
                // set the gain
                //initial_gain => osc1.gain;
                osc1.gain() => float start_gain;
                0.0 => float end_gain;
                
                // use a gauss function to smooth the "attack" of the note
                // gaussian parameters function            
                16.00 => float sigma;                       
                // url: http://en.wikipedia.org/wiki/Full_width_at_half_maximum
                2.355 * sigma => float FWHM;
                0.00 => float mu;            
                1.0 / (sigma*Math.sqrt(2*pi)) => float a;
                mu @=> float b;     // alias
                sigma @=> float c;  // alias
                //<<< "constante:", 2.35482 * c >>>;
                
                // nb samples for the discretisation of this gaussion function
                512 => int nb_samples_for_gauss_function;
                
                // define the domain parameter
                0.0 => float min_x_gauss;                
                1.1*FWHM => float max_x_gauss;
                
                // step for discretisation
                (max_x_gauss - min_x_gauss) / (nb_samples_for_gauss_function $ float) => float step_param_gauss;
                // step for timing
                duration / (nb_samples_for_gauss_function $ float) => float step_dur_time;
                                                
                Math.max( Std.fabs(min_x_gauss), Std.fabs(max_x_gauss) ) => float param_gauss_for_min_value;
                float param_gauss_for_max_value;
                if( Math.sgn(min_x_gauss) == Math.sgn(max_x_gauss) )
                    Math.min( Std.fabs(min_x_gauss), Std.fabs(max_x_gauss) ) => param_gauss_for_max_value;
                else
                     0.0 => param_gauss_for_max_value;
                
                a*Math.exp( -Math.pow(param_gauss_for_min_value-b, 2.0) / (2*Math.pow(c, 2.0)) ) => float min_gauss_value;
                a*Math.exp( -Math.pow(param_gauss_for_max_value-b, 2.0) / (2*Math.pow(c, 2.0)) ) => float max_gauss_value;
                
                1.0 / (max_gauss_value - min_gauss_value) => float normalize_gauss_value;
                //<<< "min_gauss_value: ", min_gauss_value >>>;
                //<<< "max_gauss_value: ", max_gauss_value >>>;
                
                // start parameter value
                min_x_gauss => float x;        
                1.0 / (2*Math.pow(c, 2.0)) => float d; 
                float gauss_evaluation;
                for( 0 => int j; j < nb_samples_for_gauss_function; j++ )
                {
                    // evaluate the gauss function            
                    a*Math.exp( -Math.pow(x-b, 2.0) * d) => gauss_evaluation;
                    
                    // normalize the value
                    min_gauss_value -=> gauss_evaluation;            
                    normalize_gauss_value *=> gauss_evaluation;            
                    //<<< "gauss_evaluation: ", gauss_evaluation >>>;
                    
                    // modify the gain
                    //initial_gain * gauss_evaluation => osc1.gain;
                    start_gain + (end_gain - start_gain)*(1.0-gauss_evaluation) => osc1.gain;
                    //
                    step_param_gauss +=> x;
                    //
                    step_dur_time::second => now;
                }
                //<<< "gauss_evaluation : " , gauss_evaluation >>>;
                //<<< "fin silence -  gain:" , osc1.gain() >>>;
            }
        }
        else 
        { // no                        
            1 -=> degree;
            
            arr_MidiNotes_Assessment_2[degree] => int midi_note;
            
            offset_degree_midi -=> midi_note; // offset scale
            
            // "Use tools from the standard library, including STD.mtof()"
            Std.mtof( midi_note ) => osc1.freq;
            
            //<<< osc1.gain() >>>;
            if( osc1.gain() > (initial_gain*0.5) )
            {                
                duration::second => now;
            }
            else
            {
                <<< osc1.gain() >>>;
                // set the gain
                //initial_gain => osc1.gain;
                osc1.gain() => float start_gain;
                initial_gain  => float end_gain;
                
                // use a gauss function to smooth the "attack" of the note
                // gaussian parameters function            
                16.00 => float sigma;                       
                // url: http://en.wikipedia.org/wiki/Full_width_at_half_maximum
                2.355 * sigma => float FWHM;
                0.00 => float mu;            
                1.0 / (sigma*Math.sqrt(2*pi)) => float a;
                mu @=> float b;     // alias
                sigma @=> float c;  // alias
                //<<< "constante:", 2.35482 * c >>>;
                
                // nb samples for the discretisation of this gaussion function
                512 => int nb_samples_for_gauss_function;
                
                // define the domain parameter
                -1.1*FWHM => float min_x_gauss;
                //-(FWHM/1.5) => float min_x_gauss;
                //-5.0 - mu => float min_x_gauss;  // 
                //5.0 + mu => float max_x_gauss;  // 
                0.0 => float max_x_gauss;
                
                // step for discretisation
                (max_x_gauss - min_x_gauss) / (nb_samples_for_gauss_function $ float) => float step_param_gauss;
                // step for timing
                duration / (nb_samples_for_gauss_function $ float) => float step_dur_time;
                                                
                Math.max( Std.fabs(min_x_gauss), Std.fabs(max_x_gauss) ) => float param_gauss_for_min_value;
                float param_gauss_for_max_value;
                if( Math.sgn(min_x_gauss) == Math.sgn(max_x_gauss) )
                    Math.min( Std.fabs(min_x_gauss), Std.fabs(max_x_gauss) ) => param_gauss_for_max_value;
                else
                     0.0 => param_gauss_for_max_value;
                
                a*Math.exp( -Math.pow(param_gauss_for_min_value-b, 2.0) / (2*Math.pow(c, 2.0)) ) => float min_gauss_value;
                a*Math.exp( -Math.pow(param_gauss_for_max_value-b, 2.0) / (2*Math.pow(c, 2.0)) ) => float max_gauss_value;
                
                1.0 / (max_gauss_value - min_gauss_value) => float normalize_gauss_value;
                //<<< "min_gauss_value: ", min_gauss_value >>>;
                //<<< "max_gauss_value: ", max_gauss_value >>>;
                
                // start parameter value
                min_x_gauss => float x;        
                1.0 / (2*Math.pow(c, 2.0)) => float d; 
                for( 0 => int j; j < nb_samples_for_gauss_function; j++ )
                {
                    // evaluate the gauss function            
                    a*Math.exp( -Math.pow(x-b, 2.0) * d) => float gauss_evaluation;
                    
                    // normalize the value
                    min_gauss_value -=> gauss_evaluation;            
                    normalize_gauss_value *=> gauss_evaluation;            
                    //<<< "gauss_evaluation: ", gauss_evaluation >>>;
                    
                    // modify the gain
                    //initial_gain * gauss_evaluation => osc1.gain;
                    start_gain + (end_gain - start_gain)*gauss_evaluation => osc1.gain;
                    
                    //
                    step_param_gauss +=> x;
                    //
                    step_dur_time::second => now;
                }
            }
        }
    }
}

// MAIN THEME
for( 0 => int repetition_main; repetition_main < 4; repetition_main++)
{
    for( 0 => int i; i < arr_Degrees_Main.cap(); i++ )
    {
        //
        arr_Degrees_Main[i] => int degree;    
        //
        arr_NotesValues_Main[i] => float fNoteValue;
        Std.ftoi( fNoteValue ) => int iNoteValue;
        
        arr_Durations_NotesValues[ iNoteValue ] * (1 + (fNoteValue-iNoteValue)) => float note_value;          
        note_value => duration;        
        //
        //<<< fNoteValue-iNoteValue >>>;
        //<<< note_value >>>;    
            
        
        // is a silence note ?
        if( degree == 0 )
        { // yes
            // set to 0.0 the gain
            0.0 => osc1.gain;
            // "play" the silence (sound of silence ;-))
            duration::second => now;
        }
        else 
        { // no                        
            1 -=> degree;
            arr_MidiNotes_Assessment_2[degree] => int midi_note;
            offset_degree_midi -=> midi_note; // offset scale, down 1 octav below
            Std.mtof( midi_note ) => osc1.freq;
            
            if( osc1.gain() != 0.0 )
            {                
                duration::second => now;
            }
            else
            {
                // set the gain
                initial_gain => osc1.gain;
                // use a gauss function to smooth the "attack" of the note
                // gaussian parameters function            
                16.00 => float sigma;                       
                // url: http://en.wikipedia.org/wiki/Full_width_at_half_maximum
                2.355 * sigma => float FWHM;
                0.00 => float mu;            
                1.0 / (sigma*Math.sqrt(2*pi)) => float a;
                mu @=> float b;     // alias
                sigma @=> float c;  // alias
                //<<< "constante:", 2.35482 * c >>>;
                
                // nb samples for the discretisation of this gaussion function
                512 => int nb_samples_for_gauss_function;
                
                // define the domain parameter
                -1.1*FWHM => float min_x_gauss;
                //-(FWHM/1.5) => float min_x_gauss;
                //-5.0 - mu => float min_x_gauss;  // 
                //5.0 + mu => float max_x_gauss;  // 
                1.1*FWHM => float max_x_gauss;
                
                // step for discretisation
                (max_x_gauss - min_x_gauss) / (nb_samples_for_gauss_function $ float) => float step_param_gauss;
                // step for timing
                duration / (nb_samples_for_gauss_function $ float) => float step_dur_time;
                                                
                Math.max( Std.fabs(min_x_gauss), Std.fabs(max_x_gauss) ) => float param_gauss_for_min_value;
                float param_gauss_for_max_value;
                if( Math.sgn(min_x_gauss) == Math.sgn(max_x_gauss) )
                    Math.min( Std.fabs(min_x_gauss), Std.fabs(max_x_gauss) ) => param_gauss_for_max_value;
                else
                     0.0 => param_gauss_for_max_value;
                
                a*Math.exp( -Math.pow(param_gauss_for_min_value-b, 2.0) / (2*Math.pow(c, 2.0)) ) => float min_gauss_value;
                a*Math.exp( -Math.pow(param_gauss_for_max_value-b, 2.0) / (2*Math.pow(c, 2.0)) ) => float max_gauss_value;
                
                1.0 / (max_gauss_value - min_gauss_value) => float normalize_gauss_value;
                //<<< "min_gauss_value: ", min_gauss_value >>>;
                //<<< "max_gauss_value: ", max_gauss_value >>>;
                
                // start parameter value
                min_x_gauss => float x;        
                1.0 / (2*Math.pow(c, 2.0)) => float d; 
                for( 0 => int j; j < nb_samples_for_gauss_function; j++ )
                {
                    // evaluate the gauss function            
                    a*Math.exp( -Math.pow(x-b, 2.0) * d) => float gauss_evaluation;
                    
                    // normalize the value
                    min_gauss_value -=> gauss_evaluation;            
                    normalize_gauss_value *=> gauss_evaluation;            
                    //<<< "gauss_evaluation: ", gauss_evaluation >>>;
                    
                    // modify the gain
                    initial_gain * gauss_evaluation => osc1.gain;
                    //
                    step_param_gauss +=> x;
                    //
                    step_dur_time::second => now;
                }
            }
        }
    }
}