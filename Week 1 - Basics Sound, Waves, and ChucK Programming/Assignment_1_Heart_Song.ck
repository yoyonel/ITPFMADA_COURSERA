// Assignment_1_MeloDramaTick_Heart_Song
// Autor : mmYoYoToSs (sc2 nickname :p)
// Date : 2013-10-25

// ---------------------------------------------------
// Frequencies for equal-tempered scale
// url: http://www.phy.mtu.edu/~suits/notefreqs.html
// ---------------------------------------------------
// array of frequencies
// using the string association for index/key in the array/map
float freqs_temp[12];
// define the frequencies
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
// 2D array of references 
// - 1st dimension contain chords/tones 
// - 2nd dimension contain scales
// size of the first dimension = 2 : only two scales (Major and minor melodic)
// size of the second dimension = 7 : Heptatonic scales -> 7 tones per octave
float freqs_scales[2][7];
// ----------------------------------------------------------------
// Scales - Major -> url: http://en.wikipedia.org/wiki/Major_scale
// Scales - Major - C4_Major
// ----------------------------------------------------------------
[ freqs_temp["C4"], freqs_temp["D4"], freqs_temp["E4"], freqs_temp["F4"], 
  freqs_temp["G4"], freqs_temp["A4"], freqs_temp["B4"] ] @=> freqs_scales["C4_Major"];
// ----------------------------------------------------------------
// Scales - Minor -> url: http://en.wikipedia.org/wiki/Minor_scale
// Scales - Minor -  A melodic minor scale - A4_minor_melodic_scale
// ----------------------------------------------------------------
[ freqs_temp["A4"], freqs_temp["B4"], freqs_temp["C4"], freqs_temp["D4"], 
  freqs_temp["C4"], freqs_temp["F4#"], freqs_temp["G4#"] ] @=> freqs_scales["A4_minor_melodic_scale"];

// Summary:
//     Compute a projection (linear projection) of analogic parameter _t on a discrete scale (_scale)
//
// Parameters:
//   _scale: representation of a scale - string in ["C4_Major", "A4_minor_melodic_scale"]
//   _t: functionnal parameter - float in [-pi, +pi]
//
//
// Returns:
//     frequency (hz) - float in R
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
    }
    
    // return the value
    return r_freq;
}

// Summary:
//     Compute the angle of the position(_x,_y) in cartesian 2D plane
//
// Parameters:
//   _x: x coordinate in 2D cartesian plane, float in R
//   _y: y coordinate in 2D cartesian plane, float in R
//
//
// Returns:
//    theta: angle - float in [-pi, +pi]
//     
fun float func_xy_to_rad( float _x, float _y )
{
    // atan2 -> url: http://www.cplusplus.com/reference/cmath/atan2/
    return Math.atan2(_y, _x);
}

// Summary:
//     Compute the angle of the position(_x,_y) - position(_xc,_yc) in cartesian 2D plane
//
// Parameters:
//   _x: x coordinate in 2D cartesian plane, float in R
//   _y: y coordinate in 2D cartesian plane, float in R
//   _xc: x coordinate of a center in 2D cartesian plane, float in R
//   _yc: y coordinate of a center in 2D cartesian plane, float in R
//
//
// Returns:
//     theta: angle -> float in [-pi, +pi]
fun float func_xy_to_rad( float _x, float _y, float _xc, float _yc )
{
    // translate the position (_x,_y) with the center (_xc,_yc)
    _x - _xc => float xp;
    _y - _yc => float yp;
    // compute and return the angle of the position (xp, yp)
    return func_xy_to_rad( xp, yp );
}

// Summary:
//     Compute the x result of a "Heart" function  
//
// Parameters:
//   _t: functionnal paramater - float [-pi, +pi]
//
//
// Returns:
//   x : float in R. 
//     
fun float func_heart_06_x( float _t )
{
    0.0 => float r_t;
            
    // _t -> _tm1p1 (=t') : [-pi, +pi] -> [-1, +1]
    _t/pi => float tm1p1;
    
    // sin(t')
    Math.sin(tm1p1) => float sin_tm1p1;    
    // x = 16*sin(t')^3
    16.0*(sin_tm1p1*sin_tm1p1*sin_tm1p1) => float x;
    
    return x;
}

