package sourceCode.alarmmgr.model
{
	import mx.collections.ArrayCollection;
	
	[Bindable]	
	[RemoteClass(alias="com.metarnet.mnt.alarmmgr.model.AlarmResult")] 
	public class AlarmResultModel
	{
		public function AlarmResultModel()
		{
		}
		public var list :ArrayCollection;
		
		public var alarmcount:int;
		
		public var isnowalarm:String;
		
	}
}