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
import sourceCode.resManager.resNode.Events.StationSearchEvent;
import sourceCode.resManager.resNet.events.topolinkSearchEvent;
import sourceCode.resManager.resNode.Titles.StationSearch;
import sourceCode.resManager.resNode.Titles.StationSearch;
import sourceCode.resManager.resNet.titles.TopoLinkSearch;
import sourceCode.resManager.resNet.titles.TopoLinkTtitle;
import sourceCode.resManager.resNet.model.TopoLink;

import twaver.DemoUtils;
import twaver.SequenceItemRenderer;

private var pageIndex:int=0;
private var pageSize:int=50;
private var datanumbers:int;

private var indexRenderer:Class = SequenceItemRenderer;
public var e2Oracle:DataImportFirstStep = new DataImportFirstStep();

[Bindable] public var xmlSystemCode:XMLList;
[Bindable] public var xmlLineRate:XMLList;


private var topolinkModel:TopoLink = new TopoLink();
private var dir:Boolean = true; //排序方式   true 升序 ，false 降序
private var sortName:String =""; //当前排序的列名
private var isEdit:Boolean = false;
private var isAdd:Boolean = false;
private var isDelete:Boolean = false;
private var isSearch:Boolean = true;
private var isExport:Boolean = false;
private var isImport:Boolean = false
/**
 *初始化进行 
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
//			if(model.oper_name!=null&&model.oper_name=="修改操作"){
//				isEdit = true;
//			}
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
	serverPagingBar.dataGrid=dg;
	serverPagingBar.pagingFunction=pagingFunction;
	serverPagingBar.addEventListener("returnALL",showAllDataHandler);
	getTopoLink("0",pageSize.toString());
	getSystemcode();
	getLineRate();
	var contextMenu:ContextMenu=new ContextMenu();
	dg.contextMenu=contextMenu;
	dg.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,function(e:ContextMenuEvent):void{
		var item1:ContextMenuItem = new ContextMenuItem("添 加", true);
		item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, toolbar_toolEventAddHandler);
		var item4:ContextMenuItem = new ContextMenuItem("查 询", true);
		item4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, toolbar_toolEventSearchHandler);
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
			
//			var item2:ContextMenuItem = new ContextMenuItem("修 改");
//			item2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, toolbar_toolEventEditHandler);
			var item3:ContextMenuItem = new ContextMenuItem("删 除 ", true);
			item3.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, toolbar_toolEventDeleteHandler);
//			item2.visible = isEdit;
			item3.visible = isDelete;
			dg.contextMenu.hideBuiltInItems();
			dg.contextMenu.customItems = [item1,item3,item4];
		}
	})
}
/**
 *初始化，显示数据 
 * @param event
 * 
 */
private function showAllDataHandler(event:Event):void{
	getTopoLink("0",serverPagingBar.totalRecord.toString());
}

/**
 * 
 * 获取复用段信息
 * 
 * */
private function getTopoLink(start:String,end:String):void{
	var topoRO:RemoteObject=new RemoteObject("resNetDwr");
	topolinkModel.start = start;
	topolinkModel.end = end ;
	topoRO.addEventListener(ResultEvent.RESULT,resultTopoLinkHandler);
	Application.application.faultEventHandler(topoRO);
	topoRO.endpoint = ModelLocator.END_POINT;
	topoRO.showBusyCursor = true;
	topoRO.getTopoLink(topolinkModel); 
}
/**
 *获取复用段信息后的处理函数 
 * @param event
 * 
 */
