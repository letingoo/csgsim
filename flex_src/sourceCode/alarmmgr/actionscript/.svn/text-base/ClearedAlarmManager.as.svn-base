// ActionScript file
import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.actionscript.PopupMenu_AlarmDeal;
import common.actionscript.Registry;
import common.other.events.LinkParameterEvent;

import flexunit.utils.ArrayList;

import mx.collections.ArrayCollection;
import mx.containers.TitleWindow;
import mx.controls.Alert;
import mx.core.Application;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.RemoteObject;
import mx.utils.ObjectUtil;

import org.flexunit.runner.Result;

import sourceCode.alarmmgr.actionscript.*;
import sourceCode.alarmmgr.model.AlarmMangerModel;
import sourceCode.alarmmgr.model.AlarmResultModel;
import sourceCode.flashalarm.ShowFlashAlarmDetail;
import sourceCode.rootalarm.model.AckRootAlarmModel;
import sourceCode.rootalarm.myAlert.AlertCanvas;
import sourceCode.rootalarm.myAlert.AlertTip;
import sourceCode.rootalarm.views.AlarmHelpEXP;
import sourceCode.rootalarm.views.ChangToCompanyAlarm;
import sourceCode.rootalarm.views.ChangeExistFault;
import sourceCode.rootalarm.views.FollowAlarm;
import sourceCode.rootalarm.views.RootAlarmDetails;
import sourceCode.systemManagement.model.UserModel;
import sourceCode.tableResurces.views.FileExportFirstStep;

import twaver.Follower;
[Embed(source="assets/images/rootalarm/up.png")]
public var upIcon:Class; 

[Embed(source="assets/images/rootalarm/down.png")]
public var downIcon:Class; 

[Embed(source="assets/images/rootalarm/icon_del.png")]
public var ClearedAlarmIcon:Class; 

[Embed(source="assets/images/mntsubject/bubble-chat.png")] 
private var iconClass:Class; 

public var flag:int=1; 
private var count:int; 
[Bindable]
public var contextmenu:String;
[Bindable]
private var majorcount:String;
[Bindable]
private var criticalcount:String;
[Bindable]
private var minorcount:String;
[Bindable]
private var warningcount:String;
[Bindable]
private var sum:String = "";

[Bindable]
public var start:String = "0";
[Bindable]
public var end:String = "50";

[Bindable]
public var gridSelectItem:Object=null;

[Bindable]
private var table:String="v_clearedalarminfonew";

private var alarmmangermodel:AlarmMangerModel =new AlarmMangerModel();

public var  alarmlevelxzx : String="";
private var alarmFlag:Boolean = false;//点击告警分类时为true
public var  dealperson : String="";
public var  ackperson : String="";
public var  belongtransys : String="";
public var alarm_level:String;
public var  isack:String="";
public var  isacked:String="";
public var  isrootalarm:String="";
public var iscleared:String="";
public var  ts :ArrayCollection =null;
private var param:ArrayCollection =new ArrayCollection();
private var level:String="";
private var levelflag:String="";
public var transsysname:String = "";
private var combox:ComboBox=null;
private var defaultValue:String="";
private var tw:TreeWindow;
public var mainFlag:Boolean=true;//表示正常查询
public var belongequip:String="";
public var queryFlag="";
//新加的
public var belongshelfcode:String="";
private var pageSize:int=50;
public var belongpackobject:String="";
public var belongportobject:String="";
public var ackMonitor:String="";
public var belongportcode:String="";
private var vendor:String="";
private var conMenuArray:ArrayCollection;       //存储右键菜单信息
private var alarmid:String="";
public var userid:String;   //修改人    以后再取
private var contextMeau:ContextMenu=new ContextMenu();
private var transsysCB:AlarmManagerCombobox=new AlarmManagerCombobox();
private var transdevCB:AlarmManagerCombobox=new AlarmManagerCombobox();
private var talarmlevelCB:AlarmManagerCombobox=new AlarmManagerCombobox();
private var indexRenderer:Class = SequenceItemRenderer;  
private var rootAlarmWin:TitleWindow;
private var alarmHelpEXP:TitleWindow;
private var popupmenu_alarmdeal:PopupMenu_AlarmDeal;

