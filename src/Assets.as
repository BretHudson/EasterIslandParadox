package  
{
	
	public class Assets 
	{
		
		// Images
		[Embed(source = "assets/gfx/player.png")]
		public static const PLAYER:Class;
		
		[Embed(source = "assets/gfx/door.png")]
		public static const DOOR:Class;
		
		// Omgo
		[Embed(source = "assets/ogmo/easter-island-paradox.oep", mimeType = "application/octet-stream")]
		public static const OGMOPROJECT:Class;
		
		[Embed(source = "assets/ogmo/level1.oel", mimeType = "application/octet-stream")]
		public static const LEVEL1:Class;
		
	}

}