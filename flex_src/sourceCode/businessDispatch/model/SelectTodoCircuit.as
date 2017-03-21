package sourceCode.businessDispatch.model
{
	
	[Bindable]
	[RemoteClass(alias="businessDispatch.model.SelectTodoCircuit")]
	public class SelectTodoCircuit
	{
		public var form_id:String; //方式单ID
		public var form_no:String; //方式单No
		public var appdepartment:String; //申请单位
		public var appid:String; //申请人ID
		public var applier:String; //申请人名称
		public var contactphone:String; //申请人电话
		public var appstarttime:String; //
		public var appfinishtime:String; //
		public var purpose:String; //申请目的
		public var specialtytype:String; //业务类型
		public var specialtyname:String; //业务名称
		public var causation:String;//
		public var asite:String;//A端站点
		public var zsite:String;//Z端站点
		public var speed:String;//速率编码
		public var porttype:String;//端口类型
		public var num:String;//
		public var formname:String;//方式单申请名称
		public var picurl:String;//
		public var id:String;//
		public var fsapplyformname:String;//
		public var speedname:String;//速率名称
		public var starttime:String;//申请日期
		public var finishtime:String;//完成日期
		public function SelectTodoCircuit()
		{
			form_id="";
			form_no="";
			appdepartment="";
			appid="";
			applier="";
			contactphone="";
			appstarttime="";
			appfinishtime="";
			purpose="";
			specialtytype="";
			specialtyname="";
			causation="";
			asite="";
			zsite="";
			speed="";
			porttype="";
			num="";
			formname="";
			picurl="";
			id="";
			fsapplyformname="";
			speedname="";
			starttime="";
			finishtime="";
		}
	}
}