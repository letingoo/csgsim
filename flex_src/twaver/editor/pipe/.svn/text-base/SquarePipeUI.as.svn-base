package twaver.editor.pipe
{
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	import twaver.Consts;
	import twaver.Utils;
	import twaver.network.Network;
	import twaver.network.ui.NodeUI;

	public class SquarePipeUI extends NodeUI
	{
		public function SquarePipeUI(network:Network, squarePipe:SquarePipe){
			super(network, squarePipe);
		}
		
		protected override function drawContent(graphics:Graphics):void{
			super.drawContent(graphics);
			var squarePipe:SquarePipe = SquarePipe(this.node);
			if (squarePipe == null || squarePipe.cellCounts == null || squarePipe.getAllCellCount() <= 0)
			{
				return;
			}
			var count:int = squarePipe.getAllCellCount();
			for (var i:int = 0; i < count; i++)
			{
				var rect:Rectangle = squarePipe.getPipeHoleBoundsByHoleIndex(i);
				if (squarePipe.innerWidth > 0 && rect != null)
				{
					graphics.lineStyle(squarePipe.innerWidth, squarePipe.innerColor, squarePipe.innerAlpha);
					if (squarePipe.innerPattern != null && squarePipe.innerPattern.length == 2)
					{
						var dashedLine:DashedLine = new DashedLine(graphics, squarePipe.innerPattern[0], squarePipe.innerPattern[1]);
						dashedLine.moveTo(rect.x, rect.y);
						dashedLine.lineTo(rect.x + rect.width, rect.y);
						dashedLine.lineTo(rect.x + rect.width, rect.y + rect.height);
						dashedLine.lineTo(rect.x, rect.y + rect.height);
						dashedLine.lineTo(rect.x, rect.y);
						graphics.moveTo(0, 0);
					}else{
						Utils.drawShape(graphics, Consts.SHAPE_RECTANGLE, rect.x, rect.y, rect.width, rect.height);
					}
				}else{
					graphics.lineStyle();
				}
			}
		}
	}
}