32 => int nb_samples;

SinOsc osc[nb_samples];
Pan2 osc_pan[nb_samples];

for(0=>int i; i<osc.cap(); i++) 
{
    osc[i] => osc_pan[i] => dac;
    0.0 => osc_pan[i].pan;
}

nb_samples/2 => int id_center;

 0.20 => float pan_initial;
 0.50 => float pan_width;


// url: http://en.wikipedia.org/wiki/Gaussian_function
//f(x) = a e^{- { \frac{(x-b)^2 }{ 2 c^2} } } + d
// a = 1 / ( sigma * sqrt(2pi) )
// b = mu
// c = sigma
//
// parameters for attenuation 
Math.sqrt(1.0) => float sigma;
//Math.sqrt(0.2) => float sigma;
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

//
-1 => int midi_indice_for_silence;
[ 
    69
    ,71, 72, 74, 76, 77, 79, 81
] @=> int arr_Midi_Notes[];

0.25 => float timing_note;
0.125 => float timing_silence;
2 *=> timing_note;

float fondamental_frequency;

for( 0 => int id_Midi_Note; id_Midi_Note < arr_Midi_Notes.cap(); id_Midi_Note++)
{
    if( arr_Midi_Notes[id_Midi_Note] == midi_indice_for_silence ) 
    {
        timing_silence::second => now;
    }
    else
    {        
        // get the midi note to the array
        // convert midi to frequency
        Std.mtof( arr_Midi_Notes[id_Midi_Note] - 24 ) => fondamental_frequency;
        
        // domain t parameter: [0.0 -> 1.0]
        0.0 => float cur_t;
        1.0 / (nb_samples $ float) => float step_t;
        pan_width => float width_value;
        
        float cur_value;
        pan_initial - (pan_width * 0.5) => float start_value;
        
        0.0 => float sum_gain;
        
        // linear approach
        for( 0 => int id_sample; id_sample < nb_samples; id_sample++ )
        {
            fondamental_frequency => osc[id_sample].freq;
            
            // update t
            step_t +=> cur_t;
            
            // remap the entry parameter cur_t [0.0, 1.0] to x [start_x, end_x]
            start_x + cur_t * (end_x - start_x ) => float x;
            
            // compute the attenuation coefficient
            a * Math.exp(-Math.pow(x-b, 2.0)/(2*Math.pow(c, 2.0))) + d  => float attenuation_function_value;
            
            if( Std.fabs(cur_t - 0.5) < (1*0.05) ) // % de la largeur du domaine de valeur            
            {
                2.0 *=> attenuation_function_value;
            }
            
            attenuation_function_value => osc[id_sample].gain;
            
            attenuation_function_value +=> sum_gain;
            
            start_value + width_value*cur_t => cur_value;
            Math.min(Math.max(cur_value, -1.0), 1.0) => osc_pan[id_sample].pan;
        }
        //<<< sum_value >>>;
        
        1.0 / sum_gain => float gain_normalisation;
        
        for(0=>int id_sample; id_sample<osc.cap(); id_sample++) 
        {
            osc[id_sample].gain() * gain_normalisation => osc[id_sample].gain;
            
            <<< "osc[", id_sample, "].freq = ", osc[id_sample].freq() >>>;
            <<< "osc[", id_sample, "].gain = ", osc[id_sample].gain() >>>;
            <<< "osc_pan[", id_sample, "].pan = ", osc_pan[id_sample].pan() >>>;
            <<< "--------------------------------------------------------------" >>>;
            
        }
        
        timing_note::second => now;
    }
}