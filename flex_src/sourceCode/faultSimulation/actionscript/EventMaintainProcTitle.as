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

import sourceCode.faultSimulation.model.MaintainSearchEvent;
import sourceCode.faultSimulation.model.StdMaintainProModel;

public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");	

[Bindable] public var interposeData:Object;
public var maintainModel:StdMaintainProModel = new StdMaintainProModel();
[Bindable] public var isRequired:Boolean=true;
[Bindable] public var isEnabled:Boolean=true;
public var operatetypeid:String="";

public function setData():void{
	operatetype.text = interposeData.operatetype;
	a_equiptype.text = interposeData.a_equiptype;
	z_equiptype.text = interposeData.z_equiptype;
	remark.text=interposeData.remark;
	operatedes.text=interposeData.operatedes;
	hasA_equip.text = interposeData.hasA_equip;
	hasZ_equip.text = interposeData.hasZ_equip;
//	isinterposeoperate.text = interposeData.isinterposeoperatename;
	expectedresult.text = interposeData.expectedresult;
	operatetypeid = interposeData.operatetypeid;
}

/**
 * 初始化函数
 */ 
protected function init():void{
	//查询干预类型
	getEquipTypeLst();
	//查询干预方法
	getFaultType();
	
}

private function getEquipTypeLst():void{
	var rt:RemoteObject=new RemoteObject("faultSimulation");
	rt.endpoint=ModelLocator.END_POINT;
	rt.showBusyCursor=true;
	rt.addEventListener(ResultEvent.RESULT,getEquipTypeLstHandler);
	Application.application.faultEventHandler(rt);
	rt.getEquiptypeLst("1");
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
	
	if(this.title=="修改"){
		a_equiptype.text=interposeData.a_equiptype;
		z_equiptype.text=interposeData.z_equiptype;
	}
}
//查询故障类型
private function getFaultType():void{
	var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
	remoteObject.endpoint = ModelLocator.END_POINT;
	remoteObject.showBusyCursor = true;
	remoteObject.addEventListener(ResultEvent.RESULT,getFaultTypeInfoByInterposeTypeHandler);
	Application.application.faultEventHandler(remoteObject);
	remoteObject.getFaultTypeInfoByInterposeType("");//查询所有故障
}
protected function getFaultTypeInfoByInterposeTypeHandler(event:ResultEvent):void{
//	var list:XMLList = new XMLList("<faulttype id=\"\" label=\"无\" name=\"faulttype\" isBranch=\"false\"></faulttype>"+event.result);
//	isinterposeoperate.dataProvider = list;
//	isinterposeoperate.dropdown.dataProvider = list;
//	isinterposeoperate.labelField="@label";
//	isinterposeoperate.text=(interposeData.isinterposeoperatename!=null?interposeData.isinterposeoperatename:"");
//	isinterposeoperate.selectedIndex=0;
}
/**
 *添加或修改按钮的处理函数 
 * @param event
 * 
 */
