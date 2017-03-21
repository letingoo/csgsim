package sourceCode.sysGraph.model
{
	[Bindable]	
	[RemoteClass(alias="fiberwire.model.TopolinkRing")] 
	public class TopolinkRing
	{
		public var ringid:String;
		public var ringname:String;
		public var ringnum:String;	
		public var label:String;
		public var sparetopolink:String;
		public function TopolinkRing()
		{
			this.ringid=" ";
			this.ringname=" ";
			this.ringnum="0";		
			this.label=" ";
			this.sparetopolink=" ";
		}
		public function clear()
		{
			this.ringid=" ";
			this.ringname=" ";
			this.ringnum="0";		
			this.label=" ";
			this.sparetopolink=" ";
		}
	}
}