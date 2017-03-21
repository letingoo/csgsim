// ActionScript file
/**
 * Title: 逻辑端口查询
 * Description:  逻辑端口查询调用方法
 * @version: v.1
 * @author: yangzhong 
 * @copyright:
 * @date: 2013-7-15
 */

import common.actionscript.ModelLocator;

import mx.core.Application;
import mx.events.ListEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import sourceCode.resManager.resNet.events.LogicPortSearchEvent;
import sourceCode.resManager.resNet.model.LogicPort;

[Event(name="LogicPortSearchEvent",type="sourceCode.resManager.resNet.Events.LogicPortSearchEvent")]

import common.actionscript.MyPopupManager;

import mx.managers.PopUpManager;
//以下是xj加的
import sourceCode.resManager.resNode.Titles.SearchSlotTitle;
import sourceCode.resManager.resNet.titles.SearchEquipTimeTitle;
import common.other.events.CustomEvent;
//从选择设备的子页面传回来的code
import mx.controls.Alert;
import sourceCode.resManager.resNet.titles.SearchEquipOrderBySystem;
import flash.events.MouseEvent;

private var parenteqcode:String="";

//保存选择完系统的code,传给选择设备的子页面
[Bindable]private var parent_systemcode:String;


public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");	
/**
 *重置 
 * @param event
 * 
 */
protected function button1_clickHandler(event:MouseEvent):void
{
	cmbEquipment.text = "";
	cmbFrameserial.dropdown.dataProvider=null;
	cmbFrameserial.text = "";
	cmbFrameserial.selectedIndex = -1;
	
	cmbFlotserial.dropdown.dataProvider=null;
	cmbFlotserial.text = "";
	cmbFlotserial.selectedIndex = -1;
	
	cmbPackserial.dropdown.dataProvider=null;
	cmbPackserial.text = "";
	cmbPackserial.selectedIndex = -1;
	
	cmbY_porttype.selectedIndex = -1;
	txtPortserial.dropdown.dataProvider=null;
	txtPortserial.text = "";
	txtPortserial.selectedIndex = -1;
	
	dfstartUpdateDate.text = "";
	dfendUpdateDate.text = "";
	
}

/**
 *查询按钮的处理函数 
 * @param event
 * 
 */
protected function searchClickHandler(event:MouseEvent):void
{
	var logicPortModel:LogicPort = new LogicPort();
	logicPortModel.equipcode = equipcode.text;
	if(cmbFrameserial.selectedItem != null)
		logicPortModel.frameserial = cmbFrameserial.selectedItem.@code;
	if(cmbFlotserial.selectedItem != null)
		logicPortModel.slotserial = cmbFlotserial.selectedItem.@code;
	if(cmbPackserial.selectedItem != null)
		logicPortModel.packserial = cmbPackserial.selectedItem.@id;
	if(txtPortserial.selectedItem != null)
		logicPortModel.portserial = txtPortserial.selectedItem.@code;
	if(cmbY_porttype.selectedItem != null)
		logicPortModel.y_porttype = cmbY_porttype.selectedItem.@label;
	logicPortModel.updatedate_start = dfstartUpdateDate.text;
	logicPortModel.updatedate_end = dfendUpdateDate.text;
	this.dispatchEvent(new LogicPortSearchEvent("LogicPortSearchEvent",logicPortModel));
	MyPopupManager.removePopUp(this);
}

///**
// * 
// * 设备选择事件
// * 双击之后，框的序号就可以选择了
// * */
//public function cmbEquipname_changeHandler(obj:Object):void
//{
//	parenteqcode=obj.name;
//	var rt:RemoteObject=new RemoteObject("netresDao");
//	rt.endpoint = ModelLocator.END_POINT;
//	rt.showBusyCursor = true;
//	rt.addEventListener(ResultEvent.RESULT,equipResultHandler);
//	Application.application.faultEventHandler(rt);
//	rt.getEuipFrameSerial(parenteqcode);
//	
//	
//}
///**
// *选择设备后给机框赋值
// * @param event
// * 
// */
//private function equipResultHandler(event:ResultEvent):void{
//	var xml:XMLList = new XMLList(event.result);
//	cmbFrameserial.dataProvider = xml;
//	cmbFrameserial.dropdown.dataProvider = xml;
//	cmbFrameserial.selectedIndex = -1;
//	cmbFlotserial.dataProvider = null;
//	cmbFlotserial.dropdown.dataProvider = null;
//	cmbPackserial.dataProvider = null;
//	cmbPackserial.dropdown.dataProvider = null;
//	
//	
//}

