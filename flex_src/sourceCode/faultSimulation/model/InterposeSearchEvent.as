package sourceCode.faultSimulation.model
{
	import flash.events.Event;
	
	import sourceCode.faultSimulation.model.InterposeModel;
	public class InterposeSearchEvent extends Event
	{
		public var model:InterposeModel;
		public function InterposeSearchEvent(type:String,model:InterposeModel)
		{
			super(type);
			this.model = model;
		}
	}
}