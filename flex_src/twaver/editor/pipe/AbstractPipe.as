package twaver.editor.pipe
{
	import flash.geom.Rectangle;
	import mx.events.PropertyChangeEvent;
	import twaver.*;

	public class AbstractPipe extends Follower implements IPipe
	{
		private var _holeIndex:int = -1;
		private var _innerWidth:Number = 1.0;
		private var _innerColor:uint = 0x00B200;
		private var _innerAlpha:int = 0xFF;
		private var _innerPattern:Array = [2, 2];
		
		public function AbstractPipe(id:Object = null)
		{
			super(id);
			this.setSize(160, 160);
			this.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_VECTOR);
			this.setStyle(Styles.VECTOR_FILL_COLOR, 0xC0C0C0);
			this.setStyle(Styles.VECTOR_OUTLINE_WIDTH, 1.0);
			this.setStyle(Styles.VECTOR_OUTLINE_COLOR, 0x00B200);
		}
		
		public function get innerWidth():Number
		{
			return this._innerWidth;
		}
		
		public function set innerWidth(innerWidth:Number):void
		{
			var oldValue:Number = this._innerWidth;
			this._innerWidth = innerWidth;
			this.dispatchPropertyChangeEvent("innerWidth", oldValue, innerWidth);
		}
		
		public function get innerColor():uint
		{
			return this._innerColor;
		}
		
		public function set innerColor(innerColor:uint):void
		{
			var oldValue:uint = this._innerColor;
			this._innerColor = innerColor;
			this.dispatchPropertyChangeEvent("innerColor", oldValue, innerColor);
		}
		
		public function get innerAlpha():int
		{
			return this._innerAlpha;
		}
		
		public function set innerAlpha(innerAlpha:int):void
		{
			var oldValue:int = this._innerAlpha;
			this._innerAlpha = innerAlpha;
			this.dispatchPropertyChangeEvent("innerAlpha", oldValue, innerAlpha);
		}
		
		public function get innerPattern():Array
		{
			return this._innerPattern;
		}
		
		public function set innerPattern(innerPattern:Array):void
		{
			var oldValue:Array = this._innerPattern;
			this._innerPattern = innerPattern;
			this.dispatchPropertyChangeEvent("innerPattern", oldValue, innerPattern);
		}
		
		public function get holeIndex():int
		{
			return this._holeIndex;
		}
		
		public function set holeIndex(holeIndex:int):void
		{
			var oldValue:int = this._holeIndex;
			this._holeIndex = holeIndex;
			this.dispatchPropertyChangeEvent("holeIndex", oldValue, holeIndex);
			adjustBounds();
		}
		
		protected override function updateFollowerImpl(e:PropertyChangeEvent):void
		{
			super.updateFollowerImpl(e);
			this.adjustBounds();
		}
		
		public function adjustBounds():void
		{
			if (this.host is IPipe)
			{
				var pipe:IPipe = IPipe(this.host);
				var bounds:Rectangle = pipe.getPipeHoleBoundsByHole(this);
				if (bounds != null)
				{
					this.setLocation(bounds.x + pipe.innerWidth, bounds.y + pipe.innerWidth);
					this.setSize(bounds.width - pipe.innerWidth * 2, bounds.height - pipe.innerWidth * 2);
				}
			}
		}
		
		public function getPipeHoleBoundsByHole(hole:IPipe):Rectangle
		{
			return getPipeHoleBoundsByHoleIndex(hole.holeIndex);
		}
		
		public function getPipeHoleBoundsByHoleIndex(holeIndex:int):Rectangle
		{
			return null;
		}
		
		public function getPipeHoleByHoleIndex(holeIndex:int):IPipe
		{
			for (var i:int=0; i<this.childrenCount; i++)
			{
				var element:Element = this.children.getItemAt(i);
				if (element is IPipe)
				{
					var hole:IPipe = IPipe(element);
					if (hole.holeIndex == holeIndex)
					{
						return hole;
					}
				}
			}
			return null;
		}
		
		public override function serializeXML(serializer:XMLSerializer, newInstance:IData):void{
			super.serializeXML(serializer, newInstance);
			this.serializeProperty(serializer, "holeIndex", newInstance);
			this.serializeProperty(serializer, "innerWidth", newInstance);
			this.serializeProperty(serializer, "innerColor", newInstance);
			this.serializeProperty(serializer, "innerAlpha", newInstance);
			this.serializeProperty(serializer, "innerPattern", newInstance);
		}
	}
}