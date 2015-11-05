// piano.ck
// Assigment #6 - Ethiopian Jazz - Musicawi Silt

// Part of your composition goes here

"F:/__SOUND__/__COURSERA__/Introduction to Programming for Musicians and Digital Artists/Week 6 - Multi-Threading and Concurrency/JazzBand" => string path_for_files;
//me.dir() => string path_for_files;
//"/media/atty/Seagate Expansion Drive/__SOUND__/__COURSERA__/Introduction to Programming for Musicians and Digital Artists/Week 6 - Multi-Threading and Concurrency/JazzBand" => string path_for_files;
<<< path_for_files >>>;

[
 "piano_synthe_01_left.ck",
 "piano_synthe_01_right.ck", 
 //"piano_synthe_02_left.ck"
 "piano_synthe_02_right.ck" 
] @=> string array_string_piano_instruments[];

int piano_instruments[array_string_piano_instruments.cap()];

for( 0 => int id_piano_instrument; id_piano_instrument < array_string_piano_instruments.cap(); id_piano_instrument++ )
{
	Machine.add( path_for_files + "/" + array_string_piano_instruments[id_piano_instrument] ) => piano_instruments[id_piano_instrument];
}

while(true)
{
    1::second => now;
}

