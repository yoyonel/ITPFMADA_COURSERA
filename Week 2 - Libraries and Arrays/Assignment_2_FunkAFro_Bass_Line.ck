// Assignment #2: Make a Melody
// title: Assigment_2_FunkAfro_Bass_Line

// Summary: Play a 'riff'/'song' encode in arrays (midi and value notes)
// The style is close to AfroBeat Music (http://fr.wikipedia.org/wiki/Afrobeat)
// With a attenuation function (Gaussian Function), i modify the gain for each note 
// and obtain a sound effect. It's for style and prevent the pop/crack sound when we change the gain.

// help to be sure to have a 30seconds length
now => time start_song;

// We use Gaussian function to compute a attenuation factor
// url: http://en.wikipedia.org/wiki/Gaussian_function
// f(x) = a * e^( -( (x-b)^2 / 2*c^2 )) ) + d
// - a = 1 / ( sigma * sqrt(2pi) )
// - b = mu
// - c = sigma
//
// parameters for attenuation 
1.0 => float sigma;
//Math.sqrt(0.02) => float sigma;
0.0 => float mu; // (not useful for our application)
// assign parameters : a, b & c
1 / ( sigma * Math.sqrt(2*pi) ) => float a;
mu => float b;
sigma => float c;
0.0 => float d;
//
// Full width at half maximum : FWHM
// url: http://en.wikipedia.org/wiki/Full_width_at_half_maximum
2.355 * sigma => float FWHM;
mu +=> FWHM;

// x : input parameter for gaussian function evaluation
float x;

// domain value for x
// constraints on x domain values :
// - start_x < end_x
// - end_x <= 0.0
//
-1.5*FWHM => float start_x;
mu => float end_x;
//

// min, max value for this part of the gaussian function
a * Math.exp(-Math.pow(end_x    - b, 2.0)/(2*Math.pow(c, 2.0))) + d => float attenuation_function_max;
a * Math.exp(-Math.pow(start_x  - b, 2.0)/(2*Math.pow(c, 2.0))) + d => float attenuation_function_min;
// help to remap [attenuation_function_min, attenuation_function_max] to [0.0, 1.0]
1.0 / (attenuation_function_max - attenuation_function_min) => float attenuation_function_rescale; 

// # samples to discretise our Gaussian function (and effects)
2048 => int nb_samples;

// naive method: false, true, false, false
// 'smart' method (avoid pop & crack sound) : true, true, true, true
true    => int b_play_silence;
true    => int b_use_full_gain;
true    => int b_use_fall_in_gain;
true    => int b_use_fall_off_gain;

// Timing for the "push/release" note
// Some groove is here ! (Design properties of our 'instrument')
// => timing for "push" a key - very fast (<=> very short) : 2%
// => timing to "release/pop" a key - slow (<=> long) : 95%
0.02 => float ratio_timing_for_attack_step_in;
0.95 => float ratio_timing_for_attack_step_out;
// constraint: ratio_timing_for_attack_step_in+ratio_timing_for_attack_step_out <= 1.0
// => timing to "keep pressing" the key - fast (<=> short) : 3% = 100% - (95%+2%)
1.00 - (ratio_timing_for_attack_step_in + ratio_timing_for_attack_step_out) => float ratio_timing_for_constant_gain;


// "3. Make quarter Notes (main compositional pulse) .25::second in your composition."
// double croche, croche, noire, blanche, ronde
[ 0.125, 0.25, 0.5, 1, 2 ] @=> float arr_Durations_NotesValues[];    


// "Make sure to ONLY use these MIDI Notes in your composition: 50, 52, 53, 55, 57, 59, 60, 62"
// "(for musicians, this is a D Dorian scale)"
// using scale : D Dorian (<=> same notes of C-Maj) -> 1t 1/2t 1t 1t 1t 1/2t 1t
[ 
    50, 52, 53, 55, 
    57, 59, 60, 62 
] @=> int arr_MidiNotes_Assessment_2[];

