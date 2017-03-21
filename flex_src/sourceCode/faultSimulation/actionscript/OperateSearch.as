// ActionScript file


import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
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

import sourceCode.faultSimulation.model.OperateListEvent;
import sourceCode.faultSimulation.model.OperateListModel;
import sourceCode.faultSimulation.titles.SelectEquipTitle;
import sourceCode.faultSimulation.titles.SelectUserInfoTitle;
import sourceCode.faultSimulation.titles.selectEventNameTitle;
import sourceCode.faultSimulation.titles.selectOperateTypeTitle;

public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");	

[Bindable] public var interposeData:Object;
public var operateModel:OperateListModel = new OperateListModel();
public var operatetypeid:String="";
public var a_equipcode:String="";
public var z_equipcode:String="";
public var interposeid:String="";
public var userid:String = "";
public var flag:String="";
public var curUser:String="";


private function init():void{
	//初始化，获取设备类型
	getEquipTypeLst();
}

private function getEquipTypeLst():void{
	var rt:RemoteObject=new RemoteObject("faultSimulation");
	rt.endpoint=ModelLocator.END_POINT;
	rt.showBusyCursor=true;
	rt.addEventListener(ResultEvent.RESULT,getEquipTypeLstHandler);
	Application.application.faultEventHandler(rt);
	rt.getEquiptypeLst("3");
}
private function getEquipTypeLstHandler(event:ResultEvent):void{
	var list:XMLList= new XMLList(event.result);
	a_equiptype.dataProvider=list;
	a_equiptype.dropdown.dataProvider=list;
	a_equiptype.labelField="@label";
	a_equiptype.text="";
	a_equiptype.selectedIndex=-1;
	z_equiptype.dataProvider=list;
	z_equiptype.dropdown.dataProvider=list;
	z_equiptype.labelField="@label";
	z_equiptype.text="";
	z_equiptype.selectedIndex=-1;
}

//取操作类型
protected function selectOperateTypeHnadler(event:MouseEvent):void{
	var sqsearch:selectOperateTypeTitle=new selectOperateTypeTitle();
	PopUpManager.addPopUp(sqsearch,this,true);
	PopUpManager.centerPopUp(sqsearch);
	sqsearch.myCallBack=this.cmbEquipname_changeHandler;
}
public function cmbEquipname_changeHandler(obj:Object):void
{	
	operatetype.text = obj.name;
	operatetypeid = obj.id;
}

//查询设备信息
protected function selectAEquipInfoHandler(event:MouseEvent):void{
	var sqsearch:SelectEquipTitle=new SelectEquipTitle();
	PopUpManager.addPopUp(sqsearch,this,true);
	PopUpManager.centerPopUp(sqsearch);
	sqsearch.myCallBack=this.selectAEquipInfochangeHandler;
}
protected function selectAEquipInfochangeHandler(obj:Object):void{
	a_equipname.text = obj.name;
	a_equipcode = obj.id;
}
protected function selectZEquipInfoHandler(event:MouseEvent):void{
	var sqsearch:SelectEquipTitle=new SelectEquipTitle();
	PopUpManager.addPopUp(sqsearch,this,true);
	PopUpManager.centerPopUp(sqsearch);
	sqsearch.myCallBack=this.selectZEquipInfochangeHandler;
}
protected function selectZEquipInfochangeHandler(obj:Object):void{
	z_equipname.text = obj.name;
	z_equipcode = obj.id;
}

/**
 * 用户选择的处理函数，弹出界面；选择用户
 * @param event
 * 
 */
protected function selectUserInfo(event:MouseEvent):void{
	var sqsearch:SelectUserInfoTitle=new SelectUserInfoTitle();
	sqsearch.flag=flag;
	sqsearch.curUser=curUser;
	PopUpManager.addPopUp(sqsearch,this,true);
	PopUpManager.centerPopUp(sqsearch);
	
	sqsearch.myCallBack=this.selectUserInfoHandler;
}

public function selectUserInfoHandler(obj:Object):void
{	
	if(this.title=="查询"){
		updateperson.text=obj.name;
		userid = obj.id;
	}
}

//干预选择方法
protected function selectPrjNameHandler(event:MouseEvent):void{
	var sqsearch:selectEventNameTitle=new selectEventNameTitle();
	
	PopUpManager.addPopUp(sqsearch,this,true);
	PopUpManager.centerPopUp(sqsearch);
	sqsearch.myCallBack=this.selectPrjNameHandlerHandler;
}

public function selectPrjNameHandlerHandler(obj:Object):void
{	
	projectname.text = obj.name;
	interposeid = obj.id;
}

/**
 *添加或修改按钮的处理函数 
 * @param event
 * 
 */
protected function btn_clickHandler(event:MouseEvent):void
{
	operateModel.operatetypeid=operatetypeid;
	if (a_equiptype.selectedItem != null){
		operateModel.a_equiptype = a_equiptype.selectedItem.@label;
	}
	if (z_equiptype.selectedItem != null){
		operateModel.z_equiptype = z_equiptype.selectedItem.@label;
	}
	
	operateModel.updateperson=userid;
	operateModel.interposeid=interposeid;
	operateModel.operateresult = operateresult.text;
	operateModel.flag=flag;
	operateModel.z_equipcode=z_equipcode;
	operateModel.a_equipcode=a_equipcode;
	operateModel.remark = remark.text;
	this.dispatchEvent(new OperateListEvent("OperateListEvent",operateModel));
	PopUpManager.removePopUp(this);
}

