package sourceCode.rootalarm.model
{
	import mx.collections.ArrayCollection;

	[Bindable]	
	[RemoteClass(alias="com.metarnet.mnt.rootalarm.model.PoUpKeyBussinessModelResult")] 
	public class PoUpKeyBussinessResult
	{
		public function PoUpKeyBussinessResult()
		{
		}
		public var list :ArrayCollection;
		
		public var count:int;
	}
}