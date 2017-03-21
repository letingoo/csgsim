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
	import twaver.Node;
		
	public class StationNode extends Node
	{
		public var stationCode:String;
		public var nodeType:String;
		public var isTnode:String;
		
		public function StationNode(id:String = null)
		{
			super(id);
		}
	}
}