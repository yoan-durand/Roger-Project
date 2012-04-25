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
	
	import spark.components.Image;
	import mx.controls.Label;
	import mx.core.FlexGlobals;
	
	import spark.components.BorderContainer;
	import spark.components.VGroup;
	import flash.text.TextFormatAlign;

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
				try
				{
					var sound:Sound = new Sound();
					sound.load(mp3,soundLoaderContext);
					_music_sound = sound;
					_music_sound.addEventListener(Event.COMPLETE, load_complete);
				} 
				catch(error:Error) 
				{
					trace ("loading fail");
				}
			}
		}
		
		private function load_complete (event:Event):void
		{
			play ();
		}
		

		
		private function positionTimerHandler (event:Event) : void
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
			_channel.stop();
			_channel = null;
			//_channel.removeEventListener(Event.SOUND_COMPLETE, _channel);  
			_music_sound = null;
			positionTimer.stop();
			FlexGlobals.topLevelApplication.progressBar.value = 0;
			update_index (1);
			play ();
			trace("Music end");
		}
		
		public function change_position (position:Number):void
		{
			if (_channel != null)
			{
				_channel.stop ();
				if (_music_sound != null)
				{
					_channel = _music_sound.play (Tool.getTimefromPercentage(position, _music_sound));
					_channel.soundTransform = _volume_info;
					_channel.addEventListener(Event.SOUND_COMPLETE, completeHandler);
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
			else
			{
				if (_channel == null)
				{
					var position:Number = FlexGlobals.topLevelApplication.progressBar.value;
					_channel = _music_sound.play (Tool.getTimefromPercentage(position, _music_sound));
					_channel.soundTransform = _volume_info;
					_channel.addEventListener(Event.SOUND_COMPLETE, completeHandler);
					positionTimer = new Timer(500);
					positionTimer.addEventListener(TimerEvent.TIMER, positionTimerHandler);
					positionTimer.start();
				}
				else
				{
					_channel.stop();
					_channel = null;
				}
			}
		}
		
		public function stop ():void
		{
			if (_channel != null)
			{
				_channel.stop();
				_channel = null;
				//_channel.removeEventListener(Event.SOUND_COMPLETE, _channel);  
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
		
		public function add_music (music:Music):void
		{

			display_add_music (music);
			_music_list.push(music);
		}
		
		/* DISPLAY */
		private function display_add_music (music:Music):void
		{
			var container:BorderContainer = new BorderContainer();
			container.width = 144;
			container.height = 120;
			
			var group:VGroup = new VGroup();
			group.percentHeight = 100;
			group.percentWidth = 100;
			group.gap = 0;
			
			var image:Image = new Image ();
			image.percentHeight = 70;
			image.percentWidth = 100;
			var path_cover:String = music.Path_Cover != "" ? music.Path_Cover : "assets/noimageavailable.jpg";
			image.source = path_cover;
			image.scaleMode = "stretch";
			group.addElement(image);
			
			
			var label_title:Label = new Label ();
			label_title.text = music.Title;
			label_title.percentWidth = 100;
			label_title.width = 140;
			label_title.height = 18;
			label_title.setStyle("textAlign", TextFormatAlign.CENTER);
			group.addElement (label_title);
			var label_artist:Label = new Label ();
			label_artist.text = music.Artist;
			label_artist.percentWidth = 100;
			label_title.width = 140;
			label_title.height = 18;
			label_artist.setStyle("textAlign", TextFormatAlign.CENTER);
			group.addElement (label_artist);
			
			container.addElement(group);
			
			FlexGlobals.topLevelApplication.current_playlist.addElement(container);
		}
	}
}