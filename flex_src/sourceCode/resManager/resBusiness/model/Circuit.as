package sourceCode.resManager.resBusiness.model
{
	[Bindable]	
	[RemoteClass(alias="resManager.resBusiness.model.Circuit")] 
	public class Circuit
	{
		public var no:String;
		/**
		 *电路编号 
		 */
		public var circuitcode:String;
		/**
		 *起始局站 
		 */
		public var station1:String;
		/**
		 *电路名称 
		 */
		public var username:String;
		/**
		 *终止局站 
		 */
		public var station2:String;
		/**
		 *起始设备 
		 */
		public var city1:String;
		/**
		 *终止设备 
		 */
		public var city2:String;
		public var serial:String;
		/**
		 *业务类型 
		 */
		public var x_purpose:String;
		/**
		 *开通时间 
		 */
		public var usetime:String;
		/**
		 *速率 
		 */
		public var rate:String;
		public var property:String;
		/**
		 *网管A端端口 
		 */
		public var portserialno1:String;
		/**
		 *A端时隙 
		 */
		public var slot1:String;
		/**
		 *网管Z端端口 
		 */
		public var portserialno2:String;
		/**
		 *Z端时隙 
		 */
		public var slot2:String;
		/**
		 *资源A端端口 
		 */
		public var portcode1:String;
		/**
		 *资源A端端口名称 
		 */
		public var portname1:String;
		/**
		 *资源Z端端口 
		 */
		public var portcode2:String;
		/**
		 *资源Z端端口名称 
		 */
	    public var portname2:String;
		/**
		 *方式单编号
		 */
		public var schedulerid:String;
		public var circuitcode_bak:String;//用来修改主键
		public var area:String;
		public var leaser:String;
		public var requisitionid:String;
		public var state:String;
		public var remark:String;
		public var form_id:int;
		public var circuitLevel:int;
		public var operationtype:String;
		public var requestcom:String;
		public var usercom:String;
		public var beizhu:String;
		public var check1:String;
		public var check2:String;
		public var createtime:String;
		public var cooperateDepartment:String;
		public var interfacetype:String;
		public var powerline:String;
		public var protectdevicetype:String;
		public var implementation_units:String;
		public var requestfinish_time:String;
		public var approver:String;
		public var path:String;
		public var delay1:String;
		public var delay2:String;
		
		public var systemcode:String="";//用于路由分析时按系统分类
		
		public var sort:String;
		public var dir:String;
		public var index:String;
		public var end:String;
		
		
		public function Circuit()
		{
			circuitcode="";
			station1="";
			username="";
			station2="";
			city1="";
			city2="";
			serial="";
			usetime="";
			rate="";
			property="";
			portserialno1="";
			slot1="";
			circuitcode_bak ="";
			portserialno2="";
			schedulerid="";
			slot2="";
			area="";
			leaser="";
			requisitionid="";
			state="";
			remark="";
			form_id=0;
			circuitLevel=1;
			operationtype="";
			requestcom="";
			usercom="";
			x_purpose="";
			beizhu="";
			check1="";
			check2="";
			createtime="";
			cooperateDepartment="";
			interfacetype="";
			protectdevicetype="";
			powerline="";
			implementation_units="";
			this.requestfinish_time="";
			this.approver="";
			path="";
			delay1="";
			delay2="";
			sort = "circuitcode";
			dir = "asc";
			index = "0";
			end = "50";
		}
		public function clear():void
		{
			circuitcode="";
			station1="";
			username="";
			station2="";
			city1="";
			city2="";
			serial="";
			usetime="";
			rate="";
			property="";
			portserialno1="";
			slot1="";
			portserialno2="";
			slot2="";
			area="";
			leaser="";
			requisitionid="";
			circuitcode_bak="";
			state="";
			remark="";
			form_id=0;
			circuitLevel=1;
			operationtype="";
			schedulerid="";
			requestcom="";
			usercom="";
			x_purpose="";
			beizhu="";
			check1="";
			check2="";
			createtime="";
			cooperateDepartment="";
			interfacetype="";
			protectdevicetype="";
			powerline="";
			implementation_units="";
			this.requestfinish_time="";
			this.approver="";
			path="";
			delay1="";
			delay2="";
		}
	}
}