public var alarmType:String = "";//告警级别
//			private var flagPic:Boolean=false;
public var curUser:String="";
public var curUserName:String="";
public var curUserEnable:Boolean=false;
[Bindable]
public var operPerson:String="";
[Bindable]
private var ac:ArrayCollection = new ArrayCollection([
	{label:'历史告警查询'}]);		

public function init():void{
	
	popupmenu_alarmdeal=new PopupMenu_AlarmDeal();
	isAck.dataProvider=ack;
	talarmType.dataProvider=alarmtype;
//	cleared.dataProvider=isCleared;
	//不同告警级别的数量
	transdevCB.setCombox(transdev,'vendor','');   //所属厂家 
	talarmlevelCB.setCombox(talarmlevel,'alarmlevel',alarm_level);	//告警级别
	transsysCB.setCombox(transys,'sys',"");	//所属系统
	
	var rtobj:RemoteObject=new RemoteObject("AlarmManagerComboboxDwr");
	rtobj.endpoint= ModelLocator.END_POINT;
	rtobj.showBusyCursor=true;
	rtobj.getQueryVisiable("V_ALARMINFONEW");        //告警右侧查询条件显示权限，方便维护人员，以后想增删查询条件只在数据库改就可以了
	rtobj.addEventListener(ResultEvent.RESULT,queryHandler);
	
	var roUserInfo:RemoteObject = new RemoteObject("userManager");
	roUserInfo.endpoint = ModelLocator.END_POINT;
	
	roUserInfo.addEventListener(ResultEvent.RESULT,getUserInfo);
	roUserInfo.getOnlineUserByUserId();	
	
}
public function getUserInfo(event:ResultEvent):void{
	var user:UserModel = (UserModel)(event.result);
	if(user){
		curUser = user.user_id;
		curUserName = user.user_name;
		curUserEnable = user.enable;
	}
	Setlevelcount();
	getAllAlarmInfo("0","50");
}
public function queryHandler(event:ResultEvent):void{
	var arr:ArrayCollection = event.result as ArrayCollection;
	if(!arr.contains(tt1.text.split(":")[0])){
		t1.visible = false;
		t1.includeInLayout = false;
	}
	if(!arr.contains(tt2.text.split(":")[0])){
		t2.visible = false;
		t2.includeInLayout = false;
	}
	if(!arr.contains(tt3.text.split(":")[0])){
		t3.visible = false;
		t3.includeInLayout = false;
	}
	if(!arr.contains(tt4.text.split(":")[0])){
		t4.visible = false;
		t4.includeInLayout = false;
	}
	if(!arr.contains(tt5.text.split(":")[0])){
		t5.visible = false;
		t5.includeInLayout = false;
	}
	if(!arr.contains(tt6.text.split(":")[0])){
		t6.visible = false;
		t6.includeInLayout = false;
	}
	if(!arr.contains(tt7.text.split(":")[0])){
		t7.visible = false;
		t7.includeInLayout = false;
	}
	//				if(!arr.contains(tt8.text.split(":")[0])){
	//					t8.visible = false;
	//					t8.includeInLayout = false;
	//				}
	if(!arr.contains("发生时间")){
		t9.visible = false;
		t9.includeInLayout = false;
		t10.visible = false;
		t10.includeInLayout = false;
	}
	if(!arr.contains(tt12.text.split(":")[0])){
		t12.visible = false;
		t12.includeInLayout = false;
	}
	//				if(!arr.contains(tt13.text.split(":")[0])){
	//					t13.visible = false;
	//					t13.includeInLayout = false;
	//				}
	if(!arr.contains(tt14.text.split(":")[0])){
		t14.visible = false;
		t14.includeInLayout = false;
	}
	if(!arr.contains(tt16.text.split(":")[0])){
		t16.visible = false;
		t16.includeInLayout = false;
	}
	if(!arr.contains(tt15.text.split(":")[0])){
		t15.visible = false;
		t15.includeInLayout = false;
	}
	if(!arr.contains(tt17.text.split(":")[0])){
		t17.visible = false;
		t17.includeInLayout = false;
	}
	if(!arr.contains(tt18.text.split(":")[0])){
		t18.visible = false;
		t18.includeInLayout = false;
	}
}

