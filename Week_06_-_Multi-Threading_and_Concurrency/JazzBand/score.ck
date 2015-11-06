// score.ck
// Assigment #6 - Ethiopian Jazz - Musicawi Silt

// Part of your composition goes here

now => time start_composition;

//"F:/__SOUND__/__COURSERA__/Introduction to Programming for Musicians and Digital Artists/Week 6 - Multi-Threading and Concurrency/JazzBand" => string path_for_files;
me.dir() => string path_for_files;
//"/media/atty/Seagate Expansion Drive/__SOUND__/__COURSERA__/Introduction to Programming for Musicians and Digital Artists/Week 6 - Multi-Threading and Concurrency/JazzBand" => string path_for_files;
//<<< path_for_files >>>;

[
	"drums.ck",
	"bass.ck",
	"piano.ck",	
	"flute.ck",
	"guitar_01.ck"
] @=> string array_string_instruments[];

int instruments[array_string_instruments.cap()];

for( 0 => int id_instrument; id_instrument < array_string_instruments.cap(); id_instrument++ )
{
	Machine.add( path_for_files + "/" + array_string_instruments[id_instrument] ) => instruments[id_instrument];
}

while( (now - start_composition) < 30::second )
{
    1::second => now;
}

if( (now - start_composition) < 30::second )
{
	30::second - (now - start_composition) => now;
}

for( 0 => int id_instrument; id_instrument < array_string_instruments.cap(); id_instrument++ )
{
	Machine.remove( instruments[id_instrument] );
}
