// ActionScript file
import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.actionscript.Registry;

import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.events.CloseEvent;
import mx.events.DataGridEvent;
import mx.events.FlexEvent;
import mx.events.ItemClickEvent;
import mx.events.ListEvent;
import mx.formatters.DateFormatter;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;
import mx.utils.ObjectProxy;

import org.flexunit.runner.Result;

import sourceCode.autoGrid.view.ShowProperty;
import sourceCode.faultSimulation.model.StdMaintainProModel;
import sourceCode.faultSimulation.model.MaintainSearchEvent;
import sourceCode.faultSimulation.titles.EventMaintainProcTitle;
import sourceCode.systemManagement.model.PermissionControlModel;
import sourceCode.tableResurces.Events.ToopEvent;
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

private var dir:Boolean = true; //排序方式   true 升序 ，false 降序
private var sortName:String =""; //当前排序的列名
private var isEdit:Boolean = false;
private var isAdd:Boolean = false;
private var isDelete:Boolean = false;
private var isSearch:Boolean = true;
private var isExport:Boolean = false;
private var isImport:Boolean = false;
public var modelName:String = "处理方法管理";
public var maintainModel:StdMaintainProModel = new StdMaintainProModel();

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
protected function init():void
{
	maintainModel.sort="OPERATE_TYPE_ID";
	serverPagingBar.dataGrid=dg;
	serverPagingBar.pagingFunction=pagingFunction;
	serverPagingBar.addEventListener("returnALL",showAllDataHandler);
	getAllEventMaintainProc("0",pageSize.toString());
	addContextMenu();
}

private function addContextMenu():void
{
	var contextMenu:ContextMenu=new ContextMenu();
	dg.contextMenu=contextMenu;
	dg.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,function(e:ContextMenuEvent):void{
		var item1:ContextMenuItem = new ContextMenuItem("添 加", true);
		item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
		var item4:ContextMenuItem = new ContextMenuItem("查 询", true);
		item4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
		item1.visible = isAdd;
		item4.visible = isSearch;
		if (dg.selectedItems.length> 0) {
			dg.selectedItem=dg.selectedItems[0];
		}
		//定制右键菜单
		var flexVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLEX_SDK_VERSION, false, false);
		var playerVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLASH_PLAYER_VERSION, false, false);
		
		if(dg.selectedItems.length==0){//选中元素个数
			dg.contextMenu.hideBuiltInItems();
			dg.contextMenu.customItems = [item1,item4];
		}
		else{
			
			var item2:ContextMenuItem = new ContextMenuItem("修 改");
			item2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
			var item3:ContextMenuItem = new ContextMenuItem("删 除", true);
			item3.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
			
			item2.visible = isEdit;
			item3.visible = isDelete;
			dg.contextMenu.hideBuiltInItems();
			dg.contextMenu.customItems = [item1,item2,item3,item4];
		}
	})
}

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

private function showAllDataHandler(event:Event):void{
	getAllEventMaintainProc("0",serverPagingBar.totalRecord.toString());
}

/**
 * 
 * 获取维护过程配置信息
 * 
 * */
private function getAllEventMaintainProc(start:String,end:String):void{
	var re:RemoteObject=new RemoteObject("faultSimulation");
	maintainModel.start = start;
	maintainModel.end = end ;
	re.addEventListener(ResultEvent.RESULT,resultAlldelInterposeHandler);
	Application.application.faultEventHandler(re);
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.getAllEventMaintainProc(maintainModel);
}

public function resultAlldelInterposeHandler(event:ResultEvent):void{
	var result:ResultModel=event.result as ResultModel;
	onResult(result);
}

private function pagingFunction(pageIndex:int,pageSize:int):void{
	this.pageSize=pageSize;
	getAllEventMaintainProc((pageIndex*pageSize).toString(),(pageIndex*pageSize+pageSize).toString());
}

public function onResult(result:ResultModel):void 
{	
	serverPagingBar.orgData=result.orderList;
	serverPagingBar.totalRecord=result.totalCount;
	datanumbers = result.totalCount;
	serverPagingBar.dataBind(true);					
}

private function RefreshDataGrid(event:Event):void{
	getAllEventMaintainProc("0",pageSize.toString());
}


/**
 * 
 * 添加
 * 
 * */
protected function toolbar_toolEventAddHandler(event:Event):void
{
	var interpose:EventMaintainProcTitle = new EventMaintainProcTitle();
	PopUpManager.addPopUp(interpose,Application.application as DisplayObject,true);
	PopUpManager.centerPopUp(interpose);
	interpose.title = "添加";
	interpose.addEventListener("RefreshDataGrid",RefreshDataGrid);
}

/**
 * 
 * 修改
 * 
 * */
