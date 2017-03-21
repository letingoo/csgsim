// ActionScript file

import com.adobe.serialization.json.JSON;

import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.actionscript.Registry;

import flash.events.ContextMenuEvent;
import flash.profiler.showRedrawRegions;
import flash.ui.ContextMenuItem;

import mx.collections.ArrayList;
import mx.collections.XMLListCollection;
import mx.controls.*;
import mx.core.Application;
import mx.events.ListEvent;
import mx.events.MenuEvent;
import mx.events.PropertyChangeEvent;
import mx.events.ScrollEvent;
import mx.events.TreeEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import sourceCode.ocableTopo.views.CarryBusiness;
import sourceCode.ocableTopo.views.businessInfluenced;
import sourceCode.ocableTopo.views.mixOcableMode;
import sourceCode.ocableTopo.views.ocableDetails;
import sourceCode.ocableTopo.views.ocableLink;

import twaver.*;
import twaver.network.interaction.InteractionEvent;

[Bindable]
public var selNode:XML;
private var netWorkSelectItem:*;
[Bindable]
public var XMLData:XMLList;
public var condition:String;
[Embed(source="assets/images/sysorg.png")]
public static const systemIcon:Class; 
[Embed(source="assets/images/toggle.gif")]
public static const toggle:Class;
public var rectmatrix:Array;
private function scrollto(x:Number,y:Number)
{
	var xindex:int=Math.floor(x/500)-1;
	var yindex:int=Math.floor(y/500)-1;
	if(xindex<0)xindex=0;
	if(yindex<0)yindex=0;
	var xend:int=xindex+3;
	var yend:int=yindex+3;
	if(xend>(rectmatrix[0] as Array).length)xend=(rectmatrix[0] as Array).length;
	if(yend>rectmatrix.length)yend=rectmatrix.length;
	
	for(var i:int=xindex;i<xend;i++)
	{
		
		for(var j:int=yindex;j<yend;j++)
		{
			if(rectmatrix[j][i]==false)
			{
				rectmatrix[j][i]=true;
				drawLine(i,j);
			}
		}
	}
}
private function mapscroll(e:ScrollEvent)
{
	
	var rect:Rectangle=systemorgmap1.getScopeRect(Consts.SCOPE_VIEWPORT);
	
	scrollto(rect.right,rect.bottom);
}
public function init():void {
	fw.getMaxOcablePoint();
	//fwm.getStationTree(); 
	
	//treeCanvas.addEventListener(TreeCheckBoxEvent.CHECKBOX_CLICK,treeCheckBoxHandler);
//	DemoUtils.addOverview(systemorgmap1);
	DemoUtils.initNetworkToolbarLite(toolbar1, systemorgmap1);
	DemoUtils.createButtonBar(toolbar1, [	
			DemoUtils.createButtonInfo("扩展", toggle,function():void
			{
				var visible:Boolean = !treeCanvas.visible;
				treeCanvas.visible = visible;
				treeCanvas.includeInLayout = visible; 
			})], false, false, -1, -1);
	var comboBox:ComboBox = DemoUtils.addInteractionComboBox(toolbar1, systemorgmap1, null, -1);
//	DemoUtils.initNetworkContextMenu(systemorgmap1, null);
	systemorgmap1.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
	systemorgmap1.addEventListener(ScrollEvent.SCROLL,mapscroll);
	systemorgmap1.addInteractionListener(netWorkFunction);
	this.callLater(function():void{
//		stage.addEventListener(FullScreenEvent.FULL_SCREEN, handleFullScreenChange);
	});
	addContextMenu();
}

