[ 
    69, 70, 71, 72, 72, 71, 71, 71
] @=> int arr_Midi_Notes[];

// Value Note/Silence - Dot - Divisive Rhythm - Tie
0 => int offset_Note_Value; // 'a.b' : a,b in [0, 9] (N)
1 => int offset_Dot; // 'a' : a in [0, 9] (N)
2 => int offset_DR; // 'a' : a in [0, 9] (N)
3 => int offset_Tie; // 'a' : a in [0, 1] (N)
[ 
    1.0,     0,   2,   0,
    1.0,     0,   2,   0,
    2.0,     0,   2,   0,
    1.0,     0,   2,   0,
    0.2,     1,   2,   0,
    1.0,     0,   2,   0,
    0.1,     0,   3,   0,
    1.0,     0,   2,   0
] @=> float arr_NV_Encoded[];

(offset_Tie + 1) => int inc_for_the_next_note;

arr_NV_Encoded.cap() / inc_for_the_next_note => int nb_notes;

// ---------------------------------------------------------------------------------------------
// - First step: search the maximals fractional timings for each divisive rhythm ...
// ---------------------------------------------------------------------------------------------
int arr_max_frac[10];
for(0 => int i; i<arr_max_frac.cap(); i++) 1 => arr_max_frac[i];
//1 => int max_frac_binaire;
//1 => int max_frac_ternaire;
//
for( 0 => int id_note; id_note < arr_NV_Encoded.cap(); inc_for_the_next_note +=> id_note )
{
    // get the encoding value note
    arr_NV_Encoded[ id_note + offset_Note_Value ] @=> float encoding_value_note;
    Std.ftoi(arr_NV_Encoded[ id_note + offset_Dot ]) @=> int value_note_dotted;
    Std.ftoi(arr_NV_Encoded[ id_note + offset_DR ]) @=> int value_note_divisive_rhythm;
    Std.ftoi(arr_NV_Encoded[ id_note + offset_Tie ]) @=> int value_note_tie; 
    // decompress the value note
    Std.sgn(encoding_value_note) < 0.0 => int is_silence;
    Std.fabs(encoding_value_note) => float abs_encoding_value_note;
    // Encodage sur 2 digits
    Std.ftoi(Math.trunc(abs_encoding_value_note)) => int value_note_a; // 1 digits
    Std.ftoi(Math.trunc((abs_encoding_value_note - value_note_a) * 10 )) => int value_note_b; // 1 digits
    // Compute the value note
    //0.0 => float value_note;
    0 => int max_frac;
    if( value_note_a == 0 )
    {
        Std.ftoi( Math.pow( 2, value_note_b ) ) + (value_note_divisive_rhythm - 2) => max_frac;
    }
    else
    {
        1 => max_frac;
    }
    // dotted
    for( 1 => int id_dotted; id_dotted <= value_note_dotted; id_dotted++ )
        2 *=> max_frac;
    
    // divisive rhythm
    Std.ftoi( Math.max( arr_max_frac[ value_note_divisive_rhythm - 2 ], max_frac ) ) => arr_max_frac[ value_note_divisive_rhythm - 2 ];
}

1 => int common_fractional;
for( 0 => int i; i<arr_max_frac.cap(); i++) 
{
    if( arr_max_frac[i] != 1 )
        <<< "max_frac: ", arr_max_frac[i] >>>;
    arr_max_frac[i] *=> common_fractional;
}
<<< "Common fractional for decomposition: ", common_fractional >>>;

/**
// -----------------------------------------------------------------
// - 2nd step: we decompose our song with the minimal step of time
// -----------------------------------------------------------------

for( 0 => int id_note; id_note < arr_NV_Encoded.cap(); inc_for_the_next_note +=> id_note )
{
    // get the encoding value note
    arr_NV_Encoded[ id_note + offset_Note_Value ] @=> float encoding_value_note;
    Std.ftoi(arr_NV_Encoded[ id_note + offset_Dot ]) @=> int value_note_dotted;
    Std.ftoi(arr_NV_Encoded[ id_note + offset_DR ]) @=> int value_note_divisive_rhythm;
    Std.ftoi(arr_NV_Encoded[ id_note + offset_Tie ]) @=> int value_note_tie; 

    // decompress the value note
    Std.sgn(encoding_value_note) < 0.0 => int is_silence;
    Std.fabs(encoding_value_note) => float abs_encoding_value_note;
    // Encodage sur 2 digits
    Std.ftoi(Math.trunc(abs_encoding_value_note)) => int value_note_a; // 1 digits
    Std.ftoi(Math.trunc((abs_encoding_value_note - value_note_a) * 10 )) => int value_note_b; // 1 digits
    //
    <<< "value_note_a: ", value_note_a >>>;
    <<< "value_note_b: ", value_note_b >>>;
    <<< "value_note_dotted: ", value_note_dotted >>>;
    <<< "value_note_divisive_rhythm: ", value_note_divisive_rhythm >>>;
    <<< "value_note_tie: ", value_note_tie >>>;

    // interpret the value note
    <<< "-> interpret the value note ..." >>>;
    //
    if( is_silence )
    {    
        <<< "silence ...", !is_silence >>>;
    }
    else
    {
        <<< "note a jouee !", !is_silence >>>;
    }
    //
    0 => float value_note;
    (value_note_a != 0.0) * Math.pow( 2, value_note_a-1 ) +=> value_note;
    (value_note_a == 0.0) * Math.pow( 2, 0-value_note_b ) +=> value_note;
    //
    <<< "value_note: ", value_note >>>;

    // dotted
    0.0 => float sum_dotted;
    for( 1 => int id_dotted; id_dotted <= value_note_dotted; id_dotted++ )
        1/Math.pow(2, id_dotted) +=> sum_dotted;
    value_note * sum_dotted => float inc_value_note_dotted;
    inc_value_note_dotted +=> value_note;
    //
    <<< "inc_value_note_dotted: ", inc_value_note_dotted >>>;
    <<< "update(value_note) -> use dotted : ", value_note >>>;

    // divisive rhythm
    2.0/value_note_divisive_rhythm => float coef_divisive_rhythm;
    coef_divisive_rhythm *=> value_note ;
    //
    <<< "coef_divisive_rhythm: ", coef_divisive_rhythm >>>;
    <<< "update(value_note) -> use divisive rhythm : ", value_note >>>;

    // is tie ?
    if( value_note_tie )
    {
    }
}
/**/