import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.actionscript.Registry;
import common.other.events.EventNames;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.utils.setTimeout;

import mx.collections.*;
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.CheckBox;
import mx.controls.Image;
import mx.controls.Label;
import mx.controls.ToolTip;
import mx.controls.Tree;
import mx.core.Application;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.events.MenuEvent;
import mx.events.ToolTipEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import sourceCode.faultSimulation.model.OperateListEvent;
import sourceCode.faultSimulation.model.OperateListModel;
import sourceCode.faultSimulation.model.StdMaintainProModel;
import sourceCode.faultSimulation.titles.OperateSearch;
import sourceCode.tableResurces.model.ResultModel;

private var xml:XML;
private var mouseTarget:DisplayObject;
[Bindable]   
public var folderCollection:XMLList;

[Bindable]			
private var cm:ContextMenu;

[Bindable]
private var acUserInfo:ArrayCollection;
public var operateModel:OperateListModel = new OperateListModel();

public var lastRollIndex:int;
private var pageSize:int=50;
[Bindable]
private var isSearch:Boolean = true;
[Bindable]
private var isExport:Boolean = true;
[Bindable]
private var isShortCut:Boolean = false;
public var userid:String;
private var selectedNode:XML;  
private var interposeid:String;  
private var type:String;

public function init():void{
	interposeid = Registry.lookup("projectid");//该ID实际是演习科目ID
	var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
	remoteObject.endpoint = ModelLocator.END_POINT;
	remoteObject.showBusyCursor = true;
	remoteObject.getOperateUserIdByID(interposeid,"","root");//查询干预名称，参与人员
	remoteObject.addEventListener(ResultEvent.RESULT,resultCallBack);
	Application.application.faultEventHandler(remoteObject);
	
	cm = new ContextMenu();
	cm.addEventListener(ContextMenuEvent.MENU_SELECT, contextMenu_menuSelect);
}

private function contextMenu_menuSelect(evt:ContextMenuEvent):void {	
	treeInterpose.selectedIndex = lastRollIndex;
}

//查询用户列表，用户树数据
private function resultCallBack(event:ResultEvent):void{
	folderCollection=new XMLList(event.result.toString()); 
	treeInterpose.dataProvider = folderCollection.interpose;

}



public  function initParameter():void
{
	interposeid = Registry.lookup("projectid");
}

protected function getOperateByUseridHandler(event:ResultEvent):void{
	//给列表赋值
	var result:ResultModel=event.result as ResultModel;
	onResult(result);
	//查询标准流程图
	getStdFlowByID(interposeid);
}	

protected function getStdFlowByID(interposeid:String):void{
	var rt:RemoteObject = new RemoteObject("faultSimulation");
	rt.endpoint = ModelLocator.END_POINT;
	rt.showBusyCursor =true;
	rt.addEventListener(ResultEvent.RESULT, getStdFlowByIdHandler);
	Application.application.faultEventHandler(rt);
	rt.getStdFlowByID(interposeid);
}

//画标准流程图
protected function getStdFlowByIdHandler(event:ResultEvent):void{
	var result:ResultModel=event.result as ResultModel;
	var list:ArrayCollection=result.orderList;
	var model:StdMaintainProModel = new StdMaintainProModel();
	if(list.length>0){
		for(var i:int=0;i<list.length-1;i++){
			model = list.getItemAt(i) as StdMaintainProModel;
			
			var image1:Image = new Image();
			image1.width=140;
			image1.height=50;
			image1.source="assets/images/mydocument/flow_bg.png";
			image1.toolTip=model.operatetype;
			image1.x=30;
			image1.y=70*i;
			
			var label:Label = new Label();
			label.text=model.operatetype;
			label.x=45;
			label.y=15+70*i;
			
			var image2:Image = new Image();
			image2.width=140;
			image2.height=35;
			image2.source="assets/images/mydocument/flow_down.png";
			image2.x=80;
			image2.y=38+70*i;
			
			xmlCanvas.addChild(image1);
			xmlCanvas.addChild(label);
			xmlCanvas.addChild(image2);
		}
		model = list.getItemAt(list.length-1) as StdMaintainProModel;
		var image1:Image = new Image();
		image1.width=140;
		image1.height=50;
		image1.source="assets/images/mydocument/flow_bg.png";
		image1.toolTip=model.operatetype;
		image1.x=30;
		image1.y=70*(list.length-1);
		
		var label:Label = new Label();
		label.text=model.operatetype;
		label.x=45;
		label.y=15+70*(list.length-1);
		
		xmlCanvas.addChild(image1);
		xmlCanvas.addChild(label);
	}
	
	//获取用户操作流程步骤
	var rt:RemoteObject = new RemoteObject("faultSimulation");
	rt.endpoint = ModelLocator.END_POINT;
	rt.showBusyCursor =true;
	rt.addEventListener(ResultEvent.RESULT, getUserFlowByIdHandler);
	Application.application.faultEventHandler(rt);
	rt.getUserFlowByID(interposeid,userid);
}

