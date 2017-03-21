package sourceCode.autoGrid.actionscript  
{   
	import mx.collections.IList;
	import mx.controls.Label;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.ListBase;
	
	public class ItemRenderer extends Label   
	{   
		public static var size:int = 1;
		public static var pagesize:int = 50;
		public function ItemRenderer()   
		{   
			super();   
		}   
		
		     // 另一种方法获取dataProvider并调用getItemIndex方法   
//		      override public function set data(value:Object):void{   
//		          super.data = value;   
//		          text = (((listData.owner as ListBase).dataProvider as IList)   
//		              .getItemIndex(data) + 1).toString();   
//		      }   
		override public function set listData(value:BaseListData):void{   
			super.listData = value;   
			text = ((value.owner as ListBase).itemRendererToIndex(this) + 1+(size-1)*pagesize).toString();   
		}   
	}   
} 