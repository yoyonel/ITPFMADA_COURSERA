/*
Course: Music Programming
Date: 09Dec2013
Assignment #7: SomethingNice
*/
//multi.ck

// Oscillators
SinOsc Sin => Pan2 pSin => dac;
SawOsc Saw => Pan2 pSaw => dac;

//SnfBuf
SndBuf snare => dac;
SndBuf reversestereo => dac;

//STK instrument: soundchain for Sitar
Sitar sitar => Gain sitarGain => Gain master => dac;
sitarGain => Gain sitarFeedback => Delay delay => sitarGain;

//create class instances
SFA sndfl;
BPM volm;

//array declaration
[48, 50, 52, 53, 55, 57, 59, 60] @=> int A[]; //Make sure to ONLY use these MIDI Notes in your composition (the C Ionian mode)
[1.8,0.9,0.45,0.225,0.225/3] @=> float v[]; //Volume levels

//Timing : Make quarter Notes (main compositional pulse) 0.625::second in your composition
.625::second => dur quarter;

//sitar feedback parameters
.25::second => delay.max;
.25::second => delay.delay;

//volume
0.7 => Sin.gain;
0 => Saw.gain;
.5 => snare.gain;
.5 => reversestereo.gain;
.75 => sitarFeedback.gain;

//initialize pan position value
-1.0 => float panPosition;
2/90 => float panIncrement;

fun void setWave(string wave, int frequency, float vol)
{
    if(wave == "SinWave")
    {
        Std.mtof(frequency)=>Sin.freq;   //set Sin frequency
        vol =>Sin.gain; //set Sin gain
        panPosition => pSin.pan;    //sin pan value
    }
    else if(wave == "SawWave")
    {
        Std.mtof(frequency)=>Saw.freq;   //set Saw frequency    
        vol=>Saw.gain; //set Saw gain
        -1*panPosition => pSaw.pan; //saw pan value
    }
}

fun void setPan(string wave, float panvalue)
{
     if(wave == "SinWave")
    {
        panvalue => pSin.pan;    //sin pan value
    }
    else if(wave == "SawWave")
    {        
        panvalue => pSaw.pan; //saw pan value
    }
}

fun int theEnd(int index)
{
    if (index >=1)
    {
        0 => snare.pos;
        quarter=>now;
        return theEnd(index-1);
    }
    else if(index == 0)
    {
        return 0;
    }
}
//15 seconds For loop
for(0=>int i;i<=48;i++)//15secs
{
    if(i<28 || i>30){
    //Change Sin Osc settings
    setWave("SinWave",A[Math.random2(0,7)], v[Math.random2(0,4)]);
    //Change Saw Osc settings
    setWave("SawWave",A[Math.random2(0,7)],v[Math.random2(0,4)]);
    setPan("SinWave",panPosition);
    setPan("SawWave",-1*panPosition);
    panPosition+panIncrement => panPosition; //increment panPosition    
    Math.random2(0,2) => int which;
    sndfl.get(which) => snare.read;}
    quarter/2=>now;   //Advance time
}


//15 seconds For loop
for(0=>int j;j<=24;j++)//15secs quarters*2
{
    //Sitar control
    Std.mtof(A[Math.random2(0,7)]) => sitar.freq;
    sitar.noteOn(Math.randomf());
    
    //Panning control
    setPan("SinWave",panPosition);
    setPan("SawWave",-1*panPosition);
    panPosition+panIncrement => panPosition;    //increment panPosition
    
    //Use of negative .rate on SndBuf for reversekick
    sndfl.get(7) => reversestereo.read;
    reversestereo.samples() => reversestereo.pos;
    -1.0 => reversestereo.rate; //set rate - negative

    if(j<17)    //first 23 iterations
    {
        //Change Sin Osc settings
        setWave("SinWave",A[Math.random2(0,7)], v[Math.random2(0,4)]);
        //Change Saw Osc settings
        setWave("SawWave",A[Math.random2(0,7)],v[Math.random2(0,4)]);        
        quarter/2=>now;   //Advance time
        //Change Sin Osc settings
        setWave("SinWave",A[Math.random2(0,7)], v[Math.random2(0,4)]);
        //Change Saw Osc settings
        setWave("SawWave",A[Math.random2(0,7)],v[Math.random2(0,4)]);
        quarter/2=>now;   //Advance time
    }
    else if(j<22) //next 5 iterations
    {
        Math.srandom(A[0]); //randomize with seed value
        //Change Sin Osc settings
        setWave("SinWave",A[Math.random2(0,7)], v[Math.random2(0,4)]);
        //Change Saw Osc settings
        setWave("SawWave",A[Math.random2(0,7)],v[Math.random2(0,4)]);
        Std.mtof(A[Math.random2(0,7)]) => sitar.freq;
        sitar.noteOn(Math.randomf());
        quarter/2=>now;   //Advance time
        //Change Sin Osc settings
        setWave("SinWave",A[Math.random2(0,7)]/2, v[Math.random2(0,4)]);
        //Change Saw Osc settings
        setWave("SawWave",A[Math.random2(0,7)]/2,v[Math.random2(0,4)]);
        quarter/2=>now;   //Advance time
    }
    else    //last 2 iterations
    {
        theEnd(1);
    }
}
