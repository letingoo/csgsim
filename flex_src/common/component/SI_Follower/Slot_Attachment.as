package common.component.SI_Follower
{
	import mx.controls.Label;
	
	import twaver.*;
	import twaver.network.ui.BasicAttachment;
	import twaver.network.ui.ElementUI;
	public class Slot_Attachment extends BasicAttachment
	{
		public function Slot_Attachment(elementUI:ElementUI, showInAttachmentCanvas:Boolean = false)
		{
			super(elementUI, showInAttachmentCanvas);
			this.content = usagebar;
		}
		
		private var _usagebar:Attachment_Slot_Follower=new Attachment_Slot_Follower();

		override public function updateProperties():void {
			super.updateProperties();
			var follower:Follower = Follower(this.element);
			usagebar.setValue(follower.getClient("rate"));
		}
		
		override public function get position():String {
			return Consts.POSITION_CENTER;
		}
		
		override public function get xOffset():Number{
			return -20;
		}
		
		public function get usagebar():Attachment_Slot_Follower
		{
			return _usagebar;
		}

		public function set usagebar(value:Attachment_Slot_Follower):void
		{
			_usagebar = value;
		}

	}
}