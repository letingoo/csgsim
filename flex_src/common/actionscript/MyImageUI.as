package  common.actionscript
{
	import twaver.Node;
	import twaver.network.Network;
	import twaver.network.ui.NodeUI;
	
	public class MyImageUI extends NodeUI
	{
		private var imgAttachment:ImageAttachment;
		
		public function MyImageUI(network:Network, node:Node)
		{
			super(network, node);
		}
		
		override public function checkAttachments():void{
			super.checkAttachments();
			if(imgAttachment == null){
				imgAttachment = new ImageAttachment(this);
				this.addAttachment(imgAttachment);
			}
		}
	}
}