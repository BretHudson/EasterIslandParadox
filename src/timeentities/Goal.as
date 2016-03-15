package timeentities 
{
	import flash.display.BitmapData;
	import net.flashpunk.graphics.Image;
	
	public class Goal extends TimeEntity
	{
		
		private var sprite:Image;
		
		public function Goal(x:int, y:int, numIntervals:int) 
		{
			super(x, y, numIntervals);
			
			sprite = new Image(new BitmapData(24, 32, true, 0xFF0000FF))
			sprite.centerOO();
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