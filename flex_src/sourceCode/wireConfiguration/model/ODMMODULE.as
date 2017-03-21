package sourceCode.wireConfiguration.model
{
	import mx.collections.ArrayCollection;
	
	[Bindable]	
	[RemoteClass(alias="wireConfiguration.model.ODMMODULE")]
	public class ODMMODULE{
		public var  ODFODM_DATA:DMModel;
//		public var ODFODMPORT_DATA:ArrayCollection;
		public var ODFODM_SUB_DATA:ArrayCollection;
		
		public function ODMMODULE(){
			ODFODM_DATA = new DMModel();
//			ODFODMPORT_DATA = new ArrayCollection();
			ODFODM_SUB_DATA = new ArrayCollection();
		}
	}
}