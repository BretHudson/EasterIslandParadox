package timeentities
{
	import flash.display.BlendMode;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.masks.Pixelmask;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	/**
	 * ...
	 * @author Bret Hudson
	 */
	public class Player extends TimeEntity
	{
		
		protected static const STATE_XSPEED:int = NUM_BASE_STATES + 0;
		protected static const STATE_YSPEED:int = NUM_BASE_STATES + 1;
		protected static const STATE_DOUBLE_JUMPED:int = NUM_BASE_STATES + 2;
		protected static const STATE_SCALEX:int = NUM_BASE_STATES + 3;
		protected static const STATE_FRAME:int = NUM_BASE_STATES + 4;
		protected static const STATE_ANTENNA_FRAME:int = NUM_BASE_STATES + 5;
		
		private var xspeed:Number = 0;
		private var yspeed:Number = 0;
		
		private var aspeed:Number = 0.5;
		private var fspeed:Number = 0.5;
		private var mspeed:Number = 2.0;
		
		private var gspeed:Number = 0.2;
		private var jspeed:Number = -4.2;
		private var djspeed:Number = -3.8;
		private var hasDoubleJumped:Boolean = true;
		private var jumpInputBuffering:int = 0;
		
		private var moveFrame:int = -1;
		
		private var sprite:Spritemap;
		private var antenna:Spritemap;
		
		private var inAir:Boolean = false;
		
		// TODO: Possibly create a state machine for that nifty antenna
		
		public function Player(x:int, y:int, numIntervals:int) 
		{
			super(x + 8, y + 8, numIntervals);
			
			sprite = new Spritemap(Assets.PLAYER, 16, 16);
			sprite.centerOO();
			sprite.add("roll", [0, 1, 2], 10);
			sprites.add(sprite);
			
			antenna = new Spritemap(Assets.ANTENNA, 16, 16);
			antenna.y = -16;
			antenna.centerOO();
			antenna.add("sit", [0]);
			antenna.add("roll", [0, 1, 2, 3], 10);
			antenna.add("stop", [4, 5, 6, 7, 0], 10, false);
			antenna.play("sit");
			antenna.update();
			sprites.add(antenna);
			
			//setHitbox(14, 16, 7, 8);
			// TODO: Make this better
			mask = new Pixelmask(Assets.PLAYERMASK, -8, -8);
			type = "player";
			
			states.push(new TimeState(numIntervals, false)); // XSPEED
			states.push(new TimeState(numIntervals, false)); // YSPEED
			states.push(new TimeState(numIntervals, true)); // DOUBLE_JUMPED
			states.push(new TimeState(numIntervals, true)); // SCALEX
			states.push(new TimeState(numIntervals, true)); // FRAME
			states.push(new TimeState(numIntervals, true)); // ANTENNA_FRAME
			
			recordState(0);
		}
		
		private function collideWithSolidY(yy:int):Entity
		{
			var e:Entity = null;
			e = collide("solid", x, yy)
			if (e)	return e;
			e = collide("crate", x, yy)
			if (e)	return e;
			return e;
		}
		
		// TODO: Jump input buffering!
		override public function update():void 
		{
			super.update();
			
			// Input
			var hdir:int = int(Input.check("right")) - int(Input.check("left"));
			
			// Horizontal movement
			if (hdir != 0)
			{
				antenna.scaleX = sprite.scaleX = hdir;
				xspeed = FP.clamp(xspeed + hdir, -mspeed, mspeed);
			}
			else
			{
				xspeed -= fspeed * FP.sign(xspeed);
			}
			
			// Apply gravity
			yspeed += gspeed;
			
			// Jump
			if (Input.pressed("jump"))
				jumpInputBuffering = 3;
			
			if ((!hasDoubleJumped) && (jumpInputBuffering > 0))
			{
				// TODO: Check if floor is within 2 frames
				
				//yspeed += djspeed;
				if (yspeed < 1.0)
				{
					yspeed = 0.0;
				}
				else if (yspeed < 2.0)
				{
					yspeed -= 1.0;
				}
				else
				{
					yspeed = 1.0;
				}
			
				Assets.Jump2.play();
				yspeed += djspeed;
				hasDoubleJumped = true;
				jumpInputBuffering = 0;
			}
			
			if ((jumpInputBuffering > 0) && (collideWithSolidY(y + 1)))
			{
				Assets.Jump1.play();
				yspeed = jspeed;
				hasDoubleJumped = false;
				jumpInputBuffering = 0;
			}
			
			// They hear me Squeakin'
			if ((xspeed != 0) && (collideWithSolidY(y + 1)))
			{
				sprite.play("roll");
				
				if (++moveFrame % 20 == 0)
				{
					switch (Math.floor(Math.random() * 3))
					{
						case 0: Assets.Squeak1.play(); break;
						case 1: Assets.Squeak2.play(); break;
						case 2: Assets.Squeak3.play(); break;
					}
				}
			}
			else
			{
				if ((xspeed == 0) && (antenna.currentAnim == "roll"))
				{
					antenna.play("stop");
				}
				sprite.frame = 0;
			}
			
			// Movement
			var xabs:int = Math.abs(xspeed);
			var xdir:int = FP.sign(xspeed);
			var crate:Crate;
			var xstop:Boolean = false;
			for (var xx:int = 0; xx < xabs; ++xx)
			{
				if (collide("solid", x, y + 1))
				{
					crate = collide("crate", x + xdir, y) as Crate;
					if ((crate) && (!crate.move(xdir)))
					{
						xstop = true;
						break;
					}
				}
				
				if ((!collide("solid", x + xdir, y)) && (!collide("crate", x + xdir, y)))
				{
					antenna.play("roll");
					x += xdir;
					if ((!inAir) && (!collide("solid", x + xdir, y + 1)) && (!collide("crate", x + xdir, y + 1)))
					{
						++y;
					}
				}
				else if ((!collide("solid", x + xdir, y - 2)) && (!collide("crate", x + xdir, y - 2)))
				{
					antenna.play("roll");
					x += xdir;
					--y;
				}
				else
				{
					xstop = true;
					break;
				}
			}
			
			if ((xstop) && (antenna.currentAnim == "roll"))
			{
				antenna.play("stop");
				xspeed = 0;
			}
			
			var yabs:int = Math.abs(yspeed);
			var ydir:int = FP.sign(yspeed);
			for (var yy:int = 0; yy < yabs; ++yy)
			{
				// TODO: Remove the second check
				if (!collideWithSolidY(y + ydir))
				{
					inAir = true;
					y += ydir;
				}
				else
				{
					if (yspeed > 0)
					{
						if (inAir)
						{
							inAir = false;
							Assets.landSynth.play();
						}
						hasDoubleJumped = true;
					}
					yspeed = 0;
					break;
				}
			}
			
			positionAntenna();
			
			// Collide with goal
			if (collide("goal", x, y))
			{
				Level(world).playerReachedGoal();
			}
			
			if (jumpInputBuffering > 0)
				--jumpInputBuffering;
		}
		
		private function positionAntenna():void
		{
			antenna.y = ((sprite.frame == 2) ? -15 : -16);
		}
		
		override public function recordState(frame:int):Boolean 
		{
			// TODO: Set frame = internalEnterCount * 60
			
			var success:Boolean = super.recordState(frame);
			
			if (states.length > NUM_BASE_STATES)
			{
				var dj:int = ((hasDoubleJumped) ? 1 : 0);
				if (!states[STATE_XSPEED].recordNumber(frame, xspeed))				success = false;
				if (!states[STATE_YSPEED].recordNumber(frame, yspeed))				success = false;
				if (!states[STATE_DOUBLE_JUMPED].recordInt(frame, dj))				success = false;
				if (!states[STATE_SCALEX].recordNumber(frame, sprite.scaleX))		success = false;
				if (!states[STATE_FRAME].recordInt(frame, sprite.frame))			success = false;
				if (!states[STATE_ANTENNA_FRAME].recordInt(frame, antenna.frame))	success = false;
			}
			
			return success;
		}
		
		override public function playback(frame:int):void 
		{
			super.playback(frame);
			
			xspeed = states[STATE_XSPEED].playbackNumber(frame);
			yspeed = states[STATE_YSPEED].playbackNumber(frame);
			hasDoubleJumped = (states[STATE_DOUBLE_JUMPED].playbackInt(frame) == 1);
			antenna.scaleX = sprite.scaleX = states[STATE_SCALEX].playbackNumber(frame);
			sprite.frame = states[STATE_FRAME].playbackInt(frame);
			antenna.frame = states[STATE_ANTENNA_FRAME].playbackInt(frame);
			
			positionAntenna();
		}
		
		override protected function renderParadox():void 
		{
			// TODO: Do nothing here for player :)
			
			super.renderParadox();
		}
		
	}

}