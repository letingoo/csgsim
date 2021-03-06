import com.adobe.utils.IntUtil;

import flash.events.Event;
import flash.events.MouseEvent;
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

import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.actionscript.Registry;

import org.flexunit.runner.Result;

import sourceCode.autoGrid.view.ShowProperty;
import sourceCode.resManager.resNode.Events.StationSearchEvent;
import sourceCode.resManager.resNode.Titles.SearchEquipTitle;
import sourceCode.resManager.resNode.Titles.StationSearch;
import sourceCode.resManager.resNode.model.Station;
import sourceCode.systemManagement.model.PermissionControlModel;
import sourceCode.tableResurces.Events.ToopEvent;
import sourceCode.tableResurces.model.ResultModel;
import sourceCode.tableResurces.views.DataImportFirstStep;
import sourceCode.tableResurces.views.FileExportFirstStep;

import twaver.DemoUtils;
import twaver.SequenceItemRenderer;

private var pageIndex:int=0;  //第几页
private var pageSize:int=50; //每页显示数
private var datanumbers:int; //总数据量

private var indexRenderer:Class = SequenceItemRenderer;
public var e2Oracle:DataImportFirstStep = new DataImportFirstStep();

[Bindable] public var xmlStationType:XMLList;
[Bindable] public var xmlProvince:XMLList;
[Bindable] public var xmlVolt:XMLList; //电压选项
[Bindable] public var propertyList:XMLList; 
//传输系统列表
[Bindable] public var sys_nameLst:XMLList; 
private var stationModel:Station = new Station();
private var dir:Boolean = true; //排序方式   true 升序 ，false 降序
private var sortName:String =""; //当前排序的列名
private var isEdit:Boolean = false;
private var isAdd:Boolean = false;
private var isDelete:Boolean = false;
private var isSearch:Boolean = true;
private var isExport:Boolean = false;
private var isImport:Boolean = false
public var modelName:String = "站点";
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
	getStation("0",pageSize.toString());
	getStationType();
	getProvince();
	getVoltType(); //
	getProperty();
	getSysNameLst();//查询传输系统
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
	getStation("0",serverPagingBar.totalRecord.toString());
}

/**
 * 
 * 获取站点信息
 * 
 * */
private function getStation(start:String,end:String):void{
	var Stationrt:RemoteObject=new RemoteObject("resNodeDwr");
	stationModel.start = start;
	stationModel.end = end ;
	Stationrt.addEventListener(ResultEvent.RESULT,resultStationHandler);
	Application.application.faultEventHandler(Stationrt);
	Stationrt.endpoint = ModelLocator.END_POINT;
	Stationrt.showBusyCursor = true;
	Stationrt.getStation(stationModel); 
}

public function resultStationHandler(event:ResultEvent):void{
	var result:ResultModel=event.result as ResultModel;
	this.datanumbers = result.totalCount;
	onResult(result);
}

/**
 * 
 * 获取站点类型
 * 
 * */
private function getStationType():void{
	var re:RemoteObject=new RemoteObject("resNodeDwr");
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.addEventListener(ResultEvent.RESULT,resultStationTypeHandler);
	Application.application.faultEventHandler(re);
	re.getStationType(); 
	
}

public function resultStationTypeHandler(event:ResultEvent):void{
	xmlStationType = new XMLList(event.result);
}



//---------------------------------------------
/**
 * 设置电压
 * @2011-3-1
 * @yenn
 */
