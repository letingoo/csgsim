package sourceCode.systemManagement.model
{
	import mx.collections.ArrayCollection;

	[Bindable]	
	[RemoteClass(alias="sysManager.taskConfig.model.TaskResultModel")] 
	public class TaskResultModel
	{
		public var totalCount:int;
		public var taskList:ArrayCollection;
		public function TaskResultModel()
		{
			totalCount=0;
			taskList = new ArrayCollection();
		}
	}
}