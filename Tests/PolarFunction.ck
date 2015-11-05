/**
*
*/
class CONSTANTS
{
    2.0 * pi => float two_pi;
    // static value, useful for reparametrisation [0, 2pi] -> [0, 1]
    1.0 / two_pi => float one_over_2_pi;       
    pi / 2.0 => float pi_over_2;
    
    Point2D @ origin;
    
    //
    100000.0    => float big;    
    //
    100000.0    => float MAX_FLOAT;
    -MAX_FLOAT  => float MIN_FLOAT;
        
    1.0/MAX_FLOAT  => float EPS_FLOAT;
    
    1.0/Math.sqrt(2*pi) => float inv_sqrt_2_pi;
}
CONSTANTS Constants;

/**
*
*/
class TOOLS
{    
    fun int EQUAL_0( float _value )
    {
        return (_value >= (0.0-Constants.EPS_FLOAT)) && (_value <= (0.0+Constants.EPS_FLOAT));
    }
    fun int EQUAL( float _a, float _b )
    {
        // LESS (<) OR EQUAL (= +epsilon)
        return (_a >= (_b-Constants.EPS_FLOAT)) && (_a <= (_b+Constants.EPS_FLOAT));
    }
    fun int LEQUAL( float _a, float _b )
    {
        // LESS (<) OR EQUAL (= +epsilon)
        return ( _a <= (_b+Constants.EPS_FLOAT) );
    }
    fun int GEQUAL( float _a, float _b )
    {
        // GREATER (>) OR EQUAL (= +epsilon)
        return ( _a >= (_b-Constants.EPS_FLOAT) );
    }
    fun int LESS( float _a, float _b )
    {
        // LESS (<)
        return ( _a < _b );
    }
    fun int GREATER( float _a, float _b )
    {
        // GREATER (>)
        return ( _a > _b );
    }
    
    fun float REMAP_TO_2PI( float _angle )
    {
        _angle => float angle;
        
        if( Std.fabs(_angle) > Constants.two_pi )
            Math.fmod(_angle, Constants.two_pi) => angle;        
        if( angle < 0 )
            Constants.two_pi +=> angle;
        
        return angle;
    }
    
    fun float Minimal_Distance_For_2_Angles( float _angle0, float _angle1 )
    {
        Math.min( _angle0, _angle1 ) => float min_angle;
        Math.max( _angle0, _angle1 ) => float max_angle;
        
        return Std.fabs( Math.min( max_angle - min_angle, (min_angle+Constants.two_pi) - max_angle ) );
    }
}
TOOLS Tools;

/**
*
*/
class Point2D
{
    0.0 => float x;
    0.0 => float y;
    
    fun void set( float _x, float _y ) { _x => x; _y => y; }
    fun void set( Point2D @ _pos ) { set( _pos.x, _pos.y ) ; }
    
    fun float length2()
    {
        return x*x + y*y;
    }
    
    fun float length()
    {
        return Math.sqrt( length2() );
    }
    
    fun Point2D minXY( Point2D @ _pos )
    {               
        this.set( Math.min(x, _pos.x) => this.x, Math.min(y, _pos.y) );
        return this;
    }
    
    fun Point2D maxXY( Point2D @ _pos )
    {        
        this.set( Math.max(x, _pos.x), Math.max(y, _pos.y) );
        return this;
    }
    
    fun Point2D sub( Point2D @ _pos )
    {
        this.set( x - _pos.x, y - _pos.y );
        return this;
    }
    
    fun float angle()
    {
        0.0 => float retour_angle;
        
        if( Tools.EQUAL_0(x) )
        {
            if( y > 0.0 )
                Constants.pi_over_2 => retour_angle;
            else
                3*Constants.pi_over_2 => retour_angle;
        } 
        else
            Math.atan2( y, x ) => retour_angle;
        
        return Tools.REMAP_TO_2PI( retour_angle );
    }
    
