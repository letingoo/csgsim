// ActionScript file
import com.adobe.serialization.json.JSON;

import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.actionscript.Registry;
import common.other.SuperPanelControl.nl.wv.extenders.panel.PanelWindow;
import common.other.blogagic.util.HTMLToolTip;

import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.formatters.DateFormatter;
import mx.managers.PopUpManager;
import mx.managers.ToolTipManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.SerializationFilter;
import mx.rpc.remoting.mxml.RemoteObject;
import mx.utils.StringUtil;

import sourceCode.autoGrid.model.AutoGridModel;
import sourceCode.autoGrid.model.ResultModel;
import sourceCode.autoGrid.view.ShowProperty;
import sourceCode.ocableResource.model.FiberDetailsModel;
import sourceCode.ocableResource.views.FiberRoutInfo;
import sourceCode.ocableTopo.views.FiberCarryBusiness;
import sourceCode.ocableTopo.views.FiberProperty;
import sourceCode.ocableroute.model.OcableRouteData;
import sourceCode.ocableroute.views.OcableRoute;
import sourceCode.sysGraph.model.OcableRoutInfoData;
import sourceCode.sysGraph.views.OcableRoutInfo;
import sourceCode.sysGraph.views.SysOrgMap;

import twaver.*;
import twaver.ElementBox;
import twaver.Follower;
import twaver.Node;
import twaver.Utils;
import twaver.controls.GifImage;
import twaver.editor.pipe.RoundPipe;

[Embed(source="assets/images/ocable/bundle02.png")]
public static const bundle02:Class;
[Embed(source="assets/images/ocable/bundle03.png")]
public static const bundle03:Class;
[Embed(source="assets/images/ocable/bundle04.png")]
public static const bundle04:Class;
[Embed(source="assets/images/ocable/bundle05.png")]
public static const bundle05:Class;
[Embed(source="assets/images/ocable/bundle06.png")]
public static const bundle06:Class;
[Embed(source="assets/images/ocable/bundle07.png")]
public static const bundle07:Class;
[Embed(source="assets/images/ocable/bundle08.png")]
public static const bundle08:Class;
[Embed(source="assets/images/ocable/bundle09.png")]
public static const bundle09:Class;
[Embed(source="assets/images/ocable/bundle10.png")]
public static const bundle10:Class;
[Embed(source="assets/images/ocable/bundle11.png")]
public static const bundle11:Class;
[Embed(source="assets/images/ocable/bundle12.png")]
public static const bundle12:Class;
[Bindable] 
public var ocablegriddata:XMLList;//光缆段属性数据源
[Bindable]  
public var singlefibergriddata:XMLList;//光纤属性数据源
private var box:ElementBox;
private var cm:ContextMenu;

private var cmiSlot:ContextMenuItem = new ContextMenuItem("时隙分布图", true, true);
private var cmiSys:ContextMenuItem = new ContextMenuItem("系统组织图");
private var cmiOpera:ContextMenuItem = new ContextMenuItem("光纤承载业务");
private var cmiN1:ContextMenuItem = new ContextMenuItem("\"N-1\"分析");
private var cmiFiberRoute:ContextMenuItem = new ContextMenuItem("光纤路由");
private var cmiOcableRoute:ContextMenuItem = new ContextMenuItem("光路路由");
private var cmiAddFiber:ContextMenuItem = new ContextMenuItem("添加光纤", true);
private var cmiDelFiber:ContextMenuItem = new ContextMenuItem("删除光纤");
private var cmiAltFiber:ContextMenuItem = new ContextMenuItem("修改光纤");

private var indexRenderer:Class = SequenceItemRenderer;
public var apointcode:String = "";
public var zpointcode:String = "";
public var ocablecode:String = "";
private var newfiberserial:int = 0;
private var newfibercount:int = 0;
private var ocablesectionname:String = "";
private var propertycode:String = "";
private var length:String = "";
public var obj:Object;
public var titles:Array = new Array("光缆段名称","纤芯号","承载系统","类型","用途","状态","起始设备端口","终止设备端口","起始ODF端口","终止ODF端口","衰耗值(db)","总衰耗值(db)","波数", "产权","长度","备注");
[Binable]
private var btnlabel:String="<<";

