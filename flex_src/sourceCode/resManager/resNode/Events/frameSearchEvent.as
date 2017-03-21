package sourceCode.resManager.resNode.Events
{
	import flash.events.Event;
	
	import sourceCode.resManager.resNode.model.Frame;
	
	
	public class frameSearchEvent extends Event
	{
		public var model:Frame; 
		
		public function frameSearchEvent(type:String,model:Frame)
		{
			super(type);
			this.model = model;
		}
	}
}