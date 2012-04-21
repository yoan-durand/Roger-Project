package
{
	import DB.Database;
	
	public class Application
	{
		private static var constructorKey:Object = {};
		private static var instance:Application = null;
		public var _player:Player;
		private var _list_music:Array;
		private var _display:Display;
		private var _list_playlist:Array;
		
		public function Application(pConstructorKey:Object)
		{
			if(pConstructorKey != constructorKey)
			{
				throw new Error("Instanciation illégale (constructeur privé)");
			}
			_player = new Player;
			init_database ();
			display = new Display;
		}
		
		public function get display():Display
		{
			return _display;
		}

		public function set display(value:Display):void
		{
			_display = value;
		}

		public function get list_playlist():Array
		{
			return _list_playlist;
		}

		public function set list_playlist(value:Array):void
		{
			_list_playlist = value;
		}

		public function get list_music():Array
		{
			return _list_music;
		}

		public function set list_music(value:Array):void
		{
			_list_music = value;
		}

		public static function get Instance():Application
		{
			if(instance == null)
			{
				instance = new Application(constructorKey);
			}
			return instance;
		}
		
		
		private function init_database ():void
		{
			var music_table:String = "CREATE TABLE IF NOT EXISTS Music (";
			music_table += "ID_Music INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ";
			music_table += "Path NVARCHAR(255) UNIQUE NOT NULL, ";
			music_table += "ID_Echonest INTEGER UNIQUE NULL, ";
			music_table += "Album NVARCHAR(255) NULL, ";
			music_table += "Artist NVARCHAR(255) NULL, ";
			music_table += "Length INTEGER NULL, ";
			music_table += "Title NVARCHAR(255) NULL, ";
			music_table += "Genre NVARCHAR(255) NULL ";
			music_table += ")";
			
			Database.exec_query(music_table, null);
			
			var playlist_table:String = "CREATE TABLE IF NOT EXISTS Playlist (";
			playlist_table += "ID_Playlist INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ";
			playlist_table += "Name NVARCHAR(255) UNIQUE NOT NULL ";
			playlist_table += ")";
			
			Database.exec_query(playlist_table, null);
			
			var in_playlist_table:String = "CREATE TABLE IF NOT EXISTS In_Playlist (";
			in_playlist_table += "ID_Music INTEGER NOT NULL, ";
			in_playlist_table += "ID_Playlist INTEGER NOT NULL, ";
			in_playlist_table += "PRIMARY KEY(ID_Music, ID_Playlist), ";
			in_playlist_table += "FOREIGN KEY(ID_Music) REFERENCES Music(ID_Music), ";
			in_playlist_table += "FOREIGN KEY(ID_Playlist) REFERENCES Playlist(ID_Playlist) ";
			in_playlist_table += ")";
			
			Database.exec_query(in_playlist_table, null);
			
			_list_music = Database.list_query("SELECT * FROM Music");
			var playlists:Array = Database.list_query("SELECT * FROM Playlist");
			if (playlists.length != 0)
			{
				for each (var i:int in playlists) 
				{
					var zic_in_playlist:Array = Database.list_query("SELECT * FROM In_Playlist WHERE ID_Playlist = "+playlists[i].ID_Playlist);
					var playlist:Object = new Object;
					playlist.Name = playlists[i].Name;
					for each (var j:int in zic_in_playlist)
					{
						var zic:Array = Database.list_query("SELECT * FROM Music WHERE ID_Music = "+zic_in_playlist[j].ID_Music);
						
					}
				}
			}
		}
	}
}