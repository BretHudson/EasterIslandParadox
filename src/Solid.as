package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.utils.Draw;
	
	public class Solid extends Entity
	{
		
		public function Solid(x:int, y:int, w:int, h:int) 
		{
			super(x, y);
			setHitbox(w, h);
			type = "solid";
		}
		
		override public function render():void 
		{
			super.render();
			
			//Draw.hitbox(this, false, 0xFF00FF);
		}
		
	}

}