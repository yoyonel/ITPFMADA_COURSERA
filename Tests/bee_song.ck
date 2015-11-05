// "Fallen into a Beehive"   by Enrico Cecini
// on doppler effect =)

Math.srandom(3367);
50 => int C; //number of bees
SawOsc s[C]; // Oscillators and Pans for each bee
Pan2 p[C];
for ( 0 => int i ; i< C ; ++i ) s[i] => p[i] => dac;

/* in a cartesian plain (x,y) you are at (0,y0) ; the bee is at (x0 + v*t , 0)
 v is the velocity of the bee with respect to its direction
 vs is the sound velocity
 vr is the relative velocity between you and the bee, mathematically computed
 g0 is the gain of the bee as measured locally (it is actually percepted divided by the distance)
 f0 is the frequency emitted by the bee as measured locally (it is actually percepted altered by the doppler effect)
 the pan position is mathematically computed as the actual angle for each bee
*/

.01=>float dt; //time step
float q[C];  /* variable giving the ratio between the frequencies percepted at the farest distancies */
340=>float vs;
500=>float xmax; // max value for x
20=>float ymax;
/* here some frequency, there's no serious reason for choosing them on the Dorian scale XD
 they could also be other frequencies or even randomly chosen each time
 but by fixing them there's a feeling of "structure" in the global sound */
[Std.mtof(47),Std.mtof(49),Std.mtof(50),Std.mtof(52),Std.mtof(54),Std.mtof(55),Std.mtof(57),Std.mtof(59),Std.mtof(61),Std.mtof(62),Std.mtof(74),Std.mtof(76),Std.mtof(77),Std.mtof(79),Std.mtof(81)]@=>float Dorian[];
float px[C]; /* ratio between the velocity of each bee and the sound velocity */
float v[C];
float vr[C];
float y0[C];
float x0[C]; // starting position of each bee
float x[C];  // position of each bee
float f0[C]; 
float f[C];  // f is the percepted frequency for each bee
for ( 0 => int i ; i< C ; ++i )
{
    Math.random2(0,Dorian.cap()-1) => int j1; /* choosing a starting frequency for each bee */
    Math.random2(0,Dorian.cap()-1) => int j2; /* choosing an ending frequency for each bee */
    if (j2==j1) --j2;   // they must be different
    Dorian[j1]=>f0[i];
    f0[i]/Dorian[j2]=>q[i]; /* computing the ratio between the frequencies */
    (q[i]-1)/(q[i]+1) => px[i]; /* this is the needed ratio for having the chosen frequencies */
    vs*px[i]=>v[i];
    Math.random2f(-ymax,ymax)=>y0[i]; /* choosing starting x0 and y0 in appropriate intervals */
    Math.random2f(-xmax,xmax)=>x0[i];
    x0[i]=>x[i];
}

0=>float t;     //initialize t and g0
0.2=>float g0;

while (t<60) // control the total time
{
    for ( 0 => int i ; i< C ; ++i )  // for each bee
    {
        x[i]+v[i]*dt=>x[i]; // update x
        if (Math.fabs(x[i])>=xmax) {x[i]+v[i]*t=>x0[i];-v[i]=>v[i];} /* invert the motion if too far */
        -v[i]*(x0[i]+v[i]*t)/Math.hypot(x[i],y0[i])=>vr[i]; /* this is the formula for relative velocity */

        f0[i]*vs/(vs-vr[i])=>f[i]; /* this is the doppler effect formula */
        
        f[i]=>s[i].freq;
        
        g0/Math.hypot(x[i],y0[i])=>s[i].gain; /* this is the distance attenuation of the gain formula */
        
        Math.atan(x[i]/y0[i])=>p[i].pan; /* pan in the actual angle of the cbee with respect of you  */
    }
    
    t+dt=>t;       // update t
    dt::second=>now;
}
