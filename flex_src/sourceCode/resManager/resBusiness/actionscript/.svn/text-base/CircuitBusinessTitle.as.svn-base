// ActionScript file

import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.other.events.CustomEvent;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TextEvent;

import mx.controls.Alert;
import mx.controls.TextInput;
import mx.core.IFlexDisplayObject;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import sourceCode.autoGrid.view.TreeWindow;
import sourceCode.resManager.resBusiness.events.CircuitBusinessSearchEvent;
import sourceCode.resManager.resBusiness.model.CircuitBusinessModel;
import sourceCode.resManager.resBusiness.titles.SearchBusinessByIdTitle;
import sourceCode.resManager.resBusiness.titles.SearchBusinessByNameTitle;
import sourceCode.resManager.resBusiness.titles.SearchCircuitByIdTitle;
import sourceCode.resManager.resBusiness.titles.SearchCircuitTitle;


[Event(name="CircuitBusinessSearchEvent",type="sourceCode.resManager.resBusiness.events.CircuitBusinessSearchEvent")]
public var days:Array=new Array("日", "一", "二", "三", "四", "五", "六");
public var monthNames:Array=new Array("一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月");

public var business_id_bak:String="";
public var circuitcode_bak:String="";
[Bindable]public var showBusinessID:Boolean=false;
[Bindable]public var showCicuitcode:Boolean=false;

/**
 *点击按钮后的处理函数
 * @param event
 * 
 */
protected function btn_clickHandler(event:MouseEvent):void
{
	var isCompletedRequired:String = "false";
	var obj:RemoteObject = new RemoteObject("resBusinessDwr");
	obj.endpoint = ModelLocator.END_POINT;
	obj.showBusyCursor = true;
	var cbm:CircuitBusinessModel = new CircuitBusinessModel();
	if(this.currentState == 'search'){
		cbm.business_id = business_id.text;
		cbm.circuitcode = circuitcode.text;
		cbm.business_name = business_name.text;
		cbm.username = username.text;
		cbm.updateperson = updateperson.text;
	}else if(this.currentState == 'add'){
		cbm.business_id = business_id.text;
		cbm.circuitcode = circuitcode.text;
		cbm.business_name = business_name.text;
		cbm.username = username.text;
		cbm.updateperson = updateperson.text;
	}else {
		cbm.business_id = business_id.text;
		cbm.circuitcode = circuitcode.text;
		cbm.business_name = business_name.text;
		cbm.username = username.text;
		cbm.updateperson = updateperson.text;
	}
	if(this.title=='添加'){
		if(business_id.text==""||circuitcode.text==""||business_name.text==""
			||username.text==""||updateperson.text==""){
			Alert.show("必填项不能为空，请填写完整！","提示");
		}else{
			isCompletedRequired = "true";
			obj.addCircuitBusiness(cbm);
			obj.addEventListener(ResultEvent.RESULT,addHandle);
		}
	}else if(this.title=='查询'){
		isCompletedRequired = "true";
		this.dispatchEvent(new CircuitBusinessSearchEvent("CircuitBusinessSearchEvent",cbm));
		
	}else if(this.title=='修改'){
		if(business_id.text==""||circuitcode.text==""){
			Alert.show("必填项不能为空，请填写完整！","提示");
		}else{
			isCompletedRequired = "true";
			cbm.business_id_bak = business_id_bak;
			cbm.circuitcode_bak = circuitcode_bak;
			obj.modifyCircuitBusiness(cbm);
			obj.addEventListener(ResultEvent.RESULT,updateHandler);
		}
	}
	
	//假如必填数据填写完整并且提交了请求，关闭当前页面。
	if(isCompletedRequired == "true") {
		PopUpManager.removePopUp(this);
		
	}
}

/**
 * 更新结果处理函数 
 * @param e
 * 
 */
private function updateHandler(e:ResultEvent):void{
	if(e.result!=null){
		if(e.result.toString()=="success")
		{
			Alert.show("更新成功!","提示");
			this.dispatchEvent(new Event("RefreshDataGrid"))
		}else
		{
			Alert.show("请按要求填写数据！","提示");
		}
	}
}

