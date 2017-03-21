import VButtonEvents.selectedItemEvent;

import com.adobe.serialization.json.JSON;
import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.actionscript.Registry;
import common.other.events.EventNames;
import common.other.events.FourParameterEvent;
import common.other.events.LinkParameterEvent;
import common.other.events.ParameterEvent;

import flash.display.DisplayObject;
import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;
import flash.utils.Timer;
import flash.utils.setTimeout;

import mx.collections.ArrayCollection;
import mx.collections.XMLListCollection;
import mx.containers.TitleWindow;
import mx.containers.utilityClasses.ConstraintColumn;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.ButtonBar;
import mx.controls.CheckBox;
import mx.controls.ComboBox;
import mx.controls.Spacer;
import mx.controls.TextArea;
import mx.core.Application;
import mx.core.DragSource;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.events.DragEvent;
import mx.events.ListEvent;
import mx.events.ScrollEvent;
import mx.events.StateChangeEvent;
import mx.formatters.DateFormatter;
import mx.managers.DragManager;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;
import mx.utils.StringUtil;

import sourceCode.alarmmgr.model.AlarmMangerModel;
import sourceCode.alarmmgr.views.AlarmManager;
import sourceCode.autoGrid.view.ShowProperty;
import sourceCode.faultSimulation.titles.InterposeFaultTitle;
import sourceCode.faultSimulation.titles.InterposeFaultTitle1;
import sourceCode.faultSimulation.titles.InterposeFaultTitle2;
import sourceCode.faultSimulation.titles.InterposeTitle;
import sourceCode.faultSimulation.titles.userEventMaintainTitle;
import sourceCode.ocableResource.views.OcableRoutInfo;
import sourceCode.ocableTopo.views.businessInfluenced;
import sourceCode.resManager.resNet.model.Equipment;
import sourceCode.resManager.resNode.views.enStationTree;
import sourceCode.rootalarm.views.HisRootAlarm;
import sourceCode.rootalarm.views.RootAlarmMgr;
import sourceCode.sysGraph.actionscript.ActionTile;
import sourceCode.sysGraph.actionscript.Circlerate;
import sourceCode.sysGraph.actionscript.DFloyd;
import sourceCode.sysGraph.actionscript.DemoLink;
import sourceCode.sysGraph.actionscript.Diameter;
import sourceCode.sysGraph.actionscript.RouteMethod;
import sourceCode.sysGraph.actionscript.Shareds;
import sourceCode.sysGraph.actionscript.StoryLayouter;
import sourceCode.sysGraph.actionscript.Subgraph;
import sourceCode.sysGraph.actionscript.keynode;
import sourceCode.sysGraph.model.EquInfo;
import sourceCode.sysGraph.model.Location;
import sourceCode.sysGraph.model.SystemInfo;
import sourceCode.sysGraph.views.AddEquInfo;
import sourceCode.sysGraph.views.OcableRoutInfo;
import sourceCode.sysGraph.views.ShowCc;
import sourceCode.sysGraph.views.ShowPerDatas;
import sourceCode.sysGraph.views.SysOrgMapL;
import sourceCode.sysGraph.views.WinTopoLink;
import sourceCode.sysGraph.views.configSlot;
import sourceCode.systemManagement.model.PermissionControlModel;
import sourceCode.sysGraph.views.DetailPressures;
import twaver.AlarmSeverity;
import twaver.Consts;
import twaver.DataBox;
import twaver.DemoImages;
import twaver.DemoUtils;
import twaver.Element;
import twaver.ElementBox;
import twaver.Grid;
import twaver.ICollection;
import twaver.IElement;
import twaver.Layer;
import twaver.Link;
import twaver.Node;
import twaver.SerializationSettings;
import twaver.Styles;
import twaver.Utils;
import twaver.XMLSerializer;
import twaver.network.layout.AutoLayouter;
import twaver.network.layout.SpringLayouter;
//import VButtonEvents.selectedItemEvent;      
[Bindable]                                      //liao
private var abc_route:ArrayCollection = new ArrayCollection(); 
[Bindable]                                      //liao
private var equip_provider:ArrayCollection = new ArrayCollection([
	"1", "2", "3"]); 
[Bindable]
private var scheme_provider:ArrayCollection = new ArrayCollection([
	"1", "2", "3"]);   //liao
[Bindable]
private var strategyArr:ArrayCollection = new ArrayCollection([
	"--策略选择--","时延策略","压力均衡策略","关键业务策略"]);      //最短路径策略
[Bindable]
private var myData:ArrayCollection;
/**
 *左侧树的数据源 
 */
public var XMLData:XMLList;
[Bindable] 
public static var sdsd:XML;
[Bindable]

//厂商列表
[Bindable] public var x_vendorLst:XMLList;
//传输系统列表
[Bindable] public var sys_nameLst:XMLList; 
//设备型号列表
[Bindable] public var x_modelLst:XMLList;
//设备类型列表
[Bindable] public var x_typeLst:XMLList;

[Bindable]
private var C_Analysis:ArrayCollection =new ArrayCollection();  //成环率分析
[Bindable]
public var selectflag:int = 0;//当前选中的分析项
[Bindable]
public var currSystemName:String="";//当前选中的系统网络名称

private var D_Analysis:ArrayCollection =new ArrayCollection();  //网络直径		
private var K_Analysis:ArrayCollection =new ArrayCollection();  //关键点
/**
 *保存系统组织图右侧的传输设备树的数据源 
 */
//public var DeviceXML:XMLList;              new
[Embed(source="assets/images/sysManager/show.png")] //这是图片的相对地址 
[Bindable]
public var PointIcon:Class;
[Embed(source="assets/images/sysManager/show.png")]
[Bindable]
public var PointRight:Class;
[Embed(source="assets/images/sysManager/hide.png")]
[Bindable]
public var PointLeft:Class;
private var bpl_visible:Boolean=false;
/**
 *保存当前系统传输设备树选中的结点 
 */
private var selectedNode:XML; 
private var springLaouter:SpringLayouter=null;
/**
 *保存当前系统传输设备树选中的结点的ID 
 */
private var catalogsid:String; 
/**
 *保存当前系统传输设备树选中的结点的类型 
 */
private var type:String; 
/**
 *系统初始化坐标 
 */
private var c_x:int=60, c_y:int=50; 
private var t_x:int=60, t_y:int=50;

/**
 *添加设备窗体 
 */
private var addEquInfo:AddEquInfo;
/**
 *增、改传输系统时的窗口 
 */
private var itemSystem:winSystem; 
/**
 *devicetree当前选中结点的索引 
 */
private var curIndex:int;
/**
 *network中elementBox 
 */
private var elementBox:ElementBox;
/**
 *用来保存在添加系统时已经在拓扑图中出现过该系统设备的系统 
 */
private var relate_system_array:Array=new Array();

/**
 *添加系统右键菜单项 
 */
private var cmi_addSys:ContextMenuItem;
/**
 *修改系统右键菜单项 
 */
private var cmi_modSys:ContextMenuItem;
/**
 *删除系统右键菜单项 
 */
private var cmi_delSys:ContextMenuItem;
/**
 *系统树的菜单 
 */
private var cm:ContextMenu;

/**
 *添加到系统中的设备的结点id 
 */
private var nodeId:Object={};

/**
 *表示当前系统树选中的结点 
 */
private var tree_selectedNode:XML;
private var treeChild:String;  //liao

private var isEditSys:Boolean = false;
private var isAddSys:Boolean = false;
private var isDeleteSys:Boolean = false;
private var isSaveSys:Boolean = false;
private var isSaveEquipment:Boolean = false;
private var isAddInterpose:Boolean = false;
private var isAddEquipment:Boolean = false;
private var isAddTopolink:Boolean = false;
private var isConfig:Boolean = false;
private var isAddInterposeFault:Boolean=false;
private var isAddCutFault:Boolean=false;
[bindable]
private var isDeleteEquipment:Boolean = false;
private var timer:Timer=null;
/**
 *需删除的设备编码 
 */
private var delEquipcode:String;
private var toplink:String;
private var vendor:String;
private var alarm_all:Boolean=false;
/**
 *添加复用段时保存添加的复用段的linkid 
 */
private var linkID:Object;
private var clear_arr:Array;   
/**
 *复用段添加窗体 
 */
private var winTopoLink:WinTopoLink;
/**
 *配置时隙窗体 
 */
private var tw:TitleWindow;

//背景地图图层
public var mapLayer:Layer;

[Embed(source='assets/images/toolbar/equipment.png')]
[Bindable]
private var cs:Class;
[Embed(source='assets/images/toolbar/equipmodel.png')]
[Bindable]
private var sb:Class;
[Embed(source='assets/images/toolbar/topolink.png')]
[Bindable]
private var fy:Class;


private var belongEquip:String="";
private var belongCode:String="";
public var checkFlag:Boolean = false;
private var showOper:Boolean = false;
public var showSysGraphAlarm:Boolean=false;//是否呈现够告警，由main页面赋值；
//其他页面调用，可设置main页面的是否呈现，然后再打开此页面  参考PopupMenu_AlarmDeal.as 中设备定位

private var serializer:XMLSerializer;
private var networkContent:String;
private var iconAlpha:int = 255;
private var flowingOffset:int = 0;
public var countTree:int=0;
public var mouse_x:Number=0.0;
public var mouse_y:Number=0.0;
[Bindable] 
public  var alldata:ArrayCollection = new ArrayCollection();
[Bindable] 
private var ac:ArrayCollection = new ArrayCollection([
	{label:'设备模板',icon:sb},
	{label:'复用段',icon:fy},
	{label:'搜索',icon:cs},
	{label:'分析',icon:sb}]);	
[Bindable]
private var arr_cb:ArrayCollection=new ArrayCollection([
	{label:'--请选择--'},
	{label:'成环率分析'},
	{label:'网络直径分析'},
	{label:'网络关键点分析'}]);
[Bindable]
private var arr_cb_add:ArrayCollection=new ArrayCollection([
	{label:'2'},
	{label:'3'},
	{label:'4'},
	{label:'5'},
	{label:'6'},
	{label:'7'}]);

private var equipsCount:Array;//用于存储有限制条件的设备数
//[Bindable]
//private var item_link:ContextMenuItem = new ContextMenuItem();

//liao
import sourceCode.sysGraph.views.createbusiness;
import sourceCode.resManager.resNet.events.topolinkSearchEvent;
import sourceCode.sysGraph.actionscript.Shared;

private var createb:sourceCode.sysGraph.views.createbusiness;
private var pressure:DetailPressures;

public function get dataBox():DataBox
{
	return elementBox;
}


private function preinitialize():void
{
	
	if(ModelLocator.permissionList!=null&&ModelLocator.permissionList.length>0)
	{
		isAddSys = false;
		isEditSys = false;
		isSaveSys = false;
		isAddTopolink = false;
		isAddEquipment = false;
		isSaveEquipment = false;
		isAddInterpose = false;
		isConfig = false;
		showOper = false;
		isDeleteEquipment = false;
		isAddInterposeFault=false;
		isAddCutFault=false;
		for(var i:int=0;i<ModelLocator.permissionList.length;i++)
		{
			
			var model:PermissionControlModel = ModelLocator.permissionList[i];
			
			if(model.oper_name!=null&&model.oper_name=="添加传输系统")
			{
				isAddSys = true;
			}
			if(model.oper_name!=null&&model.oper_name=="修改传输系统")
			{
				isEditSys = true;
			}
			if(model.oper_name!=null&&model.oper_name=="删除传输系统")
			{
				isDeleteSys = true;
			}
			if(model.oper_name!=null&&model.oper_name=="保存系统")
			{
				isSaveSys = true;
			}
			if(model.oper_name!=null&&model.oper_name=="添加设备")
			{
				isAddEquipment = true;
			}
			if(model.oper_name!=null&&model.oper_name=="保存设备")
			{
				isSaveEquipment = true;
			}
			if(model.oper_name!=null&&model.oper_name=="添加复用段")
			{
				isAddTopolink = true;
			}
			if(model.oper_name!=null&&model.oper_name=="配置交叉")
			{
				isConfig = true;
			}
			if(model.oper_name!=null&&model.oper_name=="移出系统")
			{
				isDeleteEquipment = true;
			}
			if(model.oper_name!=null&&model.oper_name=="新建演习科目")
			{
				isAddInterpose = true;
			}
			if(model.oper_name!=null&&model.oper_name=="处理操作")
			{
				showOper = true;
			}if(model.oper_name!=null&&model.oper_name=="新建故障")
			{
				isAddInterposeFault = true;
			}
			if(model.oper_name!=null&&model.oper_name=="新建割接")
			{
				isAddCutFault = true;
			}
		}
	}
}

