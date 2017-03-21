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
[Event(name="circuitSearchEvent",type="sourceCode.tableResurces.Events.CircuitEvent")]
import sourceCode.autoGrid.view.TreeWindow;
import sourceCode.tableResurces.Events.CircuitEvent;
import sourceCode.tableResurces.model.Circuit;
import sourceCode.tableResurces.views.porttreeForPortcode;
import sourceCode.resManager.resNode.views.enStationTree;

public var days:Array=new Array("日", "一", "二", "三", "四", "五", "六");
public var monthNames:Array=new Array("一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月");

public var circuitcode_bak:String="";

/**
 *点击按钮后的处理函数
 * @param event
 * 
 */
protected function btn_clickHandler(event:MouseEvent):void
{
	var obj:RemoteObject = new RemoteObject("channelRouteForm");
	obj.endpoint = ModelLocator.END_POINT;
	obj.showBusyCursor = true;
	var ct:Circuit = new Circuit();
	if(this.currentState == 'search'){
		ct.circuitcode = circuitcode.text;
		ct.station1 = station1.text;
		ct.x_purpose = x_purpose.text;
		ct.portserialno1 = portserialno1.text;
		ct.portname1 = portname1.text;
		ct.slot1 = slot1.text;
		ct.usetime = usetime.text;
		ct.username = username.text;
		ct.station2 = station2.text;
		ct.rate = rate.text;
		ct.portserialno2 = portserialno2.text;
		ct.portname2 = portname2.text;
		ct.slot2 = slot2.text;
	}else if(this.currentState == 'add'){
		ct.schedulerid = schedulerid.text;
		ct.station1 = station1.text;
		ct.x_purpose = x_purpose.text;
		ct.portserialno1 = portserialno1.text;
		ct.slot1 = slot1.text;
		ct.usetime = usetime.text;
		ct.username = username.text;
		ct.station2 = station2.text;
		ct.rate = rate.text;
		ct.portserialno2 = portserialno2.text;
		ct.slot2 = slot2.text;
		ct.portcode1 = (portcode1.data).toString();
		ct.portcode2 = (portcode2.data).toString();
	}else {
		ct.circuitcode = circuitcode.text;
		ct.station1 = station1.text;
		ct.x_purpose = x_purpose.text;
		ct.portserialno1 = portserialno1.text;
		ct.slot1 = slot1.text;
		ct.usetime = usetime.text;
		ct.username = username.text;
		ct.station2 = station2.text;
		ct.rate = rate.text;
		ct.portserialno2 = portserialno2.text;
		ct.slot2 = slot2.text;
	}
	if(this.title=='添加'){
		if(schedulerid.text==""||station1.text==""||portserialno1.text==""
			||slot1.text==""||username.text==""||station2.text==""||rate.text==""
			||portserialno2.text==""||slot2.text==""||portcode1.text==""||portcode1.text==""){
			Alert.show("必填项不能为空，请填写完整！","提示");
		}else{
			obj.addCircuit(ct);
			obj.addEventListener(ResultEvent.RESULT,addHandle);
		}
	}else if(this.title=='查询'){
		this.dispatchEvent(new CircuitEvent("circuitSearchEvent",ct));
		
	}else if(this.title=='修改'){
		if(circuitcode.text==""){
			Alert.show("必填项不能为空，请填写完整！","提示");
		}else{
			ct.circuitcode_bak = circuitcode_bak;
			obj.modifyCircuit(ct);
			obj.addEventListener(ResultEvent.RESULT,updateHandler);
		}
	}
	PopUpManager.removePopUp(this);
}

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

private function addHandle(e:ResultEvent):void{
	if(e.result!=null){
		if(e.result.toString()=="success")
		{
			Alert.show("添加成功!","提示");
			this.dispatchEvent(new Event("RefreshDataGrid"))
		}else
		{
			Alert.show("请按要求填写数据！","提示");
		}
	}
	
}

protected function portcode_mouseDownHandler(event:MouseEvent,port:TextInput,flag:String):void
{
	var treeport:porttreeForPortcode = new porttreeForPortcode();
	treeport.circuitTitle = this;
	treeport.port = port;
	treeport.flag = flag;
	MyPopupManager.addPopUp(treeport, true);
}
private function openTreeWindow(treeWin:IFlexDisplayObject):void{
	
	PopUpManager.addPopUp(treeWin, this, true);
	PopUpManager.centerPopUp(treeWin);
}

/**
 * 获取站点列表
 * */
//private function getStation(){
//	var obj:RemoteObject = new RemoteObject("channelRouteForm");
//	obj.addEventListener(ResultEvent.RESULT,resultStationHandler);
//	obj.endpoint = ModelLocator.END_POINT;
//	obj.showBusyCursor = true;
//	obj.getStation(); 
//}


/**
 * 获取业务类型列表
 * */
