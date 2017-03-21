// ActionScript file
//新增故障

import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.other.events.CustomEvent;

import flash.events.Event;
import flash.events.MouseEvent;

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
import sourceCode.faultSimulation.titles.SelectEquipTitle;
import sourceCode.faultSimulation.titles.SelectResourceTitle;
import sourceCode.faultSimulation.titles.selectCutPortResourceTitle;

public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");	

[Bindable] public var interposeData:Object;
public var interposeModel:InterposeModel = new InterposeModel();
public var user_id:String="";
public var interposeid:String="";
public var cutportcode:String="";//割接用端口编号
public var oldport:String="";//当前选中端口编号
[Bindable] public var isModify:Boolean=true;
/**
 * isEquip,isDevicePanel,isEquipPack这三个参数用来区分当前页面是被哪个页面调用的
 * 1.isEquip：       网络拓扑图的设备上调用
 * 2.isDevicePanel： 设备面条图的机盘上调用
 * 3.isEquipPack：   机盘管理视图的端口上调用
 * 4.默认：          事件干预管理的添加按钮上调用
 */ 
[Bindable] public var isEquip:Boolean=false;
[Bindable] public var isDevicePanel:Boolean=false;
[Bindable] public var isEquipPack:Boolean=false;
[Bindable] public var paraValue:String="";
[Bindable] public var isShow:Boolean=true;
[Bindable] public var isRequired:Boolean=true;
[Bindable] public var ismaininterposeid:String;
[Bindable] public var interposetypeid:String;
[Bindable] public var faulttypeid:String;
[Bindable] public var isCutFault:Boolean=false;
public var typeflag:Boolean=false;


public var txt_user_name:String;

public var myCallBack:Function;//定义的方法变量
public var mainApp:Object = null;//回调刷新方法


//网络拓扑图中 新建故障  初始化 值
public function setTxtData():void{
	user_name.text=txt_user_name;
//	projectid.text=txt_projectid;
//	projectname.text=txt_projectname;
}
/**
 * 初始化函数
 */ 
protected function init():void{
	//查询干预类型
	getInterposeType();
	//获取设备类型
	getEquiptypeLst();
	//初始化 科目名称
	interposename.text="割接科目"+ getNowTime();
}

/**
 * 
 *查询当前机盘下的所有未被占用的端口列表 
 * selectPortCutHandler
 **/
private function selectPortCutHandler(event:MouseEvent):void{
	var rescode:String=resourcecode.text;//资源编码
	var reequipcode:String = equipcode.text;//设备编码
	var rsearch:selectCutPortResourceTitle = new selectCutPortResourceTitle();
	rsearch.eqcode=reequipcode;
	rsearch.rescode = rescode;//资源编码
	rsearch.restype = "单板";
	PopUpManager.addPopUp(rsearch,this,true);
	PopUpManager.centerPopUp(rsearch);
	rsearch.myCallBack=this.selectPortCutResultHandler;
}

private function selectPortCutResultHandler(obj:Object):void{
	
	cutport.text=obj.name;
	cutportcode=obj.id;
}

/**
 * 查询干预类型
 */ 
