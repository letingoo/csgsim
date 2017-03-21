// ActionScript file
import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.actionscript.Registry;

import flash.events.ContextMenuEvent;
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

import sourceCode.alarmmgr.views.AlarmManager;
import sourceCode.autoGrid.view.ShowProperty;
import sourceCode.faultSimulation.model.InterposeModel;
import sourceCode.faultSimulation.model.InterposeSearchEvent;
import sourceCode.faultSimulation.titles.InterposeSearchTitle;
import sourceCode.faultSimulation.titles.InterposeTitle;
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
private var isEdit:Boolean = false;
private var isAdd:Boolean = false;
private var isDelete:Boolean = false;
private var isSearch:Boolean = true;
private var isExport:Boolean = false;
private var isImport:Boolean = false;
private var isActive:Boolean = false;
private var sceneMonitor:Boolean = false;
[Bindable] public var isshow:Boolean=true;
private var alarmPersons:String="";
private var fault_Type="";
public  var modelName:String = "演习科目管理";
public var interposeModel:InterposeModel = new InterposeModel();

private function preinitialize():void{
	if(ModelLocator.permissionList!=null&&ModelLocator.permissionList.length>0){
		isAdd = false;
		isEdit = false;
		isDelete = false;
		isSearch = true;
		isImport = false;
		isExport = false;
		isActive= false;
		sceneMonitor = false;
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
			if(model.oper_name!=null&&model.oper_name=="设置激活"){
				isActive = true;
			}
			if(model.oper_name!=null&&model.oper_name=="演习监控"){
				sceneMonitor = true;
			}
		}
	}
}
protected function init():void
{
	interposeModel.sort="I_EVENT_INTERPOSE_ID";
	serverPagingBar.dataGrid=dg;
	serverPagingBar.pagingFunction=pagingFunction;
	serverPagingBar.addEventListener("returnALL",showAllDataHandler);
	getAllInterpose("0",pageSize.toString());
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
			var item7:ContextMenuItem = new ContextMenuItem("演习监控");
			item7.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
			var item5:ContextMenuItem = new ContextMenuItem("设置激活");
			item5.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
			//查询告警现象，标准维护过程
			var item6:ContextMenuItem = new ContextMenuItem("查看告警现象配置");
			item6.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
			var item8:ContextMenuItem = new ContextMenuItem("查看标准处理过程");
			item8.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
			
			//演习处理
			var item9:ContextMenuItem = new ContextMenuItem("设置已处理");
			item9.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
			
			item2.visible = isEdit;
			item3.visible = isDelete;
			item5.visible = isActive;
			item9.visible = true;
			if(modelName!="演习科目管理"){//如果进入的不是演习科目管理  则隐藏 右键标准处理过程
				item8.visible=false;
			}
			if(modelName=="割接科目查询"){
				item9.visible = false;
			}
			dg.contextMenu.hideBuiltInItems();//可隐藏不需要显示的功能项
			dg.contextMenu.customItems = [item1,item2,item3,item4,item5,item9,item6,item8];
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
		case "演习监控":
			toolbar_toolEventShowMonitorHandler(new ToopEvent("toolEventMonitor"));
			break;
		case "设置激活":
			toolbar_toolEventIsActiveHandler(new ToopEvent("toolEventIsActive"));
			break;
		case "查看告警现象配置":
			showAlarmConfigHandler(e);
			break;
		case "查看标准处理过程":
			showAlarmConfigHandler(e);
			break;
		case "设置已处理":
			modifyInterposeInfo(e);
			break;
		default:
			break;
	}
}

protected function modifyInterposeInfo(e:ContextMenuEvent):void{
	//修改为已处理
	if(dg.selectedItem.isOperated=='已处理'){
		Alert.show("当前故障科目已处理完成","提示");
		return;
	}
	var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
	remoteObject.endpoint = ModelLocator.END_POINT;
	remoteObject.showBusyCursor = true;
	remoteObject.modifyInterposeInfo(dg.selectedItem.interposeid);
	remoteObject.addEventListener(ResultEvent.RESULT,modifyInterposeInfoHandler);
	Application.application.faultEventHandler(remoteObject);
}
private function modifyInterposeInfoHandler(event:ResultEvent):void{
	
	if(event.result.toString()=="SUCCESS"){
		Alert.show("操作成功","提示");
		getAllInterpose("0",pageSize.toString());
	}else{
		Alert.show("操作失败","提示");
		return ;
	}
}

private function showAllDataHandler(event:Event):void{
	getAllInterpose("0",serverPagingBar.totalRecord.toString());
}

/**
 * 
 * 获取场景信息
 * 
 * */
private function getAllInterpose(start:String,end:String):void{
	var re:RemoteObject=new RemoteObject("faultSimulation");
	interposeModel.start = start;
	interposeModel.end = end ;
	if(this.modelName!=null&&modelName=="演习科目管理"){
		interposeModel.s_event_title="演习";
	}else if(this.modelName!=null&&modelName=="故障科目查询"){
		interposeModel.s_event_title="故障";
	}else if(this.modelName!=null&&modelName=="割接科目查询"){
		interposeModel.s_event_title="割接";
	}
	re.addEventListener(ResultEvent.RESULT,resultAlldelInterposeHandler);
	Application.application.faultEventHandler(re);
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.getAllInterpose1(interposeModel);
}

