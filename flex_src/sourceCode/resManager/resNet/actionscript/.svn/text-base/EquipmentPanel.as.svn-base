// ActionScript file
import com.adobe.utils.IntUtil;

import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.actionscript.Registry;

import flash.events.Event;
import flash.ui.ContextMenuItem;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
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
import sourceCode.resManager.resNet.events.EquipmentSearchEvent;
import sourceCode.resManager.resNet.model.Equipment;
import sourceCode.resManager.resNet.titles.EquipmentSearch;
import sourceCode.systemManagement.model.PermissionControlModel;
import sourceCode.tableResurces.Events.ToopEvent;
import sourceCode.tableResurces.model.ResultModel;
import sourceCode.tableResurces.views.DataImportFirstStep;
import sourceCode.tableResurces.views.FileExportFirstStep;
import sourceCode.resManager.resNode.views.enStationTree;

import twaver.DemoUtils;
import twaver.SequenceItemRenderer;

private var pageIndex:int=0;  //第几页
private var pageSize:int=50; //每页显示数
private var datanumbers:int; //总数据量

private var indexRenderer:Class = SequenceItemRenderer;
public var e2Oracle:DataImportFirstStep = new DataImportFirstStep();
//厂商列表
[Bindable] public var x_vendorLst:XMLList;
//传输系统列表
[Bindable] public var sys_nameLst:XMLList; 
//设备型号列表
[Bindable] public var x_modelLst:XMLList;
//设备类型列表
//[Bindable] public var x_typeLst:XMLList;
private var equipModel:Equipment = new Equipment();
private var dir:Boolean = true; //排序方式   true 升序 ，false 降序
private var sortName:String =""; //当前排序的列名
private var isEdit:Boolean = false;
private var isAdd:Boolean = false;
private var isDelete:Boolean = false;
private var isSearch:Boolean = true;
private var isExport:Boolean = false;
private var isImport:Boolean = false
public var modelName:String = "设备";
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
	//获取设备列表
	getEquipmentLst("0",pageSize.toString());
	//获取设备厂商
	getX_VendorLst();
	//获取系统列表
	getSysNameLst();
	//获取设备型号
//	getX_modelLst();
	//获取设备类型
//	getX_equiptypeLst();
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
	getEquipmentLst("0",serverPagingBar.totalRecord.toString());
}

/**
 * 
 * 获取设备列表
 * 
 * */
private function getEquipmentLst(start:String,end:String):void{
	var stationcode:String=Registry.lookup("stationcode");
	Registry.unregister("stationcode");
	if(stationcode!=null&&stationcode!=""){
		equipModel.stationcode=stationcode;
	}
	
	//链接数据库
	var equipObj:RemoteObject=new RemoteObject("resNetDwr");
	//一页显示的条数，start为0，end为20？
	equipModel.start = start; 
	equipModel.end = end ;
	//处理结果监听
	equipObj.addEventListener(ResultEvent.RESULT,resultSDHHandler);
	//默认处理结果
	Application.application.faultEventHandler(equipObj);
	equipObj.endpoint = ModelLocator.END_POINT;
	equipObj.showBusyCursor = true;
	//查询所有设备
	equipObj.getEquipmentLst(equipModel); 
}

public function resultSDHHandler(event:ResultEvent):void{
	var result:ResultModel=event.result as ResultModel;
	this.datanumbers = result.totalCount;
	onResult(result);
}

/**
 * 
 * 获取厂商列表
 * 
 * */
private function getX_VendorLst():void{
	var re:RemoteObject=new RemoteObject("resNetDwr");
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.addEventListener(ResultEvent.RESULT,getX_modelLst);
	Application.application.faultEventHandler(re);
	re.getX_VendorLst(); 
	
}

////获取厂商列表
//public function resultVendorLstHandler(event:ResultEvent):void{
//	x_vendorLst = new XMLList(event.result);
//}
/**
 * 
 * 获取传输系统列表
 * 
 * */
private function getSysNameLst():void{
	var re:RemoteObject=new RemoteObject("resNetDwr");
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.addEventListener(ResultEvent.RESULT,resultSDHStateHandler);
	Application.application.faultEventHandler(re);
	re.getSysNameLst(); 
	
}

