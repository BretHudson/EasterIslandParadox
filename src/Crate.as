package  
{
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	
	public class Crate extends TimeEntity
	{
		
		public function Crate(x:int, y:int, numStates:int) 
		{
			super(x, y, numStates);
		}
		
		override public function update():void 
		{
			if (Input.mousePressed)
			{
				x = Input.mouseX;
				y = Input.mouseY;
			}
		}
		
		override public function render():void 
		{
			Draw.rectPlus(x, y, 20, 20, 0xFF00FF);
		}
		
	}

}