protected function btn_clickHandler(event:MouseEvent):void
{
	if(this.title == "添加"){
		if (operatetype.text ==null||operatetype.text=="")
		{
			Alert.show("处理方法不能为空", "提示");
			return;
		}
		else
		{
			//验证类型是否存在
			checkOperateTypeHandler(operatetype.text);
		}
	}else if(this.title == "修改"){
		var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		maintainModel.operatetypeid = operatetypeid;
		if (a_equiptype.selectedItem != null){
			maintainModel.a_equiptype = a_equiptype.selectedItem.@id;
		}else{
			maintainModel.a_equiptype = interposeData.a_equiptype_code;
		}
		if (z_equiptype.selectedItem != null){
			maintainModel.z_equiptype = z_equiptype.selectedItem.@id;
		}else{
			maintainModel.z_equiptype = interposeData.z_equiptype_code;
		}
		if (hasA_equip.selectedItem != null){
			maintainModel.hasA_equip = hasA_equip.selectedItem.label;
		}else{
			maintainModel.hasA_equip = interposeData.hasA_equip;
		}
		if (hasZ_equip.selectedItem != null){
			maintainModel.hasZ_equip = hasZ_equip.selectedItem.label;
		}else{
			maintainModel.hasZ_equip = interposeData.hasZ_equip;
		}
//		if (isinterposeoperate.selectedItem != null){
//			maintainModel.isinterposeoperate = isinterposeoperate.selectedItem.data;
//		}else{
//			maintainModel.isinterposeoperate = interposeData.isinterposeoperate;
//		}
		
		if (operatedes.text ==null ||operatedes.text =="")
		{
			Alert.show("设备状态属性不能为空", "提示");
			return;
		}
		else
		{
			maintainModel.operatedes=operatedes.text;
		}
		if (expectedresult.text ==null ||expectedresult.text =="")
		{
			Alert.show("设备默认状态不能为空", "提示");
			return;
		}
		else
		{
			maintainModel.expectedresult=expectedresult.text;
		}
		
		maintainModel.remark = remark.text;
		maintainModel.updateperson = Application.application.curUser;
		maintainModel.updatetime = this.getNowTime();
		
		remoteObject.addEventListener(ResultEvent.RESULT,modifyInterposeResult);
		Application.application.faultEventHandler(remoteObject);
		remoteObject.modifyEventMaintainProc(maintainModel);
	}
	else{
		maintainModel.operatetype=operatetype.text;
		if (a_equiptype.selectedItem != null){
			maintainModel.a_equiptype = a_equiptype.selectedItem.@id;
		}
		if (z_equiptype.selectedItem != null){
			maintainModel.z_equiptype = z_equiptype.selectedItem.@id;
		}
		if (hasA_equip.selectedItem != null){
			maintainModel.hasA_equip = hasA_equip.selectedItem.label;
		}
		if (hasZ_equip.selectedItem != null){
			maintainModel.hasZ_equip = hasZ_equip.selectedItem.label;
		}
//		if (isinterposeoperate.selectedItem != null){
//			maintainModel.isinterposeoperate = isinterposeoperate.selectedItem.data;
//		}
		
		maintainModel.operatedes=operatedes.text;
		maintainModel.expectedresult=expectedresult.text;
		maintainModel.remark = remark.text;
		maintainModel.sort="OPERATE_TYPE_ID";
														
		this.dispatchEvent(new MaintainSearchEvent("MaintainSearchEvent",maintainModel));
		PopUpManager.removePopUp(this);
	}
}
/**
 *添加经数据交互后的的界面提示处理
 * @param event
 * 
 */
protected function addInterposeResult(event:ResultEvent):void{
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
public function modifyInterposeResult(event:ResultEvent):void
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

public function checkOperateTypeHandler(operatetype:String):void{
	var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
	remoteObject.endpoint = ModelLocator.END_POINT;
	remoteObject.showBusyCursor = true;
	remoteObject.addEventListener(ResultEvent.RESULT,checkOperateTypeHandlerResult);
	Application.application.faultEventHandler(remoteObject);
	remoteObject.checkOperateType(operatetype);
}

protected function checkOperateTypeHandlerResult(event:ResultEvent):void{
	if(event.result.toString()=="success"){
		//表示可以使用
		maintainModel.operatetype=operatetype.text;
		var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		if(this.title=="添加"){
			if(hasA_equip.selectedItem == null){
				Alert.show("请选择是否有本端设备", "提示");
				return;
			}else{
				maintainModel.hasA_equip = hasA_equip.selectedItem.label;
			}
			if (hasZ_equip.selectedItem == null){
				Alert.show("请选择是否有对端设备", "提示");
				return;
			}else{
				maintainModel.hasZ_equip = hasZ_equip.selectedItem.label;
			}
//			if (isinterposeoperate.selectedItem == null){
////				Alert.show("请选择是否是干预性方法", "提示");
////				return;
//				maintainModel.isinterposeoperate="";
//			}else{
//				maintainModel.isinterposeoperate = isinterposeoperate.selectedItem.data;
//			}
			if (operatedes.text ==null ||operatedes.text =="")
			{
				Alert.show("设备状态属性不能为空", "提示");
				return;
			}
			else
			{
				maintainModel.operatedes=operatedes.text;
			}
			if (expectedresult.text ==null ||expectedresult.text =="")
			{
				Alert.show("设备默认状态不能为空", "提示");
				return;
			}
			else
			{
				maintainModel.expectedresult=expectedresult.text;
			}
			if(a_equiptype.selectedItem!=null){
				maintainModel.a_equiptype = a_equiptype.selectedItem.@id;
			}
			if(z_equiptype.selectedItem!=null){
				maintainModel.z_equiptype = z_equiptype.selectedItem.@id;
			}
			maintainModel.remark = remark.text;
			maintainModel.updateperson = Application.application.curUser;
			maintainModel.updatetime = this.getNowTime();
			
			remoteObject.addEventListener(ResultEvent.RESULT,addInterposeResult);
			Application.application.faultEventHandler(remoteObject);
			remoteObject.addEventMaintainProc(maintainModel);
		}
	}else{
		Alert.show("处理方法已存在，请重新填写","提示");
		operatetype.text="";
		return;
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