private function init():void
{	
	Utils.registerImageByClass("bundle2", bundle02);
	Utils.registerImageByClass("bundle3", bundle03);
	Utils.registerImageByClass("bundle4", bundle04);
	Utils.registerImageByClass("bundle5", bundle05);
	Utils.registerImageByClass("bundle6", bundle06);
	Utils.registerImageByClass("bundle7", bundle07);
	Utils.registerImageByClass("bundle8", bundle08);
	Utils.registerImageByClass("bundle9", bundle09);
	Utils.registerImageByClass("bundle10", bundle10);
	Utils.registerImageByClass("bundle11", bundle11);
	Utils.registerImageByClass("bundle12", bundle12);
	
	SerializationSettings.registerGlobalProperty("holeIndex", Consts.TYPE_INT);
	SerializationSettings.registerGlobalProperty("innerWidth", Consts.TYPE_NUMBER);
	SerializationSettings.registerGlobalProperty("innerColor", Consts.TYPE_INT);
	SerializationSettings.registerGlobalProperty("innerAlpha", Consts.TYPE_INT);
	SerializationSettings.registerGlobalProperty("innerPattern", Consts.TYPE_ARRAY_NUMBER);
	SerializationSettings.registerGlobalProperty("isHorizontal", Consts.TYPE_BOOLEAN);
	SerializationSettings.registerGlobalProperty("cellCounts", Consts.TYPE_ARRAY_NUMBER);
	SerializationSettings.registerGlobalProperty("holeCount", Consts.TYPE_INT, false, false);
	SerializationSettings.registerGlobalProperty("isCenterHole", Consts.TYPE_BOOLEAN, false, false);
	
	SerializationSettings.registerGlobalClient("FiberData", Consts.TYPE_DATA);
	SerializationSettings.registerGlobalClient("isFiber", Consts.TYPE_BOOLEAN);
	
	ToolTipManager.toolTipClass = HTMLToolTip;
	
	
	this.box = this.nwOcableGraph.elementBox;
	this.nwOcableGraph.addSelectionChangeListener(this.selectionChanged);
	nwOcableGraph.movableFunction = function():Boolean{
		return false;
	};
	
	addContextMenu();
	
	roOcableTopo.getOcableList(apointcode, zpointcode);
	PanelWindow(this.parent).closeButton.addEventListener(MouseEvent.CLICK,refreshOcableView);//关闭光缆截面图时刷新光缆接线图
}
private function exportFiberInfo():void
{
	var fdml:FiberDetailsModel = new FiberDetailsModel(); 
	fdml.sectioncode =this.ocablecode;
	var remoteobj2:RemoteObject = new RemoteObject("mapResourcesInfo"); 
	remoteobj2.endpoint = ModelLocator.END_POINT;
	remoteobj2.showBusyCursor = true;
	remoteobj2.addEventListener(ResultEvent.RESULT,ExportExcelHandler);
	remoteobj2.ExportExcel("光纤详细信息",titles,fdml);
}
public function ExportExcelHandler(event:ResultEvent):void{
	var path:String = event.result.toString();
	var request:URLRequest = new URLRequest(encodeURI(StringUtil.trim(path))); 
	navigateToURL(request,"_blank");
	
}
private function refreshOcableView(event:MouseEvent):void
{
	obj.drawTopo(); 
}
protected function addContextMenu():void
{
	cm = new ContextMenu();
	
	nwOcableGraph.contextMenu = cm;

	cm.addEventListener(ContextMenuEvent.MENU_SELECT, cm_menuSelect);	
	cmiSlot.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, cmiSlot_menuSelectHandler);
	cmiSys.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, cmiSys_menuSelectHandler);
	cmiOpera.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, cmiOpera_menuSelectHandler);
	cmiN1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, cmiN1_menuSelectHandler);
	cmiFiberRoute.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, cmiFiberRoute_menuSelectHandler);
	cmiOcableRoute.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, cmiOcableRoute_menuSelectHandler);
	
	cmiAddFiber.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, cmiAddFiber_menuSelectHandler);
	cmiDelFiber.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, cmiDelFiber_menuSelectHandler);
	cmiAltFiber.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, cmiAltFiber_menuSelectHandler);
}

