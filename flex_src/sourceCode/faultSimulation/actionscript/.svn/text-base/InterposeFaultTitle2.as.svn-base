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
import sourceCode.faultSimulation.titles.selectCutPortTitle;

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
[Bindable] public var interposetypeid:String="IT0000001";
[Bindable] public var faulttypeid:String;
[Bindable] public var equiptypeid:String;
[Bindable] public var isCutFault:Boolean=false;



public var txt_user_name:String;
public var resname:String;
public var resourceid:String;
public var cutResourceid:String;

public var myCallBack:Function;//定义的方法变量
public var mainApp:Object = null;//回调刷新方法

[Bindable]
private var arr_modify:ArrayCollection=new ArrayCollection([
	{label:'--请选择--'},
	{label:'修改单板'},
	{label:'修改端口'}
	]);

public var remoteObject:RemoteObject=new RemoteObject("faultSimulation");


//网络拓扑图中 新建故障  初始化 值
public function setTxtData():void{
	user_name.text=txt_user_name;
	equipcode.text = paraValue;
}
/**
 * 初始化函数
 */ 
protected function init():void{
	
	getFaultTypeHander();
	initSelectEquipInfoHandler();
	//初始化 科目名称
	interposename.text="割接科目"+ getNowTime();
	interposetype.text="设备故障";
	equiptype.text = "割接";
	equipnameform.enabled = false;
	equiptypeform.enabled=false;
	
	interposetypeform.enabled = isModify;
	equiptypeid="ET0000005";
}



/**
 * 割接类型改变处理函数
 * faulttypeChangeHandler
 */
private function faulttypeChangeHandler(event:ListEvent):void{
	if(faulttype.selectedItem.@label=="修改设备"){
		//把隐藏的字段显示出来
		modifylocationid.includeInLayout=true;
		modifylocationid.visible=true;
		cutresourceid.includeInLayout=true;
		cutresourceid.visible=true;
		resourcename.text = "";
		resourcecode.text = "";
	}else{
		//把显示出的字段隐藏
		modifylocationid.includeInLayout=false;
		modifylocationid.visible=false;
		cutresourceid.includeInLayout=false;
		cutresourceid.visible=false;
		resourcename.text = equipname.text;
		resourcecode.text = paraValue;
	}
	modifylocation.text="";
	modifylocation.selectedIndex=0;
}

private function cutResourceSelectHandler(event:MouseEvent):void{
	if(resourcename.text==""||resourcename.text==null){
		Alert.show("请先选择割接资源！","提示");
		return;
	}else{
		var rescode:String=resourcecode.text;//资源编码
		var reequipcode:String = equipcode.text;//设备编码
		var rsearch:selectCutPortResourceTitle = new selectCutPortResourceTitle();
		rsearch.eqcode=reequipcode;
		rsearch.rescode = rescode;//资源编码
		if(this.modifylocation.text=="修改单板"){
			//选择单板，要求和当前选的单板型号、端口速率一样，而且未被占用
			rsearch.restype = "单板";
		}else{
			//端口列表，要求端口速率一样且未被占用
			rsearch.restype = "端口";
		}
		PopUpManager.addPopUp(rsearch,this,true);
		PopUpManager.centerPopUp(rsearch);
		rsearch.myCallBack=this.selectCutPortResourceHandler;
	}
}

private function selectCutPortResourceHandler(obj:Object):void{
	cutResourceid = obj.id;
	cutResource.text=obj.name;
}

private function modifylocationChangeHandler(event:MouseEvent):void{
	if(faulttype.text=='修改设备'){
		if(modifylocation.selectedIndex<1){
			Alert.show("请先选择修改类型！","提示");
			return;
		}else{
			if(this.modifylocation.text=="修改端口"){
				//			resourcename.text = this.equipname.text;
				//			resourcecode.text = paraValue;
				//选择设备下的所有电路端口和光路端口
				var rsearch:selectCutPortTitle = new selectCutPortTitle();
				rsearch.eqcode=this.equipcode.text;
				PopUpManager.addPopUp(rsearch,this,true);
				PopUpManager.centerPopUp(rsearch);
				rsearch.myCallBack=this.selectResourcechangeHandler;
			}else{
				var srt:SelectResourceTitle=new SelectResourceTitle();
				//只选择光路板和支路板、交叉板？
				srt.eqcode=this.equipcode.text;
				srt.restype=this.modifylocation.text;
				PopUpManager.addPopUp(srt,this,true);
				PopUpManager.centerPopUp(srt);
				srt.myCallBack=this.selectResourcechangeHandler;
			}
		}
	}
}

private function modifyLocationChangeHandler(event:ListEvent):void{
//	if(modifylocation.selectedIndex==2){
//		resourcename.text = this.equipname.text;
//		resourcecode.text = paraValue;
//	}else{
		resourcename.text ="";
		resourcecode.text ="";
		cutResource.text="";
		cutResourceid="";
//	}
}

protected function selectResourcechangeHandler(obj:Object):void{
	cutResource.text="";
	cutResourceid="";
	resourcename.text = obj.name;
	resourcecode.text = obj.id;
}

/**
 *添加或修改按钮的处理函数 
 * @param event
 * 
 */
