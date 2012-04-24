package
{
	
	import flash.media.Sound;
	
	public class Tool
	{
		public static function str_replace(replace_with:String, replace:String, original:String ):String
		{
			var array:Array = original.split(replace_with);
			return array.join(replace);
		}
		
		public static function lengthtoString(time:int):String
		{
			var min:String, sec:String;
			sec = Math.round((time%60000)/1000) < 10 ? "0"+(Math.round((time%60000)/1000).toString()) : Math.round((time%60000)/1000).toString();
			min = time/60000 < 10 ? "0"+((Math.ceil(time/60000)-1).toString()) : (Math.ceil(time/60000)-1).toString();
			return (min+":"+sec);
		}
		
		public static function getTimefromPercentage(position:Number, sound:Sound):int
		{
			var estimatedLength:int =  
				Math.ceil(sound.length / (sound.bytesLoaded / sound.bytesTotal));
			var time:int = ((position * estimatedLength) / 100);
			return time;
		}
	}
}