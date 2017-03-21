// ActionScript file
import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;

import flash.ui.ContextMenuItem;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.CheckBox;
import mx.controls.ComboBox;
import mx.controls.DataGrid;
import mx.controls.dataGridClasses.DataGridColumn;
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

import org.flexunit.runner.Result;

import sourceCode.autoGrid.view.ShowProperty;
import sourceCode.resManager.resNode.Events.slotSearchEvent;
import sourceCode.resManager.resNode.Titles.FrameSlotSearch;
import sourceCode.resManager.resNode.Titles.SearchSlotTitle;
import sourceCode.resManager.resNode.Titles.ModifyFrameSlot;
import sourceCode.resManager.resNode.model.FrameSlot;
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
public var parent_page:Object;

private var indexRenderer:Class = SequenceItemRenderer;
public var e2Oracle:DataImportFirstStep = new DataImportFirstStep();
//状态列表
[Bindable] public var slot_stateLst:XMLList; 
//设备同步状态列表
[Bindable] public var sync_statusLst:XMLList;
//[Bindable] public var eqsearch:XMLList;
public var slotModel:FrameSlot = new FrameSlot();
private var dir:Boolean = true; //排序方式   true 升序 ，false 降序
private var sortName:String =""; //当前排序的列名
private var isEdit:Boolean = false;
private var isAdd:Boolean = false;
private var isDelete:Boolean = false;
private var isSearch:Boolean = true;
private var isExport:Boolean = false;
private var isImport:Boolean = false;
public var modelName:String = "机槽";
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
//			if(model.oper_name!=null&&model.oper_name=="添加操作"){
//				isAdd = true;
//			}
			if(model.oper_name!=null&&model.oper_name=="修改操作"){
				isEdit = true;
			}
//			if(model.oper_name!=null&&model.oper_name=="删除操作"){
//				isDelete = true;
//			}
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
	getFrameSlot("0",pageSize.toString());
//	获取状态列表
	getFrameSlotStatus();
	//获取设备同步状态列表
	getSlotSyncStatus();
	addContextMenu();
	
}

private function addContextMenu():void
{
	var contextMenu:ContextMenu=new ContextMenu();
	dg.contextMenu=contextMenu;
	dg.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,function(e:ContextMenuEvent):void{
//		var item1:ContextMenuItem = new ContextMenuItem("添 加", true);
//		item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
		var item4:ContextMenuItem = new ContextMenuItem("查 询", true);
		item4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
//		item1.visible = isAdd;
		item4.visible = isSearch;
		if (dg.selectedItems.length> 0) {
			dg.selectedItem=dg.selectedItems[0];
		}
		//定制右键菜单
		var flexVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLEX_SDK_VERSION, false, false);
		var playerVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLASH_PLAYER_VERSION, false, false);
		
		if(dg.selectedItems.length==0){//选中元素个数
			dg.contextMenu.hideBuiltInItems();
			dg.contextMenu.customItems = [item4];
		}
		else{
			
			var item2:ContextMenuItem = new ContextMenuItem("修 改");
			item2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
//			var item3:ContextMenuItem = new ContextMenuItem("删 除", true);
//			item3.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
			item2.visible = isEdit;
//			item3.visible = isDelete;
			dg.contextMenu.hideBuiltInItems();
			dg.contextMenu.customItems = [item2,item4];
		}
	})
}

private function itemSelectHandler(e:ContextMenuEvent):void{
	switch(e.target.caption){
//		case "添 加":
//			toolbar_toolEventAddHandler(new ToopEvent("toolEventAdd"));
//			break;
		case "修 改":
			toolbar_toolEventEditHandler(new ToopEvent("toolEventEdit"));
			break;
//		case "删 除":
//			toolbar_toolEventDeleteHandler(new ToopEvent("toolEventDelete"));
//			break;
		case "查 询":
			toolbar_toolEventSearchHandler(new ToopEvent("toolEventSearch"));
			break;
		default:
			break;
	}
}
/**
 *显示所有数据 
 * @param event
 * 
 */