protected function btn_clickHandler(event:MouseEvent):void
{
	remoteObject.endpoint = ModelLocator.END_POINT;
	remoteObject.showBusyCursor = true;
		
	interposeModel.interposename=interposename.text;
	interposeModel.interposetype =interposetypeid;
	interposeModel.interposetypeid=interposetypeid;
	interposeModel.equiptype =equiptype.text;
	interposeModel.equipcode=paraValue;
	if (faulttype.selectedItem == null){
		Alert.show("请选择割接类型", "提示");
		return;
	}else{
		interposeModel.faulttype = faulttype.selectedItem.@id;
		interposeModel.faulttypeid = faulttype.selectedItem.@id;
	}
	
	interposeModel.remark = remark.text;
	interposeModel.updateperson = Application.application.curUser;
	interposeModel.updatetime = this.getNowTime();
	interposeModel.user_name=user_name.text;
	interposeModel.user_id=user_id;
	if(this.isCutFault){
		interposeModel.s_event_title="割接";
	}else{
		interposeModel.s_event_title="故障";
	}
	interposeModel.sys_code = sys_code;
	//判断如果是删除，设备的复用段的速率必须一样，且只有2条复用段
	if(interposeModel.faulttype=="AT10000021"){
		interposeModel.resourcecode=resourcecode.text;
		interposeModel.resourcename=resourcename.text;
		checkToplinkrateDiff(equipcode.text);
	}
	else{
		//修改操作
		if(modifylocation.text==""){
			
			Alert.show("请选择修改类型","提示");
			return;
		}else{
			interposeModel.modifylocation = modifylocation.text;
		}
		if(resourcename.text==""||resourcename.text==null){
			Alert.show("请选择割接资源", "提示");
			return;
		}else{
			interposeModel.resourcecode=resourcecode.text;//当前资源ID
			interposeModel.resourcename=resourcename.text;
		}
		if(cutResource.text==""||cutResource.text==null){
			Alert.show("请选择备用资源", "提示");
			return;
		}else{
			interposeModel.cutResource=cutResourceid;//备用资源ID
		}
		//备用资源
		
		remoteObject.addEventListener(ResultEvent.RESULT,addInterposeResult);
		Application.application.faultEventHandler(remoteObject);
		remoteObject.addCutInterposeEquipModify(interposeModel);
	}

}

/**
 * 验证设备是否只有两条复用段，且速率是一样的
 * @name:checkToplinkrateDiff
 * @param :equipcode
 */ 
private function checkToplinkrateDiff(equipcode:String):void{
	var re:RemoteObject=new RemoteObject("faultSimulation");
	re.endpoint=ModelLocator.END_POINT;
	re.showBusyCursor=true;
	re.addEventListener(ResultEvent.RESULT,checkToplinkrateDiffHandler);
	Application.application.faultEventHandler(re);
	re.checkToplinkrateDiff(equipcode);
}

protected function checkToplinkrateDiffHandler(event:ResultEvent):void{
	if(event.result.toString()=="fail"){
		//表示可以割接
		remoteObject.addEventListener(ResultEvent.RESULT,addInterposeResult);
		Application.application.faultEventHandler(remoteObject);
		remoteObject.addInterposeCutFault(interposeModel);
	}else{
		Alert.show("选择的设备不能进行割接删除！","提示");
		return;
	}
}


/**
 *添加经数据交互后的的界面提示处理
 * @param event
 * 
 */
protected function addInterposeResult(event:ResultEvent):void{
	if(event.result.toString()=='suc'){
		var str:String="修改成功!";
		if(interposeModel.faulttype=="AT10000021"){
			str="删除成功!";
		}
		Alert.show(str+"是否查看告警列表？","提示",3,this,openAlarmCallBack);
		
		MyPopupManager.removePopUp(this);
		if(isEquip==true){//如果为设备 即网络拓扑图
			myCallBack.call(mainApp);//回调
		}
	}else{
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
	
		}
	}
	
//	else{
//		Alert.show("请按要求填写数据！","提示");
//	}

}
//激活操作
protected function checkEventHasSolutionResultHandler(event:ResultEvent):void{
		//此处不进行  演习科目告警或者标准处理过程 的判断 直接进行生成告警
//	if(event.result.toString()=="success"){
//		var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		//不能这么使用，因为当前设备已删除了
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
		var str:String="修改成功!";
		if(interposeModel.faulttype=="AT10000021"){
			str="删除成功!";
		}
		Alert.show(str+"是否查看告警列表？","提示",3,this,openAlarmCallBack);
		
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


//查询故障类型
protected function getFaultTypeHander():void{
	var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
	var interpose_type:String = interposetypeid;
	var equip_type:String="割接";
	interpose_type=interpose_type+";"+equip_type;
	remoteObject.endpoint = ModelLocator.END_POINT;
	remoteObject.showBusyCursor = true;
	remoteObject.addEventListener(ResultEvent.RESULT,getFaultTypeInfoByInterposeTypeHandler);
	Application.application.faultEventHandler(remoteObject);
	remoteObject.getFaultTypeInfoByInterposeType(interpose_type,"");
}
protected function getFaultTypeInfoByInterposeTypeHandler(event:ResultEvent):void{
	var list:XMLList = new XMLList(event.result);
	faulttype.dataProvider = list;
	faulttype.dropdown.dataProvider = list;
	faulttype.labelField="@label";
	faulttype.text="";
	faulttype.selectedIndex=-1;
}


/**
 * 初始化时自动生成设备名称和资源名称
 */ 
protected function initSelectEquipInfoHandler():void{
	var re:RemoteObject=new RemoteObject("faultSimulation");
	re.endpoint=ModelLocator.END_POINT;
	re.showBusyCursor=true;
	re.addEventListener(ResultEvent.RESULT,eqsearchHandler);
	Application.application.faultEventHandler(re);
	re.getEquipNameByEquipcode(paraValue);
}

/**
 * 设备查询获取资源名称和id的处理函数
 */ 
private function eqsearchHandler(event:ResultEvent):void{
	var eqsearch:String= event.result.toString();
	equipname.text = eqsearch;
//	if(isEquip) {
//		resourcename.text = eqsearch;
//		resourcecode.text = paraValue;
//	} 
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
