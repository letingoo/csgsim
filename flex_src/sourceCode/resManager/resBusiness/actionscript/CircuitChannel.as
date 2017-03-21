// ActionScript file

import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;

import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import mx.controls.Alert;
import mx.controls.DataGrid;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.Application;
import mx.events.CloseEvent;
import mx.events.DataGridEvent;
import mx.events.FlexEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import sourceCode.autoGrid.view.ShowProperty;
import sourceCode.resManager.resBusiness.events.CircuitChannelEvent;
import sourceCode.resManager.resBusiness.model.CircuitChannelModel;
import sourceCode.resManager.resBusiness.model.ResultModel;
import sourceCode.resManager.resBusiness.titles.CircuitChannelSearch;
import sourceCode.resManager.resBusiness.views.CircuitChannelRoute;
import sourceCode.systemManagement.model.PermissionControlModel;
import sourceCode.tableResurces.Events.ToopEvent;
import sourceCode.tableResurces.views.DataImportFirstStep;
import sourceCode.tableResurces.views.FileExportFirstStep;

import twaver.DemoUtils;

public var e2Oracle:DataImportFirstStep = new DataImportFirstStep();
private var pageIndex:int=0;
private var pageSize:int=50;
private var datanumbers:int;
private var circuitChannelModel:CircuitChannelModel = new CircuitChannelModel();
private var dir:Boolean = true; //排序方式   true 升序 ，false 降序
private var sortName:String =""; //当前排序的列名


protected function intApp():void
{
	serverPagingBar.dataGrid = RessGrid;
	serverPagingBar.pagingFunction=pagingFunction;
	serverPagingBar.addEventListener("returnALL",showAllDataHandler);
	getAllChannelList("0",pageSize.toString());//获取通道
	
	var contextMenu:ContextMenu=new ContextMenu();
	RessGrid.contextMenu=contextMenu;
	RessGrid.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,function(e:ContextMenuEvent):void{
		
		if (RessGrid.selectedItems.length> 0) {
			RessGrid.selectedItem=RessGrid.selectedItems[0];
		}
		//定制右键菜单
		var flexVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLEX_SDK_VERSION, false, false);
		var playerVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLASH_PLAYER_VERSION, false, false);
		
		if(RessGrid.selectedItems.length==0){//选中元素个数
			
			var item:ContextMenuItem = new ContextMenuItem("查询");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
			RessGrid.contextMenu.hideBuiltInItems();
			RessGrid.contextMenu.customItems = [item];
		}
		else{
			
			var item1:ContextMenuItem = new ContextMenuItem("查看路由图");
			item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
			RessGrid.contextMenu.hideBuiltInItems();
			RessGrid.contextMenu.customItems = [item1];
		}
	})
}
private function getAllChannelList(start:String,end:String):void{
	var obj:RemoteObject = new RemoteObject("resBusinessDwr");
	Application.application.faultEventHandler(obj);
	circuitChannelModel.start = start;
	circuitChannelModel.end = end ;
	obj.endpoint = ModelLocator.END_POINT;
	obj.showBusyCursor = true;
	obj.addEventListener(ResultEvent.RESULT,setData);
	obj.getAllChannelList(circuitChannelModel);//获取通道
}
private function setData(e:ResultEvent):void{
	var result:ResultModel = e.result as ResultModel;
	if(result!=null){
		this.datanumbers = result.totalCount;
		onResult(result);
	}
}
public function onResult(result:ResultModel):void 
{	
	serverPagingBar.orgData=result.orderList;
	serverPagingBar.totalRecord=result.totalCount;
	serverPagingBar.dataBind(true);					
}
private function showAllDataHandler(event:Event):void{
	getAllChannelList("0",serverPagingBar.totalRecord.toString());
}
private function pagingFunction(pageIndex:int,pageSize:int):void{
	this.pageSize=pageSize;
	this.pageIndex = pageIndex;
	getAllChannelList((pageIndex*pageSize).toString(),(pageIndex*pageSize+pageSize).toString());
}

//private function refreshHandle(event:Event):void{
//	serverPagingBar.navigateButtonClick("firstPage");
//}
public function itemSelectHandler(e:ContextMenuEvent):void{
	switch(e.target.caption){
		case "查询":
			toolbar_toolEventSearchHandler(new ToopEvent("toolEventSearch"));
			break;
		case "查看路由图":
			toolbar_toolEventViewRouteHandler(new ToopEvent("toolEventViewRoute"));
			break;
		default:
			break;
		
	}
}