private function showAllDataHandler(event:Event):void{
	getFrameSlot("0",serverPagingBar.totalRecord.toString());
}
/**
 *获取机框信息 
 * @param start
 * @param end
 * 
 */
private function getFrameSlot(start:String,end:String):void{
	var Framert:RemoteObject=new RemoteObject("resNodeDwr");
	slotModel.start = start;
	slotModel.end = end ;
	Framert.addEventListener(ResultEvent.RESULT,resultHandler);
	Application.application.faultEventHandler(Framert);
	Framert.endpoint = ModelLocator.END_POINT;
	Framert.showBusyCursor = true;
	Framert.getFrameSlot(slotModel);
}

public function resultHandler(event:ResultEvent):void{
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
	getFrameSlot((pageIndex*pageSize).toString(),(pageIndex*pageSize+pageSize).toString());
	this.pageIndex = pageIndex;
}
/**
 *页面下侧的数据条绑定 
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
 * 
 * 获取状态列表
 * 
 * */
private function getFrameSlotStatus():void{
	var re:RemoteObject=new RemoteObject("resNodeDwr");
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.addEventListener(ResultEvent.RESULT,resultStateLstHandler);
	Application.application.faultEventHandler(re);
	re.getFrameSlotStatus(); 
	
}

//获取状态列表
public function resultStateLstHandler(event:ResultEvent):void{
	slot_stateLst = new XMLList(event.result);
}
/**
 * 
 * 获取同步状态列表
 * 
 * */
private function getSlotSyncStatus():void{
	var re:RemoteObject=new RemoteObject("resNodeDwr");
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.addEventListener(ResultEvent.RESULT,resultModelLstHandler);
	Application.application.faultEventHandler(re);
	re.getFrameState(); 
	
}

//获取型号列表
public function resultModelLstHandler(event:ResultEvent):void{
	sync_statusLst = new XMLList(event.result);
}
/**
 *刷新页面 
 * @param event
 * 
 */
private function RefreshFrame(event:Event):void{
	serverPagingBar.navigateButtonClick("firstPage");
}

/**
 * 
 * 右键添加
 * 
 * */
private function toolbar_toolEventAdd(event:ContextMenuEvent):void{
	toolbar_toolEventAddHandler(null);
}
/**
 * 
 * 添加
 * 
 * */
protected function toolbar_toolEventAddHandler(event:Event):void{
//	var property:ShowProperty = new ShowProperty();
//	property.title = "添加";
//	property.paraValue = null;
//	property.tablename = "EQUIPSLOT";
//	property.key = "NAME_STD";
//	PopUpManager.addPopUp(property, this, true);
//	PopUpManager.centerPopUp(property);		
//	property.addEventListener("savePropertyComplete",function (event:Event):void{
//		PopUpManager.removePopUp(property);
//		
//		RefreshStation(event);});
//	
//	property.addEventListener("initFinished",function (event:Event):void{
//		(property.getElementById("UPDATEPERSON",property.propertyList) as mx.controls.TextInput).enabled = false;
//		(property.getElementById("UPDATEPERSON",property.propertyList) as mx.controls.TextInput).text = parentApplication.curUserName;
//		(property.getElementById("UPDATEDATE",property.propertyList) as mx.controls.TextInput).enabled = false;
//		(property.getElementById("UPDATEDATE",property.propertyList) as mx.controls.TextInput).text = getNowTime();
//		(property.getElementById("EQUIPNAME",property.propertyList) as mx.controls.TextInput).addEventListener(MouseEvent.CLICK,function(event:Object):void{
//			
//			property.dispatchEvent(new Event("changPicture"));
//			
//		});
//		property.addEventListener("changPicture",function (event:Object){
//			var packeqsearch:SearchSlotTitle=new SearchSlotTitle();
//			packeqsearch.page_parent=property;
//			packeqsearch.child_systemcode=null;
//			packeqsearch.child_vendor=null;
//			PopUpManager.addPopUp(packeqsearch,property,true);
//			PopUpManager.centerPopUp(packeqsearch);
//			packeqsearch.myCallBack=function(obj:Object){
//				var parent_equipcode:String=obj.name;//从子页面传过来的选的设备的code
//				var name:String = obj.id;
//				(property.getElementById("EQUIPCODE",property.propertyList) as mx.controls.TextInput).text=parent_equipcode;
//				(property.getElementById("EQUIPNAME",property.propertyList) as mx.controls.TextInput).text=name;
//				
//				var rt:RemoteObject=new RemoteObject("resNodeDwr");
//				rt.endpoint=ModelLocator.END_POINT;
//				rt.showBusyCursor=true;
//				rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent){
//					 var eqsearchLst:XMLList= new XMLList(event.result);
//					 (property.getElementById("FRAMESERIAL",property.propertyList) as mx.controls.ComboBox).dropdown.dataProvider=eqsearchLst;
//					 (property.getElementById("FRAMESERIAL",property.propertyList) as mx.controls.ComboBox).dataProvider=eqsearchLst;
//					 (property.getElementById("FRAMESERIAL",property.propertyList) as mx.controls.ComboBox).labelField="@label";
//					 (property.getElementById("FRAMESERIAL",property.propertyList) as mx.controls.ComboBox).text="";
//					 (property.getElementById("FRAMESERIAL",property.propertyList) as mx.controls.ComboBox).selectedIndex=-1;
//					 
//				});
//				rt.getFrameserialByeId(parent_equipcode);
//			 }
//		});
//	});
}


