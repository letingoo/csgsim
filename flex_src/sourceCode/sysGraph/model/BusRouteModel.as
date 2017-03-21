package sourceCode.sysGraph.model
{
	[Bindable]	
	[RemoteClass(alias="bussiness_route.model.bussiness_route_model")] 
	public class BusRouteModel
	{
		public var busid:String;
		public var busname:String;
		public var bustype:String;
		public var mainroute:String;
		public var backuproute1:String;
		public var backuproute2:String;
		public function BusRouteModel()
		{
			busid="";
			busname="";
			bustype="";
			mainroute="";
			backuproute1="";
			backuproute2="";
			
		}
	}
}