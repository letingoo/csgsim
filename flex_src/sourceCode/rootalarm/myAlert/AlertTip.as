package sourceCode.rootalarm.myAlert {
	
	import flash.display.Sprite;
	
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	
	public class AlertTip{
		
		public static var globalDelay:uint = 1000;
		public static var arrAlert:Array = new Array();
		
		public function AlertTip(){
			
		}
		
		public static function show(yFrom:int, xFrom:int, message:String="", delay:int=-1, 
			modal:Boolean=false, initValue:Object=null, parent:Sprite=null,_visible:Boolean=true):AlertCanvas{
			if(delay<0) delay = globalDelay;
			if (!parent) parent = Sprite(Application.application);
			var alert:IFlexDisplayObject = PopUpManager.createPopUp(parent, AlertCanvas, modal);
			AlertCanvas(alert).msg = message;
			AlertCanvas(alert).delay = delay;
			AlertCanvas(alert).init = initValue;
			AlertCanvas(alert).yFrom = yFrom;
			AlertCanvas(alert).visible_ = _visible;
			AlertCanvas(alert).xFrom = xFrom;
			AlertCanvas(alert).modal = modal;
			//PopUpManager.centerPopUp(alert);
			arrAlert.push(alert);
			return AlertCanvas(alert);
		}
	}
	
}