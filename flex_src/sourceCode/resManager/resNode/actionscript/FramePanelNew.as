// ActionScript file
import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;

import flash.events.Event;
import flash.ui.ContextMenuItem;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
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
import sourceCode.resManager.resNode.Events.frameSearchEvent;
import sourceCode.resManager.resNode.Titles.FrameSearch;
import sourceCode.resManager.resNode.Titles.ModifyFramePanel;
import sourceCode.resManager.resNode.Titles.SearchSlotTitle;
import sourceCode.resManager.resNode.model.Frame;
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
//厂商列表
[Bindable] public var frame_vendorLst:XMLList;
//状态列表
[Bindable] public var frame_stateLst:XMLList; 
//设备类型列表
[Bindable] public var frame_modelLst:XMLList;
public var frameModel:Frame = new Frame();
private var dir:Boolean = true; //排序方式   true 升序 ，false 降序
private var sortName:String =""; //当前排序的列名
private var isEdit:Boolean = false;
private var isAdd:Boolean = false;
private var isDelete:Boolean = false;
private var isSearch:Boolean = true;
private var isExport:Boolean = false;
private var isImport:Boolean = false;
public var modelName:String = "机框";
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
	getFrame("0",pageSize.toString());
//	获取厂商列表
//	getVendorLst();
//	获取状态列表
	getFrameState();
	//获取设备类型列表
	getFrameModel();
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
	getFrame("0",serverPagingBar.totalRecord.toString());
}
/**
 *获取机框信息 
 * @param start
 * @param end
 * 
 */
