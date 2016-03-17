package menus 
{
	import flash.ui.MouseCursor;
	import net.flashpunk.Graphic;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	
	public class LevelSelect extends World
	{
		
		public var levelSelectItems:Vector.<LevelSelectItem>;
		
		private var startX:int = 60;
		private var x:int = startX;
		private var y:int = 140;
		
		private var text:Text = new Text("Level Select");
		
		public function LevelSelect() 
		{
			levelSelectItems = new Vector.<LevelSelectItem>();
			
			var i:int = 0;
			add(new LevelSelectItem(x, y, i++, Assets.LEVEL1PREVIEW, Assets.LEVEL1));
			add(new LevelSelectItem(x, y, i++, Assets.LEVEL2PREVIEW, Assets.LEVEL2));
			add(new LevelSelectItem(x, y, i++, Assets.LEVEL3PREVIEW, Assets.LEVEL3));
			add(new LevelSelectItem(x, y, i++, Assets.LEVEL4PREVIEW, Assets.LEVEL4));
			
			add(new LevelSelectItem(x, y, i++, Assets.LEVEL5PREVIEW, Assets.LEVEL5));
			add(new LevelSelectItem(x, y, i++, Assets.LEVEL6PREVIEW, Assets.LEVEL6));
			add(new LevelSelectItem(x, y, i++, Assets.LEVEL7PREVIEW, Assets.LEVEL7));
			add(new LevelSelectItem(x, y, i++, Assets.LEVEL8PREVIEW, Assets.LEVEL8));
			
			text.size = 48;
			text.centerOO();
			text.x = 206;
			text.y = 80;
			addGraphic(text);
			
			Main.addIconsToWorld(this, 400 - 40 + 24 + 12, 8, 0xFFFFFF, 0x01FF78, false, true, false);
		}
		
		override public function add(e:Entity):Entity 
		{
			if (e is LevelSelectItem)
			{
				x += 80;
				if (x > startX + 260)
				{
					x = startX;
					y += 60;
				}
				levelSelectItems.push(e);
			}
			return super.add(e);
		}
		
		override public function begin():void 
		{
			trace("YO");
			FP.screen.color = 0x202020;
			MusicManager.playTrack(MusicManager.LEVELSELECT);
		}
		
		override public function update():void 
		{
			Input.mouseCursor = MouseCursor.ARROW;
			
			super.update();
			CONFIG::debug
			{
				if (Input.pressed("undo"))
				{
					SaveState.levelsCompleted = 100;
					FP.console.log("All levels unlocked");
				}
			}
			
			if (Input.pressed("escape"))
			{
				FP.world = Main.mainmenu;
			}
		}
		
	}

}