private function addContextMenu():void
{
	systemorgmap1.contextMenu = new ContextMenu();
	systemorgmap1.contextMenu.hideBuiltInItems();
	systemorgmap1.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, 
		function(e:ContextMenuEvent):void
		{
			var p:Point = new Point(e.mouseTarget.mouseX / systemorgmap1.zoom, e.mouseTarget.mouseY / systemorgmap1.zoom);
			var data:ICollection = systemorgmap1.getElementsByLocalPoint(p);
			if (data.count > 0 && ((data.getItemAt(0) is Node) || (data.getItemAt(0) is Link)))
			{
				systemorgmap1.selectionModel.setSelection(data.getItemAt(0));
			}
			else
			{
				systemorgmap1.selectionModel.clearSelection();
			}
			
			var cmi_room:ContextMenuItem = new ContextMenuItem("机房平面图");
			cmi_room.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, popupMenuHandler);
			var cmi_ocable:ContextMenuItem = new ContextMenuItem("光缆截面图");
			cmi_ocable.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, popupMenuHandler);
			var cmi_business:ContextMenuItem = new ContextMenuItem("影响业务");
			cmi_business.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, popupMenuHandler);
			var cmi_mode:ContextMenuItem = new ContextMenuItem("混合敷设方式分界信息");
			cmi_mode.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,popupMenuHandler);
			var carryingBusiness:ContextMenuItem = new ContextMenuItem("光缆承载业务");
			carryingBusiness.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, popupMenuHandler);
			systemorgmap1.contextMenu.customItems = [cmi_room, cmi_ocable,cmi_business,cmi_mode,carryingBusiness]
			if (systemorgmap1.selectionModel.count == 0)
			{
				cmi_room.visible = false;
				cmi_ocable.visible = false;
				cmi_business.visible = false;
				cmi_mode.visible = false;
				carryingBusiness.visible = false;
			}
			else
			{
				if (data.getItemAt(0) is Node)
				{
					cmi_room.visible = true;
					cmi_ocable.visible = false;
					cmi_business.visible = false;
					cmi_mode.visible = false;
					carryingBusiness.visible = false;
				}
				else if (data.getItemAt(0) is Link)
				{
					cmi_room.visible = false;
					cmi_ocable.visible = true;
					cmi_business.visible = true;
					cmi_mode.visible = true;
					carryingBusiness.visible = true;
				}
			}
		});
}

private function popupMenuHandler(e:ContextMenuEvent):void
{
	var element:Element = Element(systemorgmap1.selectionModel.lastData);
//	var nwin:roomShelfView = new roomShelfView();
	var item:ContextMenuItem = ContextMenuItem(e.target);
	
	if ((item.caption == "机房平面图") && (element is Node))
	{
		var node:Node = systemorgmap1.selectionModel.selection.getItemAt(0);
		var stationcode:String = node.id.toString().split("s")[1];
		Registry.register("stationcode",stationcode);
		Application.application.openModel("机房平面图", false);
	}
	else if ((item.caption == "光缆截面图") && (element is Link))
	{
		popOcableLink(element as Link);
	}
	else if ((item.caption == "影响业务") && (element is Link))
	{
		popBusinessInfluenced(element as Link);
	}else if((item.caption == "混合敷设方式分界信息") && (element is Link)){
		popMode(element as Link);
	}else if((item.caption == "光缆承载业务") && (element is Link))
	{
		popCarryingBusiness(element as Link);
	}
}

private function doubleClickHandler(e:MouseEvent):void{
	if(systemorgmap1.selectionModel.selection.count>0)
	{
		var item:Object = systemorgmap1.selectionModel.selection.getItemAt(0);
		if (item is Node)
		{
			var node:Node = item as Node;
			var stationcode:String = node.id.toString().split("s")[1];
			Registry.register("stationcode",stationcode);
			Application.application.openModel("机房平面图", false);
		}
		else if (item is Link)
		{
			popOcableLink(item as Link);
		}
		
	}
}

//private function popOcableDetails(item:Link):void
//{
//	var winOcableDetails:ocableDetails = new ocableDetails();
//	
//	winOcableDetails.apointcode = item.fromNode.id.toString().substr(1,20);
//	winOcableDetails.zpointcode = item.toNode.id.toString().substr(1,20);
//	winOcableDetails.ocablecode = item.id.toString().substr(1,20);
//	parentApplication.openModel("光缆截面图",true,winOcableDetails);
//}

