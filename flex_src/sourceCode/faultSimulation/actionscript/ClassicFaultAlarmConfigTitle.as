// ActionScript file


import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.actionscript.Registry;
import common.other.events.CustomEvent;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.controls.Alert;
import mx.core.Application;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.formatters.DateFormatter;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;
import mx.utils.StringUtil;

import sourceCode.faultSimulation.model.ClassicFaultAlarmConf;
import sourceCode.faultSimulation.titles.SelectAlarmInfoOneTitle;
import sourceCode.resManager.resNode.Titles.SearchEquipTitle;

public var alarmid:String="";
public var oper_id:String="";//父页面传过来的参数
public var parent_systemcode:String="";
public var parent_equipcode:String="";

public var interposeModel:ClassicFaultAlarmConf = new ClassicFaultAlarmConf();


/**
 * 初始化函数
 */ 
public function init():void{
	//初始化
	getTransSystemLst();
	getEquipVendor();
}

//查询传输系统
public function getTransSystemLst():void{
	var re:RemoteObject=new RemoteObject("businessAnalysis");
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.addEventListener(ResultEvent.RESULT,getTransSystemLstResultHandler);
	Application.application.faultEventHandler(re);
	re.getTranSystemLst();
}

protected function getTransSystemLstResultHandler(event:ResultEvent):void{
	var list:XMLList = new XMLList(event.result);
	transsystem.dataProvider = list;
	transsystem.dropdown.dataProvider = list;
	transsystem.labelField="@label";
	transsystem.text="";
	transsystem.selectedIndex=-1;
}
/**
 * 查询设备
 */ 
private function eqsearchHandler(event:MouseEvent):void{
	if(transsystem.selectedItem!=null){
		parent_systemcode = transsystem.selectedItem.@code;
	}
	var parent_vendor:String="";
	if(vendor.selectedItem!=null){
		parent_vendor = vendor.selectedItem.@id;
	}
	var packeqsearch:SearchEquipTitle=new SearchEquipTitle();
	packeqsearch.page_parent=this;
	packeqsearch.child_systemcode=parent_systemcode;
	packeqsearch.child_vendor=parent_vendor;
	PopUpManager.addPopUp(packeqsearch,this,true);
	PopUpManager.centerPopUp(packeqsearch);
	packeqsearch.myCallBack=this.EuipFrameSerial;
	
}

private function EuipFrameSerial(obj:Object):void{
	if(cmbEquipment.text!=null){
		parent_equipcode=obj.name;//id
		var rt:RemoteObject=new RemoteObject("resNodeDwr");
		rt.endpoint=ModelLocator.END_POINT;
		rt.showBusyCursor=true;
		rt.getFrameserialByeId(parent_equipcode);
		rt.addEventListener(ResultEvent.RESULT, getEquipFrameSerialByEquipcode);
		Application.application.faultEventHandler(rt);
	}
}

/**
 *获取了机框数据后的 ，给cmbEquipframe赋值
 * @param event
 * 
 */
public function getEquipFrameSerialByEquipcode(event:ResultEvent):void
{
	if (event.result != null && event.result.toString() != "")
	{
		var comboData:XMLList=new XMLList(event.result);
		belongframe.dropdown.dataProvider=comboData;
		belongframe.dataProvider=comboData;
		belongframe.labelField = "@label";
		belongframe.text="";
		belongframe.selectedIndex=-1;
	}
}


public function getEquipVendor():void{
	var re:RemoteObject=new RemoteObject("resNetDwr");
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.addEventListener(ResultEvent.RESULT,getX_VendorLstHandler);
	Application.application.faultEventHandler(re);
	re.getX_VendorLst();
}
private function getX_VendorLstHandler(event:ResultEvent):void{
	var list:XMLList = new XMLList(event.result);
	vendor.dataProvider = list;
	vendor.dropdown.dataProvider = list;
	vendor.labelField="@label";
	vendor.text="";
	vendor.selectedIndex=-1;
}

//查询告警列表
protected function queryAlarmInfoHandler(event:MouseEvent):void{
	if(vendor.text!=null&&vendor.text!=""){
		var alarmInfo:SelectAlarmInfoOneTitle = new SelectAlarmInfoOneTitle();
		PopUpManager.addPopUp(alarmInfo,this,true);
		PopUpManager.centerPopUp(alarmInfo);
		alarmInfo.x_vendor = vendor.selectedItem.@id;
		alarmInfo.init();
		alarmInfo.myCallBack=this.selectAlarmInfoHandler;
	}else{
		Alert.show("请先选择设备厂家！","提示");
		return;
	}
	
}

protected function selectAlarmInfoHandler(obj:Object):void{
	var name:String=obj.name;
	var id:String=obj.id;
	alarmname.text=name;
	alarmid = id;
}


private function equipframeChangeHandler(event:ListEvent):void{
	//机框修改时处理函数,根据设备编号和机框序号查找机槽
	var frameserial:String=belongframe.selectedItem.@code;
	var rt:RemoteObject=new RemoteObject("resNodeDwr");
	rt.endpoint=ModelLocator.END_POINT;
	rt.showBusyCursor=true;
	rt.getEuipSlotSerialByFrame(parent_equipcode, frameserial);
	rt.addEventListener(ResultEvent.RESULT, getEquipSlotSerialByEquipcode);
	Application.application.faultEventHandler(rt);
}

/**
 *获取机槽数据后处理函数
 * @param event
 * 
 */
