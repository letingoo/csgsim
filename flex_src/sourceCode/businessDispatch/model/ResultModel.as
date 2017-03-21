package sourceCode.businessDispatch.model
{
	import mx.collections.ArrayCollection;

	[Bindable]	
	[RemoteClass(alias="businessDispatch.model.ResultModel")] 
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