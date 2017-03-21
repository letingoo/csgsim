package sourceCode.faultSimulation.model
{
	[Bindable]	
	[RemoteClass(alias="faultSimulation.model.SceneManager")]
	public class SceneModel
	{
		public var no:String = "";
		public var projectid:String="";
		public var projectname:String="";
		public var user_id:String="";
		public var user_name:String="";
		public var remark:String="";
		public var updateperson:String="";
		public var updatetime:String="";
		
		public var dataresource:String="";
		public var state:String="";
		public var s_remark:String="";
		public var version_code:String="";
		public var version_label:String="";
		
		public var start:String;
		public var end:String;
		public var sort:String="I_PROJECT_ID";
		public var dir:String="asc";
		public function SceneModel()
		{
		}
	}
}