///**
// * 
// * 机框选择事件
// * 
// * */
//protected function cmbFrameserial_changeHandler(event:ListEvent):void
//{
//	var rt:RemoteObject=new RemoteObject("netresDao");
//	rt.endpoint = ModelLocator.END_POINT;
//	rt.showBusyCursor = true;
//	rt.addEventListener(ResultEvent.RESULT,frameserialResultHandler);
//	Application.application.faultEventHandler(rt);
//	rt.getEuipSlotSerialByFrame(parenteqcode,cmbFrameserial.selectedItem.@id.toString());
//}
///**
// *选择机框后，相应的会给 机槽和机盘赋值
// * @param event
// * 
// */
//private function frameserialResultHandler(event:ResultEvent):void{
//	var xml:XMLList = new XMLList(event.result);
//	cmbFlotserial.dataProvider = xml;
//	cmbFlotserial.dropdown.dataProvider = xml;
//	cmbFlotserial.selectedIndex = -1;
//	cmbPackserial.dataProvider = null;
//	cmbPackserial.dropdown.dataProvider = null;
//	
//}

///**
// * 
// * 机槽选择事件
// * 
// * */
//protected function cmbFlotserial_changeHandler(event:ListEvent):void
//{
//	var rt:RemoteObject=new RemoteObject("netresDao");
//	rt.endpoint = ModelLocator.END_POINT;
//	rt.showBusyCursor = true;
//	rt.addEventListener(ResultEvent.RESULT,packseriaResultHandler);
//	Application.application.faultEventHandler(rt);
//	rt.getPackseriaByEuipSlot(parenteqcode,
//		cmbFrameserial.selectedItem.@id.toString(),
//		cmbFlotserial.selectedItem.@id.toString());
//}
///**
// *选择机槽后会给机盘赋值 
// * @param event
// * 
// */
//private function packseriaResultHandler(event:ResultEvent):void{
//	var xml:XMLList = new XMLList(event.result);
//	cmbPackserial.dataProvider = xml;
//	cmbPackserial.dropdown.dataProvider = xml;
//	cmbPackserial.selectedIndex = -1;
//	
//}


//private function SystemChange(event:Event):void{
//	if(this.title!=null&&this.title=="查询"){
//		var systemcode:String = cmbSystemcode.selectedItem.@id;
//		parent_systemcode=systemcode;
//	}
//}

/**
 * 所属设备click的处理函数，弹出界面；选择设备
 * @param event
 * 
 */
protected function searchEquipment(event:MouseEvent):void{
	var sqsearch:SearchEquipOrderBySystem=new SearchEquipOrderBySystem();
	sqsearch.page_parent=this;
	PopUpManager.addPopUp(sqsearch,this,true);
	PopUpManager.centerPopUp(sqsearch);
	sqsearch.myCallBack=function(obj:Object){
		cmbEquipment.text=obj.name;
		equipcode.text = obj.id;
		var code:String = obj.id;
		var rt:RemoteObject=new RemoteObject("resNodeDwr");
		rt.endpoint=ModelLocator.END_POINT;
		rt.showBusyCursor=true;
		rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent){
			var eqsearchLst:XMLList= new XMLList(event.result);
			cmbFrameserial.dropdown.dataProvider=eqsearchLst;
			cmbFrameserial.dataProvider=eqsearchLst;
			cmbFrameserial.text="";
			cmbFrameserial.selectedIndex=-1;
		});
		rt.getFrameserialByeId(code);
	}
	
