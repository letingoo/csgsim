package sourceCode.businessDispatch.Event
{
	import flash.events.Event;
	
	import sourceCode.businessDispatch.model.SelectOthersCircuit;
	
	public class BusinessDispatchEventForOther extends Event
	{ 	public var model:SelectOthersCircuit; 
		public function BusinessDispatchEventForOther(type:String,model:SelectOthersCircuit)
		{
			super(type);
			this.model = model;
		}
	}
}