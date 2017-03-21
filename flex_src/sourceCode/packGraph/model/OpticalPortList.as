//光口列表
package sourceCode.packGraph.model
{
	[Bindable]	
	[RemoteClass(alias="equipPack.model.OpticalPortListModel")]   
	public class OpticalPortList
	{
		public var logicport:String;//端口编码
		public var x_capability:String;//速率编码
		public var logicportname:String;//端口名称
		public var systemcode:String;//系统名称
		public var portserial:String;
		public var status:String; 
		
		public function OpticalPortList()
		{
			this.logicport = "";
			this.x_capability = "";
			this.logicportname = "";
			this.systemcode = "";
			this.portserial="";
			this.status="";
		}
	}
}