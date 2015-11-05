16 => int nb_harmonics;

SinOsc osc_harmonics[nb_harmonics];
Pan2 osc_pan[nb_harmonics];

for(0=>int i; i<osc_harmonics.cap(); i++) 
{
    osc_harmonics[i] => osc_pan[i] => dac;
    0.0 => osc_pan[i].pan;
}

nb_harmonics/2 => int id_fundamental;

float fondamental_frequency;

64 => float width_band_frequencies;

// url: http://en.wikipedia.org/wiki/Gaussian_function
//f(x) = a e^{- { \frac{(x-b)^2 }{ 2 c^2} } } + d
// a = 1 / ( sigma * sqrt(2pi) )
// b = mu
// c = sigma
//
// parameters for attenuation 
1.0 => float sigma;
//Math.sqrt(0.02) => float sigma;
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
//-FWHM => float start_x;
// FWHM => float end_x;
//
-2.1*FWHM => float start_x;
 2.1*FWHM => float end_x;
//

nb_harmonics => int nb_samples;

-1 => int midi_indice_for_silence;

[ 
    69
    ,71, 72, 74, 76, 77, 79, 81
] @=> int arr_Midi_Notes[];

0.25 => float timing_note;
0.125 => float timing_silence;
2 *=> timing_note;

for( 0 => int i; i < arr_Midi_Notes.cap(); i++)
{
    if( arr_Midi_Notes[i] == midi_indice_for_silence ) 
    {
        timing_silence::second => now;
    }
    else
    {        
        // get the midi note to the array
        // convert midi to frequency
        Std.mtof( arr_Midi_Notes[i] - 24 ) => fondamental_frequency;
        
        // domain t parameter: [0.0 -> 1.0]

        0.0 => float cur_t;
        1.0 / (nb_samples $ float) => float step_t;
        
        float cur_frequency;
        fondamental_frequency => float start_frequency;
        
        0.0 => float sum_value;
        // linear approach
        for( 0 => int i; i < nb_samples; i++ )
        {        
            // update t
            step_t +=> cur_t;
            
            // remap the entry parameter cur_t [0.0, 1.0] to x [start_x, end_x]
            start_x + cur_t * (end_x - start_x ) => float x;
            
            // compute the attenuation coefficient
            a * Math.exp(-Math.pow(x-b, 2.0)/(2*Math.pow(c, 2.0))) + d  => float attenuation_function_value;
            
            start_frequency + cur_t*width_band_frequencies => cur_frequency;
            
            cur_frequency => osc_harmonics[i].freq;
            attenuation_function_value => osc_harmonics[i].gain;
            
            //<<< osc_harmonics[i].freq(), osc_harmonics[i].gain() >>>;
            
            attenuation_function_value +=> sum_value;
            <<< i, attenuation_function_value >>>;
        }
        //<<< sum_value >>>;
        
        for(0=>int i; i<osc_harmonics.cap(); i++) 
            osc_harmonics[i].gain()/(1.0*sum_value) => osc_harmonics[i].gain;
        
        timing_note::second => now;
    }
}