private function popOcableLink(item:Link):void
{
	var winOcableLink:ocableLink = new ocableLink();
	
	winOcableLink.apointcode = item.fromNode.id.toString().substr(1,20);
	winOcableLink.zpointcode = item.toNode.id.toString().substr(1,20);
	winOcableLink.ocablecode = item.id.toString().substr(1,20);
	winOcableLink.apointname = item.fromNode.name.toString();
	winOcableLink.zpointname = item.toNode.name.toString();
	parentApplication.openModel("光缆截面图  ",true,winOcableLink);
}

private function popBusinessInfluenced(item:Link):void
{
	var winBusinessInfluenced:businessInfluenced = new businessInfluenced();
	
	winBusinessInfluenced.setParameters("00023500000030222422#00023500000030222982", "ocable");
	parentApplication.openModel("影响业务",true,winBusinessInfluenced);
}

private function popCarryingBusiness(item:Link):void{
	var winCarryBusiness:CarryBusiness = new CarryBusiness();
	winCarryBusiness.sectioncode = item.id.toString();
//	Alert.show(item.id.toString());
	winCarryBusiness.sectioncode= "00000000000000042619";
	parentApplication.openModel("光缆承载业务",true,winCarryBusiness);
}

private function popMode(item:Link):void{
	var ocbleMode:mixOcableMode = new mixOcableMode;
	ocbleMode.apointcode = item.fromNode.name.toString();
	ocbleMode.zpointcode = item.toNode.name.toString();
//	ocbleMode.ocablecode = item.name.toString();
//	Alert.show(item.name.toString());
//	Alert.show(item.fromNode.name.toString());
//	
//	ocbleMode.apointcode = item.fromNode.id.toString().substr(1,20);
//	ocbleMode.zpointcode = item.toNode.id.toString().substr(1,20);
	ocbleMode.ocablecode = item.id.toString().substr(1,20);
	parentApplication.openModel("混合敷设方式分界信息",true,ocbleMode);
//	MyPopupManager.addPopUp(ocbleMode, true);
}
function getMaxOcablePoint(event:ResultEvent):void{
	
	var xml:String = event.result.toString();
	var model:Object=JSON.decode(xml);
	var x:Number=parseFloat(model.apointx);
	var y:Number=parseFloat(model.apointy);
	var xcount:int=Math.floor(x/500)+1;
	var ycount:int=Math.floor(y/500)+1;
	var i:int=0;
	var j:int=0;
	rectmatrix=new Array();
	for(j=0;j<ycount;j++)
	{
		var array:Array=new Array();
		for(i=0;i<xcount;i++)
		{
			array.push(false);
		}
		rectmatrix.push(array);
	}
	for(j=0;j<3;j++)
	{
		for(i=0;i<3;i++)
		{
			drawLine(i,j);
			rectmatrix[j][i]=true;
		}
	}
	
}