private function getFrame(start:String,end:String):void{
	var Framert:RemoteObject=new RemoteObject("resNodeDwr");
	frameModel.start = start;
	frameModel.end = end ;
	Framert.addEventListener(ResultEvent.RESULT,resultHandler);
	Application.application.faultEventHandler(Framert);
	Framert.endpoint = ModelLocator.END_POINT;
	Framert.showBusyCursor = true;
	Framert.getEquipFrame(frameModel); 
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
	getFrame((pageIndex*pageSize).toString(),(pageIndex*pageSize+pageSize).toString());
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
 * 获取厂商列表
 * 
 * */
//private function getVendorLst():void{
//	var re:RemoteObject=new RemoteObject("resNodeDwr");
//	re.endpoint = ModelLocator.END_POINT;
//	re.showBusyCursor = true;
//	re.addEventListener(ResultEvent.RESULT,resultVendorLstHandler);
//	Application.application.faultEventHandler(re);
//	re.getVenders(); 
//	
//}
//
////获取厂商列表
//public function resultVendorLstHandler(event:ResultEvent):void{
//	frame_vendorLst = new XMLList(event.result);
//}
/**
 * 
 * 获取状态列表
 * 
 * */
private function getFrameState():void{
	var re:RemoteObject=new RemoteObject("resNodeDwr");
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.addEventListener(ResultEvent.RESULT,resultStateLstHandler);
	Application.application.faultEventHandler(re);
	re.getFrameState(); 
	
}

//获取状态列表
public function resultStateLstHandler(event:ResultEvent):void{
	frame_stateLst = new XMLList(event.result);
}
/**
 * 
 * 获取型号列表
 * 
 * */
private function getFrameModel():void{
	var re:RemoteObject=new RemoteObject("resNodeDwr");
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.addEventListener(ResultEvent.RESULT,resultModelLstHandler);
	Application.application.faultEventHandler(re);
	re.getFrameModel(); 
	
}

//获取型号列表
public function resultModelLstHandler(event:ResultEvent):void{
	frame_modelLst = new XMLList(event.result);
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
//	property.tablename = "EQUIPFRAME";
//	property.key = "PROJECTNAME";
//	PopUpManager.addPopUp(property, this, true);
//	PopUpManager.centerPopUp(property);		
//	property.addEventListener("savePropertyComplete",function (event:Event):void{
//		PopUpManager.removePopUp(property);
//		
//		RefreshStation(event);});
//	
//	property.addEventListener("initFinished",function (event:Event):void{
//		(property.getElementById("SHELFINFO",property.propertyList) as mx.controls.TextInput).enabled=false;
//		(property.getElementById("UPDATEPERSON",property.propertyList) as mx.controls.TextInput).enabled = false;
//		(property.getElementById("UPDATEPERSON",property.propertyList) as mx.controls.TextInput).text = parentApplication.curUserName;
//		(property.getElementById("UPDATEDATE",property.propertyList) as mx.controls.TextInput).enabled = false;
//		(property.getElementById("UPDATEDATE",property.propertyList) as mx.controls.TextInput).text = getNowTime();
//		(property.getElementById("TRANSYSTEM",property.propertyList) as mx.controls.ComboBox).addEventListener(Event.CHANGE,function(event:Object):void{
//			
//			(property.getElementById("SHELFINFO",property.propertyList) as mx.controls.TextInput).text="";
//			(property.getElementById("EQUIPCODE",property.propertyList) as mx.controls.TextInput).text="";
//		});
//		(property.getElementById("SHELFINFO",property.propertyList) as mx.controls.TextInput).addEventListener(MouseEvent.CLICK,function(event:Object):void{
//			property.dispatchEvent(new Event("changPicture"));//发送事件
//			
//		});
//		property.addEventListener("changPicture",function (event:Object){
//			var code:String = (property.getElementById("TRANSYSTEM",property.propertyList) as mx.controls.ComboBox).selectedItem.@code;
//			var packeqsearch:SearchSlotTitle=new SearchSlotTitle();
//			packeqsearch.page_parent=property;
//			packeqsearch.child_systemcode=code;
//			packeqsearch.child_vendor=null;
//			PopUpManager.addPopUp(packeqsearch,property,true);
//			PopUpManager.centerPopUp(packeqsearch);
//			packeqsearch.myCallBack=function(obj:Object){
//				var name:String=obj.name;//从子页面传过来的选的系统的code
//				var parent_equipcode:String = obj.id;
//				(property.getElementById("EQUIPCODE",property.propertyList) as mx.controls.TextInput).text=name;
//				(property.getElementById("SHELFINFO",property.propertyList) as mx.controls.TextInput).text=parent_equipcode;
//				(property.getElementById("SYSTEMCODE",property.propertyList) as mx.controls.TextInput).text=code;
//			}
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
		var cit:ModifyFramePanel = new ModifyFramePanel();
		cit.title ='修改';
		PopUpManager.addPopUp(cit,this,true);
		PopUpManager.centerPopUp(cit);
		cit.equipcode.text = dg.selectedItem.equipcode;
		cit.shelfinfo.text = dg.selectedItem.shelfinfo;
//		cit.s_framename.text = dg.selectedItem.s_framename;
		
		cit.frame_state1.text = dg.selectedItem.state_code;
		cit.frame_state.dropdown.dataProvider=frame_stateLst;
		cit.frame_state.dataProvider=frame_stateLst;
		cit.frame_state.labelField="@label";
		cit.frame_state.text="";
		cit.frame_state.selectedIndex=-1;
		cit.frame_state.text = dg.selectedItem.frame_state;
		
		cit.frontheight.text = dg.selectedItem.frontheight;
		cit.frameserial.text = dg.selectedItem.frameserial;
		
		cit.framemodel.dropdown.dataProvider=frame_modelLst;
		cit.framemodel.dataProvider=frame_modelLst;
		cit.framemodel.labelField="@label";
		cit.framemodel.text="";
		cit.framemodel.selectedIndex=-1;
		cit.framemodel.text = dg.selectedItem.framemodel;
		cit.framemodel1.text = dg.selectedItem.model_code;
		
		cit.frontwidth.text = dg.selectedItem.frontwidth;
		cit.remark.text = dg.selectedItem.remark;
		
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
//private function delconfirmHandler(event:CloseEvent):void {
//	if (event.detail == Alert.YES) {
//		var remoteObject:RemoteObject=new RemoteObject("resNodeDwr");
//		remoteObject.endpoint = ModelLocator.END_POINT;
//		remoteObject.showBusyCursor = true;
//		remoteObject.delEquipFrames(dg.selectedItem);
//		remoteObject.addEventListener(ResultEvent.RESULT,delFrameResult);
//		Application.application.faultEventHandler(remoteObject);
//	}
//}

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
	var frameSearch:FrameSearch = new FrameSearch();
	PopUpManager.addPopUp(frameSearch,Application.application as DisplayObject,true);
	PopUpManager.centerPopUp(frameSearch);
	
	frameSearch.frame_state.dataProvider = frame_stateLst;
	frameSearch.frame_state.selectedIndex = -1;
	frameSearch.framemodel.dataProvider = frame_modelLst;
	frameSearch.framemodel.selectedIndex = -1;
	
	frameSearch.addEventListener("frameSearchEvent",frameSearchHandler);
	frameSearch.title = "查询";
}
/**
 *监听到查询，执行查询 
 * @param event
 * 
 */
protected function frameSearchHandler(event:frameSearchEvent):void{
	frameModel = event.model;
	frameModel.start="0";
	frameModel.end=pageSize.toString();
	frameModel.dir ="asc";
	serverPagingBar.navigateButtonClick("firstPage");
}

/**
 * 
 * 导出
 * 
 * */
protected function toolbar_toolEventEmpExcelHandler(event:Event):void{
	var fefs:FileExportFirstStep = new FileExportFirstStep();
	var model:Frame = new Frame();
	fefs.dataNumber = this.datanumbers;
	fefs.exportTypes = "机框";
	fefs.titles = new Array( "序号","机框序号","所属设备","机框状态","机框型号","宽度","高度","备注");
	fefs.labels = "机框信息列表";
	model = frameModel;
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
	e2Oracle.setTemplateType("机框");
}

/**
 * 
 * 添加快捷方式
 * 
 * */
protected function toolbar_toolEventAddShortcutHandler(event:Event):void{
	parentApplication.addShorcut('机框','equipframe');
}

/**
 * 
 * 删除快捷方式
 * 
 * */
protected function toolbar_toolEventDelShortcutHandler(event:Event):void{
	parentApplication.delShortcut('机框');
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
	frameModel.sort = columnName;
	frameModel.start="0";
	frameModel.end=pageSize.toString();
	if(columnName === "frameserial" || columnName == "xfront" ||  columnName == "yfront" || columnName == "frontwidth" || columnName == "frontheight"){ //处理数字类型的排序
		frameModel.isNumber =columnName;
	}else{
		frameModel.isNumber = "";
	}
	if(sortName == columnName){
		if(dir){
			frameModel.dir="asc";
			dir=false;
		}else{
			frameModel.dir="desc";
			dir=true;
		}
	}else{
		sortName=columnName;
		dir = false;
		frameModel.dir="asc";
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