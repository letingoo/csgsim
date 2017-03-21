package sourceCode.faultSimulation.model
{
	[Bindable]	
	[RemoteClass(alias="faultSimulation.model.InterposeLogModel")]
	public class InterposeLogModel
	{
			public var no:String;
			public var id:String;
			public var logid:String;
			public var logtype:String;
			public var logtime:String;
			public var eventname:String;
			public var eventtype:String;
			public var sourceobj:String;
			public var accessobj:String;
			public var start:String;
			public var end:String;
			public var sort:String;
			public var dir:String;
			public function InterposeLogModel():void{
				no="";
				logid="";
				logtype="";
				logtime="";
				eventname="";
				eventtype="";
				sourceobj="";
				accessobj="";
				id="";
				sort="";
				dir="";
				start="";
				end="";	
			}
		}
}