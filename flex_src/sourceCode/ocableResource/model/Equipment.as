package sourceCode.ocableResource.model
{
	
	[Bindable]	
	[RemoteClass(alias="ocableResources.model.Equipment")] 
	public class Equipment
	{
		public var equipcode:String;
		public var equipname:String;
		public var name_std:String;
		public var x_vendor :String;
		public var x_model:String;
		public var equiptype :String;
		public var nename:String;
		public var systemcode :String;
		public var projectname :String;
		public var equiplabel :String;
		public var shelfinfo:String;
		public var nsap :String;
		public var property:String;
		public var updatedate:String;
		public var updateperson:String;
		public var logicport:String;
		public var frameserial:String;
		public var slotserial:String;
		public var packserial:String;
		public var portserial:String;
		public var portcounts:String;
		public var stationcode:String;
		
		public function Equipment()
		{
			
		}
	}
}