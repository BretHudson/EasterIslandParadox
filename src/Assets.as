package  
{
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Tilemap;
	
	public class Assets 
	{
		
		// Gameplay Images
		[Embed(source = "assets/gfx/player.png")]
		public static const PLAYER:Class;
		
		[Embed(source = "assets/gfx/door.png")]
		public static const DOOR:Class;
		
		[Embed(source = "assets/gfx/crate.png")]
		public static const CRATE:Class;
		
		// Level Preview Images
		[Embed(source = "assets/gfx/level_previews/level1.png")]
		public static const LEVEL1PREVIEW:Class;
		
		// Tilesets
		[Embed(source = "assets/gfx/tileset1.png")]
		public static const TILESET1:Class;
		public static const TILESET1COLOR:uint = 0x0A0A0F;
		public static var tileset1:Tilemap = new Tilemap(TILESET1, Level.GAME_WIDTH + 32, Level.GAME_HEIGHT + 32, 16, 16);
		
		// Omgo
		[Embed(source = "easter-island-paradox.oep", mimeType = "application/octet-stream")]
		public static const OGMOPROJECT:Class;
		
		[Embed(source = "assets/ogmo/level1.oel", mimeType = "application/octet-stream")]
		public static const LEVEL1:Class;
		
		[Embed(source = "assets/ogmo/level2.oel", mimeType = "application/octet-stream")]
		public static const LEVEL2:Class;
		
		// Sounds
		[Embed(source = "assets/sfx/Jump1.mp3")]
		public static const JUMP1:Class;
		public static var Jump1:Sfx = new Sfx(JUMP1);
		
		[Embed(source = "assets/sfx/Jump2.mp3")]
		public static const JUMP2:Class;
		public static var Jump2:Sfx = new Sfx(JUMP2);
		
	}

}