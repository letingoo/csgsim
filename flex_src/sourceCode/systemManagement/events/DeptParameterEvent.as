package sourceCode.systemManagement.events
{
	import flash.events.Event;
	
	
	
	
	public class DeptParameterEvent extends Event
	{
		public var dept_code:String;
		public var dept_name:String;
		
		public function DeptParameterEvent(type:String,dept_code:String,dept_name:String)
		{
			super(type);
			this.dept_code=dept_code;
			this.dept_name=dept_name;
		}
	}
}