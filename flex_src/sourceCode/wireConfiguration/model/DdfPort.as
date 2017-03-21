package sourceCode.wireConfiguration.model
{
	[Bindable]	
	[RemoteClass(alias="wireConfiguration.model.DdfPortModule")] 
	public class DdfPort
	{
		public var  stationcode:String;
		public var station_name_std:String;
		public var roomcode:String;
		public var room_name_std:String;
		public var shelfcode:String;
		public var shelfserial:String;
		public var shelf_name_std:String;
		public var ddfddmcode:String;
		public var ddfddmserial:String;
		public var ddm_name_std:String;  
		public var ddfportcode:String;
		public var portserial:String;
		public var port_name_std:String; 
		public var porttype:String;
		public var porttype_x:String;
		public var status:String;
		public var status_x:String;
		public var upport:String;
		public var downport:String;
		public var remark:String;
		public var updatedate:String;
		public var updateperson:String;
		public var circuit:String;
		public function DdfPort()
		{
			  stationcode="";
			  station_name_std="";
			  roomcode="";
			  room_name_std="";
			  shelfcode="";
			  shelfserial="";
			  shelf_name_std="";
			  ddfddmcode="";
			  ddfddmserial="";
			  ddm_name_std="";  
			  ddfportcode="";
			  portserial="";
			  port_name_std=""; 
			  porttype="";
			  porttype_x="";
			  status="";
			  status_x="";
			  upport="";
			  downport="";
			  remark="";
			  updatedate="";
			  updateperson="";
			  circuit="";
			
		}
		public function clear()
		{
			stationcode="";
			station_name_std="";
			roomcode="";
			room_name_std="";
			shelfcode="";
			shelfserial="";
			shelf_name_std="";
			ddfddmcode="";
			ddfddmserial="";
			ddm_name_std="";  
			ddfportcode="";
			portserial="";
			port_name_std=""; 
			porttype="";
			porttype_x="";
			status="";
			status_x="";
			upport="";
			downport="";
			remark="";
			updatedate="";
			updateperson="";
			circuit="";
			
		}
	}
}