/**
 * 查看路由图
 * 
 */
private function toolbar_toolEventViewRouteHandler(event:Event):void{
	if(RessGrid.selectedItems.length>0){
		var channelRoute:CircuitChannelRoute = new CircuitChannelRoute();
		PopUpManager.addPopUp(channelRoute,Application.application as DisplayObject,true);
		PopUpManager.centerPopUp(channelRoute);
		//传参数
		var circuitcode:String = RessGrid.selectedItem.circuitcode;
		channelRoute.circuitcode = circuitcode;
		channelRoute.slot_a = RessGrid.selectedItem.slot1;
		channelRoute.slot_z = RessGrid.selectedItem.slot2;
		channelRoute.port_a = RessGrid.selectedItem.portcode1;
		channelRoute.port_z = RessGrid.selectedItem.portcode2;
		channelRoute.rate = RessGrid.selectedItem.rate;
		channelRoute.init();
		
	}else{
		Alert.show("请选择一条通道！","提示");
		return;
	}
}


/**
 * 查询
 * 
 * 
 */
protected function toolbar_toolEventSearchHandler(event:Event):void{
	var circuitSearch:CircuitChannelSearch = new CircuitChannelSearch();
	PopUpManager.addPopUp(circuitSearch,Application.application as DisplayObject,true);
	PopUpManager.centerPopUp(circuitSearch);
//	
//	frameSearch.frame_state.dataProvider = frame_stateLst;
//	frameSearch.frame_state.selectedIndex = -1;
//	frameSearch.framemodel.dataProvider = frame_modelLst;
//	frameSearch.framemodel.selectedIndex = -1;
//	
	circuitSearch.addEventListener("CircuitChannelEvent",circuitSearchHandler);
	circuitSearch.title = "查询";
}

/**
 *监听到查询，执行查询 
 * @param event
 * 
 */
protected function circuitSearchHandler(event:CircuitChannelEvent):void{
	circuitChannelModel = event.model;
	circuitChannelModel.start="0";
	circuitChannelModel.end=pageSize.toString();
	circuitChannelModel.dir ="asc";
	serverPagingBar.navigateButtonClick("firstPage");
}

/**
 * 导出数据
 * */
protected function toolbar1_toolEventEmpExcelHandler(event:Event):void//导出
{
//	var fefs:FileExportFirstStep = new FileExportFirstStep();
//	var model:BusinessRessModel = new BusinessRessModel();
//	fefs.dataNumber = this.datanumbers;
//	fefs.exportTypes = "业务";
//	fefs.titles = new Array("序号","业务名称","所属电路", "业务起点", "业务终点","业务类别","业务速率","业务状态","业务版本"/*,"配置容量","设备容量","工程名称","使用情况","用途","设备标签","备注" ,"更新时间"*/);
//	fefs.labels = "业务信息列表";
//	model = businessModel;
//	model.start = "0";
//	model.end = this.datanumbers.toString();
//	fefs.model = model;
//	MyPopupManager.addPopUp(fefs, true);
}

/**
 * 导入
 * */
protected function toolbar1_toolEventImpExcelHandler(event:Event):void//导入
{
//	MyPopupManager.addPopUp(e2Oracle,true);
//	e2Oracle.setTemplateType("业务");
}

/**
 * 在桌面添加快捷方式
 * */
protected function toolbar1_toolEventAddShortcutHandler(event:Event):void//添加桌面快捷方式
{
//	parentApplication.addShorcut('业务','resBusinessDwr');
}

/**
 * 删除桌面的快捷方式
 * */
protected function toolbar1_toolEventDelShortcutHandler(event:Event):void//删除桌面快捷方式
{
//	parentApplication.delShortcut('业务');
}


protected function RessGrid_headerReleaseHandler(event:DataGridEvent):void
{
	var dg:DataGrid = DataGrid(event.currentTarget);
	var dgm:DataGridColumn = dg.columns[event.columnIndex];
	var columnName:String=dgm.dataField;
	event.stopImmediatePropagation(); //阻止其自身的排序
	circuitChannelModel.sort = columnName;
	circuitChannelModel.start="0";
	if(sortName == columnName){
		if(dir){
			circuitChannelModel.dir="asc";
			dir=false;
		}else{
			circuitChannelModel.dir="desc";
			dir=true;
		}
	}else{
		sortName=columnName;
		dir = false;
		circuitChannelModel.dir="asc";
	}
	serverPagingBar.navigateButtonClick("firstPage");
}
