package
{
	public class Tool
	{
		public static function str_replace(replace_with:String, replace:String, original:String ):String
		{
			var array:Array = original.split(replace_with);
			return array.join(replace);
		}
	}
}