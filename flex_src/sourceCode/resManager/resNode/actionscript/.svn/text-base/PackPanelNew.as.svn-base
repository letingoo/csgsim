// ActionScript file
import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;

import flash.ui.ContextMenuItem;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.events.CloseEvent;
import mx.events.DataGridEvent;
import mx.events.FlexEvent;
import mx.events.ItemClickEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;
import mx.utils.ObjectProxy;

import org.flexunit.runner.Result;

import sourceCode.systemManagement.model.PermissionControlModel;
import sourceCode.tableResurces.model.ResultModel;
import sourceCode.tableResurces.views.DataImportFirstStep;
import sourceCode.tableResurces.views.FileExportFirstStep;
import sourceCode.tableResurces.Events.ToopEvent;
import sourceCode.resManager.resNode.Events.PackSearchEvent;
import sourceCode.resManager.resNode.Titles.PackSearch;
import sourceCode.resManager.resNode.Titles.PackTitle;
import sourceCode.resManager.resNode.model.Pack;

import twaver.DemoUtils;
import twaver.SequenceItemRenderer;

private var pageIndex:int=0;
private var pageSize:int=50;
private var datanumbers:int;

private var indexRenderer:Class = SequenceItemRenderer;
public var e2Oracle:DataImportFirstStep = new DataImportFirstStep();

[Bindable] public var xmlVendor:XMLList;
[Bindable] public var xmlTransystem:XMLList;

private var packModel:Pack = new Pack();
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
 *初始化 
 * 
 */
protected function init():void
{
	var contextMenu:ContextMenu=new ContextMenu();
	dg.contextMenu=contextMenu;
	dg.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,function(e:ContextMenuEvent):void{
		var item1:ContextMenuItem=new ContextMenuItem("添 加", true);
		item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
		var item4:ContextMenuItem=new ContextMenuItem("查 询", true);
		item4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
		item1.visible = isAdd;
		item4.visible = isSearch;
		if (dg.selectedItems.length > 0)
		{
			dg.selectedItem=dg.selectedItems[0];
		}
		//定制右键菜单
		var flexVersion:ContextMenuItem=new ContextMenuItem(DemoUtils.FLEX_SDK_VERSION, false, false);
		var playerVersion:ContextMenuItem=new ContextMenuItem(DemoUtils.FLASH_PLAYER_VERSION, false, false);
		
		if (dg.selectedItems.length == 0)
		{ //选中元素个数
			dg.contextMenu.hideBuiltInItems();
			dg.contextMenu.customItems=[item1, item4];
		}
		else
		{
			var item2:ContextMenuItem=new ContextMenuItem("修 改");
			item2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
			var item3:ContextMenuItem=new ContextMenuItem("删 除", true);
			item3.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
			item2.visible = isEdit;
			item3.visible = isDelete;
			dg.contextMenu.hideBuiltInItems();
			dg.contextMenu.customItems=[item1, item2, item3, item4];
		}
	});
	serverPagingBar.dataGrid=dg;
	serverPagingBar.pagingFunction=pagingFunction;
	serverPagingBar.addEventListener("returnALL",showAllDataHandler);
	getEquipPack("0",pageSize.toString());
	
//	serverPagingBar.addEventListener("viewAllEvent",Queryall);
}
//private var queryType:Boolean = true;
//private function Queryall(event:Event):void{
//	queryType = false;
//}

/**
 *右键的相应处理 
 * @param e
 * 
 */
public function itemSelectHandler(e:ContextMenuEvent):void{
	switch(e.target.caption){
		case "添 加":
			toolbar_toolEventAddHandler();
			break;
		case "修 改":
			toolbar_toolEventEditHandler();
			break;
		case "删 除":
			toolbar_toolEventDeleteHandler();
			break;
		case "查 询":
			toolbar_toolEventSearchHandler();
			break;
		default:
			break;
	}
}
/**
 *初始化进入，查询所有数据 
 * @param event
 * 
 */
private function showAllDataHandler(event:Event):void{
	getEquipPack("0",serverPagingBar.totalRecord.toString());
}

/**
 * 
 * 获取机盘信息
 * 
 * */
private function getEquipPack(start:String,end:String):void{
	var packrt:RemoteObject=new RemoteObject("resNodeDwr");
	packModel.start = start;
	packModel.end = end ;
	packrt.addEventListener(ResultEvent.RESULT,resultPackHandler);
	Application.application.faultEventHandler(packrt);
	packrt.endpoint = ModelLocator.END_POINT;
	packrt.showBusyCursor = true;
	packrt.getEquipPack(packModel); 
}
/**
 *获取机盘数据后的相应操作 
 * @param event
 * 
 */
public function resultPackHandler(event:ResultEvent):void{
	var result:ResultModel=event.result as ResultModel;
	this.datanumbers = result.totalCount;
	onResult(result);
}




/**
 *分页显示 
 * @param pageIndex
 * @param pageSize
 * 
 */
private function pagingFunction(pageIndex:int,pageSize:int):void{
	this.pageSize=pageSize;
	this.pageIndex = pageIndex;
	getEquipPack((pageIndex*pageSize).toString(),(pageIndex*pageSize+pageSize).toString());
}
/**
 *页面下侧的数据条操作 
 * @param result
 * 
 */
public function onResult(result:ResultModel):void 
{	
	serverPagingBar.orgData=result.orderList;
	serverPagingBar.totalRecord=result.totalCount;
//	if(queryType){
//		serverPagingBar.pageSize = 20; 
//		serverPagingBar.isInit = true;
//	}		
	serverPagingBar.dataBind(true);					
}

