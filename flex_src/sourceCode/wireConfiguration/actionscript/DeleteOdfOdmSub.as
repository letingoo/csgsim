import common.actionscript.ModelLocator;

import mx.collections.ArrayCollection;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

public var odfodmcode:String;
public var startserial:String;
public var listSubOdfOdm:ArrayCollection;

private function save():void{
	var ro:RemoteObject = new RemoteObject("wireConfiguration");
	ro.endpoint= ModelLocator.END_POINT;
	ro.showBusyCursor = true;
	ro.deleteOdfOdmSub(cmbStart.selectedIndex,cmbEnd.selectedIndex,listSubOdfOdm,parentApplication.curUser);
	ro.addEventListener(ResultEvent.RESULT,wireconfigResultHandler);
}

private function wireconfigResultHandler(evetn:ResultEvent):void{
	PopUpManager.removePopUp(this);
	dispatchEvent(new Event("saveCompleteHandler"));
}	
private function close():void{
	PopUpManager.removePopUp(this);
}