// ActionScript file
import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.actionscript.Registry;

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
import sourceCode.faultSimulation.titles.InterposeStdMaintainTitle;
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
private var isEdit:Boolean = true;
private var isAdd:Boolean = true;
private var isDelete:Boolean = true;
private var isSearch:Boolean = true;
private var isExport:Boolean = true;
private var isImport:Boolean = false;
public var modelName:String = "标准处理过程";
public var interposeid:String="";//父页面传过来的参数
public var interposetype:String="";//父页面传过来的参数
public var interposetypeid:String="";//父页面传过来的参数
public var faulttype:String="";//父页面传过来的参数
public var faulttypeid:String="";//父页面传过来的参数
//public var equip_type:String="";//父页面传过来的参数
public var maintainModel:StdMaintainProModel = new StdMaintainProModel();


protected function init():void
{
	interposeid=Registry.lookup("interposeid");
	Registry.unregister("interposeid");
	interposetype=Registry.lookup("interposetype");
	Registry.unregister("interposetype");
	faulttype=Registry.lookup("faulttype");
	Registry.unregister("faulttype");
	interposetypeid=Registry.lookup("interposetypeid");
	Registry.unregister("interposetypeid");
	faulttypeid=Registry.lookup("faulttypeid");
	Registry.unregister("faulttypeid");
	
	maintainModel.interposeid = interposeid;
	maintainModel.interposetypeid = interposetypeid; 
	maintainModel.faulttypeid = faulttypeid;
	
	serverPagingBar.dataGrid=dg;
	serverPagingBar.pagingFunction=pagingFunction;
	serverPagingBar.addEventListener("returnALL",showAllDataHandler);
	getAllInterposeStdMaintain("0",pageSize.toString());
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
	getAllInterposeStdMaintain("0",serverPagingBar.totalRecord.toString());
}

/**
 * 
 * 获取干预维护过程信息
 * 
 * */
private function getAllInterposeStdMaintain(start:String,end:String):void{
	var re:RemoteObject=new RemoteObject("faultSimulation");
	maintainModel.start = start;
	maintainModel.end = end ;
	maintainModel.interposeid = interposeid;
	re.addEventListener(ResultEvent.RESULT,resultAllInterposeStdMaintainHandler);
	Application.application.faultEventHandler(re);
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.getAllInterposeStdMaintain(maintainModel);
}

public function resultAllInterposeStdMaintainHandler(event:ResultEvent):void{
	var result:ResultModel=event.result as ResultModel;
	onResult(result);
}

private function pagingFunction(pageIndex:int,pageSize:int):void{
	this.pageSize=pageSize;
	getAllInterposeStdMaintain((pageIndex*pageSize).toString(),(pageIndex*pageSize+pageSize).toString());
}

public function onResult(result:ResultModel):void 
{	
	serverPagingBar.orgData=result.orderList;
	serverPagingBar.totalRecord=result.totalCount;
	serverPagingBar.dataBind(true);					
}

private function RefreshDataGrid(event:Event):void{
	getAllInterposeStdMaintain("0",pageSize.toString());
}


/**
 * 
 * 添加
 * 
 * */
protected function toolbar_toolEventAddHandler(event:Event):void
{
	var interpose:InterposeStdMaintainTitle = new InterposeStdMaintainTitle();
	PopUpManager.addPopUp(interpose,Application.application as DisplayObject,true);
	PopUpManager.centerPopUp(interpose);
	interpose.title = "添加";
	interpose.interpose_type = interposetype;
	interpose.interpose_typeid = interposetypeid;
	interpose.fault_type = faulttype;
	interpose.fault_typeid = faulttypeid;
	interpose.init();
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
		var interpose:InterposeStdMaintainTitle = new InterposeStdMaintainTitle();
		PopUpManager.addPopUp(interpose,Application.application as DisplayObject,true);
		PopUpManager.centerPopUp(interpose);
		interpose.title = "修改";
		interpose.interposeData = dg.selectedItem;
		interpose.interpose_id=interposeid;
		interpose.interpose_type = interposetype;
		interpose.interpose_typeid = interposetypeid;
		interpose.fault_type = faulttype;
		interpose.fault_typeid = faulttypeid;
		interpose.setData();
		interpose.init();
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
		remoteObject.delInterposeMaintainProc(dg.selectedItem);
		remoteObject.addEventListener(ResultEvent.RESULT,delInterposeMaintainProcResult);
		Application.application.faultEventHandler(remoteObject);
	}
}

public function delInterposeMaintainProcResult(event:ResultEvent):void{
	if(event.result.toString()=="success")
	{
		ModelLocator.showSuccessMessage("删除成功!",this);
		this.getAllInterposeStdMaintain("0",pageSize.toString());
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
	var interpose:InterposeStdMaintainTitle = new InterposeStdMaintainTitle();
	PopUpManager.addPopUp(interpose,Application.application as DisplayObject,true);
	PopUpManager.centerPopUp(interpose);
	interpose.isShow = true;
	interpose.isRequired=false;
	interpose.getInterposeType();
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
}

/**
 * 
 * 添加快捷方式
 * 
 * */
protected function toolbar_toolEventAddShortcutHandler(event:Event):void
{
	parentApplication.addShorcut('标准处理过程','nowalarm');
}

/**
 * 
 * 删除快捷方式
 * 
 * */
protected function toolbar_toolEventDelShortcutHandler(event:Event):void
{
	parentApplication.delShortcut('标准处理过程');
}
/**
 * 点击列头对查询的所有结果进行排序  
 * */
protected function dg_headerReleaseHandler(event:DataGridEvent):void
{
	var dg:DataGrid = DataGrid(event.currentTarget);
	var dgm:DataGridColumn = dg.columns[event.columnIndex];
	var columnName:String=dgm.dataField;
	if(columnName=="interposetype"){
		columnName="I_INTERPOSE_TYPE";
	}
	if(columnName=="faulttype"){
		columnName="I_FAULT_TYPE";
	}
	if(columnName=="operateorder"){
		columnName="operate_order";
	}
	if(columnName=="operatetype"){
		columnName="operate_type";
	}
	if(columnName=="isendoperate"){
		columnName="is_end_oper";
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


