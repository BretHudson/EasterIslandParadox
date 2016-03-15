package 
{
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Bret Hudson
	 */
	public class SaveState 
	{
		
		public static var levelsCompleted:int = 0;
		public static function levelComplete(id:int):void
		{
			if (levelsCompleted < id)
			{
				levelsCompleted = id;
			}
		}
		
		public static function isLevelUnlockedBase0(id:int):Boolean
		{
			return id <= levelsCompleted;
		}
		
	}

}