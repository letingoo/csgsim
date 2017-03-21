// ActionScript file


import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.actionscript.Registry;
import common.other.events.CustomEvent;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.controls.Alert;
import mx.controls.RadioButtonGroup;
import mx.core.Application;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.formatters.DateFormatter;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;
import mx.utils.StringUtil;

import sourceCode.alarmmgr.views.AlarmManager;
import sourceCode.faultSimulation.model.StdMaintainProModel;
import sourceCode.faultSimulation.titles.TopoLinkSearchTitle;
import sourceCode.faultSimulation.titles.selectOperateTypeTitle;


public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");	

[Bindable] public var interposeData:Object;
public var maintainModel:StdMaintainProModel = new StdMaintainProModel();
 public var operatetypeid:String="";
public var equipcode:String="";
public var mainApp:Object = null;
[Bindable]   
public var eventList:String="";
public var myCallBack:Function;//定义的方法变量

[Bindable]
public var isShow:Boolean=false;
public var atopoid:String;
public var atoponame:String;
public var ztopoid:String;
public var ztoponame:String;
public var survey:RadioButtonGroup=new RadioButtonGroup();
public var portFlag:String;

/**
 *添加或修改按钮的处理函数 
 * @param event
 * 
 */
protected function btn_clickHandler(event:MouseEvent):void
{    
		
	if((operatetype.text== null||operatetype.text=="")){
		Alert.show("请选择处理方法", "提示");
		return;
	}else{
		maintainModel.operatetype = operatetypeid;
		maintainModel.operatedes=operatetype.text;
	
	}
	maintainModel.a_equipcode = equipcode;
	maintainModel.remark = remark.text;
	maintainModel.updateperson = Application.application.curUser;
	maintainModel.updatetime = this.getNowTime();
	var str:String =operatetype.text;
	var flag:Boolean = false;
	if(str.indexOf("自环")!=-1){
		flag=true;
	}
	if(vs.selectedIndex==0&&(flag||operatetype.text=="环回(内环)"||operatetype.text=="环回(外环)")){
		vs.selectedIndex=1;
	}else{

		//保存，并给出操作回应
		var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		remoteObject.addEventListener(ResultEvent.RESULT,saveUserOperateResultHandler);
		Application.application.faultEventHandler(remoteObject);
		remoteObject.saveUserOperate(maintainModel,eventList);
	}
	
}

private function saveUserOperateResultHandler(event:ResultEvent):void{

	//给出提示信息
	var resultTitle:String="";
	if(event.result!=null){
		var result:Array=event.result.toString().split("==");
		if(result.length>1){
			if(result[1]=="SUCCESS"){
		
				Alert.show(result[0]+",告警清除。","提示");
				this.dispatchEvent(new Event("RefreshDataGrid"));
			}else{
				Alert.show(result[0],"提示");
			}
			isShow=true;
			if(steps.text==""){
				steps.text=operatetype.text;
			}else{
				steps.text=steps.text+"；"+operatetype.text;
			}
			operatetype.text="";
			remark.text = "";
			if(result[1]=="SUCCESS"){
				closeWindow();
			    subMessage.stopSendMessage("stop");
				subMessage.startSendMessage(Application.application.curUser);
//				var alarm:AlarmManager=new  AlarmManager();
//				alarm.init();
			}
			resultTitle=result[0]+(result[2]!=null?","+result[2]:"");
		}else{
			resultTitle=event.result.toString();
		}
		
		if(vs.selectedIndex==1){
			txtresult.text=resultTitle;
		}
	}
	
//	PopUpManager.removePopUp(this);
}

private function fontColor():void
	
{
	steps.setStyle('color','red');
	steps.setStyle("fontSize","14"); 

}



//窗口关闭函数
private function closeWindow():void{
	MyPopupManager.removePopUp(this);
	//myCallBack.call(mainApp);//回调  //liqinming
}

