package sourceCode.wireConfiguration.model
{
	[Bindable]	
	[RemoteClass(alias="wireConfiguration.model.EquipLogicportDetails")]
	public class EquipLogicportDetails{
		public var equipcode:String;
		public var logicport:String;
		public var equipname:String;
		public var name_std:String;
		public var frameserial:String;
		public var slotserial:String;
		public var packserial:String;
		public var portserial:String;
		public var y_porttype:String;
		public var x_capability:String;
		public var status:String;
		public var remark:String;
		public var updatedate:String;
		public var updateperson:String;
		public var circuit:String;
		public var start:String;
		public var end:String;
		
		public function EquipLogicportDetails(){
			 equipcode = "";
			 logicport = "";
			 equipname = "";
			 name_std = "";
			 frameserial = "";
			 slotserial = "";
			 packserial = "";
			 portserial = "";
			 y_porttype = "";
			 x_capability = "";
			 status = "";
			 remark = "";
			 updatedate = "";
			 updateperson = "";
			 circuit = "";
			 start = "0";
			 end = "50";
		}
	}
	
}