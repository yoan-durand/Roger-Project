package DB
{
	import flash.events.EventDispatcher;
	
	public class Logger extends EventDispatcher
	{
		private var errorMessageList:Array;
		
		public function get LastErrorMessage():String
		{
			return errorMessageList.length > 0 ? errorMessageList[errorMessageList.length-1] : "No error";
		}
		
		public function Logger()
		{
			errorMessageList = new Array();
		}
		
		protected function logError(pErrorMessage:String):void
		{
			errorMessageList.push(pErrorMessage);
			trace(pErrorMessage);
		}
	}
}