public function getAllAlarmInfo(start:String,end:String):void{
	setInfos(start,end);
	
	var rtobj:RemoteObject=new RemoteObject("AlarmManagerComboboxDwr");
	rtobj.endpoint= ModelLocator.END_POINT;
	rtobj.showBusyCursor=true;
	alarmmangermodel.queryFlag=queryFlag;
	rtobj.getAlarmInfos(alarmmangermodel);        //表格加载数据
	rtobj.addEventListener(ResultEvent.RESULT,getAllAlarmInfoHandler);
}

public function setInfos(start:String,end:String):void{
	if(mainFlag){//表示一开始进来的查询
		belongtransys="";
		level="";
		vendor="";
		isack="";
		isrootalarm="";
		if(iscleared !="" && iscleared!=null){
			iscleared=iscleared;
		}else{
			iscleared="1";//已清除
		}
	}else{//表示点击不同级别告警或者查询按钮
		if(alarmFlag){//点击告警颜色分类时调用
			level = alarmlevelxzx;
			belongtransys="";
			vendor="";
			isack="";
			isrootalarm="";
			if(iscleared !="" && iscleared!=null){
				iscleared=iscleared;
			}else{
				iscleared="1";
			}
		}else{//表示查询按钮
			belongtransys  = transys.selectedItem.code+"";//传输系统
			if(levelflag=="1"){
				level = alarmlevelxzx;
			}else{
				level=talarmlevel.selectedItem.code;//级别
			}
			vendor =  transdev.selectedItem.code;//厂商
			isack=isAck.selectedItem.ack+'';//是否确认
			alarmType=talarmType.selectedItem.alarmtype;//告警来源
		}
	}
	
	if(alarmlevelxzx=="总计"){
//		level="";
		level=talarmlevel.selectedItem.code;
	}
	if(belongtransys=="0"){belongtransys='';}
	if(vendor=="0"){vendor='';}
	if(level=="0"){level='';}
	if(isack=="2"){isack='';}
	if(isrootalarm=="2"){isrootalarm='';}
	if(iscleared=="2"){iscleared='1';}
	if(isacked!=""){
		if(isacked=="2")
		{
			isack='';
		}
		else{
			isack=isacked;
		}
	}
	alarmmangermodel.alarmlevel=level;//告警级别
	alarmmangermodel.alarmdesc = alarmDesc.text+'';//告警名称
	alarmmangermodel.alarmObj=alarmObj.text+'';//告警对象
	alarmmangermodel.isAck=isack;//是否确认
	alarmmangermodel.start_time = starttime.text+'';
	alarmmangermodel.belongtransys=belongtransys;//系统名称
	alarmmangermodel.end= end;
	alarmmangermodel.end_time=endtime.text+'';
	alarmmangermodel.start=start;
	alarmmangermodel.vendor=vendor;//设备厂商
	alarmmangermodel.alarmType = alarmType;//告警来源
	
	alarmmangermodel.iscleared="";
	alarmmangermodel.flag="1";
	//确认人
	alarmmangermodel.ackperson=(ackperson!=""?ackperson:ackperson1.text+"");
	alarmmangermodel.tablename = table;
	
	//局站
	alarmmangermodel.belongstation=belongstation.text+"";
	//区域
	alarmmangermodel.area=area.text+"";
	//确认时间
	alarmmangermodel.confirmTime=confirmTime.text+"";
	//告警原因
	alarmmangermodel.isworkcase=isworkcase.text+"";
	//闪屏次数
	alarmmangermodel.flashcount = flashcount.text + "";
	
	alarmmangermodel.alarmman="";//历史告警查询不按人员查
	alarmmangermodel.queryFlag=queryFlag;
}

