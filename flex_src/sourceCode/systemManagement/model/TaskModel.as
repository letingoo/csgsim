package sourceCode.systemManagement.model
{
	[Bindable]	
	[RemoteClass(alias="sysManager.taskConfig.model.TaskModel")] 
	public class TaskModel
	{
		public var task_id:String;
		public var task_name:String;
		public var task_type:String;
		public var task_period:String;
		public var isactivated:String;
		public var performer:String;
		public var starttime:String;
		public var start:String;
		public var end:String;
		public var sourceid;
		public var sourcename;
		public function clear():void
		{
			task_id="";
			task_name="";
			task_type="";
			task_period="";
			isactivated="";
			performer="";
			starttime="";
			start="";
			end="";
			sourceid="";
			sourcename="";
		}
	}
}