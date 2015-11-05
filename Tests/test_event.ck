// extended event
class TheEvent extends Event
{
    int value;
}
// the event
TheEvent e;

// handler
fun int hi( TheEvent event )
{
    while( true )
    {
        // wait on event
        event => now;
        // get the data
        <<<e.value>>>;
    }
}

// spork
// build a list of (custom) events
spork ~ hi( e );
spork ~ hi( e );
spork ~ hi( e );
spork ~ hi( e );

// infinite time loop
while( true )
{
    // advance time
    1::second => now;
    // set data
    Std.rand2( 0, 5 ) $ int => e.value;
    // signal one waiting shred
    e.signal();
}