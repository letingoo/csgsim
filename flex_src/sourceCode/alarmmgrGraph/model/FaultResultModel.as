package sourceCode.alarmmgrGraph.model
{
	import mx.collections.ArrayCollection;

	[Bindable]	
	[RemoteClass(alias="alarmMgr.model.FaultResultModel")] 
	public class FaultResultModel
	{
		public var totalCount:int;
		public var faultList:ArrayCollection;
		public function FaultResultModel()
		{
			totalCount=0;
			faultList = new ArrayCollection();
		}
	}
}