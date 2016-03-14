package timeentities
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	/**
	 * ...
	 * @author Bret Hudson
	 */
	public class Player extends TimeEntity
	{
		
		protected static const STATE_XSPEED:int = NUM_BASE_STATES + 0;
		protected static const STATE_YSPEED:int = NUM_BASE_STATES + 1;
		
		private var xspeed:Number = 0;
		private var yspeed:Number = 0;
		
		private var aspeed:Number = 0.5;
		private var fspeed:Number = 0.5;
		private var mspeed:Number = 2.0;
		
		private var gspeed:Number = 0.2;
		private var jspeed:Number = -4.2;
		
		public function Player(x:int, y:int, numIntervals:int) 
		{
			super(x, y, numIntervals);
			
			sprite = new Image(Assets.PLAYER);
			graphic = sprite;
			
			setHitbox(16, 16);
			type = "player";
			
			states.push(new TimeState(numIntervals, true)); // XSPEED
			states.push(new TimeState(numIntervals, true)); // YSPEED
			
			recordState(0);
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
		
		// TODO: Jump input buffering!
		override public function update():void 
		{
			super.update();
			
			// Input
			var hdir:int = int(Input.check("right")) - int(Input.check("left"));
			
			// Horizontal movement
			if (hdir != 0)
				xspeed = FP.clamp(xspeed + hdir, -mspeed, mspeed);
			else 
				xspeed -= fspeed * FP.sign(xspeed);
			
			// Apply gravity
			if ((yspeed < 0) && (!Input.check("jump")))
				yspeed += gspeed;
			yspeed += gspeed;
			
			// Jump
			if ((Input.pressed("jump")) &&
			((collideWithSolidY(y + 1)) || (y + height >= Level.GAME_HEIGHT)))
				yspeed = jspeed;
			
			// Movement
			var xabs:int = Math.abs(xspeed);
			var xdir:int = FP.sign(xspeed);
			var crate:Crate;
			for (var xx:int = 0; xx < xabs; ++xx)
			{
				crate = collide("crate", x + xdir, y) as Crate;
				if ((crate) && (!crate.move(xdir)))
				{
					xspeed = 0;
					break;
				}
				
				
				if (!collide("solid", x + xdir, y))
					x += xdir;
				else
				{
					xspeed = 0;
					break;
				}
			}
			
			var yabs:int = Math.abs(yspeed);
			var ydir:int = FP.sign(yspeed);
			for (var yy:int = 0; yy < yabs; ++yy)
			{
				// TODO: Remove the second check
				if ((!collideWithSolidY(y + ydir)) && (y + ydir + height <= Level.GAME_HEIGHT))
					y += ydir;
				else
				{
					yspeed = 0;
					break;
				}
			}
		}
		
		override public function recordState(frame:int):Boolean 
		{
			// TODO: Set frame = internalEnterCount * 60
			
			var success:Boolean = super.recordState(frame);
			
			if (states.length > NUM_BASE_STATES)
			{
				if (!states[STATE_XSPEED].recordNumber(frame, xspeed))	success = false;
				if (!states[STATE_YSPEED].recordNumber(frame, yspeed))	success = false;
			}
			
			return success;
		}
		
		override public function playback(frame:int):void 
		{
			super.playback(frame);
			
			xspeed = states[STATE_XSPEED].playbackNumber(frame);
			yspeed = states[STATE_YSPEED].playbackNumber(frame);
		}
		
		override protected function renderParadox():void 
		{
			// TODO: Do nothing here for player :)
			
			super.renderParadox();
		}
		
	}

}