package
{
	import DB.Database;
	
	import flash.net.dns.AAAARecord;
	
	import mx.collections.ArrayCollection;
	public class Display
	{
		private var _albumTab:Array;
		private var _artistTab:Array;
		private var _genreTab:Array;
		private var _musicTab:Array;
		private var _playlist:Array;
			
		private var _musicCollection:ArrayCollection;

		private var _genreCollection: ArrayCollection;

		private var _albumCollection:ArrayCollection;
	
		private var _artistCollection:ArrayCollection;
		
		private var _playCollection:ArrayCollection;
		public function Display()
		{
		 	musicTab = new Array();
		    artistTab = new Array();
			albumTab = new Array ();
			genreTab = new Array ();
			playlist = new Array ();
			
			artistTab.push({ArtistBase:"Tout"});
			albumTab.push({AlbumBase:"Tout"});
			genreTab.push({GenreBase:"Tout"});
		}

		public function get playlist():Array
		{
			return _playlist;
		}

		public function set playlist(value:Array):void
		{
			_playlist = value;
		}

		[Bindable]
		public function get playCollection():ArrayCollection
		{
			return _playCollection;
		}

		public function set playCollection(value:ArrayCollection):void
		{
			_playCollection = value;
		}

		[Bindable]
		public function get artistCollection():ArrayCollection
		{
			return _artistCollection;
		}

		
		public function set artistCollection(value:ArrayCollection):void
		{
			_artistCollection = value;
		}
		[Bindable]
		public function get albumCollection():ArrayCollection
		{
			return _albumCollection;
		}
		
		public function set albumCollection(value:ArrayCollection):void
		{
			_albumCollection = value;
		}
		
		[Bindable]
		public function get genreCollection():ArrayCollection
		{
			return _genreCollection;
		}

		public function set genreCollection(value:ArrayCollection):void
		{
			_genreCollection = value;
		}

		[Bindable]
		public function get musicCollection():ArrayCollection
		{
			return _musicCollection;
		}

		public function set musicCollection(value:ArrayCollection):void
		{
			_musicCollection = value;
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

		public function search(array:Array, elt:String) : Boolean
		{
			for (var i:int = 0; i < array.length; i++)
			{
				if (array[i].TitleField === elt)
				{
					return true;
				}
				
				if (array[i].ArtistBase === elt)
				{
					return true;
				}
				
				if (array[i].AlbumBase === elt)
				{
					return true;
				}
				
				if (array[i].GenreBase === elt)
				{
					return true;
				}
				
			}
			return false;
		}
		
		public function search_m(array:Array, elt:*) : Boolean
		{
			for (var i:int = 0; i < array.length; i++)
			{
				if ((array[i].TitleField === elt.Title) && (array[i].ArtistField === elt.Artist) && (array[i].AlbumField === elt.Album))
				{
						return true;
				}
			}
			return false;
		}
		
		public function fill_playlist (list:Array) : void
		{
			if (list != null)
			{
				for each (var play:* in list)
				{
					playlist.push({PlaylistField:play.Name, id:play.ID_Playlist});
				}
			}
			playCollection = new ArrayCollection (playlist);
		}
		public function fill_tab(tab_m:Array) : void
		{		
			if (tab_m != null)
			{
				for each (var t:* in tab_m)
				{
					if (search_m(musicTab, t) == false)
					{
						musicTab.push ({TitleField:t.Title, ArtistField:t.Artist, AlbumField:t.Album, GenreField:t.Genre, LengthField:Tool.lengthtoString(t.Length),
							Path:t.Path, ID:t.ID_Music, Path_cover:t.Path_Cover});
					}			
					if (search(artistTab, t.Artist) == false)
					{
						artistTab.push({ArtistBase:t.Artist});
					}
					if (search(genreTab, t.Genre) == false)
					{
						genreTab.push({GenreBase:t.Genre});
					}
					if (search(albumTab, t.Album) == false)
					{
						albumTab.push({AlbumBase:t.Album});
					}
				}	
			}
			
			musicCollection = new ArrayCollection (_musicTab);
			artistCollection = new ArrayCollection (_artistTab);
			albumCollection = new ArrayCollection (_albumTab);
			genreCollection = new ArrayCollection (_genreTab);
		
		}
	
		public function update (tab_m:Array) : void
		{
			if (tab_m != null)
			{
				for each (var t:* in tab_m)
				{
					if (search(musicTab, t) == false)
					{
						musicTab.push ({TitleField:t.Title, ArtistField:t.Artist, AlbumField:t.Album, GenreField:t.Genre, LengthField:Tool.lengthtoString(t.Length),
							Path:t.Path, ID:t.ID_Music, Path_cover:t.Path_Cover});
					}
					if (search(artistTab, t.Artist) == false)
					{
						artistTab.push({ArtistBase:t.Artist});
					}
					if (search(genreTab, t.Genre) == false)
					{
						genreTab.push({GenreBase:t.Genre});
					}
					if (search(albumTab, t.Album) == false)
					{
						albumTab.push({AlbumBase:t.Album});
					}
				}
				
				
			}
			
			musicCollection = new ArrayCollection (_musicTab);
			artistCollection = new ArrayCollection (_artistTab);
			albumCollection = new ArrayCollection (_albumTab);
			genreCollection = new ArrayCollection (_genreTab);
		}
		
	}
}