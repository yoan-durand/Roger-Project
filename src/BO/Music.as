package BO
{
	public class Music
	{
		private var _ID_Music:int;
		private var _Path:String;
		private var _ID_Echonest:int;
		private var _Album:String;
		private var _Length:int;
		private var _Artist:String;
		private var _Title:String;
		private var _Genre:String;
		
		public function Music()
		{
			_ID_Music = -1;
			_Path = "";
			_ID_Echonest = -1;
			_Album = "";
			_Length = -1;
			_Artist = "";
			_Title = "";
			_Genre = "";
		}
		
		
		public function get Genre():String
		{
			return _Genre;
		}

		public function set Genre(value:String):void
		{
			_Genre = value;
		}

		public function get Title():String
		{
			return _Title;
		}

		public function set Title(value:String):void
		{
			_Title = value;
		}

		public function get Artist():String
		{
			return _Artist;
		}

		public function set Artist(value:String):void
		{
			_Artist = value;
		}

		public function get Length():int
		{
			return _Length;
		}

		public function set Length(value:int):void
		{
			_Length = value;
		}

		public function get Album():String
		{
			return _Album;
		}

		public function set Album(value:String):void
		{
			_Album = value;
		}

		public function get ID_Echonest():int
		{
			return _ID_Echonest;
		}

		public function set ID_Echonest(value:int):void
		{
			_ID_Echonest = value;
		}

		public function get Path():String
		{
			return _Path;
		}

		public function set Path(value:String):void
		{
			_Path = value;
		}

		public function get ID_Music():int
		{
			return _ID_Music;
		}

		public function set ID_Music(value:int):void
		{
			_ID_Music = value;
		}

	}
}