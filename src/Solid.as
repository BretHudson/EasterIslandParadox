package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	
	public class Solid extends Entity
	{
		
		public function Solid(x:int, y:int, w:int, h:int) 
		{
			super(x, y);
			setHitbox(w, h);
			type = "solid";
			
			layer = -100;
			
			graphic = Image.createRect(w, h, 0xFF00FF, 1.0);
		}
		
	}

}