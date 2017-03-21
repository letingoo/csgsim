package sourceCode.indexEvaluation.model
{
	[Bindable]
	[RemoteClass(alias="indexEvaluation.model.IndexEvaModel")]
	public class IndexEvaluation
	{
		public var id:String="";
		public var name:String="";
		public var type:String="";
		public var value:String="";
		public var unit:String="";
		
		public var dept:String="";
		
		public var network:String="";
		public var relateType:String="";//相关类型
		public var self_healing_value:String="";//自愈值
		public var weight:String="";//权重
		public var first_level:String="";
		public var score:String="";//专家打分值
		public var starttime:String="";
		
		public var start:String;
		public var end:String;
		public var sort:String="";
		public var dir:String="asc";
		
		public function IndexEvaluation()
		{
		}
	}
}