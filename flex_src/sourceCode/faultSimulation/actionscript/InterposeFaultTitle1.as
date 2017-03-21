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
import sourceCode.faultSimulation.titles.selectPackCutTitle;
import sourceCode.resManager.resNet.titles.SearchEquipOrderBySystem;

public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");	

[Bindable] public var interposeData:Object;
public var interposeModel:InterposeModel = new InterposeModel();
public var user_id:String="";
public var interposeid:String="";
[Bindable] public var isModify:Boolean=true;

public var sys_code:String="";//系统传输编码
public var mouse_x:Number=0.0;//鼠标坐标X
public var mouse_y:Number=0.0;

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



public var txt_user_name:String;
public var resname:String;
public var resourceid:String;
public var equippack_acode:String="";
public var equippack_zcode:String="";
public var equipport_acode:String="";
public var equipport_zcode:String="";
public var porta_rate:String="";//a端端口速率
public var portz_rate:String="";//Z端端口速率
public var porta_type:String="";//a端端口类型
public var portz_type:String="";//z端端口类型



public var myCallBack:Function;//定义的方法变量
public var mainApp:Object = null;//回调刷新方法


//网络拓扑图中 新建故障  初始化 值
public function setTxtData():void{
	user_name.text=txt_user_name;
	resourcename.text=resname;
	resourcecode.text=resourceid;
	interposetypeid="IT0000001";//设备故障
	if(!isCutFault){
		equipname.text = resname;
		portaid.visible=false;
		portzid.visible=false;
		interposetypeid="IT0000002";
		f_user_name.label="参演人员";
		f_faulttype.label="故障类型";
		equipnameform.label="设备名称";
	}
//	equipname.text = resname;
	resourcename.enabled=false;
	
//	equipcode.text = resourceid;
	interposeModel.mouse_x=mouse_x;
	interposeModel.mouse_y=mouse_y;
	//获取设备型号列表
//	getEquipModelBySysCode(sys_code);
	//获取复用段速率和两端端口型号
	getPortTypeAndRate(resourceid);
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
	if(isCutFault){
		interposename.text="割接科目"+ getNowTime();
	}else{
		interposename.text="故障科目"+ getNowTime();
	}
	
}


/**
 * 查询设备型号
 * 
 */ 
private function getPortTypeAndRate(syscode:String):void{
	
	var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
	remoteObject.endpoint = ModelLocator.END_POINT;
	remoteObject.showBusyCursor = true;
	remoteObject.addEventListener(ResultEvent.RESULT,getEquipModelBySysCodeHandler);
	Application.application.faultEventHandler(remoteObject);
//	remoteObject.getEquipModelBySysCode(syscode);
	remoteObject.getPortTypeAndRate(syscode);
}

