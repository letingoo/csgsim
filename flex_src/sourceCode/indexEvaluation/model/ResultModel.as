package sourceCode.indexEvaluation.model
{
	import mx.collections.ArrayCollection;
	[Bindable]	
	[RemoteClass(alias="indexEvaluation.model.ResultModel")] 
	public class ResultModel
	{
		public var score:Number;
		public var orderList:ArrayCollection;
		public function ResultModel()
		{
			score=0.0;
			orderList=new ArrayCollection();
		}
	}
}