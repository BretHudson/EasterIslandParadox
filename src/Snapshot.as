package  
{
	import flash.display.InteractiveObject;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	
	
	
	
	
	
	public class Snapshot extends Entity
	{
		
		// TODO: Draw time bar underneath
		// TODO: Center all snapshots!
		
		public static var scale:Number;
		
		public var percentRecorded:Number = 0;
		
		private var graphiclist:Graphiclist;
		private var colorImage:Image;
		private var grayscaleImage:Image;
		
		public static var selectedOne:Snapshot;
		
		private var listeningToMouse:Boolean = false;
		
		public function Snapshot(x:int, y:int)
		{
			super(x, y);
			
			graphiclist = new Graphiclist();
			graphic = graphiclist;
			
			layer = 100;
		}
		
		override public function update():void 
		{
			listeningToMouse = Level(world).state == Level.STATE_THINKING;
			
			if ((listeningToMouse) && (Input.mousePressed) && (mouseHover()))
			{
				selectedOne = this;
			}
		}
		
		public function setDimensions(width:int, height:int):void
		{
			setHitbox(width, height);
		}
		
		public function mouseHover():Boolean
		{
			return collidePoint(x, y, Input.mouseX + world.camera.x, Input.mouseY + + world.camera.y);
		}
		
		public function setScreenshot(color:Image, grayscale:Image):void
		{
			graphiclist.removeAll();
			
			colorImage = color;
			grayscaleImage = grayscale;
			
			graphiclist.add(grayscaleImage);
			graphiclist.add(colorImage);
			color.scale = grayscale.scale = scale;
		}
		
		private static const border:int = 2;
		
		override public function render():void 
		{
			if (selectedOne == this)
				Draw.rect(x - border, y - border, width + border * 2, height + border * 2, 0x008800);
			else if ((listeningToMouse) && (mouseHover()))
				Draw.rect(x - border, y - border, width + border * 2, height + border * 2, 0xFFFF00);
			
			if (graphiclist.count >= 1)
			{
				colorImage.drawMask = Effects.getTransparentMaskWidth(Level.GAME_WIDTH * percentRecorded);
			}
			
			super.render();
		}
		
	}

}