adc => Gain inGain;

//RoomEffect_With_Delays();

//RoomEffect_JCRev(1.0); // medium complexity
//RoomEffect_PRCRev(1.0); // less complexity
//RoomEffect_NRev(1.0); // higher complexity

//RoomEffect_Chorus( 0.10, 0.5, 0.5 ); // modFreq, modDepth, mix

RoomEffect_PitShift( 0.50, 0.33 ); // shit, mix


fun void RoomEffect_PitShift( float _shift, float _mix )
{
	inGain => PitShift pshift => dac ;
	
	_mix => pshift.mix;
	_shift => pshift.shift;
	
	while( true )
	{
		1::second => now;
	}
}

fun void RoomEffect_Chorus( float _modFreq, float _modDepth, float _mix )
{
	inGain => Chorus chorus => dac ;
	
	_mix => chorus.mix;
	_modFreq => chorus.modFreq;
	_modDepth => chorus.modDepth;
	
	while( true )
	{
		1::second => now;
	}
}

fun void RoomEffect_JCRev( float _mix )
{
	inGain => JCRev rev => dac ;
	_mix => rev.mix;
	
	while( true )
	{
		1::second => now;
	}
}

fun void RoomEffect_PRCRev( float _mix )
{
	inGain => PRCRev rev => dac ;
	_mix => rev.mix;
	
	while( true )
	{
		1::second => now;
	}
}

fun void RoomEffect_NRev( float _mix )
{
	inGain => NRev rev => dac ;
	_mix => rev.mix;
	
	while( true )
	{
		1::second => now;
	}
}
	
fun void RoomEffect_With_Delays()
{
	Delay d[10];

	for(0 => int i; i < d.cap(); i++)
	{
		inGain => d[i];
		60::ms + i*20::ms => d[i].max => d[i].delay; // room effect
		
		d[i] => d[i] => dac; // loop
		
		0.4 => d[i].gain; // feedback gain
	}

	while( true )
	{
		1.0::second => now;
	}
}