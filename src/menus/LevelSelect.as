package menus 
{
	import net.flashpunk.Graphic;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	
	public class LevelSelect extends World
	{
		
		public function LevelSelect() 
		{
			add(new LevelSelectItem(20, 20, Assets.LEVEL1PREVIEW, Assets.LEVEL1));
			add(new LevelSelectItem(80, 20, Assets.LEVEL1PREVIEW, Assets.LEVEL2));
		}
		
		override public function begin():void 
		{
			FP.screen.color = 0x202020;
		}
		
	}

}