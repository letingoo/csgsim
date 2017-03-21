package common.component.OI_Follower
{
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	
	import twaver.Node;
	import twaver.network.Network;
	import twaver.network.ui.NodeUI;
	public class OI_Followr_UI extends NodeUI
	{
		private var attachment:OI_Attachment;
		public function OI_Followr_UI(network:Network, node:Node)
		{
			super(network, node);
		}
		override public function checkAttachments():void {
			super.checkAttachments();
			attachment=new OI_Attachment(this);
			this.addAttachment(attachment);
		}
	}
}