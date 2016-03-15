package timeentities
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	
	public class Crate extends TimeEntity
	{
		
		public function Crate(x:int, y:int, numIntervals:int) 
		{
			super(x, y, numIntervals);
			
			// TODO: Put other things here!
			
			sprite = new Image(Assets.CRATE);
			graphic = sprite;
			
			setHitbox(16, 16);
			type = "crate";
			
			recordState(0);
		}
		
		public function move(xmove:int):Boolean
		{
			if (collide("solid", x + xmove, y))
				return false;
			
			var crate:Crate = collide("crate", x + xmove, y) as Crate;
			if ((crate) && (crate != this) && (!crate.move(xmove)))
				return false;
			
			x += xmove;
			return true;
		}
		
		/*override public function recordState(frame:int):Boolean 
		{
			var success:Boolean = super.recordState(frame);
			
			// ??
			
			return success;
		}*/
		
	}

}