// ActionScript file
import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.actionscript.Registry;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.events.CloseEvent;
import mx.events.DataGridEvent;
import mx.events.FlexEvent;
import mx.events.ItemClickEvent;
import mx.formatters.DateFormatter;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;
import mx.utils.ObjectProxy;

import net.digitalprimates.fluint.unitTests.frameworkSuite.testCases.TestASComponentUse;

import org.flexunit.runner.Result;

import sourceCode.autoGrid.view.ShowProperty;
import sourceCode.autoGrid.view.pp_test;
import sourceCode.autoGrid.view.modify_window;
import sourceCode.resManager.resNode.Events.FibersSearchEvent;
import sourceCode.resManager.resNode.Events.ModifyEvent;
import sourceCode.resManager.resNode.Titles.FibersSearch;
import sourceCode.resManager.resNode.Titles.SearchEquipByStationTitle;
import sourceCode.resManager.resNode.Titles.SearchSlotTitle;
import sourceCode.resManager.resNode.Titles.SelectOcableTitle;
import sourceCode.resManager.resNode.model.Fiber;
import sourceCode.resManager.resNode.model.Testframe;
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

[Bindable] public var propertyList:XMLList;
[Bindable] public var xmlFiberStatus:XMLList;
private var fiberModel:Fiber = new Fiber();
private var testframe:Testframe = new Testframe();
private var dir:Boolean = true; //排序方式   true 升序 ，false 降序
private var sortName:String =""; //当前排序的列名
private var isEdit:Boolean = true;
private var isAdd:Boolean = true;
private var isDelete:Boolean = true;
private var isSearch:Boolean = true;
private var isExport:Boolean = false;
private var isImport:Boolean = false;

public var a_station:String = "";
public var z_station:String = "";
public var modelName:String = "光纤";

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
	serverPagingBar.dataGrid=dg;
	serverPagingBar.pagingFunction=pagingFunction;
	serverPagingBar.addEventListener("returnALL",showAllDataHandler);
	getFibers("0",pageSize.toString());
	//getProperty();
	//getFiberStatus();
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
			toolbar_toolEventEditHandler_test(new ToopEvent("toolEventEdit"));
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
	getFibers("0",serverPagingBar.totalRecord.toString());
}

/**
 * 
 * 获取光缆信息
 * 
 * */
private function getFibers(start:String,end:String):void{
	var ocablecode:String=Registry.lookup("ocablecode");
	Registry.unregister("ocablecode");
	if(ocablecode!=null&&ocablecode!=""){
		fiberModel.ocablecode=ocablecode;
	}
	
	var roFibers:RemoteObject=new RemoteObject("resNodeDwr");
	fiberModel.start = start;
	fiberModel.end = end ;
	testframe.start=start;
	testframe.end=end;
	roFibers.addEventListener(ResultEvent.RESULT,resultFibersHandler);
	Application.application.faultEventHandler(roFibers);
	roFibers.endpoint = ModelLocator.END_POINT;
	roFibers.showBusyCursor = true;
	//roFibers.getFibers(fiberModel);
	roFibers.gettestFibers(testframe);
}

public function resultFibersHandler(event:ResultEvent):void{
	var result:ResultModel=event.result as ResultModel;
	this.datanumbers = result.totalCount;
	onResult(result);
}


private function getProperty():void{
	var rtobj12:RemoteObject = new RemoteObject("resNodeDwr");
	rtobj12.endpoint = ModelLocator.END_POINT;
	rtobj12.showBusyCursor = true;
	rtobj12.getFromXTBM('XZ0701__');//根据系统编码查询对应信息(维护供电局 单位)
	rtobj12.addEventListener(ResultEvent.RESULT, function(e:ResultEvent):void{
		propertyList = new XMLList(e.result)
	})
	Application.application.faultEventHandler(rtobj12);
}

