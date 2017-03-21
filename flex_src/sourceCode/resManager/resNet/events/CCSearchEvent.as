package sourceCode.resManager.resNet.events
{
	import flash.events.Event;
	
	import sourceCode.resManager.resNet.model.CCModel;

	public class CCSearchEvent extends Event
	{
		public var model:CCModel;
		public function CCSearchEvent(type:String,model:CCModel)
		{
			super(type);
			this.model=model;
		}
	}
}