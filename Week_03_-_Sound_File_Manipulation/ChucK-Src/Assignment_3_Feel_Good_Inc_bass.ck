// Assignment #3 : bass line part (reprise de l'assigment #2)

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
0.0 => float mu; // (not useful for our application)
// assign parameters : a, b & c
1.0/(sigma*Math.sqrt(2*pi)) => float a;
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
1024*16 => int nb_samples;

// naive method: false, true, false, false
// 'smart' method (avoid pop & crack sound) : true, true, true, true
true    => int b_play_silence;
true    => int b_use_full_gain;
true    => int b_use_fall_in_gain;
true    => int b_use_fall_off_gain;

// Timing for the "push/release" note
// Some groove is here ! (Design properties of our 'instrument')
// => timing for "push" a key -  : %
// => timing to "release/pop" a key -  : %
0.02 => float ratio_timing_for_attack_step_in;
0.95 => float ratio_timing_for_attack_step_out;
// constraint: ratio_timing_for_attack_step_in+ratio_timing_for_attack_step_out <= 1.0
// => timing to "keep pressing" the key - : %
1.00 - (ratio_timing_for_attack_step_in + ratio_timing_for_attack_step_out) => float ratio_timing_for_constant_gain;


// "3. Make quarter Notes (main compositional pulse) .25::second in your composition."
// double croche, croche, noire, blanche, ronde
[ 0.125, 0.25, 0.5, 1, 2 ] @=> float arr_Durations_NotesValues[];    


// "Make sure to ONLY use these MIDI Notes in your composition: 50, 52, 53, 55, 57, 59, 60, 62"
// "(for musicians, this is a D Dorian scale)"
// using scale : D Dorian (<=> same notes of C-Maj) -> 1t 1/2t 1t 1t 1t 1/2t 1t
[ 50, 52, 53, 55, 57, 59, 60, 62 ] @=> int arr_MidiNotes_Assessment_2[];

// Midi Indice For Silence (MIFS)
0 => int mifs;

//
// Song: express in degrees relativ to the scale
// 
// For example : 
//  value = 1.5
//  - 1     for index on arr_Durations_NotesValues -> arr_Durations_NotesValues[1] = 0.25
//  - .5    for alteration -> arr_Durations_NotesValues[1] + arr_Durations_NotesValues[1]*0.5 = 0.25 + 0.25*0.5 = 0.375
//
// Intro + variations
//
[   
    1,  mifs,   1,  2,  3,  6,  5,  mifs,
    4,  mifs,   4,  6,  5,  3,  1,  mifs  
] @=> int arr_Degrees_Intro_1[];
// array of values note
[   
    2.0, 1.0, 1.0, 1.0, 2.0, 2.0, 3.5, 1.0,
    2.0, 1.0, 1.0, 1.0, 2.0, 2.0, 3.0, 2.5
] @=> float arr_NotesValues_Intro_1[];
// Save the length of arrays (using in for loops after)
[
    arr_Degrees_Intro_1.cap()
] @=> int arr_Cap_Intros[];

// Main Riff
//
[ 
    1,  2,  3,  5,  3,  5
] @=> int arr_Degrees_Main[];
[ 
    1.5,    1.5,    2.0,    1.0,    1.0,    1.0
] @=> float arr_NotesValues_Main[];
//

// Outro
//
[ 
    1,  mifs,   1,  mifs,   1,  mifs,   5
] @=> int arr_Degrees_Outro[];
[ 
    1.0, 0.0, 1.0, 0.0, 1.0, 2.0, 2.0
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
2*12 => int offset_degree_midi;

// 
-0.5 => float osc1_min_pan;
-0.1 => float osc1_max_pan;
//
0.10 => float osc2_min_pan;
0.50 => float osc2_max_pan;
//
0.25 => float osc2_min_amp_pan;
0.75 => float osc2_max_amp_pan;

// Design our song, describe repetitions
10 => int nb_repetition_intro;
0 => int nb_repetition_main;
0 => int nb_repetition_outro;

true => int bPlayOsc2;
true => int bPlayOsc1;
//
true => int bSpatialize_Part_Intro;
true => int bSpatialize_Part_Main;
true => int bSpatialize_Part_Outro;
true => int bSpatialize_Part_Last_Note;

(now-start_song) => dur time_elapsed;
while( time_elapsed < 15::second )
{    
    // INTRO
    //for( 0 => int repetition_intro; repetition_intro < nb_repetition_intro; repetition_intro++)
    if( time_elapsed < 15::second )
    {
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
    
    // update time elapsed
    (now-start_song) => time_elapsed;
}

now => time end_song;
<<< "Length of this song: ", (end_song - start_song)/1::second, " seconds." >>>;

<<< "Merci pour l'ecoute ! :-D" >>>;

if( bSaveTheSongInWavFile )
{
    // temporary workaround to automatically close file on remove-shred
    null @=> w;
}