public function resultTopoLinkHandler(event:ResultEvent):void{
	var result:ResultModel=event.result as ResultModel;
	this.datanumbers = result.totalCount;
	onResult(result);
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
/**
 *获取速率 
 * 
 */
private function getLineRate():void{
	var re:RemoteObject=new RemoteObject("resNetDwr");
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.addEventListener(ResultEvent.RESULT,resultLineRateHandler);
	Application.application.faultEventHandler(re);
	re.getLineRate(); 
	
}
/**
 * 获取速率后的处理函数
 * @param event
 * 
 */
public function resultLineRateHandler(event:ResultEvent):void{
	xmlLineRate = new XMLList(event.result);
}
/**
 *分页查询 
 * @param pageIndex
 * @param pageSize
 * 
 */
private function pagingFunction(pageIndex:int,pageSize:int):void{
	this.pageSize=pageSize;
	this.pageIndex = pageIndex;
	getTopoLink((pageIndex*pageSize).toString(),(pageIndex*pageSize+pageSize).toString());
}
/**
 * 数据条的操作
 * @param result
 * 
 */
public function onResult(result:ResultModel):void 
{	
	serverPagingBar.orgData=result.orderList;
	serverPagingBar.totalRecord=result.totalCount;
	serverPagingBar.dataBind(true);					
}
/**
 *刷新页面 
 * @param event
 * 
 */
private function RefreshTopoLink(event:Event):void{
	serverPagingBar.navigateButtonClick("firstPage");
}


/**
 * 
 * 添加
 * 
 * */
protected function toolbar_toolEventAddHandler(event:Event):void
{
	var topolinkTitle:TopoLinkTtitle = new TopoLinkTtitle();
	PopUpManager.addPopUp(topolinkTitle,Application.application as DisplayObject,true);
	PopUpManager.centerPopUp(topolinkTitle);
	topolinkTitle.cmbLineRate.dataProvider=xmlLineRate;
	topolinkTitle.aSystemcode.dataProvider=xmlSystemCode;
	topolinkTitle.zSystemcode.dataProvider=xmlSystemCode;
	topolinkTitle.title = "添加";
	topolinkTitle.addEventListener("RefreshDataGrid",RefreshTopoLink);
	init();
	
}
///**
// * 右键添加
// * @param event
// * 
// */
//private function contextMenuAdd(event:ContextMenuEvent):void{
//	
//	var topolinkTitle:TopoLinkTtitle = new TopoLinkTtitle();
//	PopUpManager.addPopUp(topolinkTitle,Application.application as DisplayObject,true);
//	PopUpManager.centerPopUp(topolinkTitle);
//	topolinkTitle.cmbLineRate.dataProvider=xmlLineRate;
//	topolinkTitle.cmbSystemcode.dataProvider=xmlSystemCode;
//	topolinkTitle.title = "添加";
//	topolinkTitle.addEventListener("RefreshDataGrid",RefreshTopoLink);
//	
//}
///**
// * 
// * 修改
// * 
// * */
protected function toolbar_toolEventEditHandler(event:Event):void
{
//	if(dg.selectedItem != null){
//		var topoLinkTitle:TopoLinkTtitle = new TopoLinkTtitle();
////		topoLinkTitle.enable = false;
//		PopUpManager.addPopUp(topoLinkTitle,Application.application as DisplayObject,true);
//		PopUpManager.centerPopUp(topoLinkTitle);
//		topoLinkTitle.setLineRate(xmlLineRate,dg.selectedItem.lineratecode);
//		topoLinkTitle.setSystemCode(xmlSystemCode,dg.selectedItem.systemcode);
//		topoLinkTitle.title = "修改";
//		topoLinkTitle.topoLinkData = dg.selectedItem;
//		topoLinkTitle.addEventListener("RefreshDataGrid",RefreshTopoLink);
//	}else{
//		Alert.show("请先选中一条记录！","提示");
//	}
//	
}
///**
// *右键修改 
// * @param event
// * 
// */
//
//private function contextMenuUpdate(event:ContextMenuEvent):void
//{
//	
//	if(dg.selectedItem != null){
//		var topoLinkTitle:TopoLinkTtitle = new TopoLinkTtitle();
//		topoLinkTitle.enable = false;
//		PopUpManager.addPopUp(topoLinkTitle,Application.application as DisplayObject,true);
//		PopUpManager.centerPopUp(topoLinkTitle);
//		topoLinkTitle.setLineRate(xmlLineRate,dg.selectedItem.lineratecode);
//		topoLinkTitle.setSystemCode(xmlSystemCode,dg.selectedItem.systemcode);
//		topoLinkTitle.title = "修改";
//		topoLinkTitle.topoLinkData = dg.selectedItem;
//		
//		topoLinkTitle.addEventListener("RefreshDataGrid",RefreshTopoLink);
//	}else{
//		Alert.show("请先选中一条记录！","提示");
//	}
//	
//}

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
///**
// *右键删除 
// * @param event
// * 
// */
//private function contextMenuDelete(event:ContextMenuEvent):void
//{
//	
//	if(dg.selectedItem != null){
//		Alert.show("您确认要删除吗？","请您确认！",Alert.YES|Alert.NO,this,delconfirmHandler,null,Alert.NO);
//	}else{
//		Alert.show("请先选中一条记录！","提示");
//	}
//	
//}
/**
 *确认删除 
 * @param event
 * 
 */
private function delconfirmHandler(event:CloseEvent):void {
	if (event.detail == Alert.YES) {
		var remoteObject:RemoteObject=new RemoteObject("resNetDwr");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		remoteObject.delTopoLink(dg.selectedItem);
		remoteObject.addEventListener(ResultEvent.RESULT,delTopolinkResult);
		Application.application.faultEventHandler(remoteObject);
	}
}
/**
 *确认删除后的界面提示 
 * @param event
 * 
 */
public function delTopolinkResult(event:ResultEvent):void{
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
	var topolinkSearch:TopoLinkSearch = new TopoLinkSearch();
	PopUpManager.addPopUp(topolinkSearch,Application.application as DisplayObject,true);
	PopUpManager.centerPopUp(topolinkSearch);
	topolinkSearch.cmbLineRate.dataProvider=xmlLineRate;
	topolinkSearch.cmbLineRate.selectedIndex=-1;
	topolinkSearch.addEventListener("topolinkSearchEvent",topolinkSearchHandler);
	topolinkSearch.title = "查询";
}
///**
// *右键查询 
// * @param event
// * 
// */
//private  function contextMenuSearch(event:ContextMenuEvent):void
//{
//	var topolinkSearch:TopoLinkSearch = new TopoLinkSearch();
//	PopUpManager.addPopUp(topolinkSearch,Application.application as DisplayObject,true);
//	PopUpManager.centerPopUp(topolinkSearch);
//	topolinkSearch.cmbLineRate.dataProvider=xmlLineRate;
//	topolinkSearch.cmbLineRate.selectedIndex=-1;
//	topolinkSearch.cmbSystemcode.dataProvider=xmlSystemCode;
//	topolinkSearch.cmbSystemcode.selectedIndex=-1;
//	topolinkSearch.addEventListener("topolinkSearchEvent",topolinkSearchHandler);
//	topolinkSearch.title = "查询";
//}
/**
 *查询的处理函数 
 * @param event
 * 
 */
protected function topolinkSearchHandler(event:topolinkSearchEvent):void{
	topolinkModel = event.model;
	topolinkModel.start = "0";
	topolinkModel.end = pageSize.toString();
	topolinkModel.dir = "asc";
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
	e2Oracle.setTemplateType("复用段");
}

/**
 * 
 * 导出
 * 
 * */
protected function toolbar_toolEventEmpExcelHandler(event:Event):void
{
	var fefs:FileExportFirstStep = new FileExportFirstStep();
	var model:TopoLink = new TopoLink();
	var remote:RemoteObject = new RemoteObject("resNetDwr");
	fefs.dataNumber = this.datanumbers;
	fefs.exportTypes = "复用段";
	fefs.titles = new Array("序号","A端设备","Z端设备","A端传输系统","Z端传输系统", "速率", "A端端口", "Z端端口","长度","备注","更新时间");
	fefs.labels = "复用段列表";
	model = topolinkModel;
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
	parentApplication.addShorcut('复用段','topolink');
}

/**
 * 
 * 删除快捷方式
 * 
 * */
protected function toolbar_toolEventDelShortcutHandler(event:Event):void
{
	parentApplication.delShortcut('复用段');
}
///**
// *双击修改 
// * @param evnet
// * 
// */
//private function gridDoubleClick(evnet:Event):void
//{
//	
//	if(dg.selectedItem!=null){
//		
//		var topoLinkTitle:TopoLinkTtitle = new TopoLinkTtitle();
//		topoLinkTitle.enable = false;
//		PopUpManager.addPopUp(topoLinkTitle,Application.application as DisplayObject,true);
//		PopUpManager.centerPopUp(topoLinkTitle);
//		topoLinkTitle.setLineRate(xmlLineRate,dg.selectedItem.lineratecode);
//		topoLinkTitle.setSystemCode(xmlSystemCode,dg.selectedItem.systemcode);
//		topoLinkTitle.title = "修改";
//		topoLinkTitle.topoLinkData = dg.selectedItem;
//		
//		topoLinkTitle.addEventListener("RefreshDataGrid",RefreshTopoLink);
//	}else{
//		Alert.show("请先选中一条记录！","提示");
//	}
//	
//} 

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
	topolinkModel.sort = columnName;
	topolinkModel.start="0";
	topolinkModel.end=pageSize.toString();
	if(sortName == columnName){
		if(dir){
			topolinkModel.dir="asc";
			dir=false;
		}else{
			topolinkModel.dir="desc";
			dir=true;
		}
	}else{
		sortName=columnName;
		dir = false;
		topolinkModel.dir="asc";
	}
	serverPagingBar.navigateButtonClick("firstPage");
}
