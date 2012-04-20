package
{
	import BO.Music;
	
	import DB.Database;
	
	import flash.data.SQLResult;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	import mx.events.FileEvent;
	
	public class Filesearch extends EventDispatcher
	{
		private var fileType : Array;
		private var _queue : Array; //File FIFO
		
		private function isValidType (type : String) : Boolean
		{
			if (type == "mp3")
			{
				return true;
			}
			return false;
		}
		
		protected function loadingfilesHandler (event:Event) : void
		{
			var head:File = event.target as File;
			search(head);
		}
		
		public function Filesearch()
		{
			var head : File = new File ();
			_queue = new Array();
			head.browseForDirectory("Choose a Directory");
			head.addEventListener(Event.SELECT, loadingfilesHandler);
		}
		
		public function search (root : File) : void
		{
			if (root.isDirectory)
			{
				root.addEventListener (FileListEvent.DIRECTORY_LISTING, _directoryListingHandler);
				root.addEventListener (ErrorEvent.ERROR, _ioErrorHandler);
				root.getDirectoryListingAsync();
			}
			else
			{
				if (this.isValidType(root.extension))
				{
					//dispatchEvent (new FileSearchEvent (root));
					parse_mp3 (root.nativePath);
				}
			}
		}
		
		protected function _directoryListingHandler (event : FileListEvent) :void
		{
			event.target.removeEventListener (FileListEvent.DIRECTORY_LISTING, _directoryListingHandler);
			for each (var f : File in event.files)
			{
				//on enfile les dossier dans _queue
				_queue.push(f);
			}
			while (_queue.length != 0)
			{
				search (_queue.shift());
			}
		}
		
		protected function _ioErrorHandler (event : ErrorEvent):void
		{
			
		}
		
		private function parse_mp3 (path : String):void
		{
			var soundLoaderContext:SoundLoaderContext = new SoundLoaderContext();
			soundLoaderContext.checkPolicyFile = true;
			
			var mp3:URLRequest = new URLRequest(path);
			
			var sound:Sound = new Sound();
			sound.addEventListener(Event.ID3, id3Handler);
			sound.load(mp3, soundLoaderContext);
			
			// ID3 events
			function id3Handler(event:Event):void {
				var id3:ID3Info = event.target.id3;
				var artist:String = id3.artist;
				var title:String = id3.songName;
				var album:String = id3.album;
				var genre:String = id3.genre;
				var snd:Sound = event.target as Sound;
				var length:int = snd.length ;
				
				var music:Music = new Music();
				music.Title = title;
				music.Album = album;
				music.Artist = artist;
				music.Genre = genre;
				music.Length = length;
				music.Path = snd.url;
				trace(music.Path);
				snd.close();
				
				var dbname:String = "airmusic.db";
				
				var music_table:String = "CREATE TABLE IF NOT EXISTS Music (";
				music_table += "ID_Music INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ";
				music_table += "Path NVARCHAR(255) UNIQUE NOT NULL, ";
				music_table += "ID_Echonest INTEGER UNIQUE NULL, ";
				music_table += "Album NVARCHAR(255) NULL, ";
				music_table += "Artist NVARCHAR(255) NULL, ";
				music_table += "Length INTEGER NULL, ";
				music_table += "Title NVARCHAR(255) NOT NULL, ";
				music_table += "Genre NVARCHAR(255) NULL ";
				music_table += ")";
				
				var insert_music:String = "INSERT INTO Music (Path, Album, Artist, Length, Title, Genre) VALUES ('"+music.Path+"', '"+music.Album+"', '"+music.Artist+"', '"+music.Length+"', '"+music.Title+"', '"+music.Genre+"')";
				
				Database.exec_query(dbname, music_table, insert_music);
				
				var playlist_table:String = "CREATE TABLE IF NOT EXISTS Playlist (";
				playlist_table += "ID_Playlist INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ";
				playlist_table += "Name NVARCHAR(255) UNIQUE NOT NULL ";
				playlist_table += ")";
				
				Database.exec_query(dbname, playlist_table, null);
				
				var in_playlist_table:String = "CREATE TABLE IF NOT EXISTS In_Playlist (";
				in_playlist_table += "ID_Music INTEGER NOT NULL, ";
				in_playlist_table += "ID_Playlist INTEGER NOT NULL, ";
				in_playlist_table += "PRIMARY KEY(ID_Music, ID_Playlist), ";
				in_playlist_table += "FOREIGN KEY(ID_Music) REFERENCES Music(ID_Music), ";
				in_playlist_table += "FOREIGN KEY(ID_Playlist) REFERENCES Playlist(ID_Playlist) ";
				in_playlist_table += ")";
				
				Database.exec_query(dbname, in_playlist_table, null);
				
				var list:SQLResult = Database.list_query(dbname, "SELECT * FROM Music");
			}
		}
	}
	
	
}