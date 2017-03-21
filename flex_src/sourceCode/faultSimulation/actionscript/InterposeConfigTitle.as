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

import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.other.events.CustomEvent;

import sourceCode.faultSimulation.model.InterposeModel;
import sourceCode.faultSimulation.model.InterposeSearchEvent;
import sourceCode.faultSimulation.titles.SelectCheckOperateTitle;
import sourceCode.faultSimulation.titles.selectOperateTypeTitle;

public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");	

[Bindable] public var interposeData:Object;
public var interposeModel:InterposeModel = new InterposeModel();
[Bindable] public var isRequired:Boolean=true;
[Bindable] public var ismaininterposeid:String;
[Bindable] public var interposetypeid:String;
[Bindable] public var faulttypeid:String;
[Bindable] public var operatetypeid:String;

public function setData():void{
	remark.text=interposeData.remark;
	faulttype.text = interposeData.faulttype;
	interposetype.text = interposeData.interposetype;
	equiptype.text = interposeData.equiptype;
	interposetypeid=interposeData.interposetypeid;
	faulttypeid = interposeData.faulttypeid;
	operatetype.text=interposeData.operatetype;
	operatetypeid=interposeData.operatetypeid;
	if(this.title == "修改"){
		interposetype.enabled=false;
		equiptype.enabled=false;
		faulttype.enabled=false;
	}
//	equipvendor.text = interposeData.equipvendor;
}

public function init():void{
		//获取干预类型
		getInterposeTypeLst();
		//获取设备类型
		getEquiptypeLst();
		//获取设备厂家
		//	getEquipVendor();
	
}

protected function getEquiptypeLst():void{
	var re:RemoteObject=new RemoteObject("faultSimulation");
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.addEventListener(ResultEvent.RESULT,getEquiptypeLstHandler);
	Application.application.faultEventHandler(re);
	re.getEquiptypeLst("3");
}
private function getEquiptypeLstHandler(event:ResultEvent):void{
	if(this.title!="修改"){
	var list:XMLList = new XMLList(event.result);
	equiptype.dataProvider = list;
	equiptype.dropdown.dataProvider = list;
	equiptype.labelField="@label";
	equiptype.text="";
	equiptype.selectedIndex=-1;
	}
}

protected function getInterposeTypeLst():void{
	var re:RemoteObject=new RemoteObject("faultSimulation");
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.addEventListener(ResultEvent.RESULT,getInterposeTypeLstHandler);
	Application.application.faultEventHandler(re);
	re.getInterposeType();
}
private function getInterposeTypeLstHandler(event:ResultEvent):void{
	if(this.title!="修改"){
		var list:XMLList = new XMLList(event.result);
		interposetype.dataProvider = list;
		interposetype.dropdown.dataProvider = list;
		interposetype.labelField="@label";
		interposetype.text="";
		interposetype.selectedIndex=-1;
	}
	
}

//protected function getEquipVendor():void{
//	var re:RemoteObject=new RemoteObject("resNetDwr");
//	re.endpoint = ModelLocator.END_POINT;
//	re.showBusyCursor = true;
//	re.addEventListener(ResultEvent.RESULT,getX_modelLst);
//	Application.application.faultEventHandler(re);
//	re.getX_VendorLst();
//}
//private function getX_modelLst(event:ResultEvent):void{
//	var list:XMLList = new XMLList(event.result);
//	equipvendor.dataProvider = list;
//	equipvendor.dropdown.dataProvider = list;
//	equipvendor.labelField="@label";
//	equipvendor.text="";
//	if(this.title=="修改"){
//		equipvendor.text=interposeData.equipvendor;
//	}
//	equipvendor.selectedIndex=-1;
//}

