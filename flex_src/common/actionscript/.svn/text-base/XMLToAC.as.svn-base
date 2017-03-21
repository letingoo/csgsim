package common.actionscript
{
	import mx.collections.ArrayCollection;
	import mx.collections.XMLListCollection;
	import mx.utils.ObjectProxy;

	public class XMLToAC
	{
		public static function returnArrayCollection(value:String):ArrayCollection{
			if(value != null){
				var xml:XML = new XML(value);
				
				var xmllist:XMLListCollection = new XMLListCollection(xml.children());
				
				var ac:ArrayCollection =new  ArrayCollection();
				
				ac.source = xmllist.toArray();
				
				for (var i:int = 0;i < ac.length; i++) {
					ac[i] = new ObjectProxy(ac[i]);
				}
				
			}
			return ac;
		}
	}
}