protected function getInterposeType():void{
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

	if(isEquip == true || isDevicePanel == true || isEquipPack == true) {//外部 进行科目添加操作
		interposetype.selectedIndex=0;
		equipnameform.enabled = isModify;
		interposetypeform.enabled = isModify;
		if(isDevicePanel == true || isEquipPack == true){
			equiptypeform.enabled = isModify;
			resourcenameform.enabled = isModify;
			//选择设备时 也可选择几盘或者端口故障
		}
		
		initSelectEquipInfoHandler();
	}else {
		interposetype.selectedIndex=-1;
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
	if(this.title == "添加"){
		interposeModel.interposename=interposename.text;
		interposeModel.interposetype = interposetype.selectedItem.@id;
		interposeModel.interposetypeid=interposetype.selectedItem.@id;
		interposeModel.faulttype = "AT10000051";
		interposeModel.faulttypeid = "AT10000051";
		interposeModel.resourcecode=resourcecode.text;
		interposeModel.resourcename=resourcename.text;
		interposeModel.equiptype = "割接";
		interposeModel.equipcode=equipcode.text;
		interposeModel.remark = remark.text;
		interposeModel.updateperson = Application.application.curUser;
		interposeModel.updatetime = this.getNowTime();
		interposeModel.user_name=user_name.text;
		interposeModel.user_id=user_id;
		interposeModel.s_event_title="割接";
		//割接端口
		interposeModel.cutportcode=cutportcode;//割接用机盘
		interposeModel.cutport = oldport;//当前选中盘ID
		remoteObject.addEventListener(ResultEvent.RESULT,addInterposeResult);
		Application.application.faultEventHandler(remoteObject);
		remoteObject.addInterposePackCut(interposeModel);
	}
}
/**
 *添加经数据交互后的的界面提示处理
 * @param event
 * 
 */
protected function addInterposeResult(event:ResultEvent):void{
	var result:Array=event.result.toString().split(";");
	if(result.length>1&&result[0]=="success"){
		//	if(event.result.toString()=="success")
		//添加完成后直接进行激活操作
		interposeModel.interposeid=result[1];
		if(isEquip == true || isDevicePanel == true || isEquipPack == true) {//外部 进行科目添加操作   进行激活操作
		var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		remoteObject.checkEventHasSolution(interposeModel);
		remoteObject.addEventListener(ResultEvent.RESULT,checkEventHasSolutionResultHandler);
		Application.application.faultEventHandler(remoteObject);
		}else{//演习科目界面添加 则手动激活
				Alert.show("添加成功!","提示");
				PopUpManager.removePopUp(this);
				this.dispatchEvent(new Event("RefreshDataGrid"))		
		}

	}
	else if(event.result.toString()=='success'){
		this.setEventIsActiveResultHandler(event);
	}
	else
	{
		Alert.show("请按要求填写数据！","提示");
	}
}
//激活操作
protected function checkEventHasSolutionResultHandler(event:ResultEvent):void{
		//此处不进行  演习科目告警或者标准处理过程 的判断 直接进行生成告警
//	if(event.result.toString()=="success"){
		var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		remoteObject.setEventIsActive(interposeModel);
		remoteObject.addEventListener(ResultEvent.RESULT,setEventIsActiveResultHandler);
		Application.application.faultEventHandler(remoteObject);
//	}else{
//			Alert.show("请先设置演习科目告警或者标准处理过程！","提示");
//		}
}
//激活操作后返回结果
protected function setEventIsActiveResultHandler(event:ResultEvent):void{
	if(event.result.toString()=="success"){
//		Alert.show("成功激活","提示");
//		this.getAllInterpose("0",pageSize.toString());
		Alert.show("添加成功,是否查看告警列表？","提示",3,this,openAlarmCallBack);
		
		MyPopupManager.removePopUp(this);
		if(isEquip==true){//如果为设备 即网络拓扑图
			myCallBack.call(mainApp);//回调
		}
		
	}else{
		
		Alert.show("操作失败！","提示");
	}
}

private function openAlarmCallBack(event:CloseEvent):void{
	if(event.detail==Alert.YES){
		subMessage.stopSendMessage("stop");
		if(this.isCutFault){
			subMessage.startSendMessage(interposeModel.user_id,"割接");
		}else{
			subMessage.startSendMessage(interposeModel.user_id);
		}
	}
}
protected function subMessage_resultHandler(event:ResultEvent):void  
{} 



protected function getEquiptypeLst():void{
	var re:RemoteObject=new RemoteObject("faultSimulation");
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.addEventListener(ResultEvent.RESULT,getEquipTypeResultHandler);
	Application.application.faultEventHandler(re);
	var type:String="1";
	if(typeflag==true){
		type="0";
	}
	re.getEquiptypeLst(type);
}

protected function getEquipTypeResultHandler(event:ResultEvent):void{
	var list:XMLList = new XMLList(event.result);
	equiptype.dataProvider = list;
	equiptype.dropdown.dataProvider = list;
	equiptype.labelField="@label";
	equiptype.text="";
	if(isEquip) {
		equiptype.selectedIndex=0;
		//查找故障类型，一开始进来的 paraValue
		var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		remoteObject.addEventListener(ResultEvent.RESULT,getFaultTypeInfoByInterposeTypeHandler);
		Application.application.faultEventHandler(remoteObject);
		remoteObject.getFaultTypeInfoByInterposeType("IT0000001;设备",paraValue);
		
	}else if(isDevicePanel) {
		equiptype.selectedIndex=1;
		var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		remoteObject.addEventListener(ResultEvent.RESULT,getFaultTypeInfoByInterposeTypeHandler);
		Application.application.faultEventHandler(remoteObject);
		remoteObject.getFaultTypeInfoByInterposeType("IT0000001;机盘",paraValue);
	}else if(isEquipPack){
		equiptype.selectedIndex=-1;
		equiptype.text="割接";
		var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		remoteObject.addEventListener(ResultEvent.RESULT,getFaultTypeInfoByInterposeTypeHandler);
		Application.application.faultEventHandler(remoteObject);
		remoteObject.getFaultTypeInfoByInterposeType("IT0000001;端口",paraValue);
	}else {
		equiptype.selectedIndex=-1;
	}
}
//查询故障类型
protected function getFaultTypeHander(event:Event):void{
	if(interposetype.selectedItem!=null||interposetypeid!=""){
		var interpose_type:String = (interposetype.selectedItem==null?interposetypeid:interposetype.selectedItem.@id);
		var equip_type:String=equiptype.text;
		interpose_type=interpose_type+";"+equip_type;
		var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		remoteObject.addEventListener(ResultEvent.RESULT,getFaultTypeInfoByInterposeTypeHandler);
		Application.application.faultEventHandler(remoteObject);
		remoteObject.getFaultTypeInfoByInterposeType(interpose_type,resourcecode.text);
	}
}
protected function getFaultTypeInfoByInterposeTypeHandler(event:ResultEvent):void{
	var list:XMLList = new XMLList(event.result);
	faulttype.dataProvider = list;
	faulttype.dropdown.dataProvider = list;
	faulttype.labelField="@label";
//	faulttype.text="";
	faulttype.selectedIndex=-1;
	faulttype.text="机盘割接";
	faulttype.enabled=false;
	
}

//查询设备信息
protected function selectEquipInfoHandler(event:MouseEvent):void{
	var sqsearch:SelectEquipTitle=new SelectEquipTitle();
	PopUpManager.addPopUp(sqsearch,this,true);
	PopUpManager.centerPopUp(sqsearch);
	sqsearch.myCallBack=this.selectEquipInfochangeHandler;
}
protected function selectEquipInfochangeHandler(obj:Object):void{
	equipname.text = obj.name;
	equipcode.text = obj.id;
	equiptype.selectedIndex=-1;
	equiptype.text="";
	resourcename.text="";
	resourcecode.text="";
	//查询设备类型
	var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
	remoteObject.endpoint = ModelLocator.END_POINT;
	remoteObject.showBusyCursor = true;
	remoteObject.addEventListener(ResultEvent.RESULT,getEquipTypeByIdHandler);
	Application.application.faultEventHandler(remoteObject);
	remoteObject.getEquipTypeById(equipcode.text);//指的是SDH端口、插板？
}

/**
 * 初始化时自动生成设备名称和资源名称
 */ 
protected function initSelectEquipInfoHandler():void{
	resourcename.text="";
	resourcecode.text="";
	if(isDevicePanel) {
		equipcode.text = paraValue.split(",")[0];
	}else if(isEquipPack) {
		equipcode.text = paraValue.split("=")[0];
	}else {
		equipcode.text = paraValue;
	}
		//查询设备类型
		var rt:RemoteObject=new RemoteObject("faultSimulation");
		rt.endpoint=ModelLocator.END_POINT;
		rt.showBusyCursor=true;
		rt.addEventListener(ResultEvent.RESULT,eqsearchHandler);
		Application.application.faultEventHandler(rt);
		rt.getEquipNameByEquipcode(equipcode.text);
}

/**
 * 设备查询获取资源名称和id的处理函数
 */ 
private function eqsearchHandler(event:ResultEvent):void{
	var eqsearch:String= event.result.toString();
	equipname.text = eqsearch;
	if(isEquip) {
		resourcename.text = eqsearch;
		resourcecode.text = equipcode.text;
		getInitFaultTypeHander();
	} else if(isDevicePanel){
		var rt:RemoteObject=new RemoteObject("faultSimulation");
		rt.endpoint=ModelLocator.END_POINT;
		rt.showBusyCursor=true;
		rt.addEventListener(ResultEvent.RESULT,packserialSearchHandler);
		Application.application.faultEventHandler(rt);
		//四个参数分别是：equipcode,frameserial,slotserial,packserial. 设备CODE，机框，机槽，机盘
		rt.getResourceNameAndID(paraValue.split(",")[0],paraValue.split(",")[1],paraValue.split(",")[2],paraValue.split(",")[3]);
	} else {
		//端口资源
		var rt:RemoteObject=new RemoteObject("faultSimulation");
		rt.endpoint=ModelLocator.END_POINT;
		rt.showBusyCursor=true;
		rt.addEventListener(ResultEvent.RESULT,packserialSearchHandler);
		Application.application.faultEventHandler(rt);
		//五个参数分别是：equipcode,frameserial,slotserial,packserial.portserial 设备CODE，机框，机槽，机盘,端口
		rt.getResourceNameAndID(paraValue.split("=")[0],paraValue.split("=")[1],paraValue.split("=")[2],paraValue.split("=")[3],paraValue.split("=")[4]);
	}
}
/**
 * 机盘查询获取资源名称和id的处理函数
 */ 
private function packserialSearchHandler(event:ResultEvent):void{
	var paramOfResource:String = event.result.toString();
	resourcecode.text = paramOfResource.split(":")[0];
	resourcename.text = paramOfResource.split(":")[1];
//	getInitFaultTypeHander();
}
private function getInitFaultTypeHander():void{
	var interpose_type:String = interposetype.selectedItem.@id;
	var equip_type:String=equiptype.text;
	interpose_type=interpose_type+";"+equip_type;
	var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
	remoteObject.endpoint = ModelLocator.END_POINT;
	remoteObject.showBusyCursor = true;
	remoteObject.addEventListener(ResultEvent.RESULT,getFaultTypeInfoByInterposeTypeHandler);
	Application.application.faultEventHandler(remoteObject);
	remoteObject.getFaultTypeInfoByInterposeType(interpose_type,resourcecode.text);
}


protected function getEquipTypeByIdHandler(event:ResultEvent):void{
	equiptype.text = event.result.toString();
}
//查询资源信息
protected function selectResourceHandler(event:MouseEvent):void{
	if(equipcode.text!=null&&equipcode.text!=""){
		if(this.equiptype.text=="设备"){
			resourcename.text = this.equipname.text;
			resourcecode.text = this.equipcode.text;
		}else{
			var rsearch:SelectResourceTitle=new SelectResourceTitle();
			rsearch.eqcode=this.equipcode.text;
			rsearch.restype=this.equiptype.text;
			PopUpManager.addPopUp(rsearch,this,true);
			PopUpManager.centerPopUp(rsearch);
			rsearch.myCallBack=this.selectResourcechangeHandler;
		}
		
	}else{
		Alert.show("请选择设备");
	}
}

protected function selectResourcechangeHandler(obj:Object):void{
	resourcename.text = obj.name;
	resourcecode.text = obj.id;
	if(interposetype.selectedItem!=null||interposetypeid!=""){
		var interpose_type:String = (interposetype.selectedItem==null?interposetypeid:interposetype.selectedItem.@id);
		var equip_type:String=equiptype.text;
		interpose_type=interpose_type+";"+equip_type;
		if(resourcecode.text!=null&&resourcecode.text!=""){
			var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
			remoteObject.endpoint = ModelLocator.END_POINT;
			remoteObject.showBusyCursor = true;
			remoteObject.addEventListener(ResultEvent.RESULT,getFaultTypeInfoByInterposeTypeHandler);
			Application.application.faultEventHandler(remoteObject);
			remoteObject.getFaultTypeInfoByInterposeType(interpose_type,resourcecode.text);
		}
	}
}
protected function equiptype_changeHandler(event:ListEvent):void
{
	
	if(equiptype.selectedItem.@label=="设备"){
		resourcename.text = this.equipname.text;
		resourcecode.text = this.equipcode.text;
		//查找在设备情况下的故障类型
		if(interposetype.selectedItem!=null||interposetypeid!=""){
			var interpose_type:String = (interposetype.selectedItem==null?interposetypeid:interposetype.selectedItem.@id);
			var equip_type:String=equiptype.text;
			interpose_type=interpose_type+";"+equip_type;
			if(resourcecode.text!=null&&resourcecode.text!=""){
				var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
				remoteObject.endpoint = ModelLocator.END_POINT;
				remoteObject.showBusyCursor = true;
				remoteObject.addEventListener(ResultEvent.RESULT,getFaultTypeInfoByInterposeTypeHandler);
				Application.application.faultEventHandler(remoteObject);
				remoteObject.getFaultTypeInfoByInterposeType(interpose_type,resourcecode.text);
			}
		}
		
	}else{
		resourcename.text ="";
		resourcecode.text ="";
		//清除故障类型列表
		faulttype.dataProvider = null;
		faulttype.dropdown.dataProvider = null;
		faulttype.text="";
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
