// ActionScript file
/**
 * Title: 逻辑端口主页面
 * Description: 逻辑端口主页面调用方法
 * @version: v.1
 * @author: yangzhong 
 * @copyright:
 * @date: 2013-7-15
 */


import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;

import flash.events.Event;
import flash.ui.ContextMenuItem;

import flexlib.scheduling.samples.AlternatingHorizontalLinesViewer;

import mx.controls.Alert;
import mx.core.Application;
import mx.events.CloseEvent;
import mx.events.DataGridEvent;
import mx.events.ListEvent;
import mx.logging.Log;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import sourceCode.systemManagement.model.PermissionControlModel;
import sourceCode.resManager.resNet.events.LogicPortSearchEvent;
import sourceCode.tableResurces.Events.ToopEvent;
import sourceCode.resManager.resNode.Events.StationSearchEvent;
import sourceCode.resManager.resNet.titles.LogicPortSearch;
import sourceCode.resManager.resNet.titles.LogicPortTitle;
import sourceCode.resManager.resNet.model.LogicPort;
import sourceCode.tableResurces.model.ResultModel;
import sourceCode.tableResurces.views.DataImportFirstStep;
import sourceCode.tableResurces.views.FileExportFirstStep;

import twaver.DemoUtils;
import twaver.SequenceItemRenderer;

private var pageIndex:int=0;
private var pageSize:int=50;
private var datanumbers:int;

private var indexRenderer:Class = SequenceItemRenderer;
public var e2Oracle:DataImportFirstStep = new DataImportFirstStep();

[Bindable] public var xmlPortType:XMLList;
[Bindable] public var xmlPortRate:XMLList;
[Bindable] public var xmlStatus:XMLList;
[Bindable] public var xmlSystemCode:XMLList;

public var model:LogicPort = new LogicPort();
private var dir:Boolean = true; //排序方式   true 升序 ，false 降序
private var sortName:String =""; //当前排序的列名

private var isEdit:Boolean = false;
private var isAdd:Boolean = false;
private var isDelete:Boolean = false;
private var isSearch:Boolean = true;
private var isExport:Boolean = false;
private var isImport:Boolean = false
/**
 *初始化进入 
 * 
 */
private function preinitialize():void{
	if(ModelLocator.permissionList!=null&&ModelLocator.permissionList.length>0){
		isAdd = false;
		isEdit = false;
		isDelete = false;
		isSearch = true;
		isImport = false;
		isExport = false;
		for(var i:int=0;i<ModelLocator.permissionList.length;i++){
			var model:PermissionControlModel = ModelLocator.permissionList[i];
			if(model.oper_name!=null&&model.oper_name=="添加操作"){
				isAdd = true;
			}
			if(model.oper_name!=null&&model.oper_name=="修改操作"){
				isEdit = true;
			}
			if(model.oper_name!=null&&model.oper_name=="删除操作"){
				isDelete = true;
			}
			if(model.oper_name!=null&&model.oper_name=="导出操作"){
				isExport = true;
			}
			if(model.oper_name!=null&&model.oper_name=="导入操作"){
				isImport = true;
			}
		}
	}
}
/**
 *初始化页面数据
 * 
 */
protected function init():void
{
	serverPagingBar.dataGrid=dg;
	serverPagingBar.pagingFunction=pagingFunction;
	serverPagingBar.addEventListener("returnALL",showAllDataHandler);
	
	getLogicPort("0",pageSize.toString());
	getSystemcode();
	getPortType();
	getPortRate();
	getPortStatus();
	addContextMenu();
//	serverPagingBar.addEventListener("viewAllEvent",Queryall);
}
//private var queryType:Boolean = true;
//private function Queryall(event:Event):void{
//	queryType = false;
//}

/**
 *添加右键功能 
 * 
 */