private function getVoltType():void{
	var re:RemoteObject = new RemoteObject("resNodeDwr");
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.addEventListener(ResultEvent.RESULT,resultVoltHandler);
	Application.application.faultEventHandler(re);
	re.getVoltType(); 
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

private function getProvince():void{
	var rtobj12:RemoteObject = new RemoteObject("resNodeDwr");
	rtobj12.endpoint = ModelLocator.END_POINT;
	rtobj12.showBusyCursor = true;
	rtobj12.getFromXTBM('XZ01__');//根据系统编码查询对应信息(所属地区)
	rtobj12.addEventListener(ResultEvent.RESULT, function(e:ResultEvent):void{
		xmlProvince = new XMLList(e.result)
	})
	Application.application.faultEventHandler(rtobj12);
}


public function resultVoltHandler(event:ResultEvent):void{
	xmlVolt = new XMLList(event.result);
}


private function pagingFunction(pageIndex:int,pageSize:int):void{
	this.pageSize=pageSize;
	getStation((pageIndex*pageSize).toString(),(pageIndex*pageSize+pageSize).toString());
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
	property.tablename = "STATION";
	property.key = "STATIONCODE";
	PopUpManager.addPopUp(property, this, true);
	PopUpManager.centerPopUp(property);		
	property.addEventListener("savePropertyComplete",function (event:Event):void{
		PopUpManager.removePopUp(property);
		
		//更新标准命名
		var stationCode:String = property.insertKey;
		if(null != stationCode && "" != stationCode){
			var rmObj:RemoteObject = new RemoteObject("resNodeDwr");
			rmObj.endpoint = ModelLocator.END_POINT;
			rmObj.showBusyCursor = false;
			rmObj.updateStationNameStd(stationCode);
			rmObj.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
				RefreshStation(event);
				//插入光缆拓扑图中
				var stationcode:String=stationCode;
				var province:String="";// 单位在后台获取 并进行处理
				var modelname:String="光缆路由图";
				var nodex:String=(property.getElementById("LNG",property.propertyList) as mx.controls.TextInput).text;
				var nodey:String=(property.getElementById("LAT",property.propertyList) as mx.controls.TextInput).text;
				var labelx:String=(property.getElementById("LNG",property.propertyList) as mx.controls.TextInput).text;
				var labely:String=(property.getElementById("LAT",property.propertyList) as mx.controls.TextInput).text;
				remoteObject("ocableResources",true,null).addCoordinatesByOcableSection(stationcode,province,modelname,nodex,nodey,labelx,labely);
			});
			
			
		}
		
		RefreshStation(event);});	
	property.addEventListener("initFinished",function (event:Event):void{
		(property.getElementById("UPDATEPERSON",property.propertyList) as mx.controls.TextInput).enabled = false;
		(property.getElementById("UPDATEPERSON",property.propertyList) as mx.controls.TextInput).text = parentApplication.curUserName;
//		(property.getElementById("UPDATEDATE",property.propertyList) as mx.controls.TextInput).enabled = false;
		(property.getElementById("UPDATEDATE",property.propertyList) as mx.controls.TextInput).text = getNowTime();
		
	});
	init();
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
		property.paraValue = dg.selectedItem.stationcode;
		property.tablename = "STATION";
		property.key = "STATIONCODE";
		
		PopUpManager.addPopUp(property, this, true);
		PopUpManager.centerPopUp(property);		
		property.addEventListener("savePropertyComplete",function (event:Event):void{
			PopUpManager.removePopUp(property);
			
			//更新标准命名
			var stationCode:String = dg.selectedItem.stationcode;
			if(null != stationCode && "" != stationCode){
				var rmObj:RemoteObject = new RemoteObject("resNodeDwr");
				rmObj.endpoint = ModelLocator.END_POINT;
				rmObj.showBusyCursor = false;
				rmObj.updateStationNameStd(stationCode);
				rmObj.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
					RefreshStation(event);
				});
			}
			
			RefreshStation(event);});
		
		property.addEventListener("initFinished",function (event:Event):void{
			(property.getElementById("UPDATEPERSON",property.propertyList) as mx.controls.TextInput).enabled = false;
			(property.getElementById("UPDATEPERSON",property.propertyList) as mx.controls.TextInput).text = parentApplication.curUserName;
//			(property.getElementById("UPDATEDATE",property.propertyList) as mx.controls.TextInput).enabled = false;
			(property.getElementById("UPDATEDATE",property.propertyList) as mx.controls.TextInput).text = getNowTime();
			
				
		});
	}else{
		Alert.show("请先选中一条记录！","提示");
	}
	init();
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
		if(dg.selectedItem.roomcount > 0){
			Alert.show("该节点下还有机房，不可删除！\n若要删除，请先删除该节点下的机房！","提示信息");
			return;
		}

			Alert.show("您确认要删除吗？","请您确认！",Alert.YES|Alert.NO,this,delconfirmHandler,null,Alert.NO);

	}else{
		Alert.show("请先选中一条记录！","提示");
	}
}

