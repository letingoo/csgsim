package common.util
{
	import common.model.RemoteObjectResult;
	
	import mx.controls.Alert;
//	import mx.core.FlexGlobals;
	import mx.managers.BrowserManager;
	import mx.managers.IBrowserManager;
	import mx.rpc.AbstractOperation;
	import mx.rpc.AsyncToken;
	import mx.rpc.CallResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	import common.actionscript.ModelLocator;

	public class RemoteObjectUtil extends RemoteObject
	{

		public function RemoteObjectUtil(destination:String) {
			super(destination);
		}

		public function call(methodName:String, callback:Function, ...args):void {
			var method:AbstractOperation = this.getOperation(methodName);
			method.arguments = args;
//			endpoint = FlexGlobals.topLevelApplication.endPoint;
			endpoint = ModelLocator.getEndPoint();
			showBusyCursor = true;
			var call:AsyncToken = method.send();
			call.userDefinedCallback = callback;
			call.addResponder(new Responder(resultCallback, faultCallback));
		}
		
//		public function callWithNoBusyCursor(methodName:String, callback:Function, ...args):void {
//			var method:AbstractOperation = this.getOperation(methodName);
//			method.arguments = args;
//			endpoint = ModelLocator.getEndPoint();
////			endpoint = FlexGlobals.topLevelApplication.endPoint;
//			showBusyCursor = false;
//			var call:AsyncToken = method.send();
//			call.userDefinedCallback = callback;
//			call.addResponder(new Responder(resultCallback, faultCallback));
//		}

		public function resultCallback(event:ResultEvent):void {
			var callback:Function = event.token.userDefinedCallback as Function;
			if (callback != null) {
				var result:RemoteObjectResult = new RemoteObjectResult();
				result.error = false;
				result.resultData = event.result;
				callback(result);
			}
		}

		public function faultCallback(event:FaultEvent):void {
			var callback:Function = event.token.userDefinedCallback as Function;
			if (callback != null) {
				var result:RemoteObjectResult = new RemoteObjectResult();
				result.error = true;
				result.errorMessage = event.fault.toString();
				callback(result);
			}
		}
	}
}