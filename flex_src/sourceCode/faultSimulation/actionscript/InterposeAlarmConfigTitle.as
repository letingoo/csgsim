// ActionScript file


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
import common.actionscript.Registry;
import common.other.events.CustomEvent;

import sourceCode.faultSimulation.model.InterposeModel;
import sourceCode.faultSimulation.model.InterposeSearchEvent;
import sourceCode.faultSimulation.titles.SelectAlarmInfoTitle;

public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");	

[Bindable] public var interposeData:Object;
public var interposeModel:InterposeModel = new InterposeModel();
[Bindable] public var isShow:Boolean=true;
[Bindable] public var isRequired:Boolean=true;
public var alarmconfid:String="";
 public var interpose_id:String="";//父页面传过来的参数
 public var interpose_type:String="";//父页面传过来的参数
 public var interpose_typeid:String="";//父页面传过来的参数
 public var fault_type:String="";//父页面传过来的参数
 public var fault_typeid:String="";//父页面传过来的参数
 public var equip_type:String="";//父页面传过来的参数
public var equip_vendor:String="";//父页面传过来的参数
public var x_vendor:String="";//父页面传过来的参数

public function setData():void{
	alarmrange.text = interposeData.alarmrange;
	remark.text=interposeData.remark;
	position.text=interposeData.position;
	alarmname.text = interposeData.alarmname;
	alarmid.text = interposeData.alarmid;
	alarmconfid = interposeData.alarmconfid;
}

/**
 * 初始化函数
 */ 
public function init():void{
	//初始化
	interposetype.text=interpose_type;
	if(interpose_type==null||interpose_type==""){
		getInterposeType();
	}
	faulttype.text = fault_type;
	equiptype.text = equip_type;
	if(equip_type==null||equip_type==""){
	   getEquiptypeLst();
	}
//	Alert.show(interpose_type+"||"+equip_type);
	if(equip_vendor!=null&&equip_vendor!=""){
		equipvendor.text = equip_vendor;
	}else{
		getEquipVendor();
	}
	
}

//查询设备类型
public function getEquiptypeLst():void{
	var re:RemoteObject=new RemoteObject("faultSimulation");
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.addEventListener(ResultEvent.RESULT,getEquipTypeResultHandler);
	Application.application.faultEventHandler(re);
	re.getEquiptypeLst("3");
}

protected function getEquipTypeResultHandler(event:ResultEvent):void{
	var list:XMLList = new XMLList(event.result);
	equiptype.dataProvider = list;
	equiptype.dropdown.dataProvider = list;
	equiptype.labelField="@label";
	equiptype.text="";
	equiptype.selectedIndex=-1;
}
/**
 * 查询干预类型
 */ 
public function getInterposeType():void{
	var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
	remoteObject.endpoint = ModelLocator.END_POINT;
	remoteObject.showBusyCursor = true;
	remoteObject.addEventListener(ResultEvent.RESULT,getInterposeTypeResultHandler);
	Application.application.faultEventHandler(remoteObject);
	remoteObject.getInterposeType();
}

protected function getInterposeTypeResultHandler(event:ResultEvent):void{
	var list:XMLList = new XMLList(event.result);
	interposetype.dataProvider = list;
	interposetype.dropdown.dataProvider = list;
	interposetype.labelField="@label";
	interposetype.text="";
	interposetype.selectedIndex=-1;
	//赋值完后 触发查询
	getFaultTypeHander();
}

