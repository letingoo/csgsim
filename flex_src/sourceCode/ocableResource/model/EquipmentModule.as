package sourceCode.ocableResource.model
{
	import mx.collections.ArrayCollection;
	import sourceCode.ocableResource.model.Equipment;
	[Bindable]	
	[RemoteClass(alias="ocableResources.model.EquipmentModule")] 
	public class EquipmentModule
	{
		public var EQUIPMENT_DATA:Equipment;
		public var EQUIPPACK_MODULE_DATA:ArrayCollection;
		public var EQUIPPACK_PORT_DATA:ArrayCollection;
		
		public function EquipmentModule()
		{
			this.EQUIPMENT_DATA = new Equipment();
			this.EQUIPPACK_MODULE_DATA = new ArrayCollection();
			this.EQUIPPACK_PORT_DATA = new ArrayCollection();
		}
	}
}