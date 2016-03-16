package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class Solid extends Entity
	{
		
		private var sprite:Image;
		
		public function Solid(x:int, y:int, w:int, h:int) 
		{
			super(x, y);
			setHitbox(w, h);
			type = "solid";
			
			layer = -100;
			
			sprite = Image.createRect(w, h, 0xFF00FF, 0.3);
			sprite.alpha = 0;
			graphic = sprite;
		}
		
		override public function update():void 
		{
			CONFIG::debug
			{
				if (Input.pressed(Key.Q))
				{
					sprite.alpha = 1 - sprite.alpha;
				}
			}
		}
		
	}

}