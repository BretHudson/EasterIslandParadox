package timeentities 
{
	import flash.display.BitmapData;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	
	public class Goal extends TimeEntity
	{
		
		private var sprite:Spritemap;
		
		public function Goal(x:int, y:int, numIntervals:int) 
		{
			super(x, y, numIntervals);
			
			sprite = new Spritemap(Assets.GOAL, 32, 32);
			sprite.centerOO();
			sprite.add("idle", [0]);
			sprite.add("close", [0, 1, 2, 3, 4], 10);
			sprite.play("idle");
			sprites.add(sprite);
			
			setHitbox(24, 32, 12, 16);
			type = "goal";
			
			recordState(0);
		}
		
		override public function added():void 
		{
			sprite.color = 0x0000FF;
		}
		
	}

}