package sourceCode.channelRoute.model
{
	import mx.collections.ArrayCollection;

	[Bindable]	
	[RemoteClass(alias="devicepanel.model.ResultModel")] 
	public class ResultModel
	{
		public var totalCount:int;
		public var orderList:ArrayCollection;
		public var string:String;
		public function ResultModel()
		{
			string="";
			totalCount=0;
			orderList=new ArrayCollection();
		}
	}
}