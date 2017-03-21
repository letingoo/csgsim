package sourceCode.resManager.resNode.Events
{
	import flash.events.Event;
	
	import sourceCode.resManager.resNode.model.Station;
	
	
	public class StationSearchEvent extends Event
	{
		public var model:Station; 
		
		public function StationSearchEvent(type:String,model:Station)
		{
			super(type);
			this.model = model;
		}
	}
}