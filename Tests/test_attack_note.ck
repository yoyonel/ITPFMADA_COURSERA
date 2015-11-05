TriOsc osc1 => dac;

440.0 => osc1.freq;

0.5 => float max_gain;

0.5 => float timing_note;

256 => int nb_samples;
0.10 => float ratio_timing_for_attack_step_in;
0.10 => float ratio_timing_for_attack_step_out;
timing_note - (ratio_timing_for_attack_step_in + ratio_timing_for_attack_step_out) => float ratio_timing_for_constant_gain;

// first attack step in
// 0.0 -> gain_max_for_this_note
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
        step_t +=> cur_t;
        start_gain + cur_t * (end_gain - start_gain) => float cur_gain;
        cur_gain => osc1.gain;
        step_timing_note::second => now;
    }
}

// 2nd step: constant gain
{
    timing_note * ratio_timing_for_constant_gain => float timing_constant_gain;
    timing_constant_gain::second => now;
}

// last step attack step out
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
        // update t parameter : linear approach
        step_t +=> cur_t;
        // project t on domain gain
        start_gain + cur_t * (end_gain - start_gain) => float cur_gain;
        // update the gain
        cur_gain => osc1.gain;
        // consume audio time
        step_timing_note::second => now;
    }
}
