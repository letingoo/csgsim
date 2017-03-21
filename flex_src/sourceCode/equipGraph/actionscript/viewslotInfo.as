	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	import twaver.Constant;
	public var equipcode:String = "";
	public var frameserial:String="";
	public var slotserial:String = "";
	public var packserial:String="";
	public var circuitcode:String = "";

	private function close():void  
	{  
		MyPopupManager.removePopUp(this); 
	}
	private function init():void{
		var rtobj:RemoteObject = new RemoteObject("devicePanel");
		rtobj.endpoint = ModelLocator.END_POINT;
		rtobj.showBusyCursor = true;
		rtobj.getSlotInfo(equipcode,frameserial,slotserial,packserial,circuitcode);//查询插槽信息
		rtobj.addEventListener(ResultEvent.RESULT, generateSlotInfo); 
		Application.application.faultEventHandler(rtobj);
	}
	private function generateSlotInfo(event:ResultEvent):void{
		var ac:ArrayCollection = ArrayCollection(event.result);
		soltList.dataProvider = ac;
		soltList.invalidateList();
	}

	private function faultGetSlotInfo(event:FaultEvent):void{
	}