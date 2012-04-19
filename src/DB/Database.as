package DB
{
	import flash.filesystem.File;
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	
	public class Database extends Logger
	{
		private static var constructorKey:Object = {};
		private static var instance:Database = null;
		
		private var databaseFile:File;
		
		public function Database(pConstructorKey:Object)
		{
			if(pConstructorKey != constructorKey)
			{
				throw new Error("Instanciation illégale (constructeur privé)");
			}
			
			databaseFile = File.applicationStorageDirectory.resolvePath("database.sqlite");
		}
		
		public static function get Instance():Database
		{
			if(instance == null)
			{
				instance = new Database(constructorKey);
			}
			return instance;
		}
		
		private function executeQuery(pMode:SQLMode, pQuery:String):SQLResult
		{
			try
			{
				var Connection:SQLConnection = new SQLConnection();
				var Statement:SQLStatement = new SQLStatement();
				
				Connection.open(databaseFile, pMode);
				
				Statement.sqlConnection = Connection;
				
				Statement.text = pQuery;
				Statement.execute();
				
				return Statement.getResult();
			}
			catch(error:SQLError)
			{
				this.logError("Requête : <" + pQuery + ">\n" + error.toString());
			}
			finally
			{
				Connection.close();
			}
			return null;
		}
		
		public function createDatabase():Boolean
		{
			if(databaseFile.exists)
			{
				return true;
			}
			
			var sQuery:String = "CREATE TABLE In_Playlist (";
			sQuery += "ID_Music INTEGER NOT NULL, ";
			sQuery += "ID_Playlist INTEGER NOT NULL, ";
			sQuery += "PRIMARY KEY(ID_Music, ID_Playlist), ";
			sQuery += "FOREIGN KEY(ID_Music) REFERENCES Music(ID_Music), ";
			sQuery += "FOREIGN KEY(ID_Playlist) REFERENCES Playlist(ID_Playlist) ";
			sQuery += "); ";
			
			sQuery += "CREATE TABLE Music (";
			sQuery += "ID_Music INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ";
			sQuery += "Path NVARCHAR(255) UNIQUE NOT NULL, ";
			sQuery += "ID_Echonest INTEGER UNIQUE NULL, ";
			sQuery += "Album NVARCHAR(255) NULL, ";
			sQuery += "Artist NVARCHAR(255) NULL, ";
			sQuery += "Length INTEGER NULL, ";
			sQuery += "Title NVARCHAR(255) NOT NULL, ";
			sQuery += "Genre NVARCHAR(255) NULL ";
			sQuery += "); ";
			
			sQuery += "CREATE TABLE Playlist (";
			sQuery += "ID_Playlist INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ";
			sQuery += "Name NVARCHAR(255) UNIQUE NOT NULL ";
			sQuery += "); ";
			
			var result:SQLResult = this.executeQuery(SQLMode.CREATE, sQuery);
			
			return result != null;
		}
	}
}