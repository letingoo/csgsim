// ActionScript file


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
import sourceCode.faultSimulation.model.InterposeSearchEvent;
import sourceCode.faultSimulation.titles.SelectCheckUserInfoTitle;
import sourceCode.faultSimulation.titles.SelectEquipTitle;
import sourceCode.faultSimulation.titles.SelectResourceTitle;

public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");	

[Bindable] public var interposeData:Object;
public var interposeModel:InterposeModel = new InterposeModel();
//public var user_id:String="";
public var interposeid:String="";
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

public var resname:String="";
public var resourceid:String="";
public var typeflag:Boolean=false;
public var isresearch:Boolean=false;

public var myCallBack:Function;//定义的方法变量
public var mainApp:Object = null;//回调刷新方法

public function setData():void{
//	projectname.text = interposeData.projectname;
	user_name.text = interposeData.USER_NAME;
	user_id.text = interposeData.USER_ID;
	remark.text=interposeData.REMARK;
//	projectid.text=interposeData.projectid;
	ismaininterpose.text = interposeData.ISMAININTERPOSE;
	faulttype.text = interposeData.FAULTTYPE;
	equipcode.text = interposeData.EQUIPCODE;
	interposetype.text = interposeData.INTERPOSETYPE;
	equiptype.text = interposeData.EQUIPTYPE;
	equipname.text = interposeData.EQUIPNAME;
	resourcecode.text = interposeData.RESOURCECODE;
	resourcename.text = interposeData.RESOURCENAME;
	interposeid = interposeData.INTERPOSEID;
	if(interposeData.ISMAININTERPOSE=="是"){
		ismaininterposeid="0";
	}else{
		ismaininterposeid="1";
	}
	interposetypeid=interposeData.INTERPOSETYPEID;
	faulttypeid = interposeData.FAULTTYPEID;
	interposename.text = interposeData.INTERPOSENAME;
}

public function setTxtData1():void{
	resourcename.text=resname;
	resourcecode.text=resourceid;
	equipname.text = resname;
	resourcename.enabled=false;
	interposetypeid="IT0000002";
	//	equipcode.text = resourceid;
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
	if(!isresearch){
		interposename.text="演习科目"+ getNowTime();
	}
	
}

