package menus 
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
			FP.screen.color = 0x202020;
			MusicManager.playTrack(MusicManager.MENU);
			FP.world = Main.levelSelect;
		}
		
	}

}