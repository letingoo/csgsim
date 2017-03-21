import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.actionscript.Registry;

import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.DataGrid;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.Application;
import mx.events.CloseEvent;
import mx.events.DataGridEvent;
import mx.events.FlexEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import sourceCode.businessAnalysis.views.BraResultShow;
import sourceCode.systemManagement.model.PermissionControlModel;
import sourceCode.tableResurces.Events.ToopEvent;
import sourceCode.tableResurces.model.ResultModel;
import sourceCode.tableResurces.views.DataImportFirstStep;
import sourceCode.tableResurces.views.FileExportFirstStep;

import twaver.DemoUtils;

[Bindable]
public var allBusiness:ArrayCollection = new ArrayCollection();

[Bindable]
public var allSearchBusiness:ArrayCollection = new ArrayCollection();
private var analysisType:String = "";

private function init():void{
	//定制右键菜单
	var contextMenu:ContextMenu=new ContextMenu();
	dg.contextMenu=contextMenu;
	dg.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,function(e:ContextMenuEvent):void{
		var item:ContextMenuItem = new ContextMenuItem("查看电路路由");
		item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
		var flexVersion:ContextMenuItem=new ContextMenuItem(DemoUtils.FLEX_SDK_VERSION, false, false);
		var playerVersion:ContextMenuItem=new ContextMenuItem(DemoUtils.FLASH_PLAYER_VERSION, false, false);
		if(dg.selectedItems.length==0){//选中元素个数
			dg.contextMenu.hideBuiltInItems();
			dg.contextMenu.customItems = [flexVersion,playerVersion];
		}
		else{
			dg.contextMenu.hideBuiltInItems();
			dg.contextMenu.customItems = [item];
		}
	});
}

private function itemSelectHandler(e:ContextMenuEvent):void{
	if(dg.selectedItem!=null){
		var busname:String= dg.selectedItem.BUSINESS_NAME;
		if(busname!=""){
			var rtCarry:RemoteObject = new RemoteObject("businessAnalysis");
			rtCarry.addEventListener(ResultEvent.RESULT,resultCarryHandler);
			rtCarry.endpoint = ModelLocator.END_POINT;
			rtCarry.showBusyCursor = true;
			rtCarry.getBusinessInfo(busname);//add by xgyin
		}
	}
}

public function resultCarryHandler(event:ResultEvent):void{
	var arr:Array = event.result.toString().split("==");
	
	if(arr.length==2){
		Registry.register("para_circuitcode", arr[0]);
		Registry.register("para_circuitype", arr[1]);
		Application.application.openModel("方式信息", false);
	}else{
		Alert.show("没有相应的电路！","提示！");
	}
}

public function queryData():void{
	allSearchBusiness = new ArrayCollection();
	var name:String=resname.text;		
	for(var i:int=0;i<allBusiness.length;i++){
		var obj:Object = allBusiness.getItemAt(i);
		var objname:String = obj.BUSINESS_NAME;
		if(objname.indexOf(name)!=-1){
			allSearchBusiness.addItem(obj);
		}
	}
}

private function close():void{
	PopUpManager.removePopUp(this);
}

private function checkedAll():void{
	for(var i:int=0; i<allSearchBusiness.length; i++){
		if(!allSearchBusiness.getItemAt(i).available){
			allSearchBusiness.getItemAt(i).available = true;
			dg.indexToItemRenderer(i).document.abox.selected=true;
		}
	}
}
private function clearSelected():void{
	for(var i:int=0; i<allSearchBusiness.length; i++){
		if(allSearchBusiness.getItemAt(i).available){
			allSearchBusiness.getItemAt(i).available = false;
			dg.indexToItemRenderer(i).document.abox.selected=false;
		}
	}
}
private function analysisN1():void{
	analysisType = "N-1";
	var selectedBus:ArrayCollection = new ArrayCollection();
	for(var i:int=0; i<allSearchBusiness.length; i++){
		if(allSearchBusiness.getItemAt(i).available)
			selectedBus.addItem(allSearchBusiness.getItemAt(i));
	}
	var obj1:RemoteObject = new RemoteObject("BraDwr");
	obj1.endpoint=ModelLocator.END_POINT;
	obj1.getN1Result(selectedBus);
	obj1.addEventListener(ResultEvent.RESULT,getNXResultsHandler);
	Application.application.faultEventHandler(obj1);
	
}
private function analysisN2():void{
	analysisType = "N-2";
	var selectedBus:ArrayCollection = new ArrayCollection();
	for(var i:int=0; i<allSearchBusiness.length; i++){
		if(allSearchBusiness.getItemAt(i).available)
			selectedBus.addItem(allSearchBusiness.getItemAt(i));
	}
	var obj1:RemoteObject = new RemoteObject("BraDwr");
	obj1.endpoint=ModelLocator.END_POINT;
	obj1.getN2Result(selectedBus);
	obj1.addEventListener(ResultEvent.RESULT,getNXResultsHandler);
	Application.application.faultEventHandler(obj1);
}
private function getBusResultsHandler(e:ResultEvent):void{
	if(e.result!=null){
		allSearchBusiness = e.result as ArrayCollection;
		for(var i:int=0; i<allSearchBusiness.length; i++){
			allSearchBusiness.getItemAt(i).available = false;
		}
	}
}
private function getNXResultsHandler(e:ResultEvent):void{
	if(e.result!=null){
		var resultArr:ArrayCollection = e.result as ArrayCollection;
		var braResult:BraResultShow = new BraResultShow();
		PopUpManager.addPopUp(braResult, this, true);    
		PopUpManager.centerPopUp(braResult);
		var busStr:String = "";
		for(var i:int=0; i<allSearchBusiness.length; i++){
			if(allSearchBusiness.getItemAt(i).available)
				busStr+=allSearchBusiness.getItemAt(i).BUSINESS_NAME + " ";
		}
		braResult.setInfo(resultArr, busStr,analysisType);
	}
}