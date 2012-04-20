package
{
	import DB.Database;
	
	import flash.net.dns.AAAARecord;

	public class Display
	{
		private var _albumTab:Array;
		private var _artistTab:Array;
		private var _genreTab:Array;
		private var _musicTab:Array;
		
		public function Display()
		{
		 	musicTab = new Array();
		    artistTab = new Array();
			albumTab = new Array ();
			genreTab = new Array ();
			
		}

		public function get musicTab():Array
		{
			return _musicTab;
		}

		public function set musicTab(value:Array):void
		{
			_musicTab = value;
		}

		public function get artistTab():Array
		{
			return _artistTab;
		}

		public function set artistTab(value:Array):void
		{
			_artistTab = value;
		}

		public function get albumTab():Array
		{
			return _albumTab;
		}

		public function set albumTab(value:Array):void
		{
			_albumTab = value;
		}

		public function get genreTab():Array
		{
			return _genreTab;
		}

		public function set genreTab(value:Array):void
		{
			_genreTab = value;
		}

		
		public function fill_tab() : void
		{
			var tab_m:Array = DB.Database.list_query("select * from Music");	
		
			if (tab_m != null)
			{
				for each (var t:* in tab_m)
				{
					musicTab.push ({TitleField:t.Title, ArtistField:t.Artist, AlbumField:t.Album, GenreField:t.Genre, LengthField:t.lenght});
					
					if (artistTab.indexOf(t.Artist) == -1)
						artistTab.push({ArtistBase:t.Artist});
					if (genreTab.indexOf(t.Genre) == -1)
						genreTab.push({GenreBase:t.Genre});
					if (albumTab.indexOf(t.Album) == -1)
						albumTab.push({AlbumBase:t.Album});
				}
			}
		
		}
	}
}