package sourceCode.sysGraph.model
{	
	[Bindable]	
	[RemoteClass(alias="bussiness_route.model.topolink_model")] 
	public class TopoModel
	{
		public var topocode:String;
		public var toponame:String;
		public var Equip_a:String;
		public var Equip_z:String;
	public function TopoModel()
		{
			topocode="";
			toponame="";
			Equip_a="";
			Equip_z="";
		}
	}
}