private function getAllAlarmInfoHandler(event:ResultEvent):void{
	param.removeAll();
	var alarmInfos:ArrayCollection=event.result.list as ArrayCollection;
	if(event.result.list==null || event.result.list==""){
		Alert.show("没有结果","提示信息",4,this,null,iconClass);
		
	}
	for each(var a:Object in alarmInfos){
		param.addItem({alarmlevelname:a.ALARMLEVELNAME,alarmobjdesc:a.ALARMOBJDESC,alarmobject:a.ALARMOBJECT,firststarttime:a.FIRSTSTARTTIME,alarmType:a.ALARMTYPE,
			isackedzh:a.ISACKEDZH,laststarttime:df.format(a.LASTSTARTTIME),isrootalarmzh:a.ISROOTALARMZH,vendorzh:a.VENDORZH,vendor:a.VENDOR,
			alarmnumber:a.ALARMNUMBER,belongtransys:a.BELONGTRANSYS,belongequip:a.BELONGEQUIP,belongshelfcode:a.BELONGSHELFCODE,belongpackobject:a.BELONGPACKOBJECT,
			belongportobject:a.BELONGPORTOBJECT,alarmdesc:a.ALARMDESC,belongslot:a.BELONGSLOT,flashcount:a.FLASHCOUNT,
			belongportcode:a.BELONGPORTCODE,objclasszh:a.OBJCLASSZH,ackperson:a.ACKPERSON,acktime:df.format(a.ACKTIME),isworkcase:a.ISWORKCASE,
			unit:a.UNIT, isfilter:a.ISFILTER, belongstation:a.BELONGSTATION, isbugno:a.ISBUGNO,area:a.AREA,belongpack:a.BELONGPACK,dealresultzh:a.DEALRESULTZH,carrycircuit:a.CARRYCIRCUIT,dealperson:a.DEALPERSON,bugno:a.BUGNO,dealresult:a.DEALRESULT,ackcontent:a.ACKCONTENT,endtime:df.format(a.ENDTIME)});
	}
	dg.dataProvider=param;
	pagingToolBarforAlarmExp.orgData =param;
	count =int(event.result.alarmcount);
	pagingToolBarforAlarmExp.totalRecord = count;
	pagingToolBarforAlarmExp.dataBind(true);
}

public function pagingFunction(pageIndex:int,pageSize:int):void {//allType分页查询所有数据
	
	this.pageSize=pageSize;
	getAllAlarmInfo((pageIndex*pageSize).toString(),(pageIndex*pageSize+pageSize).toString());
	
}

//获取不同告警级别的数量
public function Setlevelcount():void{
	var rtobj :RemoteObject= new RemoteObject("AlarmManagerComboboxDwr");
	rtobj.endpoint = ModelLocator.END_POINT;
	rtobj.showBusyCursor = true;
	level = "";
//	if(alarmFlag){
//		level = alarmlevelxzx;
//	}
	vendor = "";
	isack = "";
	isrootalarm = "";
	if(iscleared !="" && iscleared!=null){
		iscleared=iscleared;
	}else{
		iscleared="1";
	}
	if(alarmlevelxzx=="总计"){level="";}
	if(vendor=="0"){vendor='';}
	if(level=="0"){level='';}
	if(isack=="2"){isack='';}
	if(isrootalarm=="2"){isrootalarm='';}
	if(iscleared=="2"){iscleared='1';}
	if(isacked=="2")
	{
		isack='';
	}
	else{
		isack=isacked;
	}
	
	var alarmlevel:String=level;
	var alarmdesc:String = alarmDesc.text+'';
	var alarmObj:String=alarmObj.text+'';
	var isack:String=isack;
	var isrootalarm:String=isrootalarm;
	var beginTime:String = starttime.text+'';
	var endTime:String=endtime.text+'';
	var belongequip:String=belongequip;
	//新加的
	var belongshelfcode:String=belongshelfcode;
	var isCleared:String="";
	var belongpackobject:String=belongpackobject;
	var belongportobject:String=belongportobject;
	var belongportcode:String=belongportcode;
	var ackperson:String=ackperson;
	var dealPerson:String=dealperson;
	rtobj.getcount(dealPerson,isack,alarmlevel,alarmdesc,alarmObj,ackperson,belongportcode,belongportobject,belongpackobject,isCleared,
		belongshelfcode,belongequip,vendor,beginTime,endTime,isrootalarm,table,belongtransys,curUser,queryFlag,"");
	rtobj.addEventListener(ResultEvent.RESULT,getLevelCount);
}  
public function getLevelCount(event:ResultEvent):void{
	if(event.result==null){
		Alert.show('获取数据失败',"提示信息",4,this,null,iconClass);
	}
	
	majorcount=String(event.result.major);
	criticalcount=String(event.result.critical);
	minorcount=String(event.result.minor);
	warningcount=String(event.result.warning);
	sum=String(event.result.major+event.result.critical+event.result.minor+event.result.warning);
}	