public function init():void
{    
    var s:Boolean=true;
	var ro:RemoteObject = new RemoteObject("fiberWire");
	ro.endpoint = ModelLocator.END_POINT;
	ro.showBusyCursor = true;
	ro.addEventListener(ResultEvent.RESULT,getConditonqs);	
	ro.hsdata(s,SysOrgMapL.AA);
	
	
var ro:RemoteObject = new RemoteObject("topolink");
	ro.endpoint = ModelLocator.END_POINT;
	ro.showBusyCursor = true;
	ro.addEventListener(ResultEvent.RESULT,getConditon1);	
	ro.station();  
	cB.width=0;
	cB.height=0;
	busGrid.width=0;
	busGrid.height=0;
	busGrids.width=0;
	busGrids.height=0;
	//myData.removeAll();
	//abc_route.removeAll();
	SerializationSettings.registerGlobalClient("code","String"); 
	SerializationSettings.registerGlobalClient("part", Consts.TYPE_NUMBER);
	Utils.registerImageByClass("link_flexional_icon", ModelLocator.link_flexional_icon);
	Utils.registerImageByClass("jian", ModelLocator.jian);
	ModelLocator.registerAlarm();
	elementBox=systemorgmap1.elementBox;
	serializer=new XMLSerializer(elementBox)
	elementBox.setStyle(Styles.BACKGROUND_TYPE, Consts.BACKGROUND_TYPE_IMAGE_VECTOR);
	elementBox.setStyle(Styles.BACKGROUND_IMAGE_STRETCH, Consts.STRETCH_FILL);
	elementBox.setStyle(Styles.BACKGROUND_IMAGE, "twaverImages/sysOrgMap/mainbg.png");
	mapLayer=new Layer("background");	
	elementBox.layerBox.add(mapLayer,0);
	mapLayer.movable = false;
	//DeviceXML=new XMLList("<folder state='0' code='ZY03070201' label='所有设备' parameter='ZY03070201' isBranch='true' leaf='false' type='equiptype' ></folder>");	 new
	//添加工具条
	DemoUtils.initNetworkToolbarForSysGraph(toolbar, systemorgmap1,"默认模式");
	
	DemoUtils.createButtonBar(toolbar, [DemoUtils.createButtonInfo("展开/收缩面板", DemoImages.toggle, function():void
	{
		var visible:Boolean=!leftpanel.visible;
		leftpanel.visible=visible;
		leftpanel.includeInLayout=visible;
	})
	], false, false, -1, -1);
		
		if (isSaveEquipment )
		{
			DemoUtils.createButtonBar(toolbar, [DemoUtils.createButtonInfo("保存设备", DemoImages.save01, function():void
			{
				if(tree.selectedItem==null)
				{
					Alert.show("尚未选中系统，请选中一个系统！", "提示");
					return;
				}
				else
				{
					var parent_x:int=0;
					var parent_y:int=0;
					var array:ArrayCollection=new ArrayCollection();
					for (var i:int=0; i < dataBox.count; i++) //遍历图中所有节点
					{
						var ielement:IElement=dataBox.datas.getItemAt(i);
						if (ielement is Node&&!(ielement is Grid)&&(ielement.getClient("NodeType")=="equipment"||ielement.getClient("NodeType")=="virtualequip" ))
						{
							var sys_node:Node=ielement as Node;
							
							var equipinfo:EquInfo=new EquInfo();						
							
							equipinfo.equipcode=sys_node.getClient("code");
							equipinfo.equipname=sys_node.name;
							equipinfo.x=sys_node.centerLocation.x;
							equipinfo.y=sys_node.centerLocation.y;
							equipinfo.systemcode=sys_node.getClient("parent");							
							array.addItem(equipinfo);
						}
					}
					var rtobj1:RemoteObject=new RemoteObject("fiberWire");
					rtobj1.endpoint=ModelLocator.END_POINT;
					rtobj1.showBusyCursor=true;
					rtobj1.SaveSysOrgMap(array);
					rtobj1.addEventListener(ResultEvent.RESULT, afterSaveSysOrgMap);
				}
				})
		], false, false, -1, -1);
			}
				DemoUtils.createButtonBar(toolbar, [DemoUtils.createButtonInfo("刷新", DemoImages.refresh, function():void
				{			
					refreshSystems();
					
				})
				], false, false, -1, -1);
                
				DemoUtils.initNetworkContextMenu(systemorgmap1, null);
				
				systemorgmap1.addEventListener(MouseEvent.MOUSE_WHEEL,wheelHandler);
				
				//增加右键菜单
				systemorgmap1.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, function(e:ContextMenuEvent):void
				{
					//右键选中网元
					var p:Point=new Point(e.mouseTarget.mouseX / systemorgmap1.zoom, e.mouseTarget.mouseY / systemorgmap1.zoom);
					var datas:ICollection=systemorgmap1.getElementsByLocalPoint(p);
					
					if (datas.count == 0)
					{		
						
						//systemorgmap1.selectionModel.clearSelection();
					}
					
					//定制右键菜单
					var flexVersion:ContextMenuItem=new ContextMenuItem(DemoUtils.FLEX_SDK_VERSION, false, false);
					var playerVersion:ContextMenuItem=new ContextMenuItem(DemoUtils.FLASH_PLAYER_VERSION, false, false);
					
					if (systemorgmap1.selectionModel.selection.count == 0)
					{ //选中元素个数
						systemorgmap1.contextMenu.customItems=[flexVersion, playerVersion];
					}
					else
					{
						if ((Element)(systemorgmap1.selectionModel.lastData) is Node && ((Element)(systemorgmap1.selectionModel.lastData).getClient("NodeType") == "equipment"))
						{ //选中节点  
							var item_device:ContextMenuItem=new ContextMenuItem("设备面板图", true);
							item_device.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
							var item_config:ContextMenuItem=new ContextMenuItem("查看交叉");
							item_config.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, configEquipSlot);
							var item_configEquipSolt :ContextMenuItem=new ContextMenuItem("配置交叉");
							item_configEquipSolt.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, configEquipSlot);
							var item_equipproperty:ContextMenuItem=new ContextMenuItem("查看设备属性");
							item_equipproperty.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
							var item_equipdelete :ContextMenuItem=new ContextMenuItem("删除设备");
							item_equipdelete.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, performance_dataHandler);
							var item_eventInterpose :ContextMenuItem=new ContextMenuItem("新建演习科目");
							item_eventInterpose.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
							var item_rootalarm:ContextMenuItem=new ContextMenuItem("查看当前根告警", true);
							item_rootalarm.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, AlarmHandler);
							var item_alarm:ContextMenuItem=new ContextMenuItem("查看当前告警");
							item_alarm.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, AlarmHandler);
							var item_historyrootalarm:ContextMenuItem=new ContextMenuItem("查看历史根告警");
							item_historyrootalarm.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, AlarmHandler);
							var item_historyalarm:ContextMenuItem=new ContextMenuItem("查看告警");
							item_historyalarm.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, AlarmHandler);
							var item_equipopera:ContextMenuItem=new ContextMenuItem("查看设备承载业务", true);
							item_equipopera.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handlerContextMenuCarryOpera);
							var item_eventInterposeFault :ContextMenuItem=new ContextMenuItem("新建故障");
							item_eventInterposeFault.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
							//处理操作
							var item_operate:ContextMenuItem = new ContextMenuItem("处理操作");
							item_operate.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
							item_operate.visible = showOper;
							//新建割接
							var item_cutfault:ContextMenuItem = new ContextMenuItem("新建割接");
							item_cutfault.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
							item_cutfault.visible = isAddCutFault;
							if (parentApplication.curUser != "root")
							{
								item_config.visible = isConfig;
							}
							//利用visible 显示隐藏
//							systemorgmap1.contextMenu.customItems=[item_device, item_config, item_equipproperty, item_equipopera,item_alarm,item_operate,item_eventInterpose,item_eventInterposeFault];
							systemorgmap1.contextMenu.customItems=[item_device, item_config, item_configEquipSolt, item_equipproperty, item_equipopera,item_equipdelete,item_alarm];
							if(showOper){
								systemorgmap1.contextMenu.customItems.push(item_operate);
							}
							if(isAddInterpose){
								systemorgmap1.contextMenu.customItems.push(item_eventInterpose);
							}
							if(isAddInterposeFault){
								systemorgmap1.contextMenu.customItems.push(item_eventInterposeFault);
							}
							if(isAddCutFault){
								systemorgmap1.contextMenu.customItems.push(item_cutfault);
							}

						}
						else if ((Element)(systemorgmap1.selectionModel.lastData) is Link)
						{ //选中线 
							if(((Link)(systemorgmap1.selectionModel.lastData).bundleLinks==null)||((Link)(systemorgmap1.selectionModel.lastData).bundleLinks!=null&&(Link)(systemorgmap1.selectionModel.lastData).getStyle(Styles.LINK_BUNDLE_EXPANDED)==true))
							{
								var item_slot:ContextMenuItem=new ContextMenuItem("时隙分布图");
								item_slot.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler_TimeSlot);
								var item_linkproperty:ContextMenuItem=new ContextMenuItem("查看复用段属性");
								item_linkproperty.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler_Ocable);
								var item_linkopera:ContextMenuItem=new ContextMenuItem("查看复用段承载业务", true);
								item_linkopera.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler_CarryOpera);
								
								var item_linkdel:ContextMenuItem=new ContextMenuItem("删除复用段", true);
								item_linkdel.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler_LinkDel);
								
								var link_eventInterpose :ContextMenuItem=new ContextMenuItem("新建演习科目");
								link_eventInterpose.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, link_eventInterposeHandler);
								var link_eventInterposeFault :ContextMenuItem=new ContextMenuItem("新建故障");
								link_eventInterposeFault.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, link_eventInterposeFaultHandler);
								
								var item_cutfault:ContextMenuItem = new ContextMenuItem("新建割接");
								item_cutfault.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, link_eventInterpose_FaultHandler);
								
								var item_fiberroute:ContextMenuItem = new ContextMenuItem("光路路由");
								item_fiberroute.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, fiberRouteShowHandler);
								
								systemorgmap1.contextMenu.customItems=[item_slot, item_linkproperty,item_linkdel, item_linkopera,link_eventInterpose,link_eventInterposeFault,item_cutfault,item_fiberroute];
							}
						}
						else
						{
							systemorgmap1.contextMenu.customItems=[flexVersion, playerVersion];
						}
					}
				});
				
				itemSystem=new winSystem(); //增、改传输系统的窗口
				itemSystem.addEventListener("SaveSystem", saveSys);
				//左侧树的右键（添加、修改、删除传输系统）
				
				cmi_addSys=new ContextMenuItem("添加传输系统");
				cmi_addSys.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, addSys);	
				cmi_modSys=new ContextMenuItem("修改传输系统");
				cmi_modSys.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, modSys);	
				cmi_delSys=new ContextMenuItem("删除传输系统");
				cmi_delSys.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, delSys);
				cmi_addSys.visible = isAddSys;
				cmi_modSys.visible = isEditSys;
				cmi_delSys.visible = isDeleteSys;
				cm=new ContextMenu();
				cm.hideBuiltInItems();
				cm.customItems=[];
				cm.addEventListener(ContextMenuEvent.MENU_SELECT,menuSelectHandler);
				tree.contextMenu=cm;	
