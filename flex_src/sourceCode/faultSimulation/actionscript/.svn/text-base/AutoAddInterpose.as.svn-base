// ActionScript file
//新增故障

import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.other.events.CustomEvent;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.formatters.DateFormatter;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;
import mx.utils.StringUtil;

import sourceCode.faultSimulation.model.InterposeModel;

public var interposeModel:InterposeModel = new InterposeModel();
private var arr:Array=[{label:"设备"},{label:"机盘"},{label:"端口"},{label:"复用段"},
	{label:"设备+复用段"},{label:"机盘+复用段"},{label:"端口+复用段"},{label:"设备+机盘"},
	{label:"设备+端口"},{label:"机盘+端口"}];
private var arrtemp:Array=[{label:"设备"},{label:"机盘"},{label:"端口"},{label:"复用段"}];
[Bindable]
private var equiptypeLst:ArrayCollection = new ArrayCollection(arrtemp);
[Bindable]
private var equiptypeTempLst:ArrayCollection = new ArrayCollection(arr);

private var numArr:Array = [{label:"1"},{label:"2"},{label:"3"},{label:"4"},{label:"5"},
	{label:"6"},{label:"7"},{label:"8"},{label:"9"},{label:"10"},{label:"11"},{label:"12"},
	{label:"13"},{label:"14"},{label:"15"},{label:"16"},{label:"17"},{label:"18"},{label:"19"},
	{label:"20"}];
[Bindable]
private var faultNumlst:ArrayCollection = new ArrayCollection(numArr);

/**
 * 初始化函数
 */ 
protected function init():void{
	//查询干预类型
//	getInterposeType();
//	//获取设备类型
//	getEquiptypeLst();
	//初始化 科目名称
//	interposename.text="演习科目"+ getNowTime();
	equiptype.dataProvider=equiptypeLst;
	equiptype.dropdown.dataProvider = equiptypeLst;
	equiptype.text="";
	equiptype.selectedIndex=-1;
	faultNum.selectedIndex=-1;
}


/**
 * 查询干预类型
 */ 
//protected function getInterposeType():void{
//	var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
//	remoteObject.endpoint = ModelLocator.END_POINT;
//	remoteObject.showBusyCursor = true;
//	remoteObject.addEventListener(ResultEvent.RESULT,getInterposeTypeResultHandler);
//	Application.application.faultEventHandler(remoteObject);
//	remoteObject.getInterposeType();
//}
//
//protected function getInterposeTypeResultHandler(event:ResultEvent):void{
//	var list:XMLList = new XMLList(event.result);
//	interposetype.dataProvider = list;
//	interposetype.dropdown.dataProvider = list;
//	interposetype.labelField="@label";
//	interposetype.text="";
//	interposetype.selectedIndex=-1;
//}

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
	
	if (faultNum.text ==null ||faultNum.text =="")
	{
		Alert.show("请选择要生成的故障数目", "提示");
		return;
	}
	else
	{
		interposeModel.faultNum=faultNum.text;
	}
	
	if (equiptype.selectedItem == null||equiptype.text==""){
		Alert.show("请选择故障类型", "提示");
		return;
	}else{
		interposeModel.equiptype = equiptype.selectedItem.label;
	}
	
	interposeModel.updateperson = Application.application.curUser;
	interposeModel.updatetime = this.getNowTime();
	interposeModel.s_event_title="故障";
	interposeModel.autoaddinterpose="1";//表示自动生成
	remoteObject.addEventListener(ResultEvent.RESULT,addInterposeResult);
	Application.application.faultEventHandler(remoteObject);
	remoteObject.autoAddInterpose(interposeModel);
}
/**
 *添加经数据交互后的的界面提示处理
 * @param event
 * 
 */
protected function addInterposeResult(event:ResultEvent):void{
	var result:String=event.result.toString();
	if(result=="success"){
		Alert.show("自动故障添加成功，是否打开故障列表？","提示",3,this,openAlarmCallBack);
		PopUpManager.removePopUp(this);
		
//		this.dispatchEvent(new Event("RefreshDataGrid"))	
		//打开故障查询页面

	}else
	{
		Alert.show("请按要求填写数据！","提示");
	}
}
//激活操作
//protected function checkEventHasSolutionResultHandler(event:ResultEvent):void{
//		//此处不进行  演习科目告警或者标准处理过程 的判断 直接进行生成告警
////	if(event.result.toString()=="success"){
//		var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
//		remoteObject.endpoint = ModelLocator.END_POINT;
//		remoteObject.showBusyCursor = true;
//		remoteObject.setEventIsActive(interposeModel);
//		remoteObject.addEventListener(ResultEvent.RESULT,setEventIsActiveResultHandler);
//		Application.application.faultEventHandler(remoteObject);
////	}else{
////			Alert.show("请先设置演习科目告警或者标准处理过程！","提示");
////		}
//}
//激活操作后返回结果
//protected function setEventIsActiveResultHandler(event:ResultEvent):void{
//	if(event.result.toString()=="success"){
////		Alert.show("成功激活","提示");
////		this.getAllInterpose("0",pageSize.toString());
//		Alert.show("添加成功,是否查看告警列表？","提示",3,this,openAlarmCallBack);
//		
//		MyPopupManager.removePopUp(this);
//		if(isEquip==true){//如果为设备 即网络拓扑图
//			myCallBack.call(mainApp);//回调
//		}
//		
//	}else{
//		
//		Alert.show("操作失败！","提示");
//	}
//}

