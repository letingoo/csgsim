// ActionScript file
package sourceCode.ocableroute.model
{
	[Bindable]	
	[RemoteClass(alias="ocableroute.model.OcableRouteContent")] 
	public class OcableRouteContent
	{

		public var fiberroutecode:String;

		public var content:String;

		public var astationcode:String;

		public var astationname:String;

		public var zstationcode:String;

		public var zstationname:String;

		public var updatedate:String;

		public var updateperson:String;

		public function OcableRouteContent()
		{
			this.fiberroutecode="";
			this.content="";
			this.astationcode="";
			this.astationname="";
			this.zstationcode="";
			this.zstationname="";
			this.updatedate="";
			this.updateperson="";
		}
	}
}