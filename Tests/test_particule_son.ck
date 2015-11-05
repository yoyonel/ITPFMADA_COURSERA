// Particule de son

me.dir() + "/audio/" => string path;

//"stereo_fx_03.wav" => string name_of_wav;
//"stereo_fx_04.wav" => string name_of_wav;
//"stereo_fx_05.wav" => string name_of_wav;
//"kick_05.wav" => string name_of_wav;
//"kick_04.wav" => string name_of_wav;
"snare_01.wav" => string name_of_wav;

// ratios
0.00 => float ratio_naissance;
0.75 => float ratio_vie;
1.00 - (ratio_naissance + ratio_vie) => float ratio_mort;

// nombre de subdivisions temporelles requises pour chaque étape
1 => int nombre_de_subdivision_pour_naissance;
1 => int nombre_de_subdivision_pour_vie;
64 => int nombre_de_subdivision_pour_mort;

64 => int NB_MAX_PARTICULES;

// Structure d'une particule
dur duree_de_totale_de_vie[NB_MAX_PARTICULES];
float duree_de_naissance[NB_MAX_PARTICULES];
float duree_de_vie[NB_MAX_PARTICULES];
float duree_de_mort[NB_MAX_PARTICULES];
//
time pos_time_naissance[NB_MAX_PARTICULES];
time pos_time_vie[NB_MAX_PARTICULES];
time pos_time_mort[NB_MAX_PARTICULES];
//
int etat[NB_MAX_PARTICULES];
//
float gain_courant[NB_MAX_PARTICULES];
//
SndBuf wav[NB_MAX_PARTICULES];
// les pas de temps min. par étape
float pas_de_temps_min_naissance[NB_MAX_PARTICULES];
float pas_de_temps_min_vie[NB_MAX_PARTICULES];
float pas_de_temps_min_mort[NB_MAX_PARTICULES];
//
float t_01[NB_MAX_PARTICULES];

Gain master => dac;
//0 => p.pan;
0.25 => master.gain;

// init. des particules
for( 0 => int k; k < NB_MAX_PARTICULES; k++ )
{
    path + name_of_wav => wav[k].read;   // chargement d'un WAV
    1.0 => wav[k].rate;    
    
    wav[k].length() => duree_de_totale_de_vie[k];

    // remise à 0
    0 => etat[k];  // 0 : inactive
    wav[k].samples() => wav[k].pos;
    0.0 => wav[k].gain;
    
    wav[k] => master;
}

// indice de la particule courante à activer
0 => int id_particule_courante;

// Activation de la particule
//1 => etat[id_particule_courante];  // 1 : naissance

1.0 / 16.0 => float pas_de_temps_minimal;

//1::second / 64.0 => dur note_value;
//1::second / 32.0 => dur note_value;
//1::second / 16.0 => dur note_value;
//1::second / 8.0 => dur note_value;
1::second / 4.0 => dur note_value;
//1::second / 2.0 => dur note_value;
//1::second / 1.0 => dur note_value;
//1::second / 0.5 => dur note_value;
//1::second / 0.25 => dur note_value;


now => time start;
0::second => dur temps_passe;
0 => int beat;
now => time temps_derniere_note;

