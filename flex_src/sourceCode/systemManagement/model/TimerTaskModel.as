package sourceCode.systemManagement.model
{
	[Bindable]	
	[RemoteClass(alias="sysManager.timerTask.model.TimerTaskModel")] 
	public class TimerTaskModel
	{
		
		public var task_id:String;
		public var task_name:String;
		public var task_period:String;
		public var isactivated:String;
		public var performer:String;
		public var task_type:String;
		public var time_display:String;
		public var systemname:String;
		public var datetime:String;
		
		public function clear():void
		{
			task_id = "";
			task_name = "";
			task_period = "";
			isactivated = "";
			performer = "";
			task_type = "";
			time_display = "";
			systemname = "";
			datetime = "";
		}
	}
}