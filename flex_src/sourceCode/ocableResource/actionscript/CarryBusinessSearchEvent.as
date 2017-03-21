package sourceCode.ocableResource.actionscript
{
	import flash.events.Event;
	
	import sourceCode.ocableResource.model.CarryingBusinessModel;
	public class CarryBusinessSearchEvent extends Event
	{
		public var model:CarryingBusinessModel;
		public function CarryBusinessSearchEvent(type:String, model:CarryingBusinessModel)
		{
			super(type);
			this.model=model;
		}
	}
}
