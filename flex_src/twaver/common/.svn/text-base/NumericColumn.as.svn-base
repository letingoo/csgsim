package twaver.common
{
	import mx.core.ClassFactory;
	
	import twaver.controls.TableColumn;

	public class NumericColumn extends TableColumn
	{
		public function NumericColumn(columnName:String=null)
		{
			super(columnName);
			this.itemEditor = new ClassFactory(NumericEditor);
			this.editorDataField = "value";
		}
		
	}
}