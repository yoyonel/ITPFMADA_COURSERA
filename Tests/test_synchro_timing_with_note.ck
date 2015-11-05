// ----------------------------------------------------------------------------------------------------------
// Date     : 2013-11-08
// Auteur   : ATTY Lionel
// Résumé   : Gère la découpe du temps et synchro entre différentes sources de sons (midi)
//            Notions de composition, parties, barres, notes
//            Notions de gestion de subdivisions temporelles pour insertions de FXs (fade-in/out, pan, ...)
// ----------------------------------------------------------------------------------------------------------

now => time start;

true => int b_debug_activate;

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// 2.000 = ronde <=> x2
// 1.000 = blanche <=> x1
// 0.500 = noire <=> /2
// 0.250 = croche <=> /4
// 0.125 = double croche <=> /8
[ 0.125, 0.25, 0.5, 1, 2 ] @=> float arr_Durations_NotesValues[];
// using scale : D Dorian (<=> same notes of C-Maj) -> 1t 1/2t 1t 1t 1t 1/2t 1t
[ 50, 52, 53, 55, 57, 59, 60, 62 ] @=> int arr_MidiNotes_Scale[];
// Midi Indice For Silence (MIFS)
0 => int MIFS;

(arr_Durations_NotesValues[1] * 4)::second => dur dur_1_bar;    // temps pour une mesure

// ----------------------
[   
    1,  MIFS,   1,  2,  3,  6,  5,  MIFS,
    4,  MIFS,   4,  6,  5,  3,  1,  MIFS  
] @=> int arr_Degrees_Intro_1[];
// array of values note
[   
    2.0, 1.0, 1.0, 1.0, 2.0, 2.0, 3.5, 1.0,
    2.0, 1.0, 1.0, 1.0, 2.0, 2.0, 3.0, 2.5
] @=> float arr_NotesValues_Intro_1[];
//
0::second => dur dur_intro_1;
for( 0 => int i; i < arr_NotesValues_Intro_1.cap(); i++ )
{
    arr_NotesValues_Intro_1[i] => float f_note_value;
    Std.ftoi( f_note_value ) => int i_note_value;
    arr_Durations_NotesValues[ i_note_value ] * (1 + (f_note_value-i_note_value)) => f_note_value;
    f_note_value::second +=> dur_intro_1;
}
//<<< "dur_intro_1: ", dur_intro_1/1::second >>>;
// ----------------------
[ 
    "INTRO", "1",
    "INTRO", "1"
] @=> string arr_composition[];
0 => int id_indice_composition;
now => time start_next_part_composition;
// ------------------------------------------------------------------
4 => int nb_subdivision_fx_note;
0::second => dur step_subdivision_fx_note;
true => int is_fx_note_enable;

// Décomposition des beats utiles pour la gestion
// 'simultanée' de plusieurs mélodies/riffs/ligne de basse
// On considère la double croche comme l'élément atomique pour le rythme
1::second => dur length_beat; // on marque le temps
8 => int nb_sudbdivision_beat; // on marque les doubles croches
length_beat / nb_sudbdivision_beat => dur step_subdivision_beat; // on marque la double croche

now => time last_beat;
0 => int current_beat;
current_beat+1 => int next_beat;

true => int is_on_beat;
false => int is_on_beat_for_the_next_now;

step_subdivision_beat => dur minimal_step_time;

(now-start) => dur temps_passe;

start + next_beat * length_beat => time time_for_the_next_beat; 

int arr_Degrees[];
float arr_NoteValues[];
0 => int id_note;
now => time start_next_note;
now => time start_cur_note;

0 => int current_degree_note;
0.0 => float current_value_note;

0.0 => float f_note_value;
0 => int nb_suddivision_done_for_fx;
0::second => dur dur_note_value;

0.0 => float current_frequency_note;
0 => int current_midi_note;

true => int b_is_silence;

dur step_subdivision_fx_in, step_subdivision_fx_out;

