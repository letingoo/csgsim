package sourceCode.systemManagement.model
{
	[Bindable]	
	[RemoteClass(alias="sysManager.permissionControl.model.PermissionControlModel")] 
	public class PermissionControlModel
	{
		public var oper_id:String;
		public var oper_name:String;
	
		public function PermissionControlModel():void{
			oper_id="";
			oper_name="";
		}
	}
}