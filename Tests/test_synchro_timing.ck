1.67525::second => dur length_sample; // par exemple

1024 => int nb_subdivision_sample;
length_sample / nb_subdivision_sample => dur step_subdivision_sample;
true => int is_active_sample_subdivision;

1::second => dur length_beat;
4 => int nb_sudbdivision_beat;
length_beat / nb_sudbdivision_beat => dur step_subdivision_beat;

now => time last_beat;
0 => int current_beat;
current_beat+1 => int next_beat;

true => int is_on_beat;
false => int is_on_beat_for_the_next_now;

step_subdivision_beat => dur minimal_step_time;

now => time start;

(now-start) => dur temps_passe;
( start + next_beat * length_beat ) => time time_for_the_next_beat; 

while( temps_passe < 5::second )
{
    // Est on (actuellement) sur un beat ?
    if( is_on_beat )
    {
        // activer un sample
        <<< "Activation sample sur beat: ", current_beat, "- temps passe: ", temps_passe/1::second >>>;
    }

    // Subdivision du sample active ?
    if( is_active_sample_subdivision )
    {
        step_subdivision_sample => minimal_step_time;
        
        if( is_on_beat )
        {
            false => is_on_beat_for_the_next_now;
        }
        else
        {
            // on veut savoir si avec ce pas de temps on rate le prochain beat ?
            // on calcule le prochain 'now' (après l'incrément temporel)
            now + minimal_step_time => time next_now;
            // on détermine si le prochain now sera après le prochain beat (donc on rate un beat)
            next_now > time_for_the_next_beat => int next_now_over_the_next_beat;            
            if( next_now_over_the_next_beat )
            {
                time_for_the_next_beat - now => minimal_step_time;
            }
            // Si on a ajusté l'incrément 
            // alors le prochain 'now' est sur le prochain beat
            // sinon il ne l'est pas
            next_now_over_the_next_beat => is_on_beat_for_the_next_now;
        }
    }

    // On consomme un temps audio
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