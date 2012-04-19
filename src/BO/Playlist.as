package BO
{
	public class Playlist
	{
		private var _ID_Playlist:int;
		private var _Name:String;
		
		public function Playlist()
		{
			_ID_Playlist = -1;
			_Name = "";
		}
		
		
		public function get Name():String
		{
			return _Name;
		}

		public function set Name(value:String):void
		{
			_Name = value;
		}

		public function get ID_Playlist():int
		{
			return _ID_Playlist;
		}

		public function set ID_Playlist(value:int):void
		{
			_ID_Playlist = value;
		}

	}
}