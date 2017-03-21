package common.component.OI_Follower
{
	import twaver.Follower;

	public class Optical_Interface_Follower extends Follower
	{
		public function Optical_Interface_Follower(id:String)
		{
			super(id);
		}
		override public function get elementUIClass():Class {
			return Optical_Interface_Follower_UI;
		}
	}
}