private function getEquipModelBySysCodeHandler(event:ResultEvent):void{
	if(event.result!=null&&event.result.toString().indexOf("=")!=-1&&event.result.toString().split("=").length==6){
		porta_rate=event.result.toString().split("=")[0];
		porta_type=event.result.toString().split("=")[1];
		portz_rate=event.result.toString().split("=")[2];
		portz_type=event.result.toString().split("=")[3];
		link_a.text = event.result.toString().split("=")[4];
		link_z.text = event.result.toString().split("=")[5];
	}
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
		if(isCutFault){
			equipnameform.enabled = true;
			interposetype.selectedIndex=0;//表示设备故障
		}else{
			interposetype.selectedIndex=1;//表示线缆故障
		}
		
		interposetypeform.enabled = isModify;
		if(isDevicePanel == true || isEquipPack == true){
			equiptypeform.enabled = isModify;
			resourcenameform.enabled = isModify;
			//选择设备时 也可选择几盘或者端口故障
		}
		
//		initSelectEquipInfoHandler();
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

		if (interposetype.selectedItem == null){
			Alert.show("请选择科目类型", "提示");
			return;
		}else{
			interposeModel.interposetype = interposetype.selectedItem.@id;
			interposeModel.interposetypeid=interposetype.selectedItem.@id;
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
		interposeModel.remark = remark.text;
		interposeModel.updateperson = Application.application.curUser;
		interposeModel.updatetime = this.getNowTime();
		interposeModel.user_name=user_name.text;
		interposeModel.user_id=user_id;
		if(this.isCutFault){
			interposeModel.s_event_title="割接";
			interposeModel.faulttype="AT10000020";
			interposeModel.faulttypeid="AT10000020";
			if(equipname.text==""||equipname.text==null){
				Alert.show("请选择割接设备", "提示");
				return;
			}else{
				interposeModel.equipname = equipname.text;
				interposeModel.equipcode = equipcode.text;
			}
			if(equipport_a.text==""||equipport_a.text==null){
				Alert.show("请选择A端端口", "提示");
				return;
			}else{
				interposeModel.equipport_a = equipport_acode;
			}
			if(equipport_z.text==""||equipport_z.text==null){
				Alert.show("请选择Z端端口", "提示");
				return;
			}else{
				interposeModel.equipport_z = equipport_zcode;
			}
			if(equipport_acode==equipport_zcode){
				Alert.show("两端端口不能相同","提示");
				return;
			}
		}else{
			interposeModel.s_event_title="故障";
			if (faulttype.selectedItem == null){
				Alert.show("请选择故障类型", "提示");
				return;
			}else{
				interposeModel.faulttype = faulttype.selectedItem.@id;
				interposeModel.faulttypeid = faulttype.selectedItem.@id;
			}
		}
		
		interposeModel.sys_code = sys_code;
		interposeModel.toplinkid = resourceid;
		
		remoteObject.addEventListener(ResultEvent.RESULT,addInterposeResult);
		Application.application.faultEventHandler(remoteObject);
		remoteObject.addInterpose(interposeModel);
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
		remoteObject.setEventIsActive1(interposeModel);
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
	re.getEquiptypeLst("0");
}

protected function getEquipTypeResultHandler(event:ResultEvent):void{
	var list:XMLList = new XMLList(event.result);
	equiptype.dataProvider = list;
	equiptype.dropdown.dataProvider = list;
	equiptype.labelField="@label";
	equiptype.text="";
	if(isEquip) {
		if(isCutFault){
			equiptype.selectedIndex=1;//割接
		}else{
			equiptype.selectedIndex=0;//复用段
		}
		
	}else if(isDevicePanel) {
		equiptype.selectedIndex=1;
	}else if(isEquipPack){
		equiptype.selectedIndex=2;
	}else {
		equiptype.selectedIndex=-1;
	}
	equiptype.enabled=false;
	getFaultTypeHander();
}
//查询故障类型
protected function getFaultTypeHander():void{
	if(interposetype.selectedItem!=null||interposetypeid!=""){
		var interpose_type:String = (interposetype.selectedItem==null?interposetypeid:interposetype.selectedItem.@id);
		var equip_type:String="复用段";
		if(isCutFault){
			equip_type = "割接";
		}
		
		interpose_type=interpose_type+";"+equip_type;
		var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		remoteObject.addEventListener(ResultEvent.RESULT,getFaultTypeInfoByInterposeTypeHandler);
		Application.application.faultEventHandler(remoteObject);
		remoteObject.getFaultTypeInfoByInterposeType(interpose_type,"");
	}
}
protected function getFaultTypeInfoByInterposeTypeHandler(event:ResultEvent):void{
	var list:XMLList = new XMLList(event.result);
	faulttype.dataProvider = list;
	faulttype.dropdown.dataProvider = list;
	faulttype.labelField="@label";
	faulttype.text="";
	faulttype.selectedIndex=0;
	if(isCutFault){//如果为割接则进行割接故障的默认值
//		var i:int=0;
//		for each(var xml:Object in faulttype.dataProvider){
//			if(this.isEquip&&"添加设备"==xml.@label){
//				faulttype.selectedIndex=i;
//			}
////			else if(this.isDevicePanel&&"交叉板故障或不在位"==xml.@label){
////				faulttype.selectedIndex=i;
////			}else if(this.isEquipPack&&"本站端口脱落或松动"==xml.@label){
////				faulttype.selectedIndex=i;
////			}
//			i+=1;
//		}
		faulttype.text="添加设备";
		faulttypeid = "AT10000020";
		faulttype.selectedIndex=-1;
		faulttype.enabled=false;
	}
	
}

//查询设备信息
//protected function selectEquipInfoHandler(event:MouseEvent):void{
//	//判断设备型号是不是选中
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
	remoteObject.getFaultTypeInfoByInterposeType(interpose_type,"");
}


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

