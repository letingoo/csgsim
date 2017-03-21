package common.component.OI_Follower
{
	import twaver.*;
	import twaver.network.ui.BasicAttachment;
	import twaver.network.ui.ElementUI;
	public class Optical_Interface_Attachment extends BasicAttachment
	{
		public function Optical_Interface_Attachment(elementUI:ElementUI, showInAttachmentCanvas:Boolean = false)
		{
			super(elementUI, showInAttachmentCanvas);
			this.content = usage;
		}
		private var _usage:Attachment_Optical_Interface=new Attachment_Optical_Interface();
		override public function updateProperties():void {
			super.updateProperties();
			var follower:Follower = Follower(this.element);
			usage.setValue(follower.getClient("used") as int);
		}
		
		override public function get position():String {
			return Consts.POSITION_LEFT;
		}
		
		override public function get xOffset():Number{
			return -16;
		}
		
		public function get usage():Attachment_Optical_Interface
		{
			return _usage;
		}

		public function set usage(value:Attachment_Optical_Interface):void
		{
			_usage = value;
		}

	}
}