//画用户操作流程图
protected function getUserFlowByIdHandler(event:ResultEvent):void{
	var result:ResultModel=event.result as ResultModel;
	var list:ArrayCollection=result.orderList;
	var model:OperateListModel = new OperateListModel();
	if(list.length>0){
		for(var i:int=0;i<list.length-1;i++){
			model = list.getItemAt(i) as OperateListModel;
			
			var image1:Image = new Image();
			image1.width=140;
			image1.height=50;
			image1.source="assets/images/mydocument/flow_bg.png";
			image1.toolTip=model.operatetype;
			image1.x=30;
			image1.y=70*i;
			
			var label:Label = new Label();
			label.text=model.operatetype;
			label.x=45;
			label.y=15+70*i;
			
			var image2:Image = new Image();
			image2.width=140;
			image2.height=35;
			image2.source="assets/images/mydocument/flow_down.png";
			image2.x=80;
			image2.y=38+70*i;
			
			userFlow.addChild(image1);
			userFlow.addChild(label);
			userFlow.addChild(image2);
		}
		model = list.getItemAt(list.length-1) as OperateListModel;
		var image1:Image = new Image();
		image1.width=140;
		image1.height=50;
		image1.source="assets/images/mydocument/flow_bg.png";
		image1.toolTip=model.operatetype;
		image1.x=30;
		image1.y=70*(list.length-1);
		
		var label:Label = new Label();
		label.text=model.operatetype;
		label.x=45;
		label.y=15+70*(list.length-1);
		
		userFlow.addChild(image1);
		userFlow.addChild(label);
	}
}

//点击树触发事件：
private function treeChange():void{ 	
	try{	
		treeInterpose.selectedIndex = lastRollIndex;
		if(this.treeInterpose.selectedItem.@isBranch==true){
			selectedNode = this.treeInterpose.selectedItem as XML; 
			userid = this.treeInterpose.selectedItem.@id;
			type="userid";
			this.dispatchEvent(new Event(EventNames.CATALOGROW));
		}
	}catch(e:Error){
		Alert.show(e.message);
	}
}  

//点击树项目取到其下一级子目录  
private function initEvent():void{  
	operateModel.start = "0";
	operateModel.end = "50" ;
	this.addEventListener(EventNames.CATALOGROW,gettree);
}  
private function gettree(e:Event):void{  
	try{
		this.removeEventListener(EventNames.CATALOGROW,gettree);
		var rt:RemoteObject = new RemoteObject("faultSimulation");
		rt.endpoint = ModelLocator.END_POINT;
		rt.showBusyCursor =true;
		rt.addEventListener(ResultEvent.RESULT, generateDeviceTreeInfo);
		Application.application.faultEventHandler(rt);
		rt.getOperateUserIdByID(interposeid,userid,type);//
		
	}catch(e:Error){
		Alert.show(e.toString());
	}
}  

private function generateDeviceTreeInfo(event:ResultEvent):void
{
	try{
		
		var str:String = event.result as String;  
		
		if(str!=null&&str!="")
		{  
			var child:XMLList= new XMLList(str);
			if(selectedNode)
			{
				
				if(selectedNode.children()==null||selectedNode.children().length()==0)
				{ 			
					treeInterpose.expandItem(selectedNode, false, true);
					selectedNode.appendChild(child);
					treeInterpose.expandItem(selectedNode, true, true);
				}
			}
			
		}
		this.addEventListener(EventNames.CATALOGROW,gettree);
	}catch(e:Error)
	{
		Alert.show(e.message);	
	}  
}

