package twaver.common
{
	import mx.controls.ComboBox;
	import mx.controls.DataGrid;
	import mx.controls.listClasses.BaseListData;
	import mx.core.ClassFactory;
	
	import twaver.AlarmSeverity;

	public class AlarmSeverityEditor extends ComboBox
	{
		public function AlarmSeverityEditor(commitOnChange:Boolean = true)
		{
			var severities:Array = AlarmSeverity.severities.toArray();
			severities.splice(0, 0, "");
			this.dataProvider = severities;
			this.itemRenderer = new ClassFactory(AlarmSeverityRenderer);
			if(commitOnChange){
				this.addEventListener("change", endEdit);
			}
		}
		
		private function endEdit(e:*):void{
			var listData:BaseListData = this.listData;
			if(listData){
				var dg:DataGrid = listData.owner as DataGrid;
				if(dg){
					dg.editedItemPosition = null;
				}
			}
		} 		
		
		override public function get selectedItem():Object{
			return super.selectedItem as AlarmSeverity;
		}
	}
}