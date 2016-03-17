package menus 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.ui.MouseCursor;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;

	public class LevelSelectItem extends Entity
	{
		
		public var level:Class;
		private var id:int;
		private var image:Image;
		private var background:Image;
		private var color:uint;
		
		public function LevelSelectItem(x:int, y:int, id:int, source:*, level:Class)
		{
			super(x, y);
			
			this.id = id;
			
			image = new Image(source);
			width = image.width;
			height = image.height;
			
			background = Image.createRectBorder(width, height, 1);
			background.x = background.y = -1;
			graphic = new Graphiclist(background, image);
			
			image.color = background.color = color = 0x666666;
			
			this.level = level;
		}
		
		override public function update():void 
		{
			if (mouseHover())
			{
				if (image.color != 0x666666)
					Input.mouseCursor = MouseCursor.BUTTON;
			}
			
			if ((Input.mousePressed) && (mouseHover()) && (SaveState.isLevelUnlockedBase0(id)))
			{
				FP.world = new Level(level, id + 1);
			}
			
			color = ((SaveState.isLevelUnlockedBase0(id)) ? 0xFFFFFF : 0x666666);
			image.color = background.color = FP.colorLerp(background.color, color, 0.17);
		}
		
		private function mouseHover():Boolean
		{
			return ((x <= Input.mouseX) && (x + width > Input.mouseX) && (y < Input.mouseY) && (y + height >= Input.mouseY));
		}
		
	}

}