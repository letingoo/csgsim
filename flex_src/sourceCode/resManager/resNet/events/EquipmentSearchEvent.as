package sourceCode.resManager.resNet.events
{
	import flash.events.Event;
	
	import sourceCode.resManager.resNet.model.Equipment;

	public class EquipmentSearchEvent extends Event
	{
		public var model:Equipment;
		public function EquipmentSearchEvent(type:String,model:Equipment)
		{
			super(type);
			this.model=model;
		}
	}
}