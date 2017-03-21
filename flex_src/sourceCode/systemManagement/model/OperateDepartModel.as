package sourceCode.systemManagement.model
{
	[Bindable]	
	[RemoteClass(alias="sysManager.user.model.OperateDepartModel")]  
	public class OperateDepartModel
	{ 
		public var departCode:String;
		public var departName:String;
		public function  OperateDepartModel():void{
			departCode = "";
			departName = "";
		}
		public function clear():void{
			departCode = "";
			departName = "";
		}
	}
}