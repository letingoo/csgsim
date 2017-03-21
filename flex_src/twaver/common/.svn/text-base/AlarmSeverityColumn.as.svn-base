package twaver.common
{
	import mx.core.ClassFactory;
	
	import twaver.controls.TableColumn;

	public class AlarmSeverityColumn extends TableColumn
	{
		public function AlarmSeverityColumn(columnName:String=null)
		{
			super(columnName);
			this.itemRenderer = new ClassFactory(AlarmSeverityRenderer);
			this.itemEditor = new ClassFactory(AlarmSeverityEditor);
			this.editorDataField = "selectedItem";
		}
		
	}
}