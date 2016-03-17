package 
{
	import net.flashpunk.FP;
	
	public class SaveState 
	{
		
		private static var fastestTimes:Vector.<Number>;
		
		public static function init():void
		{
			fastestTimes = new Vector.<Number>();
			for (var i:int = 0; i < Assets.NUMLEVELS; ++i)
			{
				fastestTimes[i] = -1.0;
			}
		}
		
		public static var levelsCompleted:int = 0;
		public static function levelComplete(id:int, frameCount:int):void
		{
			if (levelsCompleted < id)
			{
				levelsCompleted = id;
			}
			
			if (Main.idi.idnet)
			{
				if (id == 4)
				{
					Main.idi.idnet.achievementsSave(IDI.achievement1Name, IDI.achievement1Key, '');
				}
				else if (id == 8)
				{
					Main.idi.idnet.achievementsSave(IDI.achievement2Name, IDI.achievement2Key, '');
				}
			}
			
			submitTime(id - 1, frameCount);
		}
		
		public static function isLevelUnlockedBase0(id:int):Boolean
		{
			return id <= levelsCompleted;
		}
		
		private static function submitTime(id:int, frameCount:int):void
		{
			if (Main.idi.idnet)
			{
				var score:Number = Number(frameCount) / 60.0;
				fastestTimes[id] = score;
				var name:String = null;
				
				if (Main.idi.idnet.isLoggedIn)
				{
					name = Main.idi.idnet.userData.nickname;
				}
				
				Main.idi.idnet.advancedScoreSubmitList(score * 1000, "Level " + String(id + 1) + " Highscores", name, false, false, true);
			}
			
			// TODO: Send it off
		}
		
	}

}