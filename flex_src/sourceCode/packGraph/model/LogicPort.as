package sourceCode.packGraph.model
{
	[Bindable]	
	[RemoteClass(alias="equipPack.model.LogicPortModel")]   
	public class LogicPort
	{
		public var  equipcode:String;
		public var  gb_equipcode:String;
		public var  gb_frameserial:String;
		public var  gb_slotserial:String;
		public var  gb_packserial:String;
		public var  gb_portserial:String;	
		public var  equipname:String;
		public var  frameserial:String;
		public var  slotserial:String;
		public var  packserial:String;
		public var  portserial:String;
		public var  y_porttype:String;//端口类型
		public var  x_capability:String;//端口速率
		public var  status:String;
		public var  connport:String;
		public var  remark:String;
		public var  updatedate:String;
		public var  updateperson:String;
		public var  updatedate_start:String;
		public var  updatedate_end:String;
		public var  logicport:String;
		public var  start:String;
		public var  end:String;
		public var  sort:String;
		public var  dir:String; 
		public var  totalCount:String;
		public var  circuitcode:String;
		public var  portlabel:String;
		public var  username:String;
		public function LogicPort() 
		{
			this.equipcode="";
			this.gb_equipcode="";
			this.gb_frameserial="";
			this.gb_slotserial="";
			this.gb_packserial="";
			this.gb_portserial="";
			this.equipname = "";
			this.frameserial ="";
			this.slotserial = "";
			this.packserial = "";
			this.portserial = "";
			this.y_porttype = "";
			this.x_capability = "";
			this.status = "";
			this.connport = "";
			this.remark = "";
			this.updatedate ="";
			this.updateperson ="";
			this.updatedate_start="";
			this.updatedate_end="";
			this.logicport = "";
			this.start = "0";
			this.end = "50";
			this.sort = "";
			this.dir ="asc";
			this.totalCount="";
			this.circuitcode="";
			this.portlabel="";
			this.username="";
		}
	}
}