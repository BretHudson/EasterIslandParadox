package
{
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import net.flashpunk.FP;

	[SWF(width = "800", height = "600")]
	public class Preloader extends Sprite
	{
		// Change these values
		private static const mustClick: Boolean = false;
		private static const mainClassName: String = "Main";
		
		private static const BG_COLOR:uint = 0x202020;
		private static const FG_COLOR:uint = 0xFFFFFF;
		
		[Embed(source = 'assets/04b_25__.TTF', embedAsCFF = "false", fontFamily = 'default')]
		private static const FONT:Class;
		
		[Embed(source = "assets/gfx/rollie.png")]
		private static const ROLLIE:Class;
		private var rollieBitmap:Bitmap;
		
		[Embed(source = "assets/gfx/antenna.png")]
		private static const ANTENNA:Class;
		private var antennaBitmap:Bitmap;
		
		private var display:Bitmap;
		private var frameRect:Rectangle;
		private var frameRect2:Rectangle;
		private var drawPoint:Point;// = new Point(10, 10);
		private var drawIndex:int = 0;
		private var imageScale:int = 15;
		
		private var pushDown:int = 190;
		
		// Ignore everything else
		
		
		
		private var progressBar: Shape;
		private var text: TextField;
		
		private var px:int;
		private var py:int;
		private var w:int;
		private var h:int;
		private var sw:int;
		private var sh:int;
		public static var rt:LoaderInfo;
		
		public function Preloader ()
		{
			//drawPoint = new Point((800 - (16 * imageScale)) * 0.5, 100);
			drawPoint = new Point();
			display = new Bitmap(new BitmapData(16, 32, true, BG_COLOR));
			display.scaleX = display.scaleY = imageScale;
			display.x = (800 - (16 * imageScale)) * 0.5;
			display.y = -40;
			addChild(display);
			
			rollieBitmap = new ROLLIE();
			rollieBitmap.scaleX = rollieBitmap.scaleY = imageScale;
			frameRect = new Rectangle(0, 0, 16, 16);
			
			antennaBitmap = new ANTENNA();
			antennaBitmap.scaleX = antennaBitmap.scaleY = imageScale;
			frameRect2 = new Rectangle(0, 0, 16, 16);
			
			rt = root.loaderInfo;
			sw = stage.stageWidth;
			sh = stage.stageHeight;
			
			w = stage.stageWidth * 0.8;
			h = 20;
			
			px = (sw - w) * 0.5;
			py = (sh - h) * 0.5 + pushDown;
			
			graphics.beginFill(BG_COLOR);
			graphics.drawRect(0, 0, sw, sh);
			graphics.endFill();
			
			graphics.beginFill(FG_COLOR);
			graphics.drawRect(px - 2, py - 2, w + 4, h + 4);
			graphics.endFill();
			
			progressBar = new Shape();
			
			addChild(progressBar);
			
			text = new TextField();
			
			text.textColor = FG_COLOR;
			text.selectable = false;
			text.mouseEnabled = false;
			text.defaultTextFormat = new TextFormat("default", 24);
			text.embedFonts = true;
			text.autoSize = "left";
			text.text = "0%";
			text.x = (sw - text.width) * 0.5;
			text.y = sh * 0.5 + h + pushDown;
			
			addChild(text);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			if (mustClick) {
				stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
		}

		public function onEnterFrame (e:Event): void
		{
			display.bitmapData.floodFill(0, 0, BG_COLOR);
			drawPoint.y = ((frameRect.x != 32) ? 0 : 1);
			display.bitmapData.copyPixels(antennaBitmap.bitmapData, frameRect2, drawPoint);
			drawPoint.y = 16;
			display.bitmapData.copyPixels(rollieBitmap.bitmapData, frameRect, drawPoint);
			
			if (++drawIndex % 12 == 0)
			{
				frameRect.x = (frameRect.x + 16) % (16 * 3);
				frameRect2.x = (frameRect2.x + 16) % (16 * 4);
			}
			
			if (hasLoaded())
			{
				if (! mustClick) {
					startup();
				} else {
					text.scaleX = 2.0;
					text.scaleY = 2.0;
				
					text.text = "Click to start";
			
					text.y = (sh - text.height) * 0.5;
				}
			} else {
				var p:Number = (loaderInfo.bytesLoaded / loaderInfo.bytesTotal);
				
				progressBar.graphics.clear();
				progressBar.graphics.beginFill(BG_COLOR);
				progressBar.graphics.drawRect(px, py, p * w, h);
				progressBar.graphics.endFill();
				
				text.text = int(p * 100) + "%";
			}
			
			text.x = (sw - text.width) * 0.5;
		}
		
		private function onMouseDown(e:MouseEvent):void {
			if (hasLoaded())
			{
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				startup();
			}
		}
		
		private function hasLoaded (): Boolean {
			return (loaderInfo.bytesLoaded >= loaderInfo.bytesTotal);
		}
		
		private function startup (): void {
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			var mainClass:Class = getDefinitionByName(mainClassName) as Class;
			parent.addChild(new mainClass as DisplayObject);
			
			parent.removeChild(this);
		}
	}
}