public function drawLine(xindex:int,yindex:int):void
{
	var backgroundData:RemoteObject = new RemoteObject("ocableTopologyService");
	backgroundData.endpoint = ModelLocator.END_POINT;
	backgroundData.showBusyCursor = "true";
	backgroundData.getLine(xindex,yindex);
	
	backgroundData.addEventListener(ResultEvent.RESULT,getLineResult);
	function getLineResult(event:ResultEvent):void{
		var lineData:String = event.result.toString();
		var lineXML:XMLList = new XMLList(lineData);
		//Alert.show(lineXML.child("XINDEX").toString());
		var indexx:int=parseInt(lineXML.child("XINDEX"));
		var indexy:int=parseInt(lineXML.child("YINDEX"));
		//Alert.show(indexx+","+indexy);
		//rectmatrix[indexy][indexx]=true;
		//Alert.show(rectmatrix[indexx][indexy]+";");
		var lineNumber:int = lineXML.child("LINE").length();
		var i:int = 0;
		var box:ElementBox=systemorgmap1.elementBox;
		for(i=0;i<lineNumber;i++)
		{
			var apoint:String=lineXML.child("LINE")[i].child("A_POINT");
			var apointtype:String=lineXML.child("LINE")[i].child("A_POINTTYPE");
			var zpoint:String=lineXML.child("LINE")[i].child("Z_POINT");
			var zpointtype:String=lineXML.child("LINE")[i].child("Z_POINTTYPE");
			
			var apointx:Number=lineXML.child("LINE")[i].child("A_POINT_X");
			
			var apointy:Number=lineXML.child("LINE")[i].child("A_POINT_Y");
			
			var zpointx:Number=lineXML.child("LINE")[i].child("Z_POINT_X");
			
			var zpointy:Number=lineXML.child("LINE")[i].child("Z_POINT_Y");
			var apointname=lineXML.child("LINE")[i].child("A_POINT_NAME");
			var zpointname=lineXML.child("LINE")[i].child("Z_POINT_NAME");
			var ocablecode=lineXML.child("LINE")[i].child("SECTIONCODE");
			var ocablename=lineXML.child("LINE")[i].child("OCABLENAME");
			var length:String=lineXML.child("LINE")[i].child("OLENGTH");
			var fibercount:String=lineXML.child("LINE")[i].child("FIBERCOUNT");
			var color:uint =lineXML.child("LINE")[i].child("SECTIONCOLOR");
			//Alert.show(color.toString(10));
			var anode:Node;
			var znode:Node;
			var xlength:int = lineXML.child("LINE")[i].child("X").length();
			//Alert.show(lineXML.child("LINE")[i].child("A_POIN_X").toString());
			//Alert.show(apointx+","+apointy+","+zpointy+","+zpointx);
			if(apointtype=="1")
			{
				anode=box.getDataByID("s"+apoint) as Node;
				if(anode==null)
				{
					anode=new Node("s"+apoint);
					anode.setStyle(Styles.OUTER_COLOR,0x00ff00);
					anode.setSize(60,25);
					anode.name=apointname;
					
					box.add(anode);
					anode.centerLocation=new Point(apointx,apointy);
				}
			}
			else
			{
				anode=box.getDataByID("t"+apoint) as Node;
				if(anode==null){
					anode=new Node("t"+apoint)
					anode.setStyle(Styles.OUTER_COLOR,0x00ff00);
					anode.setSize(60,25);
					anode.name=apointname;
					
					box.add(anode);
					anode.centerLocation=new Point(apointx,apointy);
				}
			}
			if(zpointtype=="1")
			{
				znode=box.getDataByID("s"+zpoint) as Node;
				if(znode==null)
				{
					znode=new Node("s"+zpoint);
					znode.setStyle(Styles.OUTER_COLOR,0x00ff00);
					znode.setSize(60,25);
					znode.name=zpointname;
					
					box.add(znode);
					znode.centerLocation=new Point(zpointx,zpointy);
				}
			}
			else
			{
				znode=box.getDataByID("t"+zpoint) as Node;
				if(znode==null)
				{
					znode=new Node("t"+zpoint);
					znode.setStyle(Styles.OUTER_COLOR,0x00ff00);
					znode.setSize(60,25);
					znode.name=zpointname;
					
					box.add(znode);
					znode.centerLocation=new Point(zpointx,zpointy);
				}
			}
			anode.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
			anode.setStyle(Styles.SELECT_COLOR,0x0000ff);
			anode.setStyle(Styles.SELECT_WIDTH,5);
			znode.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
			znode.setStyle(Styles.SELECT_WIDTH,5);
			znode.setStyle(Styles.SELECT_COLOR,0x0000ff);
			
			var link:ShapeLink=box.getDataByID("o"+ocablecode) as ShapeLink;
			
			if(link==null){
				link=new ShapeLink("o"+ocablecode,anode,znode);

				for(var j:int =0; j<xlength; j++)
					link.addPoint(new Point(lineXML.child("LINE")[i].child("X")[j],lineXML.child("LINE")[i].child("Y")[j]));
				
				link.setStyle(Styles.LINK_COLOR,color);
				link.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
				link.setStyle(Styles.SELECT_WIDTH,3);
				box.add(link);
			}
		}
	}
}

/**
 * @netWork的Click事件,获取图中鼠标点击的当前对象。
 * */
