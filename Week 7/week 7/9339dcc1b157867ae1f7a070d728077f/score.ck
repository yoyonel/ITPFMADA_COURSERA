now => time start;

/*
Course: Music Programming
Date: 09Dec2013
Assignment #7: SomethingNice
*/

// score.ck
0 => int drumsID;
0 => int pianoID;
0 => int fluteID;
0 => int multiID;

//Timing : Make quarter Notes (main compositional pulse) 0.625::second in your composition
.625::second => dur quarter;


Machine.add(me.dir() + "/multi.ck") => multiID;

//15 seconds For loop
for(0=>int i;i<=48;i++)//15secs
{
    quarter/2=>now;   //Advance time    
    //start drums
    if(i==0)    Machine.add(me.dir() + "/drums.ck") => drumsID;        
    //start flute
    if(i==28)    Machine.add(me.dir() + "/flute.ck") => fluteID;
    //stop flute
    if(i==30)   Machine.remove(fluteID);
}
//stop drums
Machine.remove(drumsID);        

//15 seconds For loop
for(0=>int j;j<=24;j++)//15secs quarters*2
{
    //start bass
    if(j%4==1)    Machine.add(me.dir() + "/piano.ck") => pianoID;
    //stop bass
    if (j!=0) if(j%4==0)   Machine.remove(pianoID);
    
    if(j<17)    //first 23 iterations
    {
        quarter=>now;   //Advance time
    }
    else if(j<22) //next 5 iterations
    {
        quarter=>now;   //Advance time
    }
    else
    {
        quarter=>now;
    }
}
Machine.remove(multiID);

<<< "Length: ", (now - start) / 1::second >>>;