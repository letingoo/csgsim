package twaver.common
{
	import demo.*;
	
	import mx.controls.DataGrid;
	import mx.controls.TextInput;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.listClasses.BaseListData;
	
	import twaver.Utils;
	import twaver.controls.TableData;

	public class ColorRenderer extends TextInput
	{
		public function ColorRenderer()
		{
			this.setStyle("borderStyle", "none");
			this.setStyle("textAlign", "center");
            this.mouseEnabled = false;
            this.mouseChildren = false;
		}

		override public function set data(value:Object):void {		
			super.data = value;
			var label:String = null;
			var color:Object = null;
			
			if(this.data is Number){
				color = this.data;
			}
			else{
				var listData:BaseListData = this.listData;
				if(listData && this.data is TableData){
					var dg:DataGrid = listData.owner as DataGrid;
					if(dg){
						var column:DataGridColumn = dg.columns[listData.columnIndex];					
						color = TableData(data).data.getPropertyValue(column.dataField);		
					}
				}				
			}

			if(color != null){
				label = Utils.toHexString(color);				
			}				
			this.text = label;
			this.setStyle("backgroundColor", color);
		}		
	}
}