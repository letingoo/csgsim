// ActionScript file
import mx.controls.Alert;

import sourceCode.resManager.resNet.events.CCSearchEvent;
import sourceCode.resManager.resNet.model.CCModel;

[Event(name="ccSearchEvent",type="sourceCode.resManager.resNet.events.CCSearchEvent")]

import common.actionscript.MyPopupManager;
import mx.events.ListEvent;
import mx.managers.PopUpManager;
import mx.rpc.remoting.mxml.RemoteObject;
import common.actionscript.ModelLocator;
import mx.rpc.events.ResultEvent;
import mx.core.Application;
import flash.events.MouseEvent;
import sourceCode.resManager.resNet.titles.SearchEquipOrderBySystem;


public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");	

protected function resetHandler(event:MouseEvent):void
{
	cmbEquipment.text = "";
	rate.text = "";
	aslot.text = "";
	zslot.text = "";
	updateperson.text ="";
	updatedate_start.text = "";
	updatedate_end.text = "";
}

//查询
protected function searchClickHandler(event:MouseEvent):void
{
	var ccModel:CCModel = new CCModel();
	ccModel.pid = cmbEquipment.text;
	ccModel.rate = rate.text;
	ccModel.aslot = aslot.text;
	ccModel.zslot = zslot.text;
	ccModel.updateperson = updateperson.text;
	ccModel.updatedate_end = updatedate_end.text;
	ccModel.updatedate_start = updatedate_start.text;
	
	this.dispatchEvent(new CCSearchEvent("ccSearchEvent",ccModel));
	MyPopupManager.removePopUp(this);
}

/**
 * 所属设备的click的处理函数，弹出界面；选择设备
 * @param event
 * 
 */
protected function eqsearchHandler(event:MouseEvent):void{
	var sqsearch:SearchEquipOrderBySystem=new SearchEquipOrderBySystem();
	sqsearch.page_parent=this;
	PopUpManager.addPopUp(sqsearch,this,true);
	PopUpManager.centerPopUp(sqsearch);
	sqsearch.myCallBack=this.cmbEquipname_changeHandler;
}
/**
 * 
 * 设备选择事件
 * 双击之后，框的序号就可以选择了
 * */
public function cmbEquipname_changeHandler(obj:Object):void
{	
//	parenteqcode=obj.id;
//	var rt:RemoteObject=new RemoteObject("resNodeDwr");
//	rt.endpoint = ModelLocator.END_POINT;
//	rt.showBusyCursor = true;
//	rt.addEventListener(ResultEvent.RESULT,equipResultHandler);
//	Application.application.faultEventHandler(rt);
//	rt.getEuipFrameSerial(parenteqcode);
//	
//	
}