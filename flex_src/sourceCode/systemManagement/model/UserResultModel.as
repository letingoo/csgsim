package sourceCode.systemManagement.model
{
	import mx.collections.ArrayCollection;

	[Bindable]	
	[RemoteClass(alias="sysManager.user.model.UserResultModel")] 
	public class UserResultModel
	{
		public var totalCount:int;
		public var userList:ArrayCollection;
	}
}