protected function getFaultTypeInitHandler(event:ResultEvent):void{
	var list:XMLList = new XMLList(event.result);
	faulttype.dataProvider = list;
	faulttype.dropdown.dataProvider = list;
	faulttype.labelField="@label";
	faulttype.text="";
	faulttype.text=interposeData.FAULTTYPE;
	faulttype.selectedIndex=-1;
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
	if(this.title=="修改"){
		interposetype.text=interposeData.INTERPOSETYPE;
		var interpose_type=interposetypeid;
		var equip_type:String=equiptype.text;
		interpose_type=interpose_type+";"+equip_type;
		var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		remoteObject.addEventListener(ResultEvent.RESULT,getFaultTypeInitHandler);
		Application.application.faultEventHandler(remoteObject);
		remoteObject.getFaultTypeInfoByInterposeType(interpose_type,interposeData.RESOURCECODE);
	}
	if(isEquip == true || isDevicePanel == true || isEquipPack == true) {//外部 进行科目添加操作
		equipnameform.enabled = isModify;
		interposetypeform.enabled = isModify;
		if(isDevicePanel == true || isEquipPack == true){
			equiptypeform.enabled = isModify;
			resourcenameform.enabled = isModify;
			//选择设备时 也可选择几盘或者端口故障
		}
		if(typeflag){
			interposetype.selectedIndex=1;//复用段上添加，默认线缆故障
		}else{
			interposetype.selectedIndex=0;
			initSelectEquipInfoHandler();
		}
		
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
		if (interposename.text ==null ||interposename.text =="")
		{
			Alert.show("科目名称不能为空", "提示");
			return;
		}
		else
		{
			interposeModel.interposename=interposename.text;
		}
		if (user_name.text == null)
		{
			Alert.show("参演人员不能为空", "提示");
			return;
		}else{
			interposeModel.user_name = user_name.text;
		}
		interposeModel.user_id = user_id.text;

		if (interposetype.selectedItem == null){
			Alert.show("请选择科目类型", "提示");
			return;
		}else{
			interposeModel.interposetype = interposetype.selectedItem.@id;
			interposeModel.interposetypeid=interposetype.selectedItem.@id;
		}
		if (faulttype.selectedItem == null){
			Alert.show("请选择故障类型", "提示");
			return;
		}else{
			interposeModel.faulttype = faulttype.selectedItem.@id;
			interposeModel.faulttypeid = faulttype.selectedItem.@id;
		}
		if (resourcecode.text ==null ||resourcecode.text =="")
		{
			Alert.show("资源名称不能为空", "提示");
			return;
		}
		else
		{
			interposeModel.resourcecode=resourcecode.text;
			interposeModel.resourcename=resourcename.text;
		}
		if (equiptype.selectedItem == null||equiptype.text==""){
			Alert.show("请选择资源类型", "提示");
			return;
		}else{
			interposeModel.equiptype = equiptype.selectedItem.@label;
		}
		if(!typeflag){
			if (equipcode.text ==null ||equipcode.text =="")
			{
				Alert.show("设备不能为空", "提示");
				return;
			}
			else
			{
				interposeModel.equipcode=equipcode.text;
			}
		}
		
		
		interposeModel.remark = remark.text;
		interposeModel.updateperson = Application.application.curUser;
		interposeModel.updatetime = this.getNowTime();
		interposeModel.s_event_title="演习";
		remoteObject.addEventListener(ResultEvent.RESULT,addInterposeResult);
		Application.application.faultEventHandler(remoteObject);
		remoteObject.addInterpose(interposeModel);
	}
	else if(this.title == "修改"){
		if (interposename.text ==null ||interposename.text =="")
		{
			Alert.show("科目名称不能为空", "提示");
			return;
		}
		else
		{
			interposeModel.interposename=interposename.text;
		}
		if (user_name.text == null)
		{
			Alert.show("参演人员不能为空", "提示");
			return;
		}else{
			interposeModel.user_name = user_name.text;
		}
		interposeModel.user_id = user_id.text;
		if (interposetype.selectedItem != null){
			interposeModel.interposetype = interposetype.selectedItem.@id;
		}else{
			interposeModel.interposetype = interposetypeid;
		}
		if(faulttype.text==""){
			Alert.show("请选择故障类型", "提示");
			return;
		}
		if (faulttype.selectedItem != null){
			interposeModel.faulttype = faulttype.selectedItem.@id;
		}else{
			interposeModel.faulttype = faulttypeid;
		}
		if(equiptype.text==""){
			Alert.show("资源类型不能为空", "提示");
			return;
		}else{
			if (equiptype.selectedItem != null){
				interposeModel.equiptype = equiptype.selectedItem.@label;
			}else{
				interposeModel.equiptype = interposeData.EQUIPTYPE;
			}
		}
		
		if (equipcode.text ==null ||equipcode.text =="")
		{
			Alert.show("设备不能为空", "提示");
			return;
		}
		else
		{
			interposeModel.equipcode=equipcode.text;
		}
		if (resourcecode.text ==null ||resourcecode.text =="")
		{
			Alert.show("资源名称不能为空", "提示");
			return;
		}
		else
		{
			interposeModel.resourcecode=resourcecode.text;
			interposeModel.resourcename=resourcename.text;
		}
		
		interposeModel.remark = remark.text;
		interposeModel.updateperson = Application.application.curUser;
		interposeModel.updatetime = this.getNowTime();
		
		interposeModel.interposeid = interposeid;
		remoteObject.addEventListener(ResultEvent.RESULT,modifyInterposeResult);
		Application.application.faultEventHandler(remoteObject);
		remoteObject.modifyInterpose(interposeModel);
	}
	else{
		interposeModel.interposename=interposename.text;
		interposeModel.user_name=user_id.text;
		if (ismaininterpose.selectedItem != null){
			interposeModel.ismaininterpose = ismaininterpose.selectedIndex.toString();
		}
		if (interposetype.selectedItem != null){
			interposeModel.interposetype = interposetype.selectedItem.@id;
		}
		if (faulttype.selectedItem != null){
			interposeModel.faulttype = faulttype.selectedItem.@id;
		}
		
		interposeModel.equipcode=equipcode.text;
		if (equiptype.selectedItem != null){
			interposeModel.equiptype = equiptype.selectedItem.@label;
		}
		interposeModel.remark = remark.text;
		interposeModel.equipname=equipname.text;
		interposeModel.sort="I_EVENT_INTERPOSE_ID";
														
		this.dispatchEvent(new InterposeSearchEvent("InterposeSearchEvent",interposeModel));
		PopUpManager.removePopUp(this);
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

	}else
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
		if(typeflag){
			remoteObject.setEventIsActive1(interposeModel);
		}else{
			remoteObject.setEventIsActive(interposeModel);
		}
		
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
//			myCallBack.call(mainApp);//回调
		}
		
	}else{
		
		Alert.show("操作失败！","提示");
	}
}

private function openAlarmCallBack(event:CloseEvent):void{
	if(event.detail==Alert.YES){
		subMessage.stopSendMessage("stop");
		subMessage.startSendMessage(interposeModel.user_id);
	}
}

protected function subMessage_resultHandler(event:ResultEvent):void  
{} 
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
	}else if(event.result.toString()=="failed")
	{
		Alert.show("不能修改已激活的科目！","提示");
	}
	else{
		Alert.show("修改失败！","提示");
	}
}



