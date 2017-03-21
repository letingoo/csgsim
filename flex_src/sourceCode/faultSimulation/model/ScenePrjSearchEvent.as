package sourceCode.faultSimulation.model
{
	import flash.events.Event;
	
	import sourceCode.faultSimulation.model.SceneModel;
	public class ScenePrjSearchEvent extends Event
	{
		public var model:SceneModel;
		public function ScenePrjSearchEvent(type:String,model:SceneModel)
		{
			super(type);
			this.model = model;
		}
	}
}