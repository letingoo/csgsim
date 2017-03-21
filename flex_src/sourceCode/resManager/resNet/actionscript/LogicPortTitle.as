// ActionScript file
/**
 * Title: 逻辑端口添加，修改
 * Description:  逻辑端口添加，修改调用方法
 * @version: v.1
 * @author: yangzhong 
 * @copyright:
 * @date: 2013-7-15
 */

import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.other.events.CustomEvent;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.controls.Alert;
import mx.core.Application;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;
import mx.utils.StringUtil;

import sourceCode.resManager.resNet.model.LogicPort;
import sourceCode.resManager.resNet.titles.SearchEquipOrderBySystem;
import sourceCode.resManager.resNet.titles.SearchEquipTitle;


public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");	

[Bindable] public var logicPortData:Object;
//从选择设备的子页面传回来的code
private var parenteqcode:String="";
public var port_serial:String="";
public var flagStr:String="";
public var code:String="";
public var logicPortModel:LogicPort = new LogicPort();

public function setData():void{
	txtPortserial.text = logicPortData.portserial;
	txtUpdatePerson.text = logicPortData.updateperson;
	dfUpdateDate.text = logicPortData.updatedate;
	txtConnport.text=logicPortData.connport;
	txtRemark.text=logicPortData.remark;
	
	cmbX_capability.text =logicPortData.x_capability
	cmbY_porttype.text=logicPortData.y_porttype
	cmbStatus.text=logicPortData.status;
	cmbEquipment.text = logicPortData.equipname;
	cmbFrameserial.text = logicPortData.frameserial;
	cmbFlotserial.text = logicPortData.slotserial;
	cmbPackserial.text = logicPortData.packserial;
	
	cmbEquipment.enabled = false;
	cmbFrameserial.enabled = false;
	cmbFlotserial.enabled = false;
	cmbPackserial.enabled = false;
	
	
}

public function setPortType(xml:XMLList,id:String):void{
	cmbY_porttype.dataProvider = xml;
	for each(var item:Object in cmbY_porttype.dataProvider){
		if(item.@label == id){
			cmbY_porttype.selectedItem = item;
		}
		
	}
}

public function setCapability(xml:XMLList,id:String):void{
	cmbX_capability.dataProvider = xml;
	for each(var item:Object in cmbX_capability.dataProvider){
		if(item.@label == id){
			cmbX_capability.selectedItem = item;
		}
		
	}
}
public function setPortStatus(xml:XMLList,id:String):void{
	cmbStatus.dataProvider=xml;
	for each(var item:Object in cmbStatus.dataProvider){
		if(item.@label == id){
			cmbStatus.selectedItem = item;
		}
	}
}
/**
 *添加或修改按钮的处理函数 
 * @param event
 * 
 */
