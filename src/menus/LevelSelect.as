package menus 
{
	import net.flashpunk.Graphic;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	
	public class LevelSelect extends World
	{
		
		public var levelSelectItems:Vector.<LevelSelectItem>;
		
		public function LevelSelect() 
		{
			levelSelectItems = new Vector.<LevelSelectItem>();
			
			var i:int = 0;
			add(new LevelSelectItem(20, 20, i++, Assets.LEVEL1PREVIEW, Assets.LEVEL1));
			add(new LevelSelectItem(80, 20, i++, Assets.LEVEL2PREVIEW, Assets.LEVEL2));
			add(new LevelSelectItem(140, 20, i++, Assets.LEVEL3PREVIEW, Assets.LEVEL3));
			add(new LevelSelectItem(200, 20, i++, Assets.LEVEL4PREVIEW, Assets.LEVEL4));
			add(new LevelSelectItem(260, 20, i++, Assets.LEVEL5PREVIEW, Assets.LEVEL5));
		}
		
		override public function add(e:Entity):Entity 
		{
			levelSelectItems.push(e);
			return super.add(e);
		}
		
		override public function begin():void 
		{
			FP.screen.color = 0x202020;
			MusicManager.playTrack(MusicManager.LEVELSELECT);
		}
		
		override public function update():void 
		{
			super.update();
			CONFIG::debug
			{
				if (Input.pressed("undo"))
				{
					SaveState.levelsCompleted = 100;
					FP.console.log("All levels unlocked");
				}
			}
		}
		
	}

}