private function delconfirmHandler(event:CloseEvent):void {
	if (event.detail == Alert.YES) {
		var remoteObject:RemoteObject=new RemoteObject("resNodeDwr");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		remoteObject.delStation(dg.selectedItem);
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
	var stationSearch:StationSearch = new StationSearch();
	PopUpManager.addPopUp(stationSearch,Application.application as DisplayObject,true);
	PopUpManager.centerPopUp(stationSearch);
	
	stationSearch.cmbStationType.dataProvider = xmlStationType;
	stationSearch.cmbStationType.selectedIndex = -1;
	
	stationSearch.cmbProvince.dataProvider = xmlProvince.children();
	stationSearch.cmbProvince.selectedIndex = -1;
	
	stationSearch.cmbProperty.dataProvider=propertyList.children();
	stationSearch.cmbProperty.selectedIndex = -1;
	
	stationSearch.addEventListener("StationSearchEvent",stationSearchHandler);
	stationSearch.title = "查询";
}

protected function stationSearchHandler(event:StationSearchEvent):void{ 
	stationModel = event.model;
	stationModel.start="0";
	stationModel.dir="asc";
	stationModel.end=pageSize.toString();
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
	e2Oracle.setTemplateType("局站");
}

/**
 * 
 * 导出
 * 
 * */
protected function toolbar_toolEventEmpExcelHandler(event:Event):void
{
	var fefs:FileExportFirstStep = new FileExportFirstStep();
	var model:Station = new Station();
	fefs.dataNumber = this.datanumbers;
	fefs.exportTypes = "站点";
	fefs.titles = new Array("序号","站点名称", "所属区局","站点类型","电压等级(kV)", "经度", "纬度", "建站时间");;
	fefs.labels = "站点信息列表";
	model = stationModel;
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
	parentApplication.addShorcut('站点','station');
}

/**
 * 
 * 删除快捷方式
 * 
 * */
protected function toolbar_toolEventDelShortcutHandler(event:Event):void
{
	parentApplication.delShortcut('站点');
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
	stationModel.sort = columnName;
	stationModel.start="0";
	stationModel.end=pageSize.toString();
	if(columnName === "volt" || columnName == "lng" ||  columnName == "lat"){ //处理数字类型的排序
		stationModel.isNumber =columnName;
	}else{
		stationModel.isNumber = "";
	}
	if(sortName == columnName){
		if(dir){
			stationModel.dir="asc";
			dir=false;
		}else{
			stationModel.dir="desc";
			dir=true;
		}
	}else{
		sortName=columnName;
		dir = false;
		stationModel.dir="asc";
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
//remoteObject对象
private function remoteObject(servicename:String,showBusyCursor:Boolean=true,resultfunction:Function=null):RemoteObject{
	var remoteObject:RemoteObject = new RemoteObject(servicename);
	remoteObject.endpoint = ModelLocator.END_POINT;
	remoteObject.showBusyCursor = showBusyCursor;
	if(resultfunction != null){
		remoteObject.addEventListener(ResultEvent.RESULT,resultfunction);
	}
	remoteObject.addEventListener(FaultEvent.FAULT,faultFunction);
	return remoteObject;
}

private function faultFunction(event:FaultEvent):void{
	Alert.show(event.fault.toString());
}
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

		protected function dg_doubleClickHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var stationcode:String=dg.selectedItem.stationcode;
			Registry.register("stationcode", stationcode);
			Application.application.openModel("设备", false);
		}