//				var deviceTreeCM:ContextMenu=new ContextMenu();
//				deviceTreeCM.addEventListener(ContextMenuEvent.MENU_SELECT, deviceTreeItemSelectHandler);
//				deviceTreeCM.hideBuiltInItems();
//				deviceTreeCM.customItems=null;
//				deviceTree.contextMenu=deviceTreeCM;
		/*		if(trun>=1)
				{
					refreshSystems();
				}*/
				fww.getSystemTree1(); //获取系统组织图左侧系统树的数据	
				}
				/**
				 * 删除设备
				 *
				 * 
				 */
				private function performance_dataHandler(e:ContextMenuEvent):void{
					var node:Node=(Element)(systemorgmap1.selectionModel.lastData);
					delEquipcode = node.getClient("code");
					//根据设备编号删除设备
					if(delEquipcode!=null&&delEquipcode!=""){
						Alert.show("您确认要删除吗？","请您确认！",Alert.YES|Alert.NO,this,delEquipConfirmHandler,null,Alert.NO);
					}else{
						Alert.show("请先选择设备！","提示");
					}
				}
				private function delEquipConfirmHandler(event:CloseEvent):void {
					if (event.detail == Alert.YES) {
						var remoteObject:RemoteObject=new RemoteObject("resNetDwr");
						remoteObject.endpoint = ModelLocator.END_POINT;
						remoteObject.showBusyCursor = true;
						//删除设备
						var equipModel:Equipment = new Equipment();
						equipModel.equipcode=delEquipcode;
						remoteObject.delEquipmentByModel(equipModel);
						remoteObject.addEventListener(ResultEvent.RESULT,delEquipResult);
						Application.application.faultEventHandler(remoteObject);
					}
				}
				
				public function delEquipResult(event:ResultEvent):void{
					if(event.result.toString()=="success")
					{
						Alert.show("删除成功！","提示");
						this.refreshTrees();
					}else
					{
						Alert.show("删除失败！","提示");
					}
				}
				
				/**
				 * 
				 * @param event
				 * 
				 */
				private function wheelHandler(event:MouseEvent):void
				{
					if(event.ctrlKey && event.delta > 0 && systemorgmap1.zoom < 1.2)
					{
						systemorgmap1.zoomIn(false);
					}
					else if(event.ctrlKey && event.delta < 0 && systemorgmap1.zoom > 0.2)
					{
						systemorgmap1.zoomOut(false);
					}
					systemorgmap1.callLater(function():void
					{
						if(systemorgmap1.elementBox.selectionModel.count > 0)
						{
							var ele:Element = systemorgmap1.elementBox.selectionModel.selection.getItemAt(0);
							if(ele is Node)
							{
								systemorgmap1.centerByLogicalPoint(Node(ele).centerLocation.x,Node(ele).centerLocation.y);
							}
						}
					});
				}
				
				/**
				 *刷新系统 
				 * 
				 */
				private function refreshSystems():void
				{  
					Alert.show("another call");
					if(springLaouter!=null){
						springLaouter.stop();
					}
					if(tree.selectedItem)
					{
						var system:Location=new Location(tree.selectedItem.@code,tree.selectedItem.@name,tree.selectedItem.@x_coordinate,tree.selectedItem.@y_coordinate,false);
						freshAddNodeAfterExpand(system);
					}
					else
					{
						Alert.show("请选择系统!");
					}
					
				}
				/**
				 *系统树菜单选择处理函数 
				 * @param event
				 * 
				 */
				private function menuSelectHandler(event:ContextMenuEvent):void
				{	
					if(tree.selectedItem!=null)
					{
						
						if(tree.selectedItem.@type == "system")
						{
							tree.contextMenu.customItems=[cmi_modSys, cmi_delSys];				
						}
						else if(tree.selectedItem.@type=="vendor")
						{
							tree.contextMenu.customItems=[cmi_addSys];	
						}
						else
						{
							tree.contextMenu.customItems=[];
						}
						
					}
					
				}
				/**
				 *右侧尚未关联系统的设备树的选中处理函数 
				 * @param event
				 * 
				 */
				
				/**
				 *菜单配置时隙处理函数 
				 * @param e
				 * 
				 */
				private function configEquipSlot(e:ContextMenuEvent):void
				{
					
					if(e.currentTarget.caption == "查看交叉"){
						tw =new TitleWindow();
						tw.layout="absolute";
						tw.x=0;
						tw.y=0;
//						tw.width=Capabilities.screenResolutionX-50;
//						tw.height=Capabilities.screenResolutionY-250;
						tw.width=1280;
						tw.height=660;
						tw.styleName="popwindow";
						tw.showCloseButton=true;
						tw.title="查看交叉";
						var showcc:ShowCc=new ShowCc();
						var node:Node=(Element)(systemorgmap1.selectionModel.lastData);
						showcc.belongequip=node.getClient("code").toString();
						tw.addEventListener(CloseEvent.CLOSE,twcolse);
						tw.addChild(showcc);
						PopUpManager.addPopUp(tw,main(Application.application),true);
						PopUpManager.centerPopUp(tw);
					}else if(e.currentTarget.caption == "配置交叉") {
						var slot:configSlot=new configSlot();
						var node:Node=(Element)(systemorgmap1.selectionModel.lastData);
						slot.equipcode=node.getClient("code").toString();
						slot.equipname=node.name;
						MyPopupManager.addPopUp(slot, true);
					}
					
				}
				
				/**
				 *添加传输系统 
				 * @param evt
				 * 
				 */
				private function addSys(evt:ContextMenuEvent):void 
				{
					
					itemSystem.title="添加传输系统";
					PopUpManager.addPopUp(itemSystem, this.parent.parent, true);
					PopUpManager.centerPopUp(itemSystem);	
					
					var systemInfo:SystemInfo=new SystemInfo();
					systemInfo.vendor=tree.selectedItem.@code;
					
					itemSystem.initSys(systemInfo);
					itemSystem.txt_systemcode.editable=true;
					itemSystem.comb_vendor.enabled=false;
				}
				
				/**
				 *修改传输系统 
				 * @param evt
				 * 
				 */
				private function modSys(evt:ContextMenuEvent):void 
				{
					var item:Object=tree.selectedItem;
					
					if (item != null)
					{
						itemSystem.title="修改传输系统";
						PopUpManager.addPopUp(itemSystem, this.parent.parent, true);
						PopUpManager.centerPopUp(itemSystem);
						var systemInfo:SystemInfo=new SystemInfo();
						systemInfo.systemcode=item.@code;
						systemInfo.systemname=item.@name;
						systemInfo.x_capacity=item.@x_capacity;
						
						systemInfo.projectname=item.@projectname;
						systemInfo.tranmodel=item.@tranmodel;
						systemInfo.vendor=item.@vendor;
						systemInfo.remark=item.@remark;
						itemSystem.initSys(systemInfo);
						itemSystem.txt_systemcode.editable=false;
					}
					else
					{
						Alert.show("你没有选择节点", "提示");
					}
				}
				
			
				
				/**
				 *请求后台判断该设备是否存在机盘端口等数据返回处理函数 
				 * @param event
				 * 
				 */
				private function hasEquipPackHandler(event:ResultEvent):void
				{
					if (event.result.toString() == "true")
					{
						Alert.show("不能删除此设备!", "提示");
					}
					else
					{
						var ro:RemoteObject=new RemoteObject("equInfo");
						ro.endpoint=ModelLocator.END_POINT;
						ro.showBusyCursor=true;
						parentApplication.faultEventHandler(ro);
						ro.addEventListener(ResultEvent.RESULT, delEquipHandler);
						ro.delEquip(delEquipcode);
					}
				}
				
				/**
				 *删除设备返回处理函数 
				 * @param event
				 * 
				 */
				private function delEquipHandler(event:ResultEvent):void
				{
					Alert.show("设备删除成功!", "提示");
				}
				
				
				
				/**
				 *添加设备到系统中保存处理函数 
				 * @param event
				 * 
				 */
				private function addEquInfoHandler(event:FourParameterEvent):void
				{
					
					var node:IElement=elementBox.getElementByID(nodeId);
					if (node)
					{
						node.setClient("code",event.parameter1.toString());
						node.name=event.parameter2.toString();
						node.toolTip=event.parameter2.toString();
						var rt:RemoteObject=new RemoteObject("fiberWire");
						rt.endpoint=ModelLocator.END_POINT;
						rt.showBusyCursor=true;
						var equipcode:String=event.parameter1.toString();		
						rt.createFrameandSlot(event.parameter3.toString(),event.parameter4.toString(),equipcode);//为当前设备添加框槽
					}
					
					Alert.show("设备添加成功!", "提示");
					
//					
//					for (var i:int=0; i < deviceTree.dataProvider.children().length(); i++)//将该设备从传输设备树种移除
//					{
//						if (vendor == deviceTree.dataProvider.children()[i].@label)
//						{
//							deviceTree.selectedIndex=i + 1;
//							curIndex=i + 1;
//							selectedNode=deviceTree.selectedItem as XML;
//							delete selectedNode.folder;
//							catalogsid=selectedNode.attribute("code");
//							type=selectedNode.attribute("type");
//							var rt_DeviceTree:RemoteObject=new RemoteObject("fiberWire");
//							rt_DeviceTree.endpoint=ModelLocator.END_POINT;
//							rt_DeviceTree.showBusyCursor=true;
//							rt_DeviceTree.addEventListener(ResultEvent.RESULT, generateDeviceTreeInfo);	
//							parentApplication.faultEventHandler(rt_DeviceTree);
//							rt_DeviceTree.getTransDevice(catalogsid, type); //获取传输设备树的数据
//							break;
//						}
//					}
					
				}
				
				
				/**
				 *删除传输系统 
				 * @param evt
				 * 
				 */
				private function delSys(evt:ContextMenuEvent):void 
				{
					var item:Object=tree.selectedItem;
					
					if (item != null)
					{
						Alert.show("您确认要删除吗？", "请您确认！", Alert.YES | Alert.NO, this, delconfirmHandler, null, Alert.NO);
					}
					else
					{
						Alert.show("你没有选择节点", "提示");
					}
				}
				
				/**
				 *对用户对最终删除传输系统的操作进行处理  
				 * @param event
				 * 
				 */
				private function delconfirmHandler(event:CloseEvent):void
				{ 
					if (event.detail == Alert.YES)
					{
						var item:Object=tree.selectedItem;
						var rtobj:RemoteObject=new RemoteObject("fiberWire");
						rtobj.endpoint=ModelLocator.END_POINT;
						rtobj.showBusyCursor=true;
						rtobj.addEventListener(ResultEvent.RESULT, resultCallBack);
						parentApplication.faultEventHandler(rtobj);
						var systemcode:String=item.@code;
						rtobj.delSys(systemcode);
						Alert.show("传输系统删除成功！", "提示");
						
						
					}
					else if (event.detail == Alert.NO)
					{
						
					}
				}
				
				/**
				 *删除传输系统后的处理工作 
				 * @param event
				 * 
				 */
				private function resultCallBack(event:ResultEvent):void 
				{
					itemSystem.systemInfo.clear();
					fww.getSystemTree1();
					dataBox.clear();
				}
				
				
				
				/**
				 *添加或者修改系统后的处理函数 
				 * @param event
				 * 
				 */
				private function saveSys(event:Event):void
				{
					var systemInfo:SystemInfo=itemSystem.systemInfo;
					var rtobj:RemoteObject=new RemoteObject("fiberWire");
					rtobj.endpoint=ModelLocator.END_POINT;
					rtobj.showBusyCursor=true;
					rtobj.addEventListener(ResultEvent.RESULT, resultCallBack);
					parentApplication.faultEventHandler(rtobj);
					if (itemSystem.title == "添加传输系统")
						rtobj.addSys(systemInfo);
					else if (itemSystem.title == "修改传输系统")
						rtobj.modSys(systemInfo); 
					else
						Alert.show("请您重新添加或修改", "提示");
					
					PopUpManager.removePopUp(itemSystem);
					
					
				}
				
				//点击传输设备树触发事件：
				
				
				//点击树项目取到其下一级子目录  
				private function initEvent():void
				{ //初始化事件
					
					
					addEventListener(EventNames.SYSEVENT,getSysTree);
				}
				
				
				/**
				 *获取系统树某一层的下一级数据 
				 * @param e
				 * 
				 */
				private function getSysTree(e:Event):void
				{
					
					removeEventListener(EventNames.SYSEVENT, getSysTree);
					var rt_SysTree:RemoteObject=new RemoteObject("fiberWire");
					rt_SysTree.endpoint=ModelLocator.END_POINT;
					rt_SysTree.showBusyCursor=true;
					var code:String=tree_selectedNode.@code;//当前选中结点的编码
					var type:String= tree_selectedNode.@type;//当前选中结点的类型
					
					rt_SysTree.getSystemTree(code,type ); //获取系统树的数据
					rt_SysTree.addEventListener(ResultEvent.RESULT, generateSysTreeInfo);
					
				}
				/**
				 *保存系统组织图后的处理 
				 * @param e
				 * 
				 */
				private function afterSaveSysOrgMap(e:ResultEvent):void 
				{
					if (e.result == true)
					{
						Alert.show("保存成功！", "提示");
					}
					else
					{
						Alert.show("保存失败！", "提示");
					}
				}
				
				
				/**
				 *对加载树后的处理 
				 * @param event
				 * 
				 */
				private function resultHandler(event:ResultEvent):void
				{
					XMLData=new XMLList(event.result.toString());
					tree.dataProvider=XMLData;
					var xmllist:*=tree.dataProvider;
					var xmlcollection:XMLListCollection=xmllist;		
					for each (var element:XML in xmlcollection)
					{
						if (element.@code ==  "全网")
						{
							tree.selectedItem=element;
							sdsd=element;
							break;
						}
					}
					//tree.callLater(expandTrees);
					for each (var element:XML in xmlcollection.children())
					{ 
						if(element.@code!="业务名称")
						{
							element.@checked="0";
							delete element.system;
						}	
				
						
						if (element.@name ==  "业务名称")
						{    
							//tree.selectedItem=element as Object;
							element.@checked="1";
							if(element.@type == "system")
							{
								if(timer!=null){
									timer.stop();
								}
								
	
								//countTree++;
								countTree++;
								currSystemName=element.@name;							
							
								tree_selectedNode=element;
								nod.text="303";
								addNodeAfterClick(element);
								/*			vb.width=40;*/																						
							}
							break;   
						}
						tree.callLater(expandTrees);
					}
					
				}
				
				private function expandTrees():void
					
				{             
					tree.expandItem(sdsd,true);	
					
				}
				
				
				/**
				 *展开当前选中结点 
				 * 
				 */
				private function expandTree():void
				{
					var systemcode:String=Registry.lookup("systemcode");
					
					tree.expandItem(tree.selectedItem,true);
					if(systemcode!=null)//如果要查找指定系统下的设备
					{ 
						Registry.unregister("systemcode");
						var xmllist:*=tree.dataProvider;
						var xmlcollection:XMLListCollection=xmllist;	
						var exist:Boolean=false;
						for each ( var systemelement:XML in xmlcollection.children())
						{
							if(systemelement.@code==systemcode)
							{
								systemelement.@checked="1";
								tree.selectedItem=systemelement;
								addNodeAfterClick(systemelement);
								tree_selectedNode = tree.selectedItem as XML;
							}
							
						}
					}
				}
				
				
				/**
				 *加载系统树失败的处理 
				 * @param event
				 * 
				 */
				public function DealFault(event:FaultEvent):void 
				{
					Alert.show(event.fault.toString());
				}
				
				/**
				 *对传输设备树展开载事件的处理 
				 * @param event
				 * 
				 */
