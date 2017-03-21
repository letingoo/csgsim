package twaver.common
{
	import mx.core.ClassFactory;
	
	import twaver.controls.TableColumn;

	public class BooleanColumn extends TableColumn
	{
		public function BooleanColumn(columnName:String=null)
		{
			super(columnName);
			this.itemRenderer = new ClassFactory(BooleanRenderer);
			this.rendererIsEditor = true;
			this.editorDataField = "selected"
		}
		
	}
}