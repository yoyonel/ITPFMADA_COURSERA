// Assignment_1_MeloDramaTick_Heart_Song_no_functions_no_array_no_fx_no_libs
// Autor : ???
// Date : 2013-10-25


// ---------------------------------------------------------------------------------------
//
// PARAMETERS to control the music (if u want to play with :-))
//
// ---------------------------------------------------------------------------------------
// Some song parameters (length)
30.0 => float time_max_length_song;	    // max time for playing the song => 30.00 sec at all
0.00 => float time_current_length_song;  // current time of the song
0.25 => float time_length_for_a_chord;  // length for each chord of this song

// Set the ratio coefficient to beginning the fade-out at the end
// set to 80% (of the song) to start the fade-out
0.80 => float osc_fade_out_begin_ratio;
// Fade-out: Set the number of sample (for the subdivision) to 32
// it's the granularity/precision of the effect 
32 => int osc_nb_subdivision_sound_sample;

// number tones per scale
8 => int osc1_nb_tones_in_scale;    // 6 = 75% of 8 tones (ps: some groove is here !)
// using for "simulate" a cast float (t paramater) to integer (index on tone in a scale)
1.0/osc1_nb_tones_in_scale => float osc1_step_for_cast_float_to_int;

// number tones per scale
8 => int osc2_nb_tones_in_scale;    // 8 = 100% of 8 tones
// using for "simulate" a cast float (t paramater) to integer (index on tone in a scale)
1.0/osc2_nb_tones_in_scale => float osc2_step_for_cast_float_to_int;

// Irrational number to guide the parameter of the heart function
// url: http://en.wikipedia.org/wiki/Irrational_number
// (ps: Some groove is here !!!)
1.0/(2*1.414213) => float irrationel_term; // 1.414213 ~= square root of 2
// ---------------------------------------------------------------------------------------

// Define oscillators
//
// First oscillator (Sine Waves) : link to a major scale (C4-M)
SinOsc osc1_major_scale => dac;
0.150 => osc1_major_scale.gain;	// set the initial gain for this oscillator
//
// Second oscillator(Triangle Waves) : link to a minor melodic scale (A4-m)
TriOsc osc2_minor_scale => dac;
0.100 => osc2_minor_scale.gain;

// ---------------------------------------------------------------------------------------
// Compute the centroid (~ mass center) of a "Heart function"
// url: mathworld.wolfram.com/HeartCurve.html (the 6th function)
// set some variables to compute a Axis-Aligned Bounding-Box (AABBox) of this function 
// -> url http://en.wikipedia.org/wiki/Minimum_bounding_box
// ---------------------------------------------------------------------------------------
 10000.0    => float x_min; // +10000.0 pretty high, to be sure to be greater than the x min value
-10000.0    => float x_max; // -10000.0 pretty low,  to be sure to be lesser than the x max value
 10000.0    => float y_min; // the same for y   (min)