private function deviceiconFun(item:Object):*
{
	if(item.@isBranch==false)
		return ModelLocator.equipIcon;
	else
		return ModelLocator.systemIcon;
}


private function pagingFunction(pageIndex:int,pageSize:int):void{
	var start:String = (pageIndex * pageSize).toString();
	var end:String = ((pageIndex * pageSize) + pageSize).toString();
	operateModel.start = start;
	operateModel.end = end ;
	operateModel.interposeid=interposeid;
	operateModel.updateperson=userid;
	var rt:RemoteObject = new RemoteObject("faultSimulation");
	rt.endpoint = ModelLocator.END_POINT;
	rt.showBusyCursor =true;
	rt.addEventListener(ResultEvent.RESULT, getOperateByUseridHandler);
	Application.application.faultEventHandler(rt);
	rt.getAllOperateListByUser(operateModel);
}

private function onResult(result:ResultModel):void{
	
	serverPagingBar.orgData=result.orderList;
	serverPagingBar.totalRecord=result.totalCount;
	serverPagingBar.dataBind(true);	
}


/**
 * 
 * 查询
 * 
 * */
protected function toolbar_toolEventSearchHandler(event:Event):void
{
	var operateSearch:OperateSearch = new OperateSearch();
	PopUpManager.addPopUp(operateSearch,Application.application as DisplayObject,true);
	PopUpManager.centerPopUp(operateSearch);
	operateSearch.addEventListener("OperateListEvent",InterposeSearchHandler);
	operateSearch.title = "查询";
}


protected function InterposeSearchHandler(event:OperateListEvent):void{
	operateModel = event.model;
	operateModel.start="0";
	operateModel.dir="asc";
	operateModel.end=pageSize.toString();
	serverPagingBar.navigateButtonClick("firstPage");
}
/**
 * 
 * 导出
 * 
 * */
protected function toolbar_toolEventEmpExcelHandler(event:Event):void
{
	
}

public function treeCheck(e:Event):void{
	try{
		if(e.target is CheckBox){
			var node:XML=treeInterpose.selectedItem as XML;
			var pnode:XML = treeInterpose.getParentItem(treeInterpose.selectedItem) as XML;
			if(node.@isBranch==false)
			{
				if(e.target.hasOwnProperty('selected')){
					//清空流程图
					xmlCanvas.removeAllChildren();
					userFlow.removeAllChildren();
					if(e.target.selected)
					{
						var xmllist:*=treeInterpose.dataProvider;
						var xmlcollection:XMLListCollection=xmllist;	
						
						for each ( var systemelement:XML in xmlcollection.children())
						{
							var psnode:XML = treeInterpose.getParentItem(systemelement) as XML;
							if(systemelement.@id!=node.@id||systemelement.@id==node.@id&&psnode.@id!=pnode.@id)
							{
								systemelement.@checked="0";
							}
						}
						var operModel:OperateListModel = new OperateListModel;
						operModel.interposeid=interposeid;
						operModel.updateperson= treeInterpose.selectedItem.@id;
						userid = treeInterpose.selectedItem.@id;
						operModel.start = "0";
						operModel.end = "50" ;
						var rtobj:RemoteObject=new RemoteObject("faultSimulation");
						rtobj.endpoint=ModelLocator.END_POINT;
						rtobj.showBusyCursor=true;
						rtobj.addEventListener(ResultEvent.RESULT, getOperateByUseridHandler);
						Application.application.faultEventHandler(rtobj);
						rtobj.getAllOperateListByUser(operModel);
					}else{
						//取消数据的显示
						node.@checked="0";
						serverPagingBar.orgData=null;
						serverPagingBar.totalRecord=0;
						serverPagingBar.dataBind(true);
					}
				}
			}
		}
	}catch(e:Error){
		Alert.show(e.toString());
	}
}

private function tree_itemClick(evt:ListEvent):void {
	try{
		var item:Object = Tree(evt.currentTarget).selectedItem;
		if (treeInterpose.dataDescriptor.isBranch(item)) {
			treeInterpose.expandItem(item, !treeInterpose.isItemOpen(item), true);
		}
	}catch(e:Error){
		Alert.show(e.message);
	}
}