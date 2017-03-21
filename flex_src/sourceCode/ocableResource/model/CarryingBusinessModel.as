package  sourceCode.ocableResource.model
{
	[Bindable]	
	[RemoteClass(alias="ocableResources.model.CarryingBusinessModel")]
	public class CarryingBusinessModel
	{   
		public var equip:String;
		public var label:String;
		public var channelcode:String;
		public var circuitcode:String;
		public var circuitname:String;
		public var state:String;
		public var username:String;
		public var x_purpose:String;
		public var rate:String;
		public var station_a:String;
		public var station_z:String;	
		public var port_a:String;
		public var port_z:String;
		public var remark:String;
		public var start:String;
		public var end:String;
		public var no:String;
		public var dir:String;
		public var sectioncode:String;
		
		public var requisitionid:String; //方式票号
		public var operationtype:String; //业务类型（小类）
		public var aequiptype:String; //起始设备类型
		public var zequiptype:String; //终止设备类型
		
		
		public function CarryingBusinessModel()
		{   
			equip= "";
			label= "";
			channelcode= "";
			circuitcode= "";
			circuitname = "";
			state= "";
			username= "";
			x_purpose= "";
			rate= "";
			station_a= "";
			station_z= "";	
			port_a= "";
			port_z= "";
			remark= "";
			start="0";
			end="50";
			no = "";
			dir= "asc";
			sectioncode="";
			
			requisitionid = "";
			operationtype = "";
			aequiptype = "";
			zequiptype ="";
		}
	}
}