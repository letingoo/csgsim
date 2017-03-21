package common.other.blogagic.util
{
	import mx.collections.ArrayCollection;
	
	import twaver.Consts;
	import twaver.Node;
	import twaver.Styles;

	public class mapNode extends Node
	{
		
		public var data:Object = new Object();
		
		public var status:String="";
		public var isOlder:Boolean = false;
		public var isNew:Boolean = false;
		public var isInsert:Boolean = false;
		public var isUpDate:Boolean = false;
		public var isDelete:Boolean = false;

		public function mapNode(id:String = null)
		{
			super(id);
			this.setStyle(Styles.IMAGE_STRETCH,Consts.STRETCH_FILL);
		}
	}
}