private function RefreshPack(event:Event):void{
	serverPagingBar.navigateButtonClick("firstPage");
}


/**
 * 
 * 添加
 * 
 * */
protected function toolbar_toolEventAddHandler(event:Event=null):void
{
	var packTitle:PackTitle = new PackTitle();
	PopUpManager.addPopUp(packTitle,Application.application as DisplayObject,true);
	PopUpManager.centerPopUp(packTitle);
	packTitle.title = "添加";
//	packTitle.getVendor();
	packTitle.addEventListener("RefreshDataGrid",RefreshPack);
	
}

/**
 * 
 * 修改
 * 
 * */
protected function toolbar_toolEventEditHandler(event:Event=null):void
{
	if(dg.selectedItem != null){
		var packTitle:PackTitle = new PackTitle();
		PopUpManager.addPopUp(packTitle,Application.application as DisplayObject,true);
		PopUpManager.centerPopUp(packTitle);
		packTitle.title = "修改";
		packTitle.cmbEquipframe.enabled=false;
//		packTitle.cmbVendor.enabled=false;
//		packTitle.cmbTransystem.enabled=false;
		packTitle.cmbEquipment.enabled=false;
		packTitle.cmbEquipSlot.enabled=false;
		packTitle.cmbPackmodel.enabled=false;
		packTitle.packData = dg.selectedItem;
		//add by xgyin
		packTitle.getEquipCodeByName(dg.selectedItem.equipname);
		packTitle.addEventListener("RefreshDataGrid",RefreshPack);
	}else{
		Alert.show("请先选中一条记录！","提示");
	}
	
}

/**
 * 
 * 删除
 * 
 * */
protected function toolbar_toolEventDeleteHandler(event:Event=null):void
{
	if(dg.selectedItem != null){

		Alert.show("您确认要删除吗？","请您确认！",Alert.YES|Alert.NO,this,delconfirmHandler,null,Alert.NO);
	}else{
		Alert.show("请先选中一条记录！","提示");
	}
}
/**
 *确认删除的操作 
 * @param event
 * 
 */
private function delconfirmHandler(event:CloseEvent):void {
	if (event.detail == Alert.YES) {
		var remoteObject:RemoteObject=new RemoteObject("resNodeDwr");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		remoteObject.delEquipPack(dg.selectedItem);
		remoteObject.addEventListener(ResultEvent.RESULT,delEquipPackResult);
		Application.application.faultEventHandler(remoteObject);
	}
}
/**
 *删除后的界面提示 ，并刷新界面
 * @param event
 * 
 */
public function delEquipPackResult(event:ResultEvent):void{
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
protected function toolbar_toolEventSearchHandler(event:Event=null):void
{
	var packSearch:PackSearch = new PackSearch();
	PopUpManager.addPopUp(packSearch,Application.application as DisplayObject,true);
	PopUpManager.centerPopUp(packSearch);
	packSearch.addEventListener("packSearchEvent",packSearchHandler);
	packSearch.title = "查询";
}
/**
 *查询界面操作后，将保存的条件传给分页处理函数进行查询 
 * @param event
 * 
 */
protected function packSearchHandler(event:PackSearchEvent):void{
//	queryType = true;
	packModel = event.model;
	packModel.start= "0";
	packModel.dir="asc";
	packModel.end = pageSize.toString();
//	packModel.end = "20";
	serverPagingBar.navigateButtonClick("firstPage");
//	pagingFunction(0,20);
//	getEquipPack("0","20");
}

/**
 * 
 * 导入
 * 
 * */
protected function toolbar_toolEventImpExcelHandler(event:Event):void
{
	MyPopupManager.addPopUp(e2Oracle,true);
	e2Oracle.setTemplateType("机盘");
}

/**
 * 
 * 导出
 * 
 * */
protected function toolbar_toolEventEmpExcelHandler(event:Event):void
{
	var fefs:FileExportFirstStep = new FileExportFirstStep();
	var model:Pack = new Pack();
	fefs.dataNumber = this.datanumbers;
	fefs.exportTypes = "机盘";
	fefs.titles = new Array("设备名称", "机框序号", "机槽序号", "机盘序号", "机盘型号", "更新时间");;
	fefs.labels = "机盘信息列表";
	model = packModel;
	model.start = "0";
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
	parentApplication.addShorcut('机盘','equippack');
}

/**
 * 
 * 删除快捷方式
 * 
 * */
protected function toolbar_toolEventDelShortcutHandler(event:Event):void
{
	parentApplication.delShortcut('机盘');
}
/**
 *列表数据的排序处理 
 * @param event
 * 
 */
protected function dg_headerReleaseHandler(event:DataGridEvent):void
{
	var dg:DataGrid = DataGrid(event.currentTarget);
	var dgm:DataGridColumn = dg.columns[event.columnIndex];
	var columnName:String=dgm.dataField;
	event.stopImmediatePropagation(); //阻止其自身的排序
	packModel.sort = columnName;
	packModel.start="0";
	packModel.end=pageSize.toString();
	if(columnName === "frameserial" || columnName == "slotserial" ||  columnName == "packserial"){ //处理数字类型的排序
		packModel.isNumber =columnName;
	}else{
		packModel.isNumber = "";
	}
	if(sortName == columnName){
		if(dir){
			packModel.dir="asc";
			dir=false;
		}else{
			packModel.dir="desc";
			dir=true;
		}
	}else{
		sortName=columnName;
		dir = false;
		packModel.dir="asc";
	}
	serverPagingBar.navigateButtonClick("firstPage");
}