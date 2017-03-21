package sourceCode.systemManagement.model
{
	import mx.collections.ArrayCollection;
	
	[Bindable]	
	[RemoteClass(alias="netres.model.ProblemsModel")] 
	public class ProblemsModel
	{
		public var totalCount:int;
		public var orderList:ArrayCollection;
		public function ProblemsModel()
		{
			totalCount=0;
			orderList=new ArrayCollection();
		}
	}
}