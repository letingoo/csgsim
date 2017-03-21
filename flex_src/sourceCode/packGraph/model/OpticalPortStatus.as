//光口状态信息
package sourceCode.packGraph.model
{
	[Bindable]	
	[RemoteClass(alias="equipPack.model.OpticalPortStatusModel")]   
	public class OpticalPortStatus
	{
		public var aptp:String;//a端或z端端口(逻辑端口)
		public var aslot:String;//时隙
		public var rate:String;//速率(VC4,VC12)
		public var circuitcode:String;
		public function OpticalPortStatus()
		{
			this.aptp = "";
			this.aslot = "";
			this.rate = "";
			this.circuitcode = "";
		}
	}
}