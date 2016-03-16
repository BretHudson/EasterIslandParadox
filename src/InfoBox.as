package 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	
	public class InfoBox extends Entity
	{
		
		private var sprite:Image;
		private var text:Text;
		
		public function InfoBox() 
		{
			sprite = new Image(Assets.TUTORIAL);
			text = new Text("Here's an info box! Here we will teach you things through text, the cheap method of game design, because we're pressed for time because this is a game jam!");
			trace(text.font);
			text.size = 12;
			text.x = 18;
			text.y = 16;
			text.smooth = false;
			text.wordWrap = true;
			text.width = 336;
			graphic = new Graphiclist(sprite, text);
			Graphiclist(graphic).visible = false;
			
			setHitbox(sprite.width, sprite.height);
			x = (400 - sprite.width) * 0.5 - 24;
			
			layer = -10000;
		}
		
		public function setFrame(frame:InfoFrame):void
		{
			
		}
		
	}

}