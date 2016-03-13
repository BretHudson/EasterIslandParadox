package  
{
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Bret Hudson
	 */
	public class Effects 
	{
		
		private static const paradoxDarkColor:uint = 0xCCFFFFFF;
		private static const paradoxLightColor:uint = 0xFFFFFFFF;
		private static const paradoxLineSpacing:int = 2;
		private static var paradoxOffset:int = 0;
		public static var paradoxLines:BitmapData;
		
		private static var percentTransparentData:BitmapData;
		
		private static var updateCount:int = 0;
		
		public function Effects() 
		{
			
		}
		
		public static function init():void
		{
			paradoxLines = new BitmapData(Level.GAME_WIDTH, Level.GAME_HEIGHT, true, paradoxDarkColor);
			percentTransparentData = new BitmapData(Level.GAME_WIDTH, Level.GAME_HEIGHT, true, paradoxDarkColor);
			
			fillParadoxLines(0);
		}
		
		public static function update():void
		{
			++updateCount;
			
			if (updateCount % 30 == 0)
			{
				paradoxOffset = (paradoxOffset + 1) % (paradoxLineSpacing * 2);
				paradoxLines.scroll( -1, 0);
				//fillParadoxLines(paradoxOffset);
			}
		}
		
		private static function fillParadoxLines(xOffset:int):void
		{
			var rectToFill:Rectangle = new Rectangle(-xOffset, 0, paradoxLineSpacing, Level.GAME_HEIGHT);
			
			var fillsToDo:int = Level.GAME_WIDTH / (paradoxLineSpacing * 2) + 1;
			for (var i:int = 0; i < fillsToDo; ++i)
			{
				rectToFill.x += paradoxLineSpacing * 2;
				paradoxLines.fillRect(rectToFill, paradoxLightColor);
			}
		}
		
		private static const rc:Number = 0.3, gc:Number = 0.59, bc:Number = 0.11;
		public static function grayscale(source:BitmapData, rect:Rectangle):void
		{
			source.applyFilter(source, rect, new Point(), new ColorMatrixFilter([rc, gc, bc, 0, 0, rc, gc, bc, 0, 0, rc, gc, bc, 0, 0, 0, 0, 0, 1, 0]));
		}
		
		public static function getTransparentMaskWidth(width:int):BitmapData
		{
			percentTransparentData.floodFill(0, 0, 0x00FFFFFF);
			
			var rectToFill:Rectangle = new Rectangle(0, 0, width, Level.GAME_HEIGHT);
			percentTransparentData.fillRect(rectToFill, 0xFFFFFFFF);
			
			return percentTransparentData;
		}
		
		public static function getAlpha(speed:Number, offset:Number, min:Number, max:Number):Number
		{
			offset = FP.scale(offset, 0.0, 1.0, 0.0, Math.PI);
			return FP.scale(Math.abs(Math.cos(offset + Number(updateCount) * speed * 0.1)), 0.0, 1.0, min, max);
		}
		
	}

}