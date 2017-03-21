package twaver.common
{
	import flash.events.Event;
	
	import mx.controls.CheckBox;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.listClasses.BaseListData;
	import mx.core.mx_internal;
	
	import twaver.controls.TableData;
   	use namespace mx_internal;

	public class BooleanRenderer extends CheckBox
	{
		public function BooleanRenderer(commitOnChange:Boolean = true){
			this.setStyle("textAlign", "center");
			if(commitOnChange){
				this.addEventListener("change", updateModel);
			}
		}
		
		private function updateModel(e:*):void{
			var listData:BaseListData = this.listData;
			if(listData && this.data is TableData){
				var dg:DataGrid = listData.owner as DataGrid;
				if(dg){
					var column:DataGridColumn = dg.columns[listData.columnIndex];
					TableData(data).data.setPropertyValue(column.dataField, this.selected);
				}
			}
		} 		
	}
}