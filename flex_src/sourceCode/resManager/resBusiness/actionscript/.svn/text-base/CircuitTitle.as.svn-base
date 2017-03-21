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
[Event(name="circuitSearchEvent",type="sourceCode.resManager.resBusiness.events.CircuitEvent")]
import sourceCode.autoGrid.view.TreeWindow;
import sourceCode.resManager.resBusiness.events.CircuitEvent;
import sourceCode.resManager.resBusiness.model.Circuit;
import sourceCode.resManager.resBusiness.views.porttreeForPortcode;
import sourceCode.resManager.resNode.views.enStationTree;
import sourceCode.resManager.resBusiness.titles.enSlotTree;

public var days:Array=new Array("日", "一", "二", "三", "四", "五", "六");
public var monthNames:Array=new Array("一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月");
[Bindable]
public var showcircuit:Boolean=true;
public var ct:Circuit = new Circuit();
public var obj:RemoteObject = new RemoteObject("resBusinessDwr");


/**
 *点击按钮后的处理函数
 * @param event
 * 
 */
protected function btn_clickHandler(event:MouseEvent):void
{
	obj.endpoint = ModelLocator.END_POINT;
	obj.showBusyCursor = true;
	if(this.currentState == 'search'){
		ct.circuitcode = circuitcode.text;
		ct.station1 = station1.text;
		ct.x_purpose = x_purpose.text;
		ct.portname1 = portname1.text;
//			ct.slot1 = slot1.text;
		
		ct.usetime = usetime.text;
		ct.username = username.text;
		ct.station2 = station2.text;
		ct.rate = rate.text;
		ct.portname2 = portname2.text;
//			ct.slot2 = slot2.text;
		ct.path=path.text;
		ct.remark=remark.text;
		ct.delay1=delay1.text;
		ct.delay2=delay2.text;
	}else if(this.currentState == 'add'){
		//首先需要判断速度，2M判断端口，155M选择时隙判断
		//需要判断所选的端口上是否有电路存在，有的话就不让填。
		
		ct.schedulerid = schedulerid.text;
		ct.station1 = station1.text;
		ct.x_purpose = x_purpose.text;
		ct.usetime = usetime.text;
		ct.username = username.text;
		ct.station2 = station2.text;
		ct.rate = rate.text;
		ct.path=path.text;
		ct.remark=remark.text;
		ct.delay1=delay1.text;
		ct.delay2=delay2.text;
		ct.portcode1 = (portcode1.data).toString();
		if(slot1.text==null||slot1.text==""){
			Alert.show("请选择A端时隙", "提示");
			return;
		}else{
			ct.slot1 = slot1.text;
		}
		ct.portcode2 = (portcode2.data).toString();
		if(slot2.text==null||slot2.text==""){
			Alert.show("请选择Z端时隙", "提示");
			return;
		}else{
			ct.slot2 = slot2.text;
		}
	}else {
		ct.circuitcode = circuitcode.text;
		ct.station1 = station1.text;
		ct.x_purpose = x_purpose.text;
		ct.slot1 = slot1.text;
		
		ct.usetime = usetime.text;
		ct.username = username.text;
		ct.station2 = station2.text;
		ct.rate = rate.text;
		ct.slot2 = slot2.text;
		ct.path=path.text;
		ct.remark=remark.text;
		ct.delay1=delay1.text;
		ct.delay2=delay2.text;
		
		//新增端口属性
		if(portcode1.data!=null&&portcode1.data!=''){
			ct.portcode1 = (portcode1.data).toString();
		}else{
			ct.portcode1 = portcode1.text;
		}
		if(portcode2.data!=null&&portcode2.data!=''){
			ct.portcode2 = (portcode2.data).toString();
		}else{
			ct.portcode2 = portcode2.text;
		}
	}
	if(this.title=='添加'){
		if(schedulerid.text==""||station1.text==""
			||slot1.text==""||username.text==""||station2.text==""||rate.text==""
			||slot2.text==""||portcode1.text==""||portcode1.text==""){
			Alert.show("必填项不能为空，请填写完整！","提示");
			return;
		}else{
			//判断端口时隙上面是否有电路\A、Z端都要判断
			checkPortAndSlotHasCircuitA(ct.rate,ct.portcode1,ct.slot1);
			
		}
	}else if(this.title=='查询'){
		ct.portname1=portcode1.text;
		ct.portname2 = portcode2.text;
		this.dispatchEvent(new CircuitEvent("circuitSearchEvent",ct));
		PopUpManager.removePopUp(this);
	}else if(this.title=='修改'){
		if(circuitcode.text==""){
			Alert.show("必填项不能为空，请填写完整！","提示");
			return;
		}else{
			checkPortAndSlotHasCircuitA(ct.rate,ct.portcode1,ct.slot1);
//			obj.modifyCircuit(ct);
//			obj.addEventListener(ResultEvent.RESULT,updateHandler);
		}
		
	}
	
}


