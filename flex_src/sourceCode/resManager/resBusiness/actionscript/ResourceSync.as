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
import org.bytearray.gif.player.GIFPlayer; 

public var days:Array=new Array("日", "一", "二", "三", "四", "五", "六");
public var monthNames:Array=new Array("一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月");
[Bindable]
public var showcircuit:Boolean=true;
[Bindable]
public var imgShow:Boolean=false;
//public var circuitcode_bak:String="";
public var ct:Circuit = new Circuit();
private var gifPlay:GIFPlayer=new GIFPlayer();   
private var gifPlay2:GIFPlayer=new GIFPlayer();  
public var obj:RemoteObject = new RemoteObject("resBusinessDwr");

private function init():void{
	hbox2.setVisible(false);
}
//同步全部资源函数
protected function controlBar_showResourceSyncHandler(event:Event):void
{
	hbox1.setVisible(false);
	hbox2.setVisible(true);
	label1.setVisible(false);
	obj.addEventListener(ResultEvent.RESULT,showResourceSyncResult);
	obj.endpoint = ModelLocator.END_POINT;
	obj.showBusyCursor = true;
	obj.resourceAllSync();//
	
}

//增量告警同步
protected function button_clickHandler(event:Event):void
{
	var str:String="";
	if(box_1.selected==true){
		str+="站点;";
	}
	if(box_2.selected==true){
		str+="光缆;";
	}
	if(box_3.selected==true){
		str+="复用段;";
	}
	if(box_4.selected==true){
		str+="光纤;";
	}
	if(box_5.selected==true){
		str+="设备;";
	}
	if(box_6.selected==true){
		str+="交叉;";
	}
	if(box_7.selected==true){
		str+="机框;";
	}
	if(box_8.selected==true){
		str+="机槽;";
	}
	if(box_9.selected==true){
		str+="电路;";
	}
	if(box_10.selected==true){
		str+="机盘;";
	}
	if(box_11.selected==true){
		str+="端口;";
	}
	if(box_12.selected==true){
		str+="业务;";
	}
	if(box_13.selected==true){
		str+="电路业务关系;";
	}
	if(str==""){
		Alert.show("请选择需要同步的资源","提示");
		return ;
	}
	var start:String = "";
	var end:String = "";
	if(dfstartUpdateDate.text==""){
		Alert.show("请选择开始时间","提示");
		return;
	}else{
		start=dfstartUpdateDate.text+" 00:00:00";
	}
	if(dfendUpdateDate.text==""){
		Alert.show("请选择结束时间","提示");
		return;
	}else{
		end = dfendUpdateDate.text+" 24:00:00";
	}
	str = str.substr(0,str.length-1);
	hbox1.setVisible(false);
	hbox2.setVisible(true);
	label1.setVisible(false);
	//调用后台
	obj.addEventListener(ResultEvent.RESULT,showResourceSyncResult);
	obj.endpoint = ModelLocator.END_POINT;
	obj.showBusyCursor = true;
	obj.resourceSync(str,start,end);
//	imgShow=true;
//	Alert.show("---");
	// TODO Auto-generated method stub
}

private function showResourceSyncResult(event:ResultEvent):void{
	if(event.result.toString()=="SUCCESS"){
		//
		hbox1.setVisible(true);
		hbox2.setVisible(false);
		label1.setVisible(true);
		Alert.show("资源同步完成","提示");
	}else{
		Alert.show("数据同步失败","提示");
	}
}
//加载动态图片
private function initImg():void{   
	
	var req:URLRequest=new URLRequest("assets/images/taskbar/black/processBar.gif");   
	
	gifPlay.load(req);   
	
	img.addChild(gifPlay);       
	
}  

//清空复选框按钮
protected function controlBar_showUnselectedHandler(event:Event):void
{
	box_1.selected=false;
	box_2.selected=false;
	box_3.selected=false;
	box_4.selected=false;
	box_5.selected=false;
	box_6.selected=false;
	box_7.selected=false;
	box_8.selected=false;
	box_9.selected=false;
	box_10.selected=false;
	box_11.selected=false;
	box_12.selected=false;
	// TODO Auto-generated method stub
}
//全选
protected function controlBar_showAllSelectHandler(event:Event):void
{
	box_1.selected=true;
	box_2.selected=true;
	box_3.selected=true;
	box_4.selected=true;
	box_5.selected=true;
	box_6.selected=true;
	box_7.selected=true;
	box_8.selected=true;
	box_9.selected=true;
	box_10.selected=true;
	box_11.selected=true;
	box_12.selected=true;
	// TODO Auto-generated method stub
}
private function reSet():void{
	dfstartUpdateDate.text="";
	dfendUpdateDate.text = "";
}

