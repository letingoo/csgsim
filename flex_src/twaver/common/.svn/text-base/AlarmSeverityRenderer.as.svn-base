package twaver.common
{
	import mx.controls.DataGrid;
	import mx.controls.TextInput;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.listClasses.BaseListData;
	
	import twaver.AlarmSeverity;
	import twaver.controls.TableData;

	public class AlarmSeverityRenderer extends TextInput
	{
		public function AlarmSeverityRenderer(){
			this.setStyle("borderStyle", "none");
			this.setStyle("textAlign", "center");
            this.mouseEnabled = false;
            this.mouseChildren = false;
		}
		
		override public function set data(value:Object):void {		
			super.data = value;
			var label:String = null;
			var color:Object = null;
			var severity:AlarmSeverity = null;
			
			if(this.data is AlarmSeverity){
				severity = this.data as AlarmSeverity;
			}
			else{
				var listData:BaseListData = this.listData;
				if(listData && this.data is TableData){
					var dg:DataGrid = listData.owner as DataGrid;
					if(dg){
						var column:DataGridColumn = dg.columns[listData.columnIndex];			
						var cellValue:* = TableData(data).data.getPropertyValue(column.dataField);
						if(cellValue is AlarmSeverity){
							severity = cellValue as AlarmSeverity;
						}else{
							label = cellValue as String;
						}			
					}
				}				
			}

			if(severity != null){
				label = severity.toString();
				color = severity.color;					
			}				
			this.text = label;
			this.setStyle("backgroundColor", color);
		}
		

	}
}