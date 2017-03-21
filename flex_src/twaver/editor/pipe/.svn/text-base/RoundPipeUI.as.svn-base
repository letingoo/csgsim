package twaver.editor.pipe
{
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	import twaver.Consts;
	import twaver.Utils;
	import twaver.network.Network;
	import twaver.network.ui.NodeUI;
	
	public class RoundPipeUI extends NodeUI
	{
		public function RoundPipeUI(network:Network, roundPipe:RoundPipe){
			super(network, roundPipe);
		}
		
		protected override function drawContent(graphics:Graphics):void{
			super.drawContent(graphics);
			var roundPipe:RoundPipe = RoundPipe(this.node);
			if (roundPipe == null || roundPipe.holeCount <= 0)
			{
				return;
			}
			for (var i:int = 0; i < roundPipe.holeCount; i++)
			{
				var rect:Rectangle = roundPipe.getPipeHoleBoundsByHoleIndex(i);
				if (roundPipe.innerWidth > 0 && rect != null)
				{
					graphics.lineStyle(roundPipe.innerWidth, roundPipe.innerColor, roundPipe.innerAlpha);
					if (roundPipe.innerPattern != null && roundPipe.innerPattern.length == 2)
					{
						var dashedLine:DashedLine = new DashedLine(graphics, roundPipe.innerPattern[0], roundPipe.innerPattern[1]);
						var x:Number = rect.x + rect.width/2;
						var y:Number = rect.y + rect.height/2;
						var r:Number = rect.width > rect.height ? rect.height/2 : rect.width/2;
						var a:Number = r*Math.tan(Math.PI/8);
						var b:Number = r*Math.sin(Math.PI/4);
						dashedLine.moveTo(x+r,y);
						dashedLine.curveTo(x+r,y+a,x+b,y+b);
						dashedLine.curveTo(x+a,y+r,x,y+r);
						dashedLine.curveTo(x-a,y+r,x-b,y+b);
						dashedLine.curveTo(x-r,y+a,x-r,y);
						dashedLine.curveTo(x-r,y-a,x-b,y-b);
						dashedLine.curveTo(x-a,y-r,x,y-r);
						dashedLine.curveTo(x+a,y-r,x+b,y-b);
						dashedLine.curveTo(x+r,y-a,x+r,y);
						graphics.moveTo(0, 0);
					}else{
						Utils.drawShape(graphics, Consts.SHAPE_CIRCLE, rect.x, rect.y, rect.width, rect.height);
					}
				}else{
					graphics.lineStyle();
				}
			}
		}
	}
}