package 
{
	import net.flashpunk.FP;
	import net.flashpunk.World;
	
	public class Menu extends World
	{
		
		public function Menu() 
		{
			
		}
		
		override public function begin():void 
		{
			FP.world = new Level();
		}
		
	}

}