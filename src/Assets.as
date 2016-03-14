package  
{
	import net.flashpunk.graphics.Tilemap;
	
	public class Assets 
	{
		
		// Images
		[Embed(source = "assets/gfx/player.png")]
		public static const PLAYER:Class;
		
		[Embed(source = "assets/gfx/door.png")]
		public static const DOOR:Class;
		
		[Embed(source = "assets/gfx/crate.png")]
		public static const CRATE:Class;
		
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
		
	}

}