// Boucle de rendu du son
while( temps_passe <= 10.0::second )
{
    // on reset le pas de temps minimal pour la prochaine boucle
    (1.0/16.0) => pas_de_temps_minimal;
    
    // parcours sur la liste des particules
    for( 0 => int i; i < NB_MAX_PARTICULES; i++ )
    {
        if( etat[i] == 0)
        {
            //<<< "particule ", i, " etat 0" >>>;
        }
        else if( etat[i] == 1 )
        {
            // naissance
            //<<< "Naissance (debut) ..." >>>;
            
            now => pos_time_naissance[i];
            0.0 => t_01[i];
            
            (duree_de_totale_de_vie[i]/1::second) * ratio_naissance => duree_de_naissance[i];
            
            // on est dans une phase de naissance avec courbe de progression
            // on fait une requete de pas minimal de temps en conséquence
            (1.0/nombre_de_subdivision_pour_naissance) * duree_de_naissance[i] => pas_de_temps_min_naissance[i];
            Math.min(pas_de_temps_minimal, pas_de_temps_min_naissance[i]) => pas_de_temps_minimal;
            
            0.0 => gain_courant[i];
            
            0 => wav[id_particule_courante].pos; // on démarre la lecture du wav
            gain_courant[i] => wav[i].gain; // gain minimal
            
            // on passe à l'état suivant
            etat[i] ++;
            //<<< "fin etat (naissance debut) - gain courant: ", gain_courant[i] >>>;
            
        }
        else if( etat[i] == 2 )
        {
            // juste après la naissance
            //<<< "Naissance (pendant) ..." >>>;
            
            // On récupère le temps courant
            now => time temps_courant;
            
            // Combien de temps depuis le début de la naissance ?
            (temps_courant - pos_time_naissance[i]) / 1::second => float temps_naissance_passe;
            
            // ratio dans la naissance
            temps_naissance_passe / duree_de_naissance[i] => t_01[i];        
            Math.min( t_01[i], 1.0 ) => t_01[i];
                            
            // fonction lineaire
            t_01[i] => gain_courant[i];
            
            // => wav.pos;
            gain_courant[i] => wav[i].gain;
            
            // on est dans une phase de naissance avec courbe de progression
            // on fait une requete de pas minimal de temps en conséquence
            Math.min(pas_de_temps_minimal, pas_de_temps_min_naissance[i]) => pas_de_temps_minimal;
            
            // on passe à l'état suivant
            if( t_01[i] >= 1.0) 
            {
                etat[i] ++;
                //<<< "fin etat (naissance pendant) - gain courant: ", gain_courant >>>;
            }
                
            //<<< "temps_courant: ", temps_courant >>>;
            //<<< "pos_time_naissance: ", pos_time_naissance >>>;
            //<<< "temps_naissance_passe: ", temps_naissance_passe >>>;
            //<<< "duree_de_naissance: ", duree_de_naissance >>>;
            //<<< "parametre t [0.0, 1.0]: ", t_01 >>>;
            //<<< "gain courant: ", gain_courant >>>;
        }
        else if( etat[i] == 3 )
        {
            // vie
            //<<< "Vie (debut) !" >>>;
            
            now => pos_time_vie[i];
            
            0.0 => t_01[i];
            
            (duree_de_totale_de_vie[i]/1::second) * ratio_vie => duree_de_vie[i];
            
            // on est dans une phase de vie (constante)
            // on fait une requete de pas minimal de temps en conséquence
            (1.0/nombre_de_subdivision_pour_vie) * duree_de_vie[i] => pas_de_temps_min_vie[i];
            
            Math.min(pas_de_temps_minimal, pas_de_temps_min_vie[i]) => pas_de_temps_minimal;
            
            1.0 => gain_courant[i];
            
            // => wav.pos;
            gain_courant[i] => wav[i].gain;
            
            // on passe à l'état suivant
            etat[i] ++;
            //<<< "fin etat (debut vie) - gain courant: ", gain_courant >>>;
            
            //<<< duree_de_totale_de_vie/1::second >>>;
            //<<< ratio_vie >>>;
            //<<< duree_de_vie >>>;
            //<<< nombre_de_subdivision_pour_vie >>>;
            //<<< pas_de_temps_min_vie >>>;
            //<<< pas_de_temps_minimal >>>;
        }
        else if( etat[i] == 4 )
        {
            // 
            //<<< "Vie (pendant) ..." >>>;
            
            // On récupère le temps courant
            now => time temps_courant;
            
            // Combien de temps depuis le début de la naissance ?
            (temps_courant - pos_time_vie[i]) / 1::second => float temps_vie_passe;
            
            // ratio dans la naissance
            temps_vie_passe / duree_de_vie[i] => t_01[i];        
            Math.min( t_01[i], 1.0 ) => t_01[i];
                            
            // fonction constante
            1.0 => gain_courant[i];
            
            // => wav.pos;
            gain_courant[i] => wav[i].gain;
            
            // on est dans une phase de naissance avec courbe de progression
            // on fait une requete de pas minimal de temps en conséquence
            Math.min(pas_de_temps_minimal, pas_de_temps_min_vie[i]) => pas_de_temps_minimal;
            
            // on passe à l'état suivant
            if( t_01[i] >= 1.0) 
            {
                etat[i] ++;
                //<<< "fin etat (vie pendant) - gain courant: ", gain_courant >>>;
            }
                
            //<<< "parametre t [0.0, 1.0]: ", t_01 >>>;
            //<<< "pas_de_temps_min_vie : ", pas_de_temps_min_vie >>>;
            //<<< "pas_de_temps_minimal : ", pas_de_temps_minimal >>>;
        }
        else if( etat[i] == 5 )
        {
            // debut mort
            //<<< "Mort (début) !" >>>;        
            
            now => pos_time_mort[i];
            
            if( t_01[i] == 1.0 ) // on etait en vie l'état précédent
            {
                0.0 => t_01[i];
                
                (duree_de_totale_de_vie[i]/1::second) * ratio_mort => duree_de_mort[i];
                
                // on est dans une phase de mort (decroissante)
                // on fait une requete de pas minimal de temps en conséquence
                (1.0/nombre_de_subdivision_pour_mort) * duree_de_mort[i] => pas_de_temps_min_mort[i];
                
                Math.min(pas_de_temps_minimal, pas_de_temps_min_mort[i]) => pas_de_temps_minimal;
                
                //1.0 => gain_courant[i];
                
                // => wav.pos;
                gain_courant[i] => wav[i].gain;
            }
            else    // on a interrompu la naissance de la particule
            {
                //<<< "interrompue !" >>>;                                
                
                // stratègie: timing comme si on ne changait pas la pente de décroissance liée à la mort
                // => l'état inactif arrivera plus tot
                (duree_de_totale_de_vie[i]/1::second) * ratio_mort => duree_de_mort[i];
                
                // stratègie: on rallonge la durée de mort et on arrive à l'inactif comme prévu (sans interruption)
                // => la courbe de mort est "plus douce", timing plus long de décroissance
                (duree_de_totale_de_vie[i]/1::second) * ratio_vie * t_01[i] +=> duree_de_mort[i];
                
                (1.0/nombre_de_subdivision_pour_mort) * duree_de_mort[i] => pas_de_temps_min_mort[i];
                Math.min(pas_de_temps_minimal, pas_de_temps_min_mort[i]) => pas_de_temps_minimal;
                
                0.0 => t_01[i];
            }
            
            // on passe à l'état suivant
            etat[i] ++;
            //<<< "fin etat (debut mort) - gain courant: ", gain_courant >>>;
        }
        else if( etat[i] == 6 )
        {
            // 
            //<<< "Mort (pendant) ..." >>>;
            
            // On récupère le temps courant
            now => time temps_courant;
            
            // Combien de temps depuis le début de la naissance ?
            (temps_courant - pos_time_mort[i]) / 1::second => float temps_mort_passe;
            
            // ratio dans la naissance
            temps_mort_passe / duree_de_mort[i] => t_01[i];        
            Math.min( t_01[i], 1.0 ) => t_01[i];
                            
            // fonction decroissante lineaire
            1.0 - t_01[i] => gain_courant[i];
            
            // => wav.pos;
            gain_courant[i] => wav[i].gain;
            
            // on est dans une phase de naissance avec courbe de progression
            // on fait une requete de pas minimal de temps en conséquence
            Math.min(pas_de_temps_minimal, pas_de_temps_min_mort[i]) => pas_de_temps_minimal;
            
            // on passe à l'état suivant
            if( t_01[i] >= 1.0) 
            {
                etat[i] ++;
                //<<< "fin etat (mort pendant) - gain courant: ", gain_courant >>>;
            }
            
            //<<< pas_de_temps_min_mort >>>;
        }
        else if( etat[i] == 7 )
        {
            // desactivation de la particule
            //<<< "Desactivation Particule ", i, " etat ", etat[i], "... " >>>;
            
            wav[i].samples() => wav[i].pos;
            0.0 => wav[i].gain;
            
            0 => etat[i];
            //<<< "fin etat (desactivation) - gain courant: ", gain_courant[i] >>>;
        }
    }
    
    // ------------------------------------------------------------------------------------------ //
    // EQualisation sur les pistes actives                                                        //
    // ------------------------------------------------------------------------------------------ //
    // interet limité car connection un master qui "moyenne" déjà tous les wavs
    // parcours sur la liste des particules
    0.0 => float somme_gain;
    16.00 => float facteur_eq;
    for( 0 => int l; l < NB_MAX_PARTICULES; l++ )
    {
        if( l == id_particule_courante ) // si on est sur la particule courante => pondération forte (x8)
            (gain_courant[l] * facteur_eq) +=> somme_gain;
        else
            gain_courant[l] +=> somme_gain;
    }
    if( somme_gain > 1.0 )
    {
        //<<< "somme_gain : ", somme_gain >>>;
        1.0 / somme_gain => float facteur_gain_normalise;
        for( 0 => int l; l < NB_MAX_PARTICULES; l++ )
        {
            if( l == id_particule_courante ) // si on est sur la particule courante => pondération forte (x8)
                (facteur_gain_normalise * facteur_eq) *=> gain_courant[l];
            else
                facteur_gain_normalise *=> gain_courant[l];
        }
    }
    // ------------------------------------------------------------------------------------------ //       
    
    /**/
    if( (now-temps_derniere_note) + pas_de_temps_minimal::second > note_value )
    {
        //<<< "pas_de_temps_minimal :", pas_de_temps_minimal >>>;
        //<<< "(now-temps_derniere_note) + pas_de_temps_minimal::second :", ((now-temps_derniere_note) + pas_de_temps_minimal::second)/1::second >>>;
        //<<< "note_value :", note_value/1::second >>>;
        //((note_value + temps_derniere_note) - now)/1::second => pas_de_temps_minimal;
        ((note_value + temps_derniere_note) - now) => now;
        ((note_value + temps_derniere_note) - now)/1::second -=> pas_de_temps_minimal;
        //<<< "pas_de_temps_minimal :", pas_de_temps_minimal >>>;
    }
    /**/
    
    if( beat == 0 )
    {
        now => temps_derniere_note;
        0 => id_particule_courante;
        1 => etat[id_particule_courante];
        beat ++;
    }
    else if( ((now-temps_derniere_note) == note_value) && (beat < 16) )
    {
        now => temps_derniere_note;

        if( etat[id_particule_courante] != 0 )
        {
            // parcours sur la liste des particules
            for( 0 => int j; j < NB_MAX_PARTICULES; j++ )
            {
                if( etat[j] != 0 && (etat[j] < 5) )
                {                    
                    5 => etat[j];
                }
            }
            (id_particule_courante+1) % NB_MAX_PARTICULES => id_particule_courante;
            //(id_particule_courante+0) % NB_MAX_PARTICULES => id_particule_courante;
        }
        
        1 => etat[id_particule_courante];
        
        //<<< beat, id_particule_courante >>>;
        
        beat ++;
    }
    
    // On génère le son    
    pas_de_temps_minimal::second => now;
    
    (now-start) => temps_passe;
    
    <<< "pas_de_temps_minimal: ", pas_de_temps_minimal >>>;
    <<< "beat: ", beat >>>;
    <<< "temps_passe: ", temps_passe/1::second >>>;
    //<<< "pas_de_temps_minimal: ", pas_de_temps_minimal >>>;
    //<<< "gain courant: ", gain_courant >>>;
}