//复选框处理函数

private function box_id_clickHandler(id:String):void{
	
	if(box_2.selected){
		box_1.selected=true;
	}
	if(box_3.selected||box_4.selected||box_6.selected){
		box_1.selected=true;//站点
		box_5.selected=true;//设备
		box_7.selected=true;//机框
		box_8.selected=true;//机槽
		box_10.selected=true;//机盘
		box_11.selected=true;//端口
	}
	if(box_5.selected){
		box_1.selected=true;//站点
	}
	if(box_7.selected){
		box_1.selected=true;//站点
		box_5.selected=true;//设备
	}
	if(box_8.selected){
		box_1.selected=true;//站点
		box_5.selected=true;//设备
		box_7.selected=true;//机框
	}
	if(box_9.selected){
		box_1.selected=true;//站点
		box_5.selected=true;//设备
		box_7.selected=true;//机框
		box_8.selected=true;//机槽
		box_10.selected=true;//机盘
		box_11.selected=true;//端口
		box_3.selected=true;//复用段
		box_6.selected=true;//交叉
	}
	if(box_10.selected){
		box_1.selected=true;//站点
		box_5.selected=true;//设备
		box_7.selected=true;//机框
		box_8.selected=true;//机槽
	}
	if(box_11.selected){
		box_1.selected=true;//站点
		box_5.selected=true;//设备
		box_7.selected=true;//机框
		box_8.selected=true;//机槽
		box_10.selected=true;//机盘
	}
	if(box_12.selected){
		box_1.selected=true;
		box_2.selected=true;
		box_4.selected=true;
		box_3.selected=true;
		box_5.selected=true;
		box_6.selected=true;
		box_7.selected=true;
		box_8.selected=true;
		box_9.selected=true;
		box_10.selected=true;
		box_11.selected=true;
	}
	if(box_13.selected){
		box_1.selected=true;
		box_2.selected=true;
		box_4.selected=true;
		box_3.selected=true;
		box_5.selected=true;
		box_6.selected=true;
		box_7.selected=true;
		box_8.selected=true;
		box_9.selected=true;
		box_10.selected=true;
		box_11.selected=true;
		box_12.selected=true;
	}
}
/**
 *点击按钮后的处理函数
 * @param event
 * 
 */
protected function btn_clickHandler(event:MouseEvent):void
{
//	obj.endpoint = ModelLocator.END_POINT;
//	obj.showBusyCursor = true;
//	if(this.currentState == 'search'){
//		ct.circuitcode = circuitcode.text;
//		ct.station1 = station1.text;
//		ct.x_purpose = x_purpose.text;
////		ct.portserialno1 = portserialno1.text;
//		ct.portname1 = portname1.text;
//		if(slot1.selectedItem!=null){
//			ct.slot1 = slot1.selectedItem.@id;
//		}
//		
//		ct.usetime = usetime.text;
//		ct.username = username.text;
//		ct.station2 = station2.text;
//		ct.rate = rate.text;
////		ct.portserialno2 = portserialno2.text;
//		ct.portname2 = portname2.text;
//		if(slot2.selectedItem!=null){
//			ct.slot2 = slot2.selectedItem.@id;
//		}
//		ct.path=path.text;
//		ct.remark=remark.text;
//		ct.delay1=delay1.text;
//		ct.delay2=delay2.text;
//	}else if(this.currentState == 'add'){
//		//首先需要判断速度，2M判断端口，155M选择时隙判断
//		//需要判断所选的端口上是否有电路存在，有的话就不让填。
//		
//		ct.schedulerid = schedulerid.text;
//		ct.station1 = station1.text;
//		ct.x_purpose = x_purpose.text;
////		ct.portserialno1 = portserialno1.text;
////		ct.slot1 = slot1.text;
//		ct.usetime = usetime.text;
//		ct.username = username.text;
//		ct.station2 = station2.text;
//		ct.rate = rate.text;
//		ct.path=path.text;
//		ct.remark=remark.text;
//		ct.delay1=delay1.text;
//		ct.delay2=delay2.text;
////		ct.portserialno2 = portserialno2.text;
////		ct.slot2 = slot2.text;
//		ct.portcode1 = (portcode1.data).toString();
//		if(slot1.selectedItem==null){
//			Alert.show("请选择A端时隙", "提示");
//			return;
//		}else{
//			ct.slot1 = slot1.selectedItem.@id;
//		}
//		ct.portcode2 = (portcode2.data).toString();
//		if(slot2.selectedItem==null){
//			Alert.show("请选择Z端时隙", "提示");
//			return;
//		}else{
//			ct.slot2 = slot2.selectedItem.@id;
//		}
//	}else {
//		ct.circuitcode = circuitcode.text;
//		ct.station1 = station1.text;
//		ct.x_purpose = x_purpose.text;
//		ct.slot1 = slot1.text;
//		
//		ct.usetime = usetime.text;
//		ct.username = username.text;
//		ct.station2 = station2.text;
//		ct.rate = rate.text;
//		ct.slot2 = slot2.text;
//		ct.path=path.text;
//		ct.remark=remark.text;
//		ct.delay1=delay1.text;
//		ct.delay2=delay2.text;
//		
//		//新增端口属性
//		if(portcode1.data!=null&&portcode1.data!=''){
//			ct.portcode1 = (portcode1.data).toString();
//		}else{
//			ct.portcode1 = portcode1.text;
//		}
//		if(portcode2.data!=null&&portcode2.data!=''){
//			ct.portcode2 = (portcode2.data).toString();
//		}else{
//			ct.portcode2 = portcode2.text;
//		}
//	}
//	if(this.title=='添加'){
//		if(schedulerid.text==""||station1.text==""
//			||slot1.text==""||username.text==""||station2.text==""||rate.text==""
//			||slot2.text==""||portcode1.text==""||portcode1.text==""){
//			Alert.show("必填项不能为空，请填写完整！","提示");
//			return;
//		}else{
//			//判断端口时隙上面是否有电路\A、Z端都要判断
//			checkPortAndSlotHasCircuitA(ct.rate,ct.portcode1,ct.slot1);
//			
//		}
//	}else if(this.title=='查询'){
//		ct.portname1=portcode1.text;
//		ct.portname2 = portcode2.text;
//		this.dispatchEvent(new CircuitEvent("circuitSearchEvent",ct));
//		PopUpManager.removePopUp(this);
//	}else if(this.title=='修改'){
//		if(circuitcode.text==""){
//			Alert.show("必填项不能为空，请填写完整！","提示");
//			return;
//		}else{
//			checkPortAndSlotHasCircuitA(ct.rate,ct.portcode1,ct.slot1);
////			obj.modifyCircuit(ct);
////			obj.addEventListener(ResultEvent.RESULT,updateHandler);
//		}
//		
//	}
	
}


