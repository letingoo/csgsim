package sourceCode.resManager.resBusiness.model
{
	[Bindable]	
	[RemoteClass(alias="resManager.resBusiness.model.CircuitChannel")] 
	public class CircuitChannelModel
	{
		public var no:String;
		/**
		 *电路编号 
		 */
		public var circuitcode:String;
		/**
		 *A端端口 
		 */
		public var porta:String;
		/**
		 *A端端口编号 
		 */
		public var portcode1:String;
		/**
		 *业务名称
		 */
		public var circuit:String;
		/**
		 *通道名称 
		 */
		public var channelcode:String;
		/**
		 *A端时隙 
		 */
		public var slot1:String;
		/**
		 *Z端端口 
		 */
		public var portz:String;
		/**
		 *Z端端口编号 
		 */
		public var portcode2:String;
		/**
		 *Z端时隙
		 */
		public var slot2:String;
		/**
		 *速率
		 */
		public var rate:String;
		
		public var sort:String;
		public var dir:String;
		public var start:String;
		public var end:String;
		
		public function CircuitChannelModel()
		{
			no="";
			circuitcode="";
			porta="";
			circuit="";
			channelcode="";
			portcode1 = "";
			portcode2 = "";
			slot1="";
			portz="";
			slot2="";
			rate="";
			sort = "circuitcode";
			dir = "asc";
			start = "0";
			end = "50";
		}
		public function clear():void
		{
			no="";
			circuitcode="";
			porta="";
			circuit="";
			channelcode="";
			portcode1 = "";
			portcode2 = "";
			slot1="";
			portz="";
			slot2="";
			rate="";
		}
	}
}