private function addContextMenu():void
{
	var contextMenu:ContextMenu=new ContextMenu();
	dg.contextMenu=contextMenu;
	dg.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,function(e:ContextMenuEvent):void{
		
		//定制右键菜单
		var item1:ContextMenuItem = new ContextMenuItem("添 加",true);
		item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
		var item2:ContextMenuItem = new ContextMenuItem("修 改");
		item2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
		var item3:ContextMenuItem = new ContextMenuItem("删 除",true);
		item3.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
		var item4:ContextMenuItem = new ContextMenuItem("查 询",true);
		item4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
		item1.visible = false;
		item2.visible  = false;
		item3.visible = false;
		item4.visible = isSearch;
		
		if(dg.selectedItems.length==0){//选中元素个数
			dg.contextMenu.hideBuiltInItems();
			dg.contextMenu.customItems = [item1, item4];
		}
		else{
			
			dg.contextMenu.hideBuiltInItems();
			dg.contextMenu.customItems = [item1,item2,item3,item4];
		}
	})
}
/**
 *相应的右键对应的处理函数 
 * @param e
 * 
 */
private function itemSelectHandler(e:ContextMenuEvent):void{
	switch(e.target.caption){
		case "添 加":
			toolbar_toolEventAddHandler(new ToopEvent("toolEventAdd"));
			break;
		case "修 改":
			toolbar_toolEventEditHandler(new ToopEvent("toolEventEdit"));
			break;
		case "删 除":
			toolbar_toolEventDeleteHandler(new ToopEvent("toolEventDelete"));
			break;
		case "查 询":
			toolbar_toolEventSearchHandler(new ToopEvent("toolEventSearch"));
			break;
		default:
			break;
	}
}
/**
 *分页显示 
 * @param pageIndex
 * @param pageSize
 * 
 */
private function pagingFunction(pageIndex:int,pageSize:int):void{
	this.pageSize = pageSize;
	this.pageIndex = pageIndex;
	getLogicPort((pageIndex*pageSize).toString(),(pageIndex*pageSize+pageSize).toString());
}
/**
 *初始化，显示所有的的端口 
 * @param event
 * 
 */
private function showAllDataHandler(event:Event):void{
	getLogicPort("0",serverPagingBar.totalRecord.toString());
}
/**
 *刷新界面 
 * @param event
 * 
 */
private function RefreshDataGrid(event:Event):void{
	serverPagingBar.navigateButtonClick("firstPage");
}

/**
 * 
 * 获取端口信息
 * 
 * */
private function getLogicPort(start:String,end:String):void{
	var rt:RemoteObject=new RemoteObject("resNetDwr");
	model.start = start;
	model.end = end;
	rt.endpoint = ModelLocator.END_POINT;
	rt.showBusyCursor = true;
	rt.addEventListener(ResultEvent.RESULT,getLogicPortResult);
	Application.application.faultEventHandler(rt);
	rt.getLogicPort(model); 
	
}
/**
 *获取端口信息后的处理函数 
 * @param event
 * 
 */
private function getLogicPortResult(event:ResultEvent):void{
	var result:ResultModel=event.result as ResultModel;
	this.datanumbers = result.totalCount;
	onResult(result);
}
/**
 *页面下侧的数据条的数据绑定 
 * @param result
 * 
 */
private function onResult(result:ResultModel):void 
{	
	serverPagingBar.orgData=result.orderList;
	serverPagingBar.totalRecord=result.totalCount;
//	if(queryType){
//		serverPagingBar.pageSize = 20; 
//		serverPagingBar.isInit = true;
//	}		
	serverPagingBar.dataBind(true);					
}

/**
 * 
 * 获取端口类型
 * 
 * */
private function getPortType():void{
	var rt:RemoteObject=new RemoteObject("resNetDwr");
	rt.addEventListener(ResultEvent.RESULT,resultPortType);
	Application.application.faultEventHandler(rt);
	rt.endpoint = ModelLocator.END_POINT;
	rt.showBusyCursor = true;
	rt.getPortType(); 
	
}
/**
 *获取端口状态 
 * 
 */ 
private function getPortStatus():void{
	var rt:RemoteObject=new RemoteObject("resNetDwr");
	rt.addEventListener(ResultEvent.RESULT,resultPortStatus);
	Application.application.faultEventHandler(rt);
	rt.endpoint = ModelLocator.END_POINT;
	rt.showBusyCursor = true;
	rt.getPortStatus(); 
}
/**
 *端口状态赋值 
 * @param event
 * 
 */