// Midi Indice For Silence (MIFS)
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
// array of values note, 
// For example : 
//  value = 1.5
//  - 1     for index on arr_Durations_NotesValues -> arr_Durations_NotesValues[1] = 0.25
//  - .5    for alteration -> arr_Durations_NotesValues[1] + arr_Durations_NotesValues[1]*0.5 = 0.25 + 0.25*0.5 = 0.375
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
] @=> float arr_NotesValues_Intro_4[];

// Save the length of arrays (using in for loops after)
[
    arr_Degrees_Intro_1.cap(),
    arr_Degrees_Intro_2.cap(),
    arr_Degrees_Intro_3.cap(),
    arr_Degrees_Intro_4.cap()
] @=> int arr_Cap_Intros[];

// Main Riff
//
[ 
    1,  2,  3,  5,  3,  5,  
    2,  1,  2,  5,  3,  2   
] @=> int arr_Degrees_Main[];
[ 
    1.5,    1.5,    2.0,    1.0,    1.0,    1.0,
    1.5,    1.5,    2.0,    1.0,    1.0,    1.0 
] @=> float arr_NotesValues_Main[];
//

// Outro
//
[ 
    1, mifs, 1, mifs, 1, mifs, 5, 
    1, mifs, 1, mifs, 1, mifs, 5, mifs, 5,
    1, mifs, 1, mifs, 1, mifs, 5,
    1, mifs, 1, mifs, 1, 5, 4, 3, 2
] @=> int arr_Degrees_Outro[];
[ 
    1.0, 0.0, 1.0, 0.0, 1.0, 2.0, 2.0,
    1.0, 0.0, 1.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    1.0, 0.0, 1.0, 0.0, 1.0, 2.0, 2.0,
    1.0, 0.0, 1.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0 
] @=> float arr_NotesValues_Outro[];


// "using Sine Waves (SineOsc), Triangle Waves (TriOsc)"
// "Include Panning (moving sound from left to right)."
// Using to oscillator for our song

SinOsc osc1 => Pan2 osc1_pan => dac;
TriOsc osc2 => Pan2 osc2_pan => dac;

false => int bSaveTheSongInWavFile;
WvOut2 w;
if( bSaveTheSongInWavFile )
{
    // url: http://chuck.cs.princeton.edu/doc/examples/basic/rec-auto-stereo.ck
    // pull samples from the dac
    // WvOut2 -> stereo operation
    dac => w => blackhole;
    me.dir() + "/Assignment_2.wav" => w.wavFilename;
}

// Max gain
0.15 => float max_gain;

// Timing for a note
float duration;

// Offset on degrees (low 1 octav)
1*12 => int offset_degree_midi;

// 
-0.5 => float osc1_min_pan;
-0.1 => float osc1_max_pan;
//
 0.1 => float osc2_min_pan;
 0.5 => float osc2_max_pan;
//
0.25 => float osc2_min_amp_pan;
0.75 => float osc2_max_amp_pan;

// Design our song, describe repetitions
3 => int nb_repetition_intro;
2 => int nb_repetition_main;
1 => int nb_repetition_outro;

true => int bPlayOsc2;
true => int bPlayOsc1;
//
true => int bSpatialize_Part_Intro;
true => int bSpatialize_Part_Main;
true => int bSpatialize_Part_Outro;
true => int bSpatialize_Part_Last_Note;

// Add some (2d) spatialisation in equalisation
if( bSpatialize_Part_Intro )
{
    // Set a initial random offset for our 2 oscillators
    Std.rand2f(osc1_min_pan, osc1_max_pan) => osc1_pan.pan;
    Std.rand2f(osc2_min_pan, osc2_max_pan) => osc2_pan.pan;
    //
    osc1_pan.pan() => float p1;
    -osc1_pan.pan() => float p1_p;
    osc2_pan.pan() => float p2;
    -osc2_pan.pan() => float p2_p;
    // Add some (2d) spatialisation in equalisation
    Std.rand2f( Math.min(p1, p2_p), Math.max(p1, p2_p) ) => osc1_pan.pan;
    Std.rand2f( Math.min(p2, p1_p), Math.max(p2, p1_p) ) => osc2_pan.pan;
}