private function checkPortAndSlotHasCircuitA(rate:String,portcode:String,slot:String):void{
	var obj:RemoteObject = new RemoteObject("resBusinessDwr");
	obj.addEventListener(ResultEvent.RESULT,checkPortAndSlotHasCircuitAHandler);
	obj.endpoint = ModelLocator.END_POINT;
	obj.showBusyCursor = true;
	obj.checkPortAndSlotHasCircuit(rate,portcode,slot,"A",ct.circuitcode);
}

private function checkPortAndSlotHasCircuitAHandler(event:ResultEvent):void{
	var str:String = event.result.toString();
	if("SUCCESS"==str.split(";")[0]){
		if("2M"==str.split(";")[1]){
			Alert.show("所选的端口上已有电路！","提示");
			portname1.text="";
			portcode1.text="";
			slot1.text = "";
			return;
		}else{
			Alert.show("所选的端口时隙上已有电路！","提示");
//			portname1.text="";
//			portcode1.text="";
			slot1.text = "";
			return;
		}
	}else{
		//判断Z端
		checkPortAndSlotHasCircuitZ(ct.rate,ct.portcode2,ct.slot2);
	}
}

private function checkPortAndSlotHasCircuitZ(rate:String,portcode:String,slot:String):void{
	var obj:RemoteObject = new RemoteObject("resBusinessDwr");
	obj.addEventListener(ResultEvent.RESULT,checkPortAndSlotHasCircuitZHandler);
	obj.endpoint = ModelLocator.END_POINT;
	obj.showBusyCursor = true;
	obj.checkPortAndSlotHasCircuit(rate,portcode,slot,"Z",ct.circuitcode);
}

private function checkPortAndSlotHasCircuitZHandler(event:ResultEvent):void{
	var str:String = event.result.toString();
	if("SUCCESS"==str.split(";")[0]){
		if("2M"==str.split(";")[1]){
			Alert.show("所选的端口上已有电路！","提示");
			portname2.text="";
			portcode2.text="";
			slot2.text = "";
			return;
		}else{
			Alert.show("所选的端口时隙上已有电路！","提示");
//			portname2.text="";
//			portcode2.text="";
			slot2.text = "";
		}
	}else{
		//
		if(this.title=='修改'){
			obj.modifyCircuit(ct);
			obj.addEventListener(ResultEvent.RESULT,updateHandler);
		}else{
			obj.addCircuit(ct);
			obj.addEventListener(ResultEvent.RESULT,addHandle);
		}
		
		PopUpManager.removePopUp(this);
	}
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
	//先判断A端端口是否选择
	if(flag=='Z'&&this.title!="查询"){
		var portA:String = portname1.text;
		if(portA==null||portA==''){
			Alert.show("请先选择A端端口！","提示");
			return;
		}
	}
	
	var treeport:porttreeForPortcode = new porttreeForPortcode();
	treeport.circuitTitle = this;
	treeport.ptitle = this.title;
	treeport.port = port;
	treeport.flag = flag;
//	treeport.rate=rate.text;
	MyPopupManager.addPopUp(treeport, true);
}
private function openTreeWindow(treeWin:IFlexDisplayObject):void{
	
	PopUpManager.addPopUp(treeWin, this, true);
	PopUpManager.centerPopUp(treeWin);
}