protected function ro_resultHandler(event:ResultEvent):void
{
	var lineData:String = event.result.toString();
	var lineXML:XMLList = new XMLList(lineData);
	
	ocableList.dataProvider=lineXML.child("ocable");
	this.ocablesectionname = lineXML.child("ocable")[0].label;
	this.propertycode = lineXML.child("ocable")[0].propertycode;
	getOcableTopoOcableInfo(ocablecode);
}

protected function itemClickHandler(event:ListEvent):void
{
//	ocablecode = ocableList.selectedItem.code;
//	getOcableTopoOcableInfo(ocablecode);
}



// 右键
private function cm_menuSelect(e:Event):void
{
	cm.hideBuiltInItems();
	if(nwOcableGraph.selectionModel.count > 0)
	{
		var item:Object = nwOcableGraph.selectionModel.selection.getItemAt(0);
		var isRoundPipe:Boolean = item is RoundPipe;
		
		if (isRoundPipe)
		{
			if ((item as RoundPipe).getClient("isFiber") == true)
			{
				cm.customItems = [cmiSlot, cmiSys, cmiOpera, cmiN1, cmiFiberRoute, cmiOcableRoute, cmiAddFiber, cmiDelFiber,cmiAltFiber];
				cmiSlot.visible = true;
				cmiSys.visible = true;
				cmiOpera.visible = true;
				cmiN1.visible = true;
				cmiFiberRoute.visible = true;
				cmiOcableRoute.visible = true;
				cmiAddFiber.visible = true;
				cmiDelFiber.visible = true;
				cmiAltFiber.visible = true;
			}
			else
			{
				cm.customItems = [cmiAddFiber];
				cmiAddFiber.visible = true;
			}
			
		}
		else
		{
			cmiSlot.visible = false;
			cmiSys.visible = false;
			cmiOpera.visible = false;
			cmiN1.visible = false;
			cmiFiberRoute.visible = false;
			cmiOcableRoute.visible = false;
			cmiAddFiber.visible = false;
			cmiDelFiber.visible = false;
			cmiAltFiber.visible = false;
		}
	}
	else
	{
		cmiSlot.visible = false;
		cmiSys.visible = false;
		cmiOpera.visible = false;
		cmiN1.visible = false;
		cmiFiberRoute.visible = false;
		cmiOcableRoute.visible = false;
		cmiAddFiber.visible = false;
		cmiDelFiber.visible = false;
		cmiAltFiber.visible = false;
	}
	
}

// 右键查看时隙信息
private function cmiSlot_menuSelectHandler(event:ContextMenuEvent):void
{
	
	if(nwOcableGraph.selectionModel.count > 0)
	{
		var fiberPipe:RoundPipe = (nwOcableGraph.selectionModel.selection.getItemAt(0)) as RoundPipe;
		var fibercode:String = fiberPipe.getClient("FiberData").@fibercode;
		var fiberserial:String = fiberPipe.getClient("FiberData").@fiberserial;
		
		var roGetTopolinkByFiber:RemoteObject = new RemoteObject("ocableTopology");
		roGetTopolinkByFiber.endpoint = ModelLocator.END_POINT;
		roGetTopolinkByFiber.showBusyCursor = true;
		//			roGetTopolinkByFiber.getTopolinkByFiber(fibercode, fiberserial); // 有数据时
//		roGetTopolinkByFiber.getTopolinkByFiber("00000000000000028149", "7"); // 北电库测试数据
					roGetTopolinkByFiber.getTopolinkByFiber("00000000000000029171", "2"); // 国电库测试数据
		roGetTopolinkByFiber.addEventListener(ResultEvent.RESULT, getResultHandler);
		
	}
	
	function getResultHandler(evt:ResultEvent):void
	{
		var topolinkStr:String = evt.result.toString();
		var label:String = topolinkStr.split('^')[0];
		var linerate:String = topolinkStr.split('^')[1];
		var systemcode:String = topolinkStr.split('^')[2];
		
		Registry.register("backsystem", systemcode);
		Registry.register("backlinerate", linerate);
		Registry.register("backlabel", label);
		Registry.register("label", label);
		Registry.register("linerate", linerate);
		Registry.register("systemcode", systemcode);
		
		Application.application.openModel("时隙分布图", false);
	}
}

//系统组织图
private function cmiSys_menuSelectHandler(e:ContextMenuEvent):void
{
	var sys:SysOrgMap = new SysOrgMap();
	parentApplication.openModel("系统组织图",true,sys);
}

