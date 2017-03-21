package sourceCode.resManager.resNode.model
{
	[Bindable]	
	[RemoteClass(alias="resManager.resNode.model.EquipPack")] 
	public class Pack
	{   
		public var no:String;
		public var serialNO:String;
		public var equipcode:String;
		public var equipname:String;
		public var frameserial:String;
		public var slotserial:String;
		public var packserial:String;
		public var packmodel:String;
		public var remark:String;
		public var updatedate:String;
		public var updateperson:String;
		public var updatedate_start:String;
		public var updatedate_end:String;
		public var gb_equipcode:String;
		public var gb_frameserial:String;
		public var gb_slotserial:String;
		public var gb_packserial:String;
		public var start:String;
		public var end:String;
		public var sort:String;
		public var dir:String;
		public var vender:String;
		public var system:String;
		public var isNumber:String;
		
		public function Pack()
		{   this.no ="";
			this.serialNO = "";
			equipcode="";
			equipname="";
			frameserial="";
			slotserial="";
			packserial="";
			packmodel="";
			remark="";
			updatedate="";
			updateperson="";
			updatedate_start="";
			updatedate_end="";
			start="";
			end="";
			sort="equipcode";
			dir="asc";
			gb_equipcode="";
			gb_frameserial="";
			gb_slotserial="";
			gb_packserial="";
			vender = "";
			system = "";
			this.isNumber = "";
		}
	}
}