private function closeButton():void{
	PopUpManager.removePopUp(this);
	myCallBack.call(mainApp);//回调
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
	var str:String =operatetype.text;
	var flag:Boolean = false;
	if(str.indexOf("自环")!=-1){
		flag=true;
	}
	if(flag||operatetype.text=="环回(内环)"||operatetype.text=="环回(外环)"){//如果选择环回 则跳转至环回操作页面
		vs.selectedIndex=1;
		hh_cl.styleName="myStyleClass";
		if(flag||obj.name=="环回(内环)"){
			if(hh1!=null){
				hh1.selected=true;
			}
			displayAnswer("环回(内环)");
		}else{
			if(hh2!=null){
				hh2.selected=true;
			}
			displayAnswer("环回(外环)");
		}
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
protected function subMessage_resultHandler(event:ResultEvent):void  
{} 
protected function displayAnswer(radioValue:String){
	operatetype.text=radioValue;
	if(txtaendptp!=null)txtaendptp.text="";//初始化复用段
	if(txtzendptp!=null)txtzendptp.text="";//初始化复用段
	var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
	remoteObject.endpoint = ModelLocator.END_POINT;
	remoteObject.showBusyCursor = true;
	remoteObject.addEventListener(ResultEvent.RESULT,selectRadioOperateResultHandler);
	Application.application.faultEventHandler(remoteObject);
	remoteObject.getOperateTypeByeqsearch(radioValue);
}
private function selectRadioOperateResultHandler(event:ResultEvent):void{
	var eqsearch:XMLList= new XMLList(event.result);
	if(eqsearch!=null&&eqsearch[0]!=null){
		operatetypeid=eqsearch[0].@id;
	}
	
}
public function portClickHanlder(event:MouseEvent,flag:String):void{
	portFlag=flag;
	var topolinksearch:TopoLinkSearchTitle=new TopoLinkSearchTitle();
	topolinksearch.page_parent=this;
	topolinksearch.equipcode=this.equipcode;
	topolinksearch.flag=portFlag;
	PopUpManager.addPopUp(topolinksearch,this,true);
	PopUpManager.centerPopUp(topolinksearch);
	topolinksearch.myCallBack=this.callBackForTopo;
}
public function callBackForTopo(obj:Object):void{ 
	if(portFlag!=null&&portFlag=="aptp"){
		txtaendptp.text = obj.name; 
		atopoid=obj.id;
		atoponame=obj.name;
	}else if(portFlag!=null&&portFlag=="zptp"){
		txtzendptp.text = obj.name; 
		ztopoid=obj.id;
		ztoponame=obj.name;
	}
	
}
protected function btn_hh_clickHandler(event:MouseEvent):void
{
//	Alert.show(survey.selectedValue.toString());
	if(survey.selectedValue==null||survey.selectedValue.toString()==null||survey.selectedValue.toString()==""||txtaendptp==null||txtaendptp.text==null||txtzendptp==null||txtzendptp.text==null){
		Alert.show("请选择环回方法和复用段", "提示");
		return;
	}else{
		operatetype.text= survey.selectedValue.toString();
		maintainModel.operatetype = operatetypeid;//操作id
		maintainModel.operatedes=survey.selectedValue.toString();//操作名称
	}
	maintainModel.a_equipcode = equipcode;
	maintainModel.remark = remark.text;
	maintainModel.updateperson = Application.application.curUser;
	maintainModel.updatetime = this.getNowTime();
	var str:String =operatetype.text;
	var flag:Boolean = false;
	if(str.indexOf("自环")!=-1){
		flag=true;
	}
	if(vs.selectedIndex==0&&(flag||operatetype.text=="环回(内环)"||operatetype.text=="环回(外环)")){
		vs.selectedIndex=1;
	}else{
		//保存，并给出操作回应
		var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		remoteObject.addEventListener(ResultEvent.RESULT,saveUserOperateResultHandler);
		Application.application.faultEventHandler(remoteObject);
		remoteObject.saveUserOperate(maintainModel,eventList);
	}
	
}