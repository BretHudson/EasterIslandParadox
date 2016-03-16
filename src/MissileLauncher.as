package 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import timeentities.Missile;
	import timeentities.Player;
	
	public class MissileLauncher extends TimeEntity
	{
		
		protected static const STATE_ANGLE:Number = NUM_BASE_STATES + 0;
		protected static const STATE_ALPHA:Number = NUM_BASE_STATES + 1;
		protected static const STATE_LAUNCHED:Number = NUM_BASE_STATES + 2;
		
		private var sprite:Image;
		private var spriteDark:Image;
		private var spriteAlpha:Number = 0;
		
		private var shootTimeout:Number = -30;
		private var shootTimer:Number;
		
		public var missileOnScreen:int = 0;
		private var colorDull:uint = 0x222222;
		
		private var lineOfSight:Boolean = false;
		
		private var missiles:Vector.<Missile>;
		
		public function MissileLauncher(x:int, y:int, numIntervals:int) 
		{
			super(x, y, numIntervals);
			
			sprite = new Image(Assets.MISSILELAUNCHER);
			sprite.centerOO();
			sprites.add(sprite);
			
			spriteDark = new Image(Assets.MISSILELAUNCHERDARK);
			spriteDark.centerOO();
			sprites.add(spriteDark);
			
			setHitbox(1, 1);
			
			layer = -5;
			
			missiles = new Vector.<Missile>();
			var missile:Missile;
			for (var i:int = 0; i < numIntervals; ++i)
			{
				missile = new Missile(x, y, numIntervals, 0);
				missile.launcher = this;
				missiles.push(missile);
			}
			
			states.push(new TimeState(numIntervals, false));
			states.push(new TimeState(numIntervals, false));
			states.push(new TimeState(numIntervals, true));
			
			recordState(0);
		}
		
		override public function added():void 
		{
			for (var i:int = 0; i < missiles.length; ++i)
			{
				Level(world).addTimeEntity(missiles[i]);
			}
		}
		
		override public function update():void 
		{
			var player:Player = Level(world).player;
			
			var angleToPlayer:Number = Math.atan2(player.y - y, player.x - x);
			
			lineOfSight = true;
			var distance:Number = FP.distance(x, y, player.x, player.y);
			
			var xstep:Number = Math.cos(angleToPlayer);
			var ystep:Number = Math.sin(angleToPlayer);
			
			for (var i:int = 0; i < distance; i += 8)
			{
				if (collide("solid", x + xstep * i, y + ystep * i))
				{
					lineOfSight = false;
					break;
				}
			}
			
			if (lineOfSight)
			{
				var diff:Number = FP.angleDiff(sprite.angle, FP.DEG * angleToPlayer);
				diff *= 0.9;
				sprite.angle += diff;
				spriteAlpha = FP.approach(spriteAlpha, 0, 0.05);
				
				++shootTimer;
				if ((shootTimer >= 0) && (missileOnScreen == 0))
				{
					var missile:Missile = missiles[Level(world).curInterval];
					if (!missile.hasBeenLaunched)
					{	
						missileOnScreen = 1;
						shootTimer = shootTimeout;
						
						// TODO: Shoot the missile!
						missile.launch(sprite.angle);
					}
				}
			}
			else
			{
				shootTimer = shootTimeout;
				spriteAlpha = FP.approach(spriteAlpha, 1, 0.05);
			}
		}
		
		override public function render():void 
		{
			spriteDark.angle = sprite.angle;
			spriteDark.alpha = spriteAlpha;
			
			super.render();
		}
		
		override public function recordState(frame:int):Boolean 
		{
			var success:Boolean = super.recordState(frame);
			
			if (states.length > NUM_BASE_STATES)
			{
				if (!states[STATE_ANGLE].recordNumber(frame, sprite.angle))	success = false;
				if (!states[STATE_ALPHA].recordNumber(frame, spriteAlpha))	success = false;
				if (!states[STATE_LAUNCHED].recordInt(frame, missileOnScreen)) success = false;
			}
			
			return success;
		}
		
		override public function playback(frame:int):void 
		{
			super.playback(frame);
			
			spriteDark.angle = sprite.angle = states[STATE_ANGLE].playbackNumber(frame);
			spriteAlpha = states[STATE_ALPHA].playbackNumber(frame);
			missileOnScreen = states[STATE_LAUNCHED].playbackInt(frame);
		}
		
		/*void OrientSprite() {
			if ((Math.Abs(acceleration.X) > 0.0f) || (Math.Abs(acceleration.Y) > 0.0f)) {
				var newAngle = Util.RAD_TO_DEG * (float)Math.Atan2(-acceleration.Y, acceleration.X);
				var angleDiff = ((((newAngle - angle) % 360) + 540) % 360) - 180;
				var rotateAmount = Util.Clamp(angleDiff, -dirStepAmount, dirStepAmount);
				direction = Util.Rotate(direction, rotateAmount);
				angle = (float)Math.Atan2(-direction.Y, direction.X) * Util.RAD_TO_DEG;
			}
			sprite.Angle = angle - 90;
		}*/
		
	}

}