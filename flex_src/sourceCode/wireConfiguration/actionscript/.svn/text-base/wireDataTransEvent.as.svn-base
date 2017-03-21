package sourceCode.wireConfiguration.actionscript
{
	import flash.events.Event;
	public class wireDataTransEvent extends Event
	{
		public var Type:String;
		public var PortCode:String;
		public var  PortType:String;
		public var McCode:String;
		
		
		public function wireDataTransEvent(type:String,portcode:String,porttype:String,mccode:String)
		{
			super(type);
			this.Type = type;
			this.PortCode = portcode;
			this.PortType = porttype;
			this.McCode = mccode;
		}
		
		override public function clone():Event
		{
			return new wireDataTransEvent(Type,PortCode,PortType,McCode);
		}
	}
}