public function getEquipSlotSerialByEquipcode(event:ResultEvent):void
{
	if (event.result != null && event.result.toString() != "")
	{
		var comboData:XMLList=new XMLList(event.result);
		belongslot.text="";
		belongslot.selectedIndex=-1;
		belongslot.labelField="@label";
		belongslot.dropdown.dataProvider=comboData;
		belongslot.dataProvider=comboData;
	}
	
}

//查询机盘序号
public function itemSelectChangeHandler(event:ListEvent):void{
	if(belongframe.selectedItem==null){
		Alert.show("请先选择机框！","提示");
		return;
	}
	var frameserial:String=belongframe.selectedItem.@code;
	var slotserial:String = belongslot.selectedItem.@id;
	var rt:RemoteObject=new RemoteObject("resNetDwr");
	rt.endpoint=ModelLocator.END_POINT;
	rt.showBusyCursor=true;
	rt.getPackseriaByEuipSlot(parent_equipcode, frameserial,slotserial);
	rt.addEventListener(ResultEvent.RESULT, getEquipPackSerialHandler);
	Application.application.faultEventHandler(rt);
}

public function getEquipPackSerialHandler(event:ResultEvent):void
{
	if (event.result != null && event.result.toString() != "")
	{
		var comboData:XMLList=new XMLList(event.result);
		belongpack.text="";
		belongpack.selectedIndex=-1;
		belongpack.labelField="@label";
		belongpack.dropdown.dataProvider=comboData;
		belongpack.dataProvider=comboData;
	}
	
}

private function equippackChangeHandler(event:ListEvent):void{
	if(belongframe.selectedItem==null){
		Alert.show("请先选择机框！","提示");
		return;
	}
	if(belongslot.selectedItem==null){
		Alert.show("请先选择机槽！","提示");
		return;
	}
	var frameserial:String=belongframe.selectedItem.@code;
	var slotserial:String = belongslot.selectedItem.@id;
	var packserial:String = belongpack.selectedItem.@id;
	var rt:RemoteObject=new RemoteObject("resNodeDwr");
	rt.endpoint=ModelLocator.END_POINT;
	rt.showBusyCursor=true;
	rt.getPortseriaByIds(parent_equipcode, frameserial,slotserial,packserial);
	rt.addEventListener(ResultEvent.RESULT, getEquipPortSerialHandler);
	Application.application.faultEventHandler(rt);
}

public function getEquipPortSerialHandler(event:ResultEvent):void
{
	if (event.result != null && event.result.toString() != "")
	{
		var comboData:XMLList=new XMLList(event.result);
		belongport.text="";
		belongport.selectedIndex=-1;
		belongport.labelField="@label";
		belongport.dropdown.dataProvider=comboData;
		belongport.dataProvider=comboData;
	}
	
}

/**
 *添加或修改按钮的处理函数 
 * @param event
 * 
 */
protected function btn_clickHandler(event:MouseEvent):void
{
	var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
	remoteObject.endpoint = ModelLocator.END_POINT;
	remoteObject.showBusyCursor = true;
	if (transsystem.selectedItem ==null)
	{
		Alert.show("请选择传输系统", "提示");
		return;
	}
	else
	{
		interposeModel.BELONGTRANSYS=transsystem.selectedItem.@label;
	}
	if (vendor.selectedItem == null){
		Alert.show("请选择设备厂家！", "提示");
		return;
	}else{
		interposeModel.VENDOR = vendor.selectedItem.@id;
	}
	if(cmbEquipment.text == null||cmbEquipment.text==""){
		Alert.show("请选择设备！", "提示");
		return;
	}else{
		interposeModel.BELONGEQUIP = parent_equipcode;
	}
	if(alarmname.text == null||alarmname.text==""){
		Alert.show("请选择告警！", "提示");
		return;
	}else{
		interposeModel.ALARMID = alarmid;
		interposeModel.ALARMDESC = alarmname.text;
	}
	if(objclass.selectedItem == null){
		Alert.show("请选择告警位置！", "提示");
		return;
	}else{
		interposeModel.OBJCLASS = objclass.selectedItem.data;
	}
	if(isrootalarm.selectedItem == null){
		Alert.show("请选择是否根告警！", "提示");
		return;
	}else{
		interposeModel.ISROOTALARM = isrootalarm.selectedItem.data;
	}
	
	if(belongframe.selectedItem!=null){
		interposeModel.BELONGFRAME = belongframe.selectedItem.@code;
	}else{
		interposeModel.BELONGFRAME = "";
	}
	if(belongslot.selectedItem!=null){
		interposeModel.BELONGSLOT = belongslot.selectedItem.@id;
	}else{
		interposeModel.BELONGSLOT = "";
	}
	if(belongpack.selectedItem!=null){
		interposeModel.BELONGPACK = belongpack.selectedItem.@id;
	}else{
		interposeModel.BELONGPACK = "";
	}
	if(belongport.selectedItem!=null){
		interposeModel.BELONGPORT = belongport.selectedItem.@code;
	}else{
		interposeModel.BELONGPORT = "";
	}
	interposeModel.FAULTID=oper_id;
	
	remoteObject.addEventListener(ResultEvent.RESULT,addInterposeAlarmConfigResult);
	remoteObject.addClassicFaultAlarmConfig(interposeModel);
}
/**
 *添加经数据交互后的的界面提示处理
 * @param event
 * 
 */
protected function addInterposeAlarmConfigResult(event:ResultEvent):void{
	if(event.result.toString()=="success")
	{
		Alert.show("添加成功!","提示");
		PopUpManager.removePopUp(this);
	}else
	{
		Alert.show("请按要求填写数据！","提示");
	}
}


