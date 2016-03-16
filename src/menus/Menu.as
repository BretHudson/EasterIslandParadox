package menus 
{
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.TiledImage;
	import net.flashpunk.utils.Input;
	
	public class Menu extends World
	{
		
		private var background:Image;
		private var cloudsBack:TiledImage;
		private var cloudsFront:TiledImage;
		private var islands:Image;
		private var logo:Image;
		
		public function Menu() 
		{
			addGraphic(background = new Image(Assets.MENU_CLOUDS_BACKGROUND));
			addGraphic(cloudsBack = new TiledImage(Assets.MENU_CLOUDS_BACK, 400 * 3, 300));
			addGraphic(cloudsFront = new TiledImage(Assets.MENU_CLOUDS_FRONT, 400 * 3, 300));
			addGraphic(islands = new Image(Assets.MENU_ISLANDS));
			addGraphic(logo = new Image(Assets.LOGO));
			
			logo.centerOO();
			logo.x = 200;
			logo.y = 65;
		}
		
		override public function begin():void 
		{
			FP.screen.color = 0x202020;
			MusicManager.playTrack(MusicManager.MENU);
		}
		
		override public function update():void 
		{
			super.update();
			
			cloudsBack.x -= 0.33;
			cloudsFront.x -= 0.25;
			
			if (cloudsBack.x < -400) cloudsBack.x += 400;
			if (cloudsFront.x < -400) cloudsFront.x += 400;
			
			if (Input.mousePressed)
			{
				FP.world = Main.levelSelect;
			}
		}
		
	}

}