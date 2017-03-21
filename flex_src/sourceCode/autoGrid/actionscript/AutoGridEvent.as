package sourceCode.autoGrid.actionscript
{
	import flash.events.Event;
	
	
	
	
	public class AutoGridEvent extends Event
	{
		public var obj:Object;
		public function AutoGridEvent(type:String,obj:Object)
		{
			super(type);
			this.obj = obj;
		}
	}
}