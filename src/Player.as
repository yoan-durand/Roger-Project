package
{
	import BO.Music;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import flashx.textLayout.formats.Float;
	
	import mx.core.FlexGlobals;

	public class Player
	{
		private var _music_list:Array; // liste de Music, correspond a la liste de lecture
		private var _music_sound:Sound;
		public  var _index:int;
		private var _channel:SoundChannel;
		private var _volume_info:SoundTransform; //infos Volume et Pan
		private var positionTimer:Timer;
		
		public function Player ()
		{
			_index = 0;
			_music_list = new Array ();
			_volume_info = new SoundTransform(1, 0);
		}
		
		public function get music_list():Array
		{
			return _music_list;
		}

		public function set music_list(value:Array):void
		{
			_music_list = value;
		}

		private function load_sound():void
		{
			if (_music_list.length != 0)
			{
				var music_data:Music = _music_list[_index];
				var soundLoaderContext:SoundLoaderContext = new SoundLoaderContext();
				soundLoaderContext.checkPolicyFile = true;
				
				var mp3:URLRequest = new URLRequest(music_data.Path);
				var sound:Sound = new Sound();
				sound.load(mp3,soundLoaderContext);
				_music_sound = sound;
				sound.addEventListener(Event.SOUND_COMPLETE, completeHandler);
			}
		}
		
		
		private function positionTimerHandler (event:Event)
		{
		/*	event.target.value;*/
			
			if (_channel != null)
			{
				var estimatedLength:int =  
					Math.ceil(_music_sound.length / (_music_sound.bytesLoaded / _music_sound.bytesTotal)); 
				var playbackPercent:Number =  
					Math.round( 100 * (100 * (_channel.position / estimatedLength))) / 100;
				trace (estimatedLength);
				trace (playbackPercent);
				
				FlexGlobals.topLevelApplication.progressBar.value = playbackPercent;
			}
		}
		private function completeHandler (event:Event):void
		{
			trace("Music end");
		}
		
		public function test():void
		{
			var mymusic:Music = new Music ();
			mymusic.Path = "file:///C:/Users/Vince/Music/Almost king/ALMOST KINGS-Goin Big.mp3";
			_music_list.push(mymusic);
			var mymusic2:Music = new Music ();
			mymusic2.Path = "file:///C:/Users/Vince/Music/Almost king/ALMOST KINGS-Legend.mp3";
			_music_list.push(mymusic2);
			var mymusic3:Music = new Music ();
			mymusic3.Path = "file:///C:/Users/Vince/Music/Almost king/ALMOST KINGS-Unstoppable.mp3";
			_music_list.push(mymusic3);
			play ();
		}
		
		public function change_position (position:Number):void
		{
			if (_channel != null)
			{
				_channel.stop ();
				if (_music_sound != null)
				{
					var estimatedLength:int =  
						Math.ceil(_music_sound.length / (_music_sound.bytesLoaded / _music_sound.bytesTotal));
					var time:int = ((position * estimatedLength) / 100);
					trace ("TIME" + time);
					_channel = _music_sound.play (time);
					_channel.soundTransform = _volume_info;
				}
			}
		}
		
		public function get_position ():int
		{
			return _channel.position;
		}
		
		public function play ():void
		{
			if (_music_sound == null)
			{
				load_sound ();
			}
			
			//On vérifie si le load c'est bien effectué
			if (_music_sound != null)
			{
				_channel = _music_sound.play ();
				_channel.soundTransform = _volume_info;
				positionTimer = new Timer(500);
				positionTimer.addEventListener(TimerEvent.TIMER, positionTimerHandler);
				positionTimer.start();
			}
		}
		
		public function stop ():void
		{
			if (_channel != null)
			{
				_channel.stop();
				_channel = null;
				_music_sound = null;
				positionTimer.stop();
				FlexGlobals.topLevelApplication.progressBar.value = 0;
			}
		}
		
		public function rewind ():void
		{
			if (_channel != null && _channel.position < 3000)
			{
			  update_index (-1);
			}
			stop();
			play();
		}
		
		public function forward ():void
		{
			if (_channel != null)
			{
				update_index (1);
			}
			stop();
			play();
		}
		
		public function change_volume (val:Number):void
		{
			_volume_info = new SoundTransform(val, 0);
			if (_channel != null)
			{
				_channel.soundTransform = _volume_info;
			}
		}
		
		
		private function update_index (inc:int):void
		{
			var index_updated:int = _index + inc;
			if (index_updated >= 0)
			{
				if (index_updated < _music_list.length)
				{
					_index = index_updated;
				}
			}
		}
	}
}