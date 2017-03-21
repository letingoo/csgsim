package  common.actionscript
{
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	import sourceCode.channelRoute.views.MyImage;
	
	import twaver.Follower;
	import twaver.network.ui.Attachment;
	import twaver.network.ui.BasicAttachment;
	import twaver.network.ui.ElementUI;
	
	public class ImageAttachment extends BasicAttachment
	{
		private var _img:MyImage;
		
		public function ImageAttachment(elementUI:ElementUI, showInAttachmentCanvas:Boolean=false)
		{
			super(elementUI, showInAttachmentCanvas);
			_img = new MyImage();
			_img.addEventListener(FlexEvent.CREATION_COMPLETE,comHandler);
			this.content = image;
			var f:Follower = Follower(this.element);
			image.setSource(f.getClient("source"));
		}
		
		private function comHandler(event:FlexEvent):void{
			var f:Follower = Follower(this.element);
			_img.width = int(f.getClient("width"));
			_img.height = int(f.getClient("height"));
		}
		
		public function get image():MyImage{
			return _img;
		}
		
		public function set image(value:MyImage):void{
			_img = value;
		}
	}
}