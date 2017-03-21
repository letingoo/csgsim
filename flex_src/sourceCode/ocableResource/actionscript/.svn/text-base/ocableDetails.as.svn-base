// ActionScript file
import com.adobe.serialization.json.JSON;

import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.actionscript.Registry;
import common.other.blogagic.util.HTMLToolTip;

import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.Label;
import mx.core.Application;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.formatters.DateFormatter;
import mx.managers.PopUpManager;
import mx.managers.ToolTipManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import org.flexunit.runners.ParentRunner;

import sourceCode.autoGrid.view.ShowProperty;
import sourceCode.ocableResource.model.FiberDetailsModel;
import sourceCode.ocableResource.model.FiberDetailsResultModel;
import sourceCode.ocableResource.model.OcableRoutInfoData;
import sourceCode.ocableResource.model.ResultModel;
import sourceCode.ocableResource.views.FiberRoutInfo;
import sourceCode.ocableResource.views.OcableRoutInfo;
import sourceCode.ocableResource.views.SysOrgMap;
import sourceCode.ocableResource.views.ocableResource;
import sourceCode.ocableResource.views.ocableResourceView;
import sourceCode.ocableResource.views.viewFiberDetails;
import sourceCode.resManager.resNode.Titles.SearchEquipByStationTitle;
import sourceCode.resManager.resNode.Titles.SearchSlotTitle;

import twaver.*;
import twaver.ElementBox;
import twaver.Follower;
import twaver.Node;
import twaver.Utils;
import twaver.controls.GifImage;
import twaver.editor.pipe.RoundPipe;

[Embed(source="assets/images/swf/ocable/nodestation.png")]
public static const station:Class;

[Embed(source="assets/images/swf/ocable/led_icon.png")]
public static const point:Class;

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
public var folderList:XMLList= new XMLList(); 
[Bindable]   
public var folderCollection:XMLList;
[Bindable]   
public var arrayData:ArrayCollection = new ArrayCollection();
public var ocablegriddata:XMLList;
public var fibergriddata:ArrayCollection;
public var singlefibergriddata:XMLList;
public var dgSingleFiberData:XMLList;
private var box:ElementBox;
private var boxParallel:ElementBox;
private var cm:ContextMenu;
private var cmPara:ContextMenu;
private var cmiSlot:ContextMenuItem = new ContextMenuItem("查看时隙信息", true, true);
private var cmiSys:ContextMenuItem = new ContextMenuItem("光纤通信");
private var cmiOpera:ContextMenuItem = new ContextMenuItem("光纤承载业务");
private var cmiN1:ContextMenuItem = new ContextMenuItem("\"N-1\"分析");
private var cmiFiberRoute:ContextMenuItem = new ContextMenuItem("光纤路由");
private var cmiOcableRoute:ContextMenuItem = new ContextMenuItem("光路路由");
private var addFiber:ContextMenuItem = new ContextMenuItem('添加光纤',false,Application.application.isEdit);
private var updateFiber:ContextMenuItem = new ContextMenuItem('修改光纤',false,Application.application.isEdit);
private var deleteFiber:ContextMenuItem = new ContextMenuItem('删除光纤',false,Application.application.isEdit);

private var indexRenderer:Class = SequenceItemRenderer;
public var apointcode:String = "";
public var zpointcode:String = "";
public var ocablecode:String = "";
private var boxLayer:Layer;
[Binable]
private var btnlabel:String="<<";

public var ocableresourceview:ocableResourceView;


private function init():void
{	
	
	Utils.registerImageByClass("nodeStation",station);
	Utils.registerImageByClass("nodeStationChild",point);
	
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
	SerializationSettings.registerGlobalClient("fibercode", Consts.TYPE_STRING);
	SerializationSettings.registerGlobalClient("fiberserial", Consts.TYPE_STRING);
	
	ToolTipManager.toolTipClass = HTMLToolTip;
	
	this.box = this.nwOcableGraph.elementBox;
	this.nwOcableGraph.addSelectionChangeListener(this.selectionChanged);
	nwOcableGraph.movableFunction = function():Boolean{
		return false;
	};
	this.boxParallel = this.nwOcableGraphParallel.elementBox;
	this.nwOcableGraphParallel.addSelectionChangeListener(this.selectionChangedPara);
	nwOcableGraphParallel.movableFunction = function():Boolean{
		return false;
	};
	
	boxLayer = new Layer("boxLayer");
	nwOcableGraphParallel.elementBox.layerBox.add(boxLayer, 0);
	
	nwOcableGraphParallel.doubleClickToLinkBundle = false
	
	addContextMenu();
	
	roOcableTopo.getOcableList(apointcode, zpointcode);
	
	var fdm:FiberDetailsModel = new FiberDetailsModel();
	fdm.sectioncode= ocablecode;
	fdm.start ="0";
	fdm.end = "100";
	var remoteObject:RemoteObject = new RemoteObject("ocableResources");
	remoteObject.endpoint = ModelLocator.END_POINT;
	remoteObject.showBusyCursor = true;
	remoteObject.addEventListener(ResultEvent.RESULT,getFiberDetailsHandler);
	remoteObject.getFiberDetailsInfo(fdm);
}

private function getFiberDetailsHandler(event:ResultEvent):void{
	var fiberdatas:FiberDetailsResultModel = event.result as FiberDetailsResultModel;
	if(fiberdatas.datascounts <=0){
		//Alert.show("该光缆段没有关联设备或业务","提示");
	}
	this.onResult(fiberdatas);
}


private var fiberxml:XML;
private var fiberdata:ArrayCollection;
public function onResult(data:FiberDetailsResultModel):void 
{	
	fiberdata = data.acdatas;
//	fiberxml  = new XML(data.datas);
//	for each(var xml:XML in fiberxml.children())
//	{  
//		fiberdata.addItem(xml);					
//	}	
	fibergrid.dataProvider=fiberdata;
}

protected function addContextMenu():void
{
	cm = new ContextMenu();
	cmPara = new ContextMenu();
	nwOcableGraph.contextMenu = cm;
	nwOcableGraphParallel.contextMenu = cmPara;
	cm.addEventListener(ContextMenuEvent.MENU_SELECT, cm_menuSelect);
	cmPara.addEventListener(ContextMenuEvent.MENU_SELECT, cmPara_menuSelect);
	//查看时隙
	cmiSlot.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, cmiSlot_menuSelectHandler);
	cmiSys.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, cmiSys_menuSelectHandler);
	//光纤承载业务
	cmiOpera.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, cmiOpera_menuSelectHandler);
	//cmiN1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, cmiN1_menuSelectHandler);
	cmiFiberRoute.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, cmiFiberRoute_menuSelectHandler);
	//光路路由
	cmiOcableRoute.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, cmiOcableRoute_menuSelectHandler);
	
	
	addFiber.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, addFiberHandler);
	updateFiber.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, updateFiberHandler);
	deleteFiber.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, deleteFiberHandler);
	
}

