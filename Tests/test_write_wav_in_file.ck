// url: http://chuck.cs.princeton.edu/doc/examples/basic/rec-auto-stereo.ck
WvOut w;

// pull samples from the dac
// WvOut2 -> stereo operation
dac => w => blackhole;

// 
//"C:/Users/atty/Music/__COURSERA__/" => string path_filename;
me.dir() + "/" => string path_filename; // probleme !!! si depuis Google Drive ... bizarre
// ouput de Chuck:
//chuck](via WvOut): Could not create WAV file: C:/Users/atty/Google Drive/__SOUND__/__COURSERA__/Introduction to Programming for Musicians and Digital Artists/Teststest_write_ופGצ?הפXƒ/
//ר‚/
//4·ד.wav

<<< "path_filename: ", path_filename >>>;

path_filename + "test_write_wav" => w.autoPrefix;

"special:auto" => w.wavFilename;

// print it out
<<< "writing to file: ", w.filename() >>>;

// temporary workaround to automatically close file on remove-shred
null @=> w;

SinOsc s => dac;

440.0 => s.freq;
0.01 => s.gain;

1::second => now;
