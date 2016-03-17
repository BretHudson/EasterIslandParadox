package menus 
{
	import flash.display.BlendMode;
	import flash.ui.MouseCursor;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.graphics.TiledImage;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	
	public class Menu extends World
	{
		
		private var background:Image;
		private var cloudsBack:TiledImage;
		private var cloudsFront:TiledImage;
		private var islands:Image;
		private var logo:Image;
		
		private var idLogo:Image;
		private var idnetLogo:Entity;
		
		private var text:Text;
		private var loginText:Text;
		
		private var playText:Text;
		private var play:Entity;
		
		public function Menu() 
		{
			addGraphic(background = new Image(Assets.MENU_CLOUDS_BACKGROUND));
			addGraphic(cloudsBack = new TiledImage(Assets.MENU_CLOUDS_BACK, 400 * 3, 300));
			addGraphic(cloudsFront = new TiledImage(Assets.MENU_CLOUDS_FRONT, 400 * 3, 300));
			addGraphic(islands = new Image(Assets.MENU_ISLANDS));
			addGraphic(logo = new Image(Assets.LOGO));
			
			playText = new Text("PLAY");
			playText.size = 48;
			playText.centerOO();
			playText.color = 0x284239;
			play = addGraphic(playText);
			play.x = 203;
			play.y = 158;
			play.setHitbox(playText.width, playText.height, playText.width * 0.5, playText.height * 0.5);
			
			idLogo = new Image(Assets.IDNETLOGO);
			idnetLogo = addGraphic(idLogo);
			idnetLogo.setHitbox(idLogo.width, idLogo.height);
			idnetLogo.x = 200 - (idLogo.width * 0.5) + 40;
			idnetLogo.y = 230;// (300 - idLogo.height) - 10;
			
			loginText = new Text("Login with", 140, 245);
			loginText.size = 16;
			addGraphic(loginText);
			
			logo.centerOO();
			logo.x = 200;
			logo.y = 65;
			
			text = new Text("Bret Hudson / Jared Cohen / Mike LeRoy         v1.0", 30, 275);
			text.size = 16;
			addGraphic(text);
			
			Main.addIconsToWorld(this, 400 - 40 + 24 + 12, 8, 0x000000, 0xFFFFFF, false, true, false);
		}
		
		override public function begin():void 
		{
			FP.screen.color = 0x202020;
			MusicManager.playTrack(MusicManager.MENU);
		}
		
		override public function render():void 
		{
			super.render();
			
			//Draw.hitbox(play, true, 0xFF0000);
		}
		
		override public function update():void 
		{
			Input.mouseCursor = MouseCursor.ARROW;
			
			super.update();
			
			cloudsBack.x -= 0.33;
			cloudsFront.x -= 0.25;
			
			if (cloudsBack.x < -400) cloudsBack.x += 400;
			if (cloudsFront.x < -400) cloudsFront.x += 400;
			
			idLogo.blend = null;
			idLogo.color = 0xFFFFFF;
			
			if ((Main.idi.idnet) && (Main.idi.idnet.InterfaceOpen()))
			{
				return;
			}
			
			if (play.collidePoint(play.x, play.y, Input.mouseX, Input.mouseY))
			{
				playText.color = 0x01FF78;
				Input.mouseCursor = MouseCursor.BUTTON;
				
				if (Input.mousePressed)
				{
					FP.world = Main.levelSelect;
				}
			}
			else
			{
				playText.color = 0x284239;
			}
			
			if (idnetLogo.collidePoint(idnetLogo.x, idnetLogo.y, Input.mouseX, Input.mouseY))
			{
				Input.mouseCursor = MouseCursor.BUTTON;
				
				idLogo.blend = BlendMode.LIGHTEN;
				idLogo.color = 0x888888;
				
				if (Input.mousePressed)
				{
					if (Main.idi.idnet)
						Main.idi.idnet.toggleInterface('registration');
				}
			}
			
			if (Input.pressed("enter"))
			{
				FP.world = Main.levelSelect;
			}
		}
		
	}

}