public var ocableLength:Number = 0;
public function getCurrentDate():String
{
	var formatter:DateFormatter = new DateFormatter();
	formatter.formatString = "YYYY-MM-DD";
	var date:Date = new Date();
	
	return formatter.format(date);
}


private var newfiberserial:int = 0;
private var newfibercount:int = 0;
private var ocablesectionname:String = "";
private var propertycode:String = "";
private var length:String = "";

//添加光纤
protected function addFiberHandler(event:ContextMenuEvent):void{
	//if(nwOcableGraph.selectionModel.count > 0)
	//{
	
	
	Alert.show("确认添加光芯？",
		"提示",
		Alert.YES|Alert.NO,
		null,
		alertAddFiberHandeler
	);
	
	//}
}

//添加光纤
private function alertAddFiberHandeler(event:CloseEvent):void{
	if(event.detail==Alert.YES){
//		var fiberObj:FiberDetailsModel = new FiberDetailsModel();
//		fiberObj.sectioncode = this.ocablecode;
//		fiberObj.fiberserial =newfibercount.toString();
//		fiberObj.property = this.propertycode;
//		fiberObj.ocablesectionname = this.ocablesectionname;
//		fiberObj.length = this.ocableLength.toString();
//		fiberObj.updateperson = parentApplication.curUser;
//		fiberObj.updatedate = this.getCurrentDate();
//		
//		var remoteobj:RemoteObject = new RemoteObject("ocableResources"); 
//		remoteobj.endpoint = ModelLocator.END_POINT;
//		remoteobj.showBusyCursor = true;
//		//Alert.show(newfibercount+"\n"+fiberObj.fiberserial);
//		remoteobj.addSingleFiber(fiberObj, newfibercount+1);
//		remoteobj.addEventListener(ResultEvent.RESULT,
//			function(e:ResultEvent):void
//			{
//				if (e.result == true)
//				{
//					Alert.show("光纤添加成功", "提示");
//					roOcableTopo.getOcableList(apointcode, zpointcode);
//					ocableresourceview.dispatchEvent(new Event("addFiber1"));
//					ocableresourceview.test();
//				}
//				else
//				{
//					Alert.show("光纤添加失败", "提示");
//				}
//			});
		//添加时首先判断纤芯是否满了
		var remoteObject:RemoteObject = new RemoteObject("resNodeDwr");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		remoteObject.getFiberSerialByOcablecodeNew(ocablecode);
		remoteObject.addEventListener(ResultEvent.RESULT,
			function(e:ResultEvent):void
				{ 
				if(e.result.toString()!=""){
					var property:ShowProperty = new ShowProperty();
					property.title = "添加";
					property.paraValue = null;
					property.tablename = "VIEW_EN_FIBER_PROPERTY";
					property.key = "FIBERCODE";
					PopUpManager.addPopUp(property, this, true);
					PopUpManager.centerPopUp(property);		
					property.addEventListener("savePropertyComplete",function (event:Event):void{
						PopUpManager.removePopUp(property);
						roOcableTopo.getOcableList(apointcode, zpointcode);						
					});	
					property.addEventListener("initFinished",function (event:Event):void{
						(property.getElementById("OCABLECODE",property.propertyList) as mx.controls.TextInput).text=ocablecode;
						(property.getElementById("OCABLENAME",property.propertyList) as mx.controls.TextInput).text=ocablesectionname;
						(property.getElementById("FIBERSERIAL",property.propertyList) as mx.controls.TextInput).text=e.result.toString();
						//获取AZ端站点编码
						var rt:RemoteObject=new RemoteObject("resNodeDwr");
						rt.endpoint=ModelLocator.END_POINT;
						rt.showBusyCursor=true;
						rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent){
							if(event.result!=null){
								var arr:Array = event.result.toString().split(";");
								(property.getElementById("ASTAIONCODE",property.propertyList) as mx.controls.TextInput).text=arr[0];
								(property.getElementById("ZSTAIONCODE",property.propertyList) as mx.controls.TextInput).text=arr[1];
								
							}
						});
						
						rt.getAportAndZportByOcablecode(ocablecode);
						(property.getElementById("FIBERSERIAL",property.propertyList) as mx.controls.TextInput).editable = false;
						(property.getElementById("OCABLENAME",property.propertyList) as mx.controls.TextInput).editable = false;
						
						//起始设备选择
						(property.getElementById("AENDEQUIPNAME",property.propertyList) as mx.controls.TextInput).addEventListener(MouseEvent.CLICK,function(event:Object):void{
							var code:String = (property.getElementById("ASTAIONCODE",property.propertyList) as mx.controls.TextInput).text;
							if(code==""||code==null){
								Alert.show("请先选择光缆段");
							}else{
								var packeqsearch:SearchEquipByStationTitle=new SearchEquipByStationTitle();
								packeqsearch.page_parent=property;
								packeqsearch.child_systemcode=code;
								packeqsearch.child_vendor=null;
								PopUpManager.addPopUp(packeqsearch,property,true);
								PopUpManager.centerPopUp(packeqsearch);
								packeqsearch.myCallBack=function(obj:Object){
									var elabel:String=obj.label;//从子页面传过来的选的设备的code
									var ecode:String = obj.code;//设备id
									(property.getElementById("AENDEQUIPNAME",property.propertyList) as mx.controls.TextInput).text=elabel ;
									(property.getElementById("AENDEQUIP",property.propertyList) as mx.controls.TextInput).text=ecode;
									var rt:RemoteObject=new RemoteObject("resNodeDwr");
									rt.endpoint=ModelLocator.END_POINT;
									rt.showBusyCursor=true;
									rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent){
										var eqsearchLst:XMLList= new XMLList(event.result);
										(property.getElementById("AENDEQPORT",property.propertyList) as mx.controls.ComboBox).dropdown.dataProvider=eqsearchLst;
										(property.getElementById("AENDEQPORT",property.propertyList) as mx.controls.ComboBox).dataProvider=eqsearchLst;
										(property.getElementById("AENDEQPORT",property.propertyList) as mx.controls.ComboBox).labelField="@label";
										(property.getElementById("AENDEQPORT",property.propertyList) as mx.controls.ComboBox).text="";
										(property.getElementById("AENDEQPORT",property.propertyList) as mx.controls.ComboBox).selectedIndex=-1;
										
									});
									rt.getFiberPortserialByEquip(ecode);//查找设备下的端口---不被占用的
								}
							}
							
						});
						//终止设备选择
						(property.getElementById("ZENDEQUIPNAME",property.propertyList) as mx.controls.TextInput).addEventListener(MouseEvent.CLICK,function(event:Object):void{
							var code:String = (property.getElementById("ZSTAIONCODE",property.propertyList) as mx.controls.TextInput).text;
							if(code==""||code==null){
								Alert.show("请先选择光缆段");
							}else{
								var packeqsearch:SearchEquipByStationTitle=new SearchEquipByStationTitle();
								packeqsearch.page_parent=property;
								packeqsearch.child_systemcode=code;
								packeqsearch.child_vendor=null;
								PopUpManager.addPopUp(packeqsearch,property,true);
								PopUpManager.centerPopUp(packeqsearch);
								packeqsearch.myCallBack=function(obj:Object){
									var elabel:String=obj.label;//从子页面传过来的选的系统的code
									var ecode:String = obj.code;
									(property.getElementById("ZENDEQUIPNAME",property.propertyList) as mx.controls.TextInput).text=elabel;
									(property.getElementById("ZENDEQUIP",property.propertyList) as mx.controls.TextInput).text=ecode;
									var rt:RemoteObject=new RemoteObject("resNodeDwr");
									rt.endpoint=ModelLocator.END_POINT;
									rt.showBusyCursor=true;
									rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent){
										var eqsearchLst:XMLList= new XMLList(event.result);
										(property.getElementById("ZENDEQPORT",property.propertyList) as mx.controls.ComboBox).dropdown.dataProvider=eqsearchLst;
										(property.getElementById("ZENDEQPORT",property.propertyList) as mx.controls.ComboBox).dataProvider=eqsearchLst;
										(property.getElementById("ZENDEQPORT",property.propertyList) as mx.controls.ComboBox).labelField="@label";
										(property.getElementById("ZENDEQPORT",property.propertyList) as mx.controls.ComboBox).text="";
										(property.getElementById("ZENDEQPORT",property.propertyList) as mx.controls.ComboBox).selectedIndex=-1;
										
									});
									rt.getFiberPortserialByEquip(ecode);
								}
							}
							
							
						});
						
						(property.getElementById("UPDATEPERSON",property.propertyList) as mx.controls.TextInput).enabled = false;
						(property.getElementById("UPDATEPERSON",property.propertyList) as mx.controls.TextInput).text = parentApplication.curUserName;
						//		(property.getElementById("UPDATEDATE",property.propertyList) as mx.controls.TextInput).enabled = false;
						(property.getElementById("UPDATEDATE",property.propertyList) as mx.controls.TextInput).text = getCurrentDate();
						
					});
				}else{
					Alert.show("该光缆段不能再添加光纤！","提示");
				}	
			});
	}
	
}

