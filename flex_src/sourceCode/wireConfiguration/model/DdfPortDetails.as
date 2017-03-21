package sourceCode.wireConfiguration.model
{
	[Bindable]	
	[RemoteClass(alias="wireConfiguration.model.DdfPortDetails")]
	
	public class DdfPortDetails{
		public var ddfddmcode:String;
		public var ddfddmserial:String;
		public var ddfportcode:String;	
		public var name_std:String;
		public var portserial:String;
		public var porttype:String;
		public var status:String;
		public var remark:String;
		public var updateperson:String;
		public var updatedate:String;  
		public var circuit:String;
		public var start:String;
		public var end:String;
		
		public function OdfPortDetails(){
			ddfddmcode = "";
			ddfddmcode = "";
			name_std = "";    
			ddfddmcode = "";	
			portserial = "";
			porttype = "";
			status = "";
			remark = "";
			updateperson = "";
			updatedate = "";  
			circuit = "";
			start = "0";
			end = "50";
		}
	}
	
}