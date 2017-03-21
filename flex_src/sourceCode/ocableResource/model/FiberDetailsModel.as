package sourceCode.ocableResource.model
{
	[Bindable]	
	[RemoteClass(alias="ocableResources.model.FiberDetailsModel")] 
	public class FiberDetailsModel
	{
	    public var fibercode:String;
		public var sectioncode:String;
		public var systemcode:String;
		public var ocablesectionname:String;
		public var fiberserial:String;
		public var name_std:String;
		public var length:String;
		public var property:String;
		public var status:String;
		public var fibermodel:String;
		public var remark:String;
		public var aendeqport:String;
		public var zendeqport:String;
		public var aendodfport:String;
		public var zendodfport:String;
		public var updateperson:String;
		public var updatedate:String;
		public var start:String;
		public var end:String;
		public var aequip:String;
		public var zequip:String;
		public var aequiptype:String;
		public var zequiptype:String;
		public var aendodfportstart:String;

		public function FiberDetailsModel()
		{   
			this.fibercode = "";
			this.aendodfportstart = "";
			this.sectioncode = "";
			this.systemcode = "";
			this.ocablesectionname = "";
			this.fiberserial = "";
			this.name_std = "";
			this.length = "";
			this.property = "";
			this.status="";
			this.fibermodel = "";
			this.remark = "";
			this.aendeqport = "";
			this.zendeqport = "";
			this.aendodfport = "";
			this.zendodfport = "";
			this.updatedate = "";
			this.updateperson = "";
			this.start="0";
			this.end="50";
			this.aequip = "";
			this.aequiptype = "";
			this.zequip = "";
			this.zequiptype = "";
		}
	}
}