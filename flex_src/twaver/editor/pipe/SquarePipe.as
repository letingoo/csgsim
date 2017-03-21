package twaver.editor.pipe
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import twaver.*;

	public class SquarePipe extends AbstractPipe
	{
		private var _cellCounts:Array = null;
		private var _isHorizontal:Boolean = true;
		
		public function SquarePipe(id:Object=null)
		{
			super(id);
			this.icon = "SquarePipe";
			this.setStyle(Styles.VECTOR_SHAPE, Consts.SHAPE_RECTANGLE);
			this.setStyle(Styles.VECTOR_GRADIENT, Consts.GRADIENT_LINEAR_NORTHWEST);
		}
		
		public override function get elementUIClass():Class
		{
			return SquarePipeUI;
		}
		
		public function get cellCounts():Array
		{
			return this._cellCounts;
		}
		
		public function set cellCounts(cellCounts:Array):void
		{
			var oldValue:Array = this._cellCounts;
			this._cellCounts = cellCounts;
			this.dispatchPropertyChangeEvent("cellCounts", oldValue, cellCounts);
		}
		
		public function get isHorizontal():Boolean
		{
			return this._isHorizontal;
		}
		
		public function set isHorizontal(isHorizontal:Boolean):void
		{
			var oldValue:Boolean = this._isHorizontal;
			this._isHorizontal = isHorizontal;
			this.dispatchPropertyChangeEvent("isHorizontal", oldValue, isHorizontal);
		}
		
		public function getAllCellCount():int
		{
			if (this.cellCounts == null || this.cellCounts.length == 0)
			{
				return 0;
			}
			var count:int = 0;
			for (var i:int = 0; i < this.cellCounts.length; i++)
			{
				count += this.cellCounts[i];
			}
			return count;
		}
		
		public function getRowIndexByPoint(point:Point):int
		{
			var count:int = this.getAllCellCount();
			for (var i:int = 0; i < count; i++)
			{
				var rect:Rectangle = this.getPipeHoleBoundsByHoleIndex(i);
				if (rect != null && rect.containsPoint(point))
				{
					return this.getRowIndexByCellIndex(i);
				}
			}
			return -1;
		}
		
		public function getRowIndexByCellIndex(cellIndex:int):int
		{
			if (cellIndex < 0 || cellIndex >= this.getAllCellCount())
			{
				return -1;
			}
			var count:int = 0;
			for (var i:int = 0; i < this.cellCounts.length; i++)
			{
				var rowCount:int = this.cellCounts[i];
				count += rowCount;
				if (count >= cellIndex + 1)
				{
					if (this.isHorizontal)
					{
						return i;
					}
					else
					{
						return rowCount - (count - cellIndex);
					}
				}
			}
			return -1;
		}
		
		public function getColumnIndexByPoint(point:Point):int
		{
			var count:int = this.getAllCellCount();
			for (var i:int = 0; i < count; i++)
			{
				var rect:Rectangle = this.getPipeHoleBoundsByHoleIndex(i);
				if (rect != null && rect.containsPoint(point))
				{
					return this.getColumnIndexByCellIndex(i);
				}
			}
			return -1;
		}
		
		public function getColumnIndexByCellIndex(cellIndex:int):int
		{
			if (cellIndex < 0 || cellIndex >= this.getAllCellCount())
			{
				return -1;
			}
			var count:int = 0;
			for (var i:int = 0; i < this.cellCounts.length; i++)
			{
				var columnCount:int = this.cellCounts[i];
				count += columnCount;
				if (count >= cellIndex + 1)
				{
					if (this.isHorizontal)
					{
						return columnCount - (count - cellIndex);
					}
					else
					{
						return i;
					}
				}
			}
			return -1;
		}
		
		public override function getPipeHoleBoundsByHoleIndex(holeIndex:int):Rectangle
		{
			if (holeIndex < 0 || holeIndex >= this.getAllCellCount())
			{
				return null;
			}
			var row:int = this.getRowIndexByCellIndex(holeIndex);
			var column:int = this.getColumnIndexByCellIndex(holeIndex);
			if (row < 0 || column < 0)
			{
				return null;
			}
			
			var location:Point = this.location;
			var borderWidth:Number = this.getStyle(Styles.VECTOR_OUTLINE_WIDTH);
			if (borderWidth < 0)
			{
				borderWidth = 0;
			}
			var x:Number = location.x + borderWidth;
			var y:Number = location.y + borderWidth;
			var w:Number = this.width - borderWidth * 2;
			var h:Number = this.height - borderWidth * 2;
			
			var rect:Rectangle = new Rectangle();
			if (this.isHorizontal)
			{
				var rowCount:int = this.cellCounts[row];
				rect.width = w / rowCount;
				rect.height = h / this.cellCounts.length;
				rect.x = x + column * w / rowCount;
				rect.y = y + row * h / this.cellCounts.length;
			}
			else
			{
				var columnCount:int = this.cellCounts[column];
				rect.width = w / this.cellCounts.length;
				rect.height = h / columnCount;
				rect.x = x + column * w / this.cellCounts.length;
				rect.y = y + row * h / columnCount;
			}
			return rect;
		}
		
		public override function serializeXML(serializer:XMLSerializer, newInstance:IData):void{
			super.serializeXML(serializer, newInstance);
			this.serializeProperty(serializer, "cellCounts", newInstance);
			this.serializeProperty(serializer, "isHorizontal", newInstance);
		}
	}
}