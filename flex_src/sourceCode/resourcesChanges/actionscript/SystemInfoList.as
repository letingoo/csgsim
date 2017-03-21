// ActionScript file
import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.events.IndexChangedEvent;
import mx.events.ResourceEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;
import mx.utils.ObjectProxy;

import org.flexunit.runner.Result;

import sourceCode.resourcesChanges.events.ChangeResourceEvent;
import sourceCode.resourcesChanges.model.*;
import sourceCode.resourcesChanges.views.SearchResource;


public var obj_query:ResourceModel;
public var his_query:HisResourceModel;
private var datanumbers:int;
private var hisnumber:int;
private function init():void
{
	
	obj_query=new ResourceModel();
	his_query=new HisResourceModel();
	obj_query.start="0";
	obj_query.limit="50";
	his_query.start="0";
	his_query.limit="50";
	addEventListener("getResult", getUpdateResources);	
	getUpdateResources();
	

	
}
private function getUpdateResources(event:Event=null):void
{
	
	if(this.tb_ack.selectedIndex==0)
	{
		
		var rtobj1:RemoteObject=new RemoteObject("resChangesDao");
		rtobj1.endpoint=ModelLocator.END_POINT;
		rtobj1.showBusyCursor=true;
		obj_query.start=(ResourceChange.pageIndex*ResourceChange.pageSize).toString();
		obj_query.limit=(ResourceChange.pageIndex * ResourceChange.pageSize + ResourceChange.pageSize).toString();
		rtobj1.addEventListener(ResultEvent.RESULT, afterGetUpdateResources);
		
		rtobj1.getUpdateResources(obj_query);
		
		parentApplication.faultEventHandler(rtobj1);
	}
	else if(this.tb_ack.selectedIndex==1)
	{
		
		var rtobj2:RemoteObject=new RemoteObject("resChangesDao");
		rtobj2.endpoint=ModelLocator.END_POINT;
		rtobj2.showBusyCursor=true;
		his_query.start=(ResourceChangeHistory.pageIndex*ResourceChangeHistory.pageSize).toString();
		his_query.limit=(ResourceChangeHistory.pageIndex * ResourceChangeHistory.pageSize + ResourceChangeHistory.pageSize).toString();
		rtobj2.addEventListener(ResultEvent.RESULT, afterGetAckResources);
		rtobj2.getAckResources(his_query);		
		parentApplication.faultEventHandler(rtobj2);
	}
	
	
	
}
private function afterGetAckResources(event:ResultEvent):void
{
	var resultmodel:ResultModel=event.result as ResultModel;	
	this.hisnumber=resultmodel.totalCount;	

	ResourceChangeHistory.onResult(resultmodel);
}
private function afterGetUpdateResources(event:ResultEvent):void
{
	
	
	var resultmodel:ResultModel=event.result as ResultModel;	
	this.datanumbers=resultmodel.totalCount;	
	ResourceChange.onResult(resultmodel);
	
}




protected function tb_ack_changeHandler(event:IndexChangedEvent):void
{
	
	
	
	if(tb_ack.selectedIndex==0)
	{
		
		ResourceChange.reLoadData();
		

	}
	else
	{
		ResourceChangeHistory.reLoadData();

	}
}
protected function exportExcelHandler(event:Event):void
{
	var titles:Array;
	var remote:RemoteObject=new RemoteObject("resChangesDao");
	remote.endpoint=ModelLocator.END_POINT;
	remote.showBusyCursor=true;
	remote.addEventListener(ResultEvent.RESULT, ExportResultHandler);
	if(tb_ack.selectedIndex==0)
	{
		titles=new Array("序号", "更新类型", "资源类型", "更新内容", "更新时间");		
		remote.resourceChangesExport(obj_query, ResourceChange.label, titles);
		
	}
	else
	{
		titles=new Array("序号", "更新类型", "资源类型", "更新内容", "更新时间","确认人","确认时间");		
		remote.hisResourceChangesExport(his_query, ResourceChangeHistory.label, titles);
	}
	
}
private function ExportResultHandler(event:ResultEvent):void
{
	
	var url:String=ModelLocator.getURL();
	var path:String=url + event.result.toString();	
	
	var request:URLRequest=new URLRequest(encodeURI(path));
	navigateToURL(request, "_blank");
	
	
}
protected function searchResourceHandler(event:Event):void
{
	var searchResource:SearchResource=new SearchResource();
	if(tb_ack.selectedIndex==0)
	{
		MyPopupManager.addPopUp(searchResource, true);		
		searchResource.init(obj_query.sync_status,obj_query.res_type,obj_query.content);
		searchResource.addEventListener("resourceSearchEvent",resourceSearchHandler);
		
		
	}
	else
	{
		MyPopupManager.addPopUp(searchResource, true);		
		searchResource.init(his_query.sync_status,his_query.res_type,his_query.content);
		searchResource.addEventListener("resourceSearchEvent",resourceSearchHandler);	
	}
}
protected function resourceSearchHandler(event:ChangeResourceEvent):void{
	
	if(this.tb_ack.selectedIndex==0)
	{
		
		var rtobj1:RemoteObject=new RemoteObject("resChangesDao");
		rtobj1.endpoint=ModelLocator.END_POINT;
		rtobj1.showBusyCursor=true;
		obj_query.sync_status=event.resource.sync_status;
		
		obj_query.res_type=event.resource.res_type;
		obj_query.content=event.resource.content;
		obj_query.start="0";
		obj_query.limit="50";
		rtobj1.addEventListener(ResultEvent.RESULT, afterGetUpdateResources);		
		rtobj1.getUpdateResources(obj_query);
		
		
	}
	else if(this.tb_ack.selectedIndex==1)
	{
		
		var rtobj2:RemoteObject=new RemoteObject("resChangesDao");
		rtobj2.endpoint=ModelLocator.END_POINT;
		rtobj2.showBusyCursor=true;
		his_query.sync_status=event.resource.sync_status;
		his_query.res_type=event.resource.res_type;
		his_query.content=event.resource.content;
		his_query.start="0";
		his_query.limit="50";
		rtobj2.addEventListener(ResultEvent.RESULT, afterGetAckResources);
		rtobj2.getAckResources(his_query);		
		
	}
	
	
}