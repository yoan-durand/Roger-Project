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
		
		public static function getGenre(genre:String):String
		{
			var Genres:Object = {
				"(0)" : "Blues", "(1)" : "Classic rock", "(2)" : "Country", "(3)" : "Dance", "(4)" : "Disco", "(5)" : "Funk",  "(6)" : "Grunge", "(7)" : "Hip-Hop", "(8)" : "Jazz", "(9)" : "Metal",
				"(10)" : "New Age", "(11)" : "Oldies", "(12)" : "Autre", "(13)" : "Pop", "(14)" : "R'n'B", "(15)" : "Rap",  "(16)" : "Reggae", "(17)" : "Rock", "(18)" : "Techno", "(19)" : "Musique industrielle",
				"(20)" : "Rock alternatif", "(21)" : "Ska", "(22)" : "Death metal", "(23)" : "Pranks", "(24)" : "Musique de film", "(25)" : "Euro-Techno",  "(26)" : "Ambient", "(27)" : "Trip-hop", "(28)" : "Musique vocale", "(29)" : "Jazz-Funk",
				"(30)" : "Fusion", "(31)" : "Trance", "(32)" : "Musique classique", "(33)" : "Instrumental", "(34)" : "Acid", "(35)" : "House",  "(36)" : "Musique de jeu vidéo", "(37)" : "Extrait sonore", "(38)" : "Gospel", "(39)" : "Musique bruitiste",
				"(40)" : "Rock alternatif", "(41)" : "Bass", "(42)" : "Soul", "(43)" : "Punk", "(44)" : "Space", "(45)" : "Musique de médiation",  "(46)" : "Pop instrumental", "(47)" : "Rock instrumental", "(48)" : "Musique ethnique", "(49)" : "Gothique",
				"(50)" : "Darkwave", "(51)" : "Techno-Industrial", "(52)" : "Musique électronique", "(53)" : "Pop-Folk", "(54)" : "Eurodance", "(55)" : "Dream",  "(56)" : "Rock sudiste", "(57)" : "Comédie", "(58)" : "Morceau Culte", "(59)" : "Gangsta",
				"(60)" : "Hit-parade", "(61)" : "Rap chrétien", "(62)" : "Pop/Funk", "(63)" : "Jungle", "(64)" : "Musique amérindienne", "(65)" : "Cabaret",  "(66)" : "New wave", "(67)" : "Psychédélique", "(68)" : "Rave", "(69)" : "Comédie musicale",
				"(70)" : "Bande-annonce", "(71)" : "Lo-fi", "(72)" : "Musique tribale", "(73)" : "Acid Punk", "(74)" : "Acid Jazz", "(75)" : "Polka",  "(76)" : "Rétro", "(77)" : "Théâtre", "(78)" : "Rock & Roll", "(79)" : "Hard Rock",
				"(80)" : "Folk", "(81)" : "Folk rock", "(82)" : "Folk américain", "(83)" : "Swing", "(84)" : "Fast Fusion", "(85)" : "Bebop",  "(86)" : "Musique latine", "(87)" : "Revival", "(88)" : "Musique celtique", "(89)" : "Bluegrass",
				"(90)" : "Avantgarde", "(91)" : "Gothic Rock", "(92)" : "Rock progressif", "(93)" : "Rock psychédélique", "(94)" : "Rock symphonique", "(95)" : "Slow Rock",  "(96)" : "Big Band", "(97)" : "Choeur", "(98)" : "Easy listening", "(99)" : "Acoustique",
				"(100)" : "Humour", "(101)" : "Discours", "(102)" : "Chanson", "(103)" : "Opéra", "(104)" : "Musique de chambre", "(105)" : "Sonate",  "(106)" : "Symphonie", "(107)" : "Booty Bass", "(108)" : "Primus", "(109)" : "Porn groove",
				"(110)" : "Satire", "(111)" : "R'n'B contemporain", "(112)" : "Club", "(113)" : "Tango", "(114)" : "Samba", "(115)" : "Folklore",  "(116)" : "Ballade", "(117)" : "Power ballad", "(118)" : "Rythmic soul", "(119)" : "Freestyle",
				"(120)" : "Duo", "(121)" : "Punk rock", "(122)" : "Drum Solo", "(123)" : "A cappella", "(124)" : "Euro-house", "(125)" : "Dancehall",  "(126)" : "Goa", "(127)" : "Drum and bass", "(128)" : "Club House", "(129)" : "Hardcore",
				"(130)" : "Terror", "(131)" : "Indie", "(132)" : "BritPop", "(133)" : "Negerpunk", "(134)" : "Polsk Punk", "(135)" : "Beat",  "(136)" : "Gangsta rap chrétien", "(137)" : "Heavy metal", "(138)" : "Black metal", "(139)" : "Crossover",
				"(140)" : "Musique chrétienne contemporaine", "(141)" : "Rock chrétien", "(142)" : "Merengue", "(143)" : "Salsa", "(144)" : "Thrash metal", "(145)" : "Anime",  "(146)" : "JPop", "(147)" : "Synthpop"
			};
			return Genres[genre] != null ? Genres[genre] : genre;
		}
	}
}