//光纤承载业务
private function cmiOpera_menuSelectHandler(e:ContextMenuEvent):void
{
	var fiberPipe:RoundPipe = (nwOcableGraph.selectionModel.selection.getItemAt(0)) as RoundPipe;
	var fibercode:String = fiberPipe.getClient("FiberData").@fibercode;
	var fiberCarryBusiness:FiberCarryBusiness = new FiberCarryBusiness();
	fiberCarryBusiness.fibercode=fibercode;
	parentApplication.openModel("光纤承载业务",true,fiberCarryBusiness);
}

private function cmiN1_menuSelectHandler(e:ContextMenuEvent):void
{
	var winBusinessInfluenced:businessInfluenced = new businessInfluenced();
	winBusinessInfluenced.setParameters(this.ocablecode,"ocable");
	parentApplication.openModel("\"N-1\"分析",true,winBusinessInfluenced);
	
}

private function cmiFiberRoute_menuSelectHandler(e:ContextMenuEvent):void
{
	if(nwOcableGraph.selectionModel.count > 0)
	{
		var fiberPipe:RoundPipe = (nwOcableGraph.selectionModel.selection.getItemAt(0)) as RoundPipe;
		var fibercode:String = fiberPipe.getClient("FiberData").@fibercode;
		var fri:FiberRoutInfo = new FiberRoutInfo();
		fri.title = "光纤路由";
		fri.fibercode = fibercode;
		MyPopupManager.addPopUp(fri);
	}

}

private function cmiOcableRoute_menuSelectHandler(e:ContextMenuEvent):void
{
	if(nwOcableGraph.selectionModel.count > 0)
	{
		var fiberPipe:RoundPipe = (nwOcableGraph.selectionModel.selection.getItemAt(0)) as RoundPipe;
		
		var fibercode:String = fiberPipe.getClient("FiberData").@fibercode;
		var ro:RemoteObject = new RemoteObject("ocableRoute");
		ro.endpoint = ModelLocator.END_POINT;
		ro.showBusyCursor = true;
		ro.getOcableRouteByFiber(fibercode);
		ro.addEventListener(ResultEvent.RESULT,getOcableRoutInfoByFiberHandler);
	}

}

private function cmiAddFiber_menuSelectHandler(e:ContextMenuEvent):void
{
	Alert.show("您确定要添加光纤吗?","请您确认!",Alert.YES|Alert.NO,this,addFiberHandler,null,Alert.NO);
}

private function addFiberHandler(event:CloseEvent):void{
	if(event.detail == Alert.YES){
		if(nwOcableGraph.selectionModel.count > 0)
		{
			var fiberObj:FiberDetailsModel = new FiberDetailsModel();
			fiberObj.sectioncode = this.ocablecode;
			fiberObj.fiberserial = this.newfiberserial.toString();
			fiberObj.property = this.propertycode;
			fiberObj.ocablesectionname = this.ocablesectionname;
			fiberObj.length = this.length;
			fiberObj.updateperson = parentApplication.curUser;
			fiberObj.updatedate = this.getCurrentDate();
			
			var remoteobj:RemoteObject = new RemoteObject("ocableTopology"); 
			remoteobj.endpoint = ModelLocator.END_POINT;
			remoteobj.showBusyCursor = true;
			remoteobj.addSingleFiber(fiberObj, newfibercount);
			remoteobj.addEventListener(ResultEvent.RESULT,
				function(e:ResultEvent):void
				{
					if (e.result == true)
					{
						Alert.show("光纤添加成功", "提示");
						roOcableTopo.getOcableList(apointcode, zpointcode);
					}
					else
					{
						Alert.show("光纤添加失败", "提示");
					}
				});
		}
	}
}
//光纤属性修改
private function cmiAltFiber_menuSelectHandler(event:ContextMenuEvent):void{
	if(nwOcableGraph.selectionModel.count > 0){
		var temp:* = nwOcableGraph.selectionModel.lastData;
		var fiberPipe:RoundPipe;
		if(temp is RoundPipe){
			fiberPipe = temp as RoundPipe;
			if(fiberPipe.getClient("isFiber") == true){
				
				var property:ShowProperty = new ShowProperty();
				property.title =  "修改光纤";
				property.paraValue =fiberPipe.getClient("FiberData").@fibercode;
				property.tablename = "VIEW_EN_FIBER_PROPERTY";
				property.key = "FIBERCODE";
				
						
				
				
				
				PopUpManager.addPopUp(property, this, true);
				PopUpManager.centerPopUp(property);
				
				property.addEventListener("savePropertyComplete",function (event:Event):void{
					PopUpManager.removePopUp(property);
					
				});
				
//				var property:ShowProperty = new ShowProperty();
//				property.paraValue = fiberPipe.getClient("FiberData").@fibercode;
//				property.tablename = "VIEW_FIBER";
//				property.key = "FIBERCODE";
//				property.title = "修改光纤";
//				
//				PopUpManager.addPopUp(property, this, true);
//				PopUpManager.centerPopUp(property);
//				
//				property.addEventListener("savePropertyComplete",function (event:Event):void{
//					PopUpManager.removePopUp(property);
//				});
			}
		}
	}
}