//查询故障类型
protected function getFaultTypeHander():void{
	if(interposetype.selectedItem!=null){
		var interpose_type:String = interposetype.selectedItem.@id;
		var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		remoteObject.addEventListener(ResultEvent.RESULT,getFaultTypeByInterposeTypeHandler);
		Application.application.faultEventHandler(remoteObject);
		remoteObject.getFaultTypeByInterposeType(interpose_type);
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
	equipvendor.dataProvider = list;
	equipvendor.dropdown.dataProvider = list;
	equipvendor.labelField="@label";
	equipvendor.text="";
	equipvendor.selectedIndex=-1;
}

//查询告警列表
protected function queryAlarmInfoHandler(event:MouseEvent):void{
	if(equipvendor.text!=null&&equipvendor.text!=""){
		var alarmInfo:SelectAlarmInfoTitle = new SelectAlarmInfoTitle();
		PopUpManager.addPopUp(alarmInfo,this,true);
		PopUpManager.centerPopUp(alarmInfo);
		alarmInfo.x_vendor = (x_vendor==null||x_vendor==""?equipvendor.selectedItem.@id:x_vendor);
		alarmInfo.init();
		alarmInfo.myCallBack=this.selectAlarmInfoHandler;
	}
	
}

protected function selectAlarmInfoHandler(obj:Object):void{
	var name:String=obj.name;
	var id:String=obj.id;
	if(name.length>0){
		name=name.substr(0,name.length-1);
	}
	if(id.length>0){
		id=id.substr(0,id.length-1);
	}
	alarmname.text=name;
	alarmid.text = id;
	alarmrange.text=name;//影响范围默认值
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
		if (position.selectedItem ==null)
		{
			Alert.show("请选择是本端还是对端", "提示");
			return;
		}
		else
		{
			interposeModel.position=position.selectedItem.label;
		}
		if (alarmname.text == null ||alarmname.text==""){
			Alert.show("请选择告警名称", "提示");
			return;
		}else{
			interposeModel.alarmname = alarmname.text;
			interposeModel.alarmid = alarmid.text;
		}
		if(alarmrange.text == null||alarmrange.text==""){
			Alert.show("告警影响范围不能为空", "提示");
			return;
		}else{
			interposeModel.alarmrange = alarmrange.text;
		}
		
		interposeModel.equiptype = (equiptype.text==null||equiptype.text=="")? equip_type:equiptype.text;
		if(interposetype.selectedItem!=null){
			interposeModel.interposetypeid = interposetype.selectedItem.@id;
		}else{
			interposeModel.interposetypeid = interpose_typeid;
		}
		if(faulttype.selectedItem!=null){
			interposeModel.faulttypeid = faulttype.selectedItem.@id;
		}else{
			interposeModel.faulttypeid = fault_typeid;
		}
		if(interposetype.selectedItem!=null){
			interposeModel.interposeid = interposetype.selectedItem.@id;
		}else{
			interposeModel.interposeid = interpose_id;
		}
		if(equipvendor.selectedItem!=null){
			interposeModel.equipvendor = equipvendor.selectedItem.@id;
		}else{
			interposeModel.equipvendor = x_vendor;
		}
//		Alert.show("1-interposeModel.equiptype"+interposeModel.equiptype+"||interposeModel.interposetypeid"+interposeModel.interposetypeid+"interposeModel.faulttypeid"+interposeModel.faulttypeid+"interposeModel.interposeid"+interposeModel.interposeid+"interposeModel.equipvendor"+interposeModel.equipvendor);
		interposeModel.remark = remark.text;
		interposeModel.updateperson = Application.application.curUser;
		interposeModel.updatetime = this.getNowTime();
		
		remoteObject.addEventListener(ResultEvent.RESULT,addInterposeAlarmConfigResult);
		Application.application.faultEventHandler(remoteObject);
		remoteObject.addInterposeAlarmConfig(interposeModel);
	}
	else if(this.title == "修改"){
		interposeModel.alarmconfid = alarmconfid;
		if (position.selectedItem !=null)
		{
			interposeModel.position = position.selectedItem.label;
		}
		else
		{
			interposeModel.position=interposeData.position;
		}
		if(alarmname.text==""){
			Alert.show("请选择告警名称","提示");
			return;
		}else{
			interposeModel.alarmname = alarmname.text;
			interposeModel.alarmid = alarmid.text;
		}
		if(alarmrange.text==""){
			Alert.show("请填写告警范围","提示");
			return;
		}else{
			interposeModel.alarmrange = alarmrange.text;
		}
		
		interposeModel.remark = remark.text;
		interposeModel.updateperson = Application.application.curUser;
		interposeModel.updatetime = this.getNowTime();
		
		remoteObject.addEventListener(ResultEvent.RESULT,modifyInterposeAlarmConfig);
		Application.application.faultEventHandler(remoteObject);
		remoteObject.modifyInterposeAlarmConfig(interposeModel);
	}
	else{
		if (interposetype.selectedItem != null){
			interposeModel.interposetypeid = interposetype.selectedItem.@id;
		}
		if (equiptype.selectedItem != null){
			interposeModel.equiptype = equiptype.selectedItem.@label;
		}
		if (faulttype.selectedItem != null){
			interposeModel.faulttypeid = faulttype.selectedItem.@id;
		}
		if (position.selectedItem != null){
			interposeModel.position = position.selectedItem.label;
		}
		if (equipvendor.selectedItem != null){
			interposeModel.equipvendor = equipvendor.selectedItem.@id;
		}
		interposeModel.alarmname=alarmname.text;
		interposeModel.alarmrange = alarmrange.text;
		interposeModel.remark = remark.text;
		interposeModel.interposeid=	interpose_id;	
		interposeModel.sort="ALARM_CONFIG_ID";
		
		this.dispatchEvent(new InterposeSearchEvent("InterposeSearchEvent",interposeModel));
		PopUpManager.removePopUp(this);
	}
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
public function modifyInterposeAlarmConfig(event:ResultEvent):void
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
