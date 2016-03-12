package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Draw;
	
	public class TimeEntity extends Entity
	{
		
		private var states:Vector.<TimeState>;
		
		protected const STATE_X:int = 0;
		protected const STATE_Y:int = 1;
		protected const NUM_BASE_STATES:int = 2;
		
		public function TimeEntity(x:Number, y:Number, numStates:int, graphic:Graphic = null, mask:Mask = null) 
		{
			super(x, y, graphic, mask);
			
			states = new Vector.<TimeState>();
			
			states.push(new TimeState(numStates, x, false));
			states.push(new TimeState(numStates, y, false));
		}
		
		public function startInterval(n:int):Boolean
		{
			x = states[STATE_X].startInterval(n);
			y = states[STATE_Y].startInterval(n);
			
			return true;
		}
		
		public function endInterval(n:int):Boolean
		{
			states[STATE_X].endInterval(n, x);
			states[STATE_Y].endInterval(n, y);
			
			return true; // TODO: Make this false!!
		}
		
		override public function render():void 
		{
			
		}
		
	}

}