public function getCurrentDate():String
{
	var formatter:DateFormatter = new DateFormatter();
	formatter.formatString = "YYYY-MM-DD";
	var date:Date = new Date();
	
	return formatter.format(date);
}

private function cmiDelFiber_menuSelectHandler(e:ContextMenuEvent):void
{
	Alert.show("您确认要删除光纤吗?","请您确认!",Alert.YES|Alert.NO,this,deleteFiberHandler,null,Alert.NO);
}

private function deleteFiberHandler(event:CloseEvent):void{
	if(event.detail == Alert.YES){
		if(nwOcableGraph.selectionModel.count > 0)
		{
			var temp:* = nwOcableGraph.selectionModel.lastData;
			var fiberPipe:RoundPipe;
			if(temp is RoundPipe){
				fiberPipe = temp as RoundPipe;
				if(fiberPipe.getClient("isFiber") == true){
					var remoteObj:RemoteObject = new RemoteObject("netresDao");
					remoteObj.endpoint = ModelLocator.END_POINT;
					remoteObj.showBusyCursor = true;
					remoteObj.deleteFiberByFibercode(String(fiberPipe.getClient("FiberData").@fibercode),ocablecode);
					remoteObj.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
						if(event.result.toString() == "success"){
							roOcableTopo.getOcableList(apointcode, zpointcode);
						}else if(event.result.toString() == "check"){
							Alert.show("该光纤关联了光口，请先解除关联关系","提示");
						}else{
							Alert.show("删除失败");
						}
					});
					//Application.application.faultEventHandler(remoteObj);
				}
			}
			//		var fiberPipe:RoundPipe = (nwOcableGraph.selectionModel.selection.getItemAt(0)) as RoundPipe;
			//		var fiberserial:String = fiberPipe.getClient("FiberData").@fiberserial;
			//		var remoteobj:RemoteObject = new RemoteObject("fiberWire"); 
			//		remoteobj.endpoint = ModelLocator.END_POINT;
			//		remoteobj.showBusyCursor = true;
			//		remoteobj.addEventListener(ResultEvent.RESULT,getOcableRoutInfoByFiberHandler);
			//		remoteobj.getOcableRoutInfoByFiber(this.ocablecode,fiberserial);
		}
	}
}
private function getOcableRoutInfoByFiberHandler(event:ResultEvent):void{
	var fiberPipe:RoundPipe = (nwOcableGraph.selectionModel.selection.getItemAt(0)) as RoundPipe;
	var fibercode:String = fiberPipe.getClient("FiberData").@fibercode;
	var ocableRouteData:OcableRouteData = new OcableRouteData();
	ocableRouteData = event.result as OcableRouteData;
	if(ocableRouteData == null){
		Alert.show("没有配置连接关系","提示");
		return;
	}
	if(ocableRouteData.content.content =="blank"){
		Alert.show("该ODF口没有配置连接关系","提示");
		return;
	}else if(ocableRouteData.content.content == "noport"){
		Alert.show("生成端口数据错误","提示");
		return;
	}if(ocableRouteData.content.content =="fault"){
		Alert.show("生成路由失败，请检查数据是否正确","提示");
		return;
	}
	
	var ocableRoute:OcableRoute = new OcableRoute();
	ocableRoute.ocableRouteData = ocableRouteData;
	ocableRoute.nodecode = fibercode;
	ocableRoute.nodetype ="3";
	parentApplication.openModel("光路路由",false,ocableRoute);
	
}

