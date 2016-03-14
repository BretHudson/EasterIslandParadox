package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.utils.Draw;
	
	public class Solid extends Entity
	{
		
		public function Solid(x:int, y:int) 
		{
			super(x, y);
			setHitbox(16, 16);
			type = "solid";
		}
		
		override public function render():void 
		{
			super.render();
			
			Draw.hitbox(this, false, 0xFF00FF);
		}
		
	}

}