public function resultSDHStateHandler(event:ResultEvent):void{
	sys_nameLst = new XMLList(event.result);
}
/**
 * 
 * 获取设备型号列表
 * 
 * */
private function getX_modelLst(event:ResultEvent):void{
	x_vendorLst = new XMLList(event.result);
	var re:RemoteObject=new RemoteObject("resNetDwr");
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.addEventListener(ResultEvent.RESULT,resultModelLstHandler);
	Application.application.faultEventHandler(re);
	re.getX_modelLst(""); 
	
}

//获取设备型号列表
public function resultModelLstHandler(event:ResultEvent):void{
	x_modelLst = new XMLList(event.result);
}
/**
 * 
 * 获取设备类型列表
 * 
 * */
//private function getX_equiptypeLst():void{
//	var re:RemoteObject=new RemoteObject("resNetDwr");
//	re.endpoint = ModelLocator.END_POINT;
//	re.showBusyCursor = true;
//	re.addEventListener(ResultEvent.RESULT,resultTypeLstHandler);
//	Application.application.faultEventHandler(re);
//	re.getX_equiptypeLst(); 
//	
//}

//获取设备类型列表
//public function resultTypeLstHandler(event:ResultEvent):void{
//	x_typeLst = new XMLList(event.result);
//}


private function pagingFunction(pageIndex:int,pageSize:int):void{
	this.pageSize=pageSize;
	getEquipmentLst((pageIndex*pageSize).toString(),(pageIndex*pageSize+pageSize).toString());
	this.pageIndex = pageIndex;
}

public function onResult(result:ResultModel):void 
{
	serverPagingBar.orgData=result.orderList;
	serverPagingBar.totalRecord=result.totalCount;
	serverPagingBar.dataBind(true);					
}

private function RefreshStation(event:Event):void{
	serverPagingBar.navigateButtonClick("firstPage");
}


/**
 * 
 * 添加
 * 
 * */
protected function toolbar_toolEventAddHandler(event:Event):void
{
	var property:ShowProperty = new ShowProperty();
	property.title = "添加";
	property.paraValue = null;
	property.tablename = "EQUIPMENT_VIEW";
	property.key = "EQUIPCODE";
	PopUpManager.addPopUp(property, this, true);
	PopUpManager.centerPopUp(property);		
	property.addEventListener("savePropertyComplete",function (event:Event):void{
		PopUpManager.removePopUp(property);
		
		RefreshStation(event);});
	
	property.addEventListener("initFinished",function (event:Event):void{
		(property.getElementById("STATIONNAME",property.propertyList) as mx.controls.TextInput).addEventListener(MouseEvent.CLICK,function(event:Object):void{
			var stations:enStationTree=new enStationTree();
			stations.page_parent=property;
			stations.textId="STATIONCODE";
			PopUpManager.addPopUp(stations, property, true);
			PopUpManager.centerPopUp(stations);  
		});
		(property.getElementById("STATIONNAME",property.propertyList) as mx.controls.TextInput).enabled = false;
		(property.getElementById("UPDATEPERSON",property.propertyList) as mx.controls.TextInput).enabled = false;
		(property.getElementById("UPDATEPERSON",property.propertyList) as mx.controls.TextInput).text = parentApplication.curUserName;
		(property.getElementById("UPDATEDATE",property.propertyList) as mx.controls.TextInput).enabled = false;
		(property.getElementById("UPDATEDATE",property.propertyList) as mx.controls.TextInput).text = getNowTime();
	});
}

/**
 * 
 * 修改
 * 
 * */