public function getOcableTopoOcableInfo(sectioncode:String):void 
{   
	var roOcableInfo:RemoteObject = new RemoteObject("ocableTopology");
	roOcableInfo.endpoint = ModelLocator.END_POINT;
	roOcableInfo.showBusyCursor = true;
	roOcableInfo.getOcableTopoOcableInfo(sectioncode);
	roOcableInfo.addEventListener(ResultEvent.RESULT,ocableInfoResultHandler);
	
	var roFiberInfo:RemoteObject = new RemoteObject("ocableTopology");
	roFiberInfo.endpoint = ModelLocator.END_POINT;
	roFiberInfo.showBusyCursor = true;
	roFiberInfo.getOcableTopoFiberInfo(sectioncode);
	roFiberInfo.addEventListener(ResultEvent.RESULT,fiberInfoResultHandler);	
}

public function ocableInfoResultHandler(event:ResultEvent):void 
{   
	var xml:String = event.result.toString();				
	ocablegriddata = new XMLList(xml);
	ocablegrid.dataProvider = ocablegriddata;
	
	var length:String = ocablegriddata[6].col2;
	this.length = length;
}

public function fiberInfoResultHandler(event:ResultEvent):void 
{   
	var xml:XML = new XML(event.result.toString());
	var fibergriddata:ArrayCollection = new ArrayCollection();
	var fibernum:int = xml.children().length();//光纤数目
	var bundleAmount:int = 0; //管数
	var bundleCapacity:int = 0; //每管芯数
	
	if (fibernum == 0)
	{
		Alert.show("该光缆段无光纤", "提示");
		newfiberserial = 0;
	}
	else
	{
		newfiberserial = xml.children()[fibernum - 1].@fiberserial;
	}
	newfiberserial = newfiberserial +1;
	newfibercount = fibernum + 1;
	
	this.box.clear();
	
	// 绘制光缆整体轮廓
	var rpOcable:RoundPipe = new RoundPipe();
	rpOcable.location = new Point(180, 100);
	rpOcable.setSize(400, 400);
	rpOcable.setStyle(Styles.VECTOR_OUTLINE_COLOR, 0x000000);
	rpOcable.setStyle(Styles.VECTOR_OUTLINE_WIDTH, 50);
	rpOcable.innerColor = 0x000000;
	rpOcable.innerWidth = 1;
	rpOcable.holeCount = 50;
	rpOcable.setStyle(Styles.VECTOR_FILL_COLOR, 0x000000);
	rpOcable.setClient("isFiber", false);
	this.box.add(rpOcable);
	
	//光缆段名称
	var folName:Follower = new Follower();
	folName.name = this.ocablesectionname;
	folName.image = "";
	folName.setStyle(Styles.LABEL_POINTER_LENGTH,-50);
	folName.setStyle(Styles.LABEL_SIZE, 20);
	folName.setStyle(Styles.LABEL_COLOR, 0x0049EE);
	folName.setStyle(Styles.LABEL_BOLD, true);
	folName.setStyle(Styles.LABEL_POSITION, Consts.POSITION_CENTER);
	folName.host = rpOcable;
	folName.setLocation(362, 30);
	this.box.add(folName);
	
	var rpHole:RoundPipe = new RoundPipe();
	rpHole.parent = rpOcable;
	rpHole.holeIndex = 49;
	rpHole.host = rpOcable;
	rpHole.setStyle(Styles.VECTOR_OUTLINE_COLOR, 0x009966);
	rpHole.setStyle(Styles.VECTOR_OUTLINE_WIDTH, 10);
	rpHole.setStyle(Styles.VECTOR_FILL_COLOR, 0xFFFFCC);
	rpHole.setClient("isFiber", false);
	rpHole.innerColor = 0x000000;
	rpHole.innerWidth = 0;
	this.box.add(rpHole);
	
	// 根据总芯数划分管数和每管芯数
	if (fibernum > 0 && fibernum < 9)
	{
		bundleAmount = 5;
		bundleCapacity = 4;
	}
	else if (fibernum > 8 && fibernum < 25)
	{
		bundleAmount = 5;
		bundleCapacity = 6;
	}
	else if (fibernum > 24 && fibernum < 37)
	{
		bundleAmount = 6;
		bundleCapacity = 6;
	}
	else if (fibernum > 36 && fibernum < 49)
	{
		bundleAmount = 6;
		bundleCapacity = 8;
	}
	else if (fibernum > 48 && fibernum < 73)
	{
		bundleAmount = 6;
		bundleCapacity = 12;
	}
	else if (fibernum > 72 && fibernum < 97)
	{
		bundleAmount = 8;
		bundleCapacity = 12;
	}
	else if (fibernum > 96 && fibernum < 145)
	{
		bundleAmount = 12;
		bundleCapacity = 12;
	}
	
	// 绘制管
	rpHole.holeCount = bundleAmount + 1;
	if (fibernum == 0)
	{
		rpHole.holeCount = 0;
	}
	for (var i:int = 0; i < rpHole.holeCount; i++)
	{
		var rpBundle:RoundPipe = new RoundPipe();
		rpBundle.parent = rpHole;
		rpBundle.holeIndex = i;
		rpBundle.host = rpHole;
		rpBundle.setStyle(Styles.VECTOR_OUTLINE_COLOR, 0x000000);
		rpBundle.setStyle(Styles.VECTOR_OUTLINE_WIDTH, 2);
		rpBundle.isCenterHole = false;
		
		if(rpHole.holeCount - 1 != i)
		{
			rpBundle.setStyle(Styles.VECTOR_FILL_COLOR, 0xFFFFFF);
			rpBundle.holeCount = bundleCapacity;
			rpBundle.innerColor = 0xFFFFFF;
			rpBundle.innerAlpha = 0;
		}
		
		rpBundle.setClient("isFiber", false);
		this.box.add(rpBundle);
	}
	
	// 绘制芯（光纤）
	for (var i:int = 0; i < fibernum; i++)
	{
		var arrxml:XML = xml.children()[i];
		var drawserial:int = i + 1;
		var fiberserial:int = arrxml.@fiberserial; // 光纤序号
		var rpFiber:RoundPipe = new RoundPipe();
		var color:String = getFiberLinkColor(drawserial, bundleCapacity);  // 光纤颜色
		var seqInBundle:int = drawserial % bundleCapacity  // 光纤在管中序号
		var bundleID:int = getFiberLinkBundleID(drawserial, bundleCapacity);  // 光纤所属管ID		
		var tooltip:String = "<b>纤芯序号: </b>" + fiberserial + "<br>";
//			+ "<b>通道类型: </b>" + arrxml.@fibermodel + "<br>";
		var rpParent:RoundPipe = rpHole.getPipeHoleByHoleIndex(bundleID) as RoundPipe;
		rpParent.setStyle(Styles.VECTOR_FILL_COLOR, 0xFFFF66);
		rpParent.setStyle(Styles.VECTOR_OUTLINE_COLOR, 0x3333CC);
		rpParent.setStyle(Styles.VECTOR_OUTLINE_WIDTH, 5);
		
		rpFiber.toolTip = tooltip;
		rpFiber.setStyle(Styles.VECTOR_FILL_COLOR, color);
		rpFiber.setStyle(Styles.VECTOR_OUTLINE_COLOR, 0x000000);
		rpFiber.setStyle(Styles.VECTOR_OUTLINE_WIDTH, 1);
		rpFiber.parent = rpParent;
		rpFiber.holeIndex = seqInBundle;
		rpFiber.host = rpParent;
		rpFiber.setClient("FiberData", arrxml);
		rpFiber.setClient("isFiber", true);
		rpFiber.name = "" + fiberserial;
		rpFiber.setStyle(Styles.LABEL_POSITION, Consts.POSITION_CENTER);
		
		this.box.add(rpFiber);
	}
}