private function openAlarmCallBack(event:CloseEvent):void{
	if(event.detail==Alert.YES){
		subMessage.stopSendMessage("stop");
		Application.application.openModel("故障科目查询",false);
	}
}
protected function subMessage_resultHandler(event:ResultEvent):void  
{} 

protected function faultNum_changeHandler(event:ListEvent):void
{
	// TODO Auto-generated method stub
	if(faultNum.selectedIndex>0){
		equiptype.dataProvider=equiptypeTempLst;
		equiptype.dropdown.dataProvider = equiptypeTempLst;
		equiptype.text="";
		equiptype.selectedIndex=-1;
	}else{
		equiptype.dataProvider=equiptypeLst;
		equiptype.dropdown.dataProvider = equiptypeLst;
		equiptype.text="";
		equiptype.selectedIndex=-1;
	}
}


//protected function getEquiptypeLst():void{
//	var re:RemoteObject=new RemoteObject("faultSimulation");
//	re.endpoint = ModelLocator.END_POINT;
//	re.showBusyCursor = true;
//	re.addEventListener(ResultEvent.RESULT,getEquipTypeResultHandler);
//	Application.application.faultEventHandler(re);
//	re.getEquiptypeLst();
//}
//
//protected function getEquipTypeResultHandler(event:ResultEvent):void{
//	var list:XMLList = new XMLList(event.result);
//	equiptype.dataProvider = list;
//	equiptype.dropdown.dataProvider = list;
//	equiptype.labelField="@label";
//	equiptype.text="";
//	equiptype.selectedIndex=-1;
//}
//查询故障类型
//protected function getFaultTypeHander(event:Event):void{
//	if(interposetype.selectedItem!=null||interposetypeid!=""){
//		var interpose_type:String = (interposetype.selectedItem==null?interposetypeid:interposetype.selectedItem.@id);
//		var equip_type:String=equiptype.text;
//		interpose_type=interpose_type+";"+equip_type;
//		var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
//		remoteObject.endpoint = ModelLocator.END_POINT;
//		remoteObject.showBusyCursor = true;
//		remoteObject.addEventListener(ResultEvent.RESULT,getFaultTypeInfoByInterposeTypeHandler);
//		Application.application.faultEventHandler(remoteObject);
//		remoteObject.getFaultTypeInfoByInterposeType(interpose_type);
//	}
//}
//protected function getFaultTypeInfoByInterposeTypeHandler(event:ResultEvent):void{
//	var list:XMLList = new XMLList(event.result);
//	faulttype.dataProvider = list;
//	faulttype.dropdown.dataProvider = list;
//	faulttype.labelField="@label";
//	faulttype.text="";
//	faulttype.selectedIndex=0;
//	if(this.isCutFault){//如果为割接则进行割接故障的默认值
//		var i:int=0;
//		for each(var xml:Object in faulttype.dataProvider){
//			if(this.isEquip&&"网元托管"==xml.@label){
//				faulttype.selectedIndex=i;
//			}else if(this.isDevicePanel&&"交叉板故障或不在位"==xml.@label){
//				faulttype.selectedIndex=i;
//			}else if(this.isEquipPack&&"本站端口脱落或松动"==xml.@label){
//				faulttype.selectedIndex=i;
//			}
//			i+=1;
//		}
//		faulttype.enabled=false;
//	}
//	
//}

////查询设备信息
//protected function selectEquipInfoHandler(event:MouseEvent):void{
//	var sqsearch:SelectEquipTitle=new SelectEquipTitle();
//	PopUpManager.addPopUp(sqsearch,this,true);
//	PopUpManager.centerPopUp(sqsearch);
//	sqsearch.myCallBack=this.selectEquipInfochangeHandler;
//}
//protected function selectEquipInfochangeHandler(obj:Object):void{
//	equipname.text = obj.name;
//	equipcode.text = obj.id;
//	equiptype.selectedIndex=-1;
//	equiptype.text="";
//	resourcename.text="";
//	resourcecode.text="";
//	//查询设备类型
//	var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
//	remoteObject.endpoint = ModelLocator.END_POINT;
//	remoteObject.showBusyCursor = true;
//	remoteObject.addEventListener(ResultEvent.RESULT,getEquipTypeByIdHandler);
//	Application.application.faultEventHandler(remoteObject);
//	remoteObject.getEquipTypeById(equipcode.text);//指的是SDH端口、插板？
//}

/**
 * 初始化时自动生成设备名称和资源名称
 */ 
