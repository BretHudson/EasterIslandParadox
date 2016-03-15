package 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Pixelmask;
	
	public class Slope extends Entity
	{
		
		public function Slope(x:int, y:int, dir:int) 
		{
			super(x, y);
			
			var m:Class = ((dir == -1) ? Assets.SLOPE_LEFT : Assets.SLOPE_RIGHT);
			mask = new Pixelmask(m);
			
			graphic = new Image(m);
			
			type = "solid";
		}
		
	}

}