protected function updateFiberHandler(event:ContextMenuEvent):void{
	if(nwOcableGraphParallel.selectionModel.count > 0){
		var property:ShowProperty = new ShowProperty();
		var fiberLink:Link = (nwOcableGraphParallel.selectionModel.selection.getItemAt(0)) as Link;
		property.paraValue = fiberLink.getClient("FiberData").@fibercode;
		property.tablename = "VIEW_EN_FIBER_PROPERTY";
		property.key = "FIBERCODE";
		property.title = "修改光纤";
		PopUpManager.addPopUp(property, this, true);
		PopUpManager.centerPopUp(property);
		property.addEventListener("savePropertyComplete",function (event:Event):void{
			PopUpManager.removePopUp(property);
		});
		//add by xgyin
		property.addEventListener("initFinished",function (event:Event):void{
			
			//获取AZ端站点编码
			var ocablecode:String=(property.getElementById("OCABLECODE",property.propertyList) as mx.controls.TextInput).text
			var rt:RemoteObject=new RemoteObject("resNodeDwr");
			rt.endpoint=ModelLocator.END_POINT;
			rt.showBusyCursor=true;
			rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent){
				if(event.result!=null){
					var arr:Array = event.result.toString().split(";");
					(property.getElementById("ASTAIONCODE",property.propertyList) as mx.controls.TextInput).text=arr[0];
					(property.getElementById("ZSTAIONCODE",property.propertyList) as mx.controls.TextInput).text=arr[1];
					
				}
			});
			
			rt.getAportAndZportByOcablecode(ocablecode);
			
			var aequip:String=(property.getElementById("AENDEQUIP",property.propertyList) as mx.controls.TextInput).text;
			var zequip:String=(property.getElementById("ZENDEQUIP",property.propertyList) as mx.controls.TextInput).text;
			var fibercode:String=fiberLink.getClient("FiberData").@fibercode;
			//初始化值 端口值
			var rt:RemoteObject=new RemoteObject("resNodeDwr");
			rt.endpoint=ModelLocator.END_POINT;
			rt.showBusyCursor=true;
			rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent){
				var str:String = event.result.toString();
				var arr:Array;
				if(str.indexOf(";")!=-1){
					arr=str.split(";");
				}else{
					arr = new Array(str);
				}
				(property.getElementById("AENDEQPORT",property.propertyList) as mx.controls.ComboBox).dropdown.dataProvider=new XMLList(arr[0]);
				(property.getElementById("AENDEQPORT",property.propertyList) as mx.controls.ComboBox).dataProvider=new XMLList(arr[0]);
				(property.getElementById("AENDEQPORT",property.propertyList) as mx.controls.ComboBox).labelField="@label";
				(property.getElementById("AENDEQPORT",property.propertyList) as mx.controls.ComboBox).text="";
				(property.getElementById("AENDEQPORT",property.propertyList) as mx.controls.ComboBox).selectedIndex=arr[1];
				
				(property.getElementById("ZENDEQPORT",property.propertyList) as mx.controls.ComboBox).dropdown.dataProvider=new XMLList(arr[2]);
				(property.getElementById("ZENDEQPORT",property.propertyList) as mx.controls.ComboBox).dataProvider=new XMLList(arr[2]);
				(property.getElementById("ZENDEQPORT",property.propertyList) as mx.controls.ComboBox).labelField="@label";
				(property.getElementById("ZENDEQPORT",property.propertyList) as mx.controls.ComboBox).text="";
				(property.getElementById("ZENDEQPORT",property.propertyList) as mx.controls.ComboBox).selectedIndex=arr[3];
				
				
			});
			rt.getLogicportserialSelectedByEquipPort(fibercode,aequip,zequip);
			
			//起始设备选择
			(property.getElementById("AENDEQUIPNAME",property.propertyList) as mx.controls.TextInput).addEventListener(MouseEvent.CLICK,function(event:Object):void{
				var code:String = (property.getElementById("ASTAIONCODE",property.propertyList) as mx.controls.TextInput).text;
				if(code==""||code==null){
					Alert.show("请先选择光缆段");
				}else{
					var packeqsearch:SearchEquipByStationTitle=new SearchEquipByStationTitle();
					packeqsearch.page_parent=property;
					packeqsearch.child_systemcode=code;
					packeqsearch.child_vendor=null;
					PopUpManager.addPopUp(packeqsearch,property,true);
					PopUpManager.centerPopUp(packeqsearch);
					packeqsearch.myCallBack=function(obj:Object){
						var elabel:String=obj.label;//从子页面传过来的选的系统的code
						var ecode:String = obj.code;
						(property.getElementById("AENDEQUIPNAME",property.propertyList) as mx.controls.TextInput).text=elabel ;
						(property.getElementById("AENDEQUIP",property.propertyList) as mx.controls.TextInput).text=ecode;
						var rt:RemoteObject=new RemoteObject("resNodeDwr");
						rt.endpoint=ModelLocator.END_POINT;
						rt.showBusyCursor=true;
						rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent){
							var eqsearchLst:XMLList= new XMLList(event.result);
							(property.getElementById("AENDEQPORT",property.propertyList) as mx.controls.ComboBox).dropdown.dataProvider=eqsearchLst;
							(property.getElementById("AENDEQPORT",property.propertyList) as mx.controls.ComboBox).dataProvider=eqsearchLst;
							(property.getElementById("AENDEQPORT",property.propertyList) as mx.controls.ComboBox).labelField="@label";
							(property.getElementById("AENDEQPORT",property.propertyList) as mx.controls.ComboBox).text="";
							(property.getElementById("AENDEQPORT",property.propertyList) as mx.controls.ComboBox).selectedIndex=-1;
							
						});
						rt.getFiberPortserialByEquip(ecode);
					}
				}
				
			});
			//终止设备选择
			(property.getElementById("ZENDEQUIPNAME",property.propertyList) as mx.controls.TextInput).addEventListener(MouseEvent.CLICK,function(event:Object):void{
				var code:String = (property.getElementById("ZSTAIONCODE",property.propertyList) as mx.controls.TextInput).text;
				if(code==""||code==null){
					Alert.show("请先选择光缆段");
				}else{
					var packeqsearch:SearchEquipByStationTitle=new SearchEquipByStationTitle();
					packeqsearch.page_parent=property;
					packeqsearch.child_systemcode=code;
					packeqsearch.child_vendor=null;
					PopUpManager.addPopUp(packeqsearch,property,true);
					PopUpManager.centerPopUp(packeqsearch);
					packeqsearch.myCallBack=function(obj:Object){
						var elabel:String=obj.label;//从子页面传过来的选的系统的code
						var ecode:String = obj.code;
						(property.getElementById("ZENDEQUIPNAME",property.propertyList) as mx.controls.TextInput).text=elabel;
						(property.getElementById("ZENDEQUIP",property.propertyList) as mx.controls.TextInput).text=ecode;
						var rt:RemoteObject=new RemoteObject("resNodeDwr");
						rt.endpoint=ModelLocator.END_POINT;
						rt.showBusyCursor=true;
						rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent){
							var eqsearchLst:XMLList= new XMLList(event.result);
							(property.getElementById("ZENDEQPORT",property.propertyList) as mx.controls.ComboBox).dropdown.dataProvider=eqsearchLst;
							(property.getElementById("ZENDEQPORT",property.propertyList) as mx.controls.ComboBox).dataProvider=eqsearchLst;
							(property.getElementById("ZENDEQPORT",property.propertyList) as mx.controls.ComboBox).labelField="@label";
							(property.getElementById("ZENDEQPORT",property.propertyList) as mx.controls.ComboBox).text="";
							(property.getElementById("ZENDEQPORT",property.propertyList) as mx.controls.ComboBox).selectedIndex=-1;
							
						});
						rt.getFiberPortserialByEquip(ecode);
					}
				}
				
			});
		});
			
	}	
}

