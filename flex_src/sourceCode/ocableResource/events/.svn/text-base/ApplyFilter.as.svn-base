package  sourceCode.ocableResource.events
{
	import flash.events.Event;

	public class ApplyFilter extends Event
	{
		[Bindable]
		public var value:Object;
		[Bindable]
		public var searchType:String;
		
		public function ApplyFilter(value:Object, type:String,searchType:String=null)
		{
			super(type, true);
			this.value = value;
			this.searchType = searchType;
		}
	}
}