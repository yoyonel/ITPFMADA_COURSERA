// bass.ck
// Assigment #6 - Ethiopian Jazz - Musicawi Silt

// Part of your composition goes here

"F:/__SOUND__/__COURSERA__/Introduction to Programming for Musicians and Digital Artists/Week 6 - Multi-Threading and Concurrency/JazzBand" => string path_for_files;
//me.dir() => string path_for_files;
//"/media/atty/Seagate Expansion Drive/__SOUND__/__COURSERA__/Introduction to Programming for Musicians and Digital Artists/Week 6 - Multi-Threading and Concurrency/JazzBand" => string path_for_files;
<<< path_for_files >>>;

[
 "bass_01.ck",
 "bass_02.ck"
] @=> string array_string_bass_instruments[];

int bass_instruments[array_string_bass_instruments.cap()];

for( 0 => int id_bass_instrument; id_bass_instrument < array_string_bass_instruments.cap(); id_bass_instrument++ )
{
	Machine.add( path_for_files + "/" + array_string_bass_instruments[id_bass_instrument] ) => bass_instruments[id_bass_instrument];
}

while(true)
{
    1::second => now;
}

