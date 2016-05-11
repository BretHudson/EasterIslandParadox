package 
{
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.tweens.misc.NumTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	
	public class MusicManager 
	{
		
		private static var menu:Sfx = new Sfx(Assets.MENUMUSIC);
		private static var menuTween:NumTween;
		public static const MENU:int = 0;
		
		private static var levelSelect:Sfx = new Sfx(Assets.LEVELSELECT);
		private static var levelSelectTween:NumTween;
		public static const LEVELSELECT:int = 1;
		
		private static var world1:Sfx = new Sfx(Assets.WORLD1);
		private static var world1Tween:NumTween;
		public static const WORLD1:int = 2;
		
		/*private static var world2:Sfx = new Sfx(Assets.WORLD2);
		private static var world2Tween:NumTween;
		public static const WORLD2:int = 2;
		
		private static var world3:Sfx = new Sfx(Assets.WORLD3);
		private static var world3Tween:NumTween;
		public static const WORLD3:int = 2;*/
		
		private static const maxVolume:Number = 0.5;
		private static var _volume:Number = 1.0;
		private static var _lastVolume:Number = 1.0;
		public static var mute:Boolean = false;
		
		public static function get volume():Number { return _volume * maxVolume; }
		public static function set volume(value:Number):void
		{
			_lastVolume = _volume;
			_volume = value;
		}
		
		private static var curPlaying:int = -1;
		
		public static function playTrack(trackIndex:int):void
		{
			if (curPlaying == trackIndex) return;
			
			// Adjust volumes
			stopTrack();
			fadeInTrack(trackIndex);
			
			// Play track if not playing
			var sfx:Sfx = getTrack(trackIndex);
			if (sfx.volume == 0)
			{
				sfx.loop();
			}
			
			curPlaying = trackIndex;
		}
		
		public static function stopTrack():void
		{
			fadeOutTrack(curPlaying);
			curPlaying = -1;
		}
		
		public static function fadeOutTrack(trackIndex:int):void
		{
			if (trackIndex < 0) return;
			var track:Sfx = getTrack(trackIndex);
			var tween:NumTween = getTrackTween(trackIndex);
			tween.tween(track.volume, 0, 0.5 * track.volume);
		}
		
		public static function fadeInTrack(trackIndex:int):void
		{
			var track:Sfx = getTrack(trackIndex);
			var tween:NumTween = getTrackTween(trackIndex);
			var startVolume:int = Math.max(track.volume, 0.001);
			tween.tween(startVolume, 1.0, 0.5 * (1.0 - startVolume));
		}
		
		public static function getTrack(trackIndex:int):Sfx
		{
			switch (trackIndex)
			{
				case MENU:			return menu;
				case LEVELSELECT:	return levelSelect;
				case WORLD1:		return world1;
			}
			
			return null;
		}
		
		public static function getTrackTween(trackIndex:int):NumTween
		{
			switch (trackIndex)
			{
				case MENU:			return menuTween;
				case LEVELSELECT:	return levelSelectTween;
				case WORLD1:		return world1Tween;
			}
			
			return null;
		}
		
		public static function init():void
		{
			menuTween = new NumTween();
			menuTween.tween(0, 0, 0);
			menuTween.value = 0;
			
			levelSelectTween = new NumTween();
			levelSelectTween.tween(0, 0, 0);
			levelSelectTween.value = volume;
			
			world1Tween = new NumTween();
			world1Tween.tween(0, 0, 0);
			world1Tween.value = 0;
			
			/*world2Tween = new NumTween();
			world2Tween.tween(0, 0, 0);
			world2Tween.value = 0;
			
			world3Tween = new NumTween();
			world3Tween.tween(0, 0, 0);
			world3Tween.value = 0;*/
			
			// TODO: Adjust volumes
			
			CONFIG::debug
			{
				toggleMute();
			}
		}
		
		public static function toggleMute():void
		{
			mute = !mute;
			if (mute)
			{
				Sfx.setVolume(null, 0);
			}
			else
			{
				Sfx.setVolume(null, 1);
			}
		}
		
		public static function update():void
		{
			if (Input.pressed("mute"))
				toggleMute();
			
			menuTween.update();
			menu.volume = menuTween.value * _volume;
			if (menu.volume == 0) menu.stop();
			else if (!menu.playing) menu.loop();
			
			levelSelectTween.update();
			levelSelect.volume = levelSelectTween.value * _volume;
			if (levelSelect.volume == 0) levelSelect.stop();
			else if (!levelSelect.playing) levelSelect.loop();
			
			world1Tween.update();
			world1.volume = world1Tween.value * _volume;
			if (world1.volume == 0) world1.stop();
			else if (!world1.playing) world1.loop();
			
			/*world2Tween.update();
			world2.volume = world2Tween.value * _volume;
			if (world2.volume == 0) world2.stop();
			else if (!world2.playing) world2.loop();
			
			world3Tween.update();
			world3.volume = world3Tween.value * _volume;
			if (world3.volume == 0) world3.stop();
			else if (!world3.playing) world3.loop();*/
			
			/*FP.console.log("Volume", volume,
			"Menu", menu.playing, menu.volume, menuTween.value,
			"Level", levelSelect.playing, levelSelect.volume, levelSelectTween.value,
			"World1", world1.playing, world1.volume, world1Tween.value,
			"World2", world2.playing, world2.volume, world2Tween.value,
			"World3", world3.playing, world3.volume, world3Tween.value);*/
		}
		
	}

}