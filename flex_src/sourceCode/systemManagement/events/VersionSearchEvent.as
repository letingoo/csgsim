package sourceCode.systemManagement.events
{
	import flash.events.Event;
	
	import sourceCode.systemManagement.model.VersionModel;
	
	
	public class VersionSearchEvent extends Event
	{
		public var model:VersionModel; 
		
		public function VersionSearchEvent(type:String,model:VersionModel)
		{
			super(type);
			this.model = model;
		}
	}
}