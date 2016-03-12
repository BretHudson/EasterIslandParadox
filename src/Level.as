package  
{
	import adobe.utils.CustomActions;
	import flash.display.BitmapData;
	import flash.display.InteractiveObject;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World
	
	public class Level extends World
	{
		
		public static const GAME_WIDTH:int = 352;
		public static const GAME_HEIGHT:int = 176;
		
		private var numIntervals:int = 6;
		private var intervalsEntered:Vector.<int>;
		// TODO: private var intervalEnterOrder:Vector.<int>;
		
		private var timeEntities:Vector.<TimeEntity>;
		
		public var curInterval:int = 0;
		public var curFrame:int = 0;
		public var recording:Boolean = false;
		public var playbackSpeed:int = 0;
		public var playFrame:int = 0;
		
		private var screenshots:Vector.<Image>;
		private var screenshotsGrayscale:Vector.<Image>;
		private var screenshotrect:Rectangle;
		private var screenshotdata:BitmapData;
		private var timeToTakeScreenshot:Boolean = false;
		
		public function Level() 
		{
			intervalsEntered = new Vector.<int>();
			for (var i:int = 0; i < numIntervals; ++i)
			{
				intervalsEntered.push(0);
			}
			
			timeEntities = new Vector.<TimeEntity>();
			
			addTimeEntity(new Crate(20, 20, numIntervals)).active;
			
			camera.x = camera.y = -24;
			
			// Screenshot stuff
			screenshotrect = new Rectangle(24, 24, GAME_WIDTH, GAME_HEIGHT);
			screenshotdata = new BitmapData(GAME_WIDTH, GAME_HEIGHT);
			
			screenshots = new Vector.<Image>();
			screenshotsGrayscale = new Vector.<Image>();
			for (var j:int = 0; j < numIntervals; ++j)
			{
				screenshots.push(null);
				screenshotsGrayscale.push(null);
			}
		}
		
		public function addTimeEntity(e:TimeEntity):TimeEntity
		{
			add(e);
			timeEntities.push(e);
			e.active = false;
			return e;
		}
		
		public function beginRecording():void
		{
			recording = true;
			curFrame = curInterval * TimeState.FRAMES_PER_INTERVAL;
			
			intervalsEntered[curInterval] = 1;
			
			for (var i:int = 0; i < timeEntities.length; ++i)
			{
				timeEntities[i].active = true;
			}
		}
		
		public function recordState():void
		{
			for (var i:int = 0; i < timeEntities.length; ++i)
			{
				if (!timeEntities[i].recordState(curFrame))
				{
					// TODO: Add that entity to a list of entities that are in a paradox!
				}
			}
			
			++curFrame;
			
			if (curFrame % TimeState.FRAMES_PER_INTERVAL == 0)
			{
				endRecording();
			}
		}
		
		public function endRecording():void
		{
			recording = false;
			
			intervalsEntered[curInterval] = 2;
			
			for (var i:int = 0; i < timeEntities.length; ++i)
			{
				timeEntities[i].active = false;
			}
			
			timeToTakeScreenshot = true;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Input.pressed(Key.LEFT))	--curInterval;
			if (Input.pressed(Key.RIGHT))	++curInterval;
			
			curInterval = (curInterval + numIntervals) % numIntervals;
			
			if (Input.pressed(Key.ENTER))
			{
				beginRecording();
			}
			
			if (recording)
			{
				recordState();
			}
			
			if (Input.pressed(Key.P))
			{
				playbackSpeed = Math.abs(playbackSpeed - 1);
				curFrame = 0;
			}
			
			if (Input.pressed(Key.R))
			{
				playbackSpeed = -1;
				curFrame = 59;
			}
			
			if (playbackSpeed != 0)
			{
				curFrame = (curFrame + TimeState.FRAMES_PER_INTERVAL) % TimeState.FRAMES_PER_INTERVAL;
				
				for (var i:int = 0; i < timeEntities.length; ++i)
				{
					timeEntities[i].playback(curFrame + TimeState.FRAMES_PER_INTERVAL * curInterval);
				}
				
				curFrame += playbackSpeed;
			}
			
			/*if (Input.pressed(Key.A))
			{
				startInterval(curInterval);
			}
			
			if (Input.pressed(Key.S))
			{
				endInterval(curInterval);
			}*/
		}
		
		private static const rc:Number = 0.3, gc:Number = 0.59, bc:Number = 0.11;
		
		private function takeScreenshot(index:int):void
		{
			// When you take a screenshot, it goes into the /next/ index, so if you're at the last, you don't wanna take one!
			if (index >= numIntervals) return;
			
			screenshotdata.copyPixels(FP.buffer, screenshotrect, FP.zero);
			
			// Craete normal image
			screenshots[index] = new Image(screenshotdata);
			
			// Create grayscale image
			screenshotdata.applyFilter(screenshotdata, screenshotdata.rect, new Point(), new ColorMatrixFilter([rc, gc, bc, 0, 0, rc, gc, bc, 0, 0, rc, gc, bc, 0, 0, 0, 0, 0, 1, 0]));
			screenshotsGrayscale[index] = new Image(screenshotdata);
		}
		
		private var drawScreenshotPos:Point = new Point(0, 0);
		
		override public function render():void 
		{
			Draw.rect(0, 0, GAME_WIDTH, GAME_HEIGHT, 0xFFFFFF);
			
			var i:int = 0;
			
			var drawX:int = 0;
			var drawY:int = 0;
			for (i = 0; i < (GAME_WIDTH / 16) * (GAME_HEIGHT / 16); ++i)
			{
				drawX = i % (GAME_WIDTH / 16);
				drawY = (i / (GAME_WIDTH / 16));
				
				Draw.rect(drawX * 16, drawY * 16, 16, 16, (i % 2 == drawY % 2) ? 0xFF0000 : 0x0000FF);
			}
			
			Draw.rect(0, GAME_HEIGHT, GAME_WIDTH, 300 - GAME_HEIGHT - 48, 0xFFFFFF);
			
			super.render();
			
			/*CONFIG::debug
			{
				
			}*/
			
			if (screenshots[0] == null)
			{
				takeScreenshot(0);
			}
			
			if (timeToTakeScreenshot)
			{
				takeScreenshot(curInterval + 1);
				timeToTakeScreenshot = false;
			}
			
			var lastScreenshotIndex:int = 0;
			
			var imageWidth:int = (GAME_WIDTH / numIntervals) - 8;
			var imageScale:Number = Number(imageWidth) / Number(GAME_WIDTH);
			var imageHeight:int = imageWidth * GAME_HEIGHT / GAME_WIDTH;
			
			for (i = 0; i < numIntervals; ++i)
			{
				var alpha:Number = ((i === curInterval) ? 1 : 0.5);
				
				if (screenshots[i] != null)
					lastScreenshotIndex = i;
				
				drawScreenshotPos.x = 6 + (imageWidth + 8) * i;
				drawScreenshotPos.y = 200;
				
				if (i == curInterval)
					Draw.rect(drawScreenshotPos.x - 2, drawScreenshotPos.y - 2, imageWidth + 4, imageHeight + 4, 0xFFFF00);
				
				// Draw interval
				if (intervalsEntered[i] == 0)
				{
					screenshotsGrayscale[lastScreenshotIndex].scale = imageScale;
					screenshotsGrayscale[lastScreenshotIndex].alpha = 0.5;
					screenshotsGrayscale[lastScreenshotIndex].render(FP.buffer, drawScreenshotPos, FP.camera);
				}
				else if (intervalsEntered[i] == 1)
				{
					screenshotsGrayscale[lastScreenshotIndex].scale = imageScale;
					screenshotsGrayscale[lastScreenshotIndex].alpha = 1;
					screenshotsGrayscale[lastScreenshotIndex].render(FP.buffer, drawScreenshotPos, FP.camera);
				}
				else
				{
					screenshots[lastScreenshotIndex].scale = imageScale;
					screenshots[lastScreenshotIndex].render(FP.buffer, drawScreenshotPos, FP.camera);
				}
			}
		}
		
		/*public function startInterval(n:int):void
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
		}*/
		
	}

}