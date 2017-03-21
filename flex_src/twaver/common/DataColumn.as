package twaver.common
{
	import mx.core.ClassFactory;
	
	import twaver.controls.TableColumn;

	public class DataColumn extends TableColumn
	{
		public function DataColumn(columnName:String=null)
		{
			super(columnName);
			this.itemRenderer = new ClassFactory(DataRenderer);
			this.editable = false;
			this.dataField = "id";
			this.headerText = "element";
		}
		
	}
}