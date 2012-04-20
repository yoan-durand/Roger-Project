package DB
{
	import BO.Music;
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	
	public class Database
	{

		public static function createTable(dbName:String, dbtbstmt:String, dbinsert:String):void
		{
			var sqlconn:SQLConnection = new SQLConnection;
			var tbcreate:SQLStatement = new SQLStatement;
			var insertst:SQLStatement = new SQLStatement;
			
			var folder:File = File.applicationDirectory;
			var dbPath:File = folder.resolvePath(dbName);
			
			sqlconn.addEventListener(SQLEvent.OPEN, dbCreated);
			sqlconn.addEventListener(SQLErrorEvent.ERROR, dbError);
			tbcreate.addEventListener(SQLEvent.RESULT, tbCreated);
			tbcreate.addEventListener(SQLErrorEvent.ERROR, tbError);
			insertst.addEventListener(SQLEvent.RESULT, recCreated);
			insertst.addEventListener(SQLErrorEvent.ERROR, recError);
			
			sqlconn.open(dbPath);
			
			if (dbtbstmt != null)
			{	
				tbcreate.sqlConnection = sqlconn;
				tbcreate.text = dbtbstmt;
				
				tbcreate.execute();
			}
			
			if (dbinsert != null)
			{
				insertst.sqlConnection = sqlconn;
				insertst.text = dbinsert;
			
				insertst.execute();
			}
			
			var sQuery:String = "CREATE TABLE In_Playlist (";
			sQuery += "ID_Music INTEGER NOT NULL, ";
			sQuery += "ID_Playlist INTEGER NOT NULL, ";
			sQuery += "PRIMARY KEY(ID_Music, ID_Playlist), ";
			sQuery += "FOREIGN KEY(ID_Music) REFERENCES Music(ID_Music), ";
			sQuery += "FOREIGN KEY(ID_Playlist) REFERENCES Playlist(ID_Playlist) ";
			sQuery += "); ";
			
			sQuery += "CREATE TABLE Playlist (";
			sQuery += "ID_Playlist INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ";
			sQuery += "Name NVARCHAR(255) UNIQUE NOT NULL ";
			sQuery += "); ";
		}
		
		private static function dbCreated(event:SQLEvent):void
		{
			trace("Database Created");
		}
		
		private static function dbError(event:SQLErrorEvent):void
		{
			trace("Error message : ", event.error.message);
			trace("Details : ", event.error.details);
		}
		
		private static function tbCreated(event:SQLEvent):void
		{
			trace("Table Created");
		}
		
		private static function tbError(event:SQLErrorEvent):void
		{
			trace("Error message : ", event.error.message);
			trace("Details : ", event.error.details);
		}
		
		private static function recCreated(event:SQLEvent):void
		{
			trace("Record Created");
		}
		
		private static function recError(event:SQLErrorEvent):void
		{
			trace("Error message : ", event.error.message);
			trace("Details : ", event.error.details);
		}
	}
}