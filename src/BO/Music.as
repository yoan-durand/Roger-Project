package BO
{
	import DB.Database;
	
	import com.adobe.serializers.json.JSONDecoder;
	
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class Music
	{
		private var _ID_Music:int;
		private var _Path:String;
		private var _ID_Echonest:String;
		private var _Album:String;
		private var _Length:int;
		private var _Artist:String;
		private var _Title:String;
		private var _Genre:String;
		private var _Path_Cover:String;
		
		public function Music()
		{
			this.ID_Music = -1;
			this.Path = "";
			this.ID_Echonest = "";
			this.Album = "";
			this.Length = 0;
			this.Artist = "";
			this.Title = "";
			this.Genre = "";
			this.Path_Cover = "";
		}

		public function request():void
		{
			var http:HTTPService = new HTTPService();
			
			// specify the url to request, the method and result format
			http.url = "http://developer.echonest.com/api/v4/song/search?api_key=5TTVQT9W99PC1OSRZ&artist="+this.Artist+"&title="+this.Title+"&format=json&bucket=id:7digital-US&bucket=audio_summary&bucket=tracks";
			http.method = "GET";
			http.resultFormat = "array";
			
			// call the HTTP Service's send() to invoke the request, a token is returned
			var token:AsyncToken = http.send();
			
			// setup responder (resultHandler and faultHandler functions) and add to token
			var responder:AsyncResponder = new AsyncResponder(this.resultHandler, this.faultHandler );
			token.addResponder( responder );
		}
		
		public function resultHandler(event:ResultEvent, token:Object):void
		{
			if (event.result != null)
			{
				var res:String = event.result[0].toString();
				var decod:JSONDecoder = new JSONDecoder;
				var obj:Object = decod.decode(res);
				try
				{
					for (var i:int = 0; i < obj.response.songs.source.length; i++)
					{
						if (obj.response.songs.source[i].tracks != null)
						{
							for (var j:int = 0; j < obj.response.songs.source[i].tracks.length; j++)
							{
								if (obj.response.songs.source[i].tracks[j].release_image != null)
								{
									this.ID_Echonest = obj.response.songs.source[i].id;
									this.Path_Cover = obj.response.songs.source[i].tracks[j].release_image;
								}
							}
						}
					}
					//this.Path_Cover = obj.response.songs.source[0].tracks != null ? obj.response.songs.source[0].tracks[0].release_image : "";
					var update_music:String = "UPDATE Music SET Path_Cover = '"+Tool.str_replace("'", "''", this.Path_Cover)+"', ID_Echonest = '"+this.ID_Echonest+"' WHERE ID_Music = "+this.ID_Music;
					Database.exec_query(null, update_music);
				}
				catch (e:String)
				{
				}
			}
		}
		
		public function faultHandler(event:FaultEvent):void
		{
			event;
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
		
		public function get Path_Cover():String
		{
			return _Path_Cover;
		}
		
		public function set Path_Cover(value:String):void
		{
			_Path_Cover = value;
		}

		public function get Album():String
		{
			return _Album;
		}

		public function set Album(value:String):void
		{
			_Album = value;
		}

		public function get ID_Echonest():String
		{
			return _ID_Echonest;
		}

		public function set ID_Echonest(value:String):void
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