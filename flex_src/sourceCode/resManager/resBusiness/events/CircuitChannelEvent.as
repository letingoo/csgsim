package sourceCode.resManager.resBusiness.events
{
	import flash.events.Event;
	
	import sourceCode.resManager.resBusiness.model.CircuitChannelModel;
	
	public class CircuitChannelEvent extends Event
	{
		public var model:CircuitChannelModel;
		public function CircuitChannelEvent(type:String,model:CircuitChannelModel)
		{
			super(type);
			this.model = model;
		}
	}
}