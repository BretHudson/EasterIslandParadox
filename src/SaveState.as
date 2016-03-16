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
			
			submitTime(id - 1, frameCount);
		}
		
		public static function isLevelUnlockedBase0(id:int):Boolean
		{
			return id <= levelsCompleted;
		}
		
		private static function submitTime(id:int, frameCount:int):void
		{
			var score:Number = Number(frameCount) / 60.0;
			fastestTimes[id] = score;
			Main.idi.idnet.advancedScoreSubmitList(score * 1000, "Level " + String(id + 1) + " Highscores", "BretHudson", false, false, true);
			
			// TODO: Send it off
		}
		
	}

}