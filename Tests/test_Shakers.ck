Shakers shak => dac;

// Latino shaders
//0 => shak.preset; // 0 : maraca
//1 => shak.preset; // 1 : cabasa
//2 => shak.preset; // 2 : sekere
3 => shak.preset; // 3 : guiro
//6 => shak.preset; // 6 : tambourin

while( true )
{
	1000	=> shak.objects;	// simule un nombre d'objets (statistiques) dans un conteneur
	0.75 	=> shak.decay;		// simule la dissipation énergétique (plus c'est proche de 0, plus le son est 'sec')
	1.0 	=> shak.energy;		// règle l'impulsion d'énergie au départ
	44.0 	=> shak.freq;		// règle la fréquence, résonnance du conteneur, effet de "taille" du conteneur
	
	0.5::second => now;
}