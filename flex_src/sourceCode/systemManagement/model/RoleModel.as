package sourceCode.systemManagement.model
{
	[Bindable]	
	[RemoteClass(alias="sysManager.role.model.RoleModel")]  
	public class RoleModel
	{
		public var role_id:String;
		public var role_name:String;
		public var role_desc:String;
		
		public function clear():void{
			role_id = "";
			role_name = "";
			role_desc = "";
		}
	}
}