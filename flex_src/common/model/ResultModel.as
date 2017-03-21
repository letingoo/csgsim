package common.model
{
	import mx.collections.ArrayCollection;
	
	[Bindable]	
	[RemoteClass(alias="common.model.ResultModel")] 
	public class ResultModel
	{
		public var totalCount:int;
		public var orderList:ArrayCollection;
		public var rateList:ArrayCollection;
		public function ResultModel()
		{
			totalCount=0;
			orderList=new ArrayCollection();
			rateList=new ArrayCollection();
		}
	}
}