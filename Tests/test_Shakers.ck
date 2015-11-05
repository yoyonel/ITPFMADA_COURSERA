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
	0.75 	=> shak.decay;		// simule la dissipation �nerg�tique (plus c'est proche de 0, plus le son est 'sec')
	1.0 	=> shak.energy;		// r�gle l'impulsion d'�nergie au d�part
	44.0 	=> shak.freq;		// r�gle la fr�quence, r�sonnance du conteneur, effet de "taille" du conteneur
	
	0.5::second => now;
}