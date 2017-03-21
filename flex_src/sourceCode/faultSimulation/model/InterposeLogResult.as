package sourceCode.faultSimulation.model
{
	import mx.collections.ArrayCollection;

	[Bindable]	
	[RemoteClass(alias="faultSimulation.model.InterposeLogResult")]
	public class InterposeLogResult
	{
		public var totalCount:int;
		public var logList:ArrayCollection;
		public function InterposeLogResult()
		{
			totalCount=0;
			logList=new ArrayCollection();
		}
	}
}