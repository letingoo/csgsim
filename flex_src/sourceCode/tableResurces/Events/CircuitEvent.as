package sourceCode.tableResurces.Events
{
	import flash.events.Event;
	
	import sourceCode.tableResurces.model.Circuit;
	
	public class CircuitEvent extends Event
	{
		public var model:Circuit;
		public function CircuitEvent(type:String,model:Circuit)
		{
			super(type);
			this.model = model;
		}
	}
}