protected function toolbar_toolEventEditHandler(event:Event):void
{
	if(dg.selectedItem != null){
		var interpose:EventMaintainProcTitle = new EventMaintainProcTitle();
		PopUpManager.addPopUp(interpose,Application.application as DisplayObject,true);
		PopUpManager.centerPopUp(interpose);
		interpose.title = "修改";
		interpose.interposeData = dg.selectedItem;
		interpose.isEnabled=false;
		interpose.setData();
		interpose.addEventListener("RefreshDataGrid",RefreshDataGrid);
	}else{
		Alert.show("请先选中一条记录！","提示");
	}
}

/**
 * 
 * 删除
 * 
 * */
protected function toolbar_toolEventDeleteHandler(event:Event):void{
	if(dg.selectedItem != null){
		ModelLocator.showConfimMessage("您确认要删除吗?",this,delconfirmHandler);
		
	}else{
		ModelLocator.showErrorMessage("请先选中一条记录!",this);
	}
}



private function delconfirmHandler(event:CloseEvent):void {
	if (event.detail == Alert.YES) {
		var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		remoteObject.delEventMaintainProc(dg.selectedItem);
		remoteObject.addEventListener(ResultEvent.RESULT,delEventMaintainProcResult);
		Application.application.faultEventHandler(remoteObject);
	}
}

public function delEventMaintainProcResult(event:ResultEvent):void{
	if(event.result.toString()=="success")
	{
		ModelLocator.showSuccessMessage("删除成功!",this);
		this.getAllEventMaintainProc("0",pageSize.toString());
	}else{
		ModelLocator.showErrorMessage("删除失败!",this);
	}
}

/**
 * 
 * 查询
 * 
 * */
protected function toolbar_toolEventSearchHandler(event:Event):void
{
	var interpose:EventMaintainProcTitle = new EventMaintainProcTitle();
	PopUpManager.addPopUp(interpose,Application.application as DisplayObject,true);
	PopUpManager.centerPopUp(interpose);
	interpose.isRequired=false;
	interpose.addEventListener("MaintainSearchEvent",InterposeSearchHandler);
	interpose.title = "查询";
}


protected function InterposeSearchHandler(event:MaintainSearchEvent):void{
	maintainModel = event.model;
	maintainModel.start="0";
	maintainModel.dir="asc";
	maintainModel.end=pageSize.toString();
	serverPagingBar.navigateButtonClick("firstPage");
}

/**
 * 
 * 导入
 * 
 * */
protected function toolbar_toolEventImpExcelHandler(event:Event):void
{
}

/**
 * 
 * 导出
 * 
 * */
protected function toolbar_toolEventEmpExcelHandler(event:Event):void
{
	var fefs:FileExportFirstStep = new FileExportFirstStep();
	fefs.dataNumber = this.datanumbers;	
	maintainModel.end = this.datanumbers.toString();				
	fefs.titles = new Array("序号","处理方法","是否有本端设备","本端设备类型","是否有对端设备","对端设备类型","设备状态属性",
		"设备默认状态","操作人","操作时间","备注");				
	fefs.exportTypes = "处理方法管理";
	fefs.labels = "处理方法管理信息列表";
	fefs.model = maintainModel;
	MyPopupManager.addPopUp(fefs, this);
}

/**
 * 
 * 添加快捷方式
 * 
 * */
protected function toolbar_toolEventAddShortcutHandler(event:Event):void
{
	parentApplication.addShorcut('处理方法管理','alarmInfoHistory');
}

/**
 * 
 * 删除快捷方式
 * 
 * */
protected function toolbar_toolEventDelShortcutHandler(event:Event):void
{
	parentApplication.delShortcut('处理方法管理');
}
/**
 * 点击列头对查询的所有结果进行排序  
 * */
protected function dg_headerReleaseHandler(event:DataGridEvent):void
{
	var dg:DataGrid = DataGrid(event.currentTarget);
	var dgm:DataGridColumn = dg.columns[event.columnIndex];
	var columnName:String=dgm.dataField;
	if(columnName=="operatetype"){
		columnName="OPERATE_TYPE_ID";
	}if(columnName=="hasA_equip"){
		columnName="HASA_EQUIP";
	}if(columnName=="a_equipname"){
		columnName="a_equipcode";
	}
	if(columnName=="hasZ_equip"){
		columnName="HASZ_EQUIP";
	}
	if(columnName=="z_equipname"){
		columnName="z_equipcode";
	}
	if(columnName=="isinterposeoperate"){
		columnName="HASINTERPOSE";
	}
	if(columnName=="operatedes"){
		columnName="OPERATE_DES";
	}
	if(columnName=="expectedresult"){
		columnName="EXPECTED_RESULT";
	}
	event.stopImmediatePropagation(); //阻止其自身的排序
	maintainModel.sort = columnName;
	maintainModel.start="0";
	maintainModel.end=pageSize.toString();
	if(sortName == columnName){
		if(dir){
			maintainModel.dir="asc";
			dir=false;
		}else{
			maintainModel.dir="desc";
			dir=true;
		}
	}else{
		sortName=columnName;
		dir = false;
		maintainModel.dir="asc";
	}
	serverPagingBar.navigateButtonClick("firstPage");
}