private function RefreshStation(event:Event):void{
	serverPagingBar.navigateButtonClick("firstPage");
}

/**
 * 
 * 右键修改
 * 
 * */
protected function toolbar_toolEventEdit(event:ContextMenuEvent):void{
	toolbar_toolEventEditHandler(null);
}
/**
 * 
 * 修改
 * 
 * */
protected function toolbar_toolEventEditHandler(event:Event):void{
	if(dg.selectedItems.length>0){
		var cit:ModifyFrameSlot = new ModifyFrameSlot();
		cit.title ='修改';
		PopUpManager.addPopUp(cit,this,true);
		PopUpManager.centerPopUp(cit);
		cit.equipcode.text = dg.selectedItem.equipcode;
		cit.equipname.text = dg.selectedItem.equipname;
		cit.slotserial.text = dg.selectedItem.slotserial;
		
		cit.status0.dropdown.dataProvider=slot_stateLst;
		cit.status0.dataProvider=slot_stateLst;
		cit.status0.labelField="@label";
		cit.status0.text="";
		cit.status0.selectedIndex=-1;
		cit.status0.text = dg.selectedItem.status;
		cit.status1.text = dg.selectedItem.state;
		
		cit.panellength.text = dg.selectedItem.panellength;
		cit.remark.text = dg.selectedItem.remark;
		cit.frameserial.text = dg.selectedItem.frameserial;
		cit.panelwidth.text = dg.selectedItem.panelwidth;
		
		cit.addEventListener("RefreshDataGrid",refreshHandle);
		
	}else{
		Alert.show("请先选中一条记录！","提示");
	}
}
private function refreshHandle(event:Event):void{
	serverPagingBar.navigateButtonClick("firstPage");
}
/**
 * 
 * 右键删除
 * 
 * */
protected function toolbar_toolEventDelete(event:ContextMenuEvent):void{
	toolbar_toolEventDeleteHandler(null);
}
/**
 * 
 * 删除
 * 
 * */
protected function toolbar_toolEventDeleteHandler(event:Event):void{
//	if(dg.selectedItem != null){
//			Alert.show("您确认要删除吗？","请您确认！",Alert.YES|Alert.NO,this,delconfirmHandler,null,Alert.NO);
//	}else{
//		Alert.show("请先选中一条记录！","提示");
//	}
}
/**
 *确认删除后的处理 
 * @param event
 * 
 */
private function delconfirmHandler(event:CloseEvent):void {
//	if (event.detail == Alert.YES) {
//		var remoteObject:RemoteObject=new RemoteObject("resNodeDwr");
//		remoteObject.endpoint = ModelLocator.END_POINT;
//		remoteObject.showBusyCursor = true;
//		remoteObject.delFrameSlot(dg.selectedItem);
//		remoteObject.addEventListener(ResultEvent.RESULT,delFrameResult);
//		Application.application.faultEventHandler(remoteObject);
//	}
}

