package twaver.common
{
	import mx.containers.HBox;
	import mx.controls.ColorPicker;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	
	import twaver.controls.TableData;

	public class ColorEditor extends HBox implements IDropInListItemRenderer
	{
		private var colorRenderer:ColorRenderer = new ColorRenderer();
		private var colorPicker:ColorPicker = new ColorPicker();
		
		public function ColorEditor()
		{
			this.addChild(colorRenderer);
			this.addChild(colorPicker);
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";
			this.setStyle("horizontalGap", 0);
			this.colorRenderer.percentWidth = 100;	
			this.colorPicker.addEventListener("change", updateModel);
		}
			
		private function updateModel(e:*):void{
			var listData:BaseListData = this.listData;
			if(listData && this.data is TableData){
				var dg:DataGrid = listData.owner as DataGrid;
				if(dg){
					var column:DataGridColumn = dg.columns[listData.columnIndex];
					TableData(data).data.setPropertyValue(column.dataField, this.color);
				}
			}
		} 			
						
    	public function get listData():BaseListData{
    		return this.colorRenderer.listData;
    	}
    
   		public function set listData(value:BaseListData):void{
   			this.colorRenderer.listData = value;
   			if(value && value.owner is DataGrid){
   				this.colorPicker.owner = value.owner as DataGrid;
   			}
   		}	
		
		override public function set data(value:Object):void{
			this.colorRenderer.data = value;
			this.colorPicker.selectedColor = this.colorRenderer.getStyle("backgroundColor");	
		}
		
		override public function get data():Object{
			return this.colorRenderer.data;
		}
		
		public function get color():uint{
			return this.colorPicker.selectedColor;
		}
	}
}