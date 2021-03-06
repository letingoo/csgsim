// ActionScript file
import mx.controls.Alert;

import sourceCode.resManager.resNode.model.Fiber;
import sourceCode.resManager.resNode.model.Testframe;
[Event(name="fibersSearchEvent",type="sourceCode.resManager.resNode.Events.FibersSearchEvent")]
import common.actionscript.MyPopupManager;
import mx.managers.PopUpManager;
import sourceCode.resManager.resNode.Events.FibersSearchEvent;
import flash.events.Event;

public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");	

private function init(){
	this.title="查询";
}

private function searchClickHandler(event:MouseEvent):void{
	var fiber:Testframe = new Testframe();
	fiber.ocablename=txtOcablename.text;
	fiber.updatedate_start=dfstartBuildDate.text;
	fiber.updatedate_end=dfendBuildDate.text;
	fiber.aendeqport=txtAENDEQPORT.text;
	fiber.zendeqport=txtZENDEQPORT.text;
	
/*	if(cmbStatus.selectedIndex != -1){
		fiber.status=cmbStatus.selectedItem.@label;
	}
	
	if(cmbProperty.selectedIndex != -1){
		fiber.property=cmbProperty.selectedItem.@label;
	}*/
	//new spec object
	
	this.dispatchEvent(new FibersSearchEvent("fibersSearchEvent",fiber));
	MyPopupManager.removePopUp(this);
	//Alert.show("fuck");
}

private function clear_clickHandler(event:MouseEvent):void{
	this.txtOcablename.text="";
	this.txtAENDEQPORT.text="";
	this.txtZENDEQPORT.text="";
	this.dfstartBuildDate.text="";
	this.dfendBuildDate.text="";
}