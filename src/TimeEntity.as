package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Draw;
	
	public class TimeEntity extends Entity
	{
		
		private var states:Vector.<TimeState>;
		
		protected static const STATE_X:int = 0;
		protected static const STATE_Y:int = 1;
		protected static const NUM_BASE_STATES:int = 2;
		
		public function TimeEntity(x:Number, y:Number, numIntervals:int, graphic:Graphic = null, mask:Mask = null) 
		{
			super(x, y, graphic, mask);
			
			states = new Vector.<TimeState>();
			
			states.push(new TimeState(numIntervals, true)); // X
			states.push(new TimeState(numIntervals, true)); // Y
			
			recordState(0);
		}
		
		override public function update():void 
	
		{
			super.update();
		}
		
		override public function render():void 
		{
			super.render();
		}
		
		public function recordState(frame:int):Boolean
		{
			var success:Boolean = true;
			
			if (!states[STATE_X].recordInt(frame, x))	success = false;
			if (!states[STATE_Y].recordInt(frame, y))	success = false;
			
			return success;
		}
		
		public function playback(frame:int):void
		{
			x = states[STATE_X].playbackInt(frame);
			y = states[STATE_Y].playbackInt(frame);
		}
		
	}

}