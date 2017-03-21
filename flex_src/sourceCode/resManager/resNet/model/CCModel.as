package sourceCode.resManager.resNet.model
{
	[Bindable]
	[RemoteClass(alias="resManager.resNet.model.CCModel")]
	public class CCModel
	{
		public var no:String="";
		public var id:String="";
		public var circuitcode:String="";
		public var pid:String="";
		public var rate:String="";
		public var direction:String="";
		public var aptp:String="";
		public var aslot:String="";
		public var zptp:String=""
		public var zslot:String="";
		public var type :String="";
		public var updateperson:String="";
		public var isdefault:String="";
		public var sync_status:String="";
		public var updatedate:String="";
		public var start:String="0";
		public var end:String="50";
		public var sort:String="id";
		public var dir:String="asc";
		public var updatedate_start:String="";
		public var updatedate_end:String="";
		public var otherType:String="";//其他标示
		public function Equipment()
		{
		}
	}
}