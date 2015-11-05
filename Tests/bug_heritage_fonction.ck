class Constants
{
    2.0*pi => static float two_pi;
    // static value, useful for reparametrisation [0, 2pi] -> [0, 1]
    1.0 / two_pi => static float one_over_2_pi;       
    
    static Point2D @ origin;
    
    //
    100000.0    => static float big;    
    //
    100000.0    => static float MAX_FLOAT;
    -MAX_FLOAT  => static float MIN_FLOAT;
}

class Point2D
{
    // virtual function    
    fun float getValue( float _theta )
    {
        <<< "(virtual function) -> getValue(...)" >>> ;
        return 0.0;
    }
    
    fun Point2D getPosition( float _theta )
    {
        <<< "(virtual function) -> getPosition(...)" >>> ;
        return Constants.origin;
    }
    
    fun float getValue_From_01( float _t_01_parameter ) 
    {
        return getValue( _t_01_parameter * Constants.two_pi );
    }    
}

class myType
{
    0 => int _value;
    
    fun void set( int value )
    { 
        value => _value; 
    }
    
}

class Abstract    
{
    Point2D _object;
    
    fun Point2D func0()
    {
        //1 => _object._value;
        return _object;
    }
}

class Implement extends Abstract
{
    // overload
    fun Point2D func0()
    {
        //2 => _object._value;
        return _object;
    }
}

class Utility
{
    fun Point2D useFunc0( Abstract @ _abstract_object )
    {
        return _abstract_object.func0();
    }
}

Abstract inst_abstract;
Implement inst_implement;
Utility utility;

inst_abstract.func0();
inst_implement.func0();
utility.useFunc0( inst_abstract );
utility.useFunc0( inst_implement );

//<<< inst_abstract.func0()._value >>>;
//<<< inst_implement.func0()._value >>>;
//<<< utility.useFunc0( inst_abstract )._value >>>;
//<<< utility.useFunc0( inst_implement )._value >>>;

