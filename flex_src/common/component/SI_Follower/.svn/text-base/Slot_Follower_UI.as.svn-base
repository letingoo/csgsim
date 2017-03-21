package common.component.SI_Follower
{
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	
	import twaver.Node;
	import twaver.network.Network;
	import twaver.network.ui.NodeUI;
	public class Slot_Follower_UI extends NodeUI
	{
		private var attachment:Slot_Attachment;
		public function Slot_Follower_UI(network:Network, node:Node)
		{
			super(network, node);
		}
		override public function checkAttachments():void {
			super.checkAttachments();
			if(attachment==null){
				attachment=new Slot_Attachment(this);
				this.addAttachment(attachment);
			}
			
		}
	}
}