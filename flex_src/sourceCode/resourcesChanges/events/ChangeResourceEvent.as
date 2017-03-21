package sourceCode.resourcesChanges.events
{
	import flash.events.Event;
	
	import sourceCode.resourcesChanges.model.ResourceModel;
	
	
	
	
	public class ChangeResourceEvent extends Event
	{
		public var resource:ResourceModel; 
		
		public function ChangeResourceEvent(type:String,resource:ResourceModel)
		{
			super(type);
			this.resource = resource;
		}
	}
}