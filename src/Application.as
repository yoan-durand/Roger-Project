package
{
	public class Application
	{
		private static var constructorKey:Object = {};
		private static var instance:Application = null;
		public var _player:Player;
		
		public function Application(pConstructorKey:Object)
		{
			if(pConstructorKey != constructorKey)
			{
				throw new Error("Instanciation illégale (constructeur privé)");
			}
			_player = new Player;
			init_database ();
		}
		
		public static function get Instance():Application
		{
			if(instance == null)
			{
				instance = new Application(constructorKey);
			}
			return instance;
		}
		
		
		private function init_database ()
		{
			//TODO
		}
	}
}