    fun static Point2D center( Point2D @ _A, Point2D @ _B )
    {
        Point2D p2D_center;
        p2D_center.set( (_A.x + _B.x)*0.5, (_A.y + _B.y)*0.5 );        
        return p2D_center;
    }
        
    
    fun string toString()
    {
        return x + " " + y;
    }
}

// ---------------------------------------------------------------------------------------------------------------
// ABSTRACT DEFINITIONS
// ---------------------------------------------------------------------------------------------------------------
/**
*
*/
class Abstract_PolarFunction
{
    Point2D position;
    
    // virtual function    
    fun float getValue( float _theta )
    {
        <<< "(virtual function) -> getValue(...)" >>> ;
        return 0.0;
    }
    
    fun Point2D @ getPosition( float _theta )
    {
        <<< "(virtual function) -> getPosition(...)" >>> ;
        return position;
    }
    
    fun float getAngle( float _theta )
    {
        <<< "getAngle(...) -  from Abstract class" >>>;
        return getPosition( _theta ).angle();
    }
    
    fun float getValue_From_01( float _t_01_parameter ) 
    {        
        return getValue( _t_01_parameter * Constants.two_pi );
    }
}

/**
*
*/
class Abstract_Projector_PolarFunction
{
    Point2D position;
    AABBox_PolarFunction aabbox;
    
    fun float project( float _theta, Abstract_PolarFunction @ _polar_function, Point2D @ _center_of_projection )
    {
        //<<< "project(...) -  from Abstract class" >>>;
        return project_value( _theta, _polar_function, _center_of_projection );
    }
        
    fun float project_value( float _theta, Abstract_PolarFunction @ _polar_function, Point2D @ _center_of_projection )
    {
        <<< "project_value(...) -  from Abstract class" >>>;
        return 0.0;
    }
        
    fun Point2D @ project_position( float _theta, Abstract_PolarFunction @ _polar_function, Point2D @ _center_of_projection )
    {
        <<< "project_position(...) -  from Abstract class" >>>;
        return position;
    }
    
    // utilisation d'une AABBox sur la fonction polaire pour aiguiller la projection
    fun float project( float _theta, Abstract_PolarFunction @ _polar_function, AABBox_PolarFunction @ _aabbox )
    {        
        return project_value( _theta, _polar_function, _aabbox );
    }
    
    fun float project_value( float _theta, Abstract_PolarFunction @ _polar_function, AABBox_PolarFunction @ _aabbox )
    {        
        return project_value( _theta, _polar_function, _aabbox.getCenter() );
    }
    
    fun Point2D project_position( float _theta, Abstract_PolarFunction @ _polar_function, AABBox_PolarFunction @ _aabbox )
    {        
        return project_position( _theta, _polar_function, _aabbox.getCenter() );
    }
}

class Abstract_Function
{
    // Members
    float func_min_value, func_max_value;        
    Domain_Values param_in;
    Domain_Values param_out;
    
    // Constructor
    0.0 => func_min_value => func_max_value;    
    0.0 => param_out.min_value => param_in.min_value;
    1.0 => param_out.max_value => param_in.max_value;
    
    // Functions
    fun float evaluate( float _param_in )
    {
        <<< "evaluate( ... ) - from Abstract class" >>>;
        return param_out.min_value;
    }
    
    fun int is_validate_param_in( float _param_in )
    {
        return param_in.inside( _param_in );
    }
    
    fun int is_validate_param_out( float _param_out )
    {
        return param_out.inside( _param_out );
    }
    
    // Methods
    fun void update_domain_values()
    {
        evaluate( param_in.min_value ) => float value_for_min_parameter;
        evaluate( param_in.max_value ) => float value_for_max_parameter;
        
        Math.min( value_for_min_parameter, value_for_max_parameter ) => param_out.min_value;
        Math.max( value_for_min_parameter, value_for_max_parameter ) => param_out.max_value;
    }
    
    fun void update_parameters()
    {
        <<< "update_parameters( ... ) - from Abstract class" >>>;
    }
}

// ---------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
// ---------------------------------------------------------------------------------------------------------------

