package
{
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
	import BO.Music;
	
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
		
		protected function _ioErrorHandler (event : ErrorEvent)
		{
			
		}
		
		private function parse_mp3 (path : String)
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
				snd.close();
				
				//TODO : Add music to BDD
				
			}
		}
	}
	
	
}