/**
 * 获取业务类型列表
 * */
private function getX_purposeList(){
	var obj:RemoteObject = new RemoteObject("resBusinessDwr");
	obj.addEventListener(ResultEvent.RESULT,resultX_purposeHandler);
	obj.endpoint = ModelLocator.END_POINT;
	obj.showBusyCursor = true;
	obj.getX_purposeList(); 
}

/**
 * 获取速率列表
 * */
private function getRateList(){
	var obj:RemoteObject = new RemoteObject("resBusinessDwr");
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
		rate.text="";
		rate.selectedIndex=-1;
		rate.text = rate0.text;
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
		x_purpose.text="";
		x_purpose.selectedIndex=-1;
		x_purpose.text = x_purpose1.text;
	}else{
		var x_purposeList:XMLList= new XMLList(event.result);
		x_purpose.dropdown.dataProvider=x_purposeList;
		x_purpose.dataProvider=x_purposeList;
		x_purpose.labelField="@label";
		x_purpose.text="";
		x_purpose.selectedIndex=-1;
	}
	
}


//获取端口时隙
protected function slot1_clickHandler(event:MouseEvent):void
{
	//修改的时候是端口编码
	if(portcode1.text==null||portcode1.text==""){
		Alert.show("请先选择端口","提示");
		return;
	}
	var portcodea:String = portcode1.text;
	var slot:enSlotTree=new enSlotTree();
	slot.page_parent=this;
	slot.s_sbmc = this.title;
	slot.textId = "slot1";
	slot.equiplogicport=portcodea;//传端口编号
	PopUpManager.addPopUp(slot, this, true);
	PopUpManager.centerPopUp(slot); 
}

protected function slot2_clickHandler(event:MouseEvent):void
{
	if(portcode2.text==null||portcode2.text==""){
		Alert.show("请先选择端口","提示");
		return;
	}
	var portcodez:String = portcode2.text;
	var slot:enSlotTree=new enSlotTree();
	slot.page_parent=this;
	slot.textId = "slot2";
	slot.equiplogicport=portcodez;//传端口编号
	PopUpManager.addPopUp(slot, this, true);
	PopUpManager.centerPopUp(slot); 
}

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
		this.formItem16.visible = false;
		this.formItem17.visible = false;
	}
	if(this.currentState=='add'){
		//添加状态下，方式单编号可见，电路编号、资源A端口，资源Z端口不可见。
		this.formItem1.visible = true;
		this.formItem11.visible = false;
		this.formItem11.includeInLayout = false;
		this.formItem16.visible = false;
//		this.formItem12.includeInLayout = false;
		this.formItem17.visible = false;
//		this.formItem13.includeInLayout = false;
		this.formItem14.visible = false;
		this.formItem15.visible = false;
	}
	
	if(this.currentState=='modify'){
		//修改状态下，电路编号可见，方式单编号编号、资源A端口，资源Z端口,端口编号1,端口编号2不可见。
		this.formItem1.visible = false;
		this.formItem1.includeInLayout = false;
		this.formItem11.visible = true;
		this.formItem16.visible = false;
//		this.formItem12.includeInLayout = false;
		this.formItem17.visible = false;
//		this.formItem13.includeInLayout = false;
		this.formItem14.visible = false;
		this.formItem14.includeInLayout = false;
		this.formItem15.visible = false;
		this.formItem15.includeInLayout = false;
	}
	
	this.getX_purposeList();
	this.getRateList();
}
protected function station1_clickHandler(event:MouseEvent):void
{
	var stations:enStationTree=new enStationTree();
	stations.page_parent=this;
	stations.textId="station1";
	PopUpManager.addPopUp(stations, this, true);
	PopUpManager.centerPopUp(stations);  
}

protected function station2_clickHandler(event:MouseEvent):void
{
	var stations:enStationTree=new enStationTree();
	stations.page_parent=this;
	stations.textId="station2";
	PopUpManager.addPopUp(stations, this, true);
	PopUpManager.centerPopUp(stations);  
}