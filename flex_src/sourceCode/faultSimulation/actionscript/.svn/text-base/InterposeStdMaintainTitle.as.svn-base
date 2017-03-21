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

import sourceCode.faultSimulation.model.MaintainSearchEvent;
import sourceCode.faultSimulation.model.StdMaintainProModel;
import sourceCode.faultSimulation.titles.selectOperateTypeTitle;

public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");	

[Bindable] public var interposeData:Object;
public var maintainModel:StdMaintainProModel = new StdMaintainProModel();
[Bindable] public var isShow:Boolean=false;
[Bindable] public var isRequired:Boolean=true;
public var maintainprocid:String="";
 public var interpose_id:String="";//父页面传过来的参数
 public var interpose_type:String="";//父页面传过来的参数
 public var interpose_typeid:String="";//父页面传过来的参数
 public var fault_type:String="";//父页面传过来的参数
 public var fault_typeid:String="";//父页面传过来的参数
 public var operatetypeid:String="";

public function setData():void{
	operatetype.text = interposeData.operatetype;
	operateorder.text = interposeData.operateorder;
	remark.text=interposeData.remark;
	isendoperate.text=interposeData.isendoperate;
	maintainprocid = interposeData.maintainprocid;
	operatetypeid = interposeData.operatetypeid;
}

/**
 * 初始化函数
 */ 
public function init():void{
	//初始化
	interposetype.text=interpose_type;
	faulttype.text = fault_type;
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
}

//查询故障类型
protected function getFaultTypeHander(event:Event):void{
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
/**
 *添加或修改按钮的处理函数 
 * @param event
 * 
 */
protected function btn_clickHandler(event:MouseEvent):void
{
	if(this.title == "添加"||this.title == "修改"){
		
		if(operatetype.text == null||operatetype.text==""){
			Alert.show("处理方法不能为空", "提示");
			return;
		}else{
			maintainModel.operatetype = operatetypeid;
		}
		if(this.title == "添加"){
			if (isendoperate.selectedItem == null){
				Alert.show("请填写是否是最后步骤", "提示");
				return;
			}else{
				maintainModel.isendoperate = isendoperate.selectedItem.data;
			}
		}
		else{
			if(isendoperate.selectedItem != null){
				maintainModel.isendoperate = isendoperate.selectedItem.data;
			}else{
				maintainModel.isendoperate = interposeData.isendoperate;
			}
		}
		if (operateorder.text == null||operateorder.text==""){
			Alert.show("请填写操作顺序", "提示");
			return;
		}else{
			maintainModel.operateorder = operateorder.text;
		}
	
		maintainModel.interposeid = interpose_id;
		var olderOrder:String="-1";
		if(this.title == "修改"){
			olderOrder = interposeData.operateorder;
		}
		checkOperateOrderHandler(maintainModel.operateorder,olderOrder,interpose_typeid,fault_typeid);
	}
	else{
		if (interposetype.selectedItem != null){
			maintainModel.interposetypeid = interposetype.selectedItem.@id;
		}
		if (faulttype.selectedItem != null){
			maintainModel.faulttypeid = faulttype.selectedItem.@id;
		}
		
		maintainModel.operatetype = operatetypeid;
		if (isendoperate.selectedItem != null){
			maintainModel.isendoperate = isendoperate.selectedItem.data;
		}
		maintainModel.operateorder = operateorder.text;
		maintainModel.remark = remark.text;
		maintainModel.interposeid=	interpose_id;	
		
		this.dispatchEvent(new MaintainSearchEvent("MaintainSearchEvent",maintainModel));
		PopUpManager.removePopUp(this);
	}
}
/**
 *添加经数据交互后的的界面提示处理
 * @param event
 * 
 */
protected function addInterposeMaintainProcResult(event:ResultEvent):void{
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
public function modifyInterposeMaintainProcResult(event:ResultEvent):void
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

//验证操作步骤是否存在
public function checkOperateOrderHandler(order:String,olderOrder:String,interposetypeid:String,faulttypeid:String):void{
	var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
	remoteObject.endpoint = ModelLocator.END_POINT;
	remoteObject.showBusyCursor = true;
	if(order!=olderOrder){
		remoteObject.addEventListener(ResultEvent.RESULT,checkOperateOrderResult);
		Application.application.faultEventHandler(remoteObject);
		remoteObject.checkOperateOrder(order,interposetypeid,faulttypeid);
	}else{
		maintainModel.remark = remark.text;
		maintainModel.updateperson = Application.application.curUser;
		maintainModel.updatetime = this.getNowTime();
		if(this.title == "添加"){
			maintainModel.interposetypeid = interpose_typeid;
			maintainModel.faulttypeid = fault_typeid;
			
			remoteObject.addEventListener(ResultEvent.RESULT,addInterposeMaintainProcResult);
			Application.application.faultEventHandler(remoteObject);
			remoteObject.addInterposeMaintainProc(maintainModel);
		}else{
			maintainModel.maintainprocid = maintainprocid;
			remoteObject.addEventListener(ResultEvent.RESULT,modifyInterposeMaintainProcResult);
			Application.application.faultEventHandler(remoteObject);
			remoteObject.modifyInterposeMaintainProc(maintainModel);
		}
	}
}
public function checkOperateOrderResult(event:ResultEvent):void
{	
	if(event.result.toString()=="success")
	{
		var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		
		maintainModel.remark = remark.text;
		maintainModel.updateperson = Application.application.curUser;
		maintainModel.updatetime = this.getNowTime();
		if(this.title == "添加"){
			maintainModel.interposetypeid = interpose_typeid;
			maintainModel.faulttypeid = fault_typeid;
			
			remoteObject.addEventListener(ResultEvent.RESULT,addInterposeMaintainProcResult);
			Application.application.faultEventHandler(remoteObject);
			remoteObject.addInterposeMaintainProc(maintainModel);
		}else{
			maintainModel.maintainprocid = maintainprocid;
			remoteObject.addEventListener(ResultEvent.RESULT,modifyInterposeMaintainProcResult);
			Application.application.faultEventHandler(remoteObject);
			remoteObject.modifyInterposeMaintainProc(maintainModel);
		}
	}
	else{
		Alert.show("该步骤已经存在，请重新填写！","提示");
		operateorder.text="";
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
