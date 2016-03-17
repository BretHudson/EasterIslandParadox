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
		
		[Embed(source = "assets/gfx/death.png")]
		public static const PLAYERDEATH:Class;
		
		[Embed(source = "assets/gfx/antenna.png")]
		public static const ANTENNA:Class;
		
		[Embed(source = "assets/gfx/door.png")]
		public static const DOOR:Class;
		
		[Embed(source = "assets/gfx/goal.png")]
		public static const GOAL:Class;
		
		[Embed(source = "assets/gfx/crate.png")]
		public static const CRATE:Class;
		
		[Embed(source = "assets/gfx/slope_left.png")]
		public static const SLOPE_LEFT:Class;
		
		[Embed(source = "assets/gfx/slope_right.png")]
		public static const SLOPE_RIGHT:Class;
		
		[Embed(source = "assets/gfx/cloud_bg.png")]
		public static const CLOUD_BG:Class;
		
		[Embed(source = "assets/gfx/game-border.png")]
		public static const GAME_BORDER:Class;
		
		[Embed(source = "assets/gfx/tutorial.png")]
		public static const TUTORIAL:Class;
		
		[Embed(source = "assets/gfx/cannonbase.png")]
		public static const MISSILELAUNCHER:Class;
		
		[Embed(source = "assets/gfx/cannonbasedark.png")]
		public static const MISSILELAUNCHERDARK:Class;
		
		[Embed(source = "assets/gfx/rocket.png")]
		public static const MISSILE:Class;
		
		[Embed(source = "assets/gfx/explosion.png")]
		public static const EXPLOSION:Class;
		
		[Embed(source = "assets/gfx/menu_background.png")]
		public static const MENU_CLOUDS_BACKGROUND:Class;
		
		[Embed(source = "assets/gfx/Menu_cloudBack.png")]
		public static const MENU_CLOUDS_BACK:Class;
		
		[Embed(source = "assets/gfx/Menu_cloudFront.png")]
		public static const MENU_CLOUDS_FRONT:Class;
		
		[Embed(source="assets/gfx/Menu_foreground.png")]
		public static const MENU_ISLANDS:Class;
		
		[Embed(source = "assets/gfx/logo.png")]
		public static const LOGO:Class;
		
		[Embed(source = "assets/gfx/buttons.png")]
		public static const BUTTONS:Class;
		
		[Embed(source = "assets/gfx/idnet.png")]
		public static const IDNETLOGO:Class;
		
		
		
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
		
		[Embed(source = "assets/gfx/level_previews/level6.png")]
		public static const LEVEL6PREVIEW:Class;
		
		[Embed(source = "assets/gfx/level_previews/level7.png")]
		public static const LEVEL7PREVIEW:Class;
		
		[Embed(source = "assets/gfx/level_previews/level8.png")]
		public static const LEVEL8PREVIEW:Class;
		
		public static const NUMLEVELS:int = 7;
		
		
		
		// Tilesets
		[Embed(source = "assets/gfx/easterislandhead.png")]
		public static const TILESET1:Class;
		public static const TILESET1COLOR:uint = 0x00FF78;
		
		
		
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
		
		[Embed(source = "assets/ogmo/levelCrateDrop.oel", mimeType = "application/octet-stream")]
		public static const LEVEL6:Class;
		
		[Embed(source = "assets/ogmo/levelCrateParadox.oel", mimeType = "application/octet-stream")]
		public static const LEVEL7:Class;
		
		[Embed(source = "assets/ogmo/blockslwvwl.oel", mimeType = "application/octet-stream")]
		public static const LEVEL8:Class;
		
		
		
		// Music
		[Embed(source = "assets/music/Menu.mp3")]
		public static const MENUMUSIC:Class;
		
		[Embed(source = "assets/music/Level Select.mp3")]
		public static const LEVELSELECT:Class;
		
		[Embed(source = "assets/music/Here's to Hope (World 1).mp3")]
		public static const WORLD2:Class;
		
		[Embed(source = "assets/music/Interesting Islands (World 2).mp3")]
		public static const WORLD1:Class;
		
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