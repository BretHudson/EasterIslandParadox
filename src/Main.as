package 
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	// TODO: Look into http://divillysausages.com/2011/04/04/as3-conditional-compilation-or-ifdef-in-flash/
	
	// TODO: Make it so the world is only offset by -8, -8
	// TODO: Make a "Slowdown" effect where you only update the entities every x frames
	
	public class Main extends Engine 
	{
		
		public function Main():void 
		{
			super(400, 300, 60, false);
			
			FP.screen.scale = 2;
			
			FP.console.enable();
			
			Effects.init();
			
			defineControls();
			
			FP.world = new Level();
		}
		
		override public function update():void 
		{
			Effects.update();
			super.update();
		}
		
		private function defineControls():void
		{
			// Directional keys
			Input.define("up", Key.UP, Key.W);
			Input.define("left", Key.LEFT, Key.A);
			Input.define("down", Key.DOWN, Key.S);
			Input.define("right", Key.RIGHT, Key.D);
			
			// Actions
			Input.define("enter", Key.ENTER);
			Input.define("escape", Key.ESCAPE);
			Input.define("jump", Key.UP, Key.W, Key.Z, Key.X, Key.SPACE);
		}
		
	}
	
}