private function resultPortStatus(event:ResultEvent):void{
	xmlStatus = new XMLList(event.result);
}
/**
 *端口类型赋值 
 * @param event
 * 
 */
private function resultPortType(event:ResultEvent):void{
	xmlPortType=new XMLList(event.result);
	
}

/**
 * 
 * 获取端口速率
 * 
 * */
private  function getPortRate():void{
	var rt:RemoteObject=new RemoteObject("resNetDwr");
	rt.addEventListener(ResultEvent.RESULT,resultPortRate);
	Application.application.faultEventHandler(rt);
	rt.endpoint = ModelLocator.END_POINT;
	rt.showBusyCursor = true;
	rt.getPortRate(); 
}

private function resultPortRate(event:ResultEvent):void{
	xmlPortRate = new XMLList(event.result);
}


/**
 * 
 * 添加
 * 
 * */
protected function toolbar_toolEventAddHandler(event:Event):void
{
	
	var title:LogicPortTitle = new LogicPortTitle();
	PopUpManager.addPopUp(title,Application.application as DisplayObject,true);
	PopUpManager.centerPopUp(title);
	title.cmbY_porttype.dataProvider = xmlPortType;
	title.cmbX_capability.dataProvider = xmlPortRate;
	title.cmbStatus.dataProvider=xmlStatus;
	title.title = "添加";
	title.addEventListener("RefreshDataGrid",RefreshDataGrid); 
	
}

protected function dg_doubleClickHandler(event:Event):void{
	toolbar_toolEventEditHandler(null);
	
}

/**
 * 
 * 修改
 * 
 * */
protected function toolbar_toolEventEditHandler(event:Event):void
{
	if(dg.selectedItem != null){
		var title:LogicPortTitle = new LogicPortTitle();
		PopUpManager.addPopUp(title,Application.application as DisplayObject,true);
		PopUpManager.centerPopUp(title);
		title.title = "修改";
		title.logicPortData = dg.selectedItem;
		title.setData();
		title.setPortType(xmlPortType,dg.selectedItem.y_porttype);
		title.setCapability(xmlPortRate,dg.selectedItem.x_capability);
		title.setPortStatus(xmlStatus,dg.selectedItem.status);
		title.port_serial = dg.selectedItem.portserial;
		title.code = dg.selectedItem.equipcode;
		title.addEventListener("RefreshDataGrid",RefreshDataGrid);
	}else{
		Alert.show("请先选中一条记录！","提示");
	}
	
}

/**
 * 
 * 删除
 * 
 * */
protected function toolbar_toolEventDeleteHandler(event:Event):void
{
	
	if(dg.selectedItem != null){
		
		Alert.show("您确认要删除吗？","请您确认！",Alert.YES|Alert.NO,this,delconfirmHandler,null,Alert.NO);
	}else{
		Alert.show("请先选中一条记录！","提示");
	}
}
/**
 *确认删除后的处理函数 
 * @param event
 * 
 */
private function delconfirmHandler(event:CloseEvent):void {
	if (event.detail == Alert.YES) {
		var remoteObject:RemoteObject=new RemoteObject("resNetDwr");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		remoteObject.delLogicPort(dg.selectedItem);
		remoteObject.addEventListener(ResultEvent.RESULT,delPortResult);
		Application.application.faultEventHandler(remoteObject);
	}
}
/**
 *删除经数据交互后的界面提示处理 
 * @param event
 * 
 */
private function delPortResult(event:ResultEvent):void{
	if(event.result.toString()=="success")
	{
		Alert.show("删除成功！","提示");
		serverPagingBar.navigateButtonClick("firstPage");
	}else
	{
		Alert.show("删除失败！","提示");
	}
}

/**
 * 
 * 查询
 * 
 * */