private function getX_purposeList(){
	var obj:RemoteObject = new RemoteObject("channelRouteForm");
	obj.addEventListener(ResultEvent.RESULT,resultX_purposeHandler);
	obj.endpoint = ModelLocator.END_POINT;
	obj.showBusyCursor = true;
	obj.getX_purposeList(); 
}

/**
 * 获取速率列表
 * */
private function getRateList(){
	var obj:RemoteObject = new RemoteObject("channelRouteForm");
	obj.addEventListener(ResultEvent.RESULT,resultRateListHandler);
	obj.endpoint = ModelLocator.END_POINT;
	obj.showBusyCursor = true;
	obj.getRateList(); 
}

public function resultRateListHandler(event:ResultEvent):void{
	if(this.currentState=='modify'){
		var rateList:XMLList= new XMLList(event.result);
		rate.dropdown.dataProvider=rateList;
		rate.dataProvider=rateList;
		rate.labelField="@label";
	}else{
		var rateList:XMLList= new XMLList(event.result);
		rate.dropdown.dataProvider=rateList;
		rate.dataProvider=rateList;
		rate.labelField="@label";
		rate.text="";
		rate.selectedIndex=-1;
	}
	
}

public function resultX_purposeHandler(event:ResultEvent):void{
	if(this.currentState=='modify'){
		var x_purposeList:XMLList= new XMLList(event.result);
		x_purpose.dropdown.dataProvider=x_purposeList;
		x_purpose.dataProvider=x_purposeList;
		x_purpose.labelField="@label";
	}else{
		var x_purposeList:XMLList= new XMLList(event.result);
		x_purpose.dropdown.dataProvider=x_purposeList;
		x_purpose.dataProvider=x_purposeList;
		x_purpose.labelField="@label";
		x_purpose.text="";
		x_purpose.selectedIndex=-1;
	}
	
}

//public function resultStationHandler(event:ResultEvent):void{
//	if(this.currentState=='modify'){
//		var strStation:XMLList= new XMLList(event.result);
//		station1.dropdown.dataProvider=strStation;
//		station1.dataProvider=strStation;
//		station1.labelField="@label";
		
//		station2.dropdown.dataProvider=strStation;
//		station2.dataProvider=strStation;
//		station2.labelField="@label";
//	}else{
//		var strStation:XMLList= new XMLList(event.result);
//		station1.dropdown.dataProvider=strStation;
//		station1.dataProvider=strStation;
//		station1.labelField="@label";
//		station1.text="";
//		station1.selectedIndex=-1;
		
//		station2.dropdown.dataProvider=strStation;
//		station2.dataProvider=strStation;
//		station2.labelField="@label";
//		station2.text="";
//		station2.selectedIndex=-1;
//	}

//}

protected function initApp():void
{
	if(this.currentState=='search'){
		//查询状态下，方式单编号,端口编号1,端口编号2不可见，电路编号、资源A端口，资源Z端口可见。
		this.formItem1.visible = false;
		this.formItem1.includeInLayout = false;
		this.formItem14.visible = false;
		this.formItem14.includeInLayout = false;
		this.formItem15.visible = false;
		this.formItem15.includeInLayout = false;
		this.formItem11.visible = true;
		this.formItem12.visible = true;
		this.formItem13.visible = true;
	}
	if(this.currentState=='add'){
		//添加状态下，方式单编号可见，电路编号、资源A端口，资源Z端口不可见。
		this.formItem1.visible = true;
		this.formItem11.visible = false;
		this.formItem11.includeInLayout = false;
		this.formItem12.visible = false;
		this.formItem12.includeInLayout = false;
		this.formItem13.visible = false;
		this.formItem13.includeInLayout = false;
	}
	
	if(this.currentState=='modify'){
		//修改状态下，电路编号可见，方式单编号编号、资源A端口，资源Z端口,端口编号1,端口编号2不可见。
		this.formItem1.visible = false;
		this.formItem1.includeInLayout = false;
		this.formItem11.visible = true;
		this.formItem12.visible = false;
		this.formItem12.includeInLayout = false;
		this.formItem13.visible = false;
		this.formItem13.includeInLayout = false;
		this.formItem14.visible = false;
		this.formItem14.includeInLayout = false;
		this.formItem15.visible = false;
		this.formItem15.includeInLayout = false;
	}
	
//	this.getStation();
	this.getX_purposeList();
	this.getRateList();
}

protected function selectStation(event:MouseEvent):void{
	var stations:enStationTree=new enStationTree();
	stations.page_parent=this;
	stations.textId="station1";
	PopUpManager.addPopUp(stations, this, true);
	PopUpManager.centerPopUp(stations);
}
protected function selectStation2(event:MouseEvent):void{
	var stations:enStationTree=new enStationTree();
	stations.page_parent=this;
	stations.textId="station2";
	PopUpManager.addPopUp(stations, this, true);
	PopUpManager.centerPopUp(stations);
}