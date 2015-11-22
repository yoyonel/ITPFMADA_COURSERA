public class FindPath
{
	0 => static int ID_CURRENT_PATH;
	1 => static int ID_AUDIO_PATH;

    fun string convert_string_path_windows_to_linux( string _string_path )
    {
        _string_path => string return_string;
        return_string.find('\\') => int id_as;
        while( id_as != -1 )
        {
            return_string.replace( id_as, "/" );
            return_string.find('\\', id_as) => int id_as;
        }
        return return_string;
    }
    
    fun string findPath( int _mode )
	{
		"" => string return_path;
		if( _mode == ID_CURRENT_PATH )
		{
            me.dir(0) => return_path;
			if( return_path == "")
			{			
				Std.getenv( "CHUCK_CURRENT_PATH" ) => return_path;
			}
		}
		else if ( _mode == ID_AUDIO_PATH )
		{
            me.dir(-1) => return_path;
			if( return_path == "")
			{			
				findPath(ID_CURRENT_PATH) + "/.." => return_path;
			}			
			"/audio" +=> return_path;
		}
		
        convert_string_path_windows_to_linux( return_path ) => return_path;        
		
		return return_path;
	}
}