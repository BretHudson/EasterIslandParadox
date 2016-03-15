package  
{
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Tilemap;
	
	public class Assets 
	{
		
		// Gameplay Images
		//[Embed(source = "assets/gfx/player.png")]
		[Embed(source = "assets/gfx/rollie.png")]
		public static const PLAYER:Class;
		
		[Embed(source = "assets/gfx/player_mask.png")]
		public static const PLAYERMASK:Class;
		
		[Embed(source = "assets/gfx/antenna.png")]
		public static const ANTENNA:Class;
		
		[Embed(source = "assets/gfx/door.png")]
		public static const DOOR:Class;
		
		[Embed(source = "assets/gfx/crate.png")]
		public static const CRATE:Class;
		
		[Embed(source = "assets/gfx/slope_left.png")]
		public static const SLOPE_LEFT:Class;
		
		[Embed(source = "assets/gfx/slope_right.png")]
		public static const SLOPE_RIGHT:Class;
		
		
		
		// Level Preview Images
		[Embed(source = "assets/gfx/level_previews/level1.png")]
		public static const LEVEL1PREVIEW:Class;
		
		[Embed(source = "assets/gfx/level_previews/level2.png")]
		public static const LEVEL2PREVIEW:Class;
		
		[Embed(source = "assets/gfx/level_previews/level3.png")]
		public static const LEVEL3PREVIEW:Class;
		
		[Embed(source = "assets/gfx/level_previews/level4.png")]
		public static const LEVEL4PREVIEW:Class;
		
		[Embed(source = "assets/gfx/level_previews/level5.png")]
		public static const LEVEL5PREVIEW:Class;
		
		
		
		// Tilesets
		[Embed(source = "assets/gfx/tileset1.png")]
		public static const TILESET1:Class;
		public static const TILESET1COLOR:uint = 0x0A0A0F;
		public static var tileset1:Tilemap = new Tilemap(TILESET1, Level.GAME_WIDTH, Level.GAME_HEIGHT, 16, 16);
		
		
		
		// Omgo
		[Embed(source = "easter-island-paradox.oep", mimeType = "application/octet-stream")]
		public static const OGMOPROJECT:Class;
		
		[Embed(source = "assets/ogmo/level1.oel", mimeType = "application/octet-stream")]
		public static const LEVEL1:Class;
		
		[Embed(source = "assets/ogmo/level2.oel", mimeType = "application/octet-stream")]
		public static const LEVEL2:Class;
		
		[Embed(source = "assets/ogmo/level3.oel", mimeType = "application/octet-stream")]
		public static const LEVEL3:Class;
		
		[Embed(source = "assets/ogmo/level4.oel", mimeType = "application/octet-stream")]
		public static const LEVEL4:Class;
		
		[Embed(source = "assets/ogmo/level5.oel", mimeType = "application/octet-stream")]
		public static const LEVEL5:Class;
		
		
		
		// Music
		[Embed(source = "assets/music/Menu.mp3")]
		public static const MENUMUSIC:Class;
		
		[Embed(source = "assets/music/Level Select.mp3")]
		public static const LEVELSELECT:Class;
		
		[Embed(source = "assets/music/Here's to Hope (World 1).mp3")]
		public static const WORLD1:Class;
		
		[Embed(source = "assets/music/Interesting Islands (World 2).mp3")]
		public static const WORLD2:Class;
		
		[Embed(source = "assets/music/Moai Mystery (World 3).mp3")]
		public static const WORLD3:Class;
		
		
		
		// Sounds
		[Embed(source = "assets/sfx/Jump1.mp3")]
		public static const JUMP1:Class;
		public static var Jump1:Sfx = new Sfx(JUMP1);
		
		[Embed(source = "assets/sfx/Jump2.mp3")]
		public static const JUMP2:Class;
		public static var Jump2:Sfx = new Sfx(JUMP2);
		
		[Embed(source = "assets/sfx/Squeak1.mp3")]
		public static const SQUEAK1:Class;
		public static var Squeak1:Sfx = new Sfx(SQUEAK1);
		
		[Embed(source = "assets/sfx/Squeak1.mp3")]
		public static const SQUEAK2:Class;
		public static var Squeak2:Sfx = new Sfx(SQUEAK2);
		
		[Embed(source = "assets/sfx/Squeak3.mp3")]
		public static const SQUEAK3:Class;
		public static var Squeak3:Sfx = new Sfx(SQUEAK3);
		
		[Embed(source = "assets/sfx/Close.mp3")]
		public static const CLOSE:Class;
		
		[Embed(source = "assets/sfx/Open.mp3")]
		public static const OPEN:Class;
		
		[Embed(source = "assets/sfx/Land.mp3")]
		public static const LAND:Class;
		public static var land:Sfx = new Sfx(LAND);
		
		[Embed(source = "assets/sfx/LandSynth.mp3")]
		public static const LANDSYNTH:Class;
		public static var landSynth:Sfx = new Sfx(LANDSYNTH);
		
		
		// Functions
		public static function init():void
		{
			// TODO: Volumes
		}
		
	}

}