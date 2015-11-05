// score.ck

// class paths
me.dir() + "/BPM.ck" => string BPMPath;
me.dir() + "/drumset.ck" => string drumsetPath;
me.dir() + "/bass.ck" => string bassPath;
me.dir() + "/organ.ck" => string organPath;
me.dir() + "/noteparser.ck" => string NPPath;
me.dir() + "/loop.ck" => string loopPath;


// Establish timing constraints


// Load classes
<<< "adding classes" >>>;
Machine.add(BPMPath);
Machine.add(drumsetPath);
Machine.add(bassPath);
Machine.add(NPPath);
Machine.add(organPath);
Machine.add(loopPath);
//30.1::second => now; // some time to pass


