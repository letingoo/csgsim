package sourceCode.systemManagement.model
{
	[Bindable]	
	[RemoteClass(alias="sysManager.log.model.LogModel")] 
	public class LogModel
	{
		public var no:String;
		public var log_id:int;
		public var log_type:String;
		public var module_desc:String;
		public var func_desc:String;
		public var data_id:String;
		public var user_id:String;
		public var user_name:String;
		public var dept_name:String;
		public var user_ip:String;
		public var log_time:String;
		public var start:String;
		public var end:String;
		public function logModel():void{
			no="";
			log_id=0;
			log_type="";
			module_desc="";
			func_desc="";
			data_id="";
			user_id="";
			user_name="";
			dept_name="";
			user_ip="";
			log_time="";
			start="";
			end="";	
		}
	}
}