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
			addEventListener("search_file", shift_and_search);
			head.browseForDirectory("Choisir un dossier");
			head.addEventListener(Event.SELECT, loadingfilesHandler);
		}
		
		private function shift_and_search (event:Event):void
		{
			if (_queue.length != 0)
			{
				search (_queue.shift());
			}
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
				dispatchEvent (new Event("search_file"));
				if (this.isValidType(root.extension))
				{
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
			if (_queue.length != 0)
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
			sound.addEventListener(Event.COMPLETE, test_loading);
			sound.load(mp3, soundLoaderContext);
			
			
			function test_loading(event:Event):void
			{
				var snd:Sound = event.target as Sound;
				
				var id3:ID3Info = snd.id3;
				var music:Music = new Music();
				music.Artist = id3.artist != null ? id3.artist : "Inconnu";
				music.Title = id3.songName != null ? id3.songName : "Inconnu";
				music.Album = id3.album != null ? id3.album : "Inconnu";
				music.Genre = id3.genre != null ? Tool.getGenre(id3.genre) : "Inconnu";

				var estimatedLength:int =  
					Math.ceil(snd.length / (snd.bytesLoaded / snd.bytesTotal));
				music.Length = estimatedLength;
				music.Path = snd.url != null ? snd.url : "";
				snd.close();
				
				var insert_music:String = "INSERT INTO Music (Path, Album, Artist, Length, Title, Genre) VALUES ('"+Tool.str_replace("'", "''", music.Path)+"', '"+Tool.str_replace("'", "''", music.Album)+"', '"+Tool.str_replace("'", "''", music.Artist)+"', '"+music.Length+"', '"+Tool.str_replace("'", "''", music.Title)+"', '"+Tool.str_replace("'", "''", music.Genre)+"')";
				var query_result:SQLResult = Database.exec_query(null, insert_music);
				if (query_result != null)
				{
					music.ID_Music = query_result.lastInsertRowID;
					music.request();
				}
				snd.id3
			}
			
			// ID3 events
			function id3Handler(event:Event):void {
				
			}
			
		}
	}
	
	
}