/**
*
*/
class Function_Linear extends Abstract_Function
{
    // url: http://en.wikipedia.org/wiki/Linear_function
    // f(x) = a.x + b    
    
    // Parameters of this function
    float a, b;
    
    // Monotonic function => don't need to overload the update_domain_values method
    
    // Implement the evaluate fonction with the definition of f(x)
    fun float evaluate( float _param_in )
    {
        return a*_param_in + b;
    }
}

/**
*
*/
class Function_Gaussian extends Abstract_Function
{
    // url: http://en.wikipedia.org/wiki/Gaussian_function
    // f(x) = a.e(-(x-b)²/(2.c²)) + d
    // - a = 1/(sigma*sqrt(2pi))
    // - b = mu
    // - c = sigma
    
    // Parameters of this function    
    float b, c, d;
    
    0.0 => b;
    1.0 => c;
    0.0 => d;
    
    c*Constants.inv_sqrt_2_pi => float a;
    c * c => float c_pow2;
    
    fun void update_parameters()
    {
        c*Constants.inv_sqrt_2_pi => a;
        c * c => c_pow2;
    }
    
    fun void set_sigma( float _sigma )
    {
        _sigma => c;
        update_parameters();
    }
    
    fun void set_mu( float _mu )
    {
        _mu => b;
    }
    
    fun float evaluate( float _param_in )
    {
        _param_in @=> float x;
        return a * Math.exp( -Math.pow(x-b, 2.0)/(2*c_pow2) ) + d;
    }
}


/**
*
*/
class Domain_Values
{
    0.0 => float min_value;
    1.0 => float max_value;
    
    fun int inside( float _value )
    {
        return Tools.LEQUAL( _value, max_value ) && Tools.GEQUAL( _value, min_value );
    }
}

/**
*
*/
class AABBox_PolarFunction
{
    // how many do we use to compute the AABBox of thie polar function ?
    2048 => int nb_samples;
    
    Point2D min_position;
    Point2D max_position;
    
    // Pre-constructor
    min_position.set( Constants.MAX_FLOAT, Constants.MAX_FLOAT );     
    max_position.set( Constants.MIN_FLOAT, Constants.MIN_FLOAT );
    
    fun void updateMin( Point2D _pos )
    {
        min_position.set( min_position.minXY( _pos ) );
    }
    
    fun void updateMax( Point2D _pos )
    {
        max_position.set( max_position.maxXY( _pos ) );
    }
    //    
    fun void compute( Abstract_PolarFunction @ _polar_function, int _nb_samples )
    {
        0.0 => float theta;
        
        Constants.two_pi / _nb_samples => float inc_theta;
        
        //Point2D position;
        
        for( 0 => int id_sample; id_sample < _nb_samples; id_sample++ )
        {
            // Evaluate the polar function            
            _polar_function.getPosition( theta ) @=> Point2D @ position;
            
            // Update the min/max
            updateMin( position );
            updateMax( position );
            
            // next sample => next theta
            inc_theta +=> theta;
        }
    }
    // Overload
    fun void compute( Abstract_PolarFunction @ _polar_function )
    {
        compute( _polar_function, nb_samples );
    }
    
    fun Point2D getCenter()
    {
        return Point2D.center( min_position, max_position );
    }
}

// url: http://www.wolframalpha.com/input/?i=graph+16*%28sin+t%29^3%2C+13*cos%28t%29+-+5*cos%282*t%29+-+2*cos%283*t%29+-+cos%284*t%29%2C+t%3D0..2pi
/**
*
*/
class Heart_06_PolarFunction extends Abstract_PolarFunction
{
    fun float computeX( float _theta, float _sin_theta )
    {
        return 16.00 * _sin_theta * _sin_theta * _sin_theta;
    }    
    
    fun float computeX( float _theta ) 
    {         
        return computeX( _theta, Math.sin(_theta) );
    }       
    
    fun float computeY( float _theta )
    {
        return 13*Math.cos(_theta) - 5*Math.cos(2*_theta) - 2*Math.cos(3*_theta) - Math.cos(4*_theta);
    }

