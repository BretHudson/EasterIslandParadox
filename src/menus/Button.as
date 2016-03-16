package menus 
{
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
		
		public function Button(x:int, y:int, button:int, tint:uint) 
		{
			super(x, y);
			
			buttonID = button;
			
			sprite = new Spritemap(Assets.BUTTONS, 16, 16);
			sprite.add("frame", [buttonID], 1);
			sprite.play("frame");
			sprite.color = tint;
			graphic = sprite;
			
			setHitbox(16, 16);
		}
		
		override public function update():void 
		{
			if ((Input.mousePressed) && (collidePoint(x, y, Input.mouseX + world.camera.x, Input.mouseY + world.camera.y)))
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
		
	}

}