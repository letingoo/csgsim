package sourceCode.sysGraph.model
{
	import mx.collections.ArrayCollection;
	[Bindable]	
	[RemoteClass(alias="netres.model.ResultModel")] 
	public class BusResultModel
	{
		public var totalCount:int;
		public var orderList:ArrayCollection;
		public function BusResultModel()
		{
			
			{
				totalCount=0;
				orderList=new ArrayCollection();
			}
		}
	}
}