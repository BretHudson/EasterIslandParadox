package  
{
	
	public class TimeState 
	{
		
		public static const SECONDS_PER_INTERVAL:int = 5;
		public static const FRAMES_PER_INTERVAL:int = SECONDS_PER_INTERVAL * 60;
		
		// Values at beginning of each interval
		private var states:Array;
		public var timesWrittenTo:Array;
		
		// If it can only be changed once (IE a crate breaking)
		private var oneTime:Boolean;
		
		public var wrongInt:int = int.MIN_VALUE;
		public var wrongNumber:Number = 0;
		
		public function TimeState(numIntervals:int, isInt:Boolean, oneTime:Boolean = false)
		{
			var frameCount:int = numIntervals * FRAMES_PER_INTERVAL;
			
			states = new Array(frameCount);
			timesWrittenTo = new Array(frameCount);
			
			for (var i:int = 0; i < frameCount; ++i)
			{
				states[i] = ((isInt) ? int.MIN_VALUE : Number.MIN_VALUE);
				timesWrittenTo[i] = 0;
			}
			
			this.oneTime = oneTime;
		}
		
		public function recordInt(frame:int, value:int):Boolean
		{
			// If that state has already been set, and it's not equal, we have a paradox! RECORD FAILED!
			if ((++timesWrittenTo[frame] > 1) && (states[frame] != value))
			{
				wrongInt = value;
				return false;
			}
			
			states[frame] = value;
			return true;
		}
		
		public function recordNumber(frame:int, value:Number):Boolean
		{
			// If that state has already been set, and it's not equal, we have a paradox! RECORD FAILED!
			if ((++timesWrittenTo[frame] > 1) && (states[frame] != value))
			{
				wrongNumber = value;
				return false;
			}
			
			states[frame] = value;
			return true;
		}
		
		public function playbackInt(frame:int):int
		{
			while (timesWrittenTo[frame] == 0)
			{
				//frame -= FRAMES_PER_INTERVAL;
				--frame;
			}
			return states[frame];
		}
		
		public function playbackNumber(frame:int):Number
		{
			while (timesWrittenTo[frame] == 0)
			{
				//frame -= FRAMES_PER_INTERVAL;
				--frame;
			}
			return states[frame];
		}
		
		public function undo(frame:int):void
		{
			if (--timesWrittenTo[frame] == 0)
			{
				states[frame] = 0;
			}
		}
		
		/*public function startInterval(n:int):int
		{
			start[n] = start[0];
			
			for (var i:int = 0; i < n; ++i)
			{
				if (delta[i] > int.MIN_VALUE)
					start[n] += delta[i];
			}
			
			return start[n];
		}
		
		public function endInterval(n:int, newValue:int):void
		{
			delta[n] = newValue - start[n];
			for (var i:int = n + 1; i < delta.length; ++i)
			{
				if (delta[i] > int.MIN_VALUE)
				{
					delta[i] -= delta[n];
					break;
				}
			}
		}
		
		public function undoInterval(n:int):int
		{
			start[n] = start[0];
			
			for (var i:int = n + 1; i < delta.length; ++i)
			{
				if (delta[i] > int.MIN_VALUE)
				{
					delta[i] += delta[n];
					break;
				}
			}
			
			delta[n] = int.MIN_VALUE;
			
			return start[n];
		}*/
		
	}

}