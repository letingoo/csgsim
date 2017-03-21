package common.component.OI_Follower
{
	import twaver.Follower;

	public class OI_Follower extends Follower
	{
		public function OI_Follower(id:String)
		{
			super(id);
		}
		override public function get elementUIClass():Class {
			return OI_Followr_UI;
		}
	}
}