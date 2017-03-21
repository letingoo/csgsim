package sourceCode.sysGraph.model
{
	import flash.events.Event;
	
	import sourceCode.resManager.resNode.model.Fiber;
	import sourceCode.resManager.resNode.model.Testframe;
	
	
	public class UsrSelectEvent extends Event
	{
		public var select_result:Array; 
		
		public function UsrSelectEvent(type:String,recv:Array)
		{
			
			super(type);
			this.select_result=recv;
		}
	}
}