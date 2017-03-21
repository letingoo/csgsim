import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

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

import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;

import sourceCode.autoGrid.view.ShowProperty;
import sourceCode.resManager.resBusiness.events.BusinessRessEvent;
import sourceCode.resManager.resBusiness.model.BusinessRessModel;
//import sourceCode.resManager.resBusiness.model.ResultModel;
import sourceCode.resManager.resBusiness.titles.SearchCircuitTitle;
import sourceCode.resManager.resBusiness.titles.TitleRess;
import sourceCode.resManager.resNet.model.CCModel;
import sourceCode.resManager.resNet.titles.CCSearch;
import sourceCode.systemManagement.model.PermissionControlModel;
import sourceCode.tableResurces.Events.ToopEvent;
import sourceCode.tableResurces.model.ResultModel;
import sourceCode.tableResurces.views.DataImportFirstStep;
import sourceCode.tableResurces.views.FileExportFirstStep;

		
private var UnusedCCCount:int = 0;
private var ccModel:CCModel = new CCModel();
private var pageIndex:int=0;  //第几页
private var pageSize:int=50; //每页显示数
private var datanumbers:int; //总数据量
private var isDelete:Boolean = true;
private var isSearch:Boolean = false;
private var dir:Boolean = true; //排序方式   true 升序 ，false 降序
private var sortName:String =""; //当前排序的列名

private function init():void{
	refreshText();
	//增加
	serverPagingBar.dataGrid=dg;
	serverPagingBar.pagingFunction=pagingFunction;
	serverPagingBar.addEventListener("returnALL",showAllDataHandler);
	//获取交叉连接列表
	getCCListNew("0",pageSize.toString());
}
private function refreshText():void{
	var obj1:RemoteObject = new RemoteObject("resBusinessDwr");
	obj1.endpoint=ModelLocator.END_POINT;
	obj1.getUnusedCCCount();
	obj1.addEventListener(ResultEvent.RESULT,getCountResultsHandler);
	Application.application.faultEventHandler(obj1);
}
private function deleteUnusedCC():void{
	var obj1:RemoteObject = new RemoteObject("resBusinessDwr");
	obj1.endpoint=ModelLocator.END_POINT;
	obj1.deleteUnusedCC();
	obj1.addEventListener(ResultEvent.RESULT,resultsHandler);
	Application.application.faultEventHandler(obj1);
}

private function getCountResultsHandler(e:ResultEvent):void{
	if(e.result!=null){
		UnusedCCCount = (int)(e.result.toString());
	}
	showCount.text = "共有"+UnusedCCCount.toString()+"个时隙碎片";
}
private function resultsHandler(e:ResultEvent):void{
	if(e.result!=null){
		if(e.result.toString()=="success"){
			Alert.show("成功整理"+UnusedCCCount.toString()+"个时隙碎片！","提示");
			refreshText();
		}else{
			Alert.show("整理失败！","提示");
		}
	}
}
private function pagingFunction(pageIndex:int,pageSize:int):void{
	this.pageSize=pageSize;
	getCCListNew((pageIndex*pageSize).toString(),(pageIndex*pageSize+pageSize).toString());
	this.pageIndex = pageIndex;
}
/**
 * 
 * 获取交叉列表
 * 
 * */
private function getCCListNew(start:String,end:String):void{
	//链接数据库
	var ccObj:RemoteObject=new RemoteObject("resNetDwr");
	//一页显示的条数，start为0，end为20？
	ccModel.start = start;
	ccModel.end = end ;
	//处理结果监听
	ccObj.addEventListener(ResultEvent.RESULT,resultHandler);
	//默认处理结果
	Application.application.faultEventHandler(ccObj);
	ccObj.endpoint = ModelLocator.END_POINT;
	ccObj.showBusyCursor = true;
	//查询所有设备
	ccModel.otherType="unused";
	ccObj.getCCListNew(ccModel); 
}

private function showAllDataHandler(event:Event):void{
	getCCListNew("0",serverPagingBar.totalRecord.toString());
}

public function resultHandler(event:ResultEvent):void{
	var result:ResultModel=event.result as ResultModel;
	this.datanumbers = result.totalCount;
	onResult(result);
}
public function onResult(result:ResultModel):void 
{
	serverPagingBar.orgData=result.orderList;
	serverPagingBar.totalRecord=result.totalCount;
	serverPagingBar.dataBind(true);					
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
	ccModel.sort = columnName;
	ccModel.start="0";
	ccModel.end=pageSize.toString();
	if(sortName == columnName){
		if(dir){
			ccModel.dir="asc";
			dir=false;
		}else{
			ccModel.dir="desc";
			dir=true;
		}
	}else{
		sortName=columnName;
		dir = false;
		ccModel.dir="asc";
	}
	serverPagingBar.navigateButtonClick("firstPage");
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
		remoteObject.delCCByid(dg.selectedItem);
		remoteObject.addEventListener(ResultEvent.RESULT,delStationResult);
		Application.application.faultEventHandler(remoteObject);
	}
}

public function delStationResult(event:ResultEvent):void{
	if(event.result.toString()=="success")
	{
		Alert.show("删除成功！","提示");
		serverPagingBar.navigateButtonClick("firstPage");
		refreshText();
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
//	//查询页面
//	var ccSearch:CCSearch = new CCSearch();
//	PopUpManager.addPopUp(ccSearch,this,true);
//	PopUpManager.centerPopUp(ccSearch);
//	
//	ccSearch.addEventListener("ccSearchEvent",ccSearchHandler);
//	ccSearch.title = "查询";
}