protected function deleteFiberHandler(event:ContextMenuEvent):void{
	Alert.show("确认删除？",
		"提示",
		Alert.YES|Alert.NO,
		null,
		confirm
	);
}
private function confirm(event:CloseEvent):void{
	if(event.detail==Alert.YES){
		if(nwOcableGraphParallel.selectionModel.count > 0)
		{
			var remoteobj:RemoteObject = new RemoteObject("ocableResources"); 
			remoteobj.endpoint = ModelLocator.END_POINT;
			remoteobj.showBusyCursor = true;
			remoteobj.addEventListener(ResultEvent.RESULT,
				function(e:ResultEvent):void
				{
					if (e.result == true)
					{
						Alert.show("删除光缆成功", "提示");
						roOcableTopo.getOcableList(apointcode, zpointcode);
						//roOcableTopo.getOcableList(apointcode, zpointcode);
					}
					else
					{
						Alert.show("删除光缆失败", "提示");
					}
				});
			
			var fiberObj:FiberDetailsModel = new FiberDetailsModel();
			fiberObj.sectioncode = this.ocablecode;
			fiberObj.fiberserial =newfibercount.toString();
			fiberObj.property = this.propertycode;
			fiberObj.ocablesectionname = this.ocablesectionname;
			fiberObj.length = this.ocableLength.toString();
			fiberObj.updateperson = parentApplication.curUser;
			fiberObj.updatedate = this.getCurrentDate();
			
			var fiberLink:Link = (nwOcableGraphParallel.selectionModel.selection.getItemAt(0)) as Link;
			var fibercode:String = fiberLink.getClient("FiberData").@fibercode;
			var fiberserial:String = fiberLink.getClient("FiberData").@fiberserial;
			remoteobj.deleteSingleFiber(fibercode,fiberserial,fiberObj,newfibercount);
		}
	}
}


protected function ro_resultHandler(event:ResultEvent):void
{
	
	if(event.result!=null){
		
		var lineData:String = event.result.toString();
		var lineXML:XMLList = new XMLList(lineData);
		
		//****************************ocableList.dataProvider=lineXML.child("ocable");
		
		getOcableTopoOcableInfo(ocablecode);
	}
}

protected function itemClickHandler(event:ListEvent):void
{
	//****************************ocablecode = ocableList.selectedItem.code;
	getOcableTopoOcableInfo(ocablecode);
}

