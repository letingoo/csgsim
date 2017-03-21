package twaver.common
{
	import mx.core.ClassFactory;
	
	import twaver.controls.TableColumn;

	public class ColorColumn extends TableColumn
	{
		public function ColorColumn(columnName:String=null)
		{
			super(columnName);
			this.itemRenderer = new ClassFactory(ColorRenderer);
			this.itemEditor = new ClassFactory(ColorEditor);
			this.editorDataField = "color";
		}
		
	}
}