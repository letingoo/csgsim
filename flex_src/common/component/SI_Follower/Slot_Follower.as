package common.component.SI_Follower
{
	import twaver.Follower;

	public class Slot_Follower extends Follower
	{
		public function Slot_Follower(id:Object=null)
		{
			super(id);
		}
		
		override public function get elementUIClass():Class {
			return Slot_Follower_UI;
		}
	}
}