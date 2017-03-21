package sourceCode.businessDispatch.model
{

	[Bindable]
	[RemoteClass(alias="businessDispatch.model.CreateCircuitInfoModel")]
	public class CreateCircuitInfo
	{
		public var modeName:String; //业务名称
		public var aStationnName:String; //起始局站
		public var zStationnName:String; //终止局站
		public var leaser:String; //申请单位
		public var property:String; //使用单位
		public var operationType:String; //业务类型
		public var circuitlevel:String; //业务等级
		public var rate:String; //速率
		public var requestionID:String; //申请名称
		public var state:String; //电路状态
		public var finishtime:String; //完成时间
		public var interfaceType:String; //接口类型
		public var department:String; //执行单位
		public var cooperateDepartment:String; //配合单位
		public var beizhu:String; //备注

		public function CreateCircuitInfo()
		{
			modeName="";
			aStationnName="";
			zStationnName=""
			leaser="";
			property="";
			operationType="";
			circuitlevel="";
			rate="";
			requestionID="";
			state="";
			finishtime="";
			interfaceType="";
			department="";
			cooperateDepartment="";
			beizhu="";
		}
	}
}