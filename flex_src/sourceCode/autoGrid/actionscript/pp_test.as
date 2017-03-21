// ActionScript file
import mx.controls.Alert;

import sourceCode.resManager.resNode.model.Fiber;
import sourceCode.resManager.resNode.model.Testframe;
[Event(name="fibersSearchEvent",type="sourceCode.resManager.resNode.Events.FibersSearchEvent")]
import common.actionscript.MyPopupManager;
import mx.managers.PopUpManager;
import sourceCode.resManager.resNode.Events.FibersSearchEvent;
import sourceCode.resManager.resNode.Events.ModifyEvent;
import flash.events.Event;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;
import mx.utils.ObjectProxy;
import common.actionscript.ModelLocator;
public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");	
public var tframe:Testframe; 
public var stp:Array;
private function init(){
	//txtAENDEQPORT.text=tframe;
	/*txtOcablename.text=stp[0];
	txtCircuitname.text=stp[1];
	txtAENDEQPORT.text=stp[2];
	txtZENDEQPORT.text=stp[3];*/
	
//	Alert.show("123");
}

private function searchClickHandler(event:MouseEvent):void{
	var fiber:Testframe = new Testframe();
	fiber.ocablename=txtOcablename.text;
	fiber.aendeqport=txtAENDEQPORT.text;
	fiber.zendeqport=txtZENDEQPORT.text;
	fiber.fiberserial=txtCircuitname.text;
	
	var remoteObject:RemoteObject=new RemoteObject("resNodeDwr");
	remoteObject.endpoint = ModelLocator.END_POINT;
	remoteObject.showBusyCursor = true;
	remoteObject.addrectest(fiber);
	remoteObject.addEventListener(ResultEvent.RESULT,addrecResult);

}

public function addrecResult(event:ResultEvent):void{
	if(event.result.toString()=="success")
	{
		ModelLocator.showSuccessMessage("添加成功!",this);
		this.dispatchEvent(new ModifyEvent("ModifyEvent"));
	}else
	{
		ModelLocator.showErrorMessage("添加失败!",this);
	}
	MyPopupManager.removePopUp(this);
}


private function clear_clickHandler(event:MouseEvent):void{
	this.txtOcablename.text="";
	this.txtAENDEQPORT.text="";
	this.txtZENDEQPORT.text="";
	this.dfstartBuildDate.text="";
	this.dfendBuildDate.text="";
}