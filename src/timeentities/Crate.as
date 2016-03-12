package timeentities
{
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	
	public class Crate extends TimeEntity
	{
		
		public function Crate(x:int, y:int, numIntervals:int) 
		{
			super(x, y, numIntervals);
			
			// TODO: Put other things here!
			
			name = "crate";
			
			recordState(0);
		}
		
		override public function update():void 
		{
			//if (Input.mousePressed)
			++x;
			{
				//x = Input.mouseX - 24;
				//y = Input.mouseY - 24;
			}
		}
		
		override public function render():void 
		{
			Draw.rectPlus(x, y, 20, 20, 0xFFFFFF);
		}
		
		override public function recordState(frame:int):Boolean 
		{
			var success:Boolean = super.recordState(frame);
			
			// ??
			
			return success;
		}
		
	}

}