protected function btn_clickHandler(event:MouseEvent):void
{
	
	if(this.title == "添加"){
		if (cmbEquipment.text ==null ||cmbEquipment.text =="")
		{
			Alert.show("设备名称不能为空", "提示");
			return;
		}
		else
		{
			logicPortModel.equipcode=parenteqcode;
		}
		if (cmbFrameserial.selectedIndex == -1)
		{
			Alert.show("机框序号不能为空", "提示");
			return;
		}
		else
		{
			logicPortModel.frameserial=cmbFrameserial.selectedItem.@id.toString();
		}
		if (cmbFlotserial.selectedIndex == -1)
		{
			Alert.show("机槽序号不能为空", "提示");
			return;
		}
		else
		{
			logicPortModel.slotserial=cmbFlotserial.selectedItem.@id.toString();
		}
		if (cmbPackserial.selectedIndex == -1)
		{
			Alert.show("机盘序号不能为空", "提示");
			return;
		}
		else
		{
			logicPortModel.packserial=cmbPackserial.selectedItem.@id.toString();
		}
		if (StringUtil.trim(txtPortserial.text) == "")
		{
			Alert.show("端口序号不能为空", "提示");
			return;
		}
		else
		{
			logicPortModel.portserial=StringUtil.trim(txtPortserial.text);
			checkPortserial(parenteqcode,cmbFrameserial.selectedItem.@id,
				cmbFlotserial.selectedItem.@id,cmbPackserial.selectedItem.@id,StringUtil.trim(txtPortserial.text));//验证端口序号是否占用
		}
		
	}else if(this.title == "修改"){
		
		
		logicPortModel.equipcode = code;
		logicPortModel.frameserial = logicPortData.frameserial;
		logicPortModel.slotserial = logicPortData.slotserial;
		logicPortModel.packserial = logicPortData.packserial;
		logicPortModel.logicport = logicPortData.logicport;
		if (StringUtil.trim(txtPortserial.text) == "")
		{
			Alert.show("端口序号不能为空", "提示");
			return;
		}
		else
		{
			logicPortModel.portserial=StringUtil.trim(txtPortserial.text);
			if(port_serial!=logicPortModel.portserial)
				checkPortserial(code,logicPortModel.frameserial,
					logicPortModel.slotserial,logicPortModel.packserial,StringUtil.trim(txtPortserial.text));
			else{
				if (cmbY_porttype.selectedIndex == -1)
				{
					Alert.show("端口类型不能为空", "提示");
					return;
				}
				else
				{
					logicPortModel.y_porttype=cmbY_porttype.selectedItem.@id.toString();
				}
				if (cmbX_capability.selectedIndex == -1)
				{
					Alert.show("端口速率不能为空", "提示");
					return;
				}
				else
				{
					logicPortModel.x_capability=cmbX_capability.selectedItem.@id.toString();
				}
				if(cmbStatus.selectedIndex == -1){
					Alert.show("端口状态不能为空", "提示");
					return;
				}else{
					logicPortModel.status=cmbStatus.selectedItem.@id.toString();
				}
				logicPortModel.updatedate = dfUpdateDate.text;
				logicPortModel.updateperson = txtUpdatePerson.text;
				logicPortModel.remark=txtRemark.text;
				logicPortModel.connport=txtConnport.text;
				
				var remoteObject:RemoteObject=new RemoteObject("resNetDwr");
				remoteObject.endpoint = ModelLocator.END_POINT;
				remoteObject.showBusyCursor = true;
				remoteObject.addEventListener(ResultEvent.RESULT,modifyStationResult);
				Application.application.faultEventHandler(remoteObject);
				remoteObject.ModifyLogicPort(logicPortModel); 
			}
		}
	}
}
/**
 *添加经数据交互后的的界面提示处理
 * @param event
 * 
 */
protected function addStationResult(event:ResultEvent):void{
	if(event.result.toString()=="success")
	{
		Alert.show("添加成功!","提示");
		PopUpManager.removePopUp(this);
		this.dispatchEvent(new Event("RefreshDataGrid"))
	}else
	{
		Alert.show("请按要求填写数据！","提示");
	}
}

/**
 *修改经数据交互后的的界面提示处理
 * @param event
 * 
 */
public function modifyStationResult(event:ResultEvent):void
{
	if(event.result.toString()=="success")
	{
		Alert.show("修改成功！","提示");
		PopUpManager.removePopUp(this);
		this.dispatchEvent(new Event("RefreshDataGrid"))
	}else if(event.result.toString()=="blank")
	{
		Alert.show("请按要求修改内容！","提示");
	}
	else if(event.result.toString()=="timeblank")
	{
		Alert.show("时间不能为空！","提示");
	}else{
		Alert.show("修改失败！","提示");
	}
}

/**
 * 
 * 设备选择事件
 * 双击之后，框的序号就可以选择了
 * */
public function cmbEquipname_changeHandler(obj:Object):void
{	
	parenteqcode=obj.id;
	var rt:RemoteObject=new RemoteObject("resNodeDwr");
	rt.endpoint = ModelLocator.END_POINT;
	rt.showBusyCursor = true;
	rt.addEventListener(ResultEvent.RESULT,equipResultHandler);
	Application.application.faultEventHandler(rt);
	rt.getEuipFrameSerial(parenteqcode);
	
	
}

/**
 *选择完设备后，给机框赋值
 * @param event
 * 
 */
private function equipResultHandler(event:ResultEvent):void{
	var xml:XMLList = new XMLList(event.result);
	cmbFrameserial.dataProvider = xml;
	cmbFrameserial.dropdown.dataProvider = xml;
	cmbFrameserial.selectedIndex = -1;
	cmbFlotserial.dataProvider = null;
	cmbFlotserial.dropdown.dataProvider = null;
	cmbPackserial.dataProvider = null;
	cmbPackserial.dropdown.dataProvider = null;
	
	
}


/**
 * 
 * 机框选择事件
 * 
 * */