/**
 * 添加结果处理函数 
 * @param e
 * 
 */
private function addHandle(e:ResultEvent):void{
	if(e.result!=null){
		if(e.result.toString()=="success")
		{
			Alert.show("添加成功!","提示");
			this.dispatchEvent(new Event("RefreshDataGrid"))
		}else
		{
			Alert.show("存在相同数据，不能再添加！","提示");
		}
	}
	
}
/**
 * 选中业务ID后自动填充业务名称 
 * @param event
 * 
 */
protected function business_id_clickHandler(event:MouseEvent):void
{
	var businessSearch:SearchBusinessByIdTitle=new SearchBusinessByIdTitle();
	businessSearch.page_parent=this;
	PopUpManager.addPopUp(businessSearch,this,true);
	PopUpManager.centerPopUp(businessSearch);
	businessSearch.myCallBack=function(obj:Object){
		var name:String=obj.label;//从SearchBusinessTitle传过来的业务的名称
		var id:String = obj.code;//从SearchBusinessTitle传过来的业务的ID
		business_id.text=id;
		business_name.text=name;
	}
}

/**
 * 选中业务名称自动填充业务ID 
 * @param event
 * 
 */
protected function business_name_clickHandler(event:MouseEvent):void
{
	var businessSearch:SearchBusinessByNameTitle=new SearchBusinessByNameTitle();
	businessSearch.page_parent=this;
	PopUpManager.addPopUp(businessSearch,this,true);
	PopUpManager.centerPopUp(businessSearch);
	businessSearch.myCallBack=function(obj:Object){
		var name:String=obj.label;//从SearchBusinessTitle传过来的业务的名称
		var id:String = obj.code;//从SearchBusinessTitle传过来的业务的ID
		business_id.text=id;
		business_name.text=name;
	}
}

/**
 * 选中电路ID自动填充电路名称 
 * @param event
 * 
 */
protected function circuitcode_clickHandler(event:MouseEvent):void
{
//	var circuitsearch:SearchCircuitByIdTitle=new SearchCircuitByIdTitle();
//	circuitsearch.circuitcode=circuitcode.text;
//	circuitsearch.page_parent=this;
//	PopUpManager.addPopUp(circuitsearch,this,true);
//	PopUpManager.centerPopUp(circuitsearch);
//	circuitsearch.myCallBack=function(obj:Object){
//		var clabel:String=obj.label;//从SearchCircuitTitle传过来的电路的名称
//		var ccode:String = obj.code;//从SearchCircuitTitle传过来的电路的id
//		username.text=clabel;
//		circuitcode.text=ccode;
//	}
}

/**
 * 选中业务名称自动填充业务ID 
 * @param event
 * 
 */
protected function circuit_name_clickHandler(event:MouseEvent):void
{
	var circuitsearch:SearchCircuitTitle=new SearchCircuitTitle();
	circuitsearch.circuitcode=circuitcode.text;
	circuitsearch.page_parent=this;
	PopUpManager.addPopUp(circuitsearch,this,true);
	PopUpManager.centerPopUp(circuitsearch);
	circuitsearch.myCallBack=function(obj:Object){
		var name:String=obj.name;
		var id:String=obj.id;
//		if(name.length>0){
//			name=name.substr(0,name.length-1);
//		}
//		if(id.length>0){
//			id=id.substr(0,id.length-1);
//		}
//		if(this.title=="查询"){
			username.text=name;
			circuitcode.text = id;
//		}
//		else{
//			if(username.text==""){
//				username.text = name;
//				circuitcode.text = id;
//			}else{
//				username.text=name;//StringUtil.trim(user_name.text)+","+obj.name;
//				circuitcode.text = id;//StringUtil.trim(user_id.text)+","+ obj.id;
//			}
//		}
		
	}
}


protected function initApp():void
{
	if(this.currentState == 'search') {
		updateperson.enabled = "true";
	} else {
		updateperson.text = parentApplication.curUserName;
		username.toolTip = username.text.toString();
	}
}