private function getFiberStatus():void{
	var rtobj12:RemoteObject = new RemoteObject("resNodeDwr");
	rtobj12.endpoint = ModelLocator.END_POINT;
	rtobj12.showBusyCursor = true;
	rtobj12.getFromXTBM('ZY130703__');//根据系统编码查询对应信息(光纤状态)
	rtobj12.addEventListener(ResultEvent.RESULT, function(e:ResultEvent):void{
		xmlFiberStatus = new XMLList(e.result)
	})
	Application.application.faultEventHandler(rtobj12);
}

private function pagingFunction(pageIndex:int,pageSize:int):void{
	this.pageSize=pageSize;
	this.pageIndex=pageIndex;
	getFibers((pageIndex*pageSize).toString(),(pageIndex*pageSize+pageSize).toString());
}

public function onResult(result:ResultModel):void 
{	
	serverPagingBar.orgData=result.orderList;
	serverPagingBar.totalRecord=result.totalCount;
	serverPagingBar.dataBind(true);					
}

private function RefreshFibers(event:Event):void{
	getFibers("0",pageSize.toString());
}


/**
 * 
 * 添加
 * 
 * */
protected function toolbar_toolEventAddHandler(event:Event):void
{
	var temp:Testframe=new Testframe();
	var test:pp_test=new pp_test(); 
	PopUpManager.addPopUp(test,this); 
	PopUpManager.centerPopUp(test); 
	test.title="添加";
	test.addEventListener("ModifyEvent",addHandler);
}
private function addHandler(event:ModifyEvent):void {
	//Alert.show("in use");
	this.getFibers("0",pageSize.toString());
}

private function getAportAndZportByOcablecode(ocablecode:String):void{
	var rt:RemoteObject=new RemoteObject("resNodeDwr");
	rt.endpoint=ModelLocator.END_POINT;
	rt.showBusyCursor=true;
	rt.addEventListener(ResultEvent.RESULT,getAportAndZportByOcablecodeHandler);
	rt.getAportAndZportByOcablecode(ocablecode);
}
private function getAportAndZportByOcablecodeHandler(event:ResultEvent):void{
	if(event.result!=null){
		var arr:Array = event.result.toString().split(";");
		a_station = arr[0];
		z_station = arr[1];
		
	}
}

/**
 * 
 * 修改
 * 
 * */
//this is not used
protected function toolbar_toolEventEditHandler_test(event:Event):void
{
	if(dg.selectedItem != null){
		var temp:Testframe=new Testframe();
		var test:pp_test=new pp_test(); 
		
		temp.ocablename=dg.selectedItem.getOcablename();
		//temp.aendeqport=dg.selectedItem.ae;
		
		//test.tframe=;
		//	tw.owner = this; 
		PopUpManager.addPopUp(test,this); 
		PopUpManager.centerPopUp(test); 
		
	}else{
		Alert.show("请先选中一条记录！","提示");
	}
	
}


protected function toolbar_toolEventEditHandler(event:Event):void
{
	var remoteObject:RemoteObject=new RemoteObject("resNodeDwr");
	remoteObject.endpoint = ModelLocator.END_POINT;
	remoteObject.showBusyCursor = true;
	remoteObject.get_param_from_selecteditem(dg.selectedItem);
	remoteObject.addEventListener(ResultEvent.RESULT,modify_reuslt);
	Application.application.faultEventHandler(remoteObject);
}
public function modify_reuslt(event:ResultEvent):void{
	var handler:Array;
	handler=event.result.toString().split(";;");
	var test:modify_window=new modify_window(); 
	test.stp=handler;
	test.owner = this;
	PopUpManager.addPopUp(test,this); 
	PopUpManager.centerPopUp(test); 
	test.addEventListener("ModifyEvent",modHandler);
	/*if(event.result.toString()=="success")
	{
	ModelLocator.showSuccessMessage("删除成功!",this);
	this.getFibers("0",pageSize.toString());
	}else
	{
	ModelLocator.showErrorMessage("删除失败!",this);
	}*/
	//Alert.show(event.result.toString());
}

