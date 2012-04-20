package
{
	public class Application
	{
		private static var constructorKey:Object = {};
		private static var instance:Application = null;
		public var player:Player;
		
		public function Application(pConstructorKey:Object)
		{
			if(pConstructorKey != constructorKey)
			{
				throw new Error("Instanciation illégale (constructeur privé)");
			}
			
			player = new Player;				
		}
		
		public static function get Instance():Application
		{
			if(instance == null)
			{
				instance = new Application(constructorKey);
			}
			return instance;
		}
	}
}