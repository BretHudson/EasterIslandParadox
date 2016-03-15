package timeentities {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Draw;
	
	public class Door extends TimeEntity
	{
		
		protected static const STATE_FRAME:int = NUM_BASE_STATES + 0;
		
		private var sprite:Spritemap;
		
		private var open:int = 0;
		private var openTimer:int = 0;
		
		public function Door(x:int, y:int, numIntervals:int) 
		{
			super(x, y, numIntervals);
			
			sprite = new Spritemap(Assets.DOOR, 16, 32);
			sprites.add(sprite);
			
			setHitbox(6, 32, -5);
			type = "solid";
			
			states.push(new TimeState(numIntervals, false));
			
			recordState(0);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (open == 1)
			{
				if (++openTimer > 3)
				{
					openTimer = 3;
				}
				
				sprite.frame = openTimer;
			}
			else
			{
				if (--openTimer < 0)
				{
					openTimer = 0;
				}
				
				sprite.frame = openTimer;
			}
			
			if (sprite.frame == 3)
			{
				setHitbox(0, 0);
			}
			else
			{
				setHitbox(6, 32, -5);
			}
		}
		
		override public function recordState(frame:int):Boolean 
		{
			var success:Boolean = super.recordState(frame);
			
			if (states.length > NUM_BASE_STATES)
			{
				if (!states[STATE_FRAME].recordInt(frame, sprite.frame))	success = false;
			}
			
			return success;
		}
		
		override public function playback(frame:int):void 
		{
			super.playback(frame);
			
			sprite.frame = states[STATE_FRAME].playbackInt(frame);
		}
		
		public function timeToToggle():void
		{
			open ^= 1;
			trace(open, "Time to toggle!");
		}
		
	}

}