private function modHandler(event:ModifyEvent):void {
	//Alert.show("in use");
	this.getFibers((pageIndex*pageSize).toString(),(pageIndex*pageSize+pageSize).toString());
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
		var remoteObject:RemoteObject=new RemoteObject("resNodeDwr");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		//	remoteObject.delFiber(dg.selectedItem);
		remoteObject.delFibertest(dg.selectedItem);
		remoteObject.addEventListener(ResultEvent.RESULT,delFibersResult);
		Application.application.faultEventHandler(remoteObject);
	}
}

public function delFibersResult(event:ResultEvent):void{
	if(event.result.toString()=="success")
	{
		ModelLocator.showSuccessMessage("删除成功!",this);
		//this.getFibers("0",pageSize.toString());
		this.getFibers((pageIndex*pageSize).toString(),(pageIndex*pageSize+pageSize).toString());
	}else
	{
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
	var fibersSearch:FibersSearch = new FibersSearch();
	PopUpManager.addPopUp(fibersSearch,Application.application as DisplayObject,true);
	PopUpManager.centerPopUp(fibersSearch);
	
	/*fibersSearch.cmbStatus.dataProvider = xmlFiberStatus.children();
	fibersSearch.cmbStatus.selectedIndex = -1;
	
	
	fibersSearch.cmbProperty.dataProvider = propertyList.children();
	fibersSearch.cmbProperty.selectedIndex = -1;*/
	
	fibersSearch.addEventListener("fibersSearchEvent",fibersSearchHandler);
	fibersSearch.title = "查询";
}


protected function fibersSearchHandler(event:FibersSearchEvent):void{
	testframe = event.model;
	testframe.start="0";
	testframe.dir="asc";
	testframe.end=pageSize.toString();
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
	e2Oracle.setTemplateType("光纤");
}

/**
 * 
 * 导出
 * 
 * */
protected function toolbar_toolEventEmpExcelHandler(event:Event):void
{
	var fefs:FileExportFirstStep = new FileExportFirstStep();
	var model:Fiber = new Fiber();
	fefs.dataNumber = this.datanumbers;
	fefs.exportTypes = "光纤";
	fefs.titles = new Array("序号","光缆名称","光纤序号", "长度","A端端口","Z端端口",  "维护单位","光路业务","复用段业务", "更新时间");;
	fefs.labels = "光纤信息列表";
	model = fiberModel;
	model.start="0";
	model.end = this.datanumbers.toString();
	fefs.model = model;
	MyPopupManager.addPopUp(fefs, true);
}

/**
 * 
 * 添加快捷方式
 * 
 * */
protected function toolbar_toolEventAddShortcutHandler(event:Event):void
{
	parentApplication.addShorcut('光缆','businessRess');
}

/**
 * 
 * 删除快捷方式
 * 
 * */
protected function toolbar_toolEventDelShortcutHandler(event:Event):void
{
	parentApplication.delShortcut('光缆');
}
/**
 * 点击列头对查询的所有结果进行排序  
 * */
protected function dg_headerReleaseHandler(event:DataGridEvent):void
{
	var dg:DataGrid = DataGrid(event.currentTarget);
	var dgm:DataGridColumn = dg.columns[event.columnIndex];
	var columnName:String=dgm.dataField;
	event.stopImmediatePropagation(); //阻止其自身的排序
	fiberModel.sort = columnName;
	fiberModel.start="0";
	fiberModel.end=pageSize.toString();
	if(sortName == columnName){
		if(dir){
			fiberModel.dir="asc";
			dir=false;
		}else{
			fiberModel.dir="desc";
			dir=true;
		}
	}else{
		sortName=columnName;
		dir = false;
		fiberModel.dir="asc";
	}
	serverPagingBar.navigateButtonClick("firstPage");
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