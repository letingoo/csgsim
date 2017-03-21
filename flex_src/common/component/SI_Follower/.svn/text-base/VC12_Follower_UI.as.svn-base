package common.component.SI_Follower
{
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	
	import twaver.Node;
	import twaver.network.Network;
	import twaver.network.ui.NodeUI;
	public class VC12_Follower_UI extends NodeUI
	{
		public function VC12_Follower_UI(network:Network, node:Node)
		{
			super(network, node);
		}
		
		private var attachment:VC12_Attachment;
		
		override public function checkAttachments():void {
			super.checkAttachments();
			if(attachment==null){
				attachment=new VC12_Attachment(this);
				this.addAttachment(attachment);
			}
			
		}
	}
}