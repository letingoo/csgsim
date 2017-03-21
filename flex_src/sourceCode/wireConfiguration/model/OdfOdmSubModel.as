package sourceCode.wireConfiguration.model
{
	[Bindable]	
	[RemoteClass(alias="wireConfiguration.model.OdfOdmSubModel")] 
	public class OdfOdmSubModel
	{
		public var odfodmcode:String;
		public var serial:String;
		public var label:String;
		public var portcount:String;
		public var updateperson:String;
		public var updatedate:String;
		public var subodfodmcode:String;
		public function OdfOdmSubModel()
		{
			this.odfodmcode = "";
			this.serial = "";
			this.label = "";
			this.portcount = "";
			this.updatedate = "";
			this.updateperson = "";
			this.subodfodmcode = "";
		}
	}
}