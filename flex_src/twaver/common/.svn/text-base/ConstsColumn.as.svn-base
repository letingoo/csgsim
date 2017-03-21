package twaver.common
{
	import twaver.controls.TableColumn;

	[DefaultProperty("prefix")]

	public class ConstsColumn extends TableColumn
	{
		public function ConstsColumn(columnName:String=null)
		{
			super(columnName);
			this.editorDataField = "selectedItem";
		}
		
		public function set prefix(prefix:String):void{
	 		this.itemEditor = new ConstsEditorFactory(prefix);
	 	}
	}
}