// 右键
private function cmPara_menuSelect(e:Event):void
{
	cmPara.hideBuiltInItems();
	if(nwOcableGraphParallel.selectionModel.count > 0)
	{
		if((Element)(nwOcableGraphParallel.selectionModel.selection.getItemAt(0)) is Link)
		{
			cmPara.customItems = [cmiSlot, cmiOpera,cmiOcableRoute,addFiber,updateFiber,deleteFiber];//暂屏蔽wjs
//			cmPara.customItems = [cmiSlot, cmiOpera,addFiber,updateFiber,deleteFiber];//测试代码
			cmiSlot.visible = true;
			cmiSys.visible = false;
			cmiOpera.visible = true;
			//cmiN1.visible = true;
			cmiFiberRoute.visible = false;
			cmiOcableRoute.visible = true;
			addFiber.visible=true;
			updateFiber.visible = true;
			deleteFiber.visible = true;
		}
		else if ((Element)(nwOcableGraphParallel.selectionModel.selection.getItemAt(0)) is Node)
		{
			cmiSlot.visible = false;
			cmiSys.visible = false;
			cmiOpera.visible = false;
			cmiN1.visible = false;
			cmiFiberRoute.visible = false;
			cmiOcableRoute.visible = false;
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
		updateFiber.visible = false;
		deleteFiber.visible = false;
		
	}	
	
}

// 右键
private function cm_menuSelect(e:Event):void
{
	cm.hideBuiltInItems();
	//	if(nwOcableGraphParallel.selectionModel.count > 0)
	//	{
	//		if((Element)(nwOcableGraphParallel.selectionModel.selection.getItemAt(0)) is Link)
	//		{
	//			cmPara.customItems = [cmiSlot];
	//		}
	//		else if ((Element)(nwOcableGraphParallel.selectionModel.selection.getItemAt(0)) is Node)
	//		{
	//		}
	//	}
	//	else
	//	{
	//	}	
	
}

// 右键查看时隙信息
private function cmiSlot_menuSelectHandler(event:ContextMenuEvent):void
{
	var fiberLink:Link = (nwOcableGraphParallel.selectionModel.selection.getItemAt(0)) as Link;
	var fibercode:String = fiberLink.getClient("fibercode").toString();
	var fiberserial:String = fiberLink.getClient("fiberserial").toString();
	var roGetTopolinkByFiber:RemoteObject = new RemoteObject("ocableResources");
	roGetTopolinkByFiber.endpoint = ModelLocator.END_POINT;
	roGetTopolinkByFiber.showBusyCursor = true;
	roGetTopolinkByFiber.getTopolinkByFiber(fibercode, fiberserial); // 有数据时
	roGetTopolinkByFiber.addEventListener(ResultEvent.RESULT, selectSlot);
	
}

private  function selectSlot(e:ResultEvent):void{
	if(e.result.toString()!=""){
		openSlotByFiber(e);	
	}else{
		Alert.show("该光纤上时隙未被占用是否打开时隙分布图？", "提示", Alert.YES|Alert.NO, this, openSlotViewHandler, null, Alert.YES);
	}
}

private function openSlotByFiber(e:ResultEvent):void
{
	var topolinkStr:String = e.result.toString();
	var label:String = topolinkStr.split(';')[0];
	var linerate:String = topolinkStr.split(';')[1];
	var systemcode:String = topolinkStr.split(';')[2];
	
	Registry.register("backsystem", systemcode);
	Registry.register("backlinerate", linerate);
	Registry.register("backlabel", label);
	Registry.register("label", label);
	Registry.register("linerate", linerate);
	Registry.register("systemcode", systemcode);		
	
	Application.application.openModel("时隙分布图", false);
}
private function openSlotViewHandler(e:CloseEvent):void{
	if(e.detail == Alert.YES){
		Application.application.openModel("时隙分布图", false);
	}
}

//系统组织图
private function cmiSys_menuSelectHandler(e:ContextMenuEvent):void
{
	var sys:SysOrgMap = new SysOrgMap();
	parentApplication.openModel("光纤通信",true,sys);
}
//光纤承载业务
private function cmiOpera_menuSelectHandler(e:ContextMenuEvent):void
{
	
	var fiberLink:Link = (nwOcableGraphParallel.selectionModel.selection.getItemAt(0)) as Link;
	var fibercode:String = fiberLink.getClient("fibercode").toString();
	var rtCarry:RemoteObject = new RemoteObject("ocableResources");
	rtCarry.addEventListener(ResultEvent.RESULT,resultCarryHandler);
	rtCarry.endpoint = ModelLocator.END_POINT;
	rtCarry.showBusyCursor = true;
	rtCarry.showFiberBesuniss(fibercode,0,50);//add by sjt
}

public function resultCarryHandler(event:ResultEvent):void{
	var model:ResultModel = event.result as ResultModel;
	if(model.totalCount==0){
		Alert.show("该光纤没有承载业务！","提示");
	}else{
		var vfd:viewFiberDetails = new viewFiberDetails();
		var fiberLink:Link = (nwOcableGraphParallel.selectionModel.selection.getItemAt(0)) as Link;
		var fibercode:String = fiberLink.getClient("fibercode").toString();
		vfd.sectioncode = fibercode;//光纤编码
		vfd.title = "光纤承载业务";
		MyPopupManager.addPopUp(vfd);
		vfd.y=0;
	}
}

private function cmiN1_menuSelectHandler(e:ContextMenuEvent):void
{
	var winBusinessInfluenced:businessInfluenced = new businessInfluenced();
	winBusinessInfluenced.setParameters(this.ocablecode,"ocable");
	parentApplication.openModel("\"N-1\"分析",true,winBusinessInfluenced);
	
}

private function cmiFiberRoute_menuSelectHandler(e:ContextMenuEvent):void
{
	var fiberLink:Link = (nwOcableGraphParallel.selectionModel.selection.getItemAt(0)) as Link;
	var fibercode:String = fiberLink.getClient("FiberData").@fibercode;
	var fri:FiberRoutInfo = new FiberRoutInfo();
	fri.title = "光纤路由";
	fri.fibercode = fibercode;
	MyPopupManager.addPopUp(fri);
	
}

//光路路由
private function cmiOcableRoute_menuSelectHandler(e:ContextMenuEvent):void
{
	var fiberLink:Link = (nwOcableGraphParallel.selectionModel.selection.getItemAt(0)) as Link;
	var fiberserial:String = fiberLink.getClient("FiberData").@fiberserial;
	var remoteobj:RemoteObject = new RemoteObject("fiberWire"); 
	remoteobj.endpoint = ModelLocator.END_POINT;
	remoteobj.showBusyCursor = true;
	remoteobj.addEventListener(ResultEvent.RESULT,getOcableRoutInfoByFiberHandler);
	remoteobj.getOpticalIDByFiber(this.ocablecode,fiberserial);
	
}

private function getOcableRoutInfoByFiberHandler(event:ResultEvent):void{
	var  apointcod:String=event.result.toString();
	if (apointcod != null&&apointcod != "")
	{
		var fri:sourceCode.ocableResource.views.OcableRoutInfo = new sourceCode.ocableResource.views.OcableRoutInfo();
		fri.title = "光路路由图";
		fri.getFiberRouteInfo(apointcod);
		fri.width=Application.application.workspace.width;
		fri.height=Application.application.workspace.height+70;
		MyPopupManager.addPopUp(fri);
		fri.y =0;
		
	}
	else
	{
		Alert.show("无相关数据!", "提示");
	}
	
}

public function getOcableTopoOcableInfo(sectioncode:String):void 
{   
	var roOcableInfo:RemoteObject = new RemoteObject("ocableResources");
	roOcableInfo.endpoint = ModelLocator.END_POINT;
	roOcableInfo.showBusyCursor = true;
	roOcableInfo.getOcableTopoOcableInfo(sectioncode);
	roOcableInfo.addEventListener(ResultEvent.RESULT,ocableInfoResultHandler);
	
	var roFiberInfo:RemoteObject = new RemoteObject("ocableResources");
	roFiberInfo.endpoint = ModelLocator.END_POINT;
	roFiberInfo.showBusyCursor = true;
	roFiberInfo.getOcableTopoFiberInfo(sectioncode);
	roFiberInfo.addEventListener(ResultEvent.RESULT,fiberInfoResultHandler);	
}

public function ocableInfoResultHandler(event:ResultEvent):void 
{   
	if(event.result.toString()!=""&&event.result!=null){
		//Alert.show("ocableInfoResultHandler============="+event.result.toString());
		var xml:String = event.result.toString();	
		
		ocablegriddata = new XMLList(xml);
		//****************************ocablegrid.dataProvider = ocablegriddata;
		this.ocableLength = ocablegriddata[4].col2;
		this.ocablesectionname = ocablegriddata[0].col2;
		this.newfibercount = Number(ocablegriddata[8].col2);
	}
}

public function fiberInfoResultHandler(event:ResultEvent):void 
{   
	//Alert.show(event.result.toString());
//	Alert.show("fiberInfoResultHandler============="+event.result.toString());
	if(event.result=="<fibers></fibers>"){//<fibers></fibers>
		return;
	}
	var xml:XML = new XML(event.result.toString());
	//	if(xml.children().length() == 0){
	//		Alert.show("无光芯信息!","温馨提示!");
	//		return ;
	//	}
	var fibergriddata:ArrayCollection = new ArrayCollection();
	var fibernum:int = xml.children().length();
	
	var roundPipe:RoundPipe = new RoundPipe();
	if(fibernum!=0){
		roundPipe.name = xml.child("fiber")[0].@ocablesectionname;
	}
	
	roundPipe.holeCount = fibernum + 1;
	roundPipe.location = new Point(50, 20);
	roundPipe.setSize(400, 400);
	this.box.clear();
	this.box.add(roundPipe);
	
	if (fibernum > 10)
	{
		var counter:int = 0;
		var outernum:int = (fibernum / 3) * 2;
		roundPipe.holeCount = outernum + 1;
		for each(var arrxml:XML in xml.children())
		{
			fibergriddata.addItem(arrxml);
			var j:int = arrxml.@fiberserial;
			
			counter++;
			if (counter == outernum + 1)
			{
				var roundHole:RoundPipe = new RoundPipe();
				roundHole.name = "";
				roundHole.holeCount = fibernum - outernum + 1;
				roundHole.parent = roundPipe;
				roundHole.holeIndex = outernum;
				roundHole.host = roundPipe;
				this.box.add(roundHole);
			}
			
			var child:RoundPipe = new RoundPipe();
			child.icon = "PipeHole";
			child.setStyle(Styles.VECTOR_FILL_COLOR, Utils.randomColor());
			child.setStyle(Styles.LABEL_POSITION, Consts.POSITION_CENTER);
			
			if (counter > outernum)
			{
				child.parent = roundHole;
				child.holeIndex = counter - outernum - 1;
				child.host = roundHole;
			}
			else 
			{
				child.parent = roundPipe;
				child.holeIndex = j - 1;
				child.host = roundPipe;
			}
			
			child.name = "" + j;
			child.setClient("FiberData", arrxml);
			child.setClient("isFiber", true);
			child.toolTip = child.getClient("FiberData").@name_std;
			this.box.add(child);
		}
		
		if (fibernum == 0)
		{
			Alert.show("该光缆无光纤", "提示");
			newfiberserial = 0;
		}
		else
		{
			newfiberserial = xml.children()[fibernum - 1].@fiberserial;
		}
		
		var labelHole:RoundPipe = new RoundPipe();
		labelHole.name = "光缆截面图";
		labelHole.setStyle(Styles.LABEL_POSITION, Consts.POSITION_CENTER);
		labelHole.parent = roundHole;
		labelHole.holeIndex = fibernum - outernum;
		labelHole.host = roundHole;
		this.box.add(labelHole);
	}
	else 
	{
		for each(var arrxml:XML in xml.children())
		{
			fibergriddata.addItem(arrxml);
			var j:int = arrxml.@fiberserial;
			
			var child:RoundPipe = new RoundPipe();
			child.icon = "PipeHole";
			child.setStyle(Styles.VECTOR_FILL_COLOR, Utils.randomColor());
			child.setStyle(Styles.LABEL_POSITION, Consts.POSITION_CENTER);
			child.parent = roundPipe;
			child.holeIndex = j - 1;
			child.name = "" + j;
			child.host = roundPipe;
			child.setClient("FiberData", arrxml);
			child.setClient("isFiber", true);
			child.toolTip = child.getClient("FiberData").@name_std;
			this.box.add(child);
		}
		
		var labelHole:RoundPipe = new RoundPipe();
		labelHole.name = "光缆截面图";
		labelHole.setStyle(Styles.LABEL_POSITION, Consts.POSITION_CENTER);
		labelHole.parent = roundPipe;
		labelHole.holeIndex = fibernum;
		labelHole.host = roundPipe;
		this.box.add(labelHole);
	}
	
	//	fibergrid.dataProvider=fibergriddata;
	//	fibergrid.invalidateList();
	
	///////////////////////////////////////////////////////////////////////
	
	var xmlParallel:XML = new XML(event.result.toString());
	var fiberparallelgriddata:ArrayCollection = new ArrayCollection();
	var fiberparallelnum:int = xmlParallel.children().length();
	var ocablesectionname = xmlParallel.child("fiber")[0].@ocablesectionname;
	var station_a:String = xmlParallel.child("fiber")[0].@station_a;
	var station_z:String = xmlParallel.child("fiber")[0].@station_z;
	var node_a:Node = new Node(apointcode);
	var node_z:Node = new Node(zpointcode);
	var bundleCapacity:int = 12;
	var nodeheight:int = 570;
	var linkGap:int = nodeheight / (fiberparallelnum + 1);
	
	boxParallel.clear();
	
	if (fiberparallelnum > 64)
		nodeheight += (((fiberparallelnum - 1) / 12) - 1) * 200;
	
	node_a.location = new Point(50, 50);
	node_a.name = station_a;
	node_a.image = "nodeStation";
	node_a.width = 126;
	node_a.height = nodeheight;
	node_a.setStyle(Styles.IMAGE_STRETCH, Consts.STRETCH_FILL);
	node_a.layerID = "boxLayer";
	node_a.setStyle(Styles.LABEL_SIZE, 30);
	node_a.setStyle(Styles.LABEL_POSITION, Consts.POSITION_TOP_TOP);
	
	node_z.location = new Point(750, 50);
	node_z.name = station_z;
	node_z.image = "nodeStation";
	node_z.width = 126;
	node_z.height = nodeheight;
	node_z.setStyle(Styles.IMAGE_STRETCH, Consts.STRETCH_FILL);
	node_z.layerID = "boxLayer";
	node_z.setStyle(Styles.LABEL_SIZE, 30);
	node_z.setStyle(Styles.LABEL_POSITION, Consts.POSITION_TOP_TOP);
	
	boxParallel.add(node_a);
	boxParallel.add(node_z);
	//Alert.show("xmlParallel======="+xmlParallel.toXMLString());
	var linkSpace:int = int(nodeheight/(xmlParallel.children().length() + 1));
	
	for (var i:int = 0 ;i<xmlParallel.children().length();i++){
		
		//}
		//	for each(var arrxml:XML in xmlParallel.children())
		//{
		//Alert.show(this.fibercode+"--------------"+this.fiberserial);
		var node_a_child:Node = new Node("node_a_child"+i.toString());
		var  height:int = 50 + (i+1) * linkSpace;
		
		node_a_child.location = new Point(110, height);
		//node_a_child.name = station_a + i.toString();
		node_a_child.image = "nodeStationChild";
		node_a_child.width = 15;
		node_a_child.height = 15;
		node_a_child.setStyle(Styles.IMAGE_STRETCH, Consts.STRETCH_FILL);
		node_a_child.layerID = "boxLayer";
		node_a_child.setStyle(Styles.LABEL_SIZE, 30);
		//node_a_child.setStyle(Styles.LABEL_POSITION, Consts.POSITION_TOP_TOP);
		boxParallel.add(node_a_child);
		fiberparallelgriddata.addItem(xmlParallel.children()[i]);
		
		var node_z_child:Node = new Node("node_z_child"+i.toString());
		var  height:int = 50 + (i+1) * linkSpace;
		
		node_z_child.location = new Point(800, height);
		//node_z_child.name = station_a + i.toString();
		node_z_child.image = "nodeStationChild";
		node_z_child.width = 15;
		node_z_child.height = 15;
		node_z_child.setStyle(Styles.IMAGE_STRETCH, Consts.STRETCH_FILL);
		node_z_child.layerID = "boxLayer";
		node_z_child.setStyle(Styles.LABEL_SIZE, 30);
		//node_a_child.setStyle(Styles.LABEL_POSITION, Consts.POSITION_TOP_TOP);
		boxParallel.add(node_z_child);
		
		var fiberlink:Link = new Link(node_a_child, node_z_child);
		fiberlink.setClient("fibercode", xmlParallel.children()[i].@fibercode);
		fiberlink.setClient("fiberserial",xmlParallel.children()[i].@fiberserial);
		//		Alert.show(fiberLink.getClient("FiberData").@aendequipPort+"\n"+fiberLink.getClient("FiberData").@zendequipPort);
		//		var fibercode:String = fiberLink.getClient("FiberData").@fibercode;
		//		var fiberserial:String = fiberLink.getClient("FiberData").@fiberserial;
		
		var color:String = getFiberLinkColor(xmlParallel.children()[i].@fiberserial, bundleCapacity);
		var bundleID:int = getFiberLinkBundleID(xmlParallel.children()[i].@fiberserial, bundleCapacity);
		var tooltip:String = "<b>纤芯序号: </b>" + xmlParallel.children()[i].@fiberserial + "<br>"
			+ "<b>光纤类型: </b>" + xmlParallel.children()[i].@fibermodel + "<br>"
			+ "<b>起始设备: </b>" + xmlParallel.children()[i].@aendeqport + "<br>"
			+ "<b>终止设备: </b>" + xmlParallel.children()[i].@zendeqport + "<br>"
			+ "<b>主备用: </b>" + xmlParallel.children()[i].@zbystatus + "<br>";//byxujiao 2012-7-30加一个主备用
		fiberlink.toolTip = tooltip;
		fiberlink.setStyle(Styles.LINK_COLOR, color);
		fiberlink.setStyle(Styles.LINK_TYPE, Consts.LINK_TYPE_PARALLEL);
		fiberlink.setStyle(Styles.LINK_BUNDLE_ID, bundleID);
		fiberlink.setStyle(Styles.LINK_BUNDLE_EXPANDED, true);
		//		fiberlink.setStyle(Styles.LINK_BUNDLE_ENABLE, false);
		fiberlink.setStyle(Styles.LINK_BUNDLE_GAP, linkGap);
		fiberlink.setStyle(Styles.LINK_FROM_XOFFSET, -15);
		fiberlink.setStyle(Styles.LINK_TO_XOFFSET, 15);
		
		if(bundleID > 0)
		{
			var iconname:String = "bundle" + (bundleID + 1).toString();
			fiberlink.setStyle(Styles.ICONS_NAMES, [iconname]);
			fiberlink.setStyle(Styles.ICONS_POSITION, Consts.POSITION_CENTER);
		}
		
		fiberlink.setClient("FiberData", XML(xmlParallel.children()[i]));
		boxParallel.add(fiberlink);
		
	}
	
	
	//	fibergrid.dataProvider=fiberparallelgriddata;
	//	fibergrid.invalidateList();
}

//public var systemcode:String='';
//public var linerate:String='';
//public var label:String='';
//public var systemcode:String='';
//var topolinkStr:String = evt.result.toString();
//var label:String = topolinkStr.split('^')[0];
//var linerate:String = topolinkStr.split('^')[1];
//var systemcode:String = topolinkStr.split('^')[2];
//
//Alert.show("systemcode========"+systemcode);
//Alert.show("linerate========"+linerate);
//Alert.show("label========"+label);
//Alert.show("linerate========"+linerate);
//
//Registry.register("backsystem", systemcode);
//Registry.register("backlinerate", linerate);
//Registry.register("backlabel", label);
//Registry.register("label", label);
//Registry.register("linerate", linerate);
//Registry.register("systemcode", systemcode);		

private function nwOcableGraphParallel_doubleClickHandler(e:MouseEvent):void
{
	var fiberLink:Link = (nwOcableGraphParallel.selectionModel.selection.getItemAt(0)) as Link;
	var fibercode:String = fiberLink.getClient("fibercode").toString();
	var fiberserial:String = fiberLink.getClient("fiberserial").toString();
	var roGetTopolinkByFiber:RemoteObject = new RemoteObject("ocableResources");
	roGetTopolinkByFiber.endpoint = ModelLocator.END_POINT;
	roGetTopolinkByFiber.showBusyCursor = true;
	roGetTopolinkByFiber.getTopolinkByFiber(fibercode, fiberserial); // 有数据时
	roGetTopolinkByFiber.addEventListener(ResultEvent.RESULT, selectSlot);
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
		xml +=  "<fiber> <col1>承载业务</col1> <col2>"+round.getClient("FiberData").@name_std+"</col2></fiber>";
		xml +=  "<fiber> <col1>长度</col1> <col2>"+round.getClient("FiberData").@length+"</col2></fiber>";
		xml +=  "<fiber> <col1>产权</col1> <col2>"+round.getClient("FiberData").@property+"</col2></fiber>";
		xml +=  "<fiber> <col1>状态</col1> <col2>"+round.getClient("FiberData").@status+"</col2></fiber>";
		xml +=  "<fiber> <col1>类型</col1> <col2>"+round.getClient("FiberData").@fibermodel+"</col2></fiber>";
		xml +=  "<fiber> <col1>备注</col1> <col2>"+round.getClient("FiberData").@remark+"</col2></fiber>";
		xml +=  "<fiber> <col1>起始设备</col1> <col2>"+round.getClient("FiberData").@aendeqport+"</col2></fiber>";
		xml +=  "<fiber> <col1>终止设备</col1> <col2>"+round.getClient("FiberData").@zendeqport+"</col2></fiber>";
		xml +=  "<fiber> <col1>起始端口</col1> <col2>"+round.getClient("FiberData").@aendodfport+"</col2></fiber>";
		xml +=  "<fiber> <col1>终止端口</col1> <col2>"+round.getClient("FiberData").@zendodfport+"</col2></fiber>";
		xml +=  "<fiber> <col1>更新人</col1> <col2>"+round.getClient("FiberData").@updateperson+"</col2></fiber>";
		xml +=  "<fiber> <col1>更新时间</col1> <col2>"+round.getClient("FiberData").@updatedate+"</col2></fiber>";
		
		
		singlefibergriddata = new XMLList(xml);
		singlefibergrid.dataProvider = singlefibergriddata;
		this.singlefibergrid.visible = true;
	}
	else
	{
		this.singlefibergrid.visible = false;
	}
	
}

