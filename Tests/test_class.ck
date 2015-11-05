class CPolarFunction
{
    // Pre constructor
    0 => int m_value;
    0.0 => static float m_static_FloatMember;
    
    fun float getFrequency( float _theta )
    {
        return 0.0;
    }
}

class CHeartFunction_06 extends CPolarFunction
{
    // Override the getFrequency function
    fun float getFrequency( float _theta )
    {
        return 1.0;
    }
}

// array of references on parent class : CPolarFunction
CPolarFunction @ arrPolarFunctions[2];

// instante 2 childrens and assign references to the array
new CPolarFunction      @=> arrPolarFunctions[0];
new CHeartFunction_06   @=> arrPolarFunctions[1];

// loop
for( 0 => int i; i < arrPolarFunctions.cap(); i++ )
{
    <<< arrPolarFunctions[i].getFrequency(0.0) >>>;
}