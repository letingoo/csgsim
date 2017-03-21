package sourceCode.wireConfiguration.actionscript
{
	import mx.collections.ArrayCollection;
	import twaver.*;
	import twaver.Node;
	import twaver.network.Network;

	[Embed(source="assets/images/wireConfiguration/DDF.png")]
	public static const panel_png:Class;
	public class DDFPanel
	{
		private var Port_Count:int;
		private var dataSource:ArrayCollection;
		
		public function setPortCount(value:int):void{
		  this.Port_Count = value;
		}
		public function getPortCount():int{
			return this.Port_Count;
		}
		
		public function setDataSource(datas:ArrayCollection):void{
			this.dataSource = datas;
		}
		
		public function getDataSource():ArrayCollection{
			return this.dataSource;
		}
		
		
		public function DDFPanel()
		{
			Utils.registerImageClass("panel_png",panel_png);
			var node:Node = new Node();
			node.setStyle(Styles.BACKGROUND_IMAGE,panel_png);
		}
	}
}