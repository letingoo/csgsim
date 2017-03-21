package sourceCode.resManager.resNode.Events
{
	import flash.events.Event;
	
	import sourceCode.resManager.resNode.model.Fiber;
	import sourceCode.resManager.resNode.model.Testframe;
	
	
	public class FibersSearchEvent extends Event
	{
		public var model:Testframe; 
		
		public function FibersSearchEvent(type:String,model:Testframe)
		{
			super(type);
			this.model = model;
		}
	}
}