package  
{
	import adobe.utils.CustomActions;
	import flash.display.BitmapData;
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World
	import timeentities.Crate;
	import timeentities.Player;
	
	public class Level extends World
	{
		
		public static const GAME_WIDTH:int = 352;
		public static const GAME_HEIGHT:int = 176;
		
		private var hoveringOverGame:Boolean = false;
		
		private var numIntervals:int = 6;
		private var intervalsEntered:Vector.<int>;
		// TODO: private var intervalEnterOrder:Vector.<int>;
		
		private var timeEntities:Vector.<TimeEntity>;
		
		public var curInterval:int = 0;
		public var intervalHovering:int = -1;
		public var curFrame:int = 0;
		public var recording:Boolean = false;
		public var playbackSpeed:int = 0;
		
		private var screenshots:Vector.<Image>;
		private var screenshotsGrayscale:Vector.<Image>;
		private var screenshotrect:Rectangle;
		private var screenshotdata:BitmapData;
		private var screenshotgraydata:BitmapData;
		private var timeToTakeScreenshot:Boolean = false;
		
		private var snapshots:Vector.<Snapshot>;
		
		public function Level() 
		{
			initIntervals();
			initSnapshots();
			
			timeEntities = new Vector.<TimeEntity>();
			
			addTimeEntity(new Crate(20, 20, numIntervals));
			addTimeEntity(new Player(64, 48, numIntervals));
			
			camera.x = camera.y = -24;
		}
		
		private function initIntervals():void
		{
			intervalsEntered = new Vector.<int>();
			for (var i:int = 0; i < numIntervals; ++i)
			{
				intervalsEntered.push(0);
			}
		}
		
		private function initSnapshots():void
		{
			screenshotrect = new Rectangle(24, 24, GAME_WIDTH, GAME_HEIGHT);
			
			screenshots = new Vector.<Image>();
			screenshotsGrayscale = new Vector.<Image>();
			snapshots = new Vector.<Snapshot>();
			
			var padding:int = 4;
			var equalWidth:Number = (GAME_WIDTH - padding * 2) / numIntervals;
			var leftX:int = (GAME_WIDTH * 0.5) - equalWidth * (Number(numIntervals) * 0.5) + padding;
			
			// First get height and see if it's alright
			var snapshotWidth:int = equalWidth - (padding * 2);
			Snapshot.scale = snapshotWidth / GAME_WIDTH;
			var snapshotHeight:int = Math.round(Number(GAME_HEIGHT) * Snapshot.scale);
			
			var snapshot:Snapshot;
			for (var j:int = 0; j < numIntervals; ++j)
			{
				screenshots.push(null);
				screenshotsGrayscale.push(null);
				
				snapshot = new Snapshot(leftX + equalWidth * j, GAME_HEIGHT + 20);
				snapshot.setDimensions(snapshotWidth, snapshotHeight);
				add(snapshot);
				snapshots.push(snapshot);
				if (j == 0) Snapshot.selectedOne = snapshot;
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
			// TODO: Set everything to that interval
			
			recording = true;
			curFrame = curInterval * TimeState.FRAMES_PER_INTERVAL;
			
			intervalsEntered[curInterval] = 1;
			
			showFrame(curFrame);
			
			for (var i:int = 0; i < timeEntities.length; ++i)
			{
				timeEntities[i].active = true;
				//timeEntities[i].playback(curFrame);
			}
			
			// TODO: Make sure a paradox can't happen
			recordState(); // Record this state
		}
		
		public function recordState():void
		{
			++curFrame;
			
			for (var i:int = 0; i < timeEntities.length; ++i)
			{
				if (!timeEntities[i].recordState(curFrame))
				{
					// TODO: Add that entity to a list of entities that are in a paradox!
					trace(timeEntities[i].name, " in paradox");
				}
			}
			
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
		
		public function showFrame(frame:int):void
		{
			for (var i:int = 0; i < timeEntities.length; ++i)
			{
				timeEntities[i].playback(frame);
			}
		}
		
		public function showFrameAtInterval(interval:int):void
		{
			showFrame(interval * TimeState.FRAMES_PER_INTERVAL);
		}
		
		override public function update():void 
		{
			if (recording)
			{
				gameState();
			}
			else
			{
				thinkState();
			}
			
			super.update();
		}
		
		public function gameState():void
		{
			recordState();
			if (curFrame < (curInterval + 1) * TimeState.FRAMES_PER_INTERVAL)
				snapshots[curInterval].percentRecorded = (curFrame % TimeState.FRAMES_PER_INTERVAL) / TimeState.FRAMES_PER_INTERVAL;
			else
				snapshots[curInterval].percentRecorded = 1;
		}
		
		public function thinkState():void
		{
			// Get hovering info
			var hoveringOverSnapshot:Boolean = false;
			for (var i:int = 0; i < snapshots.length; ++i)
			{
				if (snapshots[i].mouseHover())
				{
					intervalHovering = i;
					hoveringOverSnapshot = true;
					
					curFrame = (i * TimeState.FRAMES_PER_INTERVAL) + 0;
					
					showFrame(curFrame);
				}
			}
			
			if (!hoveringOverSnapshot)
				intervalHovering = -1;
			
			var mouseX:int = Input.mouseX + camera.x;
			var mouseY:int = Input.mouseY + camera.y;
			hoveringOverGame = ((mouseX >= 0) && (mouseX < GAME_WIDTH) && (mouseY >= 0) && (mouseY < GAME_HEIGHT));
			
			// Get input
			if (Input.mousePressed)
			{
				if (intervalHovering != -1)
					curInterval = intervalHovering;
				
				if (hoveringOverGame)
				{
					beginRecording();
				}
			}
			
			if (playbackSpeed != 0)
			{
				curFrame = (curFrame + TimeState.FRAMES_PER_INTERVAL) % TimeState.FRAMES_PER_INTERVAL;
				
				for (var t:int = 0; t < timeEntities.length; ++t)
				{
					timeEntities[t].playback(curFrame + TimeState.FRAMES_PER_INTERVAL * curInterval);
				}
				
				curFrame += playbackSpeed;
			}
		}
		
		// TODO: New screenshot version where it takes a screenshot at certain states
		private function takeScreenshot(index:int):void
		{
			// When you take a screenshot, it goes into the /next/ index, so if you're at the last, you don't wanna take one!
			if (index >= numIntervals) return;
			
			// Craete normal image
			screenshotdata = new BitmapData(GAME_WIDTH, GAME_HEIGHT);
			screenshotdata.copyPixels(FP.buffer, screenshotrect, FP.zero);
			screenshots[index] = new Image(screenshotdata);
			
			// Create grayscale image
			screenshotgraydata = new BitmapData(GAME_WIDTH, GAME_HEIGHT);
			screenshotgraydata.copyPixels(FP.buffer, screenshotrect, FP.zero);
			Effects.grayscale(screenshotgraydata, screenshotgraydata.rect);
			screenshotsGrayscale[index] = new Image(screenshotgraydata);
			
			updateSnapshots();
		}
		
		private function updateSnapshots():void
		{
			var lastValidIndex:int = 0;
			
			for (var i:int = 0; i < screenshots.length; ++i)
			{
				if (screenshots[i] != null)
					lastValidIndex = i;
				
				snapshots[i].setScreenshot(screenshots[lastValidIndex], screenshotsGrayscale[lastValidIndex]);
			}
		}
		
		// TODO: Draw 
		override public function render():void 
		{
			// Screenshot background
			Draw.rect(0, GAME_HEIGHT, GAME_WIDTH, 300 - GAME_HEIGHT - 48, 0x000000);
			
			// Game area background
			if (hoveringOverGame)
			{
				Draw.rect(-4, -4, GAME_WIDTH + 8, GAME_HEIGHT + 8, 0x00FFFF);
			}
			
			Draw.rect(0, 0, GAME_WIDTH, GAME_HEIGHT, 0xFFFFFF);
			
			// Grid
			CONFIG::debug
			{
				var i:int = 0;
				
				var drawX:int = 0;
				var drawY:int = 0;
				for (i = 0; i < (GAME_WIDTH / 16) * (GAME_HEIGHT / 16); ++i)
				{
					drawX = i % (GAME_WIDTH / 16);
					drawY = (i / (GAME_WIDTH / 16));
					
					Draw.rect(drawX * 16, drawY * 16, 16, 16, (i % 2 == drawY % 2) ? 0xFF0000 : 0x0000FF);
				}
			}
			
			super.render();
			
			/*for (var i:int = 0; i < screenshots.length; ++i)
			{
				var drawPoint:Point = new Point(0, 225);
				drawPoint.x = i * (8 + GAME_WIDTH * Snapshot.scale);
				if (screenshots[i] != null)
					screenshots[i].render(FP.buffer, drawPoint, FP.camera);
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
			
			// TODO: Render missiles here
		}
		
	}

}