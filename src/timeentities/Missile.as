package timeentities 
{
	import flash.display.Sprite;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Draw;
	
	public class Missile extends TimeEntity
	{
		
		protected static const STATE_ANGLE:int = NUM_BASE_STATES + 0;
		protected static const STATE_SPEED:int = NUM_BASE_STATES + 1;
		protected static const STATE_FRAME:int = NUM_BASE_STATES + 2;
		protected static const STATE_BEENLAUNCHED:int = NUM_BASE_STATES + 3;
		protected static const EXPLOSION_FRAME:int = NUM_BASE_STATES + 4;
		
		private var sprite:Spritemap;
		private var explosion:Spritemap;
		private var speed:Number = 0;
		public var hasBeenLaunched:int = 0;
		
		private var lineOfSight:Boolean = false;
		
		public var launcher:MissileLauncher;
		
		public function Missile(x:int, y:int, numIntervals:int, angle:Number) 
		{
			super(x, y, numIntervals);
			
			sprite = new Spritemap(Assets.MISSILE, 32, 32);
			sprite.angle = angle;
			sprite.add("play", [0, 1, 2, 3], 10);
			sprite.centerOO();
			sprites.add(sprite);
			
			explosion = new Spritemap(Assets.EXPLOSION, 64, 64);
			explosion.centerOO();
			explosion.add("nothing", [0], 1);
			explosion.add("explode", [1, 2, 3, 4, 5, 6, 0], 10, false);
			explosion.play("nothing");
			explosion.relative = false;
			sprites.add(explosion);
			
			setHitbox(10, 10, 6, 6);
			
			layer = -1;
			
			states.push(new TimeState(numIntervals, false));
			states.push(new TimeState(numIntervals, false));
			states.push(new TimeState(numIntervals, true));
			states.push(new TimeState(numIntervals, true));
			states.push(new TimeState(numIntervals, true));
			
			recordState(0);
			
			collidable = false;
		}
		
		public function launch(angle:Number):void
		{
			sprite.angle = angle;
			if (hasBeenLaunched == 0)
				collidable = true;
			hasBeenLaunched = 1;
			speed = 2.5;
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
				var turnAmount:Number = 5;
				var diff:Number = FP.angleDiff(sprite.angle, FP.DEG * angleToPlayer);
				diff = FP.clamp(diff, -turnAmount, turnAmount);
				sprite.angle += diff;
			}
			
			xstep = Math.cos(sprite.angle * FP.RAD);
			ystep = Math.sin(sprite.angle * FP.RAD);
			
			// TODO: Movement
			moveBy(xstep * speed, ystep * speed);
			
			if (collidable)
			{
				var e:Entity = collide("solid", x, y);
				if (e)
				{
					explode(x, y);
				}
				
				e = collide("crate", x, y);
				if (e)
				{
					(e as Crate).destroy();
					explode(e.x + 8, e.y + 8);
				}
				
				e = collide("player", x, y);
				if (e)
				{
					(e as Player).die();
					explode(e.x, e.y - 5);
				}
			}
		}
		
		private function explode(x:int, y:int):void
		{
			launcher.missileOnScreen = 0;
			speed = 0;
			explosion.x = x;
			explosion.y = y;
			if (collidable)
				explosion.play("explode");
			collidable = false;
		}
		
		override public function render():void 
		{
			if (speed != 0)
			{
				sprite.visible = true;
			}
			else
			{
				sprite.visible = false;
			}
			
			super.render();
		}
		
		override public function recordState(frame:int):Boolean 
		{
			var success:Boolean = super.recordState(frame);
			
			if (states.length > NUM_BASE_STATES)
			{
				if (!states[STATE_ANGLE].recordNumber(frame, sprite.angle))	success = false;
				if (!states[STATE_SPEED].recordNumber(frame, speed))		success = false;
				if (!states[STATE_FRAME].recordInt(frame, sprite.frame))	success = false;
				if (!states[STATE_BEENLAUNCHED].recordInt(frame, hasBeenLaunched))	success = false;
				if (!states[EXPLOSION_FRAME].recordInt(frame, explosion.frame))	success = false;
			}
			
			return success;
		}
		
		override public function playback(frame:int):void 
		{
			super.playback(frame);
			
			sprite.angle = states[STATE_ANGLE].playbackNumber(frame);
			speed = states[STATE_SPEED].playbackNumber(frame);
			sprite.frame = states[STATE_FRAME].playbackInt(frame);
			hasBeenLaunched = states[STATE_BEENLAUNCHED].playbackInt(frame);
			explosion.frame = states[EXPLOSION_FRAME].playbackInt(frame);
		}
		
	}

}