// Summary:
//     Represent the y result of a "Heart" function  
//
// Parameters:
//   _t: functionnal paramater - float [-pi, +pi]
//
//
// Returns:
//   y : float in R. 
//     
fun float func_heart_06_y( float _t )
{
    0.0 => float r_t;
            
    // _t -> _tm1p1 (<=> t' for comments) : [-pi, +pi] -> [-1, +1]
    _t/pi => float tm1p1;
    
    // sin(t')
    Math.sin(tm1p1) => float sin_tm1p1;    
    
    // y = 13*cos(t') - 5*cos(2t') - 2*cos(3t') - cos(4t')
    13*Math.cos(tm1p1) - 5*Math.cos(2*tm1p1) - 2*Math.cos(3*tm1p1) - Math.cos(4*tm1p1) => float y;
    
    return y;
}
    
// Summary:
//     Compute a projection of a heart function (~translate to origin) on unit circle
//
// Parameters:
//   _t: functionnal paramater - float [-pi, +pi]
//
//
// Returns:
//   parameter : float in [-pi, +pi], 
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

    // Projection of the coordinates results (x,y) of this heart function to a unit circle
    func_xy_to_rad(x, y, _xc, _yc) => r_t;
	
    return r_t;
}

//
//
// MAIN program
//
//

// Define oscillators
//
// First oscillator (Sine Waves) : link to a major scale (C4-M)
SinOsc osc1_major_scale => Chorus stk_chorus => Pan2 osc1_pan => dac;	// add some FX: Chorus, Panoramic
0.150 => osc1_major_scale.gain;	// set the initial gain for this oscillator
0.20 => stk_chorus.mix;	// set the mix with the FX (20% of the FX is present/apply on this oscillator)

// Second oscillator(Triangle Waves) : link to a minor melodic scale (A4-m)
//SinOsc osc2_minor_scale => Delay stk_delay => dac;
TriOsc osc2_minor_scale => Delay stk_delay => Pan2 osc2_pan => dac;      // add some FX: Delay, Panoramic
0.100 => osc2_minor_scale.gain;


// Compute the centroid (~ mass center) of a "Heart function"
// url: mathworld.wolfram.com/HeartCurve.html (the 6th function)
// set some variables to compute a Axis-Aligned Bounding-Box (AABBox) of this function 
// -> url http://en.wikipedia.org/wiki/Minimum_bounding_box
10000.0 => float x_min;     // +10000.0 pretty high, to be sure to be greater than the x min value
-10000.0 => float x_max;    // -10000.0 pretty low,  to be sure to be lesser than the x max value
10000.0 => float y_min;     // the same for y   (min)
-10000.0 => float y_max;    //                  (max)
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
 

 // Some song parameters (length)
30.0 => float time_max_length_song;	    // max time for playing the song => 30.00 sec at all
0.0 => float time_current_length_song;  // current time of the song
0.25 => float time_length_for_a_chord;  // length for each chord of this song

// use for t parameter of a heart mathematical function
float func_heart_t1;                    
// use for t parameter of a heart mathematical function
float func_heart_t2;                    
// integer indice using for computing the variation on the heart
0 => float func_heart_indice;           
// speed for the variation of the indice (link to length of a note)
time_length_for_a_chord*2 => float func_heart_inc_indice;    

// ------------------------------
// Effect: Fade out
// ------------------------------
// Save the initials gains (using to apply a fade-out at the end of the song)
osc1_major_scale.gain() => float initial_osc1_gain;
osc2_minor_scale.gain() => float initial_osc2_gain;
// Set the ratio coefficient to beginning the fade-out at the end
// set to 80% (of the song) to start the fade-out
0.80 => float osc_fade_out_begin_ratio;
// Fade-out: Set the number of sample (for the subdivision) to 32
// it's the granularity/precision of the effect 
32 => int osc_nb_subdivision_sound_sample;

