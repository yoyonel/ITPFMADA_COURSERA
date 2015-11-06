// ---------------------------------------------------
// Frequencies for equal-tempered scale
// url: http://www.phy.mtu.edu/~suits/notefreqs.html
// ---------------------------------------------------
float freqs_temp[12];
440.00 => freqs_temp["A4"];
466.16 => freqs_temp["A4#"];
493.88 => freqs_temp["B4"];
261.63 => freqs_temp["C4"];
277.18 => freqs_temp["C4#"];
293.66 => freqs_temp["D4"];
311.13 => freqs_temp["D4#"];
329.63 => freqs_temp["E4"];
349.23 => freqs_temp["F4"];
369.99 => freqs_temp["F4#"];
392.00 => freqs_temp["G4"];
415.30 => freqs_temp["G4#"];

// ----------------------------------------------------------------
// Scales
// url: http://en.wikipedia.org/wiki/Scale_%28music%29
// ----------------------------------------------------------------
float freqs_scales[2][7];

// ----------------------------------------------------------------
// Scales - Major (url: http://en.wikipedia.org/wiki/Major_scale)
// Scales - Major - C4_Major
// ----------------------------------------------------------------
[ freqs_temp["C4"], freqs_temp["D4"], freqs_temp["E4"], freqs_temp["F4"], freqs_temp["G4"], freqs_temp["A4"], freqs_temp["B4"] ] @=> freqs_scales["C4_Major"];

// ----------------------------------------------------------------
// Scales - Minor (url: http://en.wikipedia.org/wiki/Minor_scale)
// Scales - Minor -  A melodic minor scale - A4_minor_melodic_scale
// ----------------------------------------------------------------
[ freqs_temp["A4"], freqs_temp["B4"], freqs_temp["C4"], freqs_temp["D4"], freqs_temp["C4"], freqs_temp["F4#"], freqs_temp["G4#"] ] @=> freqs_scales["A4_minor_melodic_scale"];

// Summary:
//     
//
// Parameters:
//   _scale: representation of a scale - string in ["C4_Major", "A4_minor_melodic_scale"]
//   _t: functionnal parameter - float in [-pi, +pi]
//
//
// Returns:
//     frequency (hz) chord
//     
fun float compute_frequency( string _scale, float _t )
{    
    // default value : 0.0
    0.0 => float r_freq;
    // check if this scale "exist"
    if(freqs_scales[_scale] != null)
    {
        // _t -> _t01 : [0, 2pi [ -> [0, 1[
        (_t+pi)/(2.00*pi) => float t_01;            
		
        // _t01 -> index_chord : [0, 1[ -> [0, index of the last element in array freqs_scales for this scale
        (t_01 * freqs_scales[_scale].cap()) $ int => int index_chord;		
		
        // retrieve the frequency value for this chord (in this scale)
        freqs_scales[_scale][index_chord] => r_freq;
		
		// -- Debug output --
        //<<< "index_chord", index_chord >>>;
    }
    return r_freq;
}

// Summary:
//     
//
// Parameters:
//   _x: 
//   _y:
//
//
// Returns:
//     
//     
fun float func_xy_to_rad( float _x, float _y )
{
    // atan2 (url: http://www.cplusplus.com/reference/cmath/atan2/)        
    return Math.atan2(_y, _x);
}

// Summary:
//     
//
// Parameters:
//   _x: 
//   _y:
//
//
// Returns:
//     
//     
fun float func_xy_to_rad( float _x, float _y, float _xc, float _yc )
{
    return func_xy_to_rad(_x-_xc, _y-_yc);
}

// Summary:
//     
//
// Parameters:
//   _x: 
//   _y:
//
//
// Returns:
//     
//     
fun float func_heart_06_x( float _t )
{
    0.0 => float r_t;
            
    // _t -> _tm1p1 (=t') : [-pi, +pi] -> [-1, +1]
    _t/pi => float tm1p1;
    
    // sin(t')
    Math.sin(tm1p1) => float sin_tm1p1;    
    // x = 16*sin(t')^3
    16.0*Math.pow(sin_tm1p1, 3) => float x;
    
    return x;
}

