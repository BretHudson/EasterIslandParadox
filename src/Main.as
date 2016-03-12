package 
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	// TODO: Look into http://divillysausages.com/2011/04/04/as3-conditional-compilation-or-ifdef-in-flash/
	
	// TODO: Little bitmap imagse
	
	public class Main extends Engine 
	{
		
		public function Main():void 
		{
			super(800, 600, 60, false);
			
			FP.console.enable();
			
			FP.world = new Level();
		}
		
	}
	
}