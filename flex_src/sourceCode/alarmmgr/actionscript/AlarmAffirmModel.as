package sourceCode.alarmmgr.actionscript
{
	[Bindable]
	[RemoteClass(alias="com.metarnet.mnt.rootalarm.model.AlarmAffirmModel")]
	public class AlarmAffirmModel
	{
		public var ackperson:String;//确认人
		public var dealresult:String;//处理方式
		public var isworkcase:String;//告警原因
		public var ackcontent:String;//确认告警内容
		public var alarmtype:String;//告警类型 0为传输网1为数据网
		public var triggeredhour:String;//上报告警时间间隔
		public var isfilter:String;//继续实时监控 1为是0为否
		public var whichsys:String;//哪个系统确认的bs与cs
		public var alarmnumber:String;//告警编号
		public var acktime:String;//告警确认时间
		public var isackedzh:String;//是否确认
		public function AlarmAffirmModel()
		{
			ackperson="";
			dealresult="";
			isworkcase="";
			ackcontent="";
			alarmtype="0";
			triggeredhour="";
			isfilter="";
			whichsys="BS";
			alarmnumber="";
			acktime="";
			isackedzh="";
		}
	}
}