public function resultAlldelInterposeHandler(event:ResultEvent):void{
	var result:ResultModel=event.result as ResultModel;
	onResult(result);
}

private function pagingFunction(pageIndex:int,pageSize:int):void{
	this.pageSize=pageSize;
	getAllInterpose((pageIndex*pageSize).toString(),(pageIndex*pageSize+pageSize).toString());
}

public function onResult(result:ResultModel):void 
{	
	serverPagingBar.orgData=result.orderList;
	serverPagingBar.totalRecord=result.totalCount;
	datanumbers = result.totalCount;
	serverPagingBar.dataBind(true);					
}

private function RefreshDataGrid(event:Event):void{
	getAllInterpose("0",pageSize.toString());
}


/**
 * 
 * 添加
 * 
 * */
protected function toolbar_toolEventAddHandler(event:Event):void
{
	var interpose:InterposeTitle = new InterposeTitle();
	PopUpManager.addPopUp(interpose,Application.application as DisplayObject,true);
	PopUpManager.centerPopUp(interpose);
	interpose.title = "添加";
	interpose.isModify=false;
	interpose.interposename.text="演习科目"+ getNowTime();
	interpose.addEventListener("RefreshDataGrid",RefreshDataGrid);
}

/**
 * 
 * 修改
 * 
 * */
protected function toolbar_toolEventEditHandler(event:Event):void
{
	if(dg.selectedItem != null){
		var interpose:InterposeTitle = new InterposeTitle();
		PopUpManager.addPopUp(interpose,Application.application as DisplayObject,true);
		PopUpManager.centerPopUp(interpose);
		interpose.title = "修改";
		interpose.interposeData = dg.selectedItem;
		interpose.isShow=false;
		interpose.isModify=false;
		interpose.setData();
		interpose.addEventListener("RefreshDataGrid",RefreshDataGrid);
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
		ModelLocator.showConfimMessage("您确认要删除吗?",this,delconfirmHandler);
		
	}else{
		ModelLocator.showErrorMessage("请先选中一条记录!",this);
	}
}



private function delconfirmHandler(event:CloseEvent):void {
	if (event.detail == Alert.YES) {
		var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		remoteObject.delEventInterpose(dg.selectedItem.interposeid);
		remoteObject.addEventListener(ResultEvent.RESULT,delEventInterposeResult);
		Application.application.faultEventHandler(remoteObject);
	}
}