protected function toolbar_toolEventEditHandler(event:Event):void
{
	if(dg.selectedItem != null){
		var property:ShowProperty = new ShowProperty();
		property.title = "修改";
		property.paraValue = dg.selectedItem.equipcode;
		property.tablename = "EQUIPMENT_VIEW";
		property.key = "EQUIPCODE";
		
		PopUpManager.addPopUp(property, this, true);
		PopUpManager.centerPopUp(property);		
		property.addEventListener("savePropertyComplete",function (event:Event):void{
			PopUpManager.removePopUp(property);
			
			RefreshStation(event);});
		
		property.addEventListener("initFinished",function (event:Event):void{
			(property.getElementById("STATIONNAME",property.propertyList) as mx.controls.TextInput).addEventListener(MouseEvent.CLICK,function(event:Object):void{
				var stations:enStationTree=new enStationTree();
				stations.page_parent=property;
				stations.textId="STATIONCODE";
				PopUpManager.addPopUp(stations, property, true);
				PopUpManager.centerPopUp(stations);  
			});
			(property.getElementById("STATIONNAME",property.propertyList) as mx.controls.TextInput).enabled = false;
			(property.getElementById("UPDATEPERSON",property.propertyList) as mx.controls.TextInput).enabled = false;
			(property.getElementById("UPDATEPERSON",property.propertyList) as mx.controls.TextInput).text = parentApplication.curUserName;
			(property.getElementById("UPDATEDATE",property.propertyList) as mx.controls.TextInput).enabled = false;
			(property.getElementById("UPDATEDATE",property.propertyList) as mx.controls.TextInput).text = getNowTime();
		});
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
	// TODO Auto-generated method stub
	if(dg.selectedItem != null){
		//		if(dg.selectedItem.roomcount > 0){
		//			Alert.show("该节点下还有机房，不可删除！\n若要删除，请先删除该节点下的机房！","提示信息");
		//			return;
		//		}
		
		Alert.show("您确认要删除吗？","请您确认！",Alert.YES|Alert.NO,this,delconfirmHandler,null,Alert.NO);
		
	}else{
		Alert.show("请先选中一条记录！","提示");
	}
}

private function delconfirmHandler(event:CloseEvent):void {
	if (event.detail == Alert.YES) {
		var remoteObject:RemoteObject=new RemoteObject("resNetDwr");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		//删除一条记录
		remoteObject.delEquipmentByModel(dg.selectedItem);
		remoteObject.addEventListener(ResultEvent.RESULT,delStationResult);
		Application.application.faultEventHandler(remoteObject);
	}
}

public function delStationResult(event:ResultEvent):void{
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
	//查询页面
	var equipSearch:EquipmentSearch = new EquipmentSearch();
	PopUpManager.addPopUp(equipSearch,Application.application as DisplayObject,true);
	PopUpManager.centerPopUp(equipSearch);
	
	equipSearch.x_vendor.dataProvider = x_vendorLst;
	equipSearch.x_vendor.selectedIndex = -1;
	equipSearch.system_name.dataProvider = sys_nameLst;
	equipSearch.system_name.selectedIndex = -1;
	equipSearch.x_model.dataProvider = x_modelLst;
	equipSearch.x_model.selectedIndex = -1;
//	equipSearch.equiptype.dataProvider = x_typeLst;
//	equipSearch.equiptype.selectedIndex = -1;
	
	equipSearch.addEventListener("equipSearchEvent",equipSearchHandler);
	equipSearch.title = "查询";
}

protected function equipSearchHandler(event:EquipmentSearchEvent):void{ 
	equipModel = event.model;
	equipModel.start="0";
	equipModel.dir="asc";
	equipModel.end=pageSize.toString();
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
	e2Oracle.setTemplateType("设备");
}

/**
 * 
 * 导出
 * 
 * */
protected function toolbar_toolEventEmpExcelHandler(event:Event):void
{
	var fefs:FileExportFirstStep = new FileExportFirstStep();
	var model:Equipment = new Equipment();
	fefs.dataNumber = this.datanumbers;
	fefs.exportTypes = "设备";
	fefs.titles = new Array("序号","设备名称", "设备型号","设备厂家","设备类型", "网管名称",  "所属传输系统","更新人","更新时间");
	fefs.labels = "设备信息列表";
	model = equipModel;
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
	Alert.show("开始");
	this.parentApplication.addShorcut('设备','equipment');
}

/**
 * 
 * 删除快捷方式
 * 
 * */
protected function toolbar_toolEventDelShortcutHandler(event:Event):void
{
	parentApplication.delShortcut('设备');
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
	equipModel.sort = columnName;
	equipModel.start="0";
	equipModel.end=pageSize.toString();
	equipModel.isNumber = "";
	if(sortName == columnName){
		if(dir){
			equipModel.dir="asc";
			dir=false;
		}else{
			equipModel.dir="desc";
			dir=true;
		}
	}else{
		sortName=columnName;
		dir = false;
		equipModel.dir="asc";
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
