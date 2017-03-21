package sourceCode.packGraph.model
{
	[Bindable]	
	[RemoteClass(alias="equipPack.model.OpticalPortDetailModel")]   
	public class OpticalPortDetail
	{
		public var logicport:String;//逻辑端口名称
		public var portcode:String;//逻辑端口编号
		public var allvc4:String;//VC4个数
		public var x_capability:String;//速率
		public var usrvc4:String;//已占用VC4数
		public var usrvc12:String;//已占用VC12数
		public var rate:String;//时隙使用率
		public function OpticalPortDetail()
		{
			this.logicport = "";
			this.portcode="";
			this.x_capability = "";
			this.allvc4 = "";
			this.usrvc4 = "";
			this.usrvc12 = "";
			this.rate = "";
		}
	}
}