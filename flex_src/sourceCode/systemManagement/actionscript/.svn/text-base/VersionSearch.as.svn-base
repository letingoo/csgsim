// ActionScript file
import mx.controls.Alert;

import sourceCode.systemManagement.model.VersionModel;
[Event(name="versionSearchEvent",type="sourceCode.systemManagement.events.VersionSearchEvent")]
import common.actionscript.MyPopupManager;
import mx.managers.PopUpManager;
import sourceCode.systemManagement.events.VersionSearchEvent;

public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");	

private function init(){
	txtvid.text="";
	txtvname.text="";
	txtfromvname.text="";
	this.title="查询";
}

private function searchClickHandler(event:MouseEvent):void{
	var version:VersionModel = new VersionModel();
	version.vid=txtvid.text;
	version.vname=txtvname.text;
	version.from_vname=txtfromvname.text;
	this.dispatchEvent(new VersionSearchEvent("versionSearchEvent",version));
	MyPopupManager.removePopUp(this);
}

private function clear_clickHandler(event:MouseEvent):void{
	this.txtvid.text="";
	this.txtvname.text="";
	this.txtfromvname.text="";
}