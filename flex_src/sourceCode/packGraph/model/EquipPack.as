package sourceCode.packGraph.model
{
	[Bindable]	
	[RemoteClass(alias="equipPack.model.EquipPackModel")]   
	public class EquipPack	
	{
		public var equipname:String;
		public var frameserial:String;
		public var slotserial:String;
		public var packserial:String;
		public var portserial:String;
		public var Y_PORTTYPE:String;
		public var X_CAPABILITY:String;
		public var STATUS:String;
		public var CONNPORT:String;
		public var remark:String;
		public var updatedate:String;
		public var updateperson:String;
		public var logicport:String;
		public function EquipPack()
		{
			equipname="";
			frameserial="";
			slotserial="";
			packserial="";
			portserial="";
			Y_PORTTYPE="";
			X_CAPABILITY="";
			STATUS="";
			CONNPORT="";
			remark="";
			updatedate="";
			updateperson="";
			logicport="";
		}
	}
}