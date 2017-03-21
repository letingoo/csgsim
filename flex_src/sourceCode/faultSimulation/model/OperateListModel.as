package sourceCode.faultSimulation.model
{
	[Bindable]	
	[RemoteClass(alias="faultSimulation.model.OperateList")]
	
	public class OperateListModel
	{
		public var no:String="";
		public var operateid:String="";
		public var projectid:String="";
		public var projectname:String="";
		public var interposeid:String="";
		public var operatetype:String="";
		public var operatetypeid:String="";
		public var operateorder:String="";
		public var operateresult:String="";
		public var a_equipcode:String="";
		public var z_equipcode:String="";
		public var a_equiptype:String="";
		public var z_equiptype:String="";
		public var a_equipname:String="";
		public var z_equipname:String="";
		
		public var updateperson:String="";
		public var updatetime:String="";
		public var remark:String="";
		//告警传递
		public var oper_id:String="";
		public var alarm_id:String="";
		public var alarm_name:String="";
		public var alarm_level:String="";
		public var parent_id:String="";
		public var oper_desc:String="";
		public var oper_type:String="";
		public var vender:String="";
		public var vendercode:String="";
		public var oper_index:String="";
		
		public var frameserial:String="";
		public var slotserial:String="";
		public var packserial:String="";
		public var portserial:String="";
		
		public var start:String;
		public var end:String;
		public var sort:String="INTERPOSE_ID";
		public var dir:String="asc";
		public var flag:String="";
		
		
		public function OperateListModel()
		{
		}
	}
}