public function delEventInterposeResult(event:ResultEvent):void{
	if(event.result.toString()=="success")
	{
		ModelLocator.showSuccessMessage("删除成功!",this);
		this.getAllInterpose("0",pageSize.toString());
	}else if(event.result.toString()=="failed")
	{
		//分情况提示
		ModelLocator.showErrorMessage("不能删除已激活的演习科目!",this);
	}else{
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
	var interpose:InterposeSearchTitle = new InterposeSearchTitle();
	PopUpManager.addPopUp(interpose,Application.application as DisplayObject,true);
	PopUpManager.centerPopUp(interpose);
	interpose.isRequired=false;
	interpose.addEventListener("InterposeSearchEvent",InterposeSearchHandler);
	interpose.title = "查询";
	interpose.interposename.text="";
}


protected function InterposeSearchHandler(event:InterposeSearchEvent):void{
	interposeModel = event.model;
	interposeModel.start="0";
	interposeModel.dir="asc";
	interposeModel.end=pageSize.toString();
	serverPagingBar.navigateButtonClick("firstPage");
}

/**
 * 
 * 导入
 * 
 * */
protected function toolbar_toolEventImpExcelHandler(event:Event):void
{
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
	interposeModel.end = this.datanumbers.toString();				
	fefs.titles = new Array("序号","科目名称","参演人员","科目类型","故障类型","科目状态","资源类型",
		"设备名称","资源名称","操作人","操作时间","备注");				
	fefs.exportTypes = "演习科目管理";
	fefs.labels = "演习科目信息列表";
	fefs.model = interposeModel;
	MyPopupManager.addPopUp(fefs, this);
}

/**
 * 
 * 添加快捷方式
 * 
 * */
protected function toolbar_toolEventAddShortcutHandler(event:Event):void
{
	parentApplication.addShorcut('演习科目管理','alarmexperience');
}

/**
 * 
 * 删除快捷方式
 * 
 * */
protected function toolbar_toolEventDelShortcutHandler(event:Event):void
{
	parentApplication.delShortcut('演习科目管理');
}
/**
 * 点击列头对查询的所有结果进行排序  
 * */
protected function dg_headerReleaseHandler(event:DataGridEvent):void
{
	var dg:DataGrid = DataGrid(event.currentTarget);
	var dgm:DataGridColumn = dg.columns[event.columnIndex];
	var columnName:String=dgm.dataField;
	if(columnName=="interposetype"){
		columnName="I_INTERPOSE_TYPE";
	}if(columnName=="faulttype"){
		columnName="I_FAULT_TYPE";
	}if(columnName=="ismaininterpose"){
		columnName="IS_MAIN_INTERPOSE";
	}
	if(columnName=="isactive"){
		columnName="IS_ACTIVE";
	}
	if(columnName=="equipname"){
		columnName="equipcode";
	}
	if(columnName=="interposename"){
		columnName="INTERPOSE_NAME";
	}
	event.stopImmediatePropagation(); //阻止其自身的排序
	interposeModel.sort = columnName;
	interposeModel.start="0";
	interposeModel.end=pageSize.toString();
	if(sortName == columnName){
		if(dir){
			interposeModel.dir="asc";
			dir=false;
		}else{
			interposeModel.dir="desc";
			dir=true;
		}
	}else{
		sortName=columnName;
		dir = false;
		interposeModel.dir="asc";
	}
	serverPagingBar.navigateButtonClick("firstPage");
}


/**
 *设置激活
 */
 protected function toolbar_toolEventIsActiveHandler(event:Event):void{
	 if(dg.selectedItem != null){
		 ModelLocator.showConfimMessage("激活后不能对该演习科目进行修改和删除操作，确认要激活吗?",this,setEventIsActiveResult);
	 }else{
		 Alert.show("请先选中一条记录！","提示");
	 }
 }
 protected function setEventIsActiveResult(event:CloseEvent):void{
	 if (event.detail == Alert.YES) {
		 if(dg.selectedItem.isactive=="激活"){
			 Alert.show("已激活，请不要重复操作！");
			 return;
		 }else{
			 var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
			 remoteObject.endpoint = ModelLocator.END_POINT;
			 remoteObject.showBusyCursor = true;
			 alarmPersons = dg.selectedItem.user_id
			 fault_Type = dg.selectedItem.equiptype
			 remoteObject.checkEventHasSolution(dg.selectedItem);
			 remoteObject.addEventListener(ResultEvent.RESULT,checkEventHasSolutionResultHandler);
			 Application.application.faultEventHandler(remoteObject);
		 }
	 }
 }

protected function checkEventHasSolutionResultHandler(event:ResultEvent):void{
	//此处不进行  演习科目告警或者标准处理过程 的判断 直接进行生成告警
//	if(event.result.toString()=="success"){
		var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		if(fault_Type=="复用段"){
			remoteObject.setEventIsActive1(dg.selectedItem);
		}else{
			remoteObject.setEventIsActive(dg.selectedItem);
		}
		
		remoteObject.addEventListener(ResultEvent.RESULT,setEventIsActiveResultHandler);
		Application.application.faultEventHandler(remoteObject);
//	}else{
//		Alert.show("请先设置演习科目告警或者标准处理过程！","提示");
//	}
}

protected function setEventIsActiveResultHandler(event:ResultEvent):void{
	if(event.result.toString()=="success"){
		
		this.getAllInterpose("0",pageSize.toString());
		Alert.show("成功激活,是否打开告警列表？","提示",3,this,openAlarmCallBack);
	}else{
		
		Alert.show("操作失败！","提示");
	}
}

private function openAlarmCallBack(event:CloseEvent):void{
	if(event.detail==Alert.YES){
		subMessage.stopSendMessage("stop");
		subMessage.startSendMessage(alarmPersons);
	}
}

//进入告警配置页面
protected function showAlarmConfigHandler(e:ContextMenuEvent):void{
	Registry.register("interposeid",dg.selectedItem.interposeid);
	Registry.register("equipcode",dg.selectedItem.equipcode);
	Registry.register("interposetype",dg.selectedItem.interposetype);
	Registry.register("interposetypeid",dg.selectedItem.interposetypeid);
	Registry.register("faulttype",dg.selectedItem.faulttype);
	Registry.register("faulttypeid",dg.selectedItem.faulttypeid);
	if(e.currentTarget.caption == "查看告警现象配置") {
		Registry.register("equiptype",dg.selectedItem.equiptype);
		Application.application.openModel("告警现象配置",false);
	}

	if(e.currentTarget.caption == "查看标准处理过程"){
		Application.application.openModel("标准处理过程",false);
	}
}
protected function subMessage_resultHandler(event:ResultEvent):void  
{} 
/**
 * 获取当前时间
 */
protected function getNowTime():String{
	var dateFormatter:DateFormatter = new DateFormatter();
	dateFormatter.formatString = "YYYY-MM-DD JJ:NN:SS";
	var nowDate:String= dateFormatter.format(new Date());
	return nowDate;
}

/**
 *演习监控
 */
protected function toolbar_toolEventShowMonitorHandler(event:Event):void{
	if(dg.selectedItem != null){
		Registry.register("projectid",dg.selectedItem.interposeid);//要改
		Application.application.openModel("演习监控",false);
	}else{
		Alert.show("请先选中一条演习信息！","提示");
	}
}
