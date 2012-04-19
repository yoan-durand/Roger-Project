package DB
{
	import BO.Music;
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.filesystem.File;
	
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
		
		private function executeQuery(pMode:String, pQuery:String, pParameters:Object = null, pClass:Class=null):SQLResult
		{
			try
			{
				var Connection:SQLConnection = new SQLConnection();
				var Statement:SQLStatement = new SQLStatement();
				Connection.open(databaseFile, pMode);
				
				Statement.sqlConnection = Connection;
				
				Statement.text = pQuery;
				
				if(pParameters != null)
				{
					for(var id:String in pParameters)
					{
						Statement.parameters[id] = pParameters[id];
					}
				}
				if(pClass != null)
				{
					Statement.itemClass = pClass;
				}
				
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
		
		public function insertMusic(pMusic:BO.Music):Boolean
		{
			var sQuery:String = "INSERT INTO Music (Path, ID_Echonest, Album, Artist, Length, Title, Genre) VALUES (@Path, @ID_Echonest, @Album, @Artist, @Length, @Title, @Genre)";
			var params:Object = {"@Path" : pMusic.Path, "@ID_Echonest" : pMusic.ID_Echonest, "@Album" : pMusic.Album, "@Artist" : pMusic.Artist, "@Length" : pMusic.Length, "@Title" : pMusic.Title, "@Genre" : pMusic.Genre};
			
			var result:SQLResult = this.executeQuery(SQLMode.UPDATE, sQuery, params);
			
			if(result != null)
			{
				pMusic.ID_Music = result.lastInsertRowID;
				return true;
			}
			
			return false;
		}
		
		public function getMusicList():Array
		{
			var result:SQLResult = this.executeQuery(SQLMode.READ, "SELECT * FROM Music", null, BO.Music);
			
			if(result != null)
			{
				return result.data == null ? new Array() : result.data;
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