private function getFiberLinkColor(fiberSerial:int, bundleCapacity:int):String
{
	switch (fiberSerial % bundleCapacity) // 12光纤为一组的情况
	{
		case 0: return "0x33FFFF"; //青
		case 1: return "0x0000FF"; //蓝
		case 2: return "0xFF6600"; //橙
		case 3: return "0x006600"; //绿
		case 4: return "0xCC0000"; //朱
		case 5: return "0x666666"; //灰
		case 6: return "0xCCCCCC"; //白
		case 7: return "0xFF0000"; //红
		case 8: return "0x000000"; //黑
		case 9: return "0xFFFF00"; //黄
		case 10: return "0x990099"; //紫
		case 11: return "0xFF66CC"; //粉
		default: return "0x999933"; //土
	}
}

private function getFiberLinkBundleID(fiberSerial:int, bundleCapacity:int):int
{
	return ((fiberSerial - 1) / bundleCapacity);
}

private function selectionChanged(e:SelectionChangeEvent):void
{
		if (this.box.selectionModel.count != 1)
		{
			this.singlefibergrid.visible = false;
			this.singlefibergrid.includeInLayout = false;
			return;
		}
		
		var item:Object = this.box.selectionModel.lastData;
		var isRoundPipe:Boolean = item is RoundPipe;
		
		if (isRoundPipe && (item as RoundPipe).getClient("isFiber"))
		{
			var round:RoundPipe = RoundPipe(this.box.selectionModel.lastData);
			var xml:String = "";
			
			xml +=  "<fiber> <col1>所属光缆接续段</col1> <col2>"+round.getClient("FiberData").@ocablesectionname+"</col2></fiber>";
			xml +=  "<fiber> <col1>纤芯号</col1> <col2>"+round.getClient("FiberData").@fiberserial+"</col2></fiber>";
			xml +=  "<fiber> <col1>起始设备端口</col1> <col2>"+round.getClient("FiberData").@aendeqport+"</col2></fiber>";
			xml +=  "<fiber> <col1>终止设备端口</col1> <col2>"+round.getClient("FiberData").@zendeqport+"</col2></fiber>";
			xml +=  "<fiber> <col1>起始ODF端口</col1> <col2>"+round.getClient("FiberData").@aendodfport+"</col2></fiber>";
			xml +=  "<fiber> <col1>终止ODF端口</col1> <col2>"+round.getClient("FiberData").@zendodfport+"</col2></fiber>";
//			xml +=  "<fiber> <col1>承载业务</col1> <col2>"+round.getClient("FiberData").@name_std+"</col2></fiber>";
			xml +=  "<fiber> <col1>长度</col1> <col2>"+round.getClient("FiberData").@length+"</col2></fiber>";
			xml +=  "<fiber> <col1>产权</col1> <col2>"+round.getClient("FiberData").@property+"</col2></fiber>";
			xml +=  "<fiber> <col1>状态</col1> <col2>"+round.getClient("FiberData").@status+"</col2></fiber>";
			xml +=  "<fiber> <col1>类型</col1> <col2>"+round.getClient("FiberData").@fibermodel+"</col2></fiber>";
			xml +=  "<fiber> <col1>衰耗值</col1> <col2>"+round.getClient("FiberData").@attenuation+"</col2></fiber>";			
			xml +=  "<fiber> <col1>更新人</col1> <col2>"+round.getClient("FiberData").@updateperson+"</col2></fiber>";
			xml +=  "<fiber> <col1>更新时间</col1> <col2>"+round.getClient("FiberData").@updatedate+"</col2></fiber>";
			xml +=  "<fiber> <col1>备注</col1> <col2>"+round.getClient("FiberData").@remark+"</col2></fiber>";
			singlefibergriddata = new XMLList(xml);
			//singlefibergrid.dataProvider = singlefibergriddata;
			this.singlefibergrid.visible = true;
			this.singlefibergrid.includeInLayout = true;
		}
		else
		{
			this.singlefibergrid.visible = false;
			this.singlefibergrid.includeInLayout = false;
		}
	
}



public function DealFault(event:FaultEvent):void {
	Alert.show(event.fault.toString());
	
}



private function changeState():void{
	if(this.text.visible){
		this.cvsOcable.percentWidth=30;
		this.text.visible=false;
		this.text.includeInLayout=false;
		this.vbOcable.visible = true;
		this.vbOcable.includeInLayout = true;
		this.linkButton.label=">>";
		this.mypanel.title="所属光缆段信息";
	}else{
		this.cvsOcable.width=25;
		this.vbOcable.visible=false;
		this.vbOcable.includeInLayout=false;
		this.text.visible=true;
		this.text.includeInLayout=true;
		this.linkButton.label="<<";
		this.mypanel.title="";
	}
}

