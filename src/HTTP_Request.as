package
{
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import com.adobe.serializers.json.JSONDecoder;
	
	public class HTTP_Request
	{
		public static var _api_key:String = "api_key=5TTVQT9W99PC1OSRZ";
		public static var _format:String = "format=json";
		public static var _bucket:String = "bucket=id:7digital-US&bucket=audio_summary&bucket=tracks";
		
		public static function request(artist:String, title:String):void
		{
			var http:HTTPService = new HTTPService();
			
			// specify the url to request, the method and result format
			http.url = "http://developer.echonest.com/api/v4/song/search?"+_api_key+"&artist="+artist+"&title="+title+"&"+_format+"&"+_bucket;
			http.method = "GET";
			http.resultFormat = "array";
			
			// call the HTTP Service's send() to invoke the request, a token is returned
			var token:AsyncToken = http.send();
			
			// setup responder (resultHandler and faultHandler functions) and add to token
			var responder:AsyncResponder = new AsyncResponder( resultHandler, faultHandler );
			token.addResponder( responder );
		}
		
		public static function resultHandler(event:ResultEvent, token:Object):String
		{
			if (event.result != null)
			{
				var res:String = event.result[0].toString();
				var decod:JSONDecoder = new JSONDecoder;
				var obj:Object = decod.decode(res);
				try
				{
					var id_echonest:String = obj.response.songs.source[0].id;
					var path_cover:String = obj.response.songs.source[0].tracks[0].release_image;
				}
				catch (e:String)
				{
					return "";
				}
			}
			
			return path_cover != null ? path_cover : "";
		}
		
		public static function faultHandler(event:FaultEvent):void
		{
			event;
		}
	}
}