while( temps_passe < 16::second ) // 16 secondes = 2 x Intro
{
    // reset the minimal step time
    step_subdivision_beat => minimal_step_time;
    
    // MAJ: ou en est on dans la composition ? (quelle partie?)
    if( (id_indice_composition < arr_composition.cap()) && // est ce qu'il reste des parties de la composition à jouer ?
        (now == start_next_part_composition) // est ce qu'il est temps de changer de partie ?
    )
    {
        // on démarre la lecture d'une partie
        arr_composition[id_indice_composition] => string name_part;
        if( name_part == "INTRO" )
        {
            arr_composition[id_indice_composition+1] => string name_part_version;
            Std.atoi(name_part_version) => int part_version;
            if( part_version == 1 )
            {
                arr_Degrees_Intro_1 @=> arr_Degrees;
                arr_NotesValues_Intro_1 @=> arr_NoteValues;
                0 => id_note;
                //
                dur_intro_1 +=> start_next_part_composition;
                
                // --- [DEBUG] --- //
                if( b_debug_activate )
                {
                    <<< temps_passe/1::second, "-> Intro - 1" >>>;
                }
                // ---         --- //
            }
            //
            id_indice_composition + 2 => id_indice_composition;
        }
    }
    
    // MAJ: ou en est on dans la partie de la composition ? (quelle note?)
    if( (id_note < arr_Degrees.cap()) &&
        (now == start_next_note)
    )
    {        
        // Set the current note (degree, value)        
        arr_Degrees[id_note] => current_degree_note;
        arr_NoteValues[id_note] => current_value_note;
        
        // Decode value note
        current_value_note => float f_note_value;
        Std.ftoi( f_note_value ) => int i_note_value;
        arr_Durations_NotesValues[ i_note_value ] * (1 + (f_note_value-i_note_value)) => f_note_value;
        f_note_value::second => dur_note_value;
        // update the next start note
        dur_note_value +=> start_next_note;
        // set the start current note (now)
        now => start_cur_note;
        // progress in note part
        id_note++;
        // set the step time for fx
        dur_note_value / (nb_subdivision_fx_note $ float) => step_subdivision_fx_note;        
        
        // Decode note        
        // Est ce un silence ?
        (current_degree_note == MIFS) => b_is_silence;
        if( !b_is_silence )
        { // si non
            // On récupère la note midi correspond au degree de la note
            arr_MidiNotes_Scale[current_degree_note-1] => current_midi_note;
            // On traduit la note midi en fréquence
            Std.mtof(current_midi_note) => current_frequency_note;
        }
        else
        { // si oui
            // valeurs par défaut
            -1 => current_midi_note;
             0 => current_frequency_note;
        }
        
        // --- [DEBUG] --- //
        if( b_debug_activate )
        {
            <<< temps_passe/1::second, ",", current_frequency_note, ",", f_note_value, ",",
                step_subdivision_fx_note/1::second, ",", nb_suddivision_done_for_fx >>>;
        }
        // ---         --- //
        
        0 => nb_suddivision_done_for_fx;
    }
 
    // FX: gestion
    // FX activés sur la note (courante) ?
    if( is_fx_note_enable )
    {
        if( !b_is_silence )
        {
            // temps passé depuis la création de la note ?
            now - start_cur_note => dur temps_note_passe;
            temps_note_passe / dur_note_value => float ratio_01_note; // ratio entre du temps passé pour jouer la note - [0.0,1.0]
            
            true => int is_fx_fade_in_enable;
            true => int is_fx_fade_out_enable;
            
            //
            if( is_fx_fade_in_enable )
            {
                //
                0.0 => float nb_step_subdivision_fx_fade_in;
                0.0 => float fx_fade_in_ratio_01;
                  0 => int i_nb_step_subdivision_fx_fade_in;
                
                // Stratégie : 
                // - nombre de samples fixe 
                // - ratio par rapport à la durée de la note (durée de l'effet relative à la durée de la note)
                //
                // MOG: ya du précalcul à faire !
                //
                0.01 => float fx_fade_in_ratio; // 1% de la durée de la note
                fx_fade_in_ratio * dur_note_value => dur fx_fade_in_length; // calcul de la durée de l'effet
                fx_fade_in_length / (nb_subdivision_fx_note $ float) => step_subdivision_fx_in; // pas de temps pour l'effet
                nb_subdivision_fx_note => i_nb_step_subdivision_fx_fade_in; // nombre de subdivision pour l'effet (redondant)

                // Quand démarre, finit l'effet ?
                start_cur_note => time fx_fade_in_start;
                fx_fade_in_start + fx_fade_in_length => time fx_fade_in_end;
                
                // Est on dans la plage temporelle du FX ?
                if( (now >= fx_fade_in_start) && (now <= fx_fade_in_end) )
                {
                    step_subdivision_fx_in => step_subdivision_fx_note;
                    (now-fx_fade_in_start) / fx_fade_in_length => fx_fade_in_ratio_01;
                    
                    <<< "FX-FadeIn - ratio : ", fx_fade_in_ratio_01 >>>;

                    // --- [DEBUG] --- //
                    if( b_debug_activate )
                    {
                        if( fx_fade_in_ratio_01 == 0.0 )
                        {
                            //<<< "--> fx_fade_in : ", i_nb_step_subdivision_fx_fade_in, "-", fx_fade_in_length/1::second >>>;
                        }
                    }
                }
            }
            
            /**/
            //
            if( is_fx_fade_out_enable )
            {
                //
                0.0 => float nb_step_subdivision_fx_fade_out;
                0.0 => float fx_fade_out_ratio_01;
                  0 => int i_nb_step_subdivision_fx_fade_out;
                
                // Stratégie : 
                // - nombre de samples fixe 
                // - ratio par rapport à la durée de la note (durée de l'effet relative à la durée de la note)
                //
                // MOG: ya du précalcul à faire !
                //
                0.50 => float fx_fade_out_ratio; // 50% de la durée de la note
                fx_fade_out_ratio * dur_note_value => dur fx_fade_out_length; // calcul de la durée de l'effet
                fx_fade_out_length / (nb_subdivision_fx_note $ float) => step_subdivision_fx_out; // pas de temps pour l'effet
                nb_subdivision_fx_note => i_nb_step_subdivision_fx_fade_out; // nombre de subdivision pour l'effet (redondant)
                
                start_next_note - fx_fade_out_length => time fx_fade_out_start;
                start_next_note => time fx_fade_out_end;
                
                //<<< now/1::second, fx_fade_out_start/1::second, fx_fade_out_end/1::second >>>;
                // Est on dans la plage temporelle du FX ?
                if( (now >= fx_fade_out_start) && (now <= fx_fade_out_end) )
                {
                    step_subdivision_fx_out => step_subdivision_fx_note;
                    (now-fx_fade_out_start) / fx_fade_out_length => fx_fade_out_ratio_01;
                    
                    <<< "FX-FadeOut - ratio : ", fx_fade_out_ratio_01 >>>;
                    
                    // --- [DEBUG] --- //
                    if( b_debug_activate )
                    {
                        if( fx_fade_out_ratio_01 == 0.0 )
                        {
                            //<<< "--> fx_fade_out : ", i_nb_step_subdivision_fx_fade_out, "-", fx_fade_out_length/1::second >>>;
                        }
                    }
                }
            }
            /**/
        }
    }
    
    // MAJ: Temps minimal de simulation audio
    // FX activés sur la note (courante) ?
    if( is_fx_note_enable )
    {
        Math.min( minimal_step_time/1::second, step_subdivision_fx_note/1::second ) * 1::second => minimal_step_time;
        
        if( is_on_beat ) // est ce qu'on est sur le beat ?
        {
            false => is_on_beat_for_the_next_now; // si oui: à la prochaine itération on n'y sera pas (min_step_time <= beat / 8)
        }
        else // si non
        {
            // on veut savoir si avec ce pas de temps on rate le prochain beat ?
            // on calcule le prochain 'now' (après l'incrément temporel)
            now + minimal_step_time => time next_now;
            // on détermine si le prochain now sera après le prochain beat (donc on rate un beat)
            next_now > time_for_the_next_beat => int next_now_over_the_next_beat;            
            if( next_now_over_the_next_beat )
            {
                // si oui : on re-ajuste le step time
                time_for_the_next_beat - now => minimal_step_time;
                
                // --- [DEBUG] --- //
                if( b_debug_activate )
                {
                    <<< temps_passe/1::second, ",", current_frequency_note, ",", f_note_value, ",",
                        step_subdivision_fx_note/1::second, ",", nb_suddivision_done_for_fx, "*" >>>;
                }
                // ---         --- //
            }
            // Si on a ajusté l'incrément 
            // alors le prochain 'now' est sur le prochain beat
            // sinon il ne l'est pas
            next_now_over_the_next_beat => is_on_beat_for_the_next_now;
            
            nb_suddivision_done_for_fx ++;
        }
    }
    
    // On consomme du temps audio
    minimal_step_time => now;
    
    // On met à jour le temps passe
    (now-start) => temps_passe;
    
    is_on_beat_for_the_next_now => is_on_beat;
    
    // Est on sur un beat ?
    if( is_on_beat )
    {
        current_beat ++;
        (current_beat+1) => next_beat;
        start + next_beat * length_beat => time_for_the_next_beat; 
    }
}
