package  
{
	import timeentities.Door;
	
	public class DoorMessenger 
	{
	
		private var doors:Vector.<Door>;
		private var messages:Vector.<DoorMsg>;
		
		public function DoorMessenger() 
		{
			doors = new Vector.<Door>();
			messages = new Vector.<DoorMsg>();
		}
		
		public function update(frame:int):void
		{
			for (var i:int = 0; i < messages.length; ++i)
			{
				if (messages[i].frame == frame)
				{
					doors[messages[i].doorID].timeToToggle();
				}
			}
		}
		
		public function addDoor(door:Door):void
		{
			doors.push(door);
		}
		
		public function openCloseAtInterval(interval:int, doorID:int):void
		{
			trace("INTERVAL", interval);
			
			var offset:int = interval * TimeState.FRAMES_PER_INTERVAL;
			addMessage(offset + 15, doorID);
			addMessage(offset + TimeState.FRAMES_PER_INTERVAL - 15, doorID);
		}
		
		public function addMessage(frame:int, doorID:int):void
		{
			var msg:DoorMsg = new DoorMsg;
			msg.frame = frame;
			msg.doorID = doorID;
			messages.push(msg);
		}
		
	}

}

class DoorMsg
{
	public var frame:int;
	public var doorID:int;
}