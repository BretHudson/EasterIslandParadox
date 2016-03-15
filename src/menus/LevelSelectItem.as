package menus 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;

	public class LevelSelectItem extends Entity
	{
		
		private var level:Class;
		private var id:int;
		
		public function LevelSelectItem(x:int, y:int, id:int, source:*, level:Class)
		{
			super(x, y);
			
			this.id = id;
			
			var image:Image = new Image(source);
			width = image.width;
			height = image.height;
			var background:Image = Image.createRect(width  + 2, height + 2);
			background.x = background.y = -1;
			graphic = new Graphiclist(background, image);
			
			this.level = level;
		}
		
		override public function update():void 
		{
			if ((Input.mousePressed) && (mouseHover()))
			{
				FP.world = new Level(level, id + 1);
			}
		}
		
		private function mouseHover():Boolean
		{
			return ((x <= Input.mouseX) && (x + width > Input.mouseX) && (y < Input.mouseY) && (y + height >= Input.mouseY));
		}
		
	}

}