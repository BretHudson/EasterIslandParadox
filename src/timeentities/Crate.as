package timeentities
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	
	public class Crate extends TimeEntity
	{
		
		protected static const STATE_EXISTS:int = NUM_BASE_STATES + 0;
		protected static const STATE_YSPEED:int = NUM_BASE_STATES + 1;
		
		private var sprite:Image;
		
		private var yspeed:Number = 0;
		
		private const EXISTNUM:int = 21;
		private var exists:int = EXISTNUM;
		
		public function Crate(x:int, y:int, numIntervals:int) 
		{
			super(x, y, numIntervals);
			
			// TODO: Put other things here!
			
			sprite = new Image(Assets.CRATE);
			sprites.add(sprite);
			
			setHitbox(16, 16);
			type = "crate";
			
			states.push(new TimeState(numIntervals, true));
			states.push(new TimeState(numIntervals, false));
			
			recordState(0);
		}
		
		override public function update():void 
		{
			yspeed += Player.gspeed;
			checkFalling();
			
			if (exists < EXISTNUM)
			{
				--exists;
			}
			
			collidable = (exists > 0);
		}
		
		override public function render():void 
		{
			if (exists > 0)
				super.render();
		}
		
		public function destroy():void
		{
			--exists;
		}
		
		private function collideWithSolidY(yy:int):Entity
		{
			var e:Entity = null;
			e = collide("solid", x, yy)
			if (e)	return e;
			e = collide("crate", x, yy)
			if (e)	return e;
			e = collide("player", x, yy)
			if (e)	return e;
			return e;
		}
		
		public function move(xmove:int):Boolean
		{
			if (collide("solid", x + xmove, y))
				return false;
			
			var crate:Crate = collide("crate", x + xmove, y) as Crate;
			if ((crate) && (!crate.move(xmove)))
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
		
		override public function recordState(frame:int):Boolean 
		{
			var success:Boolean = super.recordState(frame);
			
			if (states.length > NUM_BASE_STATES)
			{
				if (!states[STATE_EXISTS].recordNumber(frame, exists))	success = false;
				if (!states[STATE_YSPEED].recordNumber(frame, yspeed))	success = false;
			}
			
			return success;
		}
		
		override public function playback(frame:int):void 
		{
			super.playback(frame);
			
			exists = states[STATE_EXISTS].playbackInt(frame);
			yspeed = states[STATE_YSPEED].playbackInt(frame);
		}
		
		/*override public function recordState(frame:int):Boolean 
		{
			var success:Boolean = super.recordState(frame);
			
			// ??
			
			return success;
		}*/
		
	}

}