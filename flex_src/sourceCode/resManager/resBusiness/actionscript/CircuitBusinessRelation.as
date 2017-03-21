
import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.actionscript.Registry;
import common.other.events.CustomEvent;

import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.net.registerClassAlias;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import mx.controls.Alert;
import mx.core.Application;
import mx.events.CloseEvent;
import mx.formatters.DateFormatter;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import sourceCode.autoGrid.view.ShowProperty;
import sourceCode.resManager.resBusiness.events.CircuitBusinessSearchEvent;
import sourceCode.resManager.resBusiness.model.CircuitBusinessModel;
import sourceCode.resManager.resBusiness.model.ResultModel;
import sourceCode.resManager.resBusiness.titles.CircuitBusinessTitle;
import sourceCode.systemManagement.model.PermissionControlModel;
import sourceCode.tableResurces.Events.ToopEvent;
import sourceCode.tableResurces.views.FileExportFirstStep;

import twaver.DemoUtils;

private var pageIndex:int = 0;
private var pageSize:int = 50;
/**
 * 数据总条数
 **/
private var dataNumber:int; 
private var isAdd:Boolean = false;
private var isDelete:Boolean = false;
private var isEdit:Boolean = false;
private var isSearch:Boolean = true;
private var isImport:Boolean = false;
private var isExport:Boolean = true;
private var dir:Boolean = true;              //排序方式   true 升序
private var sortName:String ="";             //当前排序的列名
private var circuitBusinessModel:CircuitBusinessModel = new CircuitBusinessModel();

/**
 * 初始化之前预处理函数 
 * 
 */
private function preinitialize():void
{
	if(ModelLocator.permissionList!=null && ModelLocator.permissionList.length>0)
	{
		isAdd = false;
		isEdit = false;
		isDelete = false;
		isSearch = true;
		isImport = false;
		isExport = true;
		for(var i:int = 0; i < ModelLocator.permissionList.length; i++)
		{
			var model:PermissionControlModel = ModelLocator.permissionList[i];
			
			if(model.oper_name!=null&&model.oper_name=="添加操作"){
				isAdd = true;
//				isAdd = false;
			}
			if(model.oper_name!=null&&model.oper_name=="修改操作"){
				isEdit = true;
//				isEdit = false;
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
 * 初始化之后处理函数 
 * 
 */
private function init():void
{
	registerClassAlias("resManager.resBusiness.model.CircuitBusinessModel",CircuitBusinessModel);
	serverPagingBar.dataGrid = dataGrid;
	serverPagingBar.pagingFunction = pagingFunction;
	serverPagingBar.addEventListener("returnALL",showAllDataHandler);
	getCircuitBusiness("0",pageSize.toString());
	
	addContextMenu();
}

/**
 * 分页处理函数 
 * @param pageIndex
 * @param pageSize
 * 
 */
private function pagingFunction(pageIndex:uint,pageSize:uint):void
{
	this.pageSize = pageSize;
	this.getCircuitBusiness((pageIndex*pageSize).toString(),(pageIndex*pageSize+pageSize).toString());
}

/**
 * 获取电路业务信息 
 * @param startIndex
 * @param endIndex
 * 
 */
private function getCircuitBusiness(startIndex:String,endIndex:String):void
{
	var rmObj:RemoteObject = new RemoteObject("resBusinessDwr");
	circuitBusinessModel.index = startIndex;
	circuitBusinessModel.end = endIndex;
	rmObj.endpoint = ModelLocator.END_POINT;
	rmObj.showBusyCursor = true;
	rmObj.addEventListener(ResultEvent.RESULT,resultHandler);
	rmObj.getCircuitBusiness(circuitBusinessModel);
	Application.application.faultEventHandler(rmObj);
}

/**
 * 电路业务信息结果呈现函数 
 * @param event
 * 
 */
private function resultHandler(event:ResultEvent):void{
	var result:ResultModel = event.result as ResultModel;
	if(null != result){
		this.dataNumber = result.totalCount;
		onResult(result);
	}
}

/**
 * 数据绑定
 */
private function onResult(result:ResultModel):void{
	serverPagingBar.orgData = result.orderList;
	serverPagingBar.totalRecord = result.totalCount;
	serverPagingBar.dataBind(true);
}

/**
 * 初始化显示数据函数
 * @param event
 * 
 */
private function showAllDataHandler(event:ResultEvent):void{
	getCircuitBusiness("0",serverPagingBar.totalRecord.toString());
}

/**
 * 增加弹出菜单
 * */
private function addContextMenu():void{
	var contextMenu:ContextMenu = new ContextMenu();
	dataGrid.contextMenu = contextMenu;
	dataGrid.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,function(event:ContextMenuEvent):void{
		
		var searchItem:ContextMenuItem = new ContextMenuItem("查 询",true);
		var deleteItem:ContextMenuItem = new ContextMenuItem("删 除",true);
		searchItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,function(event:ContextMenuEvent):void{
			toolbar_toolEventSearchHandler(new ToopEvent("toolEventSearch"));
		});
		deleteItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,function(event:ContextMenuEvent):void{
			controlBar_controlDelHandler(new ToopEvent("toolEventSearch"));
		});
		searchItem.visible = isSearch;
		deleteItem.visible = isDelete;
		if(dataGrid.selectedItems.length > 0)
		{
			dataGrid.selectedItem = dataGrid.selectedItems[0];
		}
		var flexVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLEX_SDK_VERSION,false,false);
		var playerVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLASH_PLAYER_VERSION,false,false);
		dataGrid.contextMenu.hideBuiltInItems();
		dataGrid.contextMenu.customItems = [searchItem,deleteItem];
		
	});
}
/**
 * 添加
 */