protected function selectResourcechangeHandler(obj:Object):void{
	resourcename.text = obj.name;
	resourcecode.text = obj.id;
}
protected function equiptype_changeHandler(event:ListEvent):void
{
	
	if(equiptype.selectedItem.@label=="设备"){
		resourcename.text = this.equipname.text;
		resourcecode.text = this.equipcode.text;
	}else{
		resourcename.text ="";
		resourcecode.text ="";
	}
}

/**
 * 
 *获取割接业务配置机盘 
 **/
private function getEquippackLstHandler(location:String,event:MouseEvent):void{
	if(equipname.text==""||equipname.text==null){
		Alert.show("请先选择割接用的设备","提示");
		return;
	}else{
		var packcut:selectPackCutTitle=new selectPackCutTitle();
		packcut.page_parent=this;
		packcut.type="pack";
		if(location=="A"){
			//A端机盘
			packcut.flog=true;
			packcut.portrate=porta_rate;
			packcut.porttype=porta_type;
		}else{
			packcut.flog=false;
			packcut.portrate=portz_rate;
			packcut.porttype=portz_type;
		}
		packcut.equipcode=this.equipcode.text;
		PopUpManager.addPopUp(packcut,this,true);
		PopUpManager.centerPopUp(packcut);
		packcut.myCallBack=this.callBack;
		packcut.myCallBack1=this.callBack1;
	}
}

/**
 * 
 *获取割接业务配置端口 
 **/
private function getEquipportHandler(event:MouseEvent,flag:String):void{
	if(flag=="A"){
//		if(equippack_a.text==""||equippack_a.text==null){
//			Alert.show("请选择A端机盘","提示");
//			return;
//		}
		var packcut:selectPackCutTitle=new selectPackCutTitle();
		packcut.page_parent=this;
		packcut.type="port";
		packcut.portrate=porta_rate;
		packcut.porttype=porta_type;
		packcut.flog=true;
		packcut.equipcode=this.equipcode.text;
		packcut.rescode = "";//机盘编码
		PopUpManager.addPopUp(packcut,this,true);
		PopUpManager.centerPopUp(packcut);
		packcut.myCallBack=this.callBack2;
		packcut.myCallBack1=this.callBack3;
	}
	if(flag=='Z'){
//		if(equippack_z.text==""||equippack_z.text==null){
//			Alert.show("请选择Z端机盘","提示");
//			return;
//		}
		var packcut:selectPackCutTitle=new selectPackCutTitle();
		packcut.page_parent=this;
		packcut.portrate=portz_rate;
		packcut.porttype=portz_type;
		packcut.type="port";
		packcut.flog=false;
		packcut.equipcode=this.equipcode.text;
		packcut.rescode="";//机盘编码
		PopUpManager.addPopUp(packcut,this,true);
		PopUpManager.centerPopUp(packcut);
		packcut.myCallBack=this.callBack2;
		packcut.myCallBack1=this.callBack3;
	}
}

/**
 *回调函数，从子页面返回A端机盘的code值 
 * @param obj
 * 
 */
public function callBack(obj:Object):void{ 
	equippack_acode = obj.name; 
	equipport_a.text="";
	equipport_acode="";
}

/**
 *回调函数，从子页面返回Z端机盘的code值 
 * @param obj
 * 
 */
public function callBack1(obj:Object):void{ 
	equippack_zcode = obj.name; 
	equipport_z.text="";
	equipport_zcode="";
}
public function callBack2(obj:Object):void{ 
	equipport_acode = obj.name; 
}
public function callBack3(obj:Object):void{ 
	equipport_zcode = obj.name; 
}

/**
 * 
 * 获取割接用的设备
 * 
 **/
private function getEquipmentHandler(event:MouseEvent):void{
	//
	var sqsearch:SearchEquipOrderBySystem=new SearchEquipOrderBySystem();
	sqsearch.page_parent=this;
	sqsearch.flag=true;
	PopUpManager.addPopUp(sqsearch,this,true);
	PopUpManager.centerPopUp(sqsearch);
	sqsearch.myCallBack=this.cmbEquipname_changeHandler;
}
public function cmbEquipname_changeHandler(obj:Object):void
{
	equipname.text=obj.name;
	equipcode.text=obj.id;
	equipport_a.text="";
	equipport_z.text="";
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
