// Il semblerait que gain transforme le signal en stereo -> mono ...
// du coup il doit avoir un gain pour les inputs stéréo mais ce n'est pas documenté à priori
//Pan2 p => dac; // on a la stereo
//Pan2 p => Gain master => dac; // on n'a plus le stéréo :/

Gain master;
SndBuf2 mySound => Pan2 p => dac;

0.5 => master.gain;

//master.gain() * p.left. gain() => p.left.gain;
//master.gain() * p.right.gain() => p.right.gain;

master.gain() * mySound.gain() => mySound.gain;

me.dir() + "/audio/" => string path;
"stereo_fx_02.wav" => string name_of_wav;

path + name_of_wav => mySound.read;

0 => mySound.pos;

12::second => now;

