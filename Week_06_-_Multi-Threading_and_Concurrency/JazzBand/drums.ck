// drums.ck
// Assigment #6 - Ethiopian Jazz - Musicawi Silt

// Part of your composition goes here

//"F:/__SOUND__/__COURSERA__/Introduction to Programming for Musicians and Digital Artists/Week 6 - Multi-Threading and Concurrency/JazzBand" => string path_for_files;
me.dir() => string path_for_files;
//"/media/atty/Seagate Expansion Drive/__SOUND__/__COURSERA__/Introduction to Programming for Musicians and Digital Artists/Week 6 - Multi-Threading and Concurrency/JazzBand" => string path_for_files;
//<<< path_for_files >>>;

[
 "drums_hithat_01.ck",
 "drums_hithat_02.ck",
 "drums_tom_verylow.ck",
 "drums_toms.ck",
 "drums_snares.ck",
 "drums_kick.ck",
 "drums_bell.ck"
] @=> string array_string_drum_instruments[];

int drum_instruments[array_string_drum_instruments.cap()];

for( 0 => int id_drum_instrument; id_drum_instrument < array_string_drum_instruments.cap(); id_drum_instrument++ )
{
	Machine.add( path_for_files + "/" + array_string_drum_instruments[id_drum_instrument] ) => drum_instruments[id_drum_instrument];
}

while(true)
{
    1::second => now;
}

