package sourceCode.resManager.resNode.Events
{
	import flash.events.Event;
	
	import sourceCode.resManager.resNode.model.Fiber;
	import sourceCode.resManager.resNode.model.Testframe;
	
	
	public class ModifyEvent extends Event
	{
		//public var model:Testframe; 
		
		public function ModifyEvent(type:String)
		{
			
			super(type);
			//super(type);
			//this.model = model;
		}
	}
}