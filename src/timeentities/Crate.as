package timeentities
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	
	public class Crate extends TimeEntity
	{
		
		public function Crate(x:int, y:int, numIntervals:int) 
		{
			super(x, y, numIntervals);
			
			// TODO: Put other things here!
			
			sprite = Image.createRect(20, 20);
			graphic = sprite;
			
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
		
		override public function recordState(frame:int):Boolean 
		{
			var success:Boolean = super.recordState(frame);
			
			// ??
			
			return success;
		}
		
	}

}