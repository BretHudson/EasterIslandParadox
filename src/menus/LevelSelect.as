package menus 
{
	import net.flashpunk.Graphic;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	
	public class LevelSelect extends World
	{
		
		private var updateGraphics:Vector.<Graphic>;
		
		public function LevelSelect() 
		{
			updateGraphics = new Vector.<Graphic>();
			
			addGraphic(new LevelSelectItem(Assets.LEVEL1PREVIEW, 20, 20, Assets.LEVEL1), 0, 0, 0);
			addGraphic(new LevelSelectItem(Assets.LEVEL1PREVIEW, 80, 20, Assets.LEVEL2), 0, 0, 0);
		}
		
		override public function begin():void 
		{
			FP.screen.color = 0x202020;
		}
		
		override public function addGraphic(graphic:Graphic, layer:int = 0, x:int = 0, y:int = 0):Entity 
		{
			updateGraphics.push(graphic);
			
			return super.addGraphic(graphic, layer, x, y);
		}
		
		override public function update():void 
		{
			super.update();
			
			for (var i:int = 0; i < updateGraphics.length; ++i)
			{
				updateGraphics[i].update();
			}
		}
		
	}

}

import flash.display.BitmapData;
import flash.geom.Point;
import net.flashpunk.FP;
import net.flashpunk.graphics.Image;
import net.flashpunk.utils.Input;

class LevelSelectItem extends Image
{
	
	private var level:Class;
	
	public function LevelSelectItem(source:*, x:int, y:int, level:Class)
	{
		super(source);
		this.x = x;
		this.y = y;
		this.level = level;
	}
	
	override public function update():void 
	{
		super.update();
		
		if ((Input.mousePressed) && (mouseHover()))
		{
			FP.world = new Level(level);
		}
	}
	
	private function mouseHover():Boolean
	{
		return ((x <= Input.mouseX) && (x + width > Input.mouseX) && (y < Input.mouseY) && (y + height >= Input.mouseY));
	}
	
}