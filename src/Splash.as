package 
{
	import menus.Menu;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	
	public class Splash extends World
	{
		
		public function Splash() 
		{
			FP.screen.color = 0x202020;
		}
		
		override public function begin():void 
		{
			FP.world = Main.mainmenu;
		}
		
	}

}