// INTRO
for( 0 => int repetition_intro; repetition_intro < nb_repetition_intro; repetition_intro++)
{
    // "Use tools from the standard library, including random numbers"
    // add some random value to choose wich intro we play
    Std.rand2( 0, arr_Cap_Intros.cap() - 1 ) => int id_intro;
    
    // Loop on notes intro
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
            // "play" the silence (sound of silence ;-))
            if( b_play_silence ) duration::second => now;
        }
        else 
        { // no                        
            //
            1 -=> degree;            
            arr_MidiNotes_Assessment_2[degree] => int midi_note;            
            offset_degree_midi -=> midi_note; // offset scale            
            // "Use tools from the standard library, including STD.mtof()"
            Std.mtof( midi_note ) => osc1.freq;
            Std.mtof( midi_note + 12 ) => osc2.freq;
            
            duration => float timing_note;
            
            // 1st step : attack step in
            // domain gain: [0.0 -> gain_max_for_this_note]
            // linear variation : f(x) = x, x=[0.0, g_max]
            if( b_use_fall_in_gain )
            {
                //
                0.0 => float start_gain;
                max_gain => float end_gain;
                //
                timing_note * ratio_timing_for_attack_step_in => float timing_attack_step_in;    
                //    
                timing_attack_step_in / (nb_samples $ float) => float step_timing_note;
                1.0 / (nb_samples $ float) => float step_t;
                
                0.0 => float cur_t;
                
                // Set the initial pan for osc2 (use random value)
                osc2_pan.pan() => float osc2_initial_pan;
                Std.rand2f(osc2_min_amp_pan, osc2_max_amp_pan) => float osc2_amplitude_pan;
                
                // linear approach
                for( 0 => int i; i < nb_samples; i++ )
                {        
                    // update t
                    step_t +=> cur_t;
                    
                    // remap the entry parameter cur_t [0.0, 1.0] to x [start_x, end_x]
                    start_x + cur_t * (end_x - start_x ) => float x;
                    
                    // compute the attenuation coefficient
                    a * Math.exp(-Math.pow(x-b, 2.0)/(2*Math.pow(c, 2.0))) + d  => float attenuation_function_value;
                    
                    // remap the output [attenuation_function_min, attenuation_function_max] to [0.0, 1.0]
                    attenuation_function_min -=> attenuation_function_value;
                    attenuation_function_rescale *=> attenuation_function_value;
                    
                    // project t on domain gain
                    start_gain + attenuation_function_value * (end_gain - start_gain) => float cur_gain;
                    
                    // update the gain
                    cur_gain => osc1.gain;
                    cur_gain => osc2.gain;
                    
                    // Animate pan of osc2
                    osc2_initial_pan + Math.sin(cur_t*2*pi) * osc2_amplitude_pan => osc2_pan.pan;
                    
                    // consume audio time
                    step_timing_note::second => now;
                }
                osc2_initial_pan => osc2_pan.pan;
            }

            // 2nd step: constant gain
            // domain gain: [gain_max_for_this_note -> gain_max_for_this_note] no variation (constant)
            // f(x) = c, c=g_max
            if( b_use_full_gain )
            {
                // update the gain
                max_gain => osc1.gain;
                max_gain => osc2.gain;
                //
                timing_note * ratio_timing_for_constant_gain => float timing_constant_gain;
                // consume audio time
                timing_constant_gain::second => now;
            }

            // last step attack step out
            // domain gain: [gain_max_for_this_note -> 0.0] 
            // linear variation : f(x) = x, x=[g_max, 0.0]
            if( b_use_fall_off_gain )
            {
                //
                max_gain => float start_gain;
                0.0 => float end_gain;
                //
                timing_note * ratio_timing_for_attack_step_out => float timing_attack_step_out;
                //
                timing_attack_step_out / (nb_samples $ float) => float step_timing_note;
                //
                1.0 / (nb_samples $ float) => float step_t;
                0.0 => float cur_t;
                
                osc2_pan.pan() => float osc2_initial_pan;
                Std.rand2f(osc2_min_amp_pan, osc2_max_amp_pan) => float osc2_amplitude_pan;
                
                // linear approach
                for( 0 => int i; i < nb_samples; i++ )
                {
                    // update t
                    step_t +=> cur_t;
                    
                    // remap the entry parameter cur_t [0.0, 1.0] to x [start_x, end_x]
                    start_x + cur_t * (end_x - start_x ) => float x;
                    
                    // compute the attenuation coefficient
                    a * Math.exp(-Math.pow(x-b, 2.0)/(2*Math.pow(c, 2.0))) + d  => float attenuation_function_value;
                    
                    // remap the output to [0.0, 1.0]
                    attenuation_function_min -=> attenuation_function_value;
                    attenuation_function_rescale *=> attenuation_function_value;
                    
                    // project t on domain gain
                    start_gain + attenuation_function_value * (end_gain - start_gain) => float cur_gain;
                    
                    // update the gain
                    cur_gain => osc1.gain;
                    cur_gain => osc2.gain;
                    
                    // Animate pan of osc2
                    osc2_initial_pan + Math.sin(cur_t*2*pi) * osc2_amplitude_pan => osc2_pan.pan;
                    
                    // consume audio time
                    step_timing_note::second => now;
                }
                osc2_initial_pan => osc2_pan.pan;
            }
        }
    }
}