-10000.0    => float y_max; //                  (max)
// set the number of samples use for this computation
1024 => int nb_samples;
// step to parse the entry domain values of this function, [-pi, +pi] = 2*pi, with nb_samples
(2.0*pi) / nb_samples => float t_step;
// initial value for the domain values
-pi => float t;
// compute the centroid
for( 0 => int i; i < nb_samples; i++ )
{    
    // retrieve a parameter t in [-pi, +pi]    
    // _t -> _tm1p1 (=t') : [-pi, +pi] -> [-1, +1]
    t/pi => float tm1p1;    
    
    // sin(t')
    //
    // --------------------
	// Using Sinus oscillation function    
    // (ps: some groove is here ! ;-))    
    // Approximation of sin(osc1_func_heart_indice);
    // url: http://devmaster.net/posts/9648/fast-and-accurate-sine-cosine
    // --------------------    
    0.0 => float sin_tm1p1;
    {
        // alias 'x' for sinus parameter
        tm1p1 => float x;
        // wrap x in [-pi, +pi] range
        while(x > pi) 
            x - 2*pi => x;
        while(x < -pi) 
            x + 2*pi => x;
        // Set some constants for computation
        4 / pi => float B;
        9.86960 => float sqrt_pi;
        -4 / sqrt_pi => float C;
        // compute absolute (abs) value of x
        x => float abs_x;
        if( x < 0)
            -x => abs_x;
        // Compute the sinus approximation         
        B * x + C * x * abs_x => sin_tm1p1;
    }
    
    // x = 16*sin(t')^3
    16.0*sin_tm1p1*sin_tm1p1*sin_tm1p1 => float x;
    
    // y = 13*cos(t') - 5*cos(2t') - 2*cos(3t') - cos(4t')
    // cos(t') = sin(t' + pi/2)
    0.0 => float cos_tm1p1;
    {
        // alias 'x' for sinus parameter
        tm1p1 + (pi/2) => float x;
        // wrap x in [-pi, +pi] range
        while(x > pi) 
            x - 2*pi => x;
        while(x < -pi) 
            x + 2*pi => x;
        // Set some constants for computation
        4 / pi => float B;
        9.86960 => float sqrt_pi;
        -4 / sqrt_pi => float C;
        // compute absolute (abs) value of x
        x => float abs_x;
        if( x < 0)
            -x => abs_x;
        // Compute the sinus approximation         
        B * x + C * x * abs_x => cos_tm1p1;
    }
    // cos(2t')
    0.0 => float cos_2_tm1p1;
    {
        // alias 'x' for sinus parameter
        2*tm1p1 + (pi/2) => float x;
        // wrap x in [-pi, +pi] range
        while(x > pi) 
            x - 2*pi => x;
        while(x < -pi) 
            x + 2*pi => x;
        // Set some constants for computation
        4 / pi => float B;
        9.86960 => float sqrt_pi;
        -4 / sqrt_pi => float C;
        // compute absolute (abs) value of x
        x => float abs_x;
        if( x < 0)
            -x => abs_x;
        // Compute the sinus approximation         
        B * x + C * x * abs_x => cos_2_tm1p1;
    }
    // cos(3t')
    0.0 => float cos_3_tm1p1;
    {
        // alias 'x' for sinus parameter
        3*tm1p1 + (pi/2) => float x;
        // wrap x in [-pi, +pi] range
        while(x > pi) 
            x - 2*pi => x;
        while(x < -pi) 
            x + 2*pi => x;
        // Set some constants for computation
        4 / pi => float B;
        9.86960 => float sqrt_pi;
        -4 / sqrt_pi => float C;
        // compute absolute (abs) value of x
        x => float abs_x;
        if( x < 0)
            -x => abs_x;
        // Compute the sinus approximation         
        B * x + C * x * abs_x => cos_3_tm1p1;
    }
    // cos(4t')
    0.0 => float cos_4_tm1p1;
    {
        // alias 'x' for sinus parameter
        4*tm1p1 + (pi/2) => float x;
        // wrap x in [-pi, +pi] range
        while(x > pi) 
            x - 2*pi => x;
        while(x < -pi) 
            x + 2*pi => x;
        // Set some constants for computation
        4 / pi => float B;
        9.86960 => float sqrt_pi;
        -4 / sqrt_pi => float C;
        // compute absolute (abs) value of x
        x => float abs_x;
        if( x < 0)
            -x => abs_x;
        // Compute the sinus approximation         
        B * x + C * x * abs_x => cos_4_tm1p1;
    }
    // y = 13*cos(t') - 5*cos(2t') - 2*cos(3t') - cos(4t')
    13*cos_tm1p1 - 5*cos_2_tm1p1 - 2*cos_3_tm1p1 - cos_4_tm1p1 => float y;
    
    // update the bbox (min, max)
    if( x < x_min)
        x => x_min;
    if( y < y_min)
        y => y_min;
    if( x > x_max)
        x => x_max;
    if( y > y_max)
        y => y_max;    
    
    // next sample
    t + t_step => t;   
}
// compute the center of the BBox ~= centroid of this heart function
// ~ center of the Circumcircle of this heart function
// url: http://www.proofwiki.org/wiki/Definition:Circumcircle_of_Triangle
(x_min + x_max) / 2.0 => float func_heart_06_xc;
(y_min + y_max) / 2.0 => float func_heart_06_yc;
// ---------------------------------------------------------------------------------------
  
