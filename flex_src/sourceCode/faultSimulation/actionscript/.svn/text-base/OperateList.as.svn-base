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
import sourceCode.faultSimulation.model.OperateListEvent;
import sourceCode.faultSimulation.model.OperateListModel;
import sourceCode.faultSimulation.titles.OperateSearch;
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
private var isSearch:Boolean = true;
private var isExport:Boolean = true;

public var modelName:String = "操作记录维护";
public var operateModel:OperateListModel = new OperateListModel();


protected function init():void
{
	serverPagingBar.dataGrid=dg;
	serverPagingBar.pagingFunction=pagingFunction;
	serverPagingBar.addEventListener("returnALL",showAllDataHandler);
	
	var rtobj:RemoteObject=new RemoteObject("faultSimulation");
	rtobj.endpoint= ModelLocator.END_POINT;
	rtobj.showBusyCursor=true;
	rtobj.isCruFaluter(parentApplication.curUser);        //告警右侧查询条件显示权限，方便维护人员，以后想增删查询条件只在数据库改就可以了
	rtobj.addEventListener(ResultEvent.RESULT,resultAllEventIsCruUser);
	
	addContextMenu();
}

public function resultAllEventIsCruUser(event:ResultEvent):void{
	var result:String = event.result.toString();
	
	if(result=="1")
	{
		getAllOperateListByUser("0",pageSize.toString());
		
	}else{
		
		operateModel.updateperson=parentApplication.curUser;
		operateModel.flag="1";
		getAllOperateListByUser("0",pageSize.toString());
		
	}
}
private function addContextMenu():void
{
	var contextMenu:ContextMenu=new ContextMenu();
	dg.contextMenu=contextMenu;
	dg.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,function(e:ContextMenuEvent):void{
		var item:ContextMenuItem = new ContextMenuItem("查 询", true);
		item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, toolbar_toolEventSearchHandler);
		item.visible = isSearch;
		if (dg.selectedItems.length> 0) {
			dg.selectedItem=dg.selectedItems[0];
		}
		//定制右键菜单
		var flexVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLEX_SDK_VERSION, false, false);
		var playerVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLASH_PLAYER_VERSION, false, false);
		
		dg.contextMenu.hideBuiltInItems();
		dg.contextMenu.customItems = [item];
	})
}


private function showAllDataHandler(event:Event):void{
	getAllOperateListByUser("0",serverPagingBar.totalRecord.toString());
}

/**
 * 
 * 获取操作列表
 * 
 * */
private function getAllOperateListByUser(start:String,end:String):void{
	
	var re:RemoteObject=new RemoteObject("faultSimulation");
	operateModel.start = start;
	operateModel.end = end ;
	re.addEventListener(ResultEvent.RESULT,resultAllEventSolutionHandler);
	Application.application.faultEventHandler(re);
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.getAllOperateListByUser(operateModel);
}

public function resultAllEventSolutionHandler(event:ResultEvent):void{
	var result:ResultModel=event.result as ResultModel;
	onResult(result);
}

private function pagingFunction(pageIndex:int,pageSize:int):void{
	this.pageSize=pageSize;
	getAllOperateListByUser((pageIndex*pageSize).toString(),(pageIndex*pageSize+pageSize).toString());
}

public function onResult(result:ResultModel):void 
{	
	serverPagingBar.orgData=result.orderList;
	serverPagingBar.totalRecord=result.totalCount;
	datanumbers = result.totalCount;
	serverPagingBar.dataBind(true);					
}

private function RefreshDataGrid(event:Event):void{
	getAllOperateListByUser("0",pageSize.toString());
}

/**
 * 
 * 查询
 * 
 * */
protected function toolbar_toolEventSearchHandler(event:Event):void
{
	var operateSearch:OperateSearch = new OperateSearch();
	operateSearch.flag=operateModel.flag;
	operateSearch.curUser=parentApplication.curUserName;
	PopUpManager.addPopUp(operateSearch,Application.application as DisplayObject,true);
	PopUpManager.centerPopUp(operateSearch);
	operateSearch.addEventListener("OperateListEvent",InterposeSearchHandler);
	operateSearch.title = "查询";
}


protected function InterposeSearchHandler(event:OperateListEvent):void{
	operateModel = event.model;
	operateModel.start="0";
	operateModel.dir="asc";
	operateModel.end=pageSize.toString();
	serverPagingBar.navigateButtonClick("firstPage");
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
	operateModel.end = this.datanumbers.toString();				
	fefs.titles = new Array("序号","处理方法","处理结果","科目名称","本端设备类型","本端设备名称","对端设备类型",
		"对端设备名称","操作人","操作时间","备注");				
	fefs.exportTypes = "科目维护操作";
	fefs.labels = "科目维护操作信息列表";
	fefs.model = operateModel;
	MyPopupManager.addPopUp(fefs, this);
}


/**
 * 
 * 添加快捷方式
 * 
 * */
protected function toolbar_toolEventAddShortcutHandler(event:Event):void
{
	parentApplication.addShorcut('操作记录维护','alarmInfoHistory');
}

/**
 * 
 * 删除快捷方式
 * 
 * */
protected function toolbar_toolEventDelShortcutHandler(event:Event):void
{
	parentApplication.delShortcut('操作记录维护');
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
	}
	if(columnName=="projectname"){
		columnName="INTERPOSE_ID";
	}
	if(columnName=="a_equiptype"||columnName=="z_equiptype"){
		columnName="OPERATE_TYPE_ID";
	}
	if(columnName=="a_equipname"){
		columnName="A_EQUIPCODE";
	}
	if(columnName=="z_equipname"){
		columnName="Z_EQUIPCODE";
	}
	event.stopImmediatePropagation(); //阻止其自身的排序
	operateModel.sort = columnName;
	operateModel.start="0";
	operateModel.end=pageSize.toString();
	if(sortName == columnName){
		if(dir){
			operateModel.dir="asc";
			dir=false;
		}else{
			operateModel.dir="desc";
			dir=true;
		}
	}else{
		sortName=columnName;
		dir = false;
		operateModel.dir="asc";
	}
	serverPagingBar.navigateButtonClick("firstPage");
}


