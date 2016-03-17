package menus 
{
	import flash.ui.MouseCursor;
	import net.flashpunk.Entity;
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
		
		public function Button(x:int, y:int, button:int, tint:uint, hoverTint:uint) 
		{
			super(x, y);
			
			buttonID = button;
			
			trace("BUTTON", button);
			
			sprite = new Spritemap(Assets.BUTTONS, 16, 16);
			sprite.add("frame", [button], 1);
			sprite.play("frame");
			sprite.color = tint;
			graphic = sprite;
			
			this.tint = tint;
			this.hoverTint = hoverTint;
			
			layer = -1000000;
			
			setHitbox(16, 16);
		}
		
		override public function update():void 
		{
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
							// TODO:
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