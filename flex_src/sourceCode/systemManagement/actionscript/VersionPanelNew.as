import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;

import flash.events.Event;
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

import org.flexunit.runner.Result;

import sourceCode.autoGrid.view.ShowProperty;
import sourceCode.systemManagement.events.VersionSearchEvent;
import sourceCode.systemManagement.model.PermissionControlModel;
import sourceCode.systemManagement.model.VersionModel;
import sourceCode.systemManagement.views.VersionSearch;
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
private var versionModel:VersionModel = new VersionModel();
private var dir:Boolean = true; //排序方式   true 升序 ，false 降序
private var sortName:String =""; //当前排序的列名
private var isEdit:Boolean = false;
private var isAdd:Boolean = false;
private var isDelete:Boolean = false;
private var isSearch:Boolean = true;
private var isExport:Boolean = false;
private var isImport:Boolean = false;
private var isCurrVersion:Boolean=true;
public var modelName:String = "资源版本管理";

private function preinitialize():void{
	if(ModelLocator.permissionList!=null&&ModelLocator.permissionList.length>0){
		isAdd = false;
		isEdit = false;
		isDelete = false;
		isSearch = true;
		isImport = false;
		isExport = true;
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
	getVersion("0",pageSize.toString());
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
		var item5:ContextMenuItem = new ContextMenuItem("切换资源版本", true);
		item5.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
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
			dg.contextMenu.customItems = [item1,item2,item3,item4,item5];
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
		case "切换资源版本":
			toSwitchVersion();
			break;
		default:
			break;
	}
}

private function showAllDataHandler(event:Event):void{
	getVersion("0",serverPagingBar.totalRecord.toString());
}
private function toSwitchVersion():void{
	var selectedVid=dg.selectedItem.vid;
	if(selectedVid!=null&&selectedVid!=""){
		var roVersion:RemoteObject=new RemoteObject("login");
		roVersion.addEventListener(ResultEvent.RESULT,resulStwitchVersionHandler);
		Application.application.faultEventHandler(roVersion);
		roVersion.endpoint = ModelLocator.END_POINT;
		roVersion.showBusyCursor = true;
		roVersion.switchUser(selectedVid);
	}
}
private function resulStwitchVersionHandler(event:ResultEvent):void{
	var result:String =event.result.toString();
	if(result!=null&&result!=""){
		ModelLocator.showSuccessMessage(result,this);
	}
}
/**
 * 
 * 获取版本信息
 * 
 * */
private function getVersion(start:String,end:String):void{
	var roVersion:RemoteObject=new RemoteObject("login");
	versionModel.start = start;
	versionModel.end = end ;
	roVersion.addEventListener(ResultEvent.RESULT,resultVersionHandler);
	Application.application.faultEventHandler(roVersion);
	roVersion.endpoint = ModelLocator.END_POINT;
	roVersion.showBusyCursor = true;
	roVersion.getVersion(versionModel);
}

public function resultVersionHandler(event:ResultEvent):void{
	var result:ResultModel=event.result as ResultModel;
	this.datanumbers = result.totalCount;
	onResult(result);
}



private function pagingFunction(pageIndex:int,pageSize:int):void{
	this.pageSize=pageSize;
	getVersion((pageIndex*pageSize).toString(),(pageIndex*pageSize+pageSize).toString());
}

public function onResult(result:ResultModel):void 
{	
	serverPagingBar.orgData=result.orderList;
	serverPagingBar.totalRecord=result.totalCount;
	serverPagingBar.dataBind(true);					
}

