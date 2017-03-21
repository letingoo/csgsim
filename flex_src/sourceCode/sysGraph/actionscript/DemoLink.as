package sourceCode.sysGraph.actionscript
{
	import twaver.*;
	
	public class DemoLink extends Link
	{
		public function DemoLink(id:Object=null, fromNode:Node=null, toNode:Node=null)
		{
			super(id, fromNode, toNode);
			this.setClient("alpha", 255);
			this.setClient("flowingOffset", 0);
			this.setClient("status", "normal");
//			this.setStyle(Styles.LINK_COLOR, 0x4CAC39);
//			this.setStyle(Styles.LINK_WIDTH, 2);
//			this.setStyle(Styles.LINK_BUNDLE_EXPANDED,true);
//			this.setStyle(Styles.LINK_TYPE,Consts.LINK_TYPE_ORTHOGONAL_VERTICAL);
//			this.setStyle(Styles.ARROW_FROM_XOFFSET, 10);
			
			
//			this.setStyle(Styles.ARROW_TO, true);
//			this.setStyle(Styles.ARROW_TO_COLOR, 0x4CAC39);
//			this.setStyle(Styles.ARROW_TO_SHAPE, Consts.ARROW_DELTA);
//			this.setStyle(Styles.ARROW_TO_HEIGHT, 12);
//			this.setStyle(Styles.ARROW_TO_WIDTH, 8);
//			this.setStyle(Styles.ARROW_TO_XOFFSET, -3);
		}
		
		override public function get elementUIClass():Class
		{
			return DemoLinkUI;
		}
	}
}