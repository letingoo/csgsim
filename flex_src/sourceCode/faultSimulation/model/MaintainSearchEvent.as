package sourceCode.faultSimulation.model
{
	import flash.events.Event;
	
	import sourceCode.faultSimulation.model.StdMaintainProModel;
	public class MaintainSearchEvent extends Event
	{
		public var model:StdMaintainProModel;
		public function MaintainSearchEvent(type:String,model:StdMaintainProModel)
		{
			super(type);
			this.model = model;
		}
	}
}