// Add some (2d) spatialisation in equalisation
if( bSpatialize_Part_Main )
{
    // Set a initial random offset for our 2 oscillators
    Std.rand2f(osc1_min_pan, osc1_max_pan) => osc1_pan.pan;
    Std.rand2f(osc2_min_pan, osc2_max_pan) => osc2_pan.pan;
    //
    osc1_pan.pan() => float p1;
    -osc1_pan.pan() => float p1_p;
    osc2_pan.pan() => float p2;
    -osc2_pan.pan() => float p2_p;
    // Add some (2d) spatialisation in equalisation
    Std.rand2f( Math.min(p1, p2_p), Math.max(p1, p2_p) ) => osc1_pan.pan;
    Std.rand2f( Math.min(p2, p1_p), Math.max(p2, p1_p) ) => osc2_pan.pan;
}

// MAIN THEME
// no pan animation for the MAIN theme
for( 0 => int repetition_main; repetition_main < nb_repetition_main; repetition_main++)
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
        
        // is a silence note ?
        if( degree == mifs )
        { // yes           
            // "play" the silence (sound of silence ;-))
            if( b_play_silence ) duration::second => now;
        }
        else 
        { // no                        
            //
            1 -=> degree;            
            arr_MidiNotes_Assessment_2[degree] => int midi_note;            
            offset_degree_midi -=> midi_note; // offset scale            
            // "Use tools from the standard library, including STD.mtof()"
            Std.mtof( midi_note ) => osc1.freq;
            //Std.mtof( midi_note ) => osc2.freq;
            Std.mtof( midi_note + 12 ) => osc2.freq;
            
            duration => float timing_note;
            
            // 1st step : attack step in
            // domain gain: [0.0 -> gain_max_for_this_note]
            // linear variation : f(x) = x, x=[0.0, g_max]
            if( b_use_fall_in_gain )
            {
                //
                0.0 => float start_gain;
                max_gain => float end_gain;
                //
                timing_note * ratio_timing_for_attack_step_in => float timing_attack_step_in;    
                //    
                timing_attack_step_in / (nb_samples $ float) => float step_timing_note;
                1.0 / (nb_samples $ float) => float step_t;
                
                0.0 => float cur_t;
                
                // linear approach
                for( 0 => int i; i < nb_samples; i++ )
                {        
                    // update t
                    step_t +=> cur_t;
                    
                    // remap the entry parameter cur_t [0.0, 1.0] to x [start_x, end_x]
                    start_x + cur_t * (end_x - start_x ) => float x;
                    
                    // compute the attenuation coefficient
                    a * Math.exp(-Math.pow(x-b, 2.0)/(2*Math.pow(c, 2.0))) + d  => float attenuation_function_value;
                    
                    // remap the output [attenuation_function_min, attenuation_function_max] to [0.0, 1.0]
                    attenuation_function_min -=> attenuation_function_value;
                    attenuation_function_rescale *=> attenuation_function_value;
                    
                    // project t on domain gain
                    start_gain + attenuation_function_value * (end_gain - start_gain) => float cur_gain;
                    
                    // update the gain
                    bPlayOsc1*cur_gain => osc1.gain;
                    bPlayOsc2*cur_gain => osc2.gain;
                    
                    // consume audio time
                    step_timing_note::second => now;
                }
            }

            // 2nd step: constant gain
            // domain gain: [gain_max_for_this_note -> gain_max_for_this_note] no variation (constant)
            // f(x) = c, c=g_max
            if( b_use_full_gain )
            {
                // update the gain
                bPlayOsc1 * max_gain => osc1.gain;
                bPlayOsc2 * max_gain => osc2.gain;
                
                timing_note * ratio_timing_for_constant_gain => float timing_constant_gain;
                
                // consume audio time
                timing_constant_gain::second => now;
            }

            // last step attack step out
            // domain gain: [gain_max_for_this_note -> 0.0] 
            // linear variation : f(x) = x, x=[g_max, 0.0]
            if( b_use_fall_off_gain )
            {
                //
                max_gain => float start_gain;
                0.0 => float end_gain;
                //
                timing_note * ratio_timing_for_attack_step_out => float timing_attack_step_out;
                //
                timing_attack_step_out / (nb_samples $ float) => float step_timing_note;
                //
                1.0 / (nb_samples $ float) => float step_t;
                0.0 => float cur_t;
                // linear approach
                for( 0 => int i; i < nb_samples; i++ )
                {
                    // update t
                    step_t +=> cur_t;
                    
                    // remap the entry parameter cur_t [0.0, 1.0] to x [start_x, end_x]
                    start_x + cur_t * (end_x - start_x ) => float x;
                    
                    // compute the attenuation coefficient
                    a * Math.exp(-Math.pow(x-b, 2.0)/(2*Math.pow(c, 2.0))) + d  => float attenuation_function_value;
                    
                    // remap the output to [0.0, 1.0]
                    attenuation_function_min -=> attenuation_function_value;
                    attenuation_function_rescale *=> attenuation_function_value;
                    
                    // project t on domain gain
                    start_gain + attenuation_function_value * (end_gain - start_gain) => float cur_gain;
                    
                    // update the gain
                    bPlayOsc1 * cur_gain => osc1.gain;
                    bPlayOsc2 * cur_gain => osc2.gain;
                    
                    // consume audio time
                    step_timing_note::second => now;
                }
            }
        }
    }
}