protected function cmbFrameserial_changeHandler(event:ListEvent):void
{
	var rt:RemoteObject=new RemoteObject("resNodeDwr");
	rt.endpoint = ModelLocator.END_POINT;
	rt.showBusyCursor = true;
	rt.addEventListener(ResultEvent.RESULT,frameserialResultHandler);
	Application.application.faultEventHandler(rt);
	rt.getEuipSlotSerialByFrame(parenteqcode,cmbFrameserial.selectedItem.@id.toString());
}
/**
 *获取机框数据之后的处理函数 
 * @param event
 * 
 */
private function frameserialResultHandler(event:ResultEvent):void{
	var xml:XMLList = new XMLList(event.result);
	cmbFlotserial.dataProvider = xml;
	cmbFlotserial.dropdown.dataProvider = xml;
	cmbFlotserial.selectedIndex = -1;
	cmbPackserial.dataProvider = null;
	cmbPackserial.dropdown.dataProvider = null;
	
}

/**
 * 
 * 机槽选择事件
 * 
 * */
protected function cmbFlotserial_changeHandler(event:ListEvent):void
{
	var rt:RemoteObject=new RemoteObject("resNetDwr");
	rt.endpoint = ModelLocator.END_POINT;
	rt.showBusyCursor = true;
	rt.addEventListener(ResultEvent.RESULT,packseriaResultHandler);
	Application.application.faultEventHandler(rt);
	rt.getPackseriaByEuipSlot(parenteqcode,
		cmbFrameserial.selectedItem.@id.toString(),
		cmbFlotserial.selectedItem.@id.toString());
}
/**
 *选完槽后，给盘赋值 
 * @param event
 * 
 */
private function packseriaResultHandler(event:ResultEvent):void{
	var xml:XMLList = new XMLList(event.result);
	cmbPackserial.dataProvider = xml;
	cmbPackserial.dropdown.dataProvider = xml;
	cmbPackserial.selectedIndex = -1;
	
}
/**
 *初始化 
 * @param event
 * 
 */
protected function init(event:FlexEvent):void
{
	cmbY_porttype.selectedIndex=-1;
	cmbX_capability.selectedIndex=-1;
	cmbStatus.selectedIndex=-1;
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
	
//	var sqsearch:SearchEquipTitle=new SearchEquipTitle();
//	sqsearch.page_parent=this;
//	PopUpManager.addPopUp(sqsearch,this,true);
//	PopUpManager.centerPopUp(sqsearch);
}
/**
 * 验证端口序号是否占用
 */ 
protected function checkPortserial(code:String,frame:String,slot:String,pack:String,port:String):void{
	var rt:RemoteObject=new RemoteObject("resNetDwr");
	rt.endpoint = ModelLocator.END_POINT;
	rt.showBusyCursor = true;
	rt.addEventListener(ResultEvent.RESULT,checkPortseriaResultHandler);
	Application.application.faultEventHandler(rt);
	rt.checkPortSerial(code,frame,slot,pack,port);
}
protected function checkPortseriaResultHandler(event:ResultEvent):void{
	flagStr =  event.result.toString();
	if(flagStr != "success"){
		if (cmbY_porttype.selectedIndex == -1)
		{
			Alert.show("端口类型不能为空", "提示");
			return;
		}
		else
		{
			logicPortModel.y_porttype=cmbY_porttype.selectedItem.@id.toString();
		}
		if (cmbX_capability.selectedIndex == -1)
		{
			Alert.show("端口速率不能为空", "提示");
			return;
		}
		else
		{
			logicPortModel.x_capability=cmbX_capability.selectedItem.@id.toString();
		}
		if(cmbStatus.selectedIndex == -1){
			Alert.show("端口状态不能为空", "提示");
			return;
		}else{
			logicPortModel.status=cmbStatus.selectedItem.@id.toString();
		}
		logicPortModel.connport = txtConnport.text ;
		logicPortModel.remark=txtRemark.text;
		logicPortModel.updatedate = dfUpdateDate.text;
		logicPortModel.updateperson = txtUpdatePerson.text;
		
		var rt:RemoteObject=new RemoteObject("resNetDwr");
		rt.endpoint = ModelLocator.END_POINT;
		rt.showBusyCursor = true;
		if(this.title=="添加"){
			rt.addEventListener(ResultEvent.RESULT,addStationResult);
			Application.application.faultEventHandler(rt);
			rt.addLogicPortModel(logicPortModel);
		}
		else{
			rt.addEventListener(ResultEvent.RESULT,modifyStationResult);
			Application.application.faultEventHandler(rt);
			rt.ModifyLogicPort(logicPortModel);
		}
	}else{
		Alert.show("填写的端口序号被占用，请重新填写","提示");
//		txtPortserial.text = "";
		return;
	}
}