/**
 * 清空所选用户信息
 * @param event
 */ 
private function clearUserInfoHandler(event:MouseEvent):void{
	user_name.text="";
	user_id.text = "";
}


/**
 * 用户选择的处理函数，弹出界面；选择用户
 * @param event
 * 
 */
protected function selectCheckUserInfo(event:MouseEvent):void{
	var sqsearch:SelectCheckUserInfoTitle=new SelectCheckUserInfoTitle();
	sqsearch.user_id=user_id.text;
	//	sqsearch.page_parent=this;
	PopUpManager.addPopUp(sqsearch,this,true);
	PopUpManager.centerPopUp(sqsearch);
	sqsearch.myCallBack=this.UserInfo_changeHandler;
}

/**
 * 
 * 选择用户处理
 * 双击选择用户
 * */
public function UserInfo_changeHandler(obj:Object):void
{	
	var name:String=obj.name;
	var id:String=obj.id;
	if(name.length>0){
		name=name.substr(0,name.length-1);
	}
	if(id.length>0){
		id=id.substr(0,id.length-1);
	}
//	if(this.title=="查询"){
		user_name.text=name;
		user_id.text = id;
//	}
//	else{
//		if(user_name.text==""){
//			user_name.text = name;
//			user_id.text = id;
//		}else{
//			user_name.text=name;//StringUtil.trim(user_name.text)+","+obj.name;
//			user_id.text = id;//StringUtil.trim(user_id.text)+","+ obj.id;
//		}
//	}
}

protected function getEquiptypeLst():void{
	var re:RemoteObject=new RemoteObject("faultSimulation");
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.addEventListener(ResultEvent.RESULT,getEquipTypeResultHandler);
	Application.application.faultEventHandler(re);
	var type:String="1";
	if(typeflag){
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
	if(this.title=="修改"){
		equiptype.text=interposeData.EQUIPTYPE;
	}
	if(isEquip) {
		if(typeflag){//复用段上演习
			equiptype.selectedIndex=0;
			equiptype.enabled=false;
			getFaultTypeLinkHander();
		}else{
			equiptype.selectedIndex=0;
			//查找故障类型，一开始进来的 paraValue
			var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
			remoteObject.endpoint = ModelLocator.END_POINT;
			remoteObject.showBusyCursor = true;
			remoteObject.addEventListener(ResultEvent.RESULT,getFaultTypeInfoByInterposeTypeHandler);
			Application.application.faultEventHandler(remoteObject);
			remoteObject.getFaultTypeInfoByInterposeType("IT0000001;设备",paraValue);
		}
		
	}else if(isDevicePanel) {
		equiptype.selectedIndex=1;
		var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		remoteObject.addEventListener(ResultEvent.RESULT,getFaultTypeInfoByInterposeTypeHandler);
		Application.application.faultEventHandler(remoteObject);
		remoteObject.getFaultTypeInfoByInterposeType("IT0000001;机盘",paraValue);
	}else if(isEquipPack){
		equiptype.selectedIndex=2;
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

protected function getFaultTypeLinkHander():void{
	if(interposetype.selectedItem!=null||interposetypeid!=""){
		var interpose_type:String = (interposetype.selectedItem==null?interposetypeid:interposetype.selectedItem.@id);
		var equip_type:String="复用段";
		interpose_type=interpose_type+";"+equip_type;
		var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		remoteObject.addEventListener(ResultEvent.RESULT,getFaultTypeInfoByInterposeTypeHandler);
		Application.application.faultEventHandler(remoteObject);
		remoteObject.getFaultTypeInfoByInterposeType(interpose_type,paraValue);
	}
}

//查询故障类型
protected function getFaultTypeHander(event:Event):void{
	//根据资源名称查找故障类型
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
protected function getFaultTypeInfoByInterposeTypeHandler(event:ResultEvent):void{
	if(event.result!=null&&event.result!=""){
		var list:XMLList = new XMLList(event.result);
		faulttype.dataProvider = list;
		faulttype.dropdown.dataProvider = list;
		faulttype.labelField="@label";
		faulttype.text="";
		faulttype.selectedIndex=-1;
	}
	else{
		Alert.show("无相关故障类型！","提示");
		faulttype.dataProvider = null;
		faulttype.dropdown.dataProvider = null;
		faulttype.text="";
	}
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
	getInitFaultTypeHander();
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
	remoteObject.getFaultTypeInfoByInterposeType(interpose_type);
}


protected function getEquipTypeByIdHandler(event:ResultEvent):void{
	equiptype.text = event.result.toString();
}
//查询资源信息
protected function selectResourceHandler(event:MouseEvent):void{
	if(resourcename.enabled){
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
}

protected function selectResourcechangeHandler(obj:Object):void{
	resourcename.text = obj.name;
	resourcecode.text = obj.id;
	//查找故障类型
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
