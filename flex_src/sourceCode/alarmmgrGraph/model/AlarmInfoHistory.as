package sourceCode.alarmmgrGraph.model
{
	[Bindable]	
	[RemoteClass(alias="alarmMgr.model.AlarmInfoHistory")]  
	public class AlarmInfoHistory
	{
		public var alarmlevel:String;// 告警级别
		public var objectinfo:String;// 告警对象
		public var alarmdesc:String;// 告警描述
		public var alarmtext:String;// 告警名称
		public var starttime:String;// 发生时间
		public var starttime_start:String;
		public var starttime_end:String;
		public var isacked:String;// 是否确认
		public var acktime:String;// 确认时间
		public var acktime_start:String;
		public var acktime_end:String;
		public var ackperson:String;// 确认人
		public var arrivetime :String;//到达时间
		public var arrivetime_start:String;
		public var arrivetime_end:String;
		public var alarmnumber :String;// 告警号
		public var objectcode:String;
		public var start:String;
		public var end:String;
		
		public function AlarmInfoHistory()
		{
			this.alarmlevel="";
			this.objectinfo="";
			this.alarmdesc="";
			this.alarmtext="";
			this.starttime="";
			this.starttime_start="";
			this.starttime_end="";
			this.isacked="";
			this.acktime="";
			this.acktime_start="";
			this.acktime_end="";
			this.ackperson="";
			this.arrivetime="";
			this.arrivetime_start="";
			this.arrivetime_end="";
			this.alarmnumber="";
			this.objectcode="";
			this.start="0";
			this.end="50";
		}
	}
}