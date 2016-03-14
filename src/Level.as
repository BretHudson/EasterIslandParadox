package  
{
	import adobe.utils.CustomActions;
	import flash.display.BitmapData;
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.NumTween;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World
	import timeentities.Crate;
	import timeentities.Door;
	import timeentities.Player;
	
	public class Level extends World
	{
		
		public static const STATE_THINKING:int = 0;
		public static const STATE_PLAYBACK:int = 1;
		public static const STATE_UNDO:int = 2;
		public static const STATE_RECORDING:int = 3;
		public static const STATE_PARADOX:int = 4;
		
		public var state:int = STATE_THINKING;
		
		public static const GAME_WIDTH:int = 352;
		public static const GAME_HEIGHT:int = 176;
		
		private var hoveringOverGame:Boolean = false;
		
		public var numIntervals:int = 4;
		private var intervalsEntered:Vector.<int>;
		// TODO: private var intervalEnterOrder:Vector.<int>;
		
		private var timeEntities:Vector.<TimeEntity>;
		
		public var curInterval:int = 0;
		public var intervalHovering:int = -1;
		public var curFrame:int = 0;
		public var playbackSpeed:int = 0;
		
		private var screenshots:Vector.<Image>;
		private var screenshotsGrayscale:Vector.<Image>;
		private var screenshotrect:Rectangle;
		private var screenshotdata:BitmapData;
		private var screenshotgraydata:BitmapData;
		private var timeToTakeScreenshot:Boolean = false;
		
		private var snapshots:Vector.<Snapshot>;
		
		private var undoFirst:int = 0;
		private var undoLast:int = 300;
		private var lastFrameUndoed:int = 0;
		
		private var paradoxEntities:Vector.<TimeEntity>;
		
		private var doorMessenger:DoorMessenger;
		
		public var player:Player;
		private var curFrameIndex:int = 0;
		
		public function Level() 
		{
			FP.screen.color = 0xB6B6B6;
			
			initIntervals();
			initSnapshots();
			
			// Time entities
			timeEntities = new Vector.<TimeEntity>();
			addTimeEntity(new Crate(20, 20, numIntervals));
			
			// Doors
			doorMessenger = new DoorMessenger();
			addDoor(new Door(96, 144, numIntervals));
			
			doorMessenger.addMessage(30, 0);
			doorMessenger.addMessage(60, 0);
			
			// Player
			player = new Player(64, 48, numIntervals);
			player.active = false;
			add(player);
			
			// Other
			paradoxEntities = new Vector.<TimeEntity>();
			
			camera.x = camera.y = -24;
		}
		
		private function initIntervals():void
		{
			intervalsEntered = new Vector.<int>();
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
		
		public function addDoor(e:Door):Door
		{
			add(e);
			addTimeEntity(e);
			doorMessenger.addDoor(e);
			return e;
		}
		
		public function beginRecording():void
		{
			// TODO: Set everything to that interval
			
			state = STATE_RECORDING;
			curFrame = curInterval * TimeState.FRAMES_PER_INTERVAL;
			curFrameIndex = intervalsEntered.length * TimeState.FRAMES_PER_INTERVAL;
			
			intervalsEntered[intervalsEntered.length] = curInterval;
			
			showFrame(curFrame, curFrameIndex);
			
			setAllEntitiesActive(true);
			
			// TODO: Make sure a paradox can't happen
			recordState(false); // Record this state
		}
		
		public function recordState(checkForEnd:Boolean = true):void
		{
			for (var i:int = 0; i < timeEntities.length; ++i)
			{
				if (!timeEntities[i].recordState(curFrame))
				{
					// TODO: Add that entity to a list of entities that are in a paradox!
					paradoxEntities.push(timeEntities[i]);
					timeEntities[i].inParadox = true;
					trace(timeEntities[i].name, " in paradox", paradoxEntities.length);
				}
			}
			
			player.recordState(curFrameIndex);
			
			if (checkForEnd)
			{
				if (paradoxEntities.length > 0)
				{
					endRecording();
					state = STATE_PARADOX;
					return;
				}
				
				if (curFrame % TimeState.FRAMES_PER_INTERVAL == 0)
				{
					endRecording();
					return;
				}
			}
			
			++curFrame;
			++curFrameIndex;
			
			//trace(curFrameNum);
		}
		
		public function endRecording():void
		{
			state = STATE_THINKING;
			
			setAllEntitiesActive(false);
			
			timeToTakeScreenshot = true;
		}
		
		private function setAllEntitiesActive(active:Boolean):void
		{
			for (var i:int = 0; i < timeEntities.length; ++i)
			{
				timeEntities[i].active = active;
			}
			
			player.active = active;
		}
		
		public function showFrame(frame:int, frameIndex:int):void
		{
			for (var i:int = 0; i < timeEntities.length; ++i)
			{
				timeEntities[i].playback(frame);
			}
			
			player.playback(frameIndex);
		}
		
		public function showFrameAtInterval(interval:int):void
		{
			// TODO: This
			//showFrame(interval * TimeState.FRAMES_PER_INTERVAL);
		}
		
		override public function update():void 
		{
			super.update();
			
			switch (state)
			{
				case STATE_THINKING:
					thinkState();
					break;
				case STATE_PLAYBACK:
					break;
				case STATE_UNDO:
					undoState();
					break;
				case STATE_RECORDING:
					gameState();
					break;
				case STATE_PARADOX:
					paradoxState();
					break;
			}
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
					
					curFrameIndex = 0;
					for (var j:int = 0; j < intervalsEntered.length; ++j)
					{
						if (intervalsEntered[j] == i)
						{
							break;
						}
						curFrameIndex += TimeState.FRAMES_PER_INTERVAL;
					}
					
					showFrame(curFrame, curFrameIndex);
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
					// TODO: Make sure this interval hasn't been entered into before
					beginRecording();
				}
			}
			
			if (Input.pressed("undo"))
			{
				if (intervalsEntered.length > 0)
				{
					state = STATE_UNDO;
					undoFirst = intervalsEntered[intervalsEntered.length - 1] * TimeState.FRAMES_PER_INTERVAL;
					undoLast = undoFirst + TimeState.FRAMES_PER_INTERVAL;
					lastFrameUndoed = undoLast;
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
		
		private var undoTween:NumTween = null;
		private function undoState():void
		{
			if (undoTween == null)
			{
				var length:Number = 0.8 * ((undoLast - undoFirst) / TimeState.FRAMES_PER_INTERVAL);
				undoTween = new NumTween(undoDone, 0);
				undoTween.tween(undoLast, undoFirst, length, Ease.quintInOut);
				addTween(undoTween, true);
				curInterval = undoFirst / TimeState.FRAMES_PER_INTERVAL;
				Snapshot.selectedOne = snapshots[curInterval];
			}
			
			// Get the new current frame, fix snapshot percentage
			curFrame = undoTween.value;
			if (curFrame < (curInterval + 1) * TimeState.FRAMES_PER_INTERVAL)
				snapshots[curInterval].percentRecorded = (curFrame % TimeState.FRAMES_PER_INTERVAL) / TimeState.FRAMES_PER_INTERVAL;
			else
				snapshots[curInterval].percentRecorded = 1;
			
			if (curFrame < undoLast)
			{
				showFrame(curFrame, curFrameIndex);
			}
			
			// Undo all those frames
			while (lastFrameUndoed > curFrame)
			{
				undoFrame(lastFrameUndoed, curFrameIndex);
				--lastFrameUndoed;
				--curFrameIndex;
			}
		}
		
		private function undoDone():void
		{
			// Make sure you undo the first frame or else we're gonna have an issue potentially
			undoFrame(curFrame, curFrameIndex);
			removeTween(undoTween);
			undoTween = null;
			state = STATE_THINKING;
			intervalsEntered.pop();
		}
		
		private function undoFrame(frame:int, frameIndex:int):void
		{
			for (var i:int = 0; i < timeEntities.length; ++i)
			{
				timeEntities[i].undo(frame);
			}
			
			player.undo(frameIndex);
		}
		
		public function gameState():void
		{
			doorMessenger.update(curFrame);
			
			recordState();
			if (curFrame < (curInterval + 1) * TimeState.FRAMES_PER_INTERVAL)
				snapshots[curInterval].percentRecorded = (curFrame % TimeState.FRAMES_PER_INTERVAL) / TimeState.FRAMES_PER_INTERVAL;
			else
				snapshots[curInterval].percentRecorded = 1;
			
			if (Input.pressed("undo"))
			{
				// TODO: Figure out why this flashes
				--curFrame;
				--curFrameIndex;
				
				state = STATE_UNDO;
				undoFirst = curInterval * TimeState.FRAMES_PER_INTERVAL;
				undoLast = curFrame;
				lastFrameUndoed = undoLast;
				setAllEntitiesActive(false);
				return;
			}
		}
		
		private function paradoxState():void
		{
			// TODO: Undo
			if (Input.pressed("undo"))
			{
				state = STATE_UNDO;
				undoFirst = intervalsEntered[intervalsEntered.length - 1] * TimeState.FRAMES_PER_INTERVAL;
				undoLast = undoFirst + TimeState.FRAMES_PER_INTERVAL;
				lastFrameUndoed = undoLast;
				
				while (paradoxEntities.length)
				{
					var e:TimeEntity = paradoxEntities.pop();
					e.inParadox = false;
				}
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
			Draw.rect(0, GAME_HEIGHT, GAME_WIDTH, 300 - GAME_HEIGHT - 48, 0xFFFFFF);
			
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
			
			switch (state)
			{
				case STATE_THINKING:
				case STATE_PLAYBACK:
				case STATE_UNDO:
				case STATE_RECORDING:
					
				case STATE_PARADOX:
					renderParadox();
					break;
			}
			
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
			
			//Draw.text(curFrameIndex.toString(), 2, 2);
			
			// TODO: Render missiles here
		}
		
		private function renderParadox():void
		{
			//Draw.rect(FP.camera.x, FP.camera.y, FP.screen.width, FP.screen.height, 0xFF0000, Effects.getAlpha(1.0, 0.0, 0.5));
		}
		
	}

}