// integer indice using for computing the variation on the heart
0.00 => float osc1_func_heart_indice;
// integer indice using for computing the variation on the heart
0.00 => float osc2_func_heart_indice;           

// Compute the velocity of the parameter belong the heart function
// (ps: Some groove is here !!!)
// speed for the variation of the indice (link to length of a note)
time_length_for_a_chord*(2 + irrationel_term) => float osc1_func_heart_inc_indice;
// speed for the variation of the indice (link to length of a note)
time_length_for_a_chord*(2 + irrationel_term) => float osc2_func_heart_inc_indice;

// ------------------------------
// Effect: Fade out
// ------------------------------
// Save the initials gains (using to apply a fade-out at the end of the song)
osc1_major_scale.gain() => float initial_osc1_gain;
osc2_minor_scale.gain() => float initial_osc2_gain;

// Variables to save the frequencies on Oscillators
float osc1_freq;
float osc2_freq;

// for random approximation
5323 => int nSeed;

// Loop simulation of the song
while(time_current_length_song <= time_max_length_song)
{
    // Evaluate a t parameter for our heart function
    // Use the approximation of a sinus
    0.0 => float osc1_sin_func_heart_indice;    
    {
        // alias 'x' for sinus parameter
        osc1_func_heart_indice => float x;
        // wrap x in [-pi, +pi] range
        while(x > pi) 
            x - 2*pi => x;
        while(x < -pi) 
            x + 2*pi => x;
        // Set some constants for computation
        4 / pi => float B;
        9.86960 => float sqrt_pi;
        -4 / sqrt_pi => float C;
        // compute absolute (abs) value of x
        x => float abs_x;
        if( x < 0)
            -x => abs_x;
        // Compute the sinus approximation         
        B * x + C * x * abs_x => osc1_sin_func_heart_indice;
    }
    osc1_sin_func_heart_indice * pi => float osc1_func_heart_t;
       
    // add a (random [0.025, 0.10] sec) delay for the second track (oscillator)
    // (ps: add some groove here ^^)
    0.0 => float rand2f_025_100;    
    {
        (8253729 * nSeed + 2396403) => nSeed;
        nSeed % 32767 => rand2f_025_100;
        rand2f_025_100 / 32767.0 => rand2f_025_100;
        (rand2f_025_100 + 0.25) / (0.25 + 1.0) => rand2f_025_100;
    }    
    osc2_func_heart_indice + osc2_func_heart_inc_indice*(0.1*rand2f_025_100) => float osc2_t_add_delay;
    
    0.0 => float osc2_sin_t;
    {
        // alias 'x' for sinus parameter
        osc2_t_add_delay => float x;
        // wrap x in [-pi, +pi] range
        while(x > pi) 
            x - 2*pi => x;
        while(x < -pi) 
            x + 2*pi => x;
        // Set some constants for computation
        4 / pi => float B;
        9.86960 => float sqrt_pi;
        -4 / sqrt_pi => float C;
        // compute absolute (abs) value of x
        x => float abs_x;
        if( x < 0)
            -x => abs_x;
        // Compute the sinus approximation         
        B * x + C * x * abs_x => osc2_sin_t;
    }
    //
    osc2_sin_t * pi => float osc2_func_heart_t;	

    // --------------------------------------------
    // SONG "COMPUTATION"
    // --------------------------------------------
    // compute a projection of the heart function 
    
    // --------------------------------------------
    // Oscillator 1
    // --------------------------------------------
    // retrieve a parameter t in [-pi, +pi]    
    // _t -> _tm1p1 (=t') : [-pi, +pi] -> [-1, +1]
    osc1_func_heart_t/pi => float osc1_tm1p1;    
    // sin(t')
    0.0 => float osc1_sin_tm1p1;
    {
        // alias 'x' for sinus parameter
        osc1_tm1p1 => float x;
        // wrap x in [-pi, +pi] range
        while(x > pi) 
            x - 2*pi => x;
        while(x < -pi) 
            x + 2*pi => x;
        // Set some constants for computation
        4 / pi => float B;
        9.86960 => float sqrt_pi;
        -4 / sqrt_pi => float C;
        // compute absolute (abs) value of x
        x => float abs_x;
        if( x < 0)
            -x => abs_x;
        // Compute the sinus approximation         
        B * x + C * x * abs_x => osc1_sin_tm1p1;
    }
    
    // x = 16*sin(t')^3
    16.0*osc1_sin_tm1p1*osc1_sin_tm1p1*osc1_sin_tm1p1 => float osc1_x;
    
    // y = 13*cos(t') - 5*cos(2t') - 2*cos(3t') - cos(4t')
    // cos(t') = sin(t' + pi/2)
    0.0 => float osc1_cos_tm1p1;
    {
        // alias 'x' for sinus parameter
        osc1_tm1p1 + (pi/2) => float x;
        // wrap x in [-pi, +pi] range
        while(x > pi) 
            x - 2*pi => x;
        while(x < -pi) 
            x + 2*pi => x;
        // Set some constants for computation
        4 / pi => float B;
        9.86960 => float sqrt_pi;
        -4 / sqrt_pi => float C;
        // compute absolute (abs) value of x
        x => float abs_x;
        if( x < 0)
            -x => abs_x;
        // Compute the sinus approximation         
        B * x + C * x * abs_x => osc1_cos_tm1p1;
    }
    // cos(2t')
    0.0 => float osc1_cos_2_tm1p1;
    {
        // alias 'x' for sinus parameter
        2*osc1_tm1p1 + (pi/2) => float x;
        // wrap x in [-pi, +pi] range
        while(x > pi) 
            x - 2*pi => x;
        while(x < -pi) 
            x + 2*pi => x;
        // Set some constants for computation
        4 / pi => float B;
        9.86960 => float sqrt_pi;
        -4 / sqrt_pi => float C;
        // compute absolute (abs) value of x
        x => float abs_x;
        if( x < 0)
            -x => abs_x;
        // Compute the sinus approximation         
        B * x + C * x * abs_x => osc1_cos_2_tm1p1;
    }
    // cos(3t')
    0.0 => float osc1_cos_3_tm1p1;
    {
        // alias 'x' for sinus parameter
        3*osc1_tm1p1 + (pi/2) => float x;
        // wrap x in [-pi, +pi] range
        while(x > pi) 
            x - 2*pi => x;
        while(x < -pi) 
            x + 2*pi => x;
        // Set some constants for computation
        4 / pi => float B;
        9.86960 => float sqrt_pi;
        -4 / sqrt_pi => float C;
        // compute absolute (abs) value of x
        x => float abs_x;
        if( x < 0)
            -x => abs_x;
        // Compute the sinus approximation         
        B * x + C * x * abs_x => osc1_cos_3_tm1p1;
    }
    // cos(4t')
    0.0 => float osc1_cos_4_tm1p1;
    {
        // alias 'x' for sinus parameter
        4*osc1_tm1p1 + (pi/2) => float x;
        // wrap x in [-pi, +pi] range
        while(x > pi) 
            x - 2*pi => x;
        while(x < -pi) 
            x + 2*pi => x;
        // Set some constants for computation
        4 / pi => float B;
        9.86960 => float sqrt_pi;
        -4 / sqrt_pi => float C;
        // compute absolute (abs) value of x
        x => float abs_x;
        if( x < 0)
            -x => abs_x;
        // Compute the sinus approximation         
        B * x + C * x * abs_x => osc1_cos_4_tm1p1;
    }
    // y = 13*cos(t') - 5*cos(2t') - 2*cos(3t') - cos(4t')
    13*osc1_cos_tm1p1 - 5*osc1_cos_2_tm1p1 - 2*osc1_cos_3_tm1p1 - osc1_cos_4_tm1p1 => float osc1_y;
    
    // Projection of the coordinates results (x,y) of this heart function to a unit circle
    // translate the position (_x,_y) with the center (_xc,_yc)
    osc1_x - func_heart_06_xc => float osc1_xp;
    osc1_y - func_heart_06_yc => float osc1_yp;
    
    // compute and return the angle of the position (xp, yp)
    // atan2 -> url: http://www.cplusplus.com/reference/cmath/atan2/
    // Approximation of atan2
    // url: https://gist.github.com/volkansalma/2972237
    0.0 => float osc1_atan2_yp_xp;
    {
        osc1_yp => float y;
        osc1_xp => float x;
        pi / 4 => float ONEQTR_PI;
        3 * pi / 4 => float THRQTR_PI;
        osc1_yp => float abs_osc1_yp;
        float r;
        float angle;
        y + 0.00000001 => float abs_y; // add epsilon to prevent 0/0 condition
        if( abs_y < 0.0 )
            - abs_y => abs_y;
        if( x < 0.0 )
        {
            (x + abs_y) / (abs_y - x) => r;
            THRQTR_PI => angle;
        }
        else
        {
            (x - abs_y) / (abs_y + x) => r;
            ONEQTR_PI => angle;
        }
        (0.1963 * r * r - 0.9817) * r + angle => angle;
        if( y < 0.0 )
            -angle => angle;
        
        angle => osc1_atan2_yp_xp;
    }
    
    osc1_atan2_yp_xp => float osc1_t;
	
    // --------------------------------------------
    // Oscillator 2
    // --------------------------------------------
    // retrieve a parameter t in [-pi, +pi]    
    // _t -> _tm1p1 (=t') : [-pi, +pi] -> [-1, +1]
    osc2_func_heart_t/pi => float osc2_tm1p1;    
    // sin(t')
    0.0 => float osc2_sin_tm1p1;
    {
        // alias 'x' for sinus parameter
        osc2_tm1p1 => float x;
        // wrap x in [-pi, +pi] range
        while(x > pi) 
            x - 2*pi => x;
        while(x < -pi) 
            x + 2*pi => x;
        // Set some constants for computation
        4 / pi => float B;
        9.86960 => float sqrt_pi;
        -4 / sqrt_pi => float C;
        // compute absolute (abs) value of x
        x => float abs_x;
        if( x < 0)
            -x => abs_x;
        // Compute the sinus approximation         
        B * x + C * x * abs_x => osc2_sin_tm1p1;
    }
    
    // x = 16*sin(t')^3
    16.0*osc2_sin_tm1p1*osc2_sin_tm1p1*osc2_sin_tm1p1 => float osc2_x;
    
    // y = 13*cos(t') - 5*cos(2t') - 2*cos(3t') - cos(4t')
    // cos(t') = sin(t' + pi/2)
    0.0 => float osc2_cos_tm1p1;
    {
        // alias 'x' for sinus parameter
        osc2_tm1p1 + (pi/2) => float x;
        // wrap x in [-pi, +pi] range
        while(x > pi) 
            x - 2*pi => x;
        while(x < -pi) 
            x + 2*pi => x;
        // Set some constants for computation
        4 / pi => float B;
        9.86960 => float sqrt_pi;
        -4 / sqrt_pi => float C;
        // compute absolute (abs) value of x
        x => float abs_x;
        if( x < 0)
            -x => abs_x;
        // Compute the sinus approximation         
        B * x + C * x * abs_x => osc2_cos_tm1p1;
    }
    // cos(2t')
    0.0 => float osc2_cos_2_tm1p1;
    {
        // alias 'x' for sinus parameter
        2*osc2_tm1p1 + (pi/2) => float x;
        // wrap x in [-pi, +pi] range
        while(x > pi) 
            x - 2*pi => x;
        while(x < -pi) 
            x + 2*pi => x;
        // Set some constants for computation
        4 / pi => float B;
        9.86960 => float sqrt_pi;
        -4 / sqrt_pi => float C;
        // compute absolute (abs) value of x
        x => float abs_x;
        if( x < 0)
            -x => abs_x;
        // Compute the sinus approximation         
        B * x + C * x * abs_x => osc2_cos_2_tm1p1;
    }
    // cos(3t')
    0.0 => float osc2_cos_3_tm1p1;
    {
        // alias 'x' for sinus parameter
        3*osc2_tm1p1 + (pi/2) => float x;
        // wrap x in [-pi, +pi] range
        while(x > pi) 
            x - 2*pi => x;
        while(x < -pi) 
            x + 2*pi => x;
        // Set some constants for computation
        4 / pi => float B;
        9.86960 => float sqrt_pi;
        -4 / sqrt_pi => float C;
        // compute absolute (abs) value of x
        x => float abs_x;
        if( x < 0)
            -x => abs_x;
        // Compute the sinus approximation         
        B * x + C * x * abs_x => osc2_cos_3_tm1p1;
    }
    // cos(4t')
    0.0 => float osc2_cos_4_tm1p1;
    {
        // alias 'x' for sinus parameter
        4*osc2_tm1p1 + (pi/2) => float x;
        // wrap x in [-pi, +pi] range
        while(x > pi) 
            x - 2*pi => x;
        while(x < -pi) 
            x + 2*pi => x;
        // Set some constants for computation
        4 / pi => float B;
        9.86960 => float sqrt_pi;
        -4 / sqrt_pi => float C;
        // compute absolute (abs) value of x
        x => float abs_x;
        if( x < 0)
            -x => abs_x;
        // Compute the sinus approximation         
        B * x + C * x * abs_x => osc2_cos_4_tm1p1;
    }
    // y = 13*cos(t') - 5*cos(2t') - 2*cos(3t') - cos(4t')
    13*osc2_cos_tm1p1 - 5*osc2_cos_2_tm1p1 - 2*osc2_cos_3_tm1p1 - osc2_cos_4_tm1p1 => float osc2_y;
    
    // Projection of the coordinates results (x,y) of this heart function to a unit circle
    // translate the position (_x,_y) with the center (_xc,_yc)
    osc2_x - func_heart_06_xc => float osc2_xp;
    osc2_y - func_heart_06_yc => float osc2_yp;
    
    // compute and return the angle of the position (xp, yp)
    // atan2 -> url: http://www.cplusplus.com/reference/cmath/atan2/
    // Approximation of atan2
    // url: https://gist.github.com/volkansalma/2972237
    0.0 => float osc2_atan2_yp_xp;
    {
        osc1_yp => float y;
        osc1_xp => float x;
        pi / 4 => float ONEQTR_PI;
        3 * pi / 4 => float THRQTR_PI;
        osc1_yp => float abs_osc1_yp;
        float r;
        float angle;
        y + 0.00000001 => float abs_y; // add epsilon to prevent 0/0 condition
        if( abs_y < 0.0 )
            - abs_y => abs_y;
        if( x < 0.0 )
        {
            (x + abs_y) / (abs_y - x) => r;
            THRQTR_PI => angle;
        }
        else
        {
            (x - abs_y) / (abs_y + x) => r;
            ONEQTR_PI => angle;
        }
        (0.1963 * r * r - 0.9817) * r + angle => angle;
        if( y < 0.0 )
            -angle => angle;
        
        angle => osc2_atan2_yp_xp;
    }
    
    osc2_atan2_yp_xp => float osc2_t;

    // --------------------------------------------
	// Projections of t parameters (osc1, osc2) on some scales (major, minor)
    // Project a analogic parameter(mathematical response of a function) to a discrete represention (music scales)
	// we retreive a frequency correspond to a note/tone of this scale
    // --------------------------------------------
    // _t -> _t01 : [0, 2pi [ -> [0, 1[
    (osc1_t+pi)/(2.00*pi) => float osc1_t_01;
    (osc2_t+pi)/(2.00*pi) => float osc2_t_01;
    
    // For the "Bass" line: A4_minor_melodic_scale
    // (simulate a) cast float t to integer index on : A4_minor_melodic_scale
    // return the frequency of a chord
    if( osc1_t_01 >= (0*osc1_step_for_cast_float_to_int) && osc1_t_01 <= (1*osc1_step_for_cast_float_to_int) )
        440.00 => osc1_freq;	// A4 frequency
    else if( osc1_t_01 >= (1*osc1_step_for_cast_float_to_int) && osc1_t_01 <= (2*osc1_step_for_cast_float_to_int) )
        493.88 => osc1_freq;	// B4 frequency
    else if( osc1_t_01 >= (2*osc1_step_for_cast_float_to_int) && osc1_t_01 <= (3*osc1_step_for_cast_float_to_int) )
        261.63 => osc1_freq;	// C4 frequency
    else if( osc1_t_01 >= (3*osc1_step_for_cast_float_to_int) && osc1_t_01 <= (4*osc1_step_for_cast_float_to_int) )
        293.66 => osc1_freq;	// D4 frequency
    else if( osc1_t_01 >= (4*osc1_step_for_cast_float_to_int) && osc1_t_01 <= (6*osc1_step_for_cast_float_to_int) )
        329.63 => osc1_freq;	// E4 frequency
    else if( osc1_t_01 >= (5*osc1_step_for_cast_float_to_int) && osc1_t_01 <= (7*osc1_step_for_cast_float_to_int) )
        369.99 => osc1_freq;	// F4# frequency
    else if( osc1_t_01 >= (6*osc1_step_for_cast_float_to_int) && osc1_t_01 <= (8*osc1_step_for_cast_float_to_int) )
        415.30 => osc1_freq;	// G4#  frequency
    //
    osc1_freq / 2.0 => osc1_major_scale.freq; 			// -> / 2.0 : create a bass line ("low" frequencies)
        
    
    // For the "Melody" line: C4_Major scale
    // (simulate a) cast float t to integer index on : C4_Major scale
    // return the frequency of a chord
    if( osc2_t_01 >= (0*osc2_step_for_cast_float_to_int) && osc2_t_01 <= (1*osc2_step_for_cast_float_to_int) )
        261.63 => osc2_freq;	// C4 frequency
    else if( osc2_t_01 >= (1*osc2_step_for_cast_float_to_int) && osc2_t_01 <= (2*osc2_step_for_cast_float_to_int) )
        293.66 => osc2_freq;	// D4 frequency
    else if( osc2_t_01 >= (2*osc2_step_for_cast_float_to_int) && osc2_t_01 <= (3*osc2_step_for_cast_float_to_int) )
        329.63 => osc2_freq;	// E4 frequency
    else if( osc2_t_01 >= (4*osc2_step_for_cast_float_to_int) && osc2_t_01 <= (5*osc2_step_for_cast_float_to_int) )
        349.23 => osc2_freq;	// F4 frequency
    else if( osc2_t_01 >= (5*osc2_step_for_cast_float_to_int) && osc2_t_01 <= (6*osc2_step_for_cast_float_to_int) )
        392.00 => osc2_freq;	// G4 frequency
    else if( osc2_t_01 >= (6*osc2_step_for_cast_float_to_int) && osc2_t_01 <= (7*osc2_step_for_cast_float_to_int) )
        440.00 => osc2_freq;	// A4 frequency
    else if( osc2_t_01 >= (7*osc2_step_for_cast_float_to_int) && osc2_t_01 <= (8*osc2_step_for_cast_float_to_int) )
        493.88 => osc2_freq;	// B4 frequency
    //
    osc2_freq => osc2_minor_scale.freq; 	// -> lead (melodic) line
    
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
    //
    osc1_func_heart_indice + osc1_func_heart_inc_indice => osc1_func_heart_indice;
    osc2_func_heart_indice + osc2_func_heart_inc_indice => osc2_func_heart_indice;
    
} // end of the song

<<< "Merci pour l'ecoute! :-D" >>>;
