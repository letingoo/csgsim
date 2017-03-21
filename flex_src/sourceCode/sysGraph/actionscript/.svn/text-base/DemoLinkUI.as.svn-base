package sourceCode.sysGraph.actionscript
{
	import flash.display.*;
	import flash.geom.*;
	
	import twaver.*;
	import twaver.network.*;
	import twaver.network.ui.*;
	
	public class DemoLinkUI extends LinkUI
	{
		public function DemoLinkUI(network:Network, link:DemoLink)
		{
			super(network, link);
		}
		
		override protected function drawBody(g:Graphics):void
		{   
			
			super.drawBody(g);
			if (link.getClient("status") != "normal")
			{
//				var centerPoint:Point=this.network.getPosition(Consts.POSITION_FROM, this, null, this.lineLength / 2, 0);
//				if (centerPoint)
//				{
//					var centerX:Number=centerPoint.x;
//					var centerY:Number=centerPoint.y;
//					g.lineStyle(2, 0xFF0000, link.getClient("alpha") / 255);
//					
//					g.drawEllipse(centerX - 10, centerY - 10, 20, 30);
//					var offset:Number=Math.sqrt(10) * 2;
//					g.moveTo(centerX - offset, centerY - offset);
//					g.lineTo(centerX + offset, centerY + offset);
//					
//					g.moveTo(0, 0);
//				}
			}
			else
			{
				var flowingOffset:Number=link.getClient("flowingOffset");
				var position:Point=this.network.getPosition(Consts.POSITION_FROM, this, null, this.lineLength * flowingOffset / 100.0, 0);
//				var position:Point=link.fromNode.centerLocation;
				if (position)
				{
					var x:Number=position.x;
					var y:Number=position.y;
					var linkWidth:Number=link.getStyle(Styles.LINK_WIDTH) + 2;
					g.beginFill(0x3300FF, 1);
					g.drawEllipse(x - linkWidth / 2, y - linkWidth / 2, linkWidth, linkWidth+2);
					g.endFill();
				}
			}
			
		}
	}
}