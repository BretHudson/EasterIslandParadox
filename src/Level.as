package  
{
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World
	
	public class Level extends World
	{
		
		private var numIntervals:int = 6;
		private var intervalsEntered:Vector.<int>;
		// TODO: private var intervalEnterOrder:Vector.<int>;
		
		public var curInterval:int = 0;
		
		private var timeEntities:Vector.<TimeEntity>;
		
		public function Level() 
		{
			intervalsEntered = new Vector.<int>();
			for (var i:int = 0; i < numIntervals; ++i)
			{
				intervalsEntered.push(0);
			}
			
			timeEntities = new Vector.<TimeEntity>();
			
			addTimeEntity(new Crate(20, 20, numIntervals));
		}
		
		public function addTimeEntity(e:TimeEntity):TimeEntity
		{
			add(e);
			timeEntities.push(e);
			return e;
		}
		
		public function startInterval(n:int):void
		{
			intervalsEntered[n] = 1;
			
			for (var i:int = 0; i < timeEntities.length; ++i)
			{
				if (!timeEntities[i].startInterval(n))
				{
					trace(timeEntities[999999].active);
				}
			}
		}
		
		public function endInterval(n:int):void
		{
			intervalsEntered[n] = 2;
			
			for (var i:int = 0; i < timeEntities.length; ++i)
			{
				if (!timeEntities[i].endInterval(n))
				{
					trace(timeEntities[999999].active);
				}
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Input.pressed(Key.LEFT))	--curInterval;
			if (Input.pressed(Key.RIGHT))	++curInterval;
			
			curInterval = (curInterval + numIntervals) % numIntervals;
			
			if (Input.pressed(Key.A))
			{
				startInterval(curInterval);
			}
			
			if (Input.pressed(Key.S))
			{
				endInterval(curInterval);
			}
		}
		
		override public function render():void 
		{
			super.render();
			
			/*CONFIG::debug
			{
				
			}*/
			
			for (var i:int = 0; i < numIntervals; ++i)
			{
				var alpha:Number = ((i === curInterval) ? 1 : 0.5);
				
				// Draw interval
				if (intervalsEntered[i] == 0)
					Draw.rectPlus(20 + 120 * i, 520, 100, 50, 0xFF0000, alpha);
				else if (intervalsEntered[i] == 1)
					Draw.rectPlus(20 + 120 * i, 520, 100, 50, 0xFFFF00, alpha);
				else
					Draw.rectPlus(20 + 120 * i, 520, 100, 50, 0x00FF00, alpha);
			}
		}
		
	}

}