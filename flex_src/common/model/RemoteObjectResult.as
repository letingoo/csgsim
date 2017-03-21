package common.model
{
	import mx.rpc.events.FaultEvent;

	public class RemoteObjectResult
	{
		public var error:Boolean = false;
		public var errorMessage:String = null;
		public var resultData:Object = null;
	}
}