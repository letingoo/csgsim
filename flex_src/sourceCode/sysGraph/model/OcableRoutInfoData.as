package sourceCode.sysGraph.model
{
	import mx.collections.ArrayCollection;

	[Bindable]	
	[RemoteClass(alias="fiberwire.model.OcableRoutInfoData")] 
	public class OcableRoutInfoData
	{
		public var systemName:String;
		public var stationNames:ArrayCollection;
		public var channelRoutModelData:ArrayCollection;
		
		public function OcableRoutInfoData()
		{   
			this.systemName = "";
			this.stationNames = new ArrayCollection();
			this.channelRoutModelData = new ArrayCollection();
		}
	}
}