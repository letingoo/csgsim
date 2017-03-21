package twaver.common
{
	import demo.DemoUtils;
	
	import mx.controls.ComboBox;
	import mx.controls.DataGrid;
	import mx.controls.listClasses.BaseListData;

	[DefaultProperty("prefix")]

	public class ConstsEditor extends mx.controls.ComboBox
	{
		public function ConstsEditor(commitOnChange:Boolean = true)
		{
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
		
	 	public function set prefix(prefix:String):void{
	 		this.dataProvider = DemoUtils.getConstsByPrefix(prefix);
	 	}
	}
}