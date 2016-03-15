package 
{
	import flash.events.Event;
	import menus.LevelSelect;
	import menus.Menu;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	[SWF(width="800", height="600")]
	
	// TODO: Look into http://divillysausages.com/2011/04/04/as3-conditional-compilation-or-ifdef-in-flash/
	
	// TODO: Make it so the world is only offset by -8, -8
	// TODO: Make a "Slowdown" effect where you only update the entities every x frames
	[Frame(factoryClass = "Preloader")]
	public class Main extends Engine 
	{
		
		private var scale:int = 2;
		
		private var idi:IDI;
		
		public static var mainmenu:Menu;
		public static var levelSelect:LevelSelect;
		
		public function Main():void
		{
			super(800 / scale, 600 / scale, 60, false);
			FP.screen.scale = scale;
			FP.screen.color = 0x202020;
			
			FP.console.enable();
			
			Effects.init();
			
			defineControls();
			
			idi = new IDI();
			addChild(idi);
			
			mainmenu = new Menu();
			levelSelect = new LevelSelect();
			
			FP.world = new Level(Assets.LEVEL2);
			//FP.world = new Splash();
		}
		
		private var loggedIn:Boolean = false;
		private var listenersActivated:Boolean = false;
		
		override public function update():void 
		{
			if ((!loggedIn) && (idi.idnet))
			{
				loggedIn = true;
				//idi.idnet.toggleInterface('registration');
				
				//idi.idnet.achievementsSave(IDI.achievementThreeName, IDI.achievementThreeKey, '');
				//var achList:* = idi.idnet.achievementsList();
				//FP.console.log("GOT LIST");
			}
			
			if ((!listenersActivated) && (stage))
			{
				stage.addEventListener(Event.ACTIVATE, onActivate);
				stage.addEventListener(Event.DEACTIVATE, onDeactivate);
				listenersActivated = true;
				FP.console.log("YO");
			}
			
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
			
			Input.define("undo", Key.BACKSPACE);
		}
		
		private function onActivate(e:Event):void {
			//if (FP.world is Level)
				//Level.paused = false;
		}
		
		private function onDeactivate(e:Event):void {
			/*if (FP.world is Level)
				Level.paused = true;*/
		}
		
	}
	
}