package  
{
	import adobe.utils.CustomActions;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.MouseCursor;
	import menus.Button;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.TiledImage;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.tweens.misc.NumTween;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World
	import punk.fx.effects.GlitchFX;
	import punk.fx.effects.ScanLinesFX;
	import punk.fx.graphics.FXLayer;
	import timeentities.Crate;
	import timeentities.Door;
	import timeentities.Goal;
	import timeentities.Player;
	
	public class Level extends World
	{
		
		public static var paused:Boolean = false;
		
		public static const STATE_THINKING:int = 0;
		public static const STATE_PLAYBACK:int = 1;
		public static const STATE_UNDO:int = 2;
		public static const STATE_RECORDING:int = 3;
		public static const STATE_PARADOX:int = 4;
		public static const STATE_COMPLETE:int = 5;
		public static const STATE_DEAD:int = 6;
		
		public var state:int = STATE_THINKING;
		
		public static const GAME_WIDTH:int = 352;
		public static const GAME_HEIGHT:int = 176;
		private var gameAreaRect:Rectangle;
		
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
		
		private var fxLayer:FXLayer;
		private var scanlines:ScanLinesFX;
		private var noiseTween:NumTween;
		private var noiseSpeed:Number = 0.004;
		private var noiseMax:int = 35;
		
		private var id:int;
		
		public static var infoBox:InfoBox;
		
		private var gameBorder:Image;
		private var gameBorderPoint:Point;
		
		private var cloud_bg:TiledImage;
		private var cloud_x_start:int;
		
		public function Level(ogmoFile:Class, id:int) 
		{
			this.id = id;
			
			if (infoBox == null)
				infoBox = new InfoBox();
			
			initIntervals();
			
			// Time entities
			timeEntities = new Vector.<TimeEntity>();
			
			// Doors
			doorMessenger = new DoorMessenger();
			
			// Load stuff
			loadFromOgmo(ogmoFile);
			
			// Snapshots
			initSnapshots();
			
			// Other
			paradoxEntities = new Vector.<TimeEntity>();
			
			var glitchFX:GlitchFX = new GlitchFX(3, 4, 1);
			
			fxLayer = new FXLayer();
			fxLayer.effects.add(glitchFX);
			addGraphic(fxLayer);
			
			camera.x = camera.y = -24;
			
			scanlines = new ScanLinesFX(true);
			scanlines.scanLinesThickness = 2;
			scanlines.scanLinesGap = scanlines.scanLinesThickness * 2;
			gameAreaRect = new Rectangle(24, 24, GAME_WIDTH, GAME_HEIGHT);
			
			noiseTween = new NumTween();
			CONFIG::debug
			{
				scanlines.noiseAmount = 0;
			}
			CONFIG::release
			{
				noiseTween.value = noiseMax;
			}
			
			gameBorder = new Image(Assets.GAME_BORDER);
			gameBorderPoint = new Point( -24, -24);
			addGraphic(gameBorder, -10000, gameBorderPoint.x, gameBorderPoint.y);
			
			cloud_x_start = (((id * id)) * 100) / id;
			cloud_x_start %= 640;
			cloud_x_start *= -1;
			
			helpButton = Main.addIconsToWorld(this, 400 - 40, -20, 0x000000, 0x01FF78, true, true, true);
		}
		
		private var helpButton:Button;
		
		private function loadFromOgmo(ogmoLevel:Class):void
		{
			var ogmoXML:XML = FP.getXML(ogmoLevel);
			var node:XML;
			
			var offsetX:int = 0;
			var offsetY:int = 0;
			
			// Add outside border
			
			add(new Solid( -16, -16, GAME_WIDTH + 32, 16));
			add(new Solid( -16, GAME_HEIGHT, GAME_WIDTH + 32, 16));
			add(new Solid( -16, 0, 16, GAME_HEIGHT));
			add(new Solid( GAME_WIDTH, 0, 16, GAME_HEIGHT));
			
			// Level data
			numIntervals = int(ogmoXML.@intervals);
			
			// Background Tilemap
			// BGlayer
			var BGtilemapStr:String = ogmoXML.BGlayer;
			var BGtilemap:Tilemap = null;
			
			if (ogmoXML.Tilemap.@tileset == "Tilemap 1")
			{
				addGraphic(Image.createRect(GAME_WIDTH, GAME_HEIGHT, Assets.TILESET1COLOR));
				addGraphic(cloud_bg = new TiledImage(Assets.CLOUD_BG, 640 * 3, GAME_HEIGHT));
				BGtilemap = new Tilemap(Assets.TILESET1, Level.GAME_WIDTH, Level.GAME_HEIGHT, 16, 16);
			}
			
			if (BGtilemap)
			{
				BGtilemap.loadFromString(BGtilemapStr, ",");
				//Assets.tileset1.setTile(0, 0, 0);
				addGraphic(BGtilemap);
			}
			
			// Tilemap
			var tilemapStr:String = ogmoXML.Tilemap;
			var tilemap:Tilemap = null;
			
			if (ogmoXML.Tilemap.@tileset == "Tilemap 1")
			{
				tilemap = new Tilemap(Assets.TILESET1, Level.GAME_WIDTH, Level.GAME_HEIGHT, 16, 16);
			}
			
			if (tilemap)
			{
				tilemap.loadFromString(tilemapStr, ",");
				//Assets.tileset1.setTile(0, 0, 0);
				addGraphic(tilemap);
			}
			
			// Solids
			for each (node in ogmoXML.Entities.Solid)
			{
				add(new Solid(int(node.@x) + offsetX, int(node.@y) + offsetY, int(node.@width), int(node.@height)));
			}
			
			// Slopes
			for each (node in ogmoXML.Entities.SlopeLeft)
			{
				add(new Slope(int(node.@x) + offsetX, int(node.@y) + offsetY, -1));
			}
			for each (node in ogmoXML.Entities.SlopeRight)
			{
				add(new Slope(int(node.@x) + offsetX, int(node.@y) + offsetY, 1));
			}
			
			// Crates
			for each (node in ogmoXML.Entities.Crate)
			{
				addTimeEntity(new Crate(int(node.@x) + offsetX, int(node.@y) + offsetY, numIntervals));
			}
			
			// Doors
			var doorID:int = 0;
			for each (node in ogmoXML.Entities.Door)
			{
				addDoor(new Door(int(node.@x) + offsetX, int(node.@y) + offsetY, numIntervals));
				doorMessenger.openCloseAtInterval(int(node.@interval), doorID);
				++doorID;
			}
			
			// Missiles
			for each (node in ogmoXML.Entities.MissileLauncher)
			{
				addTimeEntity(new MissileLauncher(int(node.@x) + offsetX, int(node.@y) + offsetY, numIntervals));
			}
			
			// Goal
			for each (node in ogmoXML.Entities.Goal)
			{
				add(new Goal(ogmoXML.Entities.Goal.@x, ogmoXML.Entities.Goal.@y, numIntervals));
			}
			for each (node in ogmoXML.Entities.GoalOffset)
			{
				add(new Goal(int(ogmoXML.Entities.GoalOffset.@x) + 8, ogmoXML.Entities.GoalOffset.@y, numIntervals));
			}
			
			// Player
			player = new Player(int(ogmoXML.Entities.Player.@x) + offsetX, int(ogmoXML.Entities.Player.@y) + offsetY, numIntervals);
			player.active = false;
			add(player);
			
			var i:int = 0;
			i *= 2;
		}
		
		private function initIntervals():void
		{
			intervalsEntered = new Vector.<int>();
		}
		
		private function initSnapshots():void
		{
			screenshots = new Vector.<Image>();
			screenshotsGrayscale = new Vector.<Image>();
			snapshots = new Vector.<Snapshot>();
			
			var padding:int = 4;
			var equalWidth:Number = (GAME_WIDTH - padding * 2) / numIntervals;
			
			// First get height and see if it's alright
			var snapshotWidth:int = equalWidth - (padding * 2);
			Snapshot.scale = snapshotWidth / GAME_WIDTH;
			var snapshotHeight:int = Math.round(Number(GAME_HEIGHT) * Snapshot.scale);
			var maxHeight:int = 40;
			
			if (snapshotHeight > maxHeight)
			{
				snapshotHeight = maxHeight;
				Snapshot.scale = snapshotHeight / GAME_HEIGHT;
				snapshotWidth = Math.round(Number(GAME_WIDTH) * Snapshot.scale);
				equalWidth = snapshotWidth + (padding * 2);
			}
			
			var leftX:int = (GAME_WIDTH * 0.5) - equalWidth * (Number(numIntervals) * 0.5) + padding;
			
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
		
		override public function begin():void 
		{
			FP.screen.color = 0xB6B6B6; // TODO: Maybe make this just an image? Or a Draw call?
			
			MusicManager.playTrack(MusicManager.WORLD1);
		}
		
		private function noiseAdd():void
		{
			noiseTween.cancel();
			noiseTween.tween(scanlines.noiseAmount, noiseMax, noiseSpeed * (noiseMax - scanlines.noiseAmount));
			addTween(noiseTween, true);
		}
		
		private function noiseRemove():void
		{
			noiseTween.cancel();
			noiseTween.tween(scanlines.noiseAmount, 0, noiseSpeed * (scanlines.noiseAmount));
			addTween(noiseTween, true);
		}
		
		public function beginRecording():void
		{
			state = STATE_RECORDING;
			curFrame = curInterval * TimeState.FRAMES_PER_INTERVAL;
			curFrameIndex = intervalsEntered.length * TimeState.FRAMES_PER_INTERVAL;
			
			intervalsEntered[intervalsEntered.length] = curInterval;
			
			showFrame(curFrame, curFrameIndex);
			
			setAllEntitiesActive(true);
			
			recordState(false); // Record this state
			
			noiseRemove();
		}
		
		private function isPlayerDead(endFrame:Boolean):void
		{
			var dead:Boolean = false;
			
			if (endFrame)
				dead = (player.deadCount != -1);
			else
				dead = (player.deadCount == 0);
			
			if (dead)
			{
				noiseAdd();
				setAllEntitiesActive(false);
				state = STATE_DEAD;
			}
		}
		
		public function recordState(checkForEnd:Boolean = true):void
		{
			for (var i:int = 0; i < timeEntities.length; ++i)
			{
				if (!timeEntities[i].recordState(curFrame))
				{
					paradoxEntities.push(timeEntities[i]);
					timeEntities[i].inParadox = true;
					fxLayer.entities.add(timeEntities[i]);
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
					isPlayerDead(true);
					return;
				}
				
				if (curFrame % TimeState.FRAMES_PER_INTERVAL == 0)
				{
					endRecording();
					isPlayerDead(true);
					return;
				}
			}
			
			isPlayerDead(false);
			
			++curFrame;
			++curFrameIndex;
			
			//trace(curFrameNum);
		}
		
		public function endRecording():void
		{
			state = STATE_THINKING;
			
			setAllEntitiesActive(false);
			
			timeToTakeScreenshot = true;
			
			noiseAdd();
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
			if (interval < 0) return;
			
			curFrame = (interval * TimeState.FRAMES_PER_INTERVAL) + 0;
					
			curFrameIndex = 0;
			for (var j:int = 0; j < intervalsEntered.length; ++j)
			{
				if (intervalsEntered[j] == interval)
				{
					break;
				}
				curFrameIndex += TimeState.FRAMES_PER_INTERVAL;
			}
			
			showFrame(curFrame, curFrameIndex);
		}
		
		public function togglePause():void
		{
			paused = !paused;
		}
		
		override public function update():void 
		{
			Input.mouseCursor = MouseCursor.ARROW;
			
			if (Input.pressed("pause"))
				togglePause();
			
			for (var i:int = 0; i < buttons.length; ++i)
			{
				buttons[i].update();
			}
			
			if (paused)
			{
				if (Input.mousePressed)
					paused = false;
				trace("PAUSED");
				return;
			}
			
			if ((helpButton) && (helpButton.helpImage.alpha == 1))
			{
				helpButton.update();
				return;
			}
			
			if ((Main.idi.idnet) && (Main.idi.idnet.InterfaceOpen()))
			{
				return;
			}
			
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
				case STATE_COMPLETE:
					completeState();
					break;
				case STATE_DEAD:
					deadState();
					break;
			}
			
			if (Input.pressed("escape"))
			{
				FP.world = Main.levelSelect;
			}
			
			CONFIG::release
			{
				scanlines.noiseAmount = noiseTween.value;
			}
			fxLayer.update();
			
			infoBox.update();
			
			setCloudsPosition();
		}
		
		private function setCloudsPosition():void
		{
			cloud_bg.x = -(curFrame / 3) + cloud_x_start;
		}
		
		public function thinkState():void
		{
			// Get hovering info
			var hoveringOverSnapshot:Boolean = false;
			var selectedSnapshotIndex:int = -1;
			for (var i:int = 0; i < snapshots.length; ++i)
			{
				if (snapshots[i].mouseHover())
				{
					intervalHovering = i;
					hoveringOverSnapshot = true;
					
					showFrameAtInterval(i);
				}
				
				if (snapshots[i] == Snapshot.selectedOne)
					selectedSnapshotIndex = i;
			}
			
			if (!hoveringOverSnapshot)
			{
				intervalHovering = -1;
				//showFrameAtInterval(selectedSnapshotIndex);
			}
			else
				Input.mouseCursor = MouseCursor.BUTTON;
			
			var mouseX:int = Input.mouseX + camera.x;
			var mouseY:int = Input.mouseY + camera.y;
			hoveringOverGame = ((mouseX >= 0) && (mouseX < GAME_WIDTH) && (mouseY >= 0) && (mouseY < GAME_HEIGHT));
			
			if (hoveringOverGame)
				Input.mouseCursor = MouseCursor.BUTTON;
			
			// Get input
			if (Input.mousePressed)
			{
				if (intervalHovering != -1)
					curInterval = intervalHovering;
				
				if (hoveringOverGame)
				{
					var okayToEnter:Boolean = true;
					for (var ie:int = 0; ie < intervalsEntered.length; ++ie)
					{
						if (curInterval == intervalsEntered[ie])
						{
							okayToEnter = false;
							break;
						}
						
					}
					
					if (okayToEnter)
						beginRecording();
				}
			}
			
			if (Input.pressed("undo"))
			{
				// TODO: Figure out where we are in the current thing
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
				noiseRemove();
				var length:Number = (0.25 * TimeState.SECONDS_PER_INTERVAL) * ((undoLast - undoFirst) / TimeState.FRAMES_PER_INTERVAL);
				undoTween = new NumTween(undoDone, 0);
				undoTween.tween(undoLast, undoFirst, length, Ease.quintInOut);
				addTween(undoTween, true);
				curInterval = undoFirst / TimeState.FRAMES_PER_INTERVAL;
				
				curFrameIndex = (intervalsEntered.length - 1) * TimeState.FRAMES_PER_INTERVAL + (undoLast - undoFirst);
				
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
			
			noiseAdd();
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
					fxLayer.entities.remove(e);
				}
			}
		}
		
		private function completeState():void
		{
			FP.console.log("Level " + id + " complete!");
			if (id < Main.levelSelect.levelSelectItems.length)
				FP.world = new Level(Main.levelSelect.levelSelectItems[id].level, id + 1);
			else
				FP.world = Main.levelSelect;
			
			// TODO: Go to next level
		}
		
		private function deadState():void
		{
			if (Input.pressed("undo"))
			{
				/*//--curFrame;
				//--curFrameIndex;
				
				state = STATE_UNDO;
				undoFirst = curInterval * TimeState.FRAMES_PER_INTERVAL;
				undoLast = curFrame;
				lastFrameUndoed = undoLast;
				setAllEntitiesActive(false);
				return;*/
				
				
				
				state = STATE_UNDO;
				undoFirst = intervalsEntered[intervalsEntered.length - 1] * TimeState.FRAMES_PER_INTERVAL;
				undoLast = curFrame;
				lastFrameUndoed = undoLast;
				
				while (paradoxEntities.length)
				{
					var e:TimeEntity = paradoxEntities.pop();
					e.inParadox = false;
					fxLayer.entities.remove(e);
				}
			}
		}
		
		public function playerReachedGoal():void
		{
			SaveState.levelComplete(id, curFrameIndex);
			state = STATE_COMPLETE;
			setAllEntitiesActive(false);
			noiseAdd();
		}
		
		// TODO: New screenshot version where it takes a screenshot at certain states
		private function takeScreenshot(index:int):void
		{
			// When you take a screenshot, it goes into the /next/ index, so if you're at the last, you don't wanna take one!
			if (index >= numIntervals) return;
			
			// Craete normal image
			screenshotdata = new BitmapData(GAME_WIDTH, GAME_HEIGHT);
			screenshotdata.copyPixels(FP.buffer, gameAreaRect, FP.zero);
			screenshots[index] = new Image(screenshotdata);
			
			// Create grayscale image
			screenshotgraydata = new BitmapData(GAME_WIDTH, GAME_HEIGHT);
			screenshotgraydata.copyPixels(FP.buffer, gameAreaRect, FP.zero);
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
			
			super.render();
			
			if (screenshots[0] == null)
			{
				takeScreenshot(0);
			}
			
			if (timeToTakeScreenshot)
			{
				takeScreenshot(curInterval + 1);
				timeToTakeScreenshot = false;
			}
			
			switch (state)
			{
				case STATE_THINKING:
				case STATE_PLAYBACK:
				case STATE_UNDO:
				case STATE_RECORDING:
					break;
				case STATE_PARADOX:
					renderParadox();
					break;
			}
			
			// Game area background
			if ((hoveringOverGame) && (state == STATE_THINKING))
			{
				Draw.rectPlus(4, 4, GAME_WIDTH - 8, GAME_HEIGHT - 8, 0xF6FB60, 1, false, 4);
			}
			
			//Draw.text("Current Frame: " + curFrame + " " + curFrameIndex, 4, 4);
			
			// TODO: Fix noise/scanlines
			if ((!helpButton) || (helpButton.helpImage.alpha == 0))
				scanlines.applyTo(FP.buffer, gameAreaRect);
			
			//gameBorder.render(FP.buffer, gameBorderPoint, FP.camera);
			
			infoBox.render();
			
			if (paused)
			{
				Draw.rect(camera.x, camera.y, 400, 600, 0xFFFFFF, 0.4);
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