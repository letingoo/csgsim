package common.component.SI_Follower
{
	import mx.controls.Label;
	
	import twaver.*;
	import twaver.network.ui.BasicAttachment;
	import twaver.network.ui.ElementUI;
	public class VC12_Attachment extends BasicAttachment
	{
		public function VC12_Attachment(elementUI:ElementUI, showInAttachmentCanvas:Boolean = false)
		{
			super(elementUI, showInAttachmentCanvas);
			this.content=bearer_service;
		}
		private var _bearer_service:Attachment_VC12=new Attachment_VC12();
		
		override public function updateProperties():void {
			super.updateProperties();
			var follower:Follower = Follower(this.element);
			bearer_service.bearer_service.text=follower.getClient("YEWU");
		}
		
		
		public function get bearer_service():Attachment_VC12
		{
			return _bearer_service;
		}
		
		override public function get position():String{
			return Consts.POSITION_RIGHT;
		}
		
		public function set bearer_service(value:Attachment_VC12):void
		{
			_bearer_service = value;
		}

	}
}