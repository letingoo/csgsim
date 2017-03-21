package sourceCode.businessDispatch.model
{
	[Bindable]
	[RemoteClass(alias="businessDispatch.model.SelectOthersCircuit")]
	public class SelectOthersCircuit
	{
		public var no:String;
		public var requisitionid:String;//
		public var circuitcode:String;//电路编号
		public var operationtype:String;//业务类型
		public var remark:String;//业务名称
		public var rate:String;//速率名称
		public var ratebm:String;//速率编码
		public var interfacetype:String;//端口类型
		public var requestcom:String;//申请单位
		public var leaser:String;//申请人
		public var createtime:String;//申请日期
		public var usetime:String;//完成日期
		public var station1:String;//A端站点
		public var station2:String;//Z端站点
		public var form_id:String;//
		public var sq_form_id:String;
		public var form_name:String;//申请名称
		public var state:String;//状态
		public var start:String;
		public var end:String;
		public var equipmentA:String;
		public var equipmentZ:String;
		public var portA:String;
		public var portZ:String;
		public var portAcode:String;
		public var portZcode:String;
		
		public function SelectOthersCircuit()
		{
			 no="";
			 state="";
			 requisitionid="";
			 circuitcode="";
			 operationtype="";
			 remark="";
			 rate="";
			 ratebm="";
			 interfacetype="";
			 requestcom="";
			 leaser="";
			 createtime="";
			 usetime="";
			 station1="";
			 station2="";
			 form_id="";
			 sq_form_id = "";
			 form_name="";
			 this.start = "0";
			 this.end = "50";
			 equipmentA="";
			 equipmentZ="";
			 portA="";
			 portZ="";
			 portAcode="";
			 portZcode="";
		}
	}
}