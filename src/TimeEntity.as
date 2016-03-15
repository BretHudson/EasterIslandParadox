package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Draw;
	
	public class TimeEntity extends Entity
	{
		
		protected var states:Vector.<TimeState>;
		
		protected static const STATE_X:int = 0;
		protected static const STATE_Y:int = 1;
		protected static const NUM_BASE_STATES:int = 2;
		
		// TODO: Refactor this so it's not just for Images (make a Graphiclist)
		protected var sprites:Graphiclist;
		public var inParadox:Boolean = false;
		
		public function TimeEntity(x:Number, y:Number, numIntervals:int) 
		{
			super(x, y);
			
			sprites = new Graphiclist();
			graphic = sprites;
			
			states = new Vector.<TimeState>();
			
			states.push(new TimeState(numIntervals, true)); // X
			states.push(new TimeState(numIntervals, true)); // Y
			
			recordState(0);
		}
		
		override public function update():void 
		{
			super.update();
		}
		
		override public function render():void 
		{
			var alphaSpeed:Number = 0.5;
			
			var i:int = 0;
			
			if (inParadox)
			{
				for (i = 0; i < sprites.children.length; ++i)
				{
					Image(sprites.children[i]).alpha = Effects.getAlpha(alphaSpeed, 0.0, 0.6, 1.0);
					Image(sprites.children[i]).color = 0xFF8888;
					Image(sprites.children[i]).drawMask = Effects.paradoxLines;
				}
			}
			
			super.render();
			
			if (inParadox)
			{
				for (i = 0; i < sprites.children.length; ++i)
				{
					Image(sprites.children[i]).alpha = Effects.getAlpha(alphaSpeed, 0.5, 0.6, 1.0);
					Image(sprites.children[i]).color = 0xFF8888;
					Image(sprites.children[i]).drawMask = Effects.paradoxLines;
				}
				renderParadox();
			}
			
			for (i = 0; i < sprites.children.length; ++i)
			{
				Image(sprites.children[i]).alpha = 1;
				Image(sprites.children[i]).color = 0xFFFFFF;
				Image(sprites.children[i]).drawMask = null;
				Image(sprites.children[i]).active = this.active;
			}
		}
		
		public function recordState(frame:int):Boolean
		{
			var success:Boolean = true;
			
			if (!states[STATE_X].recordInt(frame, x)) success = false;
			if (!states[STATE_Y].recordInt(frame, y)) success = false;
			
			return success;
		}
		
		public function playback(frame:int):void
		{
			x = states[STATE_X].playbackInt(frame);
			y = states[STATE_Y].playbackInt(frame);
		}
		
		public function undo(frame:int):void
		{
			for (var i:int = 0; i < states.length; ++i)
			{
				states[i].undo(frame);
			}
		}
		
		protected function renderParadox():void
		{
			var tempX:int = x;
			var tempY:int = y;
			
			x = states[STATE_X].playbackInt(Level(world).curFrame);
			y = states[STATE_Y].playbackInt(Level(world).curFrame);
			
			super.render();
			
			x = tempX;
			y = tempY;
		}
		
	}

}