//				private function generateDeviceTreeInfo(event:ResultEvent):void 
//				{
//					
//					var str:String=event.result as String;	
//					if (str != null && str != "")
//					{
//						var child:XMLList=new XMLList(str);
//						if (selectedNode.children() == null || selectedNode.children().length() == 0)
//						{
//							deviceTree.expandItem(selectedNode, false);
//							selectedNode.appendChild(child);
//							deviceTree.callLater(openTreeNode, [selectedNode]);
//						}
//					}
//					addEventListener(EventNames.CATALOGROW, gettree);
//				}
				
				private function generateSysTreeInfo(event:ResultEvent):void //对传输设备树展开载事件的处理
				{
					
					var str:String=event.result as String;	
					if (str != null && str != "")
					{
						
						var child:XMLList=new XMLList(str);
						
						if (tree_selectedNode.children() == null || tree_selectedNode.children().length() == 0)
						{
							tree.expandItem(tree_selectedNode,false);//先关闭当前结点
							tree_selectedNode.appendChild(child);
							
							tree.callLater(openSystemTreeNode, [tree_selectedNode.parent()]);          //test
							
						}
					}
					addEventListener(EventNames.SYSEVENT, getSysTree);
				}
				private function openSystemTreeNode(xml:XML):void
				{
					if (tree.isItemOpen(xml))
						tree.expandItem(xml, false);
					tree.expandItem(xml, true);
				}
								
				
				/**
				 *为传输系统树的结点设置图标 
				 * @param item
				 * @return 
				 * 
				 */
				private function iconFun(item:Object):*
				{ 
					return ModelLocator.systemIcon;
				}
				
				/**
				 *为传输设备树的结点添加图标 
				 * @param item
				 * @return 
				 * 
				 */
				private function deviceiconFun(item:Object):* 
				{
					if (item.@leaf == true)
						return ModelLocator.equipIcon;
					else
						return DemoImages.file;
				}
				
				private function refreshTrees():void{
					var node:XML=tree.selectedItem as XML;
					currSystemName=node.@name;//用于分析
					addNodeAfterClick(node);
					var xmllist:*=tree.dataProvider;
					var xmlcollection:XMLListCollection=xmllist;	
					
					for each ( var systemelement:XML in xmlcollection.children())
					{
						if(systemelement.@code!=node.@code)
						{
							systemelement.@checked="0";
							delete systemelement.system;
						}
						
					}
				}
				
				/**
				 *选中或者撤销传输系统树中某个系统的操作 
				 * @param evt
				 * 
				 */
				private function showSystemMap(evt:MouseEvent):void 
				{   
					if (evt.target is CheckBox)
					{	 
						var node:XML=tree.selectedItem as XML;
						if(node.@type == "system")
						{    
							if(timer!=null){
								timer.stop();
							}
							if (evt.target.hasOwnProperty('selected'))
							{ //如果结点有“selected”这个属性
								if (evt.target.selected)
								{ //如果结点被选中
									//									if(node.@name=="传输A网"||node.@name=="传输B网"){
									//										gxCheckBox.visible= true;	
									//									}else{
									//										gxCheckBox.visible= false;
									//									}			
									currSystemName=node.@name;//用于分析
//									cob_add.visible=false;cob_add.width=0;//附加次数选项隐藏  用于关键点分析
									addNodeAfterClick(node);
									var xmllist:*=tree.dataProvider;
									var xmlcollection:XMLListCollection=xmllist;	
									
									for each ( var systemelement:XML in xmlcollection.children())
									{
										if(systemelement.@code!=node.@code)
										{
											systemelement.@checked="0";
											delete systemelement.system;
										}
										
									}
								}
								else
								{  
									node.@checked="0";
									delete node.system;
									elementBox.clear();
									tree_selectedNode = null;
								}
							}else{
//								lab.text ="";
//								su.headerText="";
//								no.headerText="";
//								di.headerText="";
//								equipGrid.dataProvider=null;
							}
						}
						
						
					}				
					if(cB.visible==true)
					  {     
						   
						if(BUSINESS_NAME.visible==true)
					    {      	   
					 	  if(this.tree.selectedItem.@type=="business")
					 	  {   					
							   //liqinming1234
							  systemorgmap1.elementBox.selectionModel.clearSelection();        //clearSelection()			  
							  ServDownList.selectedIndex=0; 
						//systemorgmap1.elementBox.clear();
				             busGrid.width=0;
							  busGrid.height=0;
							  busGrids.width=1155;
							  busGrids.height=96;
							  busGrid.visible=false;			
							  busGrids.visible=true;
							  
			
							  var  sid:int=-1;
							   if(createbusiness.group.length>0)
							   {    
							  for(var i:int=0;i<createbusiness.group.length;i++)
							  {
								  if(tree.selectedItem.@name==createbusiness.group.getItemAt(i).name.toString())
								  {    sid=i;									  
									  break;
								  }
							  }
							   }
							   if(sid==-1)
							   {
										   var  treedis:XML =  tree.selectedItem as XML;
										   var treenames:String=treedis.@name;  
										   var ros:RemoteObject = new RemoteObject("topolink");
										   ros.endpoint = ModelLocator.END_POINT;
										   ros.showBusyCursor = true;
										   ros.addEventListener(ResultEvent.RESULT,getConditonas);	
										   ros.qqs(treenames);  
									   }
							
	
							   if(sid>=0)
							   {
								   myData = new ArrayCollection([
									   {	
								   BUSINESS_NAME:createbusiness.group.getItemAt(sid).name.toString(),    
								   PA:createbusiness.group.getItemAt(sid).start.toString(),
								   PB:createbusiness.group.getItemAt(sid).end.toString(),
								   BUSINESS_RATE:createbusiness.group.getItemAt(sid).rate.toString(),
								   BUSINESS_TYPE_ID:createbusiness.group.getItemAt(sid).type.toString()		
									   }
								   ]);	
							   }
							   
							/*   #FFFFFF*/
						/*	  myData = new ArrayCollection([{BUSINESS_NAME:"fwef",PA:"wfwwf",PB:"wfwsw3",BUSINESS_RATE:"ceee",BUSINESS_TYPE_ID:"eeeee23"}]);		*/								  					  	        	  
						  }
					    }
					  } 
				/*	if(clear_arr.length>0)
					{
						clearColor();
						var ac:int=clear_arr.length;
						for(var i:int=0;i<ac;i++)
						{
							clear_arr.pop();
						}						
					}*/				
					}
				
				/**
				 *在该系统结点下添加设备结点 
				 * @param node
				 * 
				 */
				private function addEquipNode(node:XML):void
				{
					
					tree_selectedNode=node;
					
					if(tree_selectedNode!=null )
					{
						
						if(tree_selectedNode.children().length() == 0)
						{			
							dispatchEvent(new Event(EventNames.SYSEVENT));
						}
						
					}
				}
				/**
				 *添加系统到network中 
				 * @param node
				 * 
				 */
				private function addNodeAfterClick(node:XML):void
				{
					var system:Location=new Location(node.@code,node.@name,node.@x_coordinate,node.@y_coordinate,false);
					freshAddNodeAfterExpand(system);
				}
				
				/**
				 *添加已经展开的系统到network中
				 *  
				 * @param system
				 * 
				 */
				private function freshAddNodeAfterExpand(system:Location):void
				{
					var rtobj:RemoteObject=new RemoteObject("fiberWire");
					rtobj.endpoint=ModelLocator.END_POINT;
					rtobj.showBusyCursor=true;
					parentApplication.faultEventHandler(rtobj);
					rtobj.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void
					{
						systemorgmap1.elementBox.clear();
						var xml:String=event.result.toString();
						var equips:Array=(JSON.decode(xml.split("---")[0].toString()) as Array); //获取该系统的设备数组
						var business_n:Array=(JSON.decode(xml.split("---")[1].toString()) as Array); //获取业务                             //liao
						var ocables:Array=(JSON.decode(xml.split("---")[2].toString()) as Array); //获取该系统的复用段数组
						Shareds.equips=equips;//设备数组初始 mawj分析
						Shareds.ocables=ocables;
						Shareds.business_n=business_n;                   //liao
						tree_selectedNode= tree.selectedItem as XML;
              			var str:String="";
						var str1:String="";             //liao 业务
						for(var p:int=0;p<business_n.length;p++)
						{var liao_bus:Object=business_n[p] as Object;			
						str1 += "<system  name='"+liao_bus.business_name+"' x_coordinate=\"0\" y_coordinate=\"0\" itemShowCheckBox=\"false\" isBranch=\"false\" type=\"business\" checked=\"0\"></system>";
						}
						treeChild=str1;                      //liao
						for (var i:int=0; i < equips.length; i++)
						{	
							var equip:Object=equips[i] as Object;			
							var exist_node:Node=systemorgmap1.elementBox.getDataByID(equip.equipcode) as Node;
							if(exist_node==null)//尚未添加该设备
							{  
								str += "<system code='"+equip.equipcode+"' name='"+equip.equipname+"' x_coordinate=\"0\" y_coordinate=\"0\" itemShowCheckBox=\"false\" isBranch=\"false\" type=\"equip\" checked=\"0\"></system>";
								var node:Node=new Node(equip.equipcode);
								
								node.name=equip.equipname;
								node.setClient("parent", equip.systemcode);
								node.setClient("code",equip.equipcode);	
								node.toolTip=equip.equiplabel;	
								node.setSize(50,50);
								
								if((equip.x_vendor=='ZY0810'&&equip.x_model=='虚拟') || equip.x_model == 'xunizhandian'||equip.x_model=='虚拟网元')
								{
									node.image="twaverImages/device/xunishebei.png";
									node.icon="twaverImages/device/xunishebei.png";
									node.setClient("NodeType","virtualequip");
								}
								else
								{
									var x_model:String=equip.x_model;
									var re1:RegExp = new RegExp("/", "g"); 
									var img_x_model:String=x_model.replace(re1,"");
									var re2:RegExp = new RegExp(" ", "g"); 
									img_x_model=img_x_model.replace(re2,"");
									//Alert.show(equip.x_vendor+"-"+img_x_model);
									if(img_x_model!="")
									{
										node.image="twaverImages/device/"+equip.x_vendor+"-"+img_x_model+".png";
										node.icon="twaverImages/device/"+equip.x_vendor+"-"+img_x_model+".png";
									}
									else
									{
										node.image="twaverImages/device/"+equip.x_vendor+".png";
										node.icon="twaverImages/device/"+equip.x_vendor+".png";	
									}
									node.setClient("NodeType","equipment");
								}
								
								var x:int=equip.x;
								var y:int=equip.y;
								node.setCenterLocation(x, y);
								node.setStyle(Styles.LABEL_YOFFSET, -2);
								node.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
								node.setStyle(Styles.SELECT_COLOR,"0xFF6600");
								node.setStyle(Styles.SELECT_WIDTH,'10');
								node.setStyle(Styles.IMAGE_STRETCH,Consts.STRETCH_FILL);					
								node.setStyle(Styles.LABEL_SIZE,12);
								node.setStyle(Styles.INNER_STYLE,Consts.INNER_STYLE_SHAPE);			
								node.setClient("alarmcount",equip.alarmcount);
								node.setClient("alarmlevel",equip.alarmlevel);
								
								if(alarm_all==true)
								{
									if(equip.alarmlevel!="null"&&equip.alarmcount!="0"&&equip.alarmcount!="null")
									{						
										node.alarmState.setNewAlarmCount(AlarmSeverity.getByValue(int(equip.alarmlevel)),int(equip.alarmcount));
										
									}
								}
								systemorgmap1.elementBox.add(node);	
							}
							
						}
						if(currSystemName!=""&&countTree==1)
						{     //Alert.show("ewfw");
							tree.expandItem(tree_selectedNode, false, true);	
							tree_selectedNode.appendChild(new XMLList(str1));              //liao
							tree.expandItem(tree_selectedNode, true, true);	
							countTree--;
						}
						//添加第三级节点 
						
						
						for ( i=0; i < ocables.length; i++) //把系统内部设备之间的复用段
						{
							var ocable:Object=ocables[i] as Object;
							var equip_a:String=ocable.equip_a;
							var system_a:String=ocable.system_a;
							var equip_z:String=ocable.equip_z;
							var system_z:String=ocable.system_z;
							var label:String=ocable.label;
							var labelname:String=ocable.aendptpxx + "-" + ocable.zendptpxx;	
							var node_a:Node=null;
							var node_z:Node=null;
							var existlink:Link=systemorgmap1.elementBox.getDataByID(label) as Link;
							if(existlink==null)
							{
								node_a=systemorgmap1.elementBox.getDataByID(equip_a) as Node;
								node_z=systemorgmap1.elementBox.getDataByID(equip_z) as Node;
								if(node_a!=null&&node_z!=null)
								{
									//									var link:DemoLink=new DemoLink(label,node_a, node_z);
									var link:Link=new Link(label,node_a, node_z);
									var aendptp:String=ocable.aendptp;
									var aendptpxx:String=ocable.aendptpxx;
									var zendptp:String=ocable.zendptp;
									var zendptpxx:String=ocable.zendptpxx;
									var link_color:String=String(ocable.linkcolor);
									var linktype:String=String(ocable.linktype);
									var opticalid:String = String(ocable.opticalid);
									if (link_color != "") 
									{						
										link.setStyle(Styles.LINK_COLOR, link_color);
									}
									link.setStyle(Styles.LINK_WIDTH,2.5);

									
									link.setClient("equip_a", equip_a);
									link.setClient("equip_z", equip_z);
									link.setClient("equip_a_name", node_a.name);
									link.setClient("equip_z_name", node_z.name);									
									link.setClient("labelname", labelname);
									link.toolTip=labelname;
									link.setClient("linktype", linktype);
									link.setStyle(Styles.LINK_BUNDLE_OFFSET, 50);
									link.setStyle(Styles.LINK_BUNDLE_GAP,25);
									link.setStyle(Styles.LINK_BUNDLE_EXPANDED, false);
									
									if(opticalid==null||opticalid==""){
										link.setStyle(Styles.LINK_PATTERN,[3,8]);
									}
									
									link.setClient("code",label);
									link.setClient("linerate", ocable.linerate);
									link.setClient("systemname",system.systemcode);
									link.setClient("aendptp",aendptp);
									link.setClient("aendptpxx",aendptpxx);
									link.setClient("zendptp",zendptp);
									link.setClient("zendptpxx",zendptpxx);
									link.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
									link.setStyle(Styles.SELECT_COLOR,"0xFF6600");
									link.setStyle(Styles.SELECT_WIDTH,'10');
									if(i<=60){
										link.setClient("status","normal");
									}else{
										link.setClient("status","aa");
									}
									systemorgmap1.elementBox.add(link);	
									//									if(timer==null){
									//										timer= new Timer(600);
									//										timer.addEventListener(TimerEvent.TIMER, tick);	
									//									}
									//									timer.start();
								}	
							}		
							
						}
						var alarm:String=Registry.lookup("alarm");
						if(alarm!=null)
						{
							Registry.unregister("alarm");
							for each(var item:* in toolbar.getChildren())
							{
//								if(item is CheckBox&& item.label=='呈现所有告警')
//								{		
//									CheckBox(item).selected=true;
//									alarm_all=true;
//									systemorgmap1.elementBox.forEach(function(element:IElement):void{
//										if(element is Node&&element.getClient("NodeType")=="equipment")
//										{	
//											var alarmcount:String=element.getClient("alarmcount");
//											var alarmlevel:String=element.getClient("alarmlevel");
//											element.alarmState.setNewAlarmCount(AlarmSeverity.getByValue(int(alarmlevel)),int(alarmcount));
//										}
//									});
//								}
							}
						}
						//居中显示
						if(!showSysGraphAlarm){
							setTimeout(setScrollPosition,500);
						}
					//	setTimeout(setScrollPosition,500);
						//加载完成后缩放 字体清晰
						systemorgmap1.zoom =	0.5917159763313609;
						var fontsize:int=12; //字号	
						fontsize=parseInt((fontsize/0.5917159763313609).toString());		
						var count:int=systemorgmap1.elementBox.datas.count; 
						for(var i:int=0;i<count;i++){				
							(systemorgmap1.elementBox.datas.getItemAt(i) as Element).setStyle(Styles.LABEL_SIZE,fontsize);  
						}	 	
						
						var equipcode:String=Registry.lookup("equipcode");
						if(equipcode!=null)
						{
							setTimeout(setLocation,0);
						}
						if(showSysGraphAlarm){
							setAlarmShow();//如果选择呈现，则呈现告警
						}
							
						
					});
								
					rtobj.getSystemData(system.systemcode,false);//查询当前系统的设备和复用段(不包含对接设备)
					
				}
				
				private function setScrollPosition():void{
					systemorgmap1.horizontalScrollPosition = systemorgmap1.width/2;
					systemorgmap1.verticalScrollPosition = systemorgmap1.height/2;								
					
				}
				
				private var b:Boolean = false;
				private function tick(event:TimerEvent = null):void {
					if(!b){
						flowingOffset += 5;	
					}else{
						flowingOffset-=5;
					}
					if(flowingOffset==0){
						b=false;		
					}
					
					iconAlpha -= 40;
					//					flowingOffset += 5;
					if(iconAlpha<0){
						iconAlpha = 255;
					}
					if(flowingOffset>100){
						b=true;
						//						flowingOffset = 0;
					}
					systemorgmap1.elementBox.forEach(function(element:IElement):void{
						if(element is Link){
							if(element.getClient("status") != "normal"){
								element.setClient("alpha", iconAlpha);
							}else{
								element.setClient("flowingOffset", flowingOffset);
							}
						}
					});
				}
				
				/**
				 *定位特定设备的位置 
				 * 
				 */
				private function setLocation():void
				{
					var equipcode:String=Registry.lookup("equipcode");
					if(equipcode!=null)
					{
						Registry.unregister("equipcode");
						var selectnode:Node=dataBox.getDataByID(equipcode) as Node;
						if(selectnode!=null)
						{
							//systemorgmap1.selectionModel.clearSelection();
							systemorgmap1.selectionModel.appendSelection(selectnode);
							selectnode.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
							selectnode.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
							selectnode.setStyle(Styles.VECTOR_FILL_COLOR, 0x7697C9);
							systemorgmap1.centerByLogicalPoint(selectnode.centerLocation.x,selectnode.centerLocation.y);
						}
						
					}
				}
				
				
				/**
				 *获取equipcode所在的系统结点或者设备结点 
				 * @param equipcode
				 * @param system
				 * @return 
				 * 
				 */
				private function getCloudOrEquip(equipcode:String, system:String):Node
				{
					var node:Node=null;
					node=dataBox.getDataByID("id"+system) as Node;//获取系统system
					if(node==null)//系统system已经展开
					{
						node=dataBox.getDataByID(equipcode) as Node;//找到展开后的设备
					}
					
					return node;
				}
				/**
				 *查看设备业务菜单的处理函数 
				 * @param e
				 * 
				 */
				private function handlerContextMenuCarryOpera(e:ContextMenuEvent):void 
				{
					
					var node:Node=(Element)(systemorgmap1.selectionModel.lastData);
					var equipcode:String=node.getClient("code").toString();
					var carryOpera:CarryOpera=new CarryOpera();
					carryOpera.title=node.name+"-设备承载业务";
					carryOpera.getOperaByCodeAndType( equipcode,"equipment");
					MyPopupManager.addPopUp(carryOpera);
					
					
				}
				
				
				
				
				
				
				/**
				 *查看复用段菜单的处理函数 
				 * @param e
				 * 
				 */
				private function itemSelectHandler_CarryOpera(e:ContextMenuEvent):void //
				{
					
					var link:Link=(Element)(systemorgmap1.selectionModel.lastData);
					var label:String=link.getClient("code").toString();
					var labelname:String=link.getClient("labelname").toString();
					var carryOpera:CarryOpera=new CarryOpera();
					carryOpera.getOperaByCodeAndType( label,"topolink");
					carryOpera.title=labelname+"-复用段承载业务";	
					MyPopupManager.addPopUp(carryOpera);
					
				}
				
				private function link_eventInterposeHandler(e:ContextMenuEvent):void
				{
					if (e.currentTarget.caption == "新建演习科目") {
						var link:Link=(Element)(systemorgmap1.selectionModel.lastData);
						var topolinkid:String=link.getClient("code").toString();
						var labelname:String=link.getClient("labelname").toString();
						var interpose:InterposeTitle = new InterposeTitle();
						interpose.title = "添加";
						interpose.isModify=false;
						interpose.isEquip=true;
						interpose.typeflag=true;
						interpose.paraValue = belongCode;
						interpose.myCallBack=this.refreshTrees;
						interpose.mainApp=this;
						interpose.resname=labelname;
						interpose.resourceid=topolinkid;
						PopUpManager.addPopUp(interpose,Application.application as DisplayObject,true);
						PopUpManager.centerPopUp(interpose);
						interpose.setTxtData1();
						interpose.addEventListener("RefreshDataGrid",RefreshDataGrid);
					}
				}
				
				//查询复用段关联光路路由
				private function fiberRouteShowHandler(e:ContextMenuEvent):void{
					var link:Link=(Element)(systemorgmap1.selectionModel.lastData);
					var topolinkid:String=link.getClient("code").toString();
					//根据复用段查找光路起始端口，有则呈现，否则提示无相关数据
					var remoteObject:RemoteObject=new RemoteObject("fiberWire");
					remoteObject.endpoint=ModelLocator.END_POINT;
					remoteObject.addEventListener(ResultEvent.RESULT, getPortCodeByToplinkidHandler);//原来
					remoteObject.getPortCodeByToplinkid(topolinkid);
				}
				
				private function getPortCodeByToplinkidHandler(event:ResultEvent):void{
					if(event.result.toString()!=null&&event.result.toString()!=""){
						var portcode:String=event.result.toString();
						var fri:sourceCode.ocableResource.views.OcableRoutInfo = new sourceCode.ocableResource.views.OcableRoutInfo();
						fri.title = "光路路由图";
						fri.getFiberRouteInfo(portcode);
						fri.width=Application.application.workspace.width;
						fri.height=Application.application.workspace.height+70;
						MyPopupManager.addPopUp(fri);
						fri.y =0;
					}else{
						Alert.show("无相关数据!", "提示");
					}
				}
				
				//割接，添加设备
				private function link_eventInterpose_FaultHandler(e:ContextMenuEvent):void{
					var link:Link=(Element)(systemorgmap1.selectionModel.lastData);
					var topolinkid:String=link.getClient("code").toString();
					var labelname:String=link.getClient("labelname").toString();
					mouse_x=e.mouseTarget.mouseX/systemorgmap1.zoom;
					mouse_y=e.mouseTarget.mouseY/systemorgmap1.zoom;
					//判断选择的复用段的速率是否大于等于155M；
					var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
					remoteObject.endpoint = ModelLocator.END_POINT;
					remoteObject.showBusyCursor = true;
					Application.application.faultEventHandler(remoteObject);
					remoteObject.addEventListener(ResultEvent.RESULT,getToplinkRateByCodeHandler);
					
					remoteObject.getToplinkRateByCode(topolinkid);
					
				}
				
				private function getToplinkRateByCodeHandler(event:ResultEvent):void{
					if(event.result.toString()=="SUCCESS"){
//						可以添加
						var link:Link=(Element)(systemorgmap1.selectionModel.lastData);
						var topolinkid:String=link.getClient("code").toString();
						var labelname:String=link.getClient("labelname").toString();
						var interposeFault1:InterposeFaultTitle1 = new InterposeFaultTitle1();
						interposeFault1.title = "添加";
						interposeFault1.isModify=false;
						interposeFault1.isEquip=true;
						interposeFault1.isCutFault=true;
						interposeFault1.paraValue = belongCode;
						interposeFault1.myCallBack=this.refreshTrees;
						interposeFault1.mainApp=this;
						interposeFault1.user_id=parentApplication.curUser;
						interposeFault1.txt_user_name =parentApplication.curUserName;
						interposeFault1.resname=labelname;
						interposeFault1.resourceid=topolinkid;//复用段ID
						interposeFault1.sys_code = tree.selectedItem.@code;//系统编码
						interposeFault1.mouse_x = mouse_x;
						interposeFault1.mouse_y = mouse_y;
						PopUpManager.addPopUp(interposeFault1,Application.application as DisplayObject,true);
						PopUpManager.centerPopUp(interposeFault1);
						interposeFault1.setTxtData();
						interposeFault1.addEventListener("RefreshDataGrid",RefreshDataGrid);
					}else{
						Alert.show("所选复用段不能进行割接！","提示");
						
					}
				}
				
				private function link_eventInterposeFaultHandler(e:ContextMenuEvent):void{
					if (e.currentTarget.caption == "新建故障") {
						var link:Link=(Element)(systemorgmap1.selectionModel.lastData);
						var topolinkid:String=link.getClient("code").toString();
						var labelname:String=link.getClient("labelname").toString();
						var interposeFault:InterposeFaultTitle1 = new InterposeFaultTitle1();
						interposeFault.title = "添加";
						interposeFault.isModify=false;
						interposeFault.isEquip=true;
						interposeFault.paraValue = belongCode;
						interposeFault.myCallBack=this.refreshTrees;
						interposeFault.mainApp=this;
						interposeFault.user_id=parentApplication.curUser;
						interposeFault.txt_user_name =parentApplication.curUserName;
						interposeFault.resname=labelname;
						interposeFault.resourceid=topolinkid;
						PopUpManager.addPopUp(interposeFault,Application.application as DisplayObject,true);
						PopUpManager.centerPopUp(interposeFault);
						interposeFault.setTxtData();
						interposeFault.addEventListener("RefreshDataGrid",RefreshDataGrid);
					}
				}
				
				/**
				 *查看设备面板图，设备属性的菜单处理函数 
				 * @param e
				 * 
				 */
				private function itemSelectHandler(e:ContextMenuEvent):void 
				{
					var node:Node=(Element)(systemorgmap1.selectionModel.lastData);
					var equipcode:String=node.getClient("code");
					belongCode = equipcode;
					if(e.currentTarget.caption == "处理操作"){
						var alarm1:AlarmMangerModel=new AlarmMangerModel();
						alarm1.iscleared="0";
						alarm1.belongequip=equipcode;
						var rtobj:RemoteObject=new RemoteObject("faultSimulation");
						rtobj.endpoint= ModelLocator.END_POINT;
						rtobj.showBusyCursor=true;
						rtobj.addEventListener(ResultEvent.RESULT,getInterposeIdsByAlarmModelHandler);
						rtobj.getInterposeIdsByAlarmModel(alarm1);
						//根据设备编号，机框序号，机槽序号和机盘序号查询未清除的告警？
						//即干预ID列表，怎么接受？如果id列表不为空，则
						//弹出一个页面
						//否则提示不需要维护
					}
					
					if (e.currentTarget.caption == "设备面板图")
					{
						Registry.register("systemcode", node.getClient("parent").toString());
						Registry.register("equipcode", equipcode);
						Application.application.openModel(e.currentTarget.caption, false);		
					}
					else if (e.currentTarget.caption == "查看设备属性")
					{
						
						var property:ShowProperty = new ShowProperty();
						property.paraValue = equipcode;
						property.tablename = "EQUIPMENT_VIEW";
						property.key = "EQUIPCODE";
						property.title = "设备查看—"+node.name;
						PopUpManager.addPopUp(property, this, true);
						PopUpManager.centerPopUp(property);
						property.addEventListener("savePropertyComplete",function (event:Event):void{
							PopUpManager.removePopUp(property);
							
						});
						property.addEventListener("initFinished",function (event:Event):void{
							
							(property.getElementById("STATIONNAME",property.propertyList) as mx.controls.TextInput).enabled = false;
							(property.getElementById("SYSTEM_NAME",property.propertyList) as mx.controls.ComboBox).enabled = false;
							(property.getElementById("X_VENDOR",property.propertyList) as mx.controls.ComboBox).enabled = false;
							(property.getElementById("X_MODEL",property.propertyList) as mx.controls.ComboBox).enabled = false;
							(property.getElementById("S_SBMC",property.propertyList) as mx.controls.TextInput).enabled = false;
							(property.getElementById("ROOMCODE",property.propertyList) as mx.controls.TextInput).enabled = false;
							
						});
						
					}
					else if (e.currentTarget.caption == "新建演习科目") {
						var interpose:InterposeTitle = new InterposeTitle();
						interpose.title = "添加";
						interpose.isModify=false;
						interpose.isEquip=true;
						interpose.paraValue = equipcode;
						interpose.myCallBack=this.refreshTrees;
						interpose.mainApp=this;
						PopUpManager.addPopUp(interpose,Application.application as DisplayObject,true);
						PopUpManager.centerPopUp(interpose);
						interpose.addEventListener("RefreshDataGrid",RefreshDataGrid);
					}else if (e.currentTarget.caption == "新建故障") {
						var interposeFault:InterposeFaultTitle = new InterposeFaultTitle();
						interposeFault.title = "添加";
						interposeFault.isModify=false;
						interposeFault.isEquip=true;
						interposeFault.paraValue = belongCode;
						interposeFault.myCallBack=this.refreshTrees;
						interposeFault.mainApp=this;
						interposeFault.user_id=parentApplication.curUser;
						interposeFault.txt_user_name =parentApplication.curUserName;
						PopUpManager.addPopUp(interposeFault,Application.application as DisplayObject,true);
						PopUpManager.centerPopUp(interposeFault);
						interposeFault.setTxtData();
						interposeFault.addEventListener("RefreshDataGrid",RefreshDataGrid);
						//新建故障后  关闭当前仿真拓扑图  仿真拓扑图中的新建故障针对当前用户 
						
					}else if (e.currentTarget.caption == "新建割接") {
						var interposeFault2:InterposeFaultTitle2 = new InterposeFaultTitle2();
						interposeFault2.title = "添加";
						interposeFault2.isModify=false;
						interposeFault2.isEquip=true;
						interposeFault2.isCutFault=true;
						interposeFault2.paraValue = belongCode;//设备编号
						interposeFault2.myCallBack=this.refreshTrees;
						interposeFault2.mainApp=this;
						interposeFault2.user_id=parentApplication.curUser;
						interposeFault2.txt_user_name =parentApplication.curUserName;
						interposeFault2.sys_code = tree.selectedItem.@code;//系统编码
						PopUpManager.addPopUp(interposeFault2,Application.application as DisplayObject,true);
						PopUpManager.centerPopUp(interposeFault2);
						interposeFault2.setTxtData();
						interposeFault2.addEventListener("RefreshDataGrid",RefreshDataGrid);
						
					}
					
				}
				
				private function RefreshDataGrid(event:Event):void{
					Application.application.openModel("演习科目管理", false);
				}

				private function getInterposeIdsByAlarmModelHandler(event:ResultEvent):void{
					var str:String = event.result.toString();
					if(str==""||str==null){
						Alert.show("无演习告警！","提示");
						return;
					}else{
						//弹出一个框，把list传过去
						var eventMaintain:userEventMaintainTitle = new userEventMaintainTitle();
						PopUpManager.addPopUp(eventMaintain,Application.application as DisplayObject,true);
						PopUpManager.centerPopUp(eventMaintain);
						eventMaintain.vs.selectedIndex=0;
						eventMaintain.eventList = str;
						eventMaintain.equipcode =belongCode;
						eventMaintain.title="处理操作";
						eventMaintain.myCallBack=this.refreshTrees;
						eventMaintain.mainApp=this;
					}
				}
				
				/**
				 *添加复用段处理函数 
				 * @param evt
				 * 
				 */

				
				private function createLinkInteraction(linkClass:Class, linkType:String, callback:Function=null, isByControlPoint:Boolean=false, splitByPercent:Boolean=true, value:Number=-1):void
				{
					if(isAddTopolink)
						systemorgmap1.setCreateLinkInteractionHandlers(linkClass, callback, linkType, isByControlPoint, value, true);
					else
						Alert.show("对不起，你没有添加复用段权限！","提示");
				}
				
				
				
				
				/**
				 *添加复用段处理函数 
				 * @param link
				 * 
				 */
				private function createLinkCallBack(link:Link):void
				{
					link.setStyle(Styles.LINK_COLOR, 0x009900);
					
					systemorgmap1.setDefaultInteractionHandlers();
					linkID=link.id;
					if(link.fromNode.getClient("code")==link.toNode.getClient("code")){
						dataBox.removeByID(linkID);
						Alert.show("复用段两端不能连接设备自身的端口","提示");
						return;
					}
					winTopoLink=new WinTopoLink();
					winTopoLink.initialize();
					winTopoLink.addEventListener("AfterAddTopoLink", afterAddTopolinkHandler);
					winTopoLink.equipCodeA=link.fromNode.getClient("code").toString();
					winTopoLink.equipCodeZ=link.toNode.getClient("code").toString();
					winTopoLink.txtEquipNameA.text=link.fromNode.name.toString();
					winTopoLink.txtEquipNameZ.text=link.toNode.name.toString();		
					winTopoLink.currSystemName=currSystemName;
					winTopoLink.addEventListener("CloseWinTopoLink", cancelClickHandler);
					MyPopupManager.addPopUp(winTopoLink, true); //创建连线后弹出复用段的属性信息面板
				}
				
				/**
				 *添加复用段成功后处理函数 
				 * @param event
				 * 
				 */
				private function afterAddTopolinkHandler(event:LinkParameterEvent):void
				{
					
					refreshSystems();
					
					
				}
				
				/**
				 * 取消添加复用段处理函数
				 * @param event
				 * 
				 */
				private function cancelClickHandler(event:Event):void
				{
					winTopoLink.removeEventListener("CloseWinTopoLink", cancelClickHandler);	
					if (linkID != null)
						dataBox.removeByID(linkID);
					MyPopupManager.removePopUp(winTopoLink);
				}
				
				
				/**
				 *对系统组织图中的network的双击事件的处理函数 
				 * @param e
				 * 
				 */
				private function doubleChickHandler(e:MouseEvent):void {
					
					if (systemorgmap1.selectionModel.count ==1) //如果当前选中的结点>0
					{
						//获取当前选中的结点
						var element:IElement=(Element)(systemorgmap1.selectionModel.lastData);
						if (element is Node) //判断选中的元素是不是结点
						{ //选中节点  
							
							var node:Node=element as Node;
							// Alert.show(""+node.id);
							Registry.register("systemcode", node.getClient("parent").toString());
							Registry.register("equipcode", node.getClient("code").toString());
							Application.application.openModel("设备面板图", false);
						}
						else if(element is Link)
						{
							
							var link:Link=element as Link;
							if(link.getStyle(Styles.LINK_BUNDLE_EXPANDED)==true)
							{
								Registry.register("label", link.getClient("code").toString());
								Registry.register("linerate", link.getClient("linerate").toString());
								Registry.register("systemcode", link.getClient("systemname").toString());
								Application.application.openModel("时隙分布图", false);
							}
							
						}
					}
					
					
				}						
				
				
				/**
				 *复用段时隙分布图右键事件 
				 * @param e
				 * 
				 */
				private function itemSelectHandler_TimeSlot(e:ContextMenuEvent):void
				{
					var link:Link=(Element)(systemorgmap1.selectionModel.lastData);
					Registry.register("label", link.getClient("code").toString());
					Registry.register("linerate", link.getClient("linerate").toString());
					Registry.register("systemcode", link.getClient("systemname").toString());
					Application.application.openModel(e.currentTarget.caption, false);
				}
				
				
				private function itemSelectHandler_LinkDel(e:ContextMenuEvent):void{
					var link:Link=(Element)(systemorgmap1.selectionModel.lastData);
					
					toplink=link.getClient("code").toString();
					if(toplink!=null&&toplink!=""){
						Alert.show("您确认要删除吗？","请您确认！",Alert.YES|Alert.NO,this,delLinkConfirmHandler,null,Alert.NO);
					}else{
						Alert.show("请先选择复用段！","提示");
					}
				}
				
				private function delLinkConfirmHandler(event:CloseEvent):void {
					if (event.detail == Alert.YES) {
						var remoteObject:RemoteObject=new RemoteObject("resNetDwr");
						remoteObject.endpoint = ModelLocator.END_POINT;
						remoteObject.showBusyCursor = true;
						//删除复用段
						remoteObject.delToplinkByID(toplink);
						remoteObject.addEventListener(ResultEvent.RESULT,delLinkResult);
						Application.application.faultEventHandler(remoteObject);
					}
				}
				
				public function delLinkResult(event:ResultEvent):void{
					if(event.result.toString()=="success")
					{
						Alert.show("删除成功！","提示");
						this.refreshTrees();
					}else
					{
						Alert.show("删除失败！","提示");
					}
				}
				
				/**
				 *复用段属性右键事件 
				 * @param e
				 * 
				 */
				private function itemSelectHandler_Ocable(e:ContextMenuEvent):void
				{
					
					
					var link:Link=(Element)(systemorgmap1.selectionModel.lastData);
					
					var topolinkid:String=link.getClient("code").toString();
					var labelname:String=link.getClient("labelname").toString();
					
					
					var property:ShowProperty = new ShowProperty();
					property.paraValue = topolinkid;
					property.tablename = "VIEW_ENTOPOLINKPROPERTY";
					property.key = "label";	
					labelname = labelname+"—复用段属性";
					property.toolTip = labelname;
					if(labelname.length>51){
						labelname = labelname.substring(0,51)+"......";
					}
					property.title = labelname;	
					PopUpManager.addPopUp(property, this, true);
					PopUpManager.centerPopUp(property);
					property.addEventListener("savePropertyComplete",function (event:Event):void{
						
						
						PopUpManager.removePopUp(property);
						
					});
					property.addEventListener("initFinished",function (event:Event):void{
						var rt:RemoteObject=new RemoteObject("resNodeDwr");
						rt.endpoint=ModelLocator.END_POINT;
						rt.showBusyCursor=true;
						rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent){
							if(event.result!=null){
								(property.getElementById("OTHERINFO",property.propertyList) as mx.controls.TextInput).editable = false;
								(property.getElementById("OTHERINFO",property.propertyList) as mx.controls.TextInput).text=event.result.toString();
								
							}
						});
						
						rt.getOpticalIdByToplinkid(topolinkid);
					});
				}
				
				
				
				private function onDragEnter(event:DragEvent):void
				{
					
					DragManager.acceptDragDrop(UIComponent(event.currentTarget));
				}
				
				
				private function onDragOver(event:DragEvent):void
				{
					
					
						if (event.ctrlKey)
							DragManager.showFeedback(DragManager.COPY);
						else if (event.shiftKey)
							DragManager.showFeedback(DragManager.LINK);
						else
						{
							DragManager.showFeedback(DragManager.MOVE);
						}
		
				}
				private function onGridDragDrop(event:DragEvent):void
				{
					var matchStr:String;
					var ds:DragSource=event.dragSource;
					var dropTarget:Network=Network(event.currentTarget);
					var node1:Node;
					var arrPicName:Array;
					var picName:String;
					var label:String;		
					var system:String;
					var x_model:String;
					var centerLocation:Point=systemorgmap1.getLogicalPoint(event as MouseEvent);;
					
				}
				
				
				// 添加设备信息 add by yangzhong   2013-8-14
				private function openAddEquipWin(vendorName:String, vendorCode:String, x_model:String,node:Node):void
				{
					
					/*addEquInfo=new AddEquInfo();
					addEquInfo.addEventListener("AfterAddEquip", addEquInfoHandler);
					addEquInfo.addEventListener(CloseEvent.CLOSE, closeEquipWinHandler);	
					MyPopupManager.addPopUp(addEquInfo, true);
					addEquInfo.setVendorAndModel(tree.selectedItem.@code,vendorCode,x_model);*/	
					
					
					var property:ShowProperty = new ShowProperty();
					property.title = "添加";
					property.paraValue = null;
					property.tablename = "EQUIPMENT_VIEW";
					property.key = "EQUIPCODE";
					PopUpManager.addPopUp(property, this, true);
					PopUpManager.centerPopUp(property);		
					property.addEventListener("savePropertyComplete",function (event:Event):void{
						PopUpManager.removePopUp(property);
						var equipode:String = property.insertKey;
						saveSysInfo(node,equipode);
					});
					property.addEventListener(CloseEvent.CLOSE, closeEquipWinHandler);
					property.addEventListener("initFinished",function (event:Event):void{
						(property.getElementById("STATIONNAME",property.propertyList) as mx.controls.TextInput).addEventListener(MouseEvent.CLICK,function(event:Object):void{
							var stations:enStationTree=new enStationTree();
							stations.page_parent=property;
							stations.textId="STATIONCODE";
							PopUpManager.addPopUp(stations, property, true);
							PopUpManager.centerPopUp(stations);  
						});
						
						(property.getElementById("STATIONNAME",property.propertyList) as mx.controls.TextInput).enabled = false;
						(property.getElementById("UPDATEPERSON",property.propertyList) as mx.controls.TextInput).enabled = false;
						(property.getElementById("UPDATEPERSON",property.propertyList) as mx.controls.TextInput).text = parentApplication.curUserName;
						(property.getElementById("UPDATEDATE",property.propertyList) as mx.controls.TextInput).enabled = false;
						(property.getElementById("UPDATEDATE",property.propertyList) as mx.controls.TextInput).text = getNowTime();
						(property.getElementById("SYSTEM_NAME",property.propertyList) as mx.controls.ComboBox).enabled = false;
						for(var i:int=0;i<(property.getElementById("SYSTEM_NAME",property.propertyList) as mx.controls.ComboBox).dataProvider.length;i++){
							if((property.getElementById("SYSTEM_NAME",property.propertyList) as mx.controls.ComboBox).dataProvider[i].@code == tree.selectedItem.@code){
								(property.getElementById("SYSTEM_NAME",property.propertyList) as mx.controls.ComboBox).selectedIndex = i;						
								break;
							}
						}
						(property.getElementById("X_VENDOR",property.propertyList) as mx.controls.ComboBox).enabled = false;
						for(var i:int=0;i<(property.getElementById("X_VENDOR",property.propertyList) as mx.controls.ComboBox).dataProvider.length;i++){
							if((property.getElementById("X_VENDOR",property.propertyList) as mx.controls.ComboBox).dataProvider[i].@code == vendorCode){
								(property.getElementById("X_VENDOR",property.propertyList) as mx.controls.ComboBox).selectedIndex = i;						
								break;
							}
						}
						
						(property.getElementById("X_MODEL",property.propertyList) as mx.controls.ComboBox).enabled = false;
						for(var i:int=0;i<(property.getElementById("X_MODEL",property.propertyList) as mx.controls.ComboBox).dataProvider.length;i++){
							if((property.getElementById("X_MODEL",property.propertyList) as mx.controls.ComboBox).dataProvider[i].@code == x_model){
								(property.getElementById("X_MODEL",property.propertyList) as mx.controls.ComboBox).selectedIndex = i;						
								break;
							}
						}
						
						
					});
					property.addEventListener("closeProperty",function (event:Event):void{
						dataBox.removeByID(nodeId);
						
					});
					
					
				}
				
				
				
				/**
				 * 获取当前时间
				 * add by yangzhong
				 * 2013-8-14
				 */
				protected function getNowTime():String{
					var dateFormatter:DateFormatter = new DateFormatter();
					dateFormatter.formatString = "YYYY-MM-DD JJ:NN:SS";
					var nowDate:String= dateFormatter.format(new Date());
					return nowDate;
				}
				
				private function closeEquipWinHandler(event:CloseEvent):void
				{
					addEquInfo.resetValue(); //清除添加面板里的值
					MyPopupManager.removePopUp(addEquInfo);
					dataBox.removeByID(nodeId);
					
				}
				
				
				private function onDragExit(event:DragEvent):void
				{
					var dropTarget:Network=Network(event.currentTarget);
					
				}
				
				
				private function enter():void
				{
					querychildren();				
				}

				
				private var xmlDeviceModel:XMLList=new XMLList();
				[Bindable]
				private var xmlListColl:XMLListCollection=new XMLListCollection();
		
				
				/**
				 *创建判定告警菜单的方法 
				 * @param e
				 * 
				 */
				private function AlarmHandler(e:ContextMenuEvent):void
				{
					
					tw =new TitleWindow();
					tw.layout="absolute";
					tw.x=0;tw.y=0;
					//获取屏幕分辩率
//					tw.width=Capabilities.screenResolutionX-50;
//					tw.height=Capabilities.screenResolutionY-250;
					tw.width=1280;
					tw.height=660;
					tw.styleName="popwindow";
					tw.showCloseButton=true;
					var node:Node=(Element)(systemorgmap1.selectionModel.lastData);
					if(e.currentTarget.caption == "查看当前根告警"){
						
						tw.title="当前根告警";
						var historyRootAlarm:HisRootAlarm=new HisRootAlarm();
						historyRootAlarm.myflag=2;
						historyRootAlarm.belongequip=node.getClient("code").toString();
						tw.addEventListener(CloseEvent.CLOSE,twcolse);
						tw.addChild(historyRootAlarm);
						PopUpManager.addPopUp(tw,main(Application.application),true);
						PopUpManager.centerPopUp(tw);						
						//						tw.title="当前根告警";
						//						var currentRootAlarm:RootAlarmMgr=new RootAlarmMgr();
						//						currentRootAlarm.belongequip=node.getClient("code").toString();
						//						currentRootAlarm.currentGrid="currentrootalarm";
						//						currentRootAlarm.flag = 1;
						//						tw.addEventListener(CloseEvent.CLOSE,twcolse);
						//						tw.addChild(currentRootAlarm);
						//						PopUpManager.addPopUp(tw,main(Application.application),true);
						//						PopUpManager.centerPopUp(tw);
						
					}
					
					if(e.currentTarget.caption == "查看历史根告警"){
						
						tw.title="历史根告警";
						var historyRootAlarm:HisRootAlarm=new HisRootAlarm();
						historyRootAlarm.myflag=3;
						historyRootAlarm.belongequip=node.getClient("code").toString();
						tw.addEventListener(CloseEvent.CLOSE,twcolse);
						tw.addChild(historyRootAlarm);
						PopUpManager.addPopUp(tw,main(Application.application),true);
						PopUpManager.centerPopUp(tw);
					}
					if(e.currentTarget.caption == "查看当前告警"){
						
						tw.title="告警查询";
						var currentOriginalAlarm:AlarmManager=new AlarmManager();
						currentOriginalAlarm.belongequip=node.getClient("code").toString();
						currentOriginalAlarm.flag = 1;
						currentOriginalAlarm.iscleared="0";
						tw.addEventListener(CloseEvent.CLOSE,twcolse);
						tw.addChild(currentOriginalAlarm);
						PopUpManager.addPopUp(tw,main(Application.application),true);
						PopUpManager.centerPopUp(tw);
						
					}
					if(e.currentTarget.caption == "查看告警"){
						tw.title="告警查询";
						var historyOriginalAlarm:AlarmManager=new AlarmManager();
						historyOriginalAlarm.flag = 1;
						historyOriginalAlarm.belongequip=node.getClient("code").toString();
						historyOriginalAlarm.iscleared="1";
						tw.addEventListener(CloseEvent.CLOSE,twcolse);
						tw.addChild(historyOriginalAlarm);
						PopUpManager.addPopUp(tw,main(Application.application),true);
						PopUpManager.centerPopUp(tw);
					}
				}
				
				/**
				 *关闭配置时隙窗体处理函数 
				 * @param evt
				 * 
				 */
				private function twcolse(evt:CloseEvent):void
				{
					PopUpManager.removePopUp(tw);
				}
				
				
				
				
				
				private function deleteEquipHandler(e:ContextMenuEvent):void
				{
					var element:Element;
					element=(Element)(systemorgmap1.selectionModel.lastData);
					if(element is Node)
					{
						Alert.show("确认将该设备从系统中移出?", "移出系统",3,this,deleteEquipReSys);
					}
				}
				/**
				 *删除network中的元素 
				 * @param event
				 * 
				 */
				private function sysNetwork_keyDownHandler(event:KeyboardEvent):void
				{
					if(systemorgmap1.selectionModel.count==1)
						var element:* = systemorgmap1.selectionModel.selection.getItemAt(0);
					if(event.keyCode == Keyboard.DELETE)
					{
						if(element is Link)
						{
						}
						else if(element is Node)
						{
							Alert.show("确认将该设备从系统中移出?", "移出系统",3,this,deleteEquipReSys);
						}
						
					}	
				}
				/**
				 *删除设备与当前系统的关联关系 
				 * @param event
				 * 
				 */
				private function deleteEquipReSys(event:CloseEvent):void
				{
					if(event.detail == Alert.YES) 
					{ 
						var node:Node=(Element)(systemorgmap1.selectionModel.lastData);
						var systemcode:String=node.getClient("parent").toString();
						var equipcode:String=node.getClient("code").toString();
						var roDeleteEquip:RemoteObject=new RemoteObject("fiberWire");
						roDeleteEquip.endpoint=ModelLocator.END_POINT;
						roDeleteEquip.showBusyCursor=true;
						roDeleteEquip.addEventListener(ResultEvent.RESULT, function(e:ResultEvent):void
						{
							var node:Node=(Element)(systemorgmap1.selectionModel.lastData);
							dataBox.remove(node);
						});
						parentApplication.faultEventHandler(roDeleteEquip);
						roDeleteEquip.deleteEquipReSys(equipcode,systemcode);
						
						
					} 
				}
				/**
				 *创建checkbox 
				 * @param name
				 * @param changeHandler
				 * @return 
				 * 
				 */
				
				//设置选中呈现告警
				public function setAlarmShow():void{
					alarm_all=true;
					var str:int = 1;
					for each(var item:* in toolbar.getChildren())
					{

					}
				}
				
				private function changeSelect(flag:String):void
				{
					if(springLaouter!=null){
						springLaouter.stop();
					}
					for each(var item:* in toolbar.getChildren())
					{
//						if(item is CheckBox&& item.label!='呈现所有告警'&&item.label!=flag)
//						{		
//							CheckBox(item).selected=false;
//						}	
					}
				}
				
				/**
				 *当双击左侧系统树中的设备时在network中选中它 
				 * @param event
				 * 
				 */
				private function tree_doubleClickHandler(event:MouseEvent):void
				{
					
				}
				
				public  function route(asa:String):void
				{
					Alert.show("into route");
					//systemorgmap1.elementBox.selectionModel.clearSelection();
					var str:String = asa;	
					var arr:Array = str.split("-->");
					/* 				for(var i:int=0; i<arr.length; i++)
					{
					Alert.show(arr[i].toString());
					} */
					
					for(var i:int=0; i<arr.length; i++){
						var equip_node:Node=dataBox.getDataByID((arr[i]).toString()) as Node;
						//Alert.show(equip_node.toString());
						if(equip_node!=null)
						{
							systemorgmap1.selectionModel.appendSelection(equip_node);	
							equip_node.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
							//值设为0，清除黄色背景框 xgyin
							equip_node.setStyle(Styles.VECTOR_FILL_ALPHA, 0);
							equip_node.setStyle(Styles.VECTOR_FILL_COLOR, 0xFF6600);
							systemorgmap1.centerByLogicalPoint(equip_node.centerLocation.x,equip_node.centerLocation.y);
						}
						
						
					}
					
					for(var i:int=arr.length; i>0; i--){
						
						systemorgmap1.elementBox.forEach(function(element:IElement):void
						{	
							if(element is Link)
							{
								
								var link:Link=element as Link;
								if(link.toNode.id.toString()==arr[i-1]&&link.fromNode.id.toString()==arr[i]){
									
									link.setStyle(Styles.SELECT_COLOR,"0xFF6600");
									link.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
									link.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
									link.setStyle(Styles.VECTOR_FILL_COLOR, 0x7697C9);
									systemorgmap1.elementBox.selectionModel.appendSelection(link);//显示不完全 有问题 mawj
								}
								if(link.toNode.id.toString()==arr[i]&&link.fromNode.id.toString()==arr[i-1]){
									
									link.setStyle(Styles.SELECT_COLOR,"0xFF6600");
									
									link.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
									link.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
									link.setStyle(Styles.VECTOR_FILL_COLOR, 0x7697C9);
									systemorgmap1.elementBox.selectionModel.appendSelection(link);//显示不完全 有问题 mawj
								}
								
							}		
							
						});
					}
					
					for(var i:int=0; i<arr.length-1; i++){					
						systemorgmap1.elementBox.forEach(function(element:IElement):void
						{	
							if(element is Link)
							{								
								var link:Link=element as Link;
								if(link.toNode.id.toString()==arr[i+1]&&link.fromNode.id.toString()==arr[i]){
									
									link.setStyle(Styles.SELECT_COLOR,"0xFF6600");
									link.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
									link.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
									link.setStyle(Styles.VECTOR_FILL_COLOR, 0x7697C9);
									systemorgmap1.elementBox.selectionModel.appendSelection(link);//显示不完全 有问题 mawj
								}
								if(link.toNode.id.toString()==arr[i]&&link.fromNode.id.toString()==arr[i+1]){									
									link.setStyle(Styles.SELECT_COLOR,"0xFF6600");									
									link.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
									link.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
									link.setStyle(Styles.VECTOR_FILL_COLOR, 0x7697C9);
									systemorgmap1.elementBox.selectionModel.appendSelection(link);//显示不完全 有问题 mawj
								}								
							}									
						});
					}
				}
				
				/**
				 *搜索框点击处理函数 
				 * @param event
				 * 
				 */

				

				
				private function searchText_clickHandler(event:Event):void
				{
					querychildren();
				}
				
				//树的搜索功能
				private function querychildren():void
				{
					if(!tree_selectedNode)
					{
						Alert.show("请选择！");
						return;
					}
					if(StringUtil.trim(searchText.txt.text)!=null&&StringUtil.trim(searchText.txt.text)!="")
					{
						var typexml:Boolean = false;
						for each(var xml:XML in XMLData.children())
						{
							if(xml.@code == tree_selectedNode.@code)
							{
								for each(var x:XML in tree_selectedNode.children())
								{
									
									if(x.@name.indexOf( searchText.txt.text)>-1)
									{
										tree.selectedItem = x;
										tree.scrollToIndex(tree.getItemIndex(x));
										typexml = true;
										var item:Object=x;
										if(item!=null)
										{
											var equip_node:Node=dataBox.getDataByID((item.@code).toString()) as Node;
											if(equip_node!=null)
											{
												//systemorgmap1.selectionModel.clearSelection();
												systemorgmap1.selectionModel.appendSelection(equip_node);
												equip_node.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
												equip_node.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
												equip_node.setStyle(Styles.VECTOR_FILL_COLOR, 0x7697C9);
												systemorgmap1.centerByLogicalPoint(equip_node.centerLocation.x,equip_node.centerLocation.y);
											}
										}													
										break;	
									}
									
								}//第一层循环
								
								break;
							}											
						}
					}	
					
					if(!typexml)
					{
						Alert.show("在当前展开的系统中不存在该设备！","提示");
					}						
					
				}
				
				
				protected function getlink(id1:String, id2:String){
					var linkid:String="";
					systemorgmap1.elementBox.forEach(function(element:IElement):void
					{
						if(element is Link)
						{
							var link:Link=element as Link;
							
							if((link.fromNode.id.toString() == id1 && link.toNode.id.toString() == id2)||(link.fromNode.id.toString() == id2 && link.toNode.id.toString() == id1)){
								linkid=link.id.toString();
							}
						}
					});
					return linkid;
				}
				protected function getlinks(id1:String, id2:String){
					var linkid:String="";
					systemorgmap1.elementBox.forEach(function(element:IElement):void
					{
						if(element is Link)
							{
							var link:Link=element as Link;
							
							if((link.fromNode.id.toString() == id1 && link.toNode.id.toString() == id2)||(link.fromNode.id.toString() == id2 && link.toNode.id.toString() == id1)){
							linkid=linkid+link.id.toString()+";";
							}
						}
					});
					
					return linkid.substring(0,linkid.length-1);
				}

			/**
			 * 添加设备保存
			 */
			  private function saveSysInfo(node:Node,equipcode:String):void
			  {
				  
						  var parent_x:int=0;
						  var parent_y:int=0;
						  var array:ArrayCollection=new ArrayCollection();
						  var sys_node:Node=node;
						  var equipinfo:EquInfo=new EquInfo();						
							equipinfo.equipcode=equipcode;
							 equipinfo.equipname=sys_node.name;
							 equipinfo.x=sys_node.centerLocation.x.toString();
							equipinfo.y=sys_node.centerLocation.y.toString();
							equipinfo.systemcode=sys_node.getClient("parent");							
						  array.addItem(equipinfo);
					
					  var rtobj1:RemoteObject=new RemoteObject("fiberWire");
					  rtobj1.endpoint=ModelLocator.END_POINT;
					  rtobj1.showBusyCursor=true;
					  rtobj1.SaveSysOrgMap(array);
					  rtobj1.addEventListener(ResultEvent.RESULT, afterSaveSysOrgMapInfo);
				 
			  }
			/**
			 *添加设备保存系统组织图后的处理 
			 * @param e
			 * 
			 */
			private function afterSaveSysOrgMapInfo(e:ResultEvent):void 
			{
				refreshSystems();
				
			}
			
			public  function mainroute(asa:String):void
			{    
				//#96CDCD  主
				//#9932CC  备用
				//#A0522D  迂回
				clear_arr=  asa.split("-->");	
				var arr:Array = asa.split("-->");				
				for(var i:int=0; i<arr.length; i++){
					var equip_node:Node=dataBox.getDataByID((arr[i]).toString()) as Node;
					//Alert.show(equip_node.toString());
					if(equip_node!=null)
					{
						
						systemorgmap1.selectionModel.appendSelection(equip_node);
						
						equip_node.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
						//值设为0，清除黄色背景框 xgyin
						equip_node.setStyle(Styles.VECTOR_FILL_ALPHA, 0);
						equip_node.setStyle(Styles.VECTOR_FILL_COLOR, 0xee1111);
						systemorgmap1.centerByLogicalPoint(equip_node.centerLocation.x,equip_node.centerLocation.y);
					}														
				}		for(var i:int=arr.length; i>0; i--){
					
					systemorgmap1.elementBox.forEach(function(element:IElement):void
					{	
						if(element is Link)
						{
							
							var link:Link=element as Link;
							if(link.toNode.id.toString()==arr[i-1]&&link.fromNode.id.toString()==arr[i]){
								
								link.setStyle(Styles.SELECT_COLOR,"0x96CDCD");
								link.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
								link.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
								link.setStyle(Styles.VECTOR_FILL_COLOR, 0x96CDCD);
								systemorgmap1.elementBox.selectionModel.appendSelection(link);//显示不完全 有问题 mawj
								//systemorgmap1.elementBox.selectionModel.clearSelection();
							}
							if(link.toNode.id.toString()==arr[i]&&link.fromNode.id.toString()==arr[i-1]){
								
								link.setStyle(Styles.SELECT_COLOR,"0x96CDCD");
								
								link.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
								link.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
								link.setStyle(Styles.VECTOR_FILL_COLOR,0x96CDCD);
								systemorgmap1.elementBox.selectionModel.appendSelection(link);//显示不完全 有问题 mawj
							}
							
						}		
						
					});
				}
				
				for(var i:int=0; i<arr.length-1; i++){
					
					systemorgmap1.elementBox.forEach(function(element:IElement):void
					{	
						if(element is Link)
						{
							
							var link:Link=element as Link;
							if(link.toNode.id.toString()==arr[i+1]&&link.fromNode.id.toString()==arr[i]){
								
								link.setStyle(Styles.SELECT_COLOR,"0x96CDCD");
								link.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
								link.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
								link.setStyle(Styles.VECTOR_FILL_COLOR, 0x96CDCD);
								systemorgmap1.elementBox.selectionModel.appendSelection(link);//显示不完全 有问题 mawj
							}
							if(link.toNode.id.toString()==arr[i]&&link.fromNode.id.toString()==arr[i+1]){
								
								link.setStyle(Styles.SELECT_COLOR,"0x96CDCD");
								
								link.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
								link.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
								link.setStyle(Styles.VECTOR_FILL_COLOR, 0x96CDCD);
								systemorgmap1.elementBox.selectionModel.appendSelection(link);//显示不完全 有问题 mawj
							
							}
							
						}		
						
					});
				}														
			}
			
			public  function backuproute(asa:String):void
			{
				// 黄色 #0x008000    备用
				//绿色  #0xee1111    主用
				//蓝色  #0xFFFF00      迂回
				var arr:Array = asa.split("-->");				
				for(var i:int=0; i<arr.length; i++){
					var equip_node:Node=dataBox.getDataByID((arr[i]).toString()) as Node;
					//Alert.show(equip_node.toString());
					if(equip_node!=null)
					{
						
						systemorgmap1.selectionModel.appendSelection(equip_node);
						
						equip_node.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
						//值设为0，清除黄色背景框 xgyin
						equip_node.setStyle(Styles.VECTOR_FILL_ALPHA, 0);
						equip_node.setStyle(Styles.VECTOR_FILL_COLOR, 0x008000);
						systemorgmap1.centerByLogicalPoint(equip_node.centerLocation.x,equip_node.centerLocation.y);
					}														
				}		for(var i:int=arr.length; i>0; i--){
					
					systemorgmap1.elementBox.forEach(function(element:IElement):void
					{	
						if(element is Link)
						{
							
							var link:Link=element as Link;
							if(link.toNode.id.toString()==arr[i-1]&&link.fromNode.id.toString()==arr[i]){
								
								link.setStyle(Styles.SELECT_COLOR,"0x9932CC");
								link.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
								link.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
								link.setStyle(Styles.VECTOR_FILL_COLOR, 0x9932CC);
								systemorgmap1.elementBox.selectionModel.appendSelection(link);//显示不完全 有问题 mawj
							}
							if(link.toNode.id.toString()==arr[i]&&link.fromNode.id.toString()==arr[i-1]){
								
								link.setStyle(Styles.SELECT_COLOR,"0x9932CC");
								
								link.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
								link.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
								link.setStyle(Styles.VECTOR_FILL_COLOR, 0x9932CC);
								systemorgmap1.elementBox.selectionModel.appendSelection(link);//显示不完全 有问题 mawj
							}
							
						}		
						
					});
				}
				
				for(var i:int=0; i<arr.length-1; i++){
					
					systemorgmap1.elementBox.forEach(function(element:IElement):void
					{	
						if(element is Link)
						{
							
							var link:Link=element as Link;
							if(link.toNode.id.toString()==arr[i+1]&&link.fromNode.id.toString()==arr[i]){
								
								link.setStyle(Styles.SELECT_COLOR,"0x9932CC");
								link.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
								link.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
								link.setStyle(Styles.VECTOR_FILL_COLOR, 0x9932CC);
								systemorgmap1.elementBox.selectionModel.appendSelection(link);//显示不完全 有问题 mawj
							}
							if(link.toNode.id.toString()==arr[i]&&link.fromNode.id.toString()==arr[i+1]){
								
								link.setStyle(Styles.SELECT_COLOR,"0x9932CC");
								
								link.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
								link.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
								link.setStyle(Styles.VECTOR_FILL_COLOR, 0x9932CC);
								systemorgmap1.elementBox.selectionModel.appendSelection(link);//显示不完全 有问题 mawj
							}										
						}											
					});
				}																			
			}
			public  function bypassroute(asa:String):void
			{
				// 黄色 #FFD700     备用
				//绿色  #66CD00     主用
				//蓝色  #0000FF       迂回
				var arr:Array = asa.split("-->");				
				for(var i:int=0; i<arr.length; i++){
					var equip_node:Node=dataBox.getDataByID((arr[i]).toString()) as Node;
					//Alert.show(equip_node.toString());
					if(equip_node!=null)
					{
						
						systemorgmap1.selectionModel.appendSelection(equip_node);
						
						equip_node.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
						//值设为0，清除黄色背景框 xgyin
						equip_node.setStyle(Styles.VECTOR_FILL_ALPHA, 0);
						equip_node.setStyle(Styles.VECTOR_FILL_COLOR, 0xFFFF00);
						systemorgmap1.centerByLogicalPoint(equip_node.centerLocation.x,equip_node.centerLocation.y);
					}														
				}		for(var i:int=arr.length; i>0; i--){
					
					systemorgmap1.elementBox.forEach(function(element:IElement):void
					{	
						if(element is Link)
						{
							
							var link:Link=element as Link;
							if(link.toNode.id.toString()==arr[i-1]&&link.fromNode.id.toString()==arr[i]){
								
								link.setStyle(Styles.SELECT_COLOR,"0xA0522D");
								link.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
								link.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
								link.setStyle(Styles.VECTOR_FILL_COLOR, 0xA0522D);
								systemorgmap1.elementBox.selectionModel.appendSelection(link);//显示不完全 有问题 mawj
							}
							if(link.toNode.id.toString()==arr[i]&&link.fromNode.id.toString()==arr[i-1]){
								
								link.setStyle(Styles.SELECT_COLOR,"0xA0522D");
								
								link.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
								link.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
								link.setStyle(Styles.VECTOR_FILL_COLOR, 0xA0522D);
								systemorgmap1.elementBox.selectionModel.appendSelection(link);//显示不完全 有问题 mawj
							}
							
						}		
						
					});
				}
				
				for(var i:int=0; i<arr.length-1; i++){
					
					systemorgmap1.elementBox.forEach(function(element:IElement):void
					{	
						if(element is Link)
						{
							
							var link:Link=element as Link;
							if(link.toNode.id.toString()==arr[i+1]&&link.fromNode.id.toString()==arr[i]){
								
								link.setStyle(Styles.SELECT_COLOR,"0xA0522D");
								link.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
								link.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
								link.setStyle(Styles.VECTOR_FILL_COLOR, 0xA0522D);
								systemorgmap1.elementBox.selectionModel.appendSelection(link);//显示不完全 有问题 mawj
							}
							if(link.toNode.id.toString()==arr[i]&&link.fromNode.id.toString()==arr[i+1]){
								
								link.setStyle(Styles.SELECT_COLOR,"0xA0522D");
								
								link.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
								link.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
								link.setStyle(Styles.VECTOR_FILL_COLOR, 0xA0522D);
								systemorgmap1.elementBox.selectionModel.appendSelection(link);//显示不完全 有问题 mawj
							}										
						}											
					});
				}																			
			}
			
			//liao
			protected function setBusiness():void
			{	
				systemorgmap1.elementBox.selectionModel.clearSelection();
				busGrids.width=0;
				busGrids.height=0;
				busGrid.width=0;
				busGrid.height=0;
				cB.width=0;
				cB.height=0;				
				busGrids.visible=false;
				busGrid.visible=false;	
				cB.visible = false;
			     createb = new createbusiness();
				createb.title = "增加业务信息";
				createb.mainApp=this;
				createb.callbackFunction=this.refreshtree;
				MyPopupManager.addPopUp(createb,true);    
				
			}
			
			
			protected  function refreshtree():void
			{ 	tree.expandItem(tree_selectedNode, false);
				tree_selectedNode.insertChildBefore(tree_selectedNode.system[0],new XML(Shareds.str_new));								
				tree.expandItem(tree_selectedNode, true);				
			}
			
			protected function createBusiness(event:MouseEvent):void
			{      
				systemorgmap1.elementBox.selectionModel.clearSelection();
				busGrids.width=1155;
				busGrids.height=96;
				busGrid.width=0;
				busGrid.height=0;
				cB.width=1155;
				cB.height=50;				
				busGrids.visible=true;
				busGrid.visible=false;	
				cB.visible = true;
				/*	BUSINESS_NAME.visible=true;
				PA.visible=true;
				PB.visible=true;
				BUSINESS_RATE.visible=true;
				BUSINESS_TYPE_ID.visible=true;
				ID.visible=false;
				strategy.visible=false;
				B_route.visible=false;*/
				Alert.show("请选择一条业务！");
			
			}
			
			
			protected function btoncancle_click(event:MouseEvent):void
			{   
				systemorgmap1.elementBox.selectionModel.clearSelection();
				busGrid.width=0;
				busGrid.height=0;
				busGrids.width=0;
				busGrids.height=0;
				cB.width=0;
				cB.height=0;
				busGrids.visible=false;
				busGrid.visible=false;
			    cB.visible = false;
			    myData.removeAll();
			   abc_route.removeAll();
			ServDownList.selectedItem=null;
			}
			
			protected function btonConfirm_click(event:MouseEvent):void
			{  			
				systemorgmap1.elementBox.selectionModel.clearSelection();
				 abc_route.removeAll();
				busGrids.visible=false;
				busGrid.visible=true;
				cB.visible = true;
				busGrids.width=0;
				busGrids.height=0;
				busGrid.width=1155;
				busGrid.height=96;				
				cB.width=1155;
				cB.height=50;					
				var  fla:Boolean = false;
			    var   numid:int =0;
				for(var i:int=0;i<createbusiness.group.length;i++)
				{
					if(tree.selectedItem.@name==createbusiness.group.getItemAt(i).name.toString())
					{    fla=true;
						numid=i;
						break;
					}
				}
				if(ServDownList.selectedIndex==3||ServDownList.selectedIndex==1)
				{   
					B_stress.visible=false;
					B_stress.headerText="关键业务个数";			
				}
				if(ServDownList.selectedIndex==2||ServDownList.selectedIndex==0)
				{  
					
					ID.width=50;
					strategy.width=90;
					B_route.width=800;
					B_delay.width=90;
					chdelay.width=90;
					B_stress.visible=true;
					B_stress.width=90;
					B_stress.headerText="路由压力指数";
					
				}		            
				if(fla==true)
				{    //abc_route.removeAll();
					var ro:RemoteObject = new RemoteObject("topolink");
					ro.endpoint = ModelLocator.END_POINT;
					ro.showBusyCursor = true;
					ro.addEventListener(ResultEvent.RESULT,getConditon);
					ro.birthroutes(createbusiness.group.getItemAt(numid).name.toString(),createbusiness.group.getItemAt(numid).start.toString(),createbusiness.group.getItemAt(numid).end.toString(),ServDownList.selectedIndex);  		
				}
				if(fla==false)
				{  
					//abc_route.removeAll();
					var  treedi:XML =  tree.selectedItem as XML;
					var treename:String=treedi.@name;   //转成字符串形式
					var ro:RemoteObject = new RemoteObject("topolink");
					ro.endpoint = ModelLocator.END_POINT;
					ro.showBusyCursor = true;
					ro.addEventListener(ResultEvent.RESULT,getConditons);	
					ro.birthroutess(treename,myData.getItemAt(0).PA.toString(),myData.getItemAt(0).PB.toString(),ServDownList.selectedIndex);  	
					 
				/*	myData = new ArrayCollection({BUSINESS_NAME:treename,PA:"ewef",PB:"feee",BUSINESS_RATE:"w45",BUSINESS_TYPE_ID:"efweff"});*/
					
				}	
		
			}	
			
			//getConditon1
			private function getConditonqs(event:ResultEvent):void
			{
			}
		private function getConditon1(event:ResultEvent):void
			{
			Shareds.stationdata  =event.result as ArrayCollection;
		}
			private function getConditonas(event:ResultEvent):void
			{
				myData=event.result as ArrayCollection;
			}
			private function getConditons(event:ResultEvent):void{

				abc_route=event.result as ArrayCollection;
				
				if(abc_route.length>0){
					if(abc_route.getItemAt(0).code.toString()!=""){
						mainroute(abc_route.getItemAt(0).code.toString());        
					}
					if(abc_route.getItemAt(1).code.toString()!=""){
						backuproute(abc_route.getItemAt(1).code.toString());        //这里还可以加 一个判断
					}
					if(abc_route.getItemAt(2).code.toString()!=""){
						bypassroute(abc_route.getItemAt(2).code.toString());
					} 
					
				}
				
				
			}
			private function getConditonsr(event:ResultEvent):void{
			}

			private function getConditon(event:ResultEvent):void{
				
				abc_route=event.result as ArrayCollection;
				if(abc_route.length>0){
					if(abc_route.getItemAt(0).code.toString()!=""){
						mainroute(abc_route.getItemAt(0).code.toString());        
					}
					if(abc_route.getItemAt(1).code.toString()!=""){
						backuproute(abc_route.getItemAt(1).code.toString());        //这里还可以加 一个判断
					}
					if(abc_route.getItemAt(2).code.toString()!=""){
						bypassroute(abc_route.getItemAt(2).code.toString());
					} 
					
				}
			}
	
			private function lfRowNum1_1(oItem:Object,iCol:int):String    
			{   
				var iIndex:int = busGrid.dataProvider.getItemIndex(oItem) + 1; 				
				return String(iIndex);     
			}
			
			protected function ServDownList_closeHandler(event:MouseEvent):void{
				//if(myData.length==0){
				
				//Alert.show(tree.selectedItem.@name.toString());cb
				if(this.tree.selectedItem.@type==null||this.tree.selectedItem.@type!="business"){
					var aAlert:Alert=Alert.show("请先选择要生成路由的业务！");
					PopUpManager.centerPopUp(aAlert);
					ServDownList.selectedItem = null;				
				}
			}
			protected function itemListClickHander(event:MouseEvent):void
			{    
				if(ServDownList.selectedIndex==2)
				{
					Shareds.alla=true;
				Shareds.sews=busGrid.selectedItem.name.toString();	
				var rojs:RemoteObject = new RemoteObject("topolink");
				rojs.endpoint = ModelLocator.END_POINT;
				rojs.showBusyCursor = true;
				rojs.addEventListener(ResultEvent.RESULT,ResultGetDevInfojs);
				rojs.chuan(busGrid.selectedItem.name.toString(),busGrid.selectedItem.route.toString(),ServDownList.selectedIndex);  
				
				pressure =new DetailPressures();
				MyPopupManager.addPopUp(pressure,true);
				}
				if(ServDownList.selectedIndex==3)
				{
					Shareds.alla=false;
					Shareds.sews=busGrid.selectedItem.name.toString();	
					var rojs:RemoteObject = new RemoteObject("topolink");
					rojs.endpoint = ModelLocator.END_POINT;
					rojs.showBusyCursor = true;
					rojs.addEventListener(ResultEvent.RESULT,ResultGetDevInfojs);
					rojs.chuan(busGrid.selectedItem.name.toString(),busGrid.selectedItem.route.toString(),ServDownList.selectedIndex);  
					
					pressure =new DetailPressures();
					MyPopupManager.addPopUp(pressure,true);
				}
			}
			private function ResultGetDevInfojs(event:ResultEvent):void
			{
				DetailPressures.equipInfojs=event.result as ArrayCollection;	
				
			}
			protected function word_clickHandler(event:MouseEvent):void
			{
				
				systemorgmap1.elementBox.selectionModel.clearSelection();
			/*	var roos:RemoteObject = new RemoteObject("outword");
				roos.endpoint = ModelLocator.END_POINT;
				roos.showBusyCursor = true;
				roos.addEventListener(ResultEvent.RESULT,getConditonsr);	
				roos.word();  	*/
			}
			