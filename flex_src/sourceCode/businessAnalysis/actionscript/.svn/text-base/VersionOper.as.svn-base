package sourceCode.businessAnalysis.actionscript
{
	import common.util.RemoteObjectUtil;
	
	import mx.collections.ArrayCollection;
	
	public class VersionOper
	{
		private static var ro:RemoteObjectUtil = new RemoteObjectUtil("businessAnalysis");
		
		public function VersionOper()
		{
		}
		public static function getAllLog(callback:Function):void{
			ro.call("getAllLog",callback);
		}
		public static function getBusinessFail(callback:Function, temp:Array){
			ro.call("getBusinessFail",callback,temp);
		}
		public static function getBusinessRe(callback:Function, temp:Array){
			ro.call("getBusinessRe",callback,temp);
		}
		
	}
}