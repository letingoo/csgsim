package sourceCode.resManager.resNode.Events
{
	import flash.events.Event;
	
	import sourceCode.resManager.resNode.model.Fiber;
	import sourceCode.resManager.resNode.model.Testframe;
	
	
	public class testevent extends Event
	{
		public var result:String; 
		
		public function testevent(type:String,result:String)
		{
			
			super(type);
			//super(type);
			this.result = result;
		}
	}
}