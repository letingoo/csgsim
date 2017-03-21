package common.component.EI_Follower
{
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	
	import twaver.Node;
	import twaver.network.Network;
	import twaver.network.ui.NodeUI;

	public class Electrical_Interface_Follower_UI extends NodeUI
	{
		private var attachment:Electrical_Interface_Attachment;
		public function Electrical_Interface_Follower_UI(network:Network, node:Node) {
			super(network, node);
		}
		
		override public function checkAttachments():void {
			super.checkAttachments();
			if(this.node.getClient("profession")==""){
				if(attachment!=null){
					this.removeAttachment(attachment);
					attachment=null;
				}
			}else{
				if(attachment==null){
					attachment=new Electrical_Interface_Attachment(this);
					this.addAttachment(attachment);
				}
			}
		}
	}
}