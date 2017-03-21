package sourceCode.wireConfiguration.model
{
	import mx.collections.ArrayCollection;
	
	[Bindable]	
	[RemoteClass(alias="wireConfiguration.model.ResultModel")] 
	public class ResultModel
	{
		public var totalCount:int;
		public var orderList:ArrayCollection;
		public function ResultModel()
		{
			totalCount=0;
			orderList=new ArrayCollection();
		}
	}
}