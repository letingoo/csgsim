package sourceCode.businessAnalysis.actionscript
{
	import flash.events.Event;
	
	public class IndexChangeEvent extends Event
	{
		public static const CHANGE:String = "change";
		public static const CHANGING:String = "changing";
		public static const CARET_CHANGE:String = "caretChange";
		
		public function IndexChangeEvent(type:String, bubbles:Boolean = false,
										 cancelable:Boolean = false,
										 oldIndex:int = -1,
										 newIndex:int = -1)
		{
			super(type, bubbles, cancelable);
			
			this.oldIndex = oldIndex;
			this.newIndex = newIndex;
		}
		
		public var newIndex:int;
		public var oldIndex:int;
		/**
		 *  @private
		 */
		override public function clone():Event
		{
			return new IndexChangeEvent(type, bubbles, cancelable,
				oldIndex, newIndex);
		}
	}
}