protected function toolbar_toolEventSearchHandler(event:Event):void
{
	
	var title:LogicPortSearch= new LogicPortSearch();
	PopUpManager.addPopUp(title,Application.application as DisplayObject,true);
	PopUpManager.centerPopUp(title);
	title.addEventListener("LogicPortSearchEvent",portSearchHandler);
	title.title = "查询";
	
	title.cmbY_porttype.dataProvider = xmlPortType;
	title.cmbY_porttype.selectedIndex = -1;
//	title.cmbSystemcode.dataProvider=xmlSystemCode;
//	title.cmbSystemcode.selectedIndex=-1;
}
/**
 *查询接收到监听事件后的处理函数 
 * @param event
 * 
 */
protected function portSearchHandler(event:LogicPortSearchEvent):void{
//	queryType = true;
//	model = event.model;
//	model.start = "0";
////	model.end = pageSize.toString();
//	model.end = "20";
//	model.dir="asc";
////	serverPagingBar.navigateButtonClick("firstPage");	 
//	getLogicPort("0","20");
	model = event.model;
	model.start="0";
	model.dir="asc";
	model.end=pageSize.toString();
	serverPagingBar.navigateButtonClick("firstPage");
}

/**
 * 
 * 导入
 * 
 * */
protected function toolbar_toolEventImpExcelHandler(event:Event):void
{
	MyPopupManager.addPopUp(e2Oracle,true);
	e2Oracle.setTemplateType("端口");
}

/**
 * 
 * 导出
 * 
 * */
protected function toolbar_toolEventEmpExcelHandler(event:Event):void
{
	var fefs:FileExportFirstStep = new FileExportFirstStep();
	var tempModel:LogicPort = new LogicPort();
	fefs.dataNumber = this.datanumbers;
	fefs.exportTypes = "端口";
	fefs.titles = new Array("序号","设备名称", "机框序号", "机槽序号", "机盘序号", "端口序号","端口类型","端口速率","更新时间");
	fefs.labels = "端口信息列表";
	tempModel = model;
	tempModel.start = "0";
	tempModel.end = this.datanumbers.toString();
	fefs.model = tempModel;
	
	MyPopupManager.addPopUp(fefs, true);
}

/**
 * 
 * 添加快捷方式
 * 
 * */
protected function toolbar_toolEventAddShortcutHandler(event:Event):void
{
	
	parentApplication.addShorcut('逻辑端口','port');
}

/**
 * 
 * 删除快捷方式
 * 
 * */
protected function toolbar_toolEventDelShortcutHandler(event:Event):void
{
	parentApplication.delShortcut('逻辑端口');
}
/**
 *列表的排序处理 
 * @param event
 * 
 */
protected function dg_headerReleaseHandler(event:DataGridEvent):void
{
	var dg:DataGrid = DataGrid(event.currentTarget);
	var dgm:DataGridColumn = dg.columns[event.columnIndex];
	var columnName:String=dgm.dataField;
	event.stopImmediatePropagation(); //阻止其自身的排序
	model.sort = columnName;
	model.start="0";
	model.end=pageSize.toString();
	if(columnName === "frameserial" || columnName == "slotserial" ||  //处理数字类型的排序
		columnName == "packserial" ||  columnName == "portserial"){ 
		model.isNumber =columnName;
	}else{
		model.isNumber = "";
	}
	if(sortName == columnName){
		if(dir){
			model.dir="asc";
			dir=false;
		}else{
			model.dir="desc";
			dir=true;
		}
	}else{
		sortName=columnName;
		dir = false;
		model.dir="asc";
	}
	serverPagingBar.navigateButtonClick("firstPage");
}

/**
 *获取复用段所属系统的code 
 * 
 */
private function getSystemcode():void{
	var re:RemoteObject=new RemoteObject("resNetDwr");
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.addEventListener(ResultEvent.RESULT,resultSystemCodeHandler);
	Application.application.faultEventHandler(re);
	re.getTranssystem(); 
	
}
/**
 * 获取复用段所属系统后的处理函数
 * @param event
 * 
 */
public function resultSystemCodeHandler(event:ResultEvent):void{
	xmlSystemCode = new XMLList(event.result);
}