package common.component.EI_Follower
{
	import mx.controls.Label;
	
	import twaver.*;
	import twaver.network.ui.BasicAttachment;
	import twaver.network.ui.ElementUI;

	public class Electrical_Interface_Attachment extends BasicAttachment
	{
		public function Electrical_Interface_Attachment(elementUI:ElementUI, showInAttachmentCanvas:Boolean = false) 
		{
			super(elementUI, showInAttachmentCanvas);
			this.content = label;
		}
		
		private var _label:Attachment_Electrical_Interface=new Attachment_Electrical_Interface();


		override public function updateProperties():void {
			super.updateProperties();
			var follower:Follower = Follower(this.element);
			label.text=follower.getClient("profession");
		}
		
		override public function get position():String {
			return Consts.POSITION_BOTTOM;
		}

		override public function get direction():String {
			return Consts.ATTACHMENT_DIRECTION_BELOW;
		}
		
		override public function get outlineColor():Number {
			return 0xFCC561;
		}
		
		override public function get fill():Boolean {
			return true;
		}
		
		override public function get fillAlpha():Number {
			return 0.7;
		}
		
		override public function get fillColor():Number {
			return 0xFFFAF2;
		}
		
		override public function get gradient():String {
			return Consts.GRADIENT_LINEAR_SOUTH;
		}
		
		override public function get gradientAlpha():Number {
			return 0.7;
		}
		
		override public function get gradientColor():Number {
			return 0xFFF0D0;
		}
		
		override public function get outlineWidth():Number {
			return 0.5;
		}
		
		public function get label():Attachment_Electrical_Interface
		{
			return _label;
		}

		public function set label(value:Attachment_Electrical_Interface):void
		{
			_label = value;
		}

	}
}