private function RefreshVersion(event:Event):void{
	getVersion("0",pageSize.toString());
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
//	property.paraValue = null;
	property.tablename = "VERSION";
	property.key = "VCODE";//autogrid 主键必须由序列得到
	PopUpManager.addPopUp(property, this, true);
	PopUpManager.centerPopUp(property);		
	property.addEventListener("savePropertyComplete",function (event:Event):void{
		PopUpManager.removePopUp(property);
		var vid:String =(property.getElementById("VID",property.propertyList) as mx.controls.ComboBox).text;// property.insertKey;
		if(null != vid && "" != vid){
		//	Alert.show("版本数据处理,请稍等");
			var rmObj:RemoteObject = new RemoteObject("login");
			rmObj.endpoint = ModelLocator.END_POINT;
			rmObj.showBusyCursor = false;
			rmObj.todoVersion(vid);
			rmObj.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
				RefreshVersion(event);
				var result:String=event.result.toString();
				if(result=="sucess"){
				//	Alert.show("版本数据处理已完成");
				}
				
				});
		}
		
		RefreshVersion(event);});	
	property.addEventListener("initFinished",function (event:Event):void{

		(property.getElementById("FILL_MAN",property.propertyList) as mx.controls.TextInput).enabled = false;
		(property.getElementById("FILL_MAN",property.propertyList) as mx.controls.TextInput).text = parentApplication.curUserName;
		(property.getElementById("FILL_MAN_ID",property.propertyList) as mx.controls.TextInput).text =parentApplication.curUser;
		(property.getElementById("FILL_TIME",property.propertyList) as mx.controls.TextInput).enabled = false;
		(property.getElementById("VNAME",property.propertyList) as mx.controls.TextInput).enabled = false;
		(property.getElementById("FILL_TIME",property.propertyList) as mx.controls.TextInput).text = getNowTime();
		if((property.getElementById("FROM_VNAME",property.propertyList) as mx.controls.ComboBox).selectedItem!=null){
			(property.getElementById("FROM_VID",property.propertyList) as mx.controls.TextInput).text = (property.getElementById("FROM_VNAME",property.propertyList) as mx.controls.ComboBox).selectedItem.@code;
		}
		//来源版本的变动
		(property.getElementById("FROM_VNAME",property.propertyList) as mx.controls.ComboBox).addEventListener(Event.CHANGE,function(event:Object):void{
			if((property.getElementById("FROM_VNAME",property.propertyList) as mx.controls.ComboBox).selectedItem!=null){
				(property.getElementById("FROM_VID",property.propertyList) as mx.controls.TextInput).text = (property.getElementById("FROM_VNAME",property.propertyList) as mx.controls.ComboBox).selectedItem.@code;
			}
			
		});
		//目标版本变动，更改目标名称
		(property.getElementById("VID",property.propertyList) as mx.controls.ComboBox).addEventListener(Event.CHANGE,function(event:Object):void{
			if((property.getElementById("VID",property.propertyList) as mx.controls.ComboBox).selectedItem!=null){
				(property.getElementById("VNAME",property.propertyList) as mx.controls.TextInput).text = (property.getElementById("VID",property.propertyList) as mx.controls.ComboBox).selectedItem.@label;
			}
			
		});
		
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
		property.paraValue = dg.selectedItem.vid;
		property.tablename = "VERSION";
		property.key = "VID";
		if(dg.selectedItem.vid=="csg_simulate"||dg.selectedItem.vname=="基础版本"){
			property.isVisible=false;
		}
		PopUpManager.addPopUp(property, this, true);
		PopUpManager.centerPopUp(property);		
		property.addEventListener("savePropertyComplete",function (event:Event):void{
			PopUpManager.removePopUp(property);
			var vid:String = dg.selectedItem.vid;
			if(null != vid && "" != vid){
			//	Alert.show("版本数据处理,请稍等");
				var rmObj:RemoteObject = new RemoteObject("login");
				rmObj.endpoint = ModelLocator.END_POINT;
				rmObj.showBusyCursor = false;
				rmObj.todoVersion(vid);
				rmObj.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
					RefreshVersion(event);
					var result:String=event.result.toString();
					if(result=="sucess"){
					//	Alert.show("版本数据处理已完成");
					}
				});
			}
			RefreshVersion(event);
		
		});
		
		property.addEventListener("initFinished",function (event:Event):void{
			(property.getElementById("FILL_MAN",property.propertyList) as mx.controls.TextInput).enabled = false;
			(property.getElementById("FILL_MAN",property.propertyList) as mx.controls.TextInput).text = parentApplication.curUserName;
			(property.getElementById("FILL_MAN_ID",property.propertyList) as mx.controls.TextInput).text = parentApplication.curUser;
			(property.getElementById("FILL_TIME",property.propertyList) as mx.controls.TextInput).enabled = false;
			(property.getElementById("VNAME",property.propertyList) as mx.controls.TextInput).enabled = false;
			(property.getElementById("FILL_TIME",property.propertyList) as mx.controls.TextInput).text = getNowTime();
			if((property.getElementById("FROM_VNAME",property.propertyList) as mx.controls.ComboBox).selectedItem!=null){
				(property.getElementById("FROM_VID",property.propertyList) as mx.controls.TextInput).text = (property.getElementById("FROM_VNAME",property.propertyList) as mx.controls.ComboBox).selectedItem.@code;
			}
			//来源版本的变动
			(property.getElementById("FROM_VNAME",property.propertyList) as mx.controls.ComboBox).addEventListener(Event.CHANGE,function(event:Object):void{
				if((property.getElementById("FROM_VNAME",property.propertyList) as mx.controls.ComboBox).selectedItem!=null){
			//		Alert.show((property.getElementById("FROM_VNAME",property.propertyList) as mx.controls.ComboBox).selectedItem.@code+"||"+(property.getElementById("VID",property.propertyList) as mx.controls.ComboBox).selectedItem.@label);
					if((property.getElementById("FROM_VNAME",property.propertyList) as mx.controls.ComboBox).selectedItem.@code==(property.getElementById("VID",property.propertyList) as mx.controls.ComboBox).selectedItem.@label){
						Alert.show("源版本和目标版本不可一致");
					}else{
						(property.getElementById("FROM_VID",property.propertyList) as mx.controls.TextInput).text = (property.getElementById("FROM_VNAME",property.propertyList) as mx.controls.ComboBox).selectedItem.@code;
					}
				
				}
				
			});
			(property.getElementById("VID",property.propertyList) as mx.controls.ComboBox).text=dg.selectedItem.vid;
			(property.getElementById("VID",property.propertyList) as mx.controls.ComboBox).enabled = false;
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
protected function toolbar_toolEventDeleteHandler(event:Event):void{
	if(dg.selectedItem != null){
		if(dg.selectedItem.vid=="csg_simulate"||dg.selectedItem.vname=="基础版本"){
			Alert.show("此版本为基础版本，不可删除");
		}else{
			ModelLocator.showConfimMessage("您确认要删除吗?",this,delconfirmHandler);
		}
		
	}else{
		ModelLocator.showErrorMessage("请先选中一条记录!",this);
	}
}



private function delconfirmHandler(event:CloseEvent):void {
	if (event.detail == Alert.YES) {
		var remoteObject:RemoteObject=new RemoteObject("login");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = false;
		remoteObject.delVersion(dg.selectedItem);
// 		remoteObject.addEventListener(ResultEvent.RESULT,delVersionResult);//屏蔽删除返回  前台不需等待 后台处理
		Application.application.faultEventHandler(remoteObject);
		//因删除较慢；直接显示删除成功；后台进行删除;提高用户体验度
		var timer:Timer = new Timer(1000,1);  //1000：毫秒数，1：代表执行次数，不设置默认为0，代表无限次。
		timer.addEventListener(TimerEvent.TIMER, delVersionResultAlert);
		function delVersionResultAlert(event:TimerEvent):void{
			RefreshVersion(event);
			Alert.show("删除成功！");
		}
		timer.start(); 
	}
}

public function delVersionResult(event:ResultEvent):void{
	
	if(event.result.toString()=="success")
	{
		ModelLocator.showSuccessMessage("删除成功!",this);
		this.getVersion("0",pageSize.toString());
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
	var versionsSearch:VersionSearch = new VersionSearch();
	PopUpManager.addPopUp(versionsSearch,Application.application as DisplayObject,true);
	PopUpManager.centerPopUp(versionsSearch);
	versionsSearch.addEventListener("versionSearchEvent",versionSearchHandler);
	versionsSearch.title = "查询";
}


protected function versionSearchHandler(event:VersionSearchEvent):void{
	versionModel = event.model;
	versionModel.start="0";
	versionModel.dir="asc";
	versionModel.end=pageSize.toString();
	serverPagingBar.navigateButtonClick("firstPage");
	
}

/**
 *导出功能
 * @name:toolbar_toolEventEmpExcelHandler
 * 
 */ 
protected function toolbar_toolEventEmpExcelHandler(event:Event):void{
	var fefs:FileExportFirstStep = new FileExportFirstStep();
	var model:VersionModel = new VersionModel();
	fefs.dataNumber = this.datanumbers;
	fefs.exportTypes = "资源版本";
	fefs.titles = new Array("序号","版本ID", "版本名称","版本描述","来源版本名称", "填写人","填写时间");
	fefs.labels = "资源版本信息列表";
	model = versionModel;
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
	parentApplication.addShorcut('资源版本管理','businessRess');
}

/**
 * 
 * 删除快捷方式
 * 
 * */
protected function toolbar_toolEventDelShortcutHandler(event:Event):void
{
	parentApplication.delShortcut('资源版本管理');
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
	versionModel.sort = columnName;
	versionModel.start="0";
	versionModel.end=pageSize.toString();
	if(sortName == columnName){
		if(dir){
			versionModel.dir="asc";
			dir=false;
		}else{
			versionModel.dir="desc";
			dir=true;
		}
	}else{
		sortName=columnName;
		dir = false;
		versionModel.dir="asc";
	}
	serverPagingBar.navigateButtonClick("firstPage");
}

protected function toolbar_toolEventCurrVersionHandler(event:Event):void{
	var remoteObject:RemoteObject=new RemoteObject("login");
	remoteObject.endpoint = ModelLocator.END_POINT;
	remoteObject.showBusyCursor = true;
	remoteObject.getCurrVersionByUser();
	remoteObject.addEventListener(ResultEvent.RESULT,currVersionResult);//屏蔽删除返回  前台不需等待 后台处理
	Application.application.faultEventHandler(remoteObject);
}
private function currVersionResult(event:ResultEvent):void{
	if(event.result.toString()!=null&&event.result.toString()!="")
	{
		var currVersion:String=event.result.toString();
		ModelLocator.showSuccessMessage("当前连接资源版本ID为："+currVersion ,this);
	}
	
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