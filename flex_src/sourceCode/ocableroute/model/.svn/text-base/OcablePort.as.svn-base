package sourceCode.ocableroute.model
{
	import mx.collections.ArrayCollection;

	[Bindable]	
	[RemoteClass(alias="ocableroute.model.OcablePort")] 
	public class OcablePort
	{
		/** 端口或T接编码. */
		private var  port:String;
		
		/** 类型. */
		private var porttype:String;
		
		/** 端口名称. */
		private var portname:String;
		
		/** 所属局站或T接. */
		private var belongOcableStation:OcableStation;
		
		/** 所属设备或模块. */
		private var belongOcableEquip:OcableEquipment;
		
		/** 和端口或T接相连的端口或T接. */
		private var listconnport:ArrayCollection;
		
		/** 坐标X.*/
		private var x:Number;
		
		/** 坐标Y.*/
		private var Y:Number;
		
		/** 位置. */
		private var position:int;
		
		/** 针对与ODF或T接连接的光纤. */
		private var ocableFiber:OcableFiber;
		
		public function OcablePort()
		{
			this.port="";
			this.portname="";
			this.porttype="";
			this.belongOcableEquip=new OcableEquipment();
			this.belongOcableStation=new OcableStation();
			this.listconnport= new ArrayCollection();
			this.x=0;
			this.y=0;
			this.position=0;
		}
	}
}