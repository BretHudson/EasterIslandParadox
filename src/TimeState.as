package  
{
	
	public class TimeState 
	{
		
		// Values at beginning of each interval
		private var start:Vector.<int>;
		
		// Amount of change during interval
		private var delta:Vector.<int>;
		
		// If it can only be changed once (IE a crate breaking)
		private var oneTime:Boolean;
		
		public function TimeState(num:int, initialValue:int, oneTime:Boolean = false)
		{
			start = new Vector.<int>();
			delta = new Vector.<int>();
			
			while (num--)
			{
				start.push(initialValue);
				delta.push(int.MIN_VALUE);
			}
			
			this.oneTime = oneTime;
		}
		
		public function startInterval(n:int):int
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
			
			return start[
		}
		
	}

}