package sourceCode.rootalarm.model
{
	[Bindable]
	[RemoteClass(alias="com.metarnet.mnt.rootalarm.model.AckRootAlarmModel")]
	public class AckRootAlarmModel
	{
		public function AckRootAlarmModel()
		{
		}
		public var alarmnumber:String = "";
		public var ackperson:String = "";
		public var alarmtype:String = "0";
		public var bugno:String = "";
		public var ackcontent:String = "";
		public var dealresult:String = "";
		public var isworkcase:String = "";
		public var isackedzh:String = "";
	}
}