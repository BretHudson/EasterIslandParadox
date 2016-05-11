package menus 
{
	import flash.ui.MouseCursor;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	
	public class Button extends Entity
	{
		
		public static const PAUSE:int = 0;
		public static const MUTE:int = 1;
		public static const HELP:int = 2;
		
		private var sprite:Spritemap;
		private var buttonID:int;
		private var tint:uint;
		private var hoverTint:uint;
		
		public var helpImage:Image;
		
		public function Button(x:int, y:int, button:int, tint:uint, hoverTint:uint) 
		{
			super(x, y);
			
			buttonID = button;
			
			sprite = new Spritemap(Assets.BUTTONS, 16, 16);
			sprite.add("frame", [button], 1);
			sprite.play("frame");
			sprite.color = tint;
			graphic = sprite;
			
			if (button == HELP)
			{
				helpImage = new Image(Assets.HOWTOPLAY)
				helpImage.relative = false;
				helpImage.x = 200;
				helpImage.y = 150;
				helpImage.centerOO();
				helpImage.alpha = 0;
				graphic = new Graphiclist(sprite, helpImage);
			}
			
			this.tint = tint;
			this.hoverTint = hoverTint;
			
			layer = -1000000;
			
			setHitbox(16, 16);
		}
		
		override public function update():void 
		{
			if (helpImage)
			{
				helpImage.x = 200 + world.camera.x;
				helpImage.y = 150 + world.camera.y;
			}
			
			if ((Input.mousePressed) && (helpImage) && (helpImage.alpha == 1))
			{
				helpImage.alpha = 0;
			}
			
			if (collidePoint(x, y, Input.mouseX + world.camera.x, Input.mouseY + world.camera.y))
			{
				sprite.color = hoverTint;
				Input.mouseCursor = MouseCursor.BUTTON;
				
				if (Input.mousePressed)
				{
					switch (buttonID)
					{
						case PAUSE:
							Level(world).togglePause();
							break;
						case MUTE:
							MusicManager.toggleMute();
							break;
						case HELP:
							helpImage.alpha = 1 - helpImage.alpha;
							break;
					}
				}
			}
			else
			{
				sprite.color = tint;
			}
			
			if (buttonID == MUTE)
			{
				sprite.frame = ((MusicManager.mute) ? 1 : 3);
			}
		}
		
	}

}