// Add some (2d) spatialisation in equalisation
if( bSpatialize_Part_Outro )
{
    // Set a initial random offset for our 2 oscillators
    Std.rand2f(osc1_min_pan, osc1_max_pan) => osc1_pan.pan;
    Std.rand2f(osc2_min_pan, osc2_max_pan) => osc2_pan.pan;
    //
    osc1_pan.pan() => float p1;
    -osc1_pan.pan() => float p1_p;
    osc2_pan.pan() => float p2;
    -osc2_pan.pan() => float p2_p;
    // Add some (2d) spatialisation in equalisation
    Std.rand2f( Math.min(p1, p2_p), Math.max(p1, p2_p) ) => osc1_pan.pan;
    Std.rand2f( Math.min(p2, p1_p), Math.max(p2, p1_p) ) => osc2_pan.pan;
}

// OUTRO
for( 0 => int repetition_outro; repetition_outro < nb_repetition_outro; repetition_outro++)
{
    for( 0 => int i; i < arr_Degrees_Outro.cap(); i++ )
    {
        //
        arr_Degrees_Outro[i] => int degree;    
        //
        arr_NotesValues_Outro[i] => float fNoteValue;
        Std.ftoi( fNoteValue ) => int iNoteValue;
        
        arr_Durations_NotesValues[ iNoteValue ] * (1 + (fNoteValue-iNoteValue)) => float note_value;          
        note_value => duration;
        
        // is a silence note ?
        if( degree == mifs )
        { // yes           
            // "play" the silence (sound of silence ;-))
            if( b_play_silence ) duration::second => now;
        }
        else 
        { // no                        
            //
            1 -=> degree;            
            arr_MidiNotes_Assessment_2[degree] => int midi_note;            
            offset_degree_midi -=> midi_note; // offset scale            
            
            // "Use tools from the standard library, including STD.mtof()"            
            Std.mtof( midi_note ) => osc1.freq;
            //Std.mtof( midi_note ) => osc2.freq;
            Std.mtof( midi_note + 12 ) => osc2.freq;
            
            duration => float timing_note;
            
            // 1st step : attack step in
            // domain gain: [0.0 -> gain_max_for_this_note]
            // linear variation : f(x) = x, x=[0.0, g_max]
            if( b_use_fall_in_gain )
            {
                //
                0.0 => float start_gain;
                max_gain => float end_gain;
                //
                timing_note * ratio_timing_for_attack_step_in => float timing_attack_step_in;    
                //    
                timing_attack_step_in / (nb_samples $ float) => float step_timing_note;
                1.0 / (nb_samples $ float) => float step_t;
                
                0.0 => float cur_t;
                
                osc2_pan.pan() => float osc2_initial_pan;
                Std.rand2f(osc2_min_amp_pan, osc2_max_amp_pan) => float osc2_amplitude_pan;
                
                // linear approach
                for( 0 => int i; i < nb_samples; i++ )
                {        
                    // update t
                    step_t +=> cur_t;
                    
                    // remap the entry parameter cur_t [0.0, 1.0] to x [start_x, end_x]
                    start_x + cur_t * (end_x - start_x ) => float x;
                    
                    // compute the attenuation coefficient
                    a * Math.exp(-Math.pow(x-b, 2.0)/(2*Math.pow(c, 2.0))) + d  => float attenuation_function_value;
                    
                    // remap the output [attenuation_function_min, attenuation_function_max] to [0.0, 1.0]
                    attenuation_function_min -=> attenuation_function_value;
                    attenuation_function_rescale *=> attenuation_function_value;
                    
                    // project t on domain gain
                    start_gain + attenuation_function_value * (end_gain - start_gain) => float cur_gain;
                    
                    // update the gain
                    cur_gain => osc1.gain;
                    cur_gain => osc2.gain;
                    
                    // Animate pan of osc2
                    osc2_initial_pan + Math.sin(cur_t*2*pi) * osc2_amplitude_pan => osc2_pan.pan;
                    
                    // consume audio time
                    step_timing_note::second => now;
                }
            }

            // 2nd step: constant gain
            // domain gain: [gain_max_for_this_note -> gain_max_for_this_note] no variation (constant)
            // f(x) = c, c=g_max
            if( b_use_full_gain )
            {
                // update the gain
                max_gain => osc1.gain;
                timing_note * ratio_timing_for_constant_gain => float timing_constant_gain;
                // consume audio time
                timing_constant_gain::second => now;
            }

            // last step attack step out
            // domain gain: [gain_max_for_this_note -> 0.0] 
            // linear variation : f(x) = x, x=[g_max, 0.0]
            if( b_use_fall_off_gain )
            {
                //
                max_gain => float start_gain;
                0.0 => float end_gain;
                //
                timing_note * ratio_timing_for_attack_step_out => float timing_attack_step_out;
                //
                timing_attack_step_out / (nb_samples $ float) => float step_timing_note;
                //
                1.0 / (nb_samples $ float) => float step_t;
                0.0 => float cur_t;
                
                osc2_pan.pan() => float osc2_initial_pan;
                Std.rand2f(osc2_min_amp_pan, osc2_max_amp_pan) => float osc2_amplitude_pan;
                
                // linear approach
                for( 0 => int i; i < nb_samples; i++ )
                {
                    // update t
                    step_t +=> cur_t;
                    
                    // remap the entry parameter cur_t [0.0, 1.0] to x [start_x, end_x]
                    start_x + cur_t * (end_x - start_x ) => float x;
                    
                    // compute the attenuation coefficient
                    a * Math.exp(-Math.pow(x-b, 2.0)/(2*Math.pow(c, 2.0))) + d  => float attenuation_function_value;
                    
                    // remap the output to [0.0, 1.0]
                    attenuation_function_min -=> attenuation_function_value;
                    attenuation_function_rescale *=> attenuation_function_value;
                    
                    // project t on domain gain
                    start_gain + attenuation_function_value * (end_gain - start_gain) => float cur_gain;
                    
                    // update the gain
                    cur_gain => osc1.gain;
                    cur_gain => osc2.gain;
                    
                    // Animate pan of osc2
                    osc2_initial_pan + Math.sin(cur_t*2*pi) * osc2_amplitude_pan => osc2_pan.pan;

                    // consume audio time
                    step_timing_note::second => now;
                }
            }
        }
    }
}

