package timeentities
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	
	public class Crate extends TimeEntity
	{
		
		private var sprite:Image;
		
		private var yspeed:Number = 0;
		
		public function Crate(x:int, y:int, numIntervals:int) 
		{
			super(x, y, numIntervals);
			
			// TODO: Put other things here!
			
			sprite = new Image(Assets.CRATE);
			sprites.add(sprite);
			
			setHitbox(16, 16);
			type = "crate";
			
			recordState(0);
		}
		
		override public function update():void 
		{
			yspeed += Player.gspeed;
			checkFalling();
		}
		
		private function collideWithSolidY(yy:int):Entity
		{
			var e:Entity = null;
			e = collide("solid", x, yy)
			if (e)	return e;
			e = collide("crate", x, yy)
			if (e)	return e;
			return e;
		}
		
		public function move(xmove:int):Boolean
		{
			if (collide("solid", x + xmove, y))
				return false;
			
			var crate:Crate = collide("crate", x + xmove, y) as Crate;
			if ((crate) && (crate != this) && (!crate.move(xmove)))
				return false;
			
			x += xmove;
			
			yspeed += Player.gspeed;
			checkFalling();
			
			return true;
		}
		
		private function checkFalling():void
		{
			for (var yy:int = 0; yy < yspeed; ++yy)
			{
				// TODO: Remove the second check
				if (!collideWithSolidY(y + 1))
				{
					++y;
				}
				else
				{
					yspeed = 0;
					break;
				}
			}
		}
		
		/*override public function recordState(frame:int):Boolean 
		{
			var success:Boolean = super.recordState(frame);
			
			// ??
			
			return success;
		}*/
		
	}

}