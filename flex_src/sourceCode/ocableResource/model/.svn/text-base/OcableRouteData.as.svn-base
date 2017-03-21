package sourceCode.ocableResource.model
{
	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias="ocableResources.model.OcableRouteData")]
	public class OcableRouteData
	{
		/** 图形XML*/
		public var xml:String;
		
		/** A向路由列表XML */
		public var routeXmlA:String;
		
		/** A向路由列表XML */
		public var routeXmlB:String;

		/** 局站或T接列表*/
		public var stationList:ArrayCollection;

		/** A向路由*/
		public var listRouteA:ArrayCollection;

		/** B向路由 */
		public var listRouteB:ArrayCollection;

		public var content:OcableRouteContent;
		
		public function OcableRouteData()
		{
			this.xml="";
			this.routeXmlA="";
			this.routeXmlB="";
			this.stationList=new ArrayCollection();
			this.listRouteA=new ArrayCollection();
			this.listRouteB =new ArrayCollection();
			this.content = new OcableRouteContent();
		}
	}
}