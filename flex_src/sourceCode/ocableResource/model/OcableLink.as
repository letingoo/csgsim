/**
 * Web App Solution Confidential Information
 * Copyright 2010, Web App Solution
 *
 * Created 2010.12.14
 * @author 王金山
 *
 * Maintenance list:
 */
package sourceCode.ocableResource.other
{
	import twaver.Link;
	import twaver.Node;
	import twaver.ShapeLink;

	public class OcableLink extends ShapeLink
	{
		[Bindable] public var ocableData:Object;
		public var ocableCode:String;
		public var ocabletype:String;
		public var ocabletype_a:String;
		public var ocabletype_z:String;
		public var ocablelength:String;
		
		public function OcableLink(id:String,from:Node,to:Node)
		{
			super(id,from,to);	
		}
	}
}