//	var packeqsearch:SearchSlotTitle=new SearchSlotTitle();
//	packeqsearch.page_parent=this;
//	packeqsearch.child_systemcode=null;
//	packeqsearch.child_vendor=null;
//	PopUpManager.addPopUp(packeqsearch,this,true);
//	PopUpManager.centerPopUp(packeqsearch);
//	packeqsearch.myCallBack=function(obj:Object){
//		cmbEquipment.text=obj.id;
//		equipcode.text = obj.name;
//		var code:String = obj.name;
//		var rt:RemoteObject=new RemoteObject("resNodeDwr");
//		rt.endpoint=ModelLocator.END_POINT;
//		rt.showBusyCursor=true;
//		rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent){
//			var eqsearchLst:XMLList= new XMLList(event.result);
//			cmbFrameserial.dropdown.dataProvider=eqsearchLst;
//			cmbFrameserial.dataProvider=eqsearchLst;
//			cmbFrameserial.text="";
//			cmbFrameserial.selectedIndex=-1;
//			
//		});
//		rt.getFrameserialByeId(code);
//	}
}

/**
 * 根据设备ID和机框ID查询机槽序号列表
 * 
 */
private function selectFrameSlotEvent(event:ListEvent):void{
	var code:String = equipcode.text;
	var frameSerial:String = cmbFrameserial.text;
	if(code!= null&&code!="" &&frameSerial!=null&&frameSerial!=""){
		var rt:RemoteObject=new RemoteObject("resNodeDwr");
		rt.endpoint=ModelLocator.END_POINT;
		rt.showBusyCursor=true;
		rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent){
			var eqsearchLst:XMLList= new XMLList(event.result);
			cmbFlotserial.dropdown.dataProvider=eqsearchLst;
			cmbFlotserial.dataProvider=eqsearchLst;
			cmbFlotserial.text="";
			cmbFlotserial.selectedIndex=-1;
			
		});
		rt.getSlotserialByeIds(code,frameSerial);
	}
}
/**
 * 根据设备ID、机框序号、机槽序号查询机盘序号列表
 *
 */  
private function selectSlotSerialEvent(event:ListEvent):void{
	var code:String = equipcode.text;
	var frameSerial:String = cmbFrameserial.text;
	var slotSerial:String = cmbFlotserial.text;
	if(code!= null&&code!="" &&frameSerial!=null&&frameSerial!=""&&slotSerial!=null&&slotSerial!=""){
		var rt:RemoteObject=new RemoteObject("resNetDwr");
		rt.endpoint=ModelLocator.END_POINT;
		rt.showBusyCursor=true;
		rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent){
			var eqsearchLst:XMLList= new XMLList(event.result);
			cmbPackserial.dropdown.dataProvider=eqsearchLst;
			cmbPackserial.dataProvider=eqsearchLst;
			cmbPackserial.text="";
			cmbPackserial.selectedIndex=-1;
			
		});
		rt.getPackseriaByEuipSlot(code,frameSerial,slotSerial);
	}
}

/**
 * 根据设备ID、机框序号、机槽序号、机盘序号查询端口列表
 *
 */  
private function selectPackSerialEvent(event:ListEvent):void{
	var code:String = equipcode.text;
	var frameSerial:String = cmbFrameserial.text;
	var slotSerial:String = cmbFlotserial.text;
	var packSerial:String = cmbPackserial.text;
	if(code!= null&&code!="" &&frameSerial!=null&&frameSerial!=""&&slotSerial!=null&&slotSerial!=""&&packSerial!=null&&packSerial!=""){
		var rt:RemoteObject=new RemoteObject("resNodeDwr");
		rt.endpoint=ModelLocator.END_POINT;
		rt.showBusyCursor=true;
		rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent){
			var eqsearchLst:XMLList= new XMLList(event.result);
			txtPortserial.dropdown.dataProvider=eqsearchLst;
			txtPortserial.dataProvider=eqsearchLst;
			txtPortserial.text="";
			txtPortserial.selectedIndex=-1;
			
		});
		rt.getPortseriaByIds(code,frameSerial,slotSerial,packSerial);
	}
}