//protected function initSelectEquipInfoHandler():void{
//	resourcename.text="";
//	resourcecode.text="";
//	if(isDevicePanel) {
//		equipcode.text = paraValue.split(",")[0];
//	}else if(isEquipPack) {
//		equipcode.text = paraValue.split("=")[0];
//	}else {
//		equipcode.text = paraValue;
//	}
//		//查询设备类型
//		var rt:RemoteObject=new RemoteObject("faultSimulation");
//		rt.endpoint=ModelLocator.END_POINT;
//		rt.showBusyCursor=true;
//		rt.addEventListener(ResultEvent.RESULT,eqsearchHandler);
//		Application.application.faultEventHandler(rt);
//		rt.getEquipNameByEquipcode(equipcode.text);
//}

/**
 * 设备查询获取资源名称和id的处理函数
 */ 
//private function eqsearchHandler(event:ResultEvent):void{
//	var eqsearch:String= event.result.toString();
//	equipname.text = eqsearch;
//	if(isEquip) {
//		resourcename.text = eqsearch;
//		resourcecode.text = equipcode.text;
//		getInitFaultTypeHander();
//	} else if(isDevicePanel){
//		var rt:RemoteObject=new RemoteObject("faultSimulation");
//		rt.endpoint=ModelLocator.END_POINT;
//		rt.showBusyCursor=true;
//		rt.addEventListener(ResultEvent.RESULT,packserialSearchHandler);
//		Application.application.faultEventHandler(rt);
//		//四个参数分别是：equipcode,frameserial,slotserial,packserial. 设备CODE，机框，机槽，机盘
//		rt.getResourceNameAndID(paraValue.split(",")[0],paraValue.split(",")[1],paraValue.split(",")[2],paraValue.split(",")[3]);
//	} else {
//		//端口资源
//		var rt:RemoteObject=new RemoteObject("faultSimulation");
//		rt.endpoint=ModelLocator.END_POINT;
//		rt.showBusyCursor=true;
//		rt.addEventListener(ResultEvent.RESULT,packserialSearchHandler);
//		Application.application.faultEventHandler(rt);
//		//五个参数分别是：equipcode,frameserial,slotserial,packserial.portserial 设备CODE，机框，机槽，机盘,端口
//		rt.getResourceNameAndID(paraValue.split("=")[0],paraValue.split("=")[1],paraValue.split("=")[2],paraValue.split("=")[3],paraValue.split("=")[4]);
//	}
//}
/**
 * 机盘查询获取资源名称和id的处理函数
 */ 
//private function packserialSearchHandler(event:ResultEvent):void{
//	var paramOfResource:String = event.result.toString();
//	resourcecode.text = paramOfResource.split(":")[0];
//	resourcename.text = paramOfResource.split(":")[1];
//	getInitFaultTypeHander();
//}
//private function getInitFaultTypeHander():void{
//	var interpose_type:String = interposetype.selectedItem.@id;
//	var equip_type:String=equiptype.text;
//	interpose_type=interpose_type+";"+equip_type;
//	var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
//	remoteObject.endpoint = ModelLocator.END_POINT;
//	remoteObject.showBusyCursor = true;
//	remoteObject.addEventListener(ResultEvent.RESULT,getFaultTypeInfoByInterposeTypeHandler);
//	Application.application.faultEventHandler(remoteObject);
//	remoteObject.getFaultTypeInfoByInterposeType(interpose_type);
//}


//protected function getEquipTypeByIdHandler(event:ResultEvent):void{
//	equiptype.text = event.result.toString();
//}
//查询资源信息
//protected function selectResourceHandler(event:MouseEvent):void{
//	if(equipcode.text!=null&&equipcode.text!=""){
//		if(this.equiptype.text=="设备"){
//			resourcename.text = this.equipname.text;
//			resourcecode.text = this.equipcode.text;
//		}else{
//			var rsearch:SelectResourceTitle=new SelectResourceTitle();
//			rsearch.eqcode=this.equipcode.text;
//			rsearch.restype=this.equiptype.text;
//			PopUpManager.addPopUp(rsearch,this,true);
//			PopUpManager.centerPopUp(rsearch);
//			rsearch.myCallBack=this.selectResourcechangeHandler;
//		}
//		
//	}else{
//		Alert.show("请选择设备");
//	}
//}

//protected function selectResourcechangeHandler(obj:Object):void{
//	resourcename.text = obj.name;
//	resourcecode.text = obj.id;
//}
//protected function equiptype_changeHandler(event:ListEvent):void
//{
//	
//	if(equiptype.selectedItem.@label=="设备"){
//		resourcename.text = this.equipname.text;
//		resourcecode.text = this.equipcode.text;
//	}else{
//		resourcename.text ="";
//		resourcecode.text ="";
//	}
//}
/**
 * 获取当前时间
 */
protected function getNowTime():String{
	var dateFormatter:DateFormatter = new DateFormatter();
	dateFormatter.formatString = "YYYY-MM-DD JJ:NN:SS";
	var nowDate:String= dateFormatter.format(new Date());
	return nowDate;
}