// Summary:
//     
//
// Parameters:
//   _x: 
//   _y:
//
//
// Returns:
//     
//     
fun float func_heart_06_y( float _t )
{
    0.0 => float r_t;
            
    // _t -> _tm1p1 (=t') : [-pi, +pi] -> [-1, +1]
    _t/pi => float tm1p1;
    
    // sin(t')
    Math.sin(tm1p1) => float sin_tm1p1;    
    
    // y = 13*cos(t') - 5*cos(2t') - 2*cos(3t') - cos(4t')
    13*Math.cos(tm1p1) - 5*Math.cos(2*tm1p1) - 2*Math.cos(3*tm1p1) - Math.cos(4*tm1p1) => float y;
    
    return y;
}
    
// Summary:
//     
//
// Parameters:
//   _t: functionnal paramater - float [-pi, +pi]
//
//
// Returns:
//   [-pi, +pi]
//     
fun float func_heart_06( float _t, float _xc, float _yc )
{
    0.0 => float r_t;
            
    // _t -> _tm1p1 (=t') : [-pi, +pi] -> [-1, +1]
    _t/pi => float tm1p1;
    
    // sin(t')
    Math.sin(tm1p1) => float sin_tm1p1;    
    // x = 16*sin(t')^3
    16.0*Math.pow(sin_tm1p1, 3) => float x;
    
    // y = 13*cos(t') - 5*cos(2t') - 2*cos(3t') - cos(4t')
    13*Math.cos(tm1p1) - 5*Math.cos(2*tm1p1) - 2*Math.cos(3*tm1p1) - Math.cos(4*tm1p1) => float y;

    //
    func_xy_to_rad(x, y, _xc, _yc) => r_t;

	// -- Debug output --    
    //<<< "x", x >>>;
    //<<< "y", y >>>;
    
    return r_t;
}

//
//
// MAIN program
//
//

// Define oscillators
//
// First oscillator : link to major scale
SinOsc osc1_major_scale => Chorus stk_chorus => dac;	// add some FX: chorus
0.150 => osc1_major_scale.gain;	// set the initial gain for this oscillator
0.20 => stk_chorus.mix;	// set the mix with the FX (20% of the FX is present on this 'track')

// Second oscillator : link to minor scale
TriOsc osc2_minor_scale => Delay stk_delay => dac;
//SinOsc osc2_minor_scale;
0.125 => osc2_minor_scale.gain;
//stk_delay

// Compute the centroid of a "Heart function"
// url: mathworld.wolfram.com/HeartCurve.html
// set some variables to compute a bounding box of this function
10000.0 => float x_min;
-10000.0 => float x_max;
10000.0 => float y_min;
-10000.0 => float y_max;
// set the number of samples use for this computation
1024 => int nb_samples;
// step to parse the entry domain values of this function, [-pi, +pi] = 2*pi, with nb_samples
(2.0*pi) / nb_samples => float t_step;
// initial value for the domain values
-pi => float t;
// compute the centroid
for( 0 => int i; i < nb_samples; i++ )
{    
	// get the x coordinate of the heart function
    func_heart_06_x(t) => float x;
	// get the y coordinate of the heart function
    func_heart_06_y(t) => float y;
    // update the bbox
    Math.min( x, x_min ) => x_min;
    Math.min( y, y_min ) => y_min;
    Math.max( x, x_max ) => x_max;
    Math.max( y, y_max ) => y_max;
    // next sample
    t + t_step => t;   
}
// compute the center of the BBox ~= centroid of this heart function
(x_min + x_max) / 2.0 => float func_heart_06_xc;
(y_min + y_max) / 2.0 => float func_heart_06_yc;
// -- Debug output --
//<<< "x_min", x_min, "x_max", x_max >>>;
//<<< "y_min", y_min, "y_max", y_max >>>;
 

 // Some song parameters (length)