private function checkPortAndSlotHasCircuitA(rate:String,portcode:String,slot:String):void{
	var obj:RemoteObject = new RemoteObject("resBusinessDwr");
	obj.addEventListener(ResultEvent.RESULT,checkPortAndSlotHasCircuitAHandler);
	obj.endpoint = ModelLocator.END_POINT;
	obj.showBusyCursor = true;
	obj.checkPortAndSlotHasCircuit(rate,portcode,slot,"A",ct.circuitcode);
}

private function checkPortAndSlotHasCircuitAHandler(event:ResultEvent):void{
	
}

private function checkPortAndSlotHasCircuitZ(rate:String,portcode:String,slot:String):void{
	var obj:RemoteObject = new RemoteObject("resBusinessDwr");
	obj.addEventListener(ResultEvent.RESULT,checkPortAndSlotHasCircuitZHandler);
	obj.endpoint = ModelLocator.END_POINT;
	obj.showBusyCursor = true;
	obj.checkPortAndSlotHasCircuit(rate,portcode,slot,"Z",ct.circuitcode);
}

private function checkPortAndSlotHasCircuitZHandler(event:ResultEvent):void{
	
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
	
}
private function openTreeWindow(treeWin:IFlexDisplayObject):void{
	
	PopUpManager.addPopUp(treeWin, this, true);
	PopUpManager.centerPopUp(treeWin);
}

/**
 * 获取站点列表
 * */
private function getStation(){
	var obj:RemoteObject = new RemoteObject("resBusinessDwr");
	obj.addEventListener(ResultEvent.RESULT,resultStationHandler);
	obj.endpoint = ModelLocator.END_POINT;
	obj.showBusyCursor = true;
	obj.getStation(); 
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

	
}

public function resultX_purposeHandler(event:ResultEvent):void{
	
	
}

public function resultStationHandler(event:ResultEvent):void{
//	if(this.currentState=='modify'){
//		var strStation:XMLList= new XMLList(event.result);
//		station1.dropdown.dataProvider=strStation;
//		station1.dataProvider=strStation;
//		station1.labelField="@label";
//		
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
//		
//		station2.dropdown.dataProvider=strStation;
//		station2.dataProvider=strStation;
//		station2.labelField="@label";
//		station2.text="";
//		station2.selectedIndex=-1;
//	}

}

protected function initApp():void
{
	
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