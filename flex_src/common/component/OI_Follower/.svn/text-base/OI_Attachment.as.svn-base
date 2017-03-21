package common.component.OI_Follower
{
	import mx.controls.ProgressBar;
	
	import twaver.*;
	import twaver.network.ui.BasicAttachment;
	import twaver.network.ui.ElementUI;

	public class OI_Attachment extends BasicAttachment
	{
		public function OI_Attachment(elementUI:ElementUI, showInAttachmentCanvas:Boolean = false)
		{
			super(elementUI, showInAttachmentCanvas);
			this.content=progress;
		}
		private var _progress:Attachment_OI=new Attachment_OI();
		override public function updateProperties():void {
			super.updateProperties();
			var follower:Follower = Follower(this.element);
			progress.setValue(follower.getClient("allvc4"),follower.getClient("usrvc4"),follower.getClient("usrvc12"),follower.getClient("rate"));
		}
		
		override public function get position():String {
			return Consts.POSITION_CENTER;
		}
		
		override public function get xOffset():Number{
			return -40;
		}
		
		override public function get yOffset():Number{
			return 9;
		}

		public function get progress():Attachment_OI
		{
			return _progress;
		}

		public function set progress(value:Attachment_OI):void
		{
			_progress = value;
		}

	}
}