private function selectionChangedPara(e:SelectionChangeEvent):void
{	
	if (this.boxParallel.selectionModel.count != 1)
	{
		//this.dgSingleFiber.visible = false;
		//this.dgSingleFiber.includeInLayout = false;
		return;
	}
	
	var itemPara:Object = this.boxParallel.selectionModel.lastData;
	var isLink:Boolean = itemPara is Link;
	
	if (isLink)
	{
		var fiberLink:Link = Link(this.boxParallel.selectionModel.lastData);
		var xml:String = "";
		
		xml +=  "<fiber> <col1>所属光缆接续段</col1> <col2>"+fiberLink.getClient("FiberData").@ocablesectionname+"</col2></fiber>";
		xml +=  "<fiber> <col1>纤芯号</col1> <col2>"+fiberLink.getClient("FiberData").@fiberserial+"</col2></fiber>";
		xml +=  "<fiber> <col1>承载业务</col1> <col2>"+fiberLink.getClient("FiberData").@name_std+"</col2></fiber>";
		xml +=  "<fiber> <col1>长度</col1> <col2>"+fiberLink.getClient("FiberData").@length+"</col2></fiber>";
		xml +=  "<fiber> <col1>产权</col1> <col2>"+fiberLink.getClient("FiberData").@property+"</col2></fiber>";
		xml +=  "<fiber> <col1>状态</col1> <col2>"+fiberLink.getClient("FiberData").@status+"</col2></fiber>";
		xml +=  "<fiber> <col1>类型</col1> <col2>"+fiberLink.getClient("FiberData").@fibermodel+"</col2></fiber>";
		xml +=  "<fiber> <col1>备注</col1> <col2>"+fiberLink.getClient("FiberData").@remark+"</col2></fiber>";
		xml +=  "<fiber> <col1>起始设备</col1> <col2>"+fiberLink.getClient("FiberData").@aendeqport+"</col2></fiber>";
		xml +=  "<fiber> <col1>终止设备</col1> <col2>"+fiberLink.getClient("FiberData").@zendeqport+"</col2></fiber>";
		xml +=  "<fiber> <col1>起始端口</col1> <col2>"+fiberLink.getClient("FiberData").@aendodfport+"</col2></fiber>";
		xml +=  "<fiber> <col1>终止端口</col1> <col2>"+fiberLink.getClient("FiberData").@zendodfport+"</col2></fiber>";
		xml +=  "<fiber> <col1>更新人</col1> <col2>"+fiberLink.getClient("FiberData").@updateperson+"</col2></fiber>";
		xml +=  "<fiber> <col1>更新时间</col1> <col2>"+fiberLink.getClient("FiberData").@updatedate+"</col2></fiber>";
		
		dgSingleFiberData = new XMLList(xml);
		//dgSingleFiber.dataProvider = dgSingleFiberData;
		//this.dgSingleFiber.visible = true;
		//this.dgSingleFiber.includeInLayout = true;
	}
	else
	{
		//this.dgSingleFiber.visible = false;
		//this.dgSingleFiber.includeInLayout = false;
	}
}

public function DealFault(event:FaultEvent):void {
	//Alert.show(event.fault.toString());
	trace(event.fault);
}

private function ChangeEvent():void
{
	getOcableTopoOcableInfo(ocablecode);
}

private function changeState():void{
	if(this.text.visible){
		this.cvsOcable.percentWidth=30;
		this.text.visible=false;
		this.text.includeInLayout=false;
		this.vbOcable.visible = true;
		this.vbOcable.includeInLayout = true;
		this.linkButton.label=">>";
		this.mypanel.title="光纤信息";
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