// Add some (2d) spatialisation in equalisation
if( bSpatialize_Part_Last_Note )
{
    // Set a initial random offset for our 2 oscillators
    Std.rand2f(osc1_min_pan, osc1_max_pan) => osc1_pan.pan;
    Std.rand2f(osc2_min_pan, osc2_max_pan) => osc2_pan.pan;
    //
    osc1_pan.pan() => float p1;
    -osc1_pan.pan() => float p1_p;
    osc2_pan.pan() => float p2;
    -osc2_pan.pan() => float p2_p;
    // Add some (2d) spatialisation in equalisation
    Std.rand2f( Math.min(p1, p2_p), Math.max(p1, p2_p) ) => osc1_pan.pan;
    Std.rand2f( Math.min(p2, p1_p), Math.max(p2, p1_p) ) => osc2_pan.pan;
}

// Last note for ending
{
    // The last note is the first and is the first degree 
    // (a lot of 'first'/'last' here ^^ Circle of life, the beginning is the end & vice&versa)
    1 => int degree_End;    
    degree_End => int degree;
    //
    1 -=> degree;            
    arr_MidiNotes_Assessment_2[degree] => int midi_note;            
    offset_degree_midi -=> midi_note; // offset scale            
    
    // "Use tools from the standard library, including STD.mtof()"
    // Convert midi note to frequency
    Std.mtof( midi_note ) => osc1.freq;
    Std.mtof( midi_note + 12 ) => osc2.freq;

    // Compute the timing for the end
    // and to be sure to have a length composition/song equal to 30.00seconds
    now => time end_outro;
    (30.0::second - (end_outro - start_song))/1::second => float timing_note;
    
    // Local (ratio) timing for the last note
    0.01 => float ratio_timing_for_attack_step_in;  //  1%
    0.49 => float ratio_timing_for_attack_step_out; // 49%
    1.0 - (ratio_timing_for_attack_step_in+ratio_timing_for_attack_step_out) => float ratio_timing_for_constant_gain;   // 50%
                
    // 1st step : attack step in
    // domain gain: [0.0 -> gain_max_for_this_note]
    // linear variation : f(x) = x, x=[0.0, g_max]
    if( b_use_fall_in_gain )
    {
        //
        0.0 => float start_gain;
        max_gain => float end_gain;
        //
        timing_note * ratio_timing_for_attack_step_in => float timing_attack_step_in;    
        //    
        timing_attack_step_in / (nb_samples $ float) => float step_timing_note;
        1.0 / (nb_samples $ float) => float step_t;
        
        0.0 => float cur_t;
        
        osc2_pan.pan() => float osc2_initial_pan;
        Std.rand2f(osc2_min_amp_pan, osc2_max_amp_pan) => float osc2_amplitude_pan;

        // linear approach
        for( 0 => int i; i < nb_samples; i++ )
        {        
            // update t
            step_t +=> cur_t;
            
            // remap the entry parameter cur_t [0.0, 1.0] to x [start_x, end_x]
            start_x + cur_t * (end_x - start_x ) => float x;
            
            // compute the attenuation coefficient
            a * Math.exp(-Math.pow(x-b, 2.0)/(2*Math.pow(c, 2.0))) + d  => float attenuation_function_value;
            
            // remap the output [attenuation_function_min, attenuation_function_max] to [0.0, 1.0]
            attenuation_function_min -=> attenuation_function_value;
            attenuation_function_rescale *=> attenuation_function_value;
            
            // project t on domain gain
            start_gain + attenuation_function_value * (end_gain - start_gain) => float cur_gain;
            
            // update the gain
            cur_gain => osc1.gain;
            cur_gain => osc2.gain;
            
            // Animate pan of osc2
            Math.min( Math.max(  Math.cos(cur_t*pi)*Math.sin((0.5-cur_t)*pi) * osc2_amplitude_pan + osc2_initial_pan, -1.0 ), 1.0 ) => osc2_pan.pan;
            
            // consume audio time
            step_timing_note::second => now;
        }
    }

    // 2nd step: constant gain
    // domain gain: [gain_max_for_this_note -> gain_max_for_this_note] no variation (constant)
    // f(x) = c, c=g_max
    if( b_use_full_gain )
    {
        // update the gain
        max_gain => osc1.gain;
        max_gain => osc2.gain;
        
        timing_note * ratio_timing_for_constant_gain => float timing_constant_gain;
        
        // consume audio time
        timing_constant_gain::second => now;
    }

    // last step attack step out
    // domain gain: [gain_max_for_this_note -> 0.0] 
    // linear variation : f(x) = x, x=[g_max, 0.0]
    if( b_use_fall_off_gain )
    {
        //
        max_gain => float start_gain;
        0.0 => float end_gain;
        //
        timing_note * ratio_timing_for_attack_step_out => float timing_attack_step_out;
        //
        timing_attack_step_out / (nb_samples $ float) => float step_timing_note;
        //
        1.0 / (nb_samples $ float) => float step_t;
        0.0 => float cur_t;
        
        osc2_pan.pan() => float osc2_initial_pan;
        Std.rand2f(osc2_min_amp_pan, osc2_max_amp_pan) => float osc2_amplitude_pan;
        
        // linear approach
        for( 0 => int i; i < nb_samples; i++ )
        {
            // update t
            step_t +=> cur_t;
            
            // remap the entry parameter cur_t [0.0, 1.0] to x [start_x, end_x]
            start_x + cur_t * (end_x - start_x ) => float x;
            
            // compute the attenuation coefficient
            a * Math.exp(-Math.pow(x-b, 2.0)/(2*Math.pow(c, 2.0))) + d  => float attenuation_function_value;
            
            // remap the output to [0.0, 1.0]
            attenuation_function_min -=> attenuation_function_value;
            attenuation_function_rescale *=> attenuation_function_value;
            
            // project t on domain gain
            start_gain + attenuation_function_value * (end_gain - start_gain) => float cur_gain;
            
            // update the gain
            cur_gain => osc1.gain;
            cur_gain => osc2.gain;
            
            // Animate pan of osc2
            Math.min( Math.max( Math.cos((0.5+cur_t)*2*pi)*Math.sin(cur_t*2*pi) * osc2_amplitude_pan + osc2_initial_pan, -1.0 ), 1.0 ) => osc2_pan.pan;
            
            // consume audio time
            step_timing_note::second => now;
        }
    }
}

now => time end_song;
<<< "Length of this song: ", (end_song - start_song)/1::second, " seconds." >>>;

<<< "Merci pour l'ecoute ! :-D" >>>;

if( bSaveTheSongInWavFile )
{
    // temporary workaround to automatically close file on remove-shred
    null @=> w;
}