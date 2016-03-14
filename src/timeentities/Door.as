package timeentities {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Draw;
	
	public class Door extends TimeEntity
	{
		
		protected static const STATE_FRAME:int = NUM_BASE_STATES + 0;
		
		[Embed(source = "../assets/gfx/door.png")]
		private const SPRITE:Class;
		
		private var sprite2:Spritemap;
		
		private var open:int = 0;
		private var openTimer:int = 0;
		
		public function Door(x:int, y:int, numIntervals:int) 
		{
			super(x, y, numIntervals);
			
			sprite = Image.createRect(16, 16, 0x888888);
			
			sprite2 = new Spritemap(SPRITE, 16, 32);
			graphic = sprite2;
			
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
				
				sprite2.frame = openTimer;
			}
			else
			{
				if (--openTimer < 0)
				{
					openTimer = 0;
				}
				
				sprite2.frame = openTimer;
			}
			
			if (sprite2.frame == 3)
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
				if (!states[STATE_FRAME].recordInt(frame, sprite2.frame))	success = false;
			}
			
			return success;
		}
		
		override public function playback(frame:int):void 
		{
			super.playback(frame);
			
			sprite2.frame = states[STATE_FRAME].playbackInt(frame);
		}
		
		public function timeToToggle():void
		{
			open ^= 1;
			trace(open, "Time to toggle!");
		}
		
		override public function render():void 
		{
			super.render();
			
			Draw.hitbox(this, true, 0xFFFFFF);
		}
		
	}

}