30.0 => float time_max_length_song;	// max time for playing the song => 30.00 sec at all
0.0 => float time_current_length_song; // current time of the song
0.25 => float time_length_for_a_chord; // length for each chord of this song

float func_heart_t;	// 
0 => float func_heart_indice;
0.5 => float func_heart_inc_indice;

// Save the initial gain to apply a fade-out at the end
osc1_major_scale.gain() => float initial_osc1_gain;
osc2_minor_scale.gain() => float initial_osc2_gain;

// Loop simulation of the song
while(time_current_length_song <= time_max_length_song)
{
	// oscillation sinus function help for t parameter of the heart function (so groove is here ;-))
    Math.sin(func_heart_indice) * pi => func_heart_t;
	
    // compute a projection of the heart function and retreive a parameter t in [-pi, +pi]
    func_heart_06( func_heart_t, func_heart_06_xc, func_heart_06_yc) => float t;
    
	// -- Some tests ---
    //Std.rand2f(-pi, pi) => float t;       
    //compute_frequency("A4_minor_melodic_scale", t) => osc1.freq;
	// -- Debug output --
    //<<< "t", t >>>;
    
	// Projection of t on some scales (major, minor)
	// we retreive a frequency correspond to a note of this scale
	compute_frequency("C4_Major", t) / 2.0 => osc1_major_scale.freq; 			// -> / 2.0 : create a bass line
    compute_frequency("A4_minor_melodic_scale", t) => osc2_minor_scale.freq; 	// -> lead (melodic) line
    
	// set the ratio coefficient to beginning the fade-out at the end
	// set to 80% (of the song) to start the fade-out
    0.80 => float osc_fade_out_begin_ratio;
    if(time_current_length_song >= osc_fade_out_begin_ratio*time_max_length_song)
    {
        // fade out
        (1.0-((time_current_length_song/time_max_length_song)-osc_fade_out_begin_ratio)/(1.0-osc_fade_out_begin_ratio)) => float osc_ratio_start_step_time;
        (1.0-(((time_current_length_song+time_length_for_a_chord)/time_max_length_song)-osc_fade_out_begin_ratio)/(1.0-osc_fade_out_begin_ratio)) => float osc_ratio_end_step_time;
        Math.max(0.0, osc_ratio_end_step_time) => osc_ratio_end_step_time;
        
		// -- Debug output --
        //<<< "osc_ratio_start_step_time", osc_ratio_start_step_time >>>;
        //<<< "osc_ratio_end_step_time", osc_ratio_end_step_time >>>;
        
		// need to subdivise the "consommation" of time audio simulation
		// set the number of sample (for the subdivision) to 32
        32 => int osc_nb_subdivision_sound_sample;
        for( 0 => int i; i < osc_nb_subdivision_sound_sample; i++ )
        {            
            osc_ratio_start_step_time + i*(osc_ratio_end_step_time-osc_ratio_start_step_time)/osc_nb_subdivision_sound_sample => float osc_ratio_step_time;
            
            initial_osc1_gain * osc_ratio_step_time => osc1_major_scale.gain;
            initial_osc2_gain * osc_ratio_step_time => osc2_minor_scale.gain;
            
			// run the audio simulation
            (time_length_for_a_chord/osc_nb_subdivision_sound_sample)::second => now;
        }
    }
    else
    {        
		// run the audio simulation
        (time_length_for_a_chord)::second => now;
    }
	
	// update the parameters for the 'Heart song' simulation (link to the time audio simulation)
    time_current_length_song + time_length_for_a_chord => time_current_length_song;    
    func_heart_indice + func_heart_inc_indice => func_heart_indice;
} // end of the song