//public function delFrameResult(event:ResultEvent):void{
//	if(event.result.toString()=="success")
//	{
//		Alert.show("删除成功！","提示");
//		serverPagingBar.navigateButtonClick("firstPage");
//	}else
//	{
//		Alert.show("删除失败！","提示");
//	}
//}

/**
 * 
 * 右键查询
 * 
 * */
protected function toolbar_toolEventSearch(event:ContextMenuEvent):void{
	toolbar_toolEventSearchHandler(null);
}
/**
 * 
 * 查询
 * 
 * */
protected function toolbar_toolEventSearchHandler(event:Event):void{
	var frameSearch:FrameSlotSearch = new FrameSlotSearch();
	PopUpManager.addPopUp(frameSearch,Application.application as DisplayObject,true);
	PopUpManager.centerPopUp(frameSearch);
	
	frameSearch.slot_status.dataProvider = slot_stateLst;
	frameSearch.slot_status.selectedIndex = -1;
	
	frameSearch.addEventListener("slotSearchEvent",slotSearchHandler);
	frameSearch.title = "查询";
}
/**
 *监听到查询，执行查询 
 * @param event
 * 
 */
protected function slotSearchHandler(event:slotSearchEvent):void{
	slotModel = event.model;
	slotModel.start="0";
	slotModel.end=pageSize.toString();
	slotModel.dir ="asc";
	serverPagingBar.navigateButtonClick("firstPage");
}

/**
 * 
 * 导出
 * 
 * */
protected function toolbar_toolEventEmpExcelHandler(event:Event):void{
	var fefs:FileExportFirstStep = new FileExportFirstStep();
	var model:FrameSlot = new FrameSlot();
	fefs.dataNumber = this.datanumbers;
	fefs.exportTypes = "机槽";
	fefs.titles = new Array("序号","机框序号","机槽序号","所属设备","机槽状态","宽度","长度","备注");
	fefs.labels = "机槽信息列表";
	model = slotModel;
	model.start = "0";
	model.end = this.datanumbers.toString();
	fefs.model=model;
	MyPopupManager.addPopUp(fefs, true);
}

/**
 * 
 * 导入
 * 
 * */
protected function toolbar_toolEventImpExcelHandler(event:Event):void{
	MyPopupManager.addPopUp(e2Oracle,true);
	e2Oracle.setTemplateType("机槽");
}

/**
 * 
 * 添加快捷方式
 * 
 * */
protected function toolbar_toolEventAddShortcutHandler(event:Event):void{
	parentApplication.addShorcut('机槽','equipslot');
}

/**
 * 
 * 删除快捷方式
 * 
 * */
protected function toolbar_toolEventDelShortcutHandler(event:Event):void{
	parentApplication.delShortcut('机槽');
}
/**
 *双击修改 
 * @param event
 * 
 */
protected function dg_doubleClickHandler(event:MouseEvent):void
{
	toolbar_toolEventEditHandler(null);
}
/**
 *列表排序处理 
 * @param event
 * 
 */
protected function dg_headerReleaseHandler(event:DataGridEvent):void
{
	var dg:DataGrid = DataGrid(event.currentTarget);
	var dgm:DataGridColumn = dg.columns[event.columnIndex];
	var columnName:String=dgm.dataField;
	event.stopImmediatePropagation(); //阻止其自身的排序
	slotModel.sort = columnName;
	slotModel.start="0";
	slotModel.end=pageSize.toString();
	if(columnName === "slotserial" || columnName == "rowno" ||  columnName == "colno" || columnName == "panelwidth" || columnName == "panellength"){ //处理数字类型的排序
		slotModel.isNumber =columnName;
	}else{
		slotModel.isNumber = "";
	}
	if(sortName == columnName){
		if(dir){
			slotModel.dir="asc";
			dir=false;
		}else{
			slotModel.dir="desc";
			dir=true;
		}
	}else{
		sortName=columnName;
		dir = false;
		slotModel.dir="asc";
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