    fun Point2D @ getPosition( float _theta )
    {
        // update position
        this.position.set( computeX(_theta), computeY(_theta) );
        return this.position;
    }
    
    // overload the function
    // default: return the length between origin (O) and the position evaluate for _theta
    fun float getValue( float _theta ) 
    {
        return getLength( _theta );
    }
    
    fun float getLength( float _theta )
    {
        // update position and return the distance from the center (0, 0)
        return getPosition( _theta ).length();
    }
    
    fun float getAngle( float _theta )
    {
        // update position and return the angle between (1, 0) and (O, PF(theta)) (PF: Polar Function)
        return getPosition( _theta ).angle();
    }
}

/**
*
*/
class Projector_On_Unit_Circle extends Abstract_Projector_PolarFunction
{
    fun float project_value( float _theta, Abstract_PolarFunction @ _polar_function, Point2D @ _center_of_projection )
    {
        //
        _polar_function.getPosition(_theta) @=> Point2D pf_position;
        //
        pf_position.sub(_center_of_projection);
        //
        return pf_position.angle();
    }
    
    fun Point2D @ project_position( float _theta, Abstract_PolarFunction @ _polar_function, Point2D @ _center_of_projection )
    {
        //
        project_value( _theta, _polar_function, _center_of_projection ) => float angle;
        
        // Project the angle on unit circle and retrieve a new position        
        Math.cos(angle) => position.x;
        Math.sin(angle) => position.y;
        
        // return the position computed
        return position;
    }
}

// ---------------------------------------------------------------------------------------------------------------
// TESTS
// ---------------------------------------------------------------------------------------------------------------
/**
*
*/
fun void test_Evaluate_diff( 
    Abstract_PolarFunction @ func_heart_06, 
    AABBox_PolarFunction @ aabbox_heart_06, 
    Abstract_Projector_PolarFunction @ projector 
)
{
    // theta: angular parameter
    pi/4.0 => float theta;
    128 => int nb_samples;
    0 => float start_theta;
    2*pi => float end_theta;
    (end_theta - start_theta) / nb_samples => float inc_theta;
    //
    for(0 => int i; i<nb_samples; i++)
    {
        // value: polar function heart 06 evaluate for theta, retrieve the angle of the position
        func_heart_06.getAngle( theta ) => float value_angle;
        // project_value: polar projection on unit circle for theta parameter
        projector.project_value( theta, func_heart_06, aabbox_heart_06 ) => float project_value_angle;
        Tools.Minimal_Distance_For_2_Angles(value_angle, project_value_angle) => float diff;
        
        // OUTPUTs program
        <<< "theta: ", theta >>>;
        //<<< "func_heart_06.getAngle( theta ): ", value_angle >>>;
        //<<< "projector.project_value( theta, ... ):", project_value_angle >>>;
        <<< "angular difference: ", diff >>>;

        inc_theta +=> theta;
    }
}

// ---------------------------------------------------------------------------------------------------------------
// MAIN
// ---------------------------------------------------------------------------------------------------------------
// Instante a new object Heart_06_PolarFunction
Heart_06_PolarFunction func_heart_06;

AABBox_PolarFunction aabbox_heart_06;

aabbox_heart_06.compute( func_heart_06, 128 );  // using 128 samples to discretise the polar function
//
<<< "aabbox_heart_06.min: ", aabbox_heart_06.min_position.toString() >>>;
<<< "aabbox_heart_06.max: ", aabbox_heart_06.max_position.toString() >>>;

aabbox_heart_06.compute( func_heart_06 ); // 2048 samples by default
//
<<< "aabbox_heart_06.min: ", aabbox_heart_06.min_position.toString() >>>;
<<< "aabbox_heart_06.max: ", aabbox_heart_06.max_position.toString() >>>;

Projector_On_Unit_Circle projector;

//test_Evaluate_diff( func_heart_06, aabbox_heart_06, projector );