protected function network_clickHandler(event:MouseEvent):void
{
	// TODO Auto-generated method stub
	
	if(systemorgmap1.selectionModel.count > 0){
		netWorkSelectItem = systemorgmap1.selectionModel.selection.getItemAt(0);
		
		if(netWorkSelectItem is Link){
			Link(netWorkSelectItem).setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
			Link(netWorkSelectItem).setStyle(Styles.SELECT_WIDTH,'3');
		}
	}
}

/**
 * @netWork的所有事件。
 * */
private function netWorkFunction(e:InteractionEvent):void
{	
	if(netWorkSelectItem is Node)
	{		
		if(e.kind == "liveMoveEnd")
		{
//			var model:MapResourcesInfoModel = new MapResourcesInfoModel();
//			model.STATIONCODE = netWorkSelectItem.data.STATIONCODE;
//			model.MAP_X = (netWorkSelectItem as mapNode).x.toString();
//			model.MAP_Y = (netWorkSelectItem as mapNode).y.toString();
//			var remoteObjectLiveMoveEnd:RemoteObject = new RemoteObject("mapResourcesInfo");
//			remoteObjectLiveMoveEnd.endpoint = ModelLocator.END_POINT;
//			//remoteObjectLiveMoveEnd.addEventListener(ResultEvent.RESULT,updateStationHandler);
//			remoteObjectLiveMoveEnd.updateMapStation(model); 
		}		
	}
}

public function DealFault(event:FaultEvent):void {
	Alert.show(event.fault.toString());
	trace(event.fault);
}
private function fullScreen():void {
	try{
		if(stage.displayState == StageDisplayState.FULL_SCREEN) {
			stage.displayState = StageDisplayState.NORMAL;
		}else {
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}					
	}catch(e:*){
		Alert.show(e, "全屏出错啦！");
	}				
}

protected function searchbutton_clickHandler(event:MouseEvent):void
{
	if(searchtext.text!="")
	{
		var backgroundData:RemoteObject = new RemoteObject("ocableTopology");
		backgroundData.endpoint = ModelLocator.END_POINT;
		backgroundData.showBusyCursor = "true";
		backgroundData.getSearchStation(searchtext.text);
		backgroundData.addEventListener(ResultEvent.RESULT,getSearchResult);
		function getSearchResult(event:ResultEvent):void{
			var lineData:String = event.result.toString();
			var lineXML:XMLList = new XMLList(lineData);
			//Alert.show(lineXML.toString());
			searchResultList.dataProvider=lineXML.child("station");
			var lineNumber:int = lineXML.child("station").length();
			for(var i:int=0;i<lineNumber;i++)
			{
				var x:Number=lineXML.child("station")[i].child("x");
				var y:Number=lineXML.child("station")[i].child("y");
				scrollto(x,y);
			}
		}
	}
}


protected function searchResultList_itemDoubleClickHandler(event:ListEvent):void
{
	var stationcode:String=searchResultList.selectedItem.stationcode;
	var box:ElementBox=systemorgmap1.elementBox;
	var node:Node=box.getDataByID("s"+stationcode) as Node;
	if(node!=null)
	{
		systemorgmap1.selectionModel.clearSelection();
		systemorgmap1.selectionModel.appendSelection(node);
		systemorgmap1.centerByLogicalPoint(node.centerLocation.x,node.centerLocation.y);
	}
}

protected function drawlinkButton_clickHandler(event:MouseEvent):void
{	
	if(drawlinkbutton.selected){
		systemorgmap1.setCreateLinkInteractionHandlers(ShapeLink,function(link:ShapeLink){	
			link.setStyle(Styles.LINK_COLOR,0x800080);
			link.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
			link.setStyle(Styles.SELECT_WIDTH,3);
			drawlinkbutton.selected = false;
			systemorgmap1.setDefaultInteractionHandlers();
//			link.layerID = link.fromNode.layerID.toString() + "-" + link.toNode.layerID.toString();
//			if (link.fromNode.layerID.toString() > link.toNode.layerID.toString())
//				link.layerID = link.toNode.layerID.toString() + "-" + link.fromNode.layerID.toString();
			
		},Consts.LINK_TYPE_PARALLEL,false,-1,true);
	}else{
		systemorgmap1.setDefaultInteractionHandlers();
		
	}
}