//获取故障类型
protected function selectFaultTypeHandler(event:Event):void{
	if(interposetype.selectedItem!=null){
		var interpose_type:String = interposetype.selectedItem.@id;
		var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		remoteObject.addEventListener(ResultEvent.RESULT,getFaultTypeByInterposeTypeHandler);
		Application.application.faultEventHandler(remoteObject);
		remoteObject.getFaultTypeByInterposeType(interpose_type);
	}else{
		Alert.show("请先选择科目类型！","提示");
	}
}
protected function getFaultTypeByInterposeTypeHandler(event:ResultEvent):void{
	var list:XMLList = new XMLList(event.result);
	faulttype.dataProvider = list;
	faulttype.dropdown.dataProvider = list;
	faulttype.labelField="@label";
	faulttype.text="";
	faulttype.selectedIndex=-1;
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
/**
 * 多选择操作
 * @param event
 * 
 */
protected function selectCheckOperateType(event:MouseEvent):void{
	var sqsearch:SelectCheckOperateTitle=new SelectCheckOperateTitle();
	sqsearch.ids=operatetypeid;
	sqsearch.names=operatetype.text;
	//	sqsearch.page_parent=this;
	PopUpManager.addPopUp(sqsearch,this,true);
	PopUpManager.centerPopUp(sqsearch);
	sqsearch.myCallBack=this.cmbOperate_changeHandler;
}
/**
 * 
 * 选择用户处理
 * 双击选择用户
 * */
public function cmbOperate_changeHandler(obj:Object):void
{	
	var name:String=obj.name;
	var id:String=obj.id;
	if(name.length>0){
		name=name.substr(0,name.length-1);
	}
	if(id.length>0){
		id=id.substr(0,id.length-1);
	}
	if(this.title=="查询"){
		operatetype.text=name;
		operatetypeid = id;
	}
	else{
		operatetype.text = name;
		operatetypeid = id;
	}
}
/**
 * 清空所选用户信息
 * @param event
 */ 
private function clearOperateHandler(event:MouseEvent):void{
	operatetype.text="";
	operatetypeid= "";
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
	if(this.title == "添加"){
		if (interposetype.selectedItem == null){
			Alert.show("请选择科目类型", "提示");
			return;
		}else{
			interposeModel.interposetypeid = interposetype.selectedItem.@id;
			interposeModel.interposetype = interposetype.selectedItem.@label;
		}
		if (faulttype.selectedItem == null){
			Alert.show("请选择故障类型", "提示");
			return;
		}else{
			interposeModel.faulttypeid = faulttype.selectedItem.@id;
			interposeModel.faulttype = faulttype.selectedItem.@label;
		}
		if (equiptype.selectedItem ==null)
		{
			Alert.show("请选择设备类型", "提示");
			return;
		}
		else
		{//设备类型存名字
			interposeModel.equiptype=equiptype.selectedItem.@label;
		}
//		if (equipvendor.selectedItem ==null)
//		{
//			Alert.show("请选择设备厂商", "提示");
//			return;
//		}
//		else
//		{
//			interposeModel.equipvendor=equipvendor.selectedItem.@id;
//		}
		if (operatetype.text == null||operatetype.text==""){
			Alert.show("请填写处理方法", "提示");
			return;
		}else{
			interposeModel.operatetype = operatetype.text;
			interposeModel.operatetypeid = operatetypeid;
		}
		interposeModel.remark = remark.text;
		interposeModel.updateperson = Application.application.curUser;
		interposeModel.updatetime = this.getNowTime();
		
		remoteObject.addEventListener(ResultEvent.RESULT,addInterposeConfigResult);
		Application.application.faultEventHandler(remoteObject);
		remoteObject.addInterposeConfig(interposeModel);
	}
	else if(this.title == "修改"){
		if (interposetype.selectedItem != null){
			interposeModel.interposetypeid = interposetype.selectedItem.data;
			interposeModel.interposetype = interposetype.selectedItem.label;
		}else{
			interposeModel.interposetypeid = interposetypeid;
			interposeModel.interposetype = interposeData.interposetype;
		}
		if (faulttype.selectedItem != null){
			interposeModel.faulttypeid = faulttype.selectedItem.data;
			interposeModel.faulttype = faulttype.selectedItem.label;
		}else{
			interposeModel.faulttypeid = faulttypeid;
			interposeModel.faulttype = interposeData.faulttype;
		}
		if (equiptype.selectedItem != null){
			interposeModel.equiptype = equiptype.selectedItem.label;
		}else{
			interposeModel.equiptype = interposeData.equiptype;
		}
		if (operatetype.text == null||operatetype.text==""){
			interposeModel.operatetype = interposeData.operatetype;
			interposeModel.operatetypeid = interposeData.operatetypeid;
		}else{
			interposeModel.operatetype = operatetype.text;
			interposeModel.operatetypeid = operatetypeid;
		}
		
		interposeModel.remark = remark.text;
		interposeModel.updateperson = Application.application.curUserName;
		interposeModel.updatetime = this.getNowTime();
		
		remoteObject.addEventListener(ResultEvent.RESULT,modifyInterposeConfigResult);
		Application.application.faultEventHandler(remoteObject);
		remoteObject.modifyInterposeConfig(interposeModel);
	}
	else{
		if (interposetype.selectedItem != null){
			interposeModel.interposetype = interposetype.selectedItem.@id;
		}
		if (faulttype.selectedItem != null){
			interposeModel.faulttype = faulttype.selectedItem.@id;
		}
		if (equiptype.selectedItem != null){
			interposeModel.equiptype = equiptype.selectedItem.@label;
		}
		
		interposeModel.operatetype = operatetype.text;
		interposeModel.remark = remark.text;
		interposeModel.sort="i_interpose_type";
		this.dispatchEvent(new InterposeSearchEvent("InterposeSearchEvent",interposeModel));
		PopUpManager.removePopUp(this);
	}
}
/**
 *添加经数据交互后的的界面提示处理
 * @param event
 * 
 */
protected function addInterposeConfigResult(event:ResultEvent):void{
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
//
///**
// *修改经数据交互后的的界面提示处理
// * @param event
// * 
// */
public function modifyInterposeConfigResult(event:ResultEvent):void
{
	if(event.result.toString()=="success")
	{
		Alert.show("修改成功！","提示");
		PopUpManager.removePopUp(this);
		this.dispatchEvent(new Event("RefreshDataGrid"))
	}
	else{
		Alert.show("修改失败！","提示");
	}
}
/**
 * 获取当前时间
 */
protected function getNowTime():String{
	var dateFormatter:DateFormatter = new DateFormatter();
	dateFormatter.formatString = "YYYY-MM-DD JJ:NN:SS";
	var nowDate:String= dateFormatter.format(new Date());
	return nowDate;
}
