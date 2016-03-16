package 
{
	import net.flashpunk.graphics.Image;
	
	public class MissileLauncher extends TimeEntity
	{
		
		protected static const STATE_ANGLE:Number = NUM_BASE_STATES + 0;
		
		private var sprite:Image;
		
		public function MissileLauncher(x:int, y:int, numIntervals:int) 
		{
			super(x, y, numIntervals);
			
			
		}
		
	}

}	