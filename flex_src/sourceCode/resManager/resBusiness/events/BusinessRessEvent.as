package sourceCode.resManager.resBusiness.events
{
	import flash.events.Event;
	
	import sourceCode.resManager.resBusiness.model.BusinessRessModel;
	
	public class BusinessRessEvent extends Event
	{
		public var model:BusinessRessModel;
		public function BusinessRessEvent(type:String,model:BusinessRessModel)
		{
			super(type);
			this.model = model;
		}
	}
}