protected function controlBar_controlAddHandler(event:Event):void
{
		var cbt:CircuitBusinessTitle = new CircuitBusinessTitle();
		cbt.title ='添加';
		cbt.currentState = 'add';
		PopUpManager.addPopUp(cbt,this,true);
		PopUpManager.centerPopUp(cbt);
		cbt.addEventListener("RefreshDataGrid",refreshHandle);
}

/**
 * 修改
 * */
protected function controlBar_controlEditHandler(event:Event):void
{
	if(dataGrid.selectedItems.length>0){
		
		var cbt:CircuitBusinessTitle = new CircuitBusinessTitle();
		cbt.title ='修改';
		cbt.currentState = "modify";
		PopUpManager.addPopUp(cbt,this,true);
		PopUpManager.centerPopUp(cbt);
		cbt.business_id.text = dataGrid.selectedItem.business_id;
		cbt.circuitcode.text = dataGrid.selectedItem.circuitcode;
		cbt.business_name.text = dataGrid.selectedItem.business_name;
		cbt.username.text = dataGrid.selectedItem.username;
//		cbt.updateperson.text = dataGrid.selectedItem.updateperson;
		cbt.business_id_bak = dataGrid.selectedItem.business_id;
		cbt.circuitcode_bak = dataGrid.selectedItem.circuitcode;

		cbt.addEventListener("RefreshDataGrid",refreshHandle);
		
	}else{
		Alert.show("请先选中一条记录！","提示");
	}
}

/**
 * 删除
 * */
protected function controlBar_controlDelHandler(event:Event):void
{
	if(dataGrid.selectedItems.length>0){
		//					if(parentApplication.isEdit==true){
		Alert.show("确定要删除这条记录吗？","请您确定",Alert.YES|Alert.NO,this,closeHandler,null,Alert.NO);	
		//					}else{
		//						Alert.show("对不起！您没有足够权限删除数据","提示");
		//					}
	}else{
		Alert.show("请先选中一条记录！","提示");
	}	
}

/**
 * 删除处理
 * */
private function closeHandler(e:CloseEvent):void{
	//判断点击按钮为"是"
	if(e.detail == Alert.YES){
		var obj1:RemoteObject = new RemoteObject("resBusinessDwr");
		obj1.endpoint=ModelLocator.END_POINT;
		obj1.deleteCircuitBusiness(dataGrid.selectedItem);
		obj1.addEventListener(ResultEvent.RESULT,resultsHandler);
		Application.application.faultEventHandler(obj1);
	}
}

/**
 * 删除结果处理函数 
 * @param e
 * 
 */
private function resultsHandler(e:ResultEvent):void{
	if(e.result!=null){
		if(e.result.toString()=="success"){
			Alert.show("删除成功！","提示");
			serverPagingBar.navigateButtonClick("firstPage");
		}else{
			Alert.show("删除失败！","提示");
		}
	}
}

/**
 * 查询 
 */
private function toolbar_toolEventSearchHandler(event:Event):void
{
		var cbt:CircuitBusinessTitle = new CircuitBusinessTitle();
		cbt.title = '查询';
		cbt.showCicuitcode=true;
		cbt.showBusinessID=true;
		cbt.currentState = 'search';
		PopUpManager.addPopUp(cbt,this,true);
		PopUpManager.centerPopUp(cbt);
		
		//监听查询按钮是否点击确认
		cbt.addEventListener("CircuitBusinessSearchEvent",searchCircuitBusinessHandler);
}

/**
 * 导入
 * */
protected function controlBar_controlImportHandler(event:Event):void
{
	// TODO Auto-generated method stub
	
}

/**
 * 导出
 */
private function toolbar_ExportExcelHandler(event:Event):void{
	var fefs:FileExportFirstStep = new FileExportFirstStep();
	fefs.dataNumber = this.dataNumber;	
	circuitBusinessModel.end = this.dataNumber.toString();				
	fefs.titles = new Array("序号","业务名称","电路名称","更新人");				
	fefs.exportTypes = "电路业务";
	fefs.labels = "电路业务关系表";
	fefs.model = circuitBusinessModel;
	MyPopupManager.addPopUp(fefs, this);
}




/**
 * 刷新处理
 */
private function refreshDataGridHandler(event:Event):void{
	getCircuitBusiness("0",pageSize.toString());
}

/**
 * 查询电路业务信息--结果处理函数 
 * @param event
 * 
 */
private function searchCircuitBusinessHandler(event:CircuitBusinessSearchEvent):void
{
	circuitBusinessModel = event.model;
	circuitBusinessModel.index = "0";
	circuitBusinessModel.end = pageSize.toString();
	circuitBusinessModel.dir = "asc";
	serverPagingBar.navigateButtonClick("firstPage");
}

/**
 * 增删改查--结果处理函数 
 * @param event
 * 
 */
private function refreshHandle(event:Event):void{
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

