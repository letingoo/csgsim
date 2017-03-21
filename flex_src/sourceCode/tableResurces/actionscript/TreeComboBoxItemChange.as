package sourceCode.tableResurces.actionscript
{
	import flash.events.Event;
	public class TreeComboBoxItemChange extends Event
	{
		// 新添加的一个参数
		public var TreeSelectedItem:Object;
		
		public function TreeComboBoxItemChange(type:String, selectedItem:Object)
		{
			super(type);
			this.TreeSelectedItem=selectedItem;
		}
		
		override public function clone():Event
		{
			return new TreeComboBoxItemChange(type, TreeSelectedItem);
		}
	}
}