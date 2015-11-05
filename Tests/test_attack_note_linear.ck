// url: http://en.wikipedia.org/wiki/Linear_function
// f(x) = ax + b    
// parameters for attenuation 
// constraints: a >= 0.0
1.0 => float a;
0.0 => float b;
// domain value for x
0.0 => float start_x;
1.0 => float end_x;
// min, max value for this function
start_x *a + b => float attenuation_function_min;
end_x   *a + b => float attenuation_function_max;
// help to remap [attenuation_function_min, attenuation_function_max] to [0.0, 1.0]
1.0 / (attenuation_function_max - attenuation_function_min) => float attenuation_function_rescale; 

TriOsc osc1 => dac;

-1 => int midi_indice_for_silence;

[ 
69, midi_indice_for_silence, 
70, 71, midi_indice_for_silence, 
72, 72, midi_indice_for_silence, 
71, 71, 71 
] @=> int arr_Midi_Notes[];

0.5 => float max_gain;

256 => int nb_samples;

// naive method: false, true, false, false
// 'smart' method: true, true, true, true
true    => int b_play_silence;
true    => int b_use_full_gain;
true    => int b_use_fall_in_gain;
true    => int b_use_fall_off_gain;

0.33 => float ratio_timing_for_attack_step_in;
0.33 => float ratio_timing_for_attack_step_out;
// constraint: ratio_timing_for_attack_step_in+ratio_timing_for_attack_step_out <= 1.0
1.00 - (ratio_timing_for_attack_step_in + ratio_timing_for_attack_step_out) => float ratio_timing_for_constant_gain;

0.25 => float timing_note;
0.125 => float timing_silence;

for( 0 => int i; i < arr_Midi_Notes.cap(); i++)
{
    if( b_play_silence && arr_Midi_Notes[i] == midi_indice_for_silence ) 
    {
        <<< " __ : 'play' silence note ..." >>>;
        0.0 => osc1.gain;
        timing_silence::second => now;
    }
    else
    {        
        // get the midi note to the array
        // convert midi to frequency
        Std.mtof( arr_Midi_Notes[i] ) => osc1.freq;
        
        // domain t parameter: [0.0 -> 1.0] with linear variation

        // 1st step : attack step in
        // domain gain: [0.0 -> gain_max_for_this_note]
        // linear variation : f(x) = ax + b
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
                
                // compute the attenuation coefficient -> f(x) = ax + b
                a * x + b  => float attenuation_function_value;
                
                // remap the output to [0.0, 1.0]
                attenuation_function_min -=> attenuation_function_value;
                attenuation_function_rescale *=> attenuation_function_value;
                
                // project t on domain gain
                start_gain + attenuation_function_value * (end_gain - start_gain) => float cur_gain;
                
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
                
                // compute the attenuation coefficient -> f(x) = ax + b
                a * x + b  => float attenuation_function_value;
                
                // remap the output to [0.0, 1.0]
                attenuation_function_min -=> attenuation_function_value;
                attenuation_function_rescale *=> attenuation_function_value;
                
                // project t on domain gain
                start_gain + attenuation_function_value * (end_gain - start_gain) => float cur_gain;
                
                // update the gain
                cur_gain => osc1.gain;
                
                // consume audio time
                step_timing_note::second => now;
            }
        }
    }
}