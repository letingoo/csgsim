package sourceCode.businessDispatch.Event
{
	import flash.events.Event;
	
	import sourceCode.businessDispatch.model.SelectTodoCircuit;
	
	public class BusinessDispatchEvent extends Event
	{	public var model:SelectTodoCircuit;
		public function BusinessDispatchEvent(type:String, model:SelectTodoCircuit)
		{
			super(type);
			this.model = model;
		}
	}
}