//根据不同的告警级别获取告警信息
private function getAlarmsByAlarmLevel(levelstr:String):void
{  //告警记录为0的清空记录
	var alarmindex:int=0;
	if(levelstr=="warning"){
		if(talarmlevel.selectedIndex>0){
			alarmindex=4;
		}
		if(warningcount=="0"){
			param.removeAll();
			dg.dataProvider = param;
			pagingToolBarforAlarmExp.orgData =param;
			pagingToolBarforAlarmExp.totalRecord = 0;	
			pagingToolBarforAlarmExp.dataBind(true);
			return;
		}
		
	}else if(levelstr=="minor"){
		if(talarmlevel.selectedIndex>0){
			alarmindex=3;
		}
		if(minorcount=="0"){
			param.removeAll();
			dg.dataProvider = param;
			pagingToolBarforAlarmExp.orgData =param;
			pagingToolBarforAlarmExp.totalRecord = 0;	
			pagingToolBarforAlarmExp.dataBind(true);						
			return;
		}					
	}else if(levelstr=="major"){
		if(talarmlevel.selectedIndex>0){
			alarmindex=2;
		}
		if(majorcount=="0"){
			param.removeAll();
			dg.dataProvider = param;
			pagingToolBarforAlarmExp.orgData =param;
			pagingToolBarforAlarmExp.totalRecord = 0;	
			pagingToolBarforAlarmExp.dataBind(true);						
			return;
		}					
	}else if(levelstr=="critical"){
		if(talarmlevel.selectedIndex>0){
			alarmindex=1;
		}
		if(criticalcount=="0"){
			param.removeAll();
			dg.dataProvider = param;
			pagingToolBarforAlarmExp.orgData =param;
			pagingToolBarforAlarmExp.totalRecord = 0;	
			pagingToolBarforAlarmExp.dataBind(true);						
			return;
		}					
	}else if(levelstr =="总计"){
		alarmindex=talarmlevel.selectedIndex;
	}
	talarmlevel.selectedIndex=alarmindex;
	alarmType="";
	belongtransys="";
	
	alarmlevelxzx=levelstr;
	
	alarmFlag = true;//表示不同颜色告警
	mainFlag=false;
	getSelectAlarms('1',levelstr);
}


//获取指定查询条件的告警信息
public function getWebSelectAlarms(curAlarm:String):void{
	alarmFlag = false;
	param.removeAll();
	mainFlag=false;
	ackperson="";
	dealperson="";
	queryFlag=curAlarm;
	searchNum("");
	pagingToolBarforAlarmExp.navigateButtonClick("firstPage");
	contextMeau.customItems=[];
}

public function getSelectAlarms(curAlarm:String,levelstr:String):void{
	alarmFlag = false;
	param.removeAll();
	mainFlag=false;
	levelflag=curAlarm;
	ackperson="";
	dealperson="";
	
	if(curAlarm!="1"||levelstr=="总计"){
		searchNum(curAlarm);
	}
	pagingToolBarforAlarmExp.navigateButtonClick("firstPage");
	contextMeau.customItems=[];
}
private function searchNum(curAlarm:String):void{
	var rtobj :RemoteObject= new RemoteObject("AlarmManagerComboboxDwr");
	rtobj.endpoint = ModelLocator.END_POINT;
	rtobj.showBusyCursor = true;
	var alarmmangermodel1:AlarmMangerModel =new AlarmMangerModel();
	alarmmangermodel1=alarmmangermodel;
	alarmmangermodel1.alarmdesc=alarmDesc.text;
	alarmmangermodel1.alarmObj=alarmObj.text;
	alarmmangermodel1.vendor=(transdev.selectedIndex==0?"":transdev.selectedItem.code+"");
	alarmmangermodel1.belongtransys=(transys.selectedIndex==0?"":transys.selectedItem.code+"");
	if(curAlarm=="1"){
		alarmmangermodel1.alarmlevel=alarmlevelxzx;
	}else{
		alarmmangermodel1.alarmlevel=(talarmlevel.selectedIndex==0?"":talarmlevel.selectedItem.code+"");
	}
	alarmmangermodel1.alarmType=(talarmType.selectedIndex==0?"":talarmType.selectedItem.alarmtype+'');
	alarmmangermodel1.isAck=(isAck.selectedIndex==0?"":isAck.selectedItem.ack+'');
	
	//发生时间
	alarmmangermodel1.start_time=starttime.text+"";
	alarmmangermodel1.end_time = endtime.text+"";
	alarmmangermodel1.belongstation=belongstation.text+"";//局站
	alarmmangermodel1.area=area.text+"";//区域
	alarmmangermodel1.flashcount = flashcount.text+"";
	alarmmangermodel1.confirmTime=confirmTime.text+"";
	alarmmangermodel1.ackperson=ackperson1.text+"";
	alarmmangermodel1.isworkcase=isworkcase.text+"";
	alarmmangermodel1.tablename = table;
	alarmmangermodel1.alarmman = "";
	alarmmangermodel1.queryFlag=queryFlag
	rtobj.getcountBySearch(alarmmangermodel1);
	rtobj.addEventListener(ResultEvent.RESULT,getLevelCount);
}

