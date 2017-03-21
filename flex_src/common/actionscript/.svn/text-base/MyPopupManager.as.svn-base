package common.actionscript
{
	import flash.display.DisplayObject;
	
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;

	public class MyPopupManager
	{
		public function MyPopupManager()
		{
		}
		
		public static function addPopUp(window:IFlexDisplayObject,
										modal:Boolean = false,
										childList:String = null):void
		{
			PopUpManager.addPopUp(window, DisplayObject(Application.application), modal, childList);
			PopUpManager.centerPopUp(window);
		}
		
		public static function removePopUp(popUp:IFlexDisplayObject):void
		{
			PopUpManager.removePopUp(popUp);
		}
		
		public static function bringToFront(popUp:IFlexDisplayObject):void
		{
			PopUpManager.bringToFront(popUp);
		}
	}
}