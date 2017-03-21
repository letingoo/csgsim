// ActionScript file
import mx.controls.Alert;

import sourceCode.resManager.resNet.events.EquipmentSearchEvent;
import sourceCode.resManager.resNet.model.Equipment;

[Event(name="equipSearchEvent",type="sourceCode.resManager.resNet.events.EquipmentSearchEvent")]

import common.actionscript.MyPopupManager;
import mx.events.ListEvent;
import mx.managers.PopUpManager;
import mx.rpc.remoting.mxml.RemoteObject;
import common.actionscript.ModelLocator;
import mx.rpc.events.ResultEvent;
import mx.core.Application;


public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");	

protected function button1_clickHandler(event:MouseEvent):void
{
	
	s_sbmc.text = "";
	updatedate_start.text = "";
	updatedate_end.text = "";
	system_name.selectedIndex = -1;
	x_vendor.selectedIndex = -1;
//	equiptype.selectedIndex = -1;
	x_model.selectedIndex = -1;
}

//查询
protected function searchClickHandler(event:MouseEvent):void
{
	var equip:Equipment = new Equipment();
	equip.s_sbmc = s_sbmc.text;
	
	if(x_vendor.selectedItem != null){
		equip.x_vendor = x_vendor.selectedItem.@id;
		//这里用的是ID
		//		sdh.sdh_state = sdh_state.selectedItem.@label;
	}
	if(system_name.selectedItem != null){
		equip.system_name = system_name.selectedItem.@id;
	}
	if(x_model.selectedItem != null){
		equip.x_model = x_model.selectedItem.@label;
	}
//	if(equiptype.selectedItem != null){
//		equip.equiptype = equiptype.selectedItem.@id;
//	}
	equip.updatedate_end = updatedate_end.text;
	equip.updatedate_start = updatedate_start.text;
	
	this.dispatchEvent(new EquipmentSearchEvent("equipSearchEvent",equip));
	MyPopupManager.removePopUp(this);
}
/**
 *选择生产厂家 
 * @param event
 * 
 */
protected function comX_vendor_changeHandler(event:ListEvent):void
{
	var vendor:String=x_vendor.selectedItem.@id;
	var rt:RemoteObject=new RemoteObject("resNetDwr");
	Application.application.faultEventHandler(rt);
	rt.endpoint=ModelLocator.END_POINT;
	rt.showBusyCursor=true;
	rt.getX_modelLst(vendor);
	rt.addEventListener(ResultEvent.RESULT, X_modelHandler);
}
/**
 *获取厂家后给 给型号赋值
 * @param event
 * 
 */
public function X_modelHandler(event:ResultEvent):void
{
	var comboData:XMLList=new XMLList(event.result);
	x_model.dataProvider=comboData;
	x_model.dropdown.dataProvider=comboData;
	x_model.selectedIndex=-1;
}
