// url: http://en.wikipedia.org/wiki/Gaussian_function
//f(x) = a e^{- { \frac{(x-b)^2 }{ 2 c^2} } } + d
// a = 1 / ( sigma * sqrt(2pi) )
// b = mu
// c = sigma
//
// parameters for attenuation 
//1.0 => float sigma;
Math.sqrt(0.02) => float sigma;
0.0 => float mu; // parametrique générique, pas utile pour notre application
//
1 / ( sigma * Math.sqrt(2*pi) ) => float a;
mu => float b;
sigma => float c;
0.0 => float d;
//
// Full width at half maximum : FWHM
// url: http://en.wikipedia.org/wiki/Full_width_at_half_maximum
2.355 * sigma => float FWHM;
<<< "FWHM: ", FWHM >>>;
mu +=> FWHM;
// x : input parameter for gaussian function evaluation
float x;

// domain value for x
// constraints on x domain values :
// - start_x < end_x
// - end_x <= 0.0
//
//-0.75*FWHM => float start_x;
//-0.25*FWHM => float end_x;
//
-1.5*FWHM => float start_x;
mu => float end_x;
//

// min, max value for this function
a * Math.exp(-Math.pow(end_x    - b, 2.0)/(2*Math.pow(c, 2.0))) + d => float attenuation_function_max;
a * Math.exp(-Math.pow(start_x  - b, 2.0)/(2*Math.pow(c, 2.0))) + d => float attenuation_function_min;
// help to remap [attenuation_function_min, attenuation_function_max] to [0.0, 1.0]
1.0 / (attenuation_function_max - attenuation_function_min) => float attenuation_function_rescale; 
// max, min values to remap
0.025 => float min_value_to_remap;
1.0 => float max_value_to_remap;
//
( max_value_to_remap - min_value_to_remap ) / 1.0 => float scale_value_to_remap;


512 => int nb_samples;

0.5 => float max_gain;

-1 => int midi_indice_for_silence;

[ 
    69, midi_indice_for_silence, 
    70, 71, midi_indice_for_silence, 
    72, 72, midi_indice_for_silence, 
    71, 71, 71 
] @=> int arr_Midi_Notes[];

// naive method: false, true, false, false
// 'smart' method: true, true, true, true
true    => int b_play_silence;
true    => int b_use_full_gain;
true    => int b_use_fall_in_gain;
true    => int b_use_fall_off_gain;
//
0.0025 => float ratio_timing_for_attack_step_in;
0.950 => float ratio_timing_for_attack_step_out;
// constraint: ratio_timing_for_attack_step_in+ratio_timing_for_attack_step_out <= 1.0
1.00 - (ratio_timing_for_attack_step_in + ratio_timing_for_attack_step_out) => float ratio_timing_for_constant_gain;

0.25 => float timing_note;
0.125 => float timing_silence;

TriOsc osc1 => dac;

for( 0 => int i; i < arr_Midi_Notes.cap(); i++)
{
    if( b_play_silence && arr_Midi_Notes[i] == midi_indice_for_silence ) 
    {
        <<< " __ : 'play' silence note ..." >>>;
        min_value_to_remap * max_gain => osc1.gain;
        timing_silence::second => now;
    }
    else
    {        
        // get the midi note to the array
        // convert midi to frequency
        Std.mtof( arr_Midi_Notes[i] - 12 ) => osc1.freq;
        
        // domain t parameter: [0.0 -> 1.0]

        // 1st step : attack step in
        // domain gain: [0.0 -> gain_max_for_this_note]
        // linear variation : f(x) = x, x=[0.0, g_max]
        if( b_use_fall_in_gain )
        {
            <<< " < : fall in (gain) note ..." >>>;
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
                
                // remap gain
                cur_gain / max_gain => float ratio_gain;
                scale_value_to_remap *=> ratio_gain;
                min_value_to_remap +=> ratio_gain;
                ratio_gain * max_gain => cur_gain;
                
                // update the gain
                cur_gain => osc1.gain;
                
                // consume audio time
                step_timing_note::second => now;
            }
        }

        // 2nd step: constant gain
        // domain gain: [gain_max_for_this_note -> gain_max_for_this_note] no variation (constant)
        // f(x) = c, c=g_max
        if( b_use_full_gain )
        {
            <<< " == : full (gain) note ..." >>>;
            // update the gain
            max_gain => osc1.gain;
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
            <<< " > : fall out (gain) note ..." >>>;
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
                
                // remap gain
                cur_gain / max_gain => float ratio_gain;
                scale_value_to_remap *=> ratio_gain;
                min_value_to_remap +=> ratio_gain;
                ratio_gain * max_gain => cur_gain;
                
                // update the gain
                cur_gain => osc1.gain;
                
                // consume audio time
                step_timing_note::second => now;
            }
        }
    }
}