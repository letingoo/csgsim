package common.component.OI_Follower
{
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	
	import twaver.Node;
	import twaver.network.Network;
	import twaver.network.ui.NodeUI;
	public class Optical_Interface_Follower_UI extends NodeUI
	{
		private var attachment:Optical_Interface_Attachment;
		public function Optical_Interface_Follower_UI(network:Network, node:Node) {
			super(network, node);
		}
		
		override public function checkAttachments():void {
			super.checkAttachments();
			attachment=new Optical_Interface_Attachment(this);
			this.addAttachment(attachment);
		}
	}
}