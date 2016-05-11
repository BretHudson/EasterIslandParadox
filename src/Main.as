package 
{
	import flash.events.Event;
	import menus.Button;
	import menus.LevelSelect;
	import menus.Menu;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	[SWF(width="800", height="600")]
	
	// TODO: Look into http://divillysausages.com/2011/04/04/as3-conditional-compilation-or-ifdef-in-flash/
	
	
	// http://www.dafont.com/sd-auto-pilot.font?text=Easter+Island+Paradox SIGNS
	
	
	// TODO: Make it so the world is only offset by -8, -8
	// TODO: Make a "Slowdown" effect where you only update the entities every x frames
	[Frame(factoryClass = "Preloader")]
	public class Main extends Engine 
	{
		
		// Font
		[Embed(source = "assets/gabs_pixel.ttf", embedAsCFF = "false", fontFamily = "04B25")]
		public static const FONT:Class;
		
		private var scale:int = 2;
		
		public static var idi:IDI;
		
		public static var mainmenu:Menu;
		public static var levelSelect:LevelSelect;
		
		public function Main():void
		{
			super(800 / scale, 600 / scale, 60, false);
			FP.screen.scale = scale;
			FP.screen.color = 0x202020;
			
			CONFIG::debug
			{
				FP.console.enable();
			}
			
			Text.font = "04B25";
			Text.size = 12;
			
			Assets.init();
			Effects.init();
			MusicManager.init();
			SaveState.init();
			
			defineControls();
			
			idi = new IDI();
			//addChild(idi);
			
			mainmenu = new Menu();
			levelSelect = new LevelSelect();
			FP.world = new Splash();
			
			//FP.world = new Level(Assets.LEVEL2, 0);
		}
		
		private var loggedIn:Boolean = false;
		private var listenersActivated:Boolean = false;
		
		override public function update():void 
		{
			if ((!loggedIn) && (idi) && (idi.idnet))
			{
				//idi.idnet.autoLogin();
				
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
			}
			
			Effects.update();
			MusicManager.update();
			super.update();
		}
		
		public static function addIconsToWorld(world:World, x:int, y:int, tint:uint, hoverTint:uint, pause:Boolean, mute:Boolean, help:Boolean):Button
		{
			var offset:int = 24;
			
			var helpButton:Button;
			
			if (help)
			{
				x -= offset;
				helpButton = world.add(new Button(x, y, 2, tint, hoverTint)) as Button;
			}
			
			if (mute)
			{
				x -= offset;
				world.add(new Button(x, y, 1, tint, hoverTint));
			}
			
			if (pause)
			{
				x -= offset;
				world.add(new Button(x, y, 0, tint, hoverTint));
			}
			
			return helpButton;
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
			
			Input.define("pause", Key.P);
			//Input.define("mute", Key.M);
			
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