private function reset():void{
	
	alarmDesc.text="";
	alarmObj.text="";
	transdev.selectedIndex=0;
	transys.selectedIndex=0;
	talarmlevel.selectedIndex=0;
	talarmType.selectedIndex=0;
	isAck.selectedIndex=0;
	flashcount.text="";
	starttime.text="";
	endtime.text="";
	level="";
	vendor="";
	isack="";
	belongstation.text="";
	area.text="";
	confirmTime.text="";
	ackperson1.text="";
	isworkcase.text="";
}


protected function dg_clickHandler(event:MouseEvent):void
{
	// 右键告警处理 by hjl
	if(dg.selectedItem!=null && dg.selectedItem != ""){
		contextMeau.hideBuiltInItems();
		popupmenu_alarmdeal.parent=this;
		popupmenu_alarmdeal.alarm=dg.selectedItem;
		if(dg.selectedItems.length>1){
			popupmenu_alarmdeal.alarmList=dg.selectedItems;
		}else{
			popupmenu_alarmdeal.alarmList.splice(0);
		}
		popupmenu_alarmdeal.setItemStatus();
		contextMeau.customItems =popupmenu_alarmdeal.customItems;
		dg.contextMenu = contextMeau;
	}
	
}
protected function button1_clickHandler(event:MouseEvent):void
{
	var fefs:FileExportFirstStep = new FileExportFirstStep();
	var model:AlarmMangerModel = new AlarmMangerModel();
	fefs.exportTypes = "历史告警查询";
	fefs.titles = new Array("告警级别","发生时间","告警来源","科目名称","告警对象","告警名称","所属厂家","所属系统","所属局站","所属区域","频闪次数","告警原因","运维单位","恢复时间","确认时间","确认人");
	fefs.labels = "历史告警管理信息列表";
	if(dg.selectedItems.length > 1){
		var ac:ArrayCollection = new ArrayCollection();
		for(var i:int = 0;i<dg.selectedItems.length;i++){
			ac.addItem(dg.selectedItems[i]);
		} 
		fefs.dataNumber = dg.selectedItems.length;
		fefs.selectItem = ac;
		
	}else{
		model = alarmmangermodel;
		fefs.dataNumber = (dg.dataProvider as ArrayCollection).length;
	}
	if(fefs.dataNumber > 20000){
		fefs.dataNumber = 19999;
		fefs.model = model;
		Alert.show("导出数量超过20000条，如果继续只能导出前20000条。。",
			"提示",
			Alert.YES|Alert.NO,
			null,
			function():void{
				MyPopupManager.addPopUp(fefs, true);
			}
		);
	}else{
		model.queryFlag=queryFlag
		model.end=sum.toString();
		fefs.dataNumber=int(sum);
		fefs.model=model;
		MyPopupManager.addPopUp(fefs, true);
	}
}
protected function buttonCur_clickHandler(event:MouseEvent):void
{	
	var rtobj :RemoteObject= new RemoteObject("AlarmManagerComboboxDwr");
	rtobj.endpoint = ModelLocator.END_POINT;
	rtobj.showBusyCursor = true;
	rtobj.queryAlarmWebService("1");
	rtobj.addEventListener(ResultEvent.RESULT,getWebData);
	
}
public function getWebData(event:ResultEvent):void{
	var result:String = event.result.toString()
	getWebSelectAlarms('1');
}