// ------------------------------
// Effect: Panoramic
// ------------------------------
0.50 => float osc1_pan_max_amp;


// Loop simulation of the song
while(time_current_length_song <= time_max_length_song)
{
	// sinus oscillation function using for evaluate a t parameter of heart function
    // (ps: some groove is here ! ;-))    
    Math.sin(func_heart_indice) * pi => func_heart_t1;
    // add a delay for the second track (oscillator), add some groove ^^
    Math.sin(func_heart_indice + func_heart_inc_indice*(0.1*Std.rand2f(0.25, 1.0))) * pi => func_heart_t2;  

    // compute a projection of the heart function and retreive a parameter t in [-pi, +pi]
    // the song is compute *here*
    func_heart_06( func_heart_t1, func_heart_06_xc, func_heart_06_yc) => float t1;
    func_heart_06( func_heart_t2, func_heart_06_xc, func_heart_06_yc) => float t2;

	// Projection of t on some scales (major, minor)
    // Projection analogic signal (mathematical response of a function) to discrete represention (scales)
	// we retreive a frequency correspond to a note of this scale
    // For the bass line:
	//compute_frequency("C4_Major", t1) / 2.0 => osc1_major_scale.freq; 			// -> / 2.0 : create a bass line
    compute_frequency("A4_minor_melodic_scale", t1) / 2.0 => osc1_major_scale.freq; 			// -> / 2.0 : create a bass line
    // For the "melody":
    //compute_frequency("A4_minor_melodic_scale", t2) => osc2_minor_scale.freq; 	// -> lead (melodic) line
    compute_frequency("C4_Major", t2) => osc2_minor_scale.freq; 	// -> lead (melodic) line    
   
    // ------------------------------
    // Effect: Panoramic
    // ------------------------------    	
    Math.cos(func_heart_indice) * osc1_pan_max_amp => osc1_pan.pan; // add some beat, but i don't know why lol (maybe a windows bug ... strange)
    
    // ------------------------------
    // Effect: Fade out
    // ------------------------------    	
    // it's time to apply the fade-out ???
    if(time_current_length_song >= osc_fade_out_begin_ratio*time_max_length_song)
    {
        // Let's go ! :-D
        //
        // Compute ratio to apply the fade-out
        (1.0-((time_current_length_song/time_max_length_song)-osc_fade_out_begin_ratio)/(1.0-osc_fade_out_begin_ratio)) => float osc_ratio_start_step_time;
        (1.0-(((time_current_length_song+time_length_for_a_chord)/time_max_length_song)-osc_fade_out_begin_ratio)/(1.0-osc_fade_out_begin_ratio)) => float osc_ratio_end_step_time;
        Math.max(0.0, osc_ratio_end_step_time) => osc_ratio_end_step_time;

		// Need to subdivise the time step of ChucK (Audio Simulation)
        for( 0 => int i; i < osc_nb_subdivision_sound_sample; i++ )
        {            
            // Compute the fade-out ratio
            osc_ratio_start_step_time + i*(osc_ratio_end_step_time-osc_ratio_start_step_time)/osc_nb_subdivision_sound_sample => float osc_ratio_step_time;
            
            // Apply the fade-out (reduce the gain)
            initial_osc1_gain * osc_ratio_step_time => osc1_major_scale.gain;
            initial_osc2_gain * osc_ratio_step_time => osc2_minor_scale.gain;
            
			// Run the audio simulation
            // for 1 sub-step time
            (time_length_for_a_chord/osc_nb_subdivision_sound_sample)::second => now;
        }
    }
    else // play the song with max/initial gain
    {        
		// Run the audio simulation
        (time_length_for_a_chord)::second => now;
    }
	
	// update the parameters for the 'Heart song' simulation (link to the time audio simulation)
    time_current_length_song + time_length_for_a_chord => time_current_length_song;    
    func_heart_indice + func_heart_inc_indice => func_heart_indice;
    
} // end of the song

<<< "Merci pour l'ecoute! :-D" >>>;