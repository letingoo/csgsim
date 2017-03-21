package sourceCode.ocableTopo.model
{
	[Bindable]	
	[RemoteClass(alias="mapResourcesInfo.model.SeparatorNewModel")] 
	public class ocableSectionNew
	{
		
		public var subsectioncode:String;
		public var sectioncode:String;
		public var separator_a:String;
		public var a_type:String;
		public var separator_z:String;
		public var z_type:String;
		public var serial:String;

		public function ocableSectionNew()
		{
			
			subsectioncode = "";
			sectioncode = "";
			separator_a = "";
			a_type = "";
			separator_z = "";
			z_type = "";
			serial = "";

		}
	}
}