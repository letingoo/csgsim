package twaver.editor.pipe
{
	import flash.geom.Rectangle;
	
	import twaver.*;
	
	public class RoundPipe extends AbstractPipe
	{
		private var _holeCount:int = 0;
		private var _isCenterHole:Boolean = true;
		
		public function RoundPipe(id:Object=null)
		{
			super(id);
			this.icon = "RoundPipe";
			this.setStyle(Styles.VECTOR_SHAPE, Consts.SHAPE_CIRCLE);
			this.setStyle(Styles.VECTOR_GRADIENT, Consts.GRADIENT_RADIAL_NORTHWEST);
		}
		
		public override function get elementUIClass():Class
		{
			return RoundPipeUI;
		}
		
		public function get holeCount():int
		{
			return this._holeCount;
		}
		
		public function set holeCount(holeCount:int):void
		{
			var oldValue:int = this._holeCount;
			this._holeCount = holeCount;
			this.dispatchPropertyChangeEvent("holeCount", oldValue, holeCount);
		}
		
		public function get isCenterHole():Boolean
		{
			return this._isCenterHole;
		}
		
		public function set isCenterHole(isCenterHole:Boolean):void
		{
			var oldValue:Boolean = this._isCenterHole;
			this._isCenterHole = isCenterHole;
			this.dispatchPropertyChangeEvent("isCenterHole", oldValue, isCenterHole);
		}
		
		public override function getPipeHoleBoundsByHoleIndex(holeIndex:int):Rectangle
		{
			if (holeIndex < 0 || holeIndex >= this.holeCount)
			{
				return null;
			}
			var R:Number = Math.min(this.width, this.height) / 2.0;
			var cx:Number = this.x + this.width / 2.0;
			var cy:Number = this.y + this.height / 2.0;
			var count:int = this.isCenterHole ? this.holeCount - 1 : this.holeCount;
			var angle:Number = Math.PI / count;
			var r:Number = R * Math.sin(angle) / (1 + Math.sin(angle));
			var x:Number = (R - r) * Math.sin(angle * 2 * holeIndex);
			var y:Number = (R - r) * Math.cos(angle * 2 * holeIndex);
			if (this.isCenterHole && holeIndex == this.holeCount - 1)
			{
				r = R - 2 * r;
				return new Rectangle(cx - r, cy - r, 2 * r, 2 * r);
			}
			else
			{
				return new Rectangle(cx + x - r, cy + y - r, 2 * r, 2 * r);
			}
		}
		
		public override function serializeXML(serializer:XMLSerializer, newInstance:IData):void{
			super.serializeXML(serializer, newInstance);
			this.serializeProperty(serializer, "holeCount", newInstance);
			this.serializeProperty(serializer, "isCenterHole", newInstance);
		}
	}
}