import VButtonEvents.selectedItemEvent;

import com.adobe.serialization.json.JSON;

import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.actionscript.Registry;
import common.component.TopMenuBar;
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

import flexunit.utils.ArrayList;

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
import mx.controls.Text;
import mx.controls.TextArea;
import mx.core.Application;
import mx.core.DragSource;
import mx.core.UIComponent;
import mx.effects.Effect;
import mx.events.CloseEvent;
import mx.events.DragEvent;
import mx.events.FlexEvent;
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
import sourceCode.alarmmgrGraph.views.currentOrHistoryOriginalAlarmView;
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
import sourceCode.sysGraph.actionscript.Effect_util;
import sourceCode.sysGraph.actionscript.Risk_Operation;
import sourceCode.sysGraph.actionscript.RouteMethod;
import sourceCode.sysGraph.actionscript.Shared;
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
import sourceCode.sysGraph.views.SysOrgMap;
import sourceCode.sysGraph.views.WinTopoLink;
import sourceCode.sysGraph.views.configSlot;
import sourceCode.systemManagement.model.PermissionControlModel;

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
import twaver.LinkSubNetwork;
import twaver.Node;
import twaver.SerializationSettings;
import twaver.Size;
import twaver.Styles;
import twaver.Utils;
import twaver.XMLSerializer;
import twaver.network.layout.AutoLayouter;
import twaver.network.layout.SpringLayouter;

[Bindable]
/**
 *左侧树的数据源 
 */
public var countTree:int=0;
public var XMLData:XMLList;
[Bindable]
public var a:ArrayCollection=new ArrayCollection();
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
private var singleK_Analysis:ArrayCollection=new ArrayCollection();//带悬挂点的关键点

/**
 *保存系统组织图右侧的传输设备树的数据源 
 */
public var DeviceXML:XMLList; 
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
private var sfsf:String;
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
/**
 *表示设备的设备编号
 */
private var nameid:String="";
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
private  var length:Array=new Array() ;
private  var path:Array=new Array() ; 				
private	 var nodea:int;
private	 var nodeb:int;
public static var network_diameter:int=0;
public static var d:int=0;
private  var MAX:int = 2147483647;
private  var row:int ;
private  var spot:Array=new Array() ;
private   var onePath:Array=new Array() ;	
private  var point:int;
public   var longpath:Array=new Array() ;
public   var idlongpath:Array=new Array() ;
public   var longpath_num:int;
public  var from:Array=new Array() ; 
public  var to:Array=new Array() ; 
public  var allspot:Array=new Array();
public  var spot_num:int;
public  var real_pathnum:int;
private  var node_name:Array=new Array();
private  var node_id:Array=new Array();


[Embed(source='assets/images/toolbar/equipment.png')]
[Bindable]
private var cs:Class;
[Embed(source='assets/images/toolbar/equipmodel.png')]
[Bindable]
private var sb:Class;
[Embed(source='assets/images/toolbar/topolink.png')]
[Bindable]
private var fy:Class;

//表格双击事件
public static  var doubleFlag:Boolean=false;

public function genrowno(ob:Object):String {  
	return String(dataGrid1.dataProvider.getItemIndex(ob)+1);  
}

public function b1_creationCompleteHandler (event:FlexEvent):void
{
	
	stage.scaleMode=StageScaleMode.NO_SCALE;
	stage.align=StageAlign.TOP_LEFT;
	stage.addEventListener(Event.RESIZE,onResize);
}
public function onResize (e:Event):void{
	var flag:Boolean=TopMenuBar.fullScreenFlag;
	
	
	//如果不是全屏，且双击左侧表格或者单击网元,且未双击设备
	if(!flag&& doubleFlag){
		vb.height=cvs.height;
		acc.height=vb.height;
	}
		//如果全屏并且双击左侧表格或者单击网元
	else if(flag&&doubleFlag){
		vb.height=this.stage.stageHeight* 0.58;
		acc.height=vb.height;
		
	}
	
}

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

public var mouse_x:Number=0.0;
public var mouse_y:Number=0.0;
private var tplink:Array=new Array();

[Bindable]
public var arrayCollection:ArrayCollection=new ArrayCollection();

[Bindable] 
private var ac:ArrayCollection = new ArrayCollection([
	{label:'设备模板',icon:sb},
	{label:'复用段',icon:fy},
	{label:'搜索',icon:cs},
	{label:'分析',icon:sb}]);	
[Bindable]
private var arr_cb:ArrayCollection=new ArrayCollection([
	{label:'--网络分析--'},
	{label:'成环率分析'},
	{label:'网络直径分析'},
	{label:'网络关键点分析'}]);
[Bindable]
private var  arr_Analysis:ArrayCollection=new ArrayCollection([
	{label:'--利用率分析--'},
	{label:'VC12穿通通道利用率分析'},
	{label:'VC4穿通通道利用率分析'},
	{label:'VC3穿通通道利用率分析'},
]);
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

[Bindable]
private var equipInfo_1:ArrayCollection = new ArrayCollection();	
[Bindable]
private var equipPortDetail_1:ArrayCollection = new ArrayCollection();	 
//返回行号
private function lfRowNum_1(oItem:Object,iCol:int):String    
{   
	var iIndex:int = dgEquip_1.dataProvider.getItemIndex(oItem) + 1; 				
	return String(iIndex);     
} 
//返回行号1 表2
private function lfRowNum1_1(oItem:Object,iCol:int):String    
{   
	var iIndex:int = dgEquipInfo_1.dataProvider.getItemIndex(oItem) + 1; 				
	return String(iIndex);     
}





[Bindable]
private var equipInfo:ArrayCollection = new ArrayCollection();	
[Bindable]
private var equipPortDetail:ArrayCollection = new ArrayCollection();	 	
private function lfRowNum(oItem:Object,iCol:int):String    
{   
	var iIndex:int = dgEquip.dataProvider.getItemIndex(oItem) + 1; 				
	return String(iIndex);     
} 
//返回行号1 表2
private function lfRowNum1(oItem:Object,iCol:int):String    
{   
	var iIndex:int = dgEquipInfo.dataProvider.getItemIndex(oItem) + 1; 				
	return String(iIndex);     
}  



private function itemListClickHander(event:MouseEvent):void
{  //dbl
	//dbl
	equipPortDetail=null;
	doubleFlag=true;
	var flag:Boolean=TopMenuBar.fullScreenFlag;
	if(!flag)
	{			
		
		vb.height=this.stage.stageHeight* 0.58;
		acc.height=vb.height;
	}
	
	nameid="";
	dgEquipInfo.visible=true; dgEquipInfo.width=980; dgEquipInfo.height=130;
	if(dgEquip.selectedItem!=0){
	if(eqp_Analysis.selectedIndex==1){	
		sumport.headerText="VC12总量";
		rep.headerText="使用VC12量";
		useport.headerText="剩余VC12量";
		var name:String=dgEquip.selectedItem.S_SBMC.toString();
		var sat:String=dgEquip.selectedItem.RAT.toString();
	   // Alert.show(sat+"ecwc");
		var re:RemoteObject = new RemoteObject("tuopu");
		re.endpoint = ModelLocator.END_POINT;
		re.showBusyCursor = true;
		re.addEventListener(ResultEvent.RESULT,ResultGetDevDetaiInfo);
		re.getRrep(name,sat); 
		
		var rej:RemoteObject = new RemoteObject("tuopu");
		rej.endpoint = ModelLocator.END_POINT;
		rej.showBusyCursor = true;
		rej.addEventListener(ResultEvent.RESULT,ResultGetDevDetaiInfol);
		rej.getID(name);
	}else if(eqp_Analysis.selectedIndex==2){
		sumport.headerText="VC4总量";
		rep.headerText="使用VC4量";
		useport.headerText="剩余VC4量";
		var name:String=dgEquip.selectedItem.S_SBMC.toString();
		var sat:String=dgEquip.selectedItem.RAT.toString();
		// Alert.show(sat+"ecwc");
		var re1:RemoteObject = new RemoteObject("tuopu");
		re1.endpoint = ModelLocator.END_POINT;
		re1.showBusyCursor = true;
		re1.addEventListener(ResultEvent.RESULT,ResultGetDevDetaiInfo);
		re1.getRrep_vc4(name,sat); 
		
		var rej1:RemoteObject = new RemoteObject("tuopu");
		rej1.endpoint = ModelLocator.END_POINT;
		rej1.showBusyCursor = true;
		rej1.addEventListener(ResultEvent.RESULT,ResultGetDevDetaiInfol);
		rej1.getID(name);
	}else if(eqp_Analysis.selectedIndex==3){	
		sumport.headerText="VC3总量";
		rep.headerText="使用VC3量";
		useport.headerText="剩余VC3量";
		var name:String=dgEquip.selectedItem.S_SBMC.toString();
		var sat:String=dgEquip.selectedItem.RAT.toString();
		// Alert.show(sat+"ecwc");
		var re2:RemoteObject = new RemoteObject("tuopu");
		re2.endpoint = ModelLocator.END_POINT;
		re2.showBusyCursor = true;
		re2.addEventListener(ResultEvent.RESULT,ResultGetDevDetaiInfo);
		re2.getRrep_vc3(name,sat); 
		
		var rej2:RemoteObject = new RemoteObject("tuopu");
		rej2.endpoint = ModelLocator.END_POINT;
		rej2.showBusyCursor = true;
		rej2.addEventListener(ResultEvent.RESULT,ResultGetDevDetaiInfol);
		rej2.getID(name);
	}}
}

private function ResultGetDevDetaiInfo(event:ResultEvent):void{
	
	equipPortDetail=event.result as ArrayCollection;
}
private function ResultGetDevDetaiInfot(event:ResultEvent):void{
	equipPortDetail=event.result as ArrayCollection;
	var element:IElement=(Element)(systemorgmap.selectionModel.lastData);	
	var node:Node=element as Node;
	//var nameStr:String=node.name;
	var idx:int = -1;
	for each(var item:Object in dgEquip.dataProvider){
		idx++;
		for each(var col:DataGridColumn in dgEquip.columns){
			//if(col.dataField !=null && String(item[col.dataField]).indexOf(nameStr)!=-1){
			    if(col.dataField !=null && String(item[col.dataField]).indexOf(node.name)!=-1){
				dgEquip.selectedItem = item;
				dgEquip.scrollToIndex(idx);//将当前行滚动到可视范围内
				return;
			}
		}
	}
}
private function ResultGetDevDetaiInfol(event:ResultEvent):void{
	   nameid=event.result.toString();
	   wangyuan(nameid);
	   
}
private function ResultGetDevInfo(event:ResultEvent):void{
	equipInfo=event.result as ArrayCollection;	
}



public function get dataBox():DataBox
{
	return elementBox;
}



private function itemClickHandler(e:MouseEvent):void{
	
	var element:IElement=(Element)(systemorgmap.selectionModel.lastData);
		if(element is Link){
				;
		}
		else{
			//Alert.show("isworking");
			//Alert.show(tplink.length.toString());
			while(tplink.length>0){
			//	Alert.show("xxxxxxxx");
				
				systemorgmap.elementBox.remove(tplink.pop());
				
			}
				
			
		}
	if (eqp_Analysis.selectedIndex&&systemorgmap.selectionModel.count ==1) //如果当前选中的结点>0
	{
		//获取当前选中的结点

		if (element is Node) //判断选中的元素是不是结点
		{ //选中节点  
			//Alert.show("node");
			var flag:Boolean=TopMenuBar.fullScreenFlag;
			doubleFlag=true;
			if(!flag)
			{			
				
				vb.height=this.stage.stageHeight* 0.58;
				acc.height=vb.height;
			}
	
	if (eqp_Analysis.selectedIndex==1&&systemorgmap.selectionModel.count ==1) //如果当前选中的结点>0
	{
		vb.height=458;
		acc.height=458;
		//获取当前选中的结点
		var element:IElement=(Element)(systemorgmap.selectionModel.lastData);
		if (element is Node) //判断选中的元素是不是结点
		{ 
			//选中节点  
			
			var node:Node=element as Node;
			if(arrayCollection.length>0)
			{
				for(var i:int=0;i<arrayCollection.length;i++)
				{
					if((arrayCollection.getItemAt(i).equipName.toString())==node.name.toString())
					{
						dataGrid1.selectedIndex = i;
						dataGrid1.scrollToIndex(i);//将当前行滚动到可视范围内
						break;
					}
				}
			}
			
			
		}
		
	}
	
	
	if (eqp_Analysis.selectedIndex==2&&systemorgmap.selectionModel.count ==1) //如果当前选中的结点>0
	{
		vb.height=458;
		acc.height=458;
		//获取当前选中的结点
		var element:IElement=(Element)(systemorgmap.selectionModel.lastData);
		if (element is Node) //判断选中的元素是不是结点
		{ 
			//选中节点  
			
			var node:Node=element as Node;
			if(arrayCollection.length>0)
			{
				for(var i:int=0;i<arrayCollection.length;i++)
				{
					if((arrayCollection.getItemAt(i).equipName.toString())==node.name.toString())
					{
						dataGrid1.selectedIndex = i;
						break;
					}
				}
			}
			
			
		}
	}
		}
	}
	
	
	if (eqp_Analysis.selectedIndex==3&&systemorgmap.selectionModel.count==1)//如果选中穿通通道利用率并且当前选中的结点>0
	{
		
		vb.height=458;
		acc.height=458;
		//获取当前选中的结点
		var element:IElement=(Element)(systemorgmap.selectionModel.lastData);
		if (element is Node) //判断选中的元素是不是结点
		{ 
			//选中节点  
			
			var node:Node=element as Node;
			if(equipInfo.length>0)  
			{
				for(var i:int=0;i<equipInfo.length;i++)
				{
					if((equipInfo.getItemAt(i).S_SBMC.toString())==node.name.toString())
					{
						dgEquip.selectedIndex = i;
						break;
					}
				}
			}
			
			
		}
	}
	if (eqp_Analysis.selectedIndex==4&&systemorgmap.selectionModel.count>0) 
	{
		vb.height=458;
		acc.height=458;
		//获取当前选中的结点
		var element:IElement=(Element)(systemorgmap.selectionModel.lastData);
		if (element is Node) //判断选中的元素是不是结点
		{ 
			//选中节点  
			
			var node:Node=element as Node;
			if(equipInfo_1.length>0)
			{
				for(var i:int=0;i<equipInfo_1.length;i++)
				{
					if((equipInfo_1.getItemAt(i).S_SBMC.toString())==node.name.toString())
					{
						dgEquip_1.selectedIndex = i;
						dgEquip_1.scrollToIndex(i);//将当前行滚动到可视范围内
						break;
					}
				}
			}
			
			
		}
/*		equipPortDetail_1=null;
		dgEquip_1.visible=true; dgEquip_1.width=169.8;
		dgEquipInfo_1.visible=true; dgEquipInfo_1.width=980; dgEquipInfo_1.height=130;
		//			dgEquip_1.dataProvider=null; dgEquipInfo_1.dataProvider=null;
		sumTimeSlot.headerText="VC4总量";
		useTimeSlot.headerText="使用VC4量";
		leftTimeSlot.headerText="剩余VC4量";

		//			dgEquip_1.dataProvider=null; dgEquipInfo_1.dataProvider=null;
		//获取当前选中的结点
		var element:IElement=(Element)(systemorgmap.selectionModel.lastData);	
		//Alert.show("11");
		var node:Node=element as Node;
		var ro:RemoteObject = new RemoteObject("EquipName");
		ro.endpoint = ModelLocator.END_POINT;
		ro.showBusyCursor = true;
		ro.addEventListener(ResultEvent.RESULT,ResultGetDevDetaiInfo_1);
		ro.getDevPortHigh(node.id);
		//		Alert.show("222");
		var eqpInfoArr:Array  = new Array();
		for (var i:int=0; i < Shared.equips.length; i++) //遍历所有节点
		{	
			var equip:Object=Shared.equips[i] as Object;	
			var S_SBMC:String = equip.equipname;
			eqpInfoArr[i]=S_SBMC;
		}
		var ro1:RemoteObject = new RemoteObject("EquipName");
		ro1.endpoint = ModelLocator.END_POINT;
		ro1.showBusyCursor = true;
		ro1.addEventListener(ResultEvent.RESULT,ResultGetDevInfo_1);
		ro1.getDevPort(eqpInfoArr);	*/
		
	}
	else if (eqp_Analysis.selectedIndex==5&&systemorgmap.selectionModel.count>0) //如果选中低阶利用率 并且当前选中的结点>0
	{
		
		vb.height=458;
		acc.height=458;
		//获取当前选中的结点
		var element:IElement=(Element)(systemorgmap.selectionModel.lastData);
		if (element is Node) //判断选中的元素是不是结点
		{ 
			//选中节点  			
			var node:Node=element as Node;
			if(equipInfo_1.length>0)
			{
				for(var i:int=0;i<equipInfo_1.length;i++)
				{
					if((equipInfo_1.getItemAt(i).S_SBMC.toString())==node.name.toString())
					{
						dgEquip_1.selectedIndex = i;
						dgEquip_1.scrollToIndex(i);//将当前行滚动到可视范围内
						break;
					}
				}
			}
			
			
		}
		
	/*	equipPortDetail_1=null;
		
		dgEquip_1.visible=true; dgEquip_1.width=169.8;
		dgEquipInfo_1.visible=true; dgEquipInfo_1.width=980; dgEquipInfo_1.height=130;
		
		sumTimeSlot.headerText="VC12总量";
		useTimeSlot.headerText="使用VC12量";
		leftTimeSlot.headerText="剩余VC12量";
		
		//获取当前选中的结点
		var element:IElement=(Element)(systemorgmap.selectionModel.lastData);	
		
		var node:Node=element as Node;
		var ro:RemoteObject = new RemoteObject("EquipName");
		ro.endpoint = ModelLocator.END_POINT;
		ro.showBusyCursor = true;
		ro.addEventListener(ResultEvent.RESULT,ResultGetDevDetaiInfo_1);
		ro.getDevPortLow(node.id);
		
		
		
		
		var eqpInfoArr :Array  = new Array();
		for (var i:int=0; i < Shared.equips.length; i++) //遍历所有节点
		{	
			var equip:Object=Shared.equips[i] as Object;	
			var S_SBMC:String = equip.equipname;
			eqpInfoArr[i]=S_SBMC;
		}
		var ro1:RemoteObject = new RemoteObject("EquipName");
		ro1.endpoint = ModelLocator.END_POINT;
		ro1.showBusyCursor = true;
		ro1.addEventListener(ResultEvent.RESULT,ResultGetDevInfo_1);
		ro1.getDevPort(eqpInfoArr);	
		*/
	}
}


private function ResultGetDevInfo_1(event:ResultEvent):void{
	/*equipInfo_1=event.result as ArrayCollection;	
	//	Alert.show("result");
	var element:IElement=(Element)(systemorgmap.selectionModel.lastData);	
	var node:Node=element as Node;
	var nameStr:String=node.name;

	var idx:int = -1;
	for each(var item:Object in dgEquip_1.dataProvider){
		idx++;
		for each(var col:DataGridColumn in dgEquip_1.columns){
			if(col.dataField !=null && String(item[col.dataField]).indexOf(nameStr)!=-1){
				dgEquip_1.selectedItem = item;
				dgEquip_1.scrollToIndex(idx);//将当前行滚动到可视范围内
				return;
			}
		}
	}*/
	equipInfo_1=event.result as ArrayCollection;	
	var element:IElement=(Element)(systemorgmap.selectionModel.lastData);	
	var node:Node=element as Node;
	var nameStr:String=node.name;
	/*   
	* 单击网络图某一设备在左边表格显示出来
	*/
	//假设nameStr是要查找的字符串,grid是DataGrid组件
	var idx:int = -1;
	for each(var item:Object in dgEquip_1.dataProvider){
		idx++;
		for each(var col:DataGridColumn in dgEquip_1.columns){
			if(col.dataField !=null && String(item[col.dataField]).indexOf(nameStr)!=-1){
				dgEquip_1.selectedItem = item;
				dgEquip_1.scrollToIndex(idx);//将当前行滚动到可视范围内
				return;
			}
		}
	}
	
}	

private function ResultGetDevDetaiInfo_1(event:ResultEvent):void{
	
	equipPortDetail_1=event.result as ArrayCollection;
	var ro11:RemoteObject = new RemoteObject("EquipName");
	ro11.endpoint = ModelLocator.END_POINT;
	ro11.showBusyCursor = true;
	ro11.addEventListener(ResultEvent.RESULT,ResultGetDevDetaiInfosssss);
	ro11.zhi();		
}	
private function ResultGetDevDetaiInfosssss(event:ResultEvent):void{
	
	  sfsf=event.result as String;
	  var sfdf:Array=sfsf.split(",");
	  var objs:Object=new Object();
	  objs.TIMESLOT_USE="最小利用率："+sfdf[0].toString();     ////可能跟后面的业务重复了，去掉重复的内容
	  objs.USE_RATIO="平均利用率："+sfdf[1].toString();
	  objs.TIMESLOT_LEFT="最大利用率："+sfdf[2].toString();
	  //新增的用户放第一条
	  equipPortDetail_1.addItemAt(objs,equipPortDetail_1.length);

	  
}
/**
 *当双击左侧表格的设备时在network中选中它 ,已经实现
 * @param event
 * 
 */
private function dgEquip_doubleClick(event:MouseEvent):void
{
	equipPortDetail_1=null;
	doubleFlag=true;
	var flag:Boolean=TopMenuBar.fullScreenFlag;
	if(!flag)
	{					
		vb.height=this.stage.stageHeight* 0.58;
		acc.height=vb.height;
	}
	var name:Object=dgEquip_1.selectedItem.S_SBMC;
	var ro:RemoteObject = new RemoteObject("EquipName");
	ro.endpoint = ModelLocator.END_POINT;
	ro.showBusyCursor = true;
	ro.addEventListener(ResultEvent.RESULT,ResultGetCode);
	ro.getCodeByName(name);	
	
	
}

private function ResultGetCode(event:ResultEvent):void{
	var code:String=event.result.toString();
	
	if(code!=null)
	{		
		//显示下面的表格
		if (eqp_Analysis.selectedIndex==4){    //端口高阶利用率分析
			
			sumTimeSlot.headerText="VC4总量";
			useTimeSlot.headerText="使用VC4量";
			leftTimeSlot.headerText="剩余VC4量";
			
			dgEquipInfo_1.visible=true; dgEquipInfo_1.width=980; dgEquipInfo_1.height=130;	
			
			var ro:RemoteObject = new RemoteObject("EquipName");
			ro.endpoint = ModelLocator.END_POINT;
			ro.showBusyCursor = true;
			ro.addEventListener(ResultEvent.RESULT,ResultGetDevDetaiInfo_1);
			ro.getDevPortHigh(code);
		}
			
			//显示下面的表格
		else	if (eqp_Analysis.selectedIndex==5){  
			
			sumTimeSlot.headerText="VC12总量";
			useTimeSlot.headerText="使用VC12量";
			leftTimeSlot.headerText="剩余VC12量";

			//端口低阶利用率分析
			dgEquipInfo_1.visible=true; dgEquipInfo_1.width=980; dgEquipInfo_1.height=130;	
			var ro1:RemoteObject = new RemoteObject("EquipName");
			ro1.endpoint = ModelLocator.END_POINT;
			ro1.showBusyCursor = true;
			ro1.addEventListener(ResultEvent.RESULT,ResultGetDevDetaiInfo_1);
			ro1.getDevPortLow(code);
		
		}
		//双击表格设备，右边拓扑图显示
		var equip_node:Node=dataBox.getDataByID(code.toString()) as Node;
		if(equip_node!=null)
		{
			systemorgmap.selectionModel.clearSelection();
			systemorgmap.selectionModel.appendSelection(equip_node);
			equip_node.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
			equip_node.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
			equip_node.setStyle(Styles.VECTOR_FILL_COLOR, 0x7697C9);
			systemorgmap.centerByLogicalPoint(equip_node.centerLocation.x,equip_node.centerLocation.y);
		}
	}
}

private function preinitialize():void
{
	mapobj=new BussinessRoute();
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
	
	if(Shared.import_flag==2){
		Alert.show("请先在“网络拓扑图”页面导入调度数据网拓扑图！");
		Shared.import_flag=0;
	}
	
	var xml :String = "<system code=\"全网\" name=\"全网\" x_coordinate=\"0\" y_coordinate=\"0\" itemShowCheckBox=\"false\" isBranch=\"true\" type=\"all\" checked=\"0\">";
	xml += "<system code=\"骨干网A平面\" name=\"华为\" x_coordinate=\"0\" y_coordinate=\"0\" isBranch=\"true\" type=\"system\" itemShowCheckBox=\"true\" checked=\"0\"></system>";
	xml += "<system code=\"骨干网B平面\" name=\"测试平面b\" x_coordinate=\"0\" y_coordinate=\"0\" isBranch=\"true\" type=\"system\" itemShowCheckBox=\"true\" checked=\"0\"></system>";
	xml += "</system>";
	XMLData=new XMLList(xml.toString());
	testtree.dataProvider=XMLData;
	
	
	dataGrid1.visible=false; dataGrid1.width=0;
	dgEquip.visible=false; dgEquip.width=0;  //我的 网元高阶、低阶利用率分析分别隐藏
	dgEquipInfo.visible=false; dgEquipInfo.width=0; dgEquipInfo.height=0;//我的
	dgEquip_1.visible=false; dgEquip_1.width=0;  //我的 网元高阶、低阶利用率分析分别隐藏
	dgEquipInfo_1.visible=false; dgEquipInfo_1.width=0; dgEquipInfo_1.height=0;//我的
	
	
	SerializationSettings.registerGlobalClient("code","String"); 
	SerializationSettings.registerGlobalClient("part", Consts.TYPE_NUMBER);
	Utils.registerImageByClass("link_flexional_icon", ModelLocator.link_flexional_icon);
	Utils.registerImageByClass("jian", ModelLocator.jian);
	ModelLocator.registerAlarm();
	elementBox=systemorgmap.elementBox;
	serializer=new XMLSerializer(elementBox)
	elementBox.setStyle(Styles.BACKGROUND_TYPE, Consts.BACKGROUND_TYPE_IMAGE_VECTOR);
	elementBox.setStyle(Styles.BACKGROUND_IMAGE_STRETCH, Consts.STRETCH_FILL);
	elementBox.setStyle(Styles.BACKGROUND_IMAGE, "twaverImages/sysOrgMap/mainbg.png");
	mapLayer=new Layer("background");	
	elementBox.layerBox.add(mapLayer,0);
	mapLayer.movable = false;
	DeviceXML=new XMLList("<folder state='0' code='ZY03070201' label='所有设备' parameter='ZY03070201' isBranch='true' leaf='false' type='equiptype' ></folder>");	
	//添加工具条
	DemoUtils.initNetworkToolbarForSysGraph(toolbar, systemorgmap,"默认模式");
	
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
					
					// 暂时注释掉 zmc
					//rtobj1.SaveSysOrgMap(array);
					//rtobj1.addEventListener(ResultEvent.RESULT, afterSaveSysOrgMap);
				}
				})
		], false, false, -1, -1);
			}
				DemoUtils.createButtonBar(toolbar, [DemoUtils.createButtonInfo("刷新", DemoImages.refresh, function():void
				{		
					/*cob.visible="true";		
					cob.width=150;	*/
					refreshSystems();
					
				})
				], false, false, -1, -1);
				var s:Spacer = new Spacer();
				s.width=-2;
				toolbar.addChild(s);
				toolbar.addChild(createCheckBox('呈现所有告警',checkbox_alarmHandler));
				//				if(tree.selectedItem){
				//					var node:XML=tree.selectedItem as XML;
				//					if(node.@name=="传输A网"||node.@name=="传输B网"){				
				//					 toolbar.addChild(createCheckBox("呈现光迅信息",bPL_changeHandler));
				//					}
				//				}	
				toolbar.addChild(createCheckBox('圆形布局',checkbox_changeHandler));
				toolbar.addChild(createCheckBox('星形布局',checkbox_changeHandler));
				toolbar.addChild(createCheckBox('弹性布局',checkbox_changeHandler));
				//初始化右键菜单
				DemoUtils.initNetworkContextMenu(systemorgmap, null);
				
				systemorgmap.addEventListener(MouseEvent.MOUSE_WHEEL,wheelHandler);
			//	systemorgmap.addEventListener(MouseEvent.CLICK,OnClickHandler);//modified
				
				//增加右键菜单
				systemorgmap.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, function(e:ContextMenuEvent):void
				{
					//右键选中网元
					var p:Point=new Point(e.mouseTarget.mouseX / systemorgmap.zoom, e.mouseTarget.mouseY / systemorgmap.zoom);
					var datas:ICollection=systemorgmap.getElementsByLocalPoint(p);
					
					if (datas.count == 0)
					{		
						
						systemorgmap.selectionModel.clearSelection();
					}
					
					//定制右键菜单
					var flexVersion:ContextMenuItem=new ContextMenuItem(DemoUtils.FLEX_SDK_VERSION, false, false);
					var playerVersion:ContextMenuItem=new ContextMenuItem(DemoUtils.FLASH_PLAYER_VERSION, false, false);
					

					
					if (systemorgmap.selectionModel.selection.count == 0)
					{ //选中元素个数
						systemorgmap.contextMenu.customItems=[flexVersion, playerVersion];
					}
					else
					{
						if ((Element)(systemorgmap.selectionModel.lastData) is Node && ((Element)(systemorgmap.selectionModel.lastData).getClient("NodeType") == "equipment"))
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
							//故障检修
							var item_rep:ContextMenuItem = new ContextMenuItem("故障检修");
							item_rep.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, BusinesscheckHandler);
							
							//检修恢复
							var item_rec:ContextMenuItem = new ContextMenuItem("检修点恢复");
							item_rec.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, CheckRecoverHandler);
							
							if (parentApplication.curUser != "root")
							{
								item_config.visible = isConfig;
							}
							//利用visible 显示隐藏
							//							systemorgmap.contextMenu.customItems=[item_device, item_config, item_equipproperty, item_equipopera,item_alarm,item_operate,item_eventInterpose,item_eventInterposeFault];
//							systemorgmap.contextMenu.customItems=[item_device, item_config, item_configEquipSolt, item_equipproperty, item_equipopera,item_equipdelete,item_alarm,item_rep,item_rec];
							systemorgmap.contextMenu.customItems=[item_rep,item_rec];
							
							if(showOper){
								systemorgmap.contextMenu.customItems.push(item_operate);
							}
							if(isAddInterpose){
								systemorgmap.contextMenu.customItems.push(item_eventInterpose);
							}
							if(isAddInterposeFault){
								systemorgmap.contextMenu.customItems.push(item_eventInterposeFault);
							}
							if(isAddCutFault){
								systemorgmap.contextMenu.customItems.push(item_cutfault);
							}
							//							if(isAddInterpose&&isAddInterposeFault){
							//								systemorgmap.contextMenu.customItems=[item_device, item_config, item_equipproperty, item_equipopera,item_alarm,item_operate,item_eventInterpose,item_eventInterposeFault];
							//							}else if(isAddInterpose){
							//								systemorgmap.contextMenu.customItems=[item_device, item_config, item_equipproperty, item_equipopera,item_alarm,item_operate,item_eventInterpose];
							//							}else if(isAddInterposeFault){
							//								systemorgmap.contextMenu.customItems=[item_device, item_config, item_equipproperty, item_equipopera,item_alarm,item_operate,item_eventInterposeFault];
							//							}else {
							//								systemorgmap.contextMenu.customItems=[item_device, item_config, item_equipproperty, item_equipopera,item_alarm,item_operate];
							//							}
							//也可这样 简单配置
							//							item_cutfault.visible = isAddCutFault;
							//							systemorgmap.contextMenu.hideBuiltInItems();//可隐藏不需要显示的功能项
							//							systemorgmap.contextMenu.customItems = [item_device, item_config, item_equipproperty, item_equipopera,item_alarm,item_operate,item_cutfault];
						}
						else if ((Element)(systemorgmap.selectionModel.lastData) is Link)
						{ //选中线 
							if(((Link)(systemorgmap.selectionModel.lastData).bundleLinks==null)||((Link)(systemorgmap.selectionModel.lastData).bundleLinks!=null&&(Link)(systemorgmap.selectionModel.lastData).getStyle(Styles.LINK_BUNDLE_EXPANDED)==true))
							{
								var item_slot:ContextMenuItem=new ContextMenuItem("时隙分布图");
								item_slot.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler_TimeSlot);
								var item_info:ContextMenuItem=new ContextMenuItem("复用段信息");
								item_info.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler_info);
								var item_route:ContextMenuItem=new ContextMenuItem("查看光路");
								item_route.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,itemSelectHandler_modlink);
								systemorgmap.contextMenu.customItems=[item_route];
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
								
								//故障检修
								var item_rep:ContextMenuItem = new ContextMenuItem("故障检修");
								item_rep.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, BusinesscheckHandler);
								
								//检修恢复
								var item_rec:ContextMenuItem = new ContextMenuItem("检修点恢复");
								item_rec.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, CheckRecoverHandler);
								
								systemorgmap.contextMenu.customItems=[item_info,item_route,item_slot, item_linkproperty,item_linkdel, item_linkopera,link_eventInterpose,link_eventInterposeFault,item_cutfault,item_fiberroute,item_rep,item_rec];
							}
							else{
								var item_route:ContextMenuItem=new ContextMenuItem("查看光路");
								item_route.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,itemSelectHandler_modlink);
								systemorgmap.contextMenu.customItems=[item_route];
							}
						}
						else
						{
							systemorgmap.contextMenu.customItems=[flexVersion, playerVersion];
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
				var deviceTreeCM:ContextMenu=new ContextMenu();
				deviceTreeCM.addEventListener(ContextMenuEvent.MENU_SELECT, deviceTreeItemSelectHandler);
				deviceTreeCM.hideBuiltInItems();
				deviceTreeCM.customItems=null;
				deviceTree.contextMenu=deviceTreeCM;
				
				fw.getSystemTree(); //获取系统组织图左侧系统树的数据	
				}
				/**
				 * 删除设备
				 *
				 * 
				 */
				private function performance_dataHandler(e:ContextMenuEvent):void{
					var node:Node=(Element)(systemorgmap.selectionModel.lastData);
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
					if(event.ctrlKey && event.delta > 0 && systemorgmap.zoom < 1.2)
					{
						systemorgmap.zoomIn(false);
					}
					else if(event.ctrlKey && event.delta < 0 && systemorgmap.zoom > 0.2)
					{
						systemorgmap.zoomOut(false);
					}
					systemorgmap.callLater(function():void
					{
						if(systemorgmap.elementBox.selectionModel.count > 0)
						{
							var ele:Element = systemorgmap.elementBox.selectionModel.selection.getItemAt(0);
							if(ele is Node)
							{
								systemorgmap.centerByLogicalPoint(Node(ele).centerLocation.x,Node(ele).centerLocation.y);
							}
						}
					});
				}
				/**
				 * 
				 * 单击复用段事件处理
				 * 
				 */
				private function OnClickHandler(event:MouseEvent):void
				{
					if ((Element)(systemorgmap.selectionModel.lastData) is Link){
						Alert.show("link is clicked");
						
						
					}
				}
				
				/**
				 *刷新系统 
				 * 
				 */
				private function refreshSystems():void
					
				{  
					vb.height=458;
					acc.height=458;

					
					eqp_Analysis.selectedIndex=0;
					dataGrid1.visible=false;
					dataGrid1.width=0;
					arrayCollection=null;
					eqp_Analysis.selectedIndex=0;
					dgEquip.visible=false; dgEquip.width=0;  //我的 网元高阶、低阶利用率分析分别隐藏
					dgEquipInfo.visible=false; dgEquipInfo.width=0; dgEquipInfo.height=0;//我的
					dgEquip_1.visible=false; dgEquip_1.width=0;  //我的 网元高阶、低阶利用率分析分别隐藏
					dgEquipInfo_1.visible=false; dgEquipInfo_1.width=0; dgEquipInfo_1.height=0;//我的
					if(tree.selectedItem&&tree.selectedItem.@name!="调度数据网")
					{
						// edit here
						//var system:Location=new Location(tree.selectedItem.@code,tree.selectedItem.@name,tree.selectedItem.@x_coordinate,tree.selectedItem.@y_coordinate,false);
						//freshAddNodeAfterExpand(system);
					}	
					else
					{
						Alert.show("请选择系统!");
					}
					if(springLaouter!=null){
						springLaouter.stop();
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
				private function deviceTreeItemSelectHandler(event:ContextMenuEvent):void
				{
					var itemDel:ContextMenuItem=new ContextMenuItem("删除设备");
					itemDel.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemDeleteHandler);
					itemDel.visible = isDeleteEquipment;
					deviceTree.selectedIndex=curIndex;
					if (deviceTree.selectedItem)
					{
						if (deviceTree.selectedItem.@isBranch == "false")//为设备
						{
							deviceTree.contextMenu.customItems=[itemDel];
						}	
						else
						{			
							deviceTree.contextMenu.customItems=null;
						}
					}
				}
				
				
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
						var node:Node=(Element)(systemorgmap.selectionModel.lastData);
						showcc.belongequip=node.getClient("code").toString();
						tw.addEventListener(CloseEvent.CLOSE,twcolse);
						tw.addChild(showcc);
						PopUpManager.addPopUp(tw,main(Application.application),true);
						PopUpManager.centerPopUp(tw);
					}else if(e.currentTarget.caption == "配置交叉") {
						var slot:configSlot=new configSlot();
						var node:Node=(Element)(systemorgmap.selectionModel.lastData);
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
				 *菜单删除设备处理函数 
				 * @param event
				 * 
				 */
				private function itemDeleteHandler(event:ContextMenuEvent):void 
				{
					Alert.show("您确认要删除吗？", "提示", Alert.YES | Alert.NO, this, delHandler);
				}
				
				
				/**
				 * 删除设备处理函数
				 * @param event
				 * 
				 */
				private function delHandler(event:CloseEvent):void
				{
					if (event.detail == Alert.YES)
					{
						delEquipcode=deviceTree.selectedItem.@code;
						var ro:RemoteObject=new RemoteObject("equInfo");
						ro.endpoint=ModelLocator.END_POINT;
						ro.showBusyCursor=true;
						parentApplication.faultEventHandler(ro);
						ro.addEventListener(ResultEvent.RESULT, hasEquipPackHandler);
						ro.hasEquipPack(delEquipcode);//判断当前设备是否有机盘等数据
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
					
					
					for (var i:int=0; i < deviceTree.dataProvider.children().length(); i++)//将该设备从传输设备树种移除
					{
						if (vendor == deviceTree.dataProvider.children()[i].@label)
						{
							deviceTree.selectedIndex=i + 1;
							curIndex=i + 1;
							selectedNode=deviceTree.selectedItem as XML;
							delete selectedNode.folder;
							catalogsid=selectedNode.attribute("code");
							type=selectedNode.attribute("type");
							var rt_DeviceTree:RemoteObject=new RemoteObject("fiberWire");
							rt_DeviceTree.endpoint=ModelLocator.END_POINT;
							rt_DeviceTree.showBusyCursor=true;
							rt_DeviceTree.addEventListener(ResultEvent.RESULT, generateDeviceTreeInfo);	
							parentApplication.faultEventHandler(rt_DeviceTree);
							rt_DeviceTree.getTransDevice(catalogsid, type); //获取传输设备树的数据
							break;
						}
					}
					
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
					fw.getSystemTree();
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
				private function treeChange():void
				{
					deviceTree.selectedIndex=curIndex;
					selectedNode=deviceTree.selectedItem as XML;
					if (selectedNode.@leaf == false && (selectedNode.children() == null || selectedNode.children().length() == 0))
					{
						catalogsid=selectedNode.attribute("parameter");
						type=selectedNode.attribute("type");	
						dispatchEvent(new Event(EventNames.CATALOGROW));
					}
				}
				
				//点击树项目取到其下一级子目录  
				private function initEvent():void
				{ //初始化事件
					
					addEventListener(EventNames.CATALOGROW, gettree);
					addEventListener(EventNames.SYSEVENT,getSysTree);
					
					
				
					
				}
				
				private function gettree(e:Event):void
				{
					
					removeEventListener(EventNames.CATALOGROW, gettree);
					var rt_DeviceTree:RemoteObject=new RemoteObject("fiberWire");
					rt_DeviceTree.endpoint=ModelLocator.END_POINT;
					rt_DeviceTree.showBusyCursor=true;
					rt_DeviceTree.addEventListener(ResultEvent.RESULT, generateDeviceTreeInfo);
					parentApplication.faultEventHandler(rt_DeviceTree);
					rt_DeviceTree.getTransDevice(catalogsid, type); //获取传输设备树的数据
					
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
				//  tree.dataProvider=null;
					XMLData=new XMLList(event.result.toString());
					tree.dataProvider=XMLData;
					var xmllist:*=tree.dataProvider;
					var xmlcollection:XMLListCollection=xmllist;		
					for each (var element:XML in xmlcollection)
					{
						if (element.@code ==  "全网")
						{ 
							tree.selectedItem=element;
							break;
						}
						
					}
					if(showSysGraphAlarm){
						for each (var element:XML in xmlcollection.children())
						{ 
							if (element.@name ==  "华为")
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
									addNodeAfterClick(element);
									/*			vb.width=40;*/																						
								}
								break;   
							}
							/*if(element.@name == "调度数据网"){
								import_map_clickHandler();
							}*/
							tree.callLater(expandTree);
						}
					}
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
				private function generateDeviceTreeInfo(event:ResultEvent):void 
				{
					
					var str:String=event.result as String;	
					if (str != null && str != "")
					{
						var child:XMLList=new XMLList(str);
						if (selectedNode.children() == null || selectedNode.children().length() == 0)
						{
							deviceTree.expandItem(selectedNode, false);
							selectedNode.appendChild(child);
							deviceTree.callLater(openTreeNode, [selectedNode]);
						}
					}
					addEventListener(EventNames.CATALOGROW, gettree);
				}
				
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
							
							tree.callLater(openSystemTreeNode, [tree_selectedNode]);
							
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
				 *展开传输设备树结点 
				 * @param xml
				 * 
				 */
				private function openTreeNode(xml:XML):void 
				{
					if (deviceTree.isItemOpen(xml))
						deviceTree.expandItem(xml, false);
					deviceTree.expandItem(xml, true);
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
					Shared.import_flag=0;
					vb.height=458;
					acc.height=458;
					cob.visible=true;
					eqp_Analysis.visible=true;
					//Alert.show("wefwf");
					  eqp_Analysis.selectedIndex=0;
					  dataGrid1.visible=false;
					  dataGrid1.width=0;
					  arrayCollection=null;

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
								{
									if(node.@name == "调度数据网"){
										import_map_clickHandler();
							
									}
									else{
										Shared.import_flag=0;
										nod.text=Shared.equips.length.toString();
							
										eqp_Analysis.selectedIndex=0;
										currSystemName=node.@name;//用于分析
										countTree++;
										cob_add.visible=false;cob_add.width=0;//附加次数选项隐藏  用于关键点分析
										
										dgEquip.visible=false; dgEquip.width=0;  //我的
										dgEquipInfo.visible=false; dgEquipInfo.width=0; dgEquipInfo.height=0;//我的
										
										dgEquip_1.visible=false; dgEquip_1.width=0;  //我的
										dgEquipInfo_1.visible=false; dgEquipInfo_1.width=0; dgEquipInfo_1.height=0;//我的
										addNodeAfterClick(node);
									}
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
								{        /*   cob.visible="true";
									        cob.width=150;
										    vb.width=25;*/
									        currSystemName="";   
                                            countTree=0;
									dgEquip.visible=false; dgEquip.width=0;  //我的
									dgEquipInfo.visible=false; dgEquipInfo.width=0; dgEquipInfo.height=0;//我的
									dgEquip_1.visible=false; dgEquip_1.width=0;  //我的
									dgEquipInfo_1.visible=false; dgEquipInfo_1.width=0; dgEquipInfo_1.height=0//我的							
									eqp_Analysis.selectedIndex=0;  
									node.@checked="0";
									delete node.system;
									
									Alert.show("clear");
									elementBox.clear();
									tree_selectedNode = null;
									lab.text ="";
									su.headerText="";
									no.headerText="";
									di.headerText="";
									equipGrid.dataProvider=null;
								}
							}else{
								lab.text ="";
								su.headerText="";
								no.headerText="";
								di.headerText="";
								equipGrid.dataProvider=null;
							}
						}
					}
					
				}
				protected function dataGrid1_itemDoubleClickHandler(event:ListEvent):void
				{
					
					
					// TODO Auto-generated method stub
					/*var item:Object=Tree(event.currentTarget).selectedItem;*/
					var item:*=dataGrid1.selectedItem as Object;
					var str:String=item.equipName.toString();
					var rtobj663:RemoteObject=new RemoteObject("availability");
					rtobj663.endpoint=ModelLocator.END_POINT;
					rtobj663.showBusyCursor=true;
					rtobj663.getequipcode(str);
					rtobj663.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{								
						var ss:String=event.result as String;
						if(item!=null)
						{
							var equip_node:Node=dataBox.getDataByID(ss) as Node;
							if(equip_node!=null)
							{
								systemorgmap.selectionModel.clearSelection();
								systemorgmap.selectionModel.appendSelection(equip_node);
								
								equip_node.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
								equip_node.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
								equip_node.setStyle(Styles.VECTOR_FILL_COLOR, 0x7697C9);
								systemorgmap.centerByLogicalPoint(equip_node.centerLocation.x,equip_node.centerLocation.y);
							}
						}
					});
					
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
				public var system:Location;
				private function addNodeAfterClick(node:XML):void
				{
					system=new Location(node.@code,node.@name,node.@x_coordinate,node.@y_coordinate,false);
					
					freshAddNodeAfterExpand(system);
				}
				
				/**
				 *添加已经展开的系统到network中
				 *  
				 * @param system
				 * 
				 */
				private function freshAddNodeAfterExpand(system:Location):void
				{     //2evar cic:bo;
					//初始化分析栏 mawj
					var i:String="sss";
					cob.selectedIndex=0;
					if(lab!=null&&equipGrid!=null){
						lab.visible=false;
						equipGrid.visible=false;
					}
					vb.currentState="hide";
					var rtobj:RemoteObject=new RemoteObject("fiberWire");
					rtobj.endpoint=ModelLocator.END_POINT;
					rtobj.showBusyCursor=true;
					parentApplication.faultEventHandler(rtobj);
					rtobj.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void
					{
						//liqinming 
						var syscode:String=currSystemName;
		//json usage			
						Alert.show("clear 2");
						systemorgmap.elementBox.clear();
						var xml:String=event.result.toString();
						var equips:Array=(JSON.decode(xml.split("---")[0].toString()) as Array); //获取该系统的设备数组
						var business_n:Array=(JSON.decode(xml.split("---")[1].toString()) as Array); //获取业务             //liao
						var ocables:Array=(JSON.decode(xml.split("---")[2].toString()) as Array); //获取该系统的复用段数组					
						var fibers:Array=(JSON.decode(xml.split("---")[3].toString()) as Array); //获取该系统的光路段数组
						Shared.equips=equips;//设备数组初始 mawj分析
						nod.text=equips.length.toString();
						Shared.ocables=ocables;
						Shared.fibers=fibers;
						tree_selectedNode= tree.selectedItem as XML;
						
						Shared.info_array=new Array();//lian
							
						var str:String="";
						var wArray:Array=new Array();                    //自定义，存放设备代码
						for (var i:int=0;i<equips.length;i++)
						{	
							Shared.info_array[i] = new Array();//lian
							for(var j:int = 0; j<equips.length; j++){
								Shared.info_array[i][j] = 0;
							}
							var equip:Object=equips[i] as Object;	
							wArray[i]=equip.equipcode;
							var exist_node:Node=systemorgmap.elementBox.getDataByID(equip.equipcode) as Node;
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
									var re1:RegExp = new RegExp("/", "g");     //liqinming
									var img_x_model:String=x_model.replace(re1,"");
									var re2:RegExp = new RegExp(" ", "g"); 
									img_x_model=img_x_model.replace(re2,"");
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
								systemorgmap.elementBox.add(node);					
								
							}
							
						}
						Shared.equipmentcodes=wArray;               //自定义
                            if(currSystemName!=""&&countTree==1)
						 {
						//添加第三级节点 
						tree.expandItem(tree_selectedNode, false, true);
						//展开树形节点
					
						tree_selectedNode.appendChild(new XMLList(str));
                                                 countTree--;
					tree.expandItem(tree_selectedNode, true, true);	
					         }
                                              
							if(currSystemName=="")
						{
							Alert.show("clear 3");
							//systemorgmap.elementBox.clear();
						}
					
						
						var tArray = new Array();              //自定义，存放服用段代码
						
						for ( i=0; i < ocables.length; i++) //把系统内部设备之间的复用段
						{
							var ocable:Object=ocables[i] as Object;
							var equip_a:String=ocable.equip_a;
							var system_a:String=ocable.system_a;
							var equip_z:String=ocable.equip_z;
							var equipa_z:String=ocable.equipa_z;               //自定义
							var linkid:String=ocable.label;
							tArray[i] = equipa_z;
							
							var system_z:String=ocable.system_z;
							var label:String=ocable.label;
							var labelname:String=ocable.aendptpxx + "-" + ocable.zendptpxx;	
							var node_a:Node=null;
							var node_z:Node=null;
							var existlink:Link=systemorgmap.elementBox.getDataByID(label) as Link;
							//自定义
							
							if(existlink==null)
							{
								node_a=systemorgmap.elementBox.getDataByID(equip_a) as Node;
								node_z=systemorgmap.elementBox.getDataByID(equip_z) as Node;
								var id1:int=0,id2:int=0;
								var count1:int=0;
								for(var i1:int = 0; i1<equips.length && count1<2 ; i1++){
									if(equips[i1].equipcode == equip_a){
										id1 = i1;
										count1++;
									}
									if(equips[i1].equipcode == equip_z){
										id2 = i1;
										count1++;
									}
								}
								if(node_a!=null&&node_z!=null)
								{//lian
									Shared.info_array[id1][id2] = 1;
									Shared.info_array[id2][id1] = 1;
									//									var link:DemoLink=new DemoLink(label,node_a, node_z);
									//link添加位置
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
									//									switch(ocable.linerate)
									//									{
									//										case 'ZY110601' : link.setStyle(Styles.LINK_WIDTH,2.5);break;//155Mb/s
									//										case 'ZY110602' : link.setStyle(Styles.LINK_WIDTH,2.5);break;//622Mb/s
									//										case 'ZY110603' : link.setStyle(Styles.LINK_WIDTH,2.5); break;//2.5Gb/s
									//										case 'ZY110604' : link.setStyle(Styles.LINK_WIDTH,2.5);break;//10Gb/s
									//										case 'ZY110612' : link.setStyle(Styles.LINK_WIDTH,2.5);break;//2Mb/s
									//										case 'ZY110613' : link.setStyle(Styles.LINK_WIDTH,2.5);break;//64K
									//										case 'ZY110699' : link.setStyle(Styles.LINK_WIDTH,2.5);break;//其它
									//										
									//									}
									
									link.setClient("equip_a", equip_a);
									link.setClient("equip_z", equip_z);
									link.setClient("equip_a_name", node_a.name);
									link.setClient("equip_z_name", node_z.name);									
									link.setClient("labelname", labelname);
									link.toolTip=labelname;
									link.setClient("linktype", linktype);
									link.setStyle(Styles.LINK_TYPE,Consts.LINK_TYPE_HORIZONTAL_VERTICAL);
									//lian
									link.setStyle(Styles.LINK_BUNDLE_OFFSET, 50);
									link.setStyle(Styles.LINK_BUNDLE_GAP,25);
									link.setStyle(Styles.LINK_BUNDLE_EXPANDED, false);
									
									/*if(opticalid==null||opticalid==""){
										link.setStyle(Styles.LINK_PATTERN,[3,8]);
									}*/
									
									link.setClient("code",label);
									link.setClient("linerate", ocable.linerate);
									link.setClient("systemname",system.systemcode);
									link.setClient("aendptp",aendptp);
									link.setClient("aendptpxx",aendptpxx);
									link.setClient("zendptp",zendptp);
									link.setClient("zendptpxx",zendptpxx);
									link.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
									if(ocable.linerate=="ZY110601")
										link.setStyle(Styles.INNER_COLOR,0x000000);
									else if(ocable.linerate=="ZY110604")
									{
										link.setStyle(Styles.INNER_COLOR,0xee1111);
										link.setStyle(Styles.LINK_WIDTH,2.5)
									}
									else if(ocable.linerate=="ZY110603")
										link.setStyle(Styles.INNER_COLOR,0x008000);
									else if(ocable.linerate=="ZY110602")
										link.setStyle(Styles.INNER_COLOR,0x800080);
									link.setStyle(Styles.SELECT_COLOR,"0xFF6600");
									link.setStyle(Styles.SELECT_WIDTH,'10');
									if(i<=60){
										link.setClient("status","normal");
									}else{
										link.setClient("status","aa");
									}
									systemorgmap.elementBox.add(link);	
									//									if(timer==null){
									//										timer= new Timer(600);
									//										timer.addEventListener(TimerEvent.TIMER, tick);	
									//									}
									//									timer.start();
								}	
							}		
							
						}
						Shared.linkcodes=tArray;                    //自定义
						/*for(var i:int=0;i<wArray.length;i++)
						Alert.show(wArray[i].toString());*/
						
						var alarm:String=Registry.lookup("alarm");
						if(alarm!=null)
						{
							Registry.unregister("alarm");
							for each(var item:* in toolbar.getChildren())
							{
								if(item is CheckBox&& item.label=='呈现所有告警')
								{		
									CheckBox(item).selected=true;
									alarm_all=true;
									systemorgmap.elementBox.forEach(function(element:IElement):void{
										if(element is Node&&element.getClient("NodeType")=="equipment")
										{	
											var alarmcount:String=element.getClient("alarmcount");
											var alarmlevel:String=element.getClient("alarmlevel");
											element.alarmState.setNewAlarmCount(AlarmSeverity.getByValue(int(alarmlevel)),int(alarmcount));
										}
									});
								}
							}
						}
						//居中显示
						if(!showSysGraphAlarm){
							setTimeout(setScrollPosition,500);
						}
						//	setTimeout(setScrollPosition,500);
						//加载完成后缩放 字体清晰
						systemorgmap.zoom =	0.5917159763313609;
						var fontsize:int=12; //字号	
						fontsize=parseInt((fontsize/0.5917159763313609).toString());		
						var count:int=systemorgmap.elementBox.datas.count; 
						for(var i:int=0;i<count;i++){				
							(systemorgmap.elementBox.datas.getItemAt(i) as Element).setStyle(Styles.LABEL_SIZE,fontsize);  
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
				//李钦铭 
					
				
				}
				
				private function setScrollPosition():void{
					systemorgmap.horizontalScrollPosition = systemorgmap.width/2;
					systemorgmap.verticalScrollPosition = systemorgmap.height/2;								
					
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
					systemorgmap.elementBox.forEach(function(element:IElement):void{
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
							systemorgmap.selectionModel.clearSelection();
							systemorgmap.selectionModel.appendSelection(selectnode);
							selectnode.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
							selectnode.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
							selectnode.setStyle(Styles.VECTOR_FILL_COLOR, 0x7697C9);
							systemorgmap.centerByLogicalPoint(selectnode.centerLocation.x,selectnode.centerLocation.y);
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
					
					var node:Node=(Element)(systemorgmap.selectionModel.lastData);
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
					
					var link:Link=(Element)(systemorgmap.selectionModel.lastData);
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
						var link:Link=(Element)(systemorgmap.selectionModel.lastData);
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
					var link:Link=(Element)(systemorgmap.selectionModel.lastData);
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
					var link:Link=(Element)(systemorgmap.selectionModel.lastData);
					var topolinkid:String=link.getClient("code").toString();
					var labelname:String=link.getClient("labelname").toString();
					mouse_x=e.mouseTarget.mouseX/systemorgmap.zoom;
					mouse_y=e.mouseTarget.mouseY/systemorgmap.zoom;
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
						var link:Link=(Element)(systemorgmap.selectionModel.lastData);
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
						var link:Link=(Element)(systemorgmap.selectionModel.lastData);
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
					var node:Node=(Element)(systemorgmap.selectionModel.lastData);
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
				private function onItemClick(evt:ListEvent):void
				{
					if (evt.target is TileList && ((evt.target as TileList).selectedItem is ActionTile))
					{
						var item:ActionTile=(evt.target as TileList).selectedItem as ActionTile;
						if (item.action != null)
						{
							item.action();
						}
						else
						{
							systemorgmap.setEditInteractionHandlers();
						}
					}
				}
				
				private function createLinkInteraction(linkClass:Class, linkType:String, callback:Function=null, isByControlPoint:Boolean=false, splitByPercent:Boolean=true, value:Number=-1):void
				{
					if(isAddTopolink)
						systemorgmap.setCreateLinkInteractionHandlers(linkClass, callback, linkType, isByControlPoint, value, true);
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
					
					systemorgmap.setDefaultInteractionHandlers();
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
					
					if (systemorgmap.selectionModel.count ==1) //如果当前选中的结点>0
					{
						//获取当前选中的结点
						var element:IElement=(Element)(systemorgmap.selectionModel.lastData);
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
					var link:Link=(Element)(systemorgmap.selectionModel.lastData);
					Registry.register("label", link.getClient("code").toString());
					Registry.register("linerate", link.getClient("linerate").toString());
					Registry.register("systemcode", link.getClient("systemname").toString());
					Application.application.openModel(e.currentTarget.caption, false);
				}
				/**
				 *查看对应复用段所有光路 
				 * @param e
				 * 
				 */
				private function itemSelectHandler_getroute(e:ContextMenuEvent):void
				{
					var link:Link=(Element)(systemorgmap.selectionModel.lastData);
					Registry.register("label", link.getClient("code").toString());
					Registry.register("linerate", link.getClient("linerate").toString());
					Registry.register("systemcode", link.getClient("systemname").toString());
					Application.application.openModel(e.currentTarget.caption, false);
				}
				/**
				 * 
				 *alert对应复用段存储信息
				 * @param e
				 * 
				 */
				private function itemSelectHandler_info(e:ContextMenuEvent):void
				{
					var element:IElement=(Element)(systemorgmap.selectionModel.lastData);
					if(element is Link){
					var temp:String;
					temp+="eqname:"+element.getClient("equip_a_name")+"eqname:"+element.getClient("equip_a")+
					"eqname:"+element.getClient("equip_z")+"eqname:"+element.getClient("labelname")+"eqname:"+element.getClient("linerate")+"eqname:"
					+element.getClient("code");
					
					Alert.show(temp);
					}
					else
						Alert.show("fail to show");
				}
				/**
				 * 
				 *从db中查询数据信息并返回光纤路径数，并进行link添加
				 * @param e
				 * 
				 */
				private function itemSelectHandler_modlink(e:ContextMenuEvent):void
				{
					
					var element:IElement=(Element)(systemorgmap.selectionModel.lastData);
					if(element is Link){
						var node_a:Node=null;
						var node_z:Node=null;
						node_a=systemorgmap.elementBox.getDataByID(element.getClient("equip_a")) as Node;
						node_z=systemorgmap.elementBox.getDataByID(element.getClient("equip_z")) as Node;
						var remoteObject:RemoteObject=new RemoteObject("resNetDwr");
							remoteObject.endpoint = ModelLocator.END_POINT;
							remoteObject.showBusyCursor = true;
							remoteObject.QueryRoutebyEquip(element.getClient("equip_a"),element.getClient("equip_z"));
							remoteObject.addEventListener(ResultEvent.RESULT,modLinkResult);
							Application.application.faultEventHandler(remoteObject);
					}
					else
						Alert.show("fail to show");
				}
				public function modLinkResult(event:ResultEvent):void{
					var element:IElement=(Element)(systemorgmap.selectionModel.lastData);
					var node_a:Node=null;
					var node_z:Node=null;
					
					node_a=systemorgmap.elementBox.getDataByID(element.getClient("equip_a")) as Node;
					node_z=systemorgmap.elementBox.getDataByID(element.getClient("equip_z")) as Node;
					var handler:Array;
					handler=event.result.toString().split(";;");
					//handler.
					for(var x:int=0;x<handler.length-1;x++)
					{
						
						//Alert.show(handler[x]);
						var link:Link=new Link(handler[x],node_a, node_z);
						link.toolTip=(x+1).toString()+":"+handler[x];
						link.setStyle(Styles.LINK_BUNDLE_ID, "bundle_route");
						link.setStyle(Styles.LINK_WIDTH,5);
						link.setStyle(Styles.LINK_BUNDLE_OFFSET, 25);
						link.setStyle(Styles.LINK_BUNDLE_GAP,15);
						link.setStyle(Styles.LINK_BUNDLE_EXPANDED, true);
						link.setStyle(Styles.LINK_TYPE,Consts.LINK_TYPE_HORIZONTAL_VERTICAL);
						//set color attribute.if u need frequent change,extract it as an independent method
						var tp:String=handler[x].toString();
						if(tp.search("10G")!=-1){
							link.setStyle(Styles.INNER_COLOR,0xee1111);
						}
						else if(tp.search("2.5G")!=-1){
							link.setStyle(Styles.INNER_COLOR,0x008000);
						}
						else if(tp.search("622M")!=-1){
						
							link.setStyle(Styles.INNER_COLOR,0x800080);
						}
						else if(tp.search("155M")!=-1){
							link.setStyle(Styles.INNER_COLOR,0x000000);
						}		

						systemorgmap.elementBox.add(link);	
						tplink.push(link);
						//systemorgmap.elementBox.
					}
					//Alert.show(handler[x]);
					
				
					
				}
				
				
				private function itemSelectHandler_LinkDel(e:ContextMenuEvent):void{
					var link:Link=(Element)(systemorgmap.selectionModel.lastData);
					
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
					
					
					var link:Link=(Element)(systemorgmap.selectionModel.lastData);
					
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
				
				public  function route(asa:String):void
				{
					//meiyoujindaogaifangfa 
					
					systemorgmap.elementBox.selectionModel.clearSelection();
					var str:String = asa;	
					var arr:Array = str.split("-->");
					for(var i:int=0; i<arr.length; i++){
						var equip_node:Node=dataBox.getDataByID((arr[i]).toString()) as Node;
						
						if(equip_node!=null)
						{
							systemorgmap.selectionModel.appendSelection(equip_node);	
							equip_node.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
							//值设为0，清除黄色背景框 xgyin
							equip_node.setStyle(Styles.VECTOR_FILL_ALPHA, 0);
							equip_node.setStyle(Styles.VECTOR_FILL_COLOR, 0xFF6600);
							systemorgmap.centerByLogicalPoint(equip_node.centerLocation.x,equip_node.centerLocation.y);
						}
						
						
					}
					
					for(var i:int=arr.length; i>0; i--){
						
						systemorgmap.elementBox.forEach(function(element:IElement):void
						{	
							if(element is Link)
							{
								
								var link:Link=element as Link;
								if(link.toNode.id.toString()==arr[i-1]&&link.fromNode.id.toString()==arr[i]){
									
									link.setStyle(Styles.SELECT_COLOR,"0xFF6600");
									link.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
									link.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
									link.setStyle(Styles.VECTOR_FILL_COLOR, 0x7697C9);
									systemorgmap.elementBox.selectionModel.appendSelection(link);//显示不完全 有问题 mawj
								}
								if(link.toNode.id.toString()==arr[i]&&link.fromNode.id.toString()==arr[i-1]){
									
									link.setStyle(Styles.SELECT_COLOR,"0xFF6600");
									
									link.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
									link.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
									link.setStyle(Styles.VECTOR_FILL_COLOR, 0x7697C9);
									systemorgmap.elementBox.selectionModel.appendSelection(link);//显示不完全 有问题 mawj
								}
								
							}		
							
						});
					}
					
					for(var i:int=0; i<arr.length-1; i++){
						
						systemorgmap.elementBox.forEach(function(element:IElement):void
						{	
							if(element is Link)
							{
								
								var link:Link=element as Link;
								if(link.toNode.id.toString()==arr[i+1]&&link.fromNode.id.toString()==arr[i]){
									
									link.setStyle(Styles.SELECT_COLOR,"0xFF6600");
									link.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
									link.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
									link.setStyle(Styles.VECTOR_FILL_COLOR, 0x7697C9);
									systemorgmap.elementBox.selectionModel.appendSelection(link);//显示不完全 有问题 mawj
								}
								if(link.toNode.id.toString()==arr[i]&&link.fromNode.id.toString()==arr[i+1]){
									
									link.setStyle(Styles.SELECT_COLOR,"0xFF6600");
									
									link.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
									link.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
									link.setStyle(Styles.VECTOR_FILL_COLOR, 0x7697C9);
									systemorgmap.elementBox.selectionModel.appendSelection(link);//显示不完全 有问题 mawj
								}
								
							}		
							
						});
					}
				}
				
				private function onDragEnter(event:DragEvent):void
				{
					if (event.dragInitiator is Tree)
					{
						var ds:DragSource=event.dragSource;
						if (!ds.hasFormat("treeItems"))
							return; // no useful data
						if (ds.dataForFormat("treeItems")[0].@leaf == false)
							return;
						
					}
					// if the tree passes or the dragInitiator is not a tree, accept the drop
					DragManager.acceptDragDrop(UIComponent(event.currentTarget));
				}
				
				
				private function onDragOver(event:DragEvent):void
				{
					if (event.dragInitiator is Tree)
					{
						DragManager.showFeedback(DragManager.COPY);
					}
					else
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
					var centerLocation:Point=systemorgmap.getLogicalPoint(event as MouseEvent);;
					//					if(acc.selectedIndex==0)//传输设备
					//					{
					//						matchStr="treeItems";
					//						node1=dataBox.getDataByID(ds.dataForFormat(matchStr)[0].@code) as Node;
					//						if(node1==null)//该设备在系统中不存在
					//						{
					//							Alert.show("确认将该设备关联到该系统中吗?", "关联系统",3,this,function addEquipReSys(event:CloseEvent):void
					//							{
					//								if(event.detail == Alert.YES) 
					//								{ 
					//									if(tree.selectedItem==null){
					//										return;
					//									}
					//									var code:String=ds.dataForFormat(matchStr)[0].@code;
					//									var systemcode:String =tree.selectedItem.@code;
					//									var rtobj1:RemoteObject=new RemoteObject("fiberWire");
					//									rtobj1.endpoint=ModelLocator.END_POINT;
					//									rtobj1.showBusyCursor=true;
					//									rtobj1.addEquipToSystem(systemcode,code);					
					//									//添加设备到图中
					//									arrPicName=String(ds.dataForFormat(matchStr)[0].@source).split("/");
					//									picName=arrPicName[arrPicName.length - 1];
					//									if (picName == "noIcon.png")
					//										return;
					//									node1=new Node();
					//									nodeId=node1.id;
					//									
					//									label=ds.dataForFormat(matchStr)[0].@label;
					//									
					//									node1.setClient("code",code);
					//									node1.name=label;
					//									vendor=ds.dataForFormat(matchStr)[0].@vendor;
					//									x_model=ds.dataForFormat(matchStr)[0].@x_model;
					//									node1.setClient("vendor", vendor);
					//									node1.setClient("x_model", x_model);
					//									if((vendor=="ZY0810"&&x_model=="虚拟") || x_model == "xunizhandian")
					//									{
					//										node1.image="twaverImages/device/xunishebei.png";
					//										node1.icon="twaverImages/device/xunishebei.png";
					//										node1.setClient("NodeType","virtualequip");
					//									}
					//									else
					//									{
					//										var re1:RegExp = new RegExp("/", "g"); 
					//										var img_x_model:String=x_model.replace(re1,"");
					//										var re2:RegExp = new RegExp(" ", "g"); 
					//										img_x_model=img_x_model.replace(re2,"");
					//										node1.image="twaverImages/device/"+vendor+"-"+img_x_model+".png";
					//										node1.icon="twaverImages/device/"+vendor+"-"+img_x_model+".png";	
					//										node1.setClient("NodeType","equipment");	
					//										
					//									}
					//									node1.setClient("parent", tree.selectedItem.@code);
					//									node1.toolTip=ds.dataForFormat(matchStr)[0].@equiplabel;
					//									node1.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
					//									node1.setStyle(Styles.SELECT_COLOR,"0x00FF00");
					//									node1.setStyle(Styles.SELECT_WIDTH,'10');
					//									node1.centerLocation=centerLocation;
					//									node1.setClient("parent_x", tree.selectedItem.@x_coordinate);
					//									node1.setClient("parent_y", tree.selectedItem.@y_coordinate);
					//									node1.setSize(82,63);	
					//									systemorgmap.elementBox.add(node1);
					//									//添加设备与图中已有设备之间的复用段
					//									var equip_connections:String=ds.dataForFormat(matchStr)[0].@connections;
					//									
					//									var connections:Array=equip_connections.split("$$");
					//									for (var j:int=0; j < connections.length - 1; j++)
					//									{
					//										var connection:Array=connections[j].split("@@");
					//										var connectequipcode:String=connection[0];
					//										var linkid:String=connection[1];
					//										//	var linkNodes:Array=linkid.split("#");
					//										var linkNode:Node=systemorgmap.elementBox.getDataByID(connectequipcode) as Node;
					//										if(linkNode!=null)
					//										{
					//											var link:Link;												
					//											link=new Link(node1, linkNode);
					//											link.setClient("code",linkid);								
					//											//添加复用段到图中						
					//											link.setStyle(Styles.LINK_COLOR, 0x009900);				
					//											link.setStyle(Styles.LINK_BUNDLE_EXPANDED, false);
					//											link.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
					//											link.setStyle(Styles.SELECT_COLOR,"0x00FF00");
					//											link.setStyle(Styles.SELECT_WIDTH,'10');
					//											systemorgmap.elementBox.add(link);
					//										}
					//										
					//									}
					//									var hasdelete:Boolean=false;	
					//									
					//									for (var i:int=0;i<DeviceXML.children().length();i++)
					//									{
					//										if(hasdelete)
					//										{
					//											break;
					//										}
					//										else
					//										{
					//											for (var k:int=0;k<DeviceXML.children()[i].children().length();k++)
					//											{
					//												if(DeviceXML.children()[i].children()[k].@code == code ) 
					//												{
					//													delete DeviceXML.folder.folder[k];
					//													hasdelete=true;
					//													break;
					//												}
					//											}
					//										}
					//										
					//									}
					//								} 
					//							});
					//							
					//						}
					//						
					//					}
					//					else 
					if(acc.selectedIndex==0)//设备模板
					{
						matchStr="items";
						//添加设备到图中				
						arrPicName=String(ds.dataForFormat(matchStr)[0].@source).split("/");
						picName=arrPicName[arrPicName.length - 1];
						if (picName == "noIcon.png")
							return;
						node1=new Node();
						nodeId=node1.id;
						
						label=ds.dataForFormat(matchStr)[0].@label;	
						node1.name=label;
						vendor=ds.dataForFormat(matchStr)[0].@vendor;
						x_model=ds.dataForFormat(matchStr)[0].@x_model;
						node1.setClient("vendor", vendor);
						node1.setClient("x_model", x_model);
						node1.setClient("NodeType","equipment");	
						var re1:RegExp = new RegExp("/", "g"); 
						var img_x_model:String=x_model.replace(re1,"");
						var re2:RegExp = new RegExp(" ", "g"); 
						img_x_model=img_x_model.replace(re2,"");
						node1.image="twaverImages/device/"+vendor+"-"+img_x_model+".png";
						node1.icon="twaverImages/device/"+vendor+"-"+img_x_model+".png";	
						node1.setClient("parent", tree.selectedItem.@code);
						
						node1.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
						node1.setStyle(Styles.SELECT_COLOR,"0x00FF00");
						node1.setStyle(Styles.SELECT_WIDTH,'10');
						node1.centerLocation=centerLocation;
						node1.setClient("parent_x", tree.selectedItem.@x_coordinate);
						node1.setClient("parent_y", tree.selectedItem.@y_coordinate);
						node1.setSize(82,63);	
						systemorgmap.elementBox.add(node1);
						openAddEquipWin(label, vendor, x_model,node1);
					}
						
					else
					{
						Alert.show('此设备在视图中已存在，请选择其它设备！', '提示');
					}
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
				
				private function tree_itemClick(evt:ListEvent):void
				{
					
					var item:Object=Tree(evt.currentTarget).selectedItem;
					
					if (deviceTree.dataDescriptor.isBranch(item))
					{
						
						deviceTree.expandItem(item, !deviceTree.isItemOpen(item), true);
					}
					
				}
				
				/**
				 *在当前展开的系统树中搜索某个设备 
				 * @param equipname
				 * @return 
				 * 
				 */
				private function searchEquipInSysTree(equipname:String):XML
				{
					
					var xmllist:*=tree.dataProvider;
					var xmlcollection:XMLListCollection=xmllist;	
					var exist:Boolean=false;
					var equipxml:XML=null;
					
					for each(var vendorelement:XML in xmlcollection.children())
					{
						for each(var syselement:XML in vendorelement.children())
						{
							
							for each(var equipelement:XML in syselement.children())
							{		
								
								if ((equipelement.@name).toUpperCase() .indexOf(equipname.toUpperCase()) != -1)
								{
									
									
									equipxml=equipelement;
									exist=true;							
									break;
								}
							}
							if(exist)
							{
								break;
							}
						}
						if(exist)
						{
							break;
						}
					}
					
					return equipxml;
				}
				private function enter():void
				{
					//							seach();
					querychildren();
					//							if(searchText.txt.text!=null&&searchText.txt.text!="")
					//							{
					//								var equip:XML=searchEquipInSysTree(searchText.txt.text);
					//								if(equip==null)
					//								{
					//									Alert.show("在当前展开的系统中不存在该设备！","提示");
					//								}
					//								else
					//								{
					//									tree.selectedItem=equip;
					//								}
					//							}
					//	通过后台搜索匹配的设备
					//	var rt:RemoteObject = new RemoteObject("fiberWire");
					//	rt.endpoint = ModelLocator.END_POINT;
					//	rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
					//		tree.dataProvider = null;
					//		tree.dataProvider = new XMLList(event.result.toString()); 
					//	});
					//	refreshArray.splice(0);
					//	relate_system_array.splice(0);
					//	dataBox.clear();
					//	if(searchText.txt.text!=null&&searchText.txt.text!="")
					//	{
					//			
					//		rt.getSearchTree(searchText.txt.text);
					//		
					//	}else
					//	{
					////		rt.addEventListener(ResultEvent.RESULT, generateSysTreeInfo);
					//		rt.getSystemTree();
					//	}
					
				}
				private function enter1():void
				{
					findSelectEquip();
				}
				
				private var xmlDeviceModel:XMLList=new XMLList();
				[Bindable]
				private var xmlListColl:XMLListCollection=new XMLListCollection();
				
				private function accordionChange():void
				{
					if (acc.selectedIndex&& xmlDeviceModel.children().length() == 0)
					{
						
						var roDeviceModel:RemoteObject=new RemoteObject("fiberWire");
						roDeviceModel.endpoint=ModelLocator.END_POINT;
						roDeviceModel.showBusyCursor=true;
						roDeviceModel.addEventListener(ResultEvent.RESULT, getDeviceModelHandler);
						parentApplication.faultEventHandler(roDeviceModel);
						roDeviceModel.getDeviceModel();
					}
				}
				/**
				 *点击右侧功能按钮的处理函数 
				 * @param event
				 * 
				 */
				private function vb_selectedItemEventHandler(event:selectedItemEvent):void
				{
					
					
					if(event.selectedIndex==0&&xmlDeviceModel.children().length() == 0)
					{
						var roDeviceModel:RemoteObject=new RemoteObject("fiberWire");
						roDeviceModel.endpoint=ModelLocator.END_POINT;
						roDeviceModel.showBusyCursor=true;
						roDeviceModel.addEventListener(ResultEvent.RESULT, getDeviceModelHandler);
						parentApplication.faultEventHandler(roDeviceModel);
						roDeviceModel.getDeviceModel();//从后台请求设备模板列表数据
					}
				}
				
				
				/**
				 *从后台请求设备模板列表数据返回结果处理函数 
				 * @param event
				 * 
				 */
				private function getDeviceModelHandler(event:ResultEvent):void
				{
					xmlDeviceModel=XMLList(event.result);
					xmlListColl.source=xmlDeviceModel.model;
				}
				
				
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
					var node:Node=(Element)(systemorgmap.selectionModel.lastData);
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
					element=(Element)(systemorgmap.selectionModel.lastData);
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
					if(systemorgmap.selectionModel.count==1)
						var element:* = systemorgmap.selectionModel.selection.getItemAt(0);
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
						var node:Node=(Element)(systemorgmap.selectionModel.lastData);
						var systemcode:String=node.getClient("parent").toString();
						var equipcode:String=node.getClient("code").toString();
						var roDeleteEquip:RemoteObject=new RemoteObject("fiberWire");
						roDeleteEquip.endpoint=ModelLocator.END_POINT;
						roDeleteEquip.showBusyCursor=true;
						roDeleteEquip.addEventListener(ResultEvent.RESULT, function(e:ResultEvent):void
						{
							var node:Node=(Element)(systemorgmap.selectionModel.lastData);
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
				//				private var gxCheckBox:CheckBox ;
				public function createCheckBox(name:String,changeHandler:Function):CheckBox{
					var chk:CheckBox = new CheckBox();
					chk.label =name;	
					chk.id =name;
					chk.selected = false;
					
					chk.addEventListener(Event.CHANGE,changeHandler);
					//					if(name=="呈现光迅信息"){
					//						chk.visible = false;
					//						gxCheckBox = chk;
					//					}
					return chk;
				}
				
				protected function checkbox_changeHandler(event:Event):void
				{
					if(networkContent==null||networkContent=="")
					{
						networkContent=serializer.serialize();
					}
					
					if(CheckBox(event.currentTarget).label=='圆形布局')
					{			
						if(CheckBox(event.currentTarget).selected)
						{
							changeSelect(CheckBox(event.currentTarget).label);
							var autoLayouter:AutoLayouter = new AutoLayouter(systemorgmap);
							autoLayouter.animate = true;
							autoLayouter.doLayout(Consts.LAYOUT_ROUND);
							
						}
						else
						{
							serializer.deserialize(networkContent);
							networkContent="";
						}
					}
					if(CheckBox(event.currentTarget).label=='星形布局')
					{			
						if(CheckBox(event.currentTarget).selected)
						{
							changeSelect(CheckBox(event.currentTarget).label);
							var autoLayouter:AutoLayouter = new AutoLayouter(systemorgmap);
							autoLayouter.animate = true;
							autoLayouter.doLayout(Consts.LAYOUT_SYMMETRY);
							for each(var item:* in toolbar.getChildren())
							{
								if(item is ButtonBar )
								{	
									for each (var btn:* in (item as ButtonBar).getChildren())
									{ 
										
										if(btn.label=='保存设备')
										{
											btn.enabled=false;
											
										}
									}
									
									
								}
							}
							
							
							
						}
						else
						{
							serializer.deserialize(networkContent);
							networkContent="";
							for each(var item:* in toolbar.getChildren())
							{
								if(item is ButtonBar )
								{	
									for each (var btn:* in (item as ButtonBar).getChildren())
									{ 
										
										if(btn.label=='保存设备')
										{
											btn.enabled=true;
											
										}
									}
									
									
								}
							}
						}
					}
					if(CheckBox(event.currentTarget).label=='弹性布局')
					{			
						if(CheckBox(event.currentTarget).selected)
						{
							changeSelect(CheckBox(event.currentTarget).label);
							springLaouter = new SpringLayouter(systemorgmap);
							springLaouter.start();
							for each(var item:* in toolbar.getChildren())
							{
								if(item is ButtonBar )
								{	
									for each (var btn:* in (item as ButtonBar).getChildren())
									{ 
										
										if(btn.label=='保存设备')
										{
											btn.enabled=false;
											
										}
									}
									
									
								}
							}
							
						}
						else
						{
							if(springLaouter!=null)
							{
								springLaouter.stop();
							}
							serializer.deserialize(networkContent);
							networkContent="";
							for each(var item:* in toolbar.getChildren())
							{
								if(item is ButtonBar )
								{	
									for each (var btn:* in (item as ButtonBar).getChildren())
									{ 
										
										if(btn.label=='保存设备')
										{
											btn.enabled=true;
											
										}
									}
									
									
								}
							}
							
						}
					}
					
				}
				
				private function checkbox_alarmHandler(event:Event):void
				{
					var value:String="";
					for each(var item:* in toolbar.getChildren())
					{
						if(item is CheckBox&& item.label=='呈现所有告警')
						{			
							if(item.selected)
							{
								//								setAlarmShow();
								alarm_all=true;
								systemorgmap.elementBox.forEach(function(element:IElement):void{
									if(element is Node&&element.getClient("NodeType")=="equipment")
									{
										var alarmcount:String=element.getClient("alarmcount");
										var alarmlevel:String=element.getClient("alarmlevel");
										element.alarmState.setNewAlarmCount(AlarmSeverity.getByValue(int(alarmlevel)),int(alarmcount));
									}
								});
							}
							else{
								alarm_all=false;
								systemorgmap.elementBox.forEach(function(element:IElement):void{
									if(element is Node && element.getClient("NodeType")=="equipment")
									{
										element.alarmState.clear();
									}
								});
							}
						}
					}
				}
				//设置选中呈现告警
				public function setAlarmShow():void{
					alarm_all=true;
					var str:int = 1;
					for each(var item:* in toolbar.getChildren())
					{
						if(item is CheckBox&& item.label=='呈现所有告警')
						{		
							(item as CheckBox).selected=true;	
							systemorgmap.elementBox.forEach(function(element:IElement):void{
								if(element is Node&&element.getClient("NodeType")=="equipment")
								{	
									var alarmcount:String=element.getClient("alarmcount");
									var alarmlevel:String=element.getClient("alarmlevel");
									//									if(int(alarmcount)>0&&str==1){
									//										Alert.show("---"+alarmcount);
									//									}
									//									str++;
									element.alarmState.setNewAlarmCount(AlarmSeverity.getByValue(int(alarmlevel)),int(alarmcount));
								}
							});
						}
					}
				}
				
				private function changeSelect(flag:String):void
				{
					if(springLaouter!=null){
						springLaouter.stop();
					}
					for each(var item:* in toolbar.getChildren())
					{
						if(item is CheckBox&& item.label!='呈现所有告警'&&item.label!=flag)
						{		
							CheckBox(item).selected=false;
						}	
					}
				}
				
				/**
				 *当双击左侧系统树中的设备时在network中选中它 
				 * @param event
				 * 
				 */
				private function wangyuan(id:String):void
				{     
					var equip_node:Node=dataBox.getDataByID(id) as Node;
					if(equip_node!=null)
					{
						systemorgmap.selectionModel.clearSelection();
						systemorgmap.selectionModel.appendSelection(equip_node);
						
						equip_node.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
						equip_node.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
						equip_node.setStyle(Styles.VECTOR_FILL_COLOR, 0x7697C9);
						systemorgmap.centerByLogicalPoint(equip_node.centerLocation.x,equip_node.centerLocation.y);
					}
				}
			  
				
				private function tree_doubleClickHandler(event:MouseEvent):void
				{    
					var item:Object=Tree(event.currentTarget).selectedItem;
					if(item!=null)
					{
						var equip_node:Node=dataBox.getDataByID((item.@code).toString()) as Node;
						//Alert.show("sa"+equip_node.name);
						//Alert.show("aaa"+currSystemName);
						if(equip_node!=null)
						{
							systemorgmap.selectionModel.clearSelection();
							systemorgmap.selectionModel.appendSelection(equip_node);
							
							equip_node.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
							equip_node.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
							equip_node.setStyle(Styles.VECTOR_FILL_COLOR, 0x7697C9);
							systemorgmap.centerByLogicalPoint(equip_node.centerLocation.x,equip_node.centerLocation.y);
						}
					}
				}
				/**
				 *搜索框点击处理函数 
				 * @param event
				 * 
				 */
				private function searchText_clickHandler1(event:Event):void
				{
					findSelectEquip();
				}
				private function findSelectEquip():void
				{
					if(searchText1.txt.text!=null&&searchText1.txt.text!="")
					{
						tileSearch.dataProvider=null;
						var equipList:String=searchEquipInSys(searchText1.txt.text);
						if(equipList.length<1)
						{
							Alert.show("在当前展开的系统中不存在该设备！","提示");
						}
						else
						{
							tileSearch.dataProvider=new XMLList(equipList);
						}
					}
				}
				
				private function searchEquipInSys(name:String):String
				{
					var listString:String="";
					systemorgmap.elementBox.forEach(function(element:IElement):void
					{
						if(element is Node)
						{
							var node:Node=element as Node;
							if(node.name.indexOf(name)>-1)
							{
								listString+="<folder label='"+node.name+"' code='"+node.id+"'></folder>";	
							}
						}
					});
					return listString;
				}
				protected function tileSearch_itemDoubleClickHandler(event:ListEvent):void
				{
					if(tileSearch.selectedItem)
					{
						systemorgmap.elementBox.forEach(function(element:IElement):void
						{
							if(element is Node)
							{
								var node:Node=element as Node;
								if(node.id==tileSearch.selectedItem.@code)
								{
									systemorgmap.elementBox.selectionModel.clearSelection();
									systemorgmap.elementBox.selectionModel.appendSelection(node);
									systemorgmap.centerByLogicalPoint(node.centerLocation.x,node.centerLocation.y);
									if(tree_selectedNode)
									{
										
										for each(var xml:XML in XMLData.children())
										{
											if(xml.@code == tree_selectedNode.@code)
											{
												for each(var x:XML in tree_selectedNode.children())
												{
													if(x.@code == tileSearch.selectedItem.@code)
													{
														tree.selectedItem = x;
														tree.scrollToIndex(tree.getItemIndex(x));
													}
												}
											}											
										}
									}
									return;
								}
							}
						});
						
						
					}
				}
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
												systemorgmap.selectionModel.clearSelection();
												systemorgmap.selectionModel.appendSelection(equip_node);
												equip_node.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
												equip_node.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
												equip_node.setStyle(Styles.VECTOR_FILL_COLOR, 0x7697C9);
												systemorgmap.centerByLogicalPoint(equip_node.centerLocation.x,equip_node.centerLocation.y);
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
				
				
				//自定义
				
				protected function cob1_changeHandler(event:ListEvent):void
				{   
					Alert.show("7890j");
					vb.currentState="hide";
					systemorgmap.elementBox.selectionModel.clearSelection();
					var str:String=eqp_Analysis.selectedLabel.toString();
					if( eqp_Analysis.selectedIndex==0)
					{
						dgEquip.visible=false; dgEquip.width=0;  //我的 网元高阶、低阶利用率分析分别隐藏
						dgEquipInfo.visible=false; dgEquipInfo.width=0; dgEquipInfo.height=0;//我的
						dgEquip_1.visible=false; dgEquip_1.width=0;  //我的 网元高阶、低阶利用率分析分别隐藏
						dgEquipInfo_1.visible=false; dgEquipInfo_1.width=0; dgEquipInfo_1.height=0;//我的 
						dataGrid1.visible=false;
						dataGrid1.width=0;
						arrayCollection=null;
					}				
					if(str == "VC12穿通通道利用率分析"){//cai
						//refreshSystems();
						eqp_Analysis.selectedIndex=1;
						dataGrid1.visible=false;
						dataGrid1.width=0;
						arrayCollection=null;
						dgEquip_1.visible=false; dgEquip_1.width=0;  //我的 网元高阶、低阶利用率分析分别隐藏
						dgEquipInfo_1.visible=false; dgEquipInfo_1.width=0; dgEquipInfo_1.height=0;//我的 
				/*		cob.visible="false";
						cob.width=0;*/
						 var syscode:String=currSystemName;
						 Alert.show(syscode);
						 if(syscode=="")
						 {
							 Alert.show("没有选择系统，请先选择系统再继续！");
							 eqp_Analysis.selectedIndex=0;
						 }
						 if(!syscode=="")
						 {
						if(currSystemName=="广州供电局华为A网")
						  {
							syscode="SDH";
						  }
						dgEquip.visible=true; dgEquip.width=169.8;
						dgEquipInfo.visible=false; dgEquipInfo.width=0; dgEquipInfo.height=0;
						var ro:RemoteObject = new RemoteObject("tuopu");
						ro.endpoint = ModelLocator.END_POINT;
						ro.showBusyCursor = true;
						ro.addEventListener(ResultEvent.RESULT,ResultGetDevInfo);
						ro.getName(syscode);
						 }
					}else if(str == "VC4穿通通道利用率分析"){
						//refreshSystems();
						eqp_Analysis.selectedIndex=2;
						dataGrid1.visible=false;
						dataGrid1.width=0;
						arrayCollection=null;
						dgEquip_1.visible=false; dgEquip_1.width=0;  //我的 网元高阶、低阶利用率分析分别隐藏
						dgEquipInfo_1.visible=false; dgEquipInfo_1.width=0; dgEquipInfo_1.height=0;//我的 
						/*		cob.visible="false";
						cob.width=0;*/
						var syscode:String=currSystemName;
						if(syscode=="")
						{
							Alert.show("没有选择系统，请先选择系统再继续！");
							eqp_Analysis.selectedIndex=0;
						}
						if(!syscode=="")
						{
							if(currSystemName=="广州供电局华为A网")
							{
								syscode="SDH";
							}
							dgEquip.visible=true; dgEquip.width=169.8;
							dgEquipInfo.visible=false; dgEquipInfo.width=0; dgEquipInfo.height=0;
							var ro1:RemoteObject = new RemoteObject("tuopu");
							ro1.endpoint = ModelLocator.END_POINT;
							ro1.showBusyCursor = true;
							ro1.addEventListener(ResultEvent.RESULT,ResultGetDevInfo);
							ro1.getName_vc4(syscode);
						}
					}else if(str == "VC3穿通通道利用率分析"){
						//refreshSystems();
						eqp_Analysis.selectedIndex=3;
						dataGrid1.visible=false;
						dataGrid1.width=0;
						arrayCollection=null;
						dgEquip_1.visible=false; dgEquip_1.width=0;  //我的 网元高阶、低阶利用率分析分别隐藏
						dgEquipInfo_1.visible=false; dgEquipInfo_1.width=0; dgEquipInfo_1.height=0;//我的 
						/*		cob.visible="false";
						cob.width=0;*/
						var syscode:String=currSystemName;
						if(syscode=="")
						{
							Alert.show("没有选择系统，请先选择系统再继续！");
							eqp_Analysis.selectedIndex=0;
						}
						if(!syscode=="")
						{
							if(currSystemName=="广州供电局华为A网")
							{
								syscode="SDH";
							}
							dgEquip.visible=true; dgEquip.width=169.8;
							dgEquipInfo.visible=false; dgEquipInfo.width=0; dgEquipInfo.height=0;
							var ro2:RemoteObject = new RemoteObject("tuopu");
							ro2.endpoint = ModelLocator.END_POINT;
							ro2.showBusyCursor = true;
							ro2.addEventListener(ResultEvent.RESULT,ResultGetDevInfo);
							ro2.getName_vc3(syscode);
						}
					}
					
					
					
					if(str=="端口高阶利用率分析"||str=="端口低阶利用率分析"){
						
						if(str=="端口高阶利用率分析")
						{
							refreshSystems();
							eqp_Analysis.selectedIndex=4;
						
						}
						if(str=="端口低阶利用率分析")
						{
							refreshSystems();
							eqp_Analysis.selectedIndex=5;		
						}
						dataGrid1.visible=false;
						dataGrid1.width=0;
						arrayCollection=null;
						dgEquip.visible=false; dgEquip.width=0;  //我的 网元高阶、低阶利用率分析分别隐藏
						dgEquipInfo.visible=false; dgEquipInfo.width=0; dgEquipInfo.height=0;//我的
						var syscode:String=currSystemName;
						if(syscode=="")
						{
							Alert.show("没有选择系统，请先选择系统再继续！");
							eqp_Analysis.selectedIndex=0;
						}
						if(syscode!=""){
							dgEquip_1.visible=true; dgEquip_1.width=169.8
							dgEquipInfo_1.visible=false; dgEquipInfo_1.width=0; dgEquipInfo_1.height=0;//我的
							
							var eqpInfoArr:Array  = new Array();
							for (var i:int=0; i < Shared.equips.length; i++) //遍历所有节点
							{	
								var equip:Object=Shared.equips[i] as Object;	
								var S_SBMC:String = equip.equipname;
								eqpInfoArr[i]=S_SBMC;
							}
							
							var ro1:RemoteObject = new RemoteObject("EquipName");
							ro1.endpoint = ModelLocator.END_POINT;
							ro1.showBusyCursor = true;
							ro1.addEventListener(ResultEvent.RESULT,ResultGetDevInfo_1);
							ro1.getDevPort(eqpInfoArr);	
							
						}
					}	
					if(eqp_Analysis.selectedLabel.toString()=="设备高阶交叉剩余能力分析"){
						refreshSystems();
						eqp_Analysis.selectedIndex=4;
						dgEquip.visible=false; dgEquip.width=0;  //我的 网元高阶、低阶利用率分析分别隐藏
						dgEquipInfo.visible=false; dgEquipInfo.width=0; dgEquipInfo.height=0;//我的
						dgEquip_1.visible=false; dgEquip_1.width=0;  //我的 网元高阶、低阶利用率分析分别隐藏
						dgEquipInfo_1.visible=false; dgEquipInfo_1.width=0; dgEquipInfo_1.height=0;//我的 
						var syscode:String=currSystemName;
						if(syscode=="")
						{
							Alert.show("没有选择系统，请先选择系统再继续！");
							eqp_Analysis.selectedIndex=0;
						}
						if(!syscode=="")
						{
						colum2.headerText="总高阶";
						dataGrid1.visible=true;
						dataGrid1.width=169.8;

						arrayCollection=null;
						cob.selectedIndex=0;
						eqp_Analysis.selectedIndex=1;
						cob_add.visible=false;
						cob_add.width=0;
						cob_add.selectedIndex=0;
						K_Analysis.removeAll();
						dgEquip.visible=false; dgEquip.width=0;  //我的 网元高阶、低阶利用率分析分别隐藏
						dgEquipInfo.visible=false; dgEquipInfo.width=0; dgEquipInfo.height=0;//我的
						
						dgEquip_1.visible=false; dgEquip_1.width=0;  //我的 网元高阶、低阶利用率分析分别隐藏
						dgEquipInfo_1.visible=false; dgEquipInfo_1.width=0; dgEquipInfo_1.height=0;//我的
						
						eqp_Analysis.selectedIndex=1;
						var rtobj:RemoteObject=new RemoteObject("fiberWire");
						rtobj.endpoint=ModelLocator.END_POINT;
						rtobj.showBusyCursor=true;
						parentApplication.faultEventHandler(rtobj);
						rtobj.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void
						{
							
							systemorgmap.elementBox.clear();
							var xml:String=event.result.toString();
							var equips:Array=(JSON.decode(xml.split("---")[0].toString()) as Array); //获取该系统的设备数组
							var business_n:Array=(JSON.decode(xml.split("---")[1].toString()) as Array); //获取业务             //liao
							var ocables:Array=(JSON.decode(xml.split("---")[2].toString()) as Array); //获取该系统的复用段数组
							var array:Array=new Array();
							for (var i:int=0;i<equips.length;i++){
								var equip:Object=equips[i] as Object;	
								array[i]=equip.equipcode;
							}
							var rtobj661:RemoteObject=new RemoteObject("availability");
							rtobj661.endpoint=ModelLocator.END_POINT;
							rtobj661.showBusyCursor=true;
							rtobj661.getall(array);
							rtobj661.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{								
								arrayCollection=event.result as ArrayCollection;
								
							});
							
							tree_selectedNode= tree.selectedItem as XML;
							var str:String="";
							
							
							for (var i:int=0;i<equips.length;i++)
							{	
								var equip:Object=equips[i] as Object;	
								var exist_node:Node=systemorgmap.elementBox.getDataByID(equip.equipcode) as Node;
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
									systemorgmap.elementBox.add(node);					
									//添加节点node1
									
									var rtobj66:RemoteObject=new RemoteObject("availability");
									rtobj66.endpoint=ModelLocator.END_POINT;
									rtobj66.showBusyCursor=true;
									rtobj66.highavailability1(equip.equipcode);
									rtobj66.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{								
										a= event.result as ArrayCollection;
										
										var t:int=int(a.getItemAt(0).X.toString());
										var n:int=int(a.getItemAt(0).Y.toString());
										
										var node1:Node=new Node();
										node1.location = new Point(t,n-100);
										node1.name ="剩余高阶:"+a.getItemAt(0).ava.toString();
										node1.icon="";
										node1.image="";
										node1.setStyle(Styles.LABEL_SIZE,18);
										node1.setStyle(Styles.LABEL_COLOR,"0xff0000");
										systemorgmap.elementBox.add(node1);	
										
										
									});
									
									
								}
								
							}
							
							//添加第三级节点 
							tree.expandItem(tree_selectedNode, false, true);
							//展开树形节点
							tree_selectedNode.appendChild(new XMLList(str));
							//展开树形节点
							//展开树形结构
							tree.expandItem(tree_selectedNode, true, true);							
							
							
							
							for ( i=0; i < ocables.length; i++) //把系统内部设备之间的复用段
							{
								var ocable:Object=ocables[i] as Object;
								var equip_a:String=ocable.equip_a;
								var system_a:String=ocable.system_a;
								var equip_z:String=ocable.equip_z;
								var equipa_z:String=ocable.equipa_z;               //自定义
								var linkid:String=ocable.label;
								
								
								var system_z:String=ocable.system_z;
								var label:String=ocable.label;
								var labelname:String=ocable.aendptpxx + "-" + ocable.zendptpxx;	
								var node_a:Node=null;
								var node_z:Node=null;
								var existlink:Link=systemorgmap.elementBox.getDataByID(label) as Link;
								//自定义
								
								if(existlink==null)
								{
									node_a=systemorgmap.elementBox.getDataByID(equip_a) as Node;
									node_z=systemorgmap.elementBox.getDataByID(equip_z) as Node;
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
										systemorgmap.elementBox.add(link);	
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
									if(item is CheckBox&& item.label=='呈现所有告警')
									{		
										CheckBox(item).selected=true;
										alarm_all=true;
										systemorgmap.elementBox.forEach(function(element:IElement):void{
											if(element is Node&&element.getClient("NodeType")=="equipment")
											{	
												var alarmcount:String=element.getClient("alarmcount");
												var alarmlevel:String=element.getClient("alarmlevel");
												element.alarmState.setNewAlarmCount(AlarmSeverity.getByValue(int(alarmlevel)),int(alarmcount));
											}
										});
									}
								}
							}
							//居中显示
							if(!showSysGraphAlarm){
								setTimeout(setScrollPosition,500);
							}
							
							systemorgmap.zoom =	0.5917159763313609;
							var fontsize:int=12; //字号	
							fontsize=parseInt((fontsize/0.5917159763313609).toString());		
							var count:int=systemorgmap.elementBox.datas.count; 
							for(var i:int=0;i<count;i++){				
								(systemorgmap.elementBox.datas.getItemAt(i) as Element).setStyle(Styles.LABEL_SIZE,fontsize);  
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
					}
					//自定义
					if(eqp_Analysis.selectedLabel.toString()=="设备低阶交叉剩余能力分析"){
						refreshSystems();
						eqp_Analysis.selectedIndex=5;
						dgEquip.visible=false; dgEquip.width=0;  //我的 网元高阶、低阶利用率分析分别隐藏
						dgEquipInfo.visible=false; dgEquipInfo.width=0; dgEquipInfo.height=0;//我的
						dgEquip_1.visible=false; dgEquip_1.width=0;  //我的 网元高阶、低阶利用率分析分别隐藏
						dgEquipInfo_1.visible=false; dgEquipInfo_1.width=0; dgEquipInfo_1.height=0;//我的 
						var syscode:String=currSystemName;
						if(syscode=="") 
						{
							Alert.show("没有选择系统，请先选择系统再继续！");
							eqp_Analysis.selectedIndex=0;
						}
						if(!syscode=="")
						{
						colum2.headerText="总低阶";
						eqp_Analysis.selectedIndex=2;
						dataGrid1.visible=true;
						dataGrid1.width=169.8;
					
						arrayCollection=null;
						cob.selectedIndex=0;
						cob_add.visible=false;
						cob_add.selectedIndex=0;
						cob_add.width=0;
						vb.currentState="hide";
						eqp_Analysis.selectedIndex=2;
						dgEquip.visible=false; dgEquip.width=0;  //我的 网元高阶、低阶利用率分析分别隐藏
						dgEquipInfo.visible=false; dgEquipInfo.width=0; dgEquipInfo.height=0;//我的
						
						dgEquip_1.visible=false; dgEquip_1.width=0;  //我的 网元高阶、低阶利用率分析分别隐藏
						dgEquipInfo_1.visible=false; dgEquipInfo_1.width=0; dgEquipInfo_1.height=0;//我的
						
			
						
						var rtobj:RemoteObject=new RemoteObject("fiberWire");
						rtobj.endpoint=ModelLocator.END_POINT;
						rtobj.showBusyCursor=true;
						parentApplication.faultEventHandler(rtobj);
						rtobj.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void
						{
							Alert.show("clear a");
							systemorgmap.elementBox.clear();
							var xml:String=event.result.toString();
							var equips:Array=(JSON.decode(xml.split("---")[0].toString()) as Array); //获取该系统的设备数组
							var business_n:Array=(JSON.decode(xml.split("---")[1].toString()) as Array); //获取业务             //liao
							var ocables:Array=(JSON.decode(xml.split("---")[2].toString()) as Array); //获取该系统的复用段数组
							var array1:Array=new Array();
							for (var i:int=0;i<equips.length;i++){
								var equip:Object=equips[i] as Object;	
								array1[i]=equip.equipcode;
							}
							var rtobj662:RemoteObject=new RemoteObject("availability");
							rtobj662.endpoint=ModelLocator.END_POINT;
							rtobj662.showBusyCursor=true;
							rtobj662.getall1(array1);
							rtobj662.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{								
								arrayCollection=event.result as ArrayCollection;
								
							});
							Shared.equips=equips;//设备数组初始 mawj分析
							Shared.ocables=ocables;
							tree_selectedNode= tree.selectedItem as XML;
							var str:String="";
							var wArray:Array=new Array();                    //自定义，存放设备代码
							for (var i:int=0;i<equips.length;i++)
							{	
								
								var equip:Object=equips[i] as Object;	
								wArray[i]=equip.equipcode;
								var exist_node:Node=systemorgmap.elementBox.getDataByID(equip.equipcode) as Node;
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
									systemorgmap.elementBox.add(node);					
									//添加节点node1
									
									var rtobj66:RemoteObject=new RemoteObject("availability");
									rtobj66.endpoint=ModelLocator.END_POINT;
									rtobj66.showBusyCursor=true;
									rtobj66.lowavailability1(equip.equipcode);
									rtobj66.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{								
										a= event.result as ArrayCollection;
										
										var t:int=int(a.getItemAt(0).X.toString());
										var n:int=int(a.getItemAt(0).Y.toString());
										
										var node1:Node=new Node();
										node1.location = new Point(t,n-100);
										node1.name ="剩余低阶:"+a.getItemAt(0).ava.toString();
										node1.icon="";
										node1.image="";
										node1.setStyle(Styles.LABEL_SIZE,18);
										
										node1.setStyle(Styles.LABEL_COLOR,"0xff0000");
										systemorgmap.elementBox.add(node1);	
										
										
									});
									
									
								}
								
							}
							Shared.equipmentcodes=wArray;               //自定义
							//添加第三级节点 
							tree.expandItem(tree_selectedNode, false, true);
							//展开树形节点
							tree_selectedNode.appendChild(new XMLList(str));
							//展开树形节点
							//展开树形结构
							tree.expandItem(tree_selectedNode, true, true);							
							
							
							var tArray = new Array();              //自定义，存放服用段代码
							for ( i=0; i < ocables.length; i++) //把系统内部设备之间的复用段
							{
								var ocable:Object=ocables[i] as Object;
								var equip_a:String=ocable.equip_a;
								var system_a:String=ocable.system_a;
								var equip_z:String=ocable.equip_z;
								var equipa_z:String=ocable.equipa_z;               //自定义
								var linkid:String=ocable.label;
								tArray[i] = equipa_z;
								
								var system_z:String=ocable.system_z;
								var label:String=ocable.label;
								var labelname:String=ocable.aendptpxx + "-" + ocable.zendptpxx;	
								var node_a:Node=null;
								var node_z:Node=null;
								var existlink:Link=systemorgmap.elementBox.getDataByID(label) as Link;
								//自定义
								
								if(existlink==null)
								{
									node_a=systemorgmap.elementBox.getDataByID(equip_a) as Node;
									node_z=systemorgmap.elementBox.getDataByID(equip_z) as Node;
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
										systemorgmap.elementBox.add(link);	
										
									}	
								}		
								
							}
							Shared.linkcodes=tArray;                    //自定义
							/*Alert.show(Shared.linkcodes.length+"长度");*/
							var alarm:String=Registry.lookup("alarm");
							if(alarm!=null)
							{
								Registry.unregister("alarm");
								for each(var item:* in toolbar.getChildren())
								{
									if(item is CheckBox&& item.label=='呈现所有告警')
									{		
										CheckBox(item).selected=true;
										alarm_all=true;
										systemorgmap.elementBox.forEach(function(element:IElement):void{
											if(element is Node&&element.getClient("NodeType")=="equipment")
											{	
												var alarmcount:String=element.getClient("alarmcount");
												var alarmlevel:String=element.getClient("alarmlevel");
												element.alarmState.setNewAlarmCount(AlarmSeverity.getByValue(int(alarmlevel)),int(alarmcount));
											}
										});
									}
								}
							}
							//居中显示
							if(!showSysGraphAlarm){
								setTimeout(setScrollPosition,500);
							}
							//	setTimeout(setScrollPosition,500);
							//加载完成后缩放 字体清晰
							systemorgmap.zoom =	0.5917159763313609;
							var fontsize:int=12; //字号	
							fontsize=parseInt((fontsize/0.5917159763313609).toString());		
							var count:int=systemorgmap.elementBox.datas.count; 
							for(var i:int=0;i<count;i++){				
								(systemorgmap.elementBox.datas.getItemAt(i) as Element).setStyle(Styles.LABEL_SIZE,fontsize);  
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
					}
					
					
					refreshArray("todo");//先查询 再分析
					vb.currentState="hide";
				}
				//分析 mawj分析
				
				
				
				
				
				protected function cob_changeHandler(event:ListEvent):void
				{   	
					
					
					dgEquip.visible=false; dgEquip.width=0;  //我的 网元高阶、低阶利用率分析分别隐藏
					dgEquipInfo.visible=false; dgEquipInfo.width=0; dgEquipInfo.height=0;//我的
					dgEquip_1.visible=false; dgEquip_1.width=0;  //我的 网元高阶、低阶利用率分析分别隐藏
					dgEquipInfo_1.visible=false; dgEquipInfo_1.width=0; dgEquipInfo_1.height=0;//我的 
					dataGrid1.visible=false;
					dataGrid1.width=0;
					arrayCollection=null;
					
					//					if(equipGrid==null){
					//						vb.__btnvisible_click(new MouseEvent(MouseEvent.CLICK));
					//					}
					vb.currentState="show";
					
					
					acc.selectedIndex=3;
					lab.text="";
					diInput.visible = false;
					switch_show.visible=false;
					equipGrid_1.visible=false;
					equipGrid_1.includeInLayout=false;
					ddd.text="";//清空输入值
					//清楚上次分析的结果，xgyin
					systemorgmap.elementBox.selectionModel.clearSelection();
					if(cob.selectedLabel.toString()=="网络关键点分析"){
						
			//			cob_add.visible=true;cob_add.width=50;
					}else{
						cob_add.visible=false;cob_add.width=0;
						if(cob.selectedLabel.toString()=="网络直径分析"){
							diInput.visible = true;
						}
						
					}
					refreshArray("todo");
					
				}
				private function cob_todoAnaly():void{
					
					//Alert.show("分析");
					var str=cob.selectedLabel.toString();
					var info_array:Array = Shared.info_array;
					//var info_array1:Array = Shared.info_array1;
					var nodename_array:Array = Shared.equipnamelist;
					
					
					
					
					
					if(str == "成环率分析"){
							//Alert.show("cheng huan");
							refreshSystems();
							cob.selectedIndex=1;
							vb.visible=true;
							vb.currentState="show";
							acc.visible=true;
						//成环率的处理 mawj
						equipGrid.visible=true;
						lab.visible=true;
						selectflag = 3;
						
						// 设备名称数组
						var name_list:Array = Shared.equipnamelist;
						var rate:Number = Circlerate.main(info_array, name_list);
						
						
						var namestr:String = Circlerate.U_NODE;//同缆假环(无环)设备显示
						//Alert.show("namestr" + namestr);
						var arrbak:Array = new Array();
						if(namestr!=null){
							if(namestr.indexOf(",")!=-1){
								arrbak= namestr.split(",");
							}else{
								arrbak.push(namestr);
							}
						}
						
						var namearr:Array = new Array();
						for(var i=0;i<arrbak.length-1;i++){
							if(arrbak[i]!=arrbak[i+1]){
								namearr.push(arrbak[i]);
							}
						}
						if(arrbak[arrbak.length-1]!=arrbak[0]){
							namearr.push(arrbak[arrbak.length-1]);
						}
						var idstr:String = Circlerate.U_NODEID;
						var idarrbak:Array = idstr.split(",");
						var idarr:Array = new Array();
						for(var i=0;i<idarrbak.length-1;i++){//wats the point for reorganizing idarr ,redundancy?
							if(idarrbak[i]!=idarrbak[i+1]){
								idarr.push(idarrbak[i]);
							}
						}
						if(idarrbak[idarrbak.length-1]!=idarrbak[0]){
							idarr.push(idarrbak[idarrbak.length-1]);
						}
						C_Analysis.removeAll();
						//Alert.show("here");
						for(var i:int =0; i<namearr.length; i++){
							//							if(namearr[i]!="undefined"&&namearr[i]!="1-金贸变"){//判断是否包含undefined类型，金贸变特殊处理（原因不明）
							if(namearr[i]!="undefined"){
								var Citem:Object = new Object();
								Citem.NODE_NAME = namearr[i];
								Citem.ID = namearr[i];
								Citem.NODE_ID =  idarr[i];
								Citem.STATION_ID = "";
								Citem.NODE_TYPE_NAME ="";
								Citem.TIPINFO="";
								for each(var ob:Object in Shared.equips){
									if(ob.equipcode == idarr[i]){
										Citem.STATION_ID=ob.stationcode;
										var stationname:String=ob.stationname;
										if(stationname==null||stationname=="null"){
											stationname="";
										}//删掉equips!!!!!!!!!!!!
										Citem.STATIONNAME=stationname;
										Citem.TIPINFO="所在站点:"+stationname+" 设备型号："+ob.x_model;
									}
								}
								if(!C_Analysis.contains(Citem)){//避免重复添加
									C_Analysis.addItem(Citem);
								}
							}
						}
						
						
//						var xmllist:*=tree.dataProvider;
//						var xmlcollection:XMLListCollection=xmllist;	
//						var flag:String="0";
//						for each ( var systemelement:XML in xmlcollection.children())
//						{
//							if(systemelement.@checked=="1")
//							{
//								flag="1";
//							}
//							
//						}
						
							equipGrid.dataProvider = C_Analysis;
							//Alert.show("C_A" + C_Analysis.length.toString());
							lab.text = currSystemName+" 成环率分析"+" 成环率"+((info_array.length-C_Analysis.length)/info_array.length*100).toFixed(2)+ "%"; 
							
							no.headerText="未成环设备："+Circlerate.U_TOTAL.toString();
							
							//							no.headerText="未成环设备："+(C_Analysis.length-1).toString();
							no.visible = true;
							di.visible = false;
							su.visible=false;
						
					}else if(str == "网络直径分析"){
						
						/*
						refreshSystems();
						vb.visible=true;
						vb.currentState="show";
						acc.visible=true;					
						cob.selectedIndex=2;
						//网络直径分析 zqliu
						equipGrid.visible=true;
						equipGrid.includeInLayout=true;
						lab.visible=true;
						selectflag = 4;
						D_Analysis.removeAll();
						
						// 划分子网
						Subgraph.main(info_array);
						
						Alert.show("Subgraph succeeds!" + Subgraph.sub_num_sub.toString());
						
						// 对每一个子网求网络直径
						for(var k:int=0; k<Subgraph.sub_num_sub; k++){
							var subarr:Array = new Array();
							var subname:Array = new Array();
							var subid:Array = new Array();
							var line:int = Subgraph.subn_sub[k];//line存储了子网K的节点数目
							var strr:String = Subgraph.subg_sub[k];//strr为存储了子网k的所有节点Index的字符串
							var subg:Array = strr.split(",");//subg为存储了子网K中所有节点index的Array
							for(var i:int=0; i<line; i++){
								subarr[i]=new Array();
								var from_tmp:int = int(subg[i]);//from依次取子网k中的每个节点的Index						
								subname[i]= nodename_array[from_tmp];//subname依次存储了子网K中所有节点的名称
								subid[i]= Shared.equipid_array[from_tmp];//subid一次存储了子网K中所有节点的真实equipid
								for(var j:int=0; j<line; j++){
									var to_tmp:int = int(subg[j]);//对于每个from值，to依次取子网k中的每个节点的Index								
									subarr[i][j]=info_array[from_tmp][to_tmp];//subarr存储了子网k中所有节点的距离二维矩阵
								}
							}
							
							var info:Array = new Array();//info[i][j]=0表示节点i,j不连通
							info = subarr;
							//var resflag:int=-1;
							//DFloyd.main(info,subname,subid,resflag);//DFloyd中的G[i][j]对info进行了转化，若节点i,j不连通则length[i][j]=max
							row=subarr.length;
							add_dimension(length,row,2);
							add_dimension(path,row,2);
							add_dimension(spot,row,2);
							add_dimension(allspot,row,3);
							refresh();
							Initialization();	
							//Alert.show("0");
							
							
							
							Floyd(subarr,subname);
							var str:String="";
							
							
							//Alert.show("1");
							for (var i:int = 0; i < row; i++){
								for (var j:int = 0; j < row; j++){
									if(i==j){
										length[i][j]=0;
									} 
								}
							}	
							for (var i:int = 0; i < row; i++) {					
								for (var j:int = i+1; j < row; j++) {
									if(length[i][j]<MAX){
										if(length[i][j]>network_diameter){//一个子网的网络直径为所有节点之间最短路径的Max值
											network_diameter=length[i][j];
											Initialization();//reset长度为网络直径的路径信息，因为网络直径本身的值也更新了
											from[0]=i;
											to[0]=j;						
										}else if(length[i][j] == network_diameter){//记录所有长度为network_diameter的路径的起始和终止节点	
											from[longpath_num]=i;//longpath_num为长度取网络直径的路径数目
											to[longpath_num]=j;
											longpath_num++;
										}				
									}							
								}
							}
							
							Initialization();
							longpath_num=0;
							network_diameter=network_diameter;
							for (var i:int = 0; i < row; i++){					
								for (var j:int = i+1; j < row; j++){
										if(length[i][j]==network_diameter){
											from[longpath_num]=i;
											to[longpath_num]=j;
											longpath_num++;
										}
								}
							}
							node_name=new Array();
							node_id=new Array();
							for(var i:int=0;i<subname.length;i++){
								node_name[i]=subname[i];
								node_id[i]=subid[i];
							}
							if(network_diameter>d){
								d=network_diameter;
								Alert.show("d is "+d);
							}
							var rtobj:RemoteObject=new RemoteObject("fiberWire");
							rtobj.endpoint=ModelLocator.END_POINT;
							rtobj.showBusyCursor=true;
							rtobj.concurrency="last";//设置为同步执行
							//parentApplication.faultEventHandler(rtobj);
							rtobj.addEventListener(ResultEvent.RESULT,afterdelnode);
							rtobj.check_nodebusiness(from,to,node_id,network_diameter);

						}					 
						*/
						
						refreshSystems();
						vb.visible=true;
						vb.currentState="show";
						acc.visible=true;					
						cob.selectedIndex=2;
						//网络直径分析 zqliu
						equipGrid.visible=true;
						lab.visible=true;
						selectflag = 4;
						D_Analysis.removeAll();
						Subgraph.main(info_array);
						var d:int=0;
						for(var k:int=0; k<Subgraph.sub_num_sub; k++){
							var subarr:Array = new Array();
							var subname:Array = new Array();
							var subid:Array = new Array();
							var line:int = Subgraph.subn_sub[k];
							var strr:String = Subgraph.subg_sub[k];
							var subg:Array = strr.split(",");
							for(var i:int=0; i<line; i++){
								subarr[i]=new Array();
								var from:int = int(subg[i]);						
								subname[i]= nodename_array[from];
								subid[i]= Shared.equipid_array[from];
								for(var j:int=0; j<line; j++){
									var to:int = int(subg[j]);								
									subarr[i][j]=info_array[from][to];
								}
							}
							
							var info:Array = new Array();
							info = subarr;
							DFloyd.main(info,subname,subid);
							if(DFloyd.network_diameter == d){
								for(var i:int = 0; i<DFloyd.longpath_num; i++){
									var Citem:Object = new Object();
									var node_from:int=DFloyd.from[i];
									var node_to:int  = DFloyd.to[i];
									Citem.Diameter = DFloyd.network_diameter;
									Citem.P_Node = subname[node_from]+"-->"+subname[node_to];
									Citem.Path  = DFloyd.longpath[i];
									Citem.IDPath = DFloyd.idlongpath[i];
									D_Analysis.addItem(Citem);
								}
							}
							if(DFloyd.network_diameter > d){
								D_Analysis.removeAll();
								d = DFloyd.network_diameter;
								for(var i:int = 0; i<DFloyd.longpath_num; i++){
									var Citem:Object = new Object();
									var node_from:int = DFloyd.from[i];
									var node_to:int  = DFloyd.to[i];
									Citem.Diameter = DFloyd.network_diameter;
									Citem.P_Node = subname[node_from]+"-->"+subname[node_to];
									Citem.Path  = DFloyd.longpath[i];	
									Citem.IDPath = DFloyd.idlongpath[i];
									D_Analysis.addItem(Citem);
								}
							}
							
							
						}					 
						
						//var flag = "1";
						//if(flag=="1"){
						lab.text = "网络直径分析";
						di.visible = true;
						di.headerText="直径路径：" + D_Analysis.length;
						no.visible = false;
						su.visible=false;
						equipGrid.dataProvider = D_Analysis;
						//}
					}
					else if(str == "网络关键点分析"){
						
						//Alert.show("Rooney: " + cob.selectedLabel.toString());
						refreshSystems();			
						vb.visible=true;
						vb.currentState="show";
						acc.visible=true;
						cob.selectedIndex=0;
						equipGrid.visible=true;
						//equipGrid.includeInLayout=true;
						lab.visible=true;
						switch_show.visible=true;
						selectflag =5;
						//cob.selectedLabel = "网络关键点分析"
						//Alert.show("messi: " + cob.selectedLabel.toString());
						var info_array:Array = Shared.info_array;
						
						var temp_count:int = 0;
						
						// 划分子网
						Subgraph.main(info_array);
						K_Analysis.removeAll();
						singleK_Analysis.removeAll();
						
						
						for(var k:int=0; k<Subgraph.sub_num_sub; k++){
							
							// subarr是子网 k的邻接矩阵
							var subarr:Array = new Array();
							var subname:Array = new Array();
							var subid:Array = new Array();
							//line:子网 k的边数
							var line:int = Subgraph.subn_sub[k];
							// strr:子网 k的结点
							var strr:String = Subgraph.subg_sub[k];
							var subg:Array = strr.split(",");
							for(var i:int=0; i<line; i++){
								subarr[i]=new Array();
								var from:int = int(subg[i]);						
								subname[i]= nodename_array[from];
								subid[i]= Shared.equip_idlist[from];
								for(var j:int=0; j<line; j++){
									var to:int = int(subg[j]);								
									subarr[i][j]=info_array[from][to];
								}
							}
							
							var info:Array = new Array();
							info = subarr;
							
							// 求关键点的算法
							keynode.main(info);
							
							
							
							for (var i:int=0;i<info.length;i++){
								if(keynode.subn[i]>1){									
									var singleNet_id:String = "";
									var strr:String = keynode.singleNet[i];
									var singleNet_N:Array = new Array();
									
									if(strr==""){
										
									}else{
										singleNet_N = strr.split(",");
										for(var n:int=0; n<singleNet_N.length; n++){
											var node:int = parseInt(singleNet_N[n]);
											singleNet_id = singleNet_id + subid[node].toString() +",";
										}
										singleNet_id=singleNet_id.substring(0,singleNet_id.length-1);
									}
									
									
									
									var count:String="2";
//									if(parseInt(count)>2){//如果 选择的个数大于2 则再进行帅选 
//										for(var h:int=0;h<equipsCount.length;h++){//计算出来的关键点和应算的数据对比  影响到的复用段个数 才显示  mawj
//											if(subid[i]==equipsCount[h].equipcode){
//												var Citem:Object = new Object();
//												Citem.ID = subid[i];
//												Citem.G_Point = subname[i];
//												Citem.SubG_Num  = keynode.subn[i].toString();			
//												Citem.SubG_Large = keynode.crit_value[i];
//												Citem.SubG_singleNet = singleNet_id;
//												if(singleNet_id==""){
//													K_Analysis.addItem(Citem);
//												}
//												else{
//													singleK_Analysis.addItem(Citem);
//												}
//												
//											}
//										}
//									}
									
									var Citem:Object = new Object();
									Citem.NODE_ID = subid[i];
									Citem.ID = subname[i];
									Citem.G_Point = subname[i];
									Citem.SubG_Num  = keynode.subn[i].toString();			
									Citem.SubG_Large = keynode.crit_value[i] ;
									Citem.SubG_singleNet = singleNet_id;
									if(singleNet_id==""){
										K_Analysis.addItem(Citem);
									}
									else{
										singleK_Analysis.addItem(Citem);
									}
									
								}
							}
						}
						
						//1 显示网络关键点分析相关信息
						var xmllist:*=tree.dataProvider;
						var xmlcollection:XMLListCollection=xmllist;	
						//var flag:String="0";
//						for each ( var systemelement:XML in xmlcollection.children())
//						{
//							if(systemelement.@checked=="1")
//							{
//								flag="1";
//							}
//							
//						}
						
						
						lab.text = "网络关键点分析";
						su.visible=true;
						su.headerText="无悬挂点割点:"+K_Analysis.length;
						su_1.visible=true;
						su_1.headerText="有悬挂点割点:"+singleK_Analysis.length;
							
						di.visible = false;
						no.visible = false;
						equipGrid.dataProvider = K_Analysis;
						equipGrid_1.dataProvider = singleK_Analysis;
						
						
					}
					
					
				}
				
				
				private function refreshArray(type:String):void{
					//刷新数据列表 用于对比 mawj
					

					vb.currentState="show";
					acc.selectedIndex=3;
					//Shared.info_array = new Array();
					Shared.info_array1 = new Array();
					Shared.equipname_array = new Array();	
					Shared.equipid_array = new Array();
					var namesarr:Array = new Array();
					var idsarr:Array = new Array();
					//						Alert.show(Shared.equips.length.toString());
					for(var i:int = 0; i<Shared.equips.length; i++){
						var equipOb:Object = Shared.equips[i];
						//Shared.info_array[i] = new Array();
						Shared.info_array1[i] = new Array();
						namesarr[i] = equipOb.equipname;
						idsarr[i] = equipOb.equipcode;
						
						for(var j:int = 0; j<Shared.equips.length; j++){
							//Shared.info_array[i][j] = 0;
							Shared.info_array1[i][j] = 0;
						}
					}
					
					for(var i=0;i<namesarr.length-1;i++){
						if(namesarr[i]!=namesarr[i+1]){
							Shared.equipname_array.push(namesarr[i]);
						}
					}
					if(namesarr[namesarr.length-1]!=namesarr[0]){
						Shared.equipname_array.push(namesarr[namesarr.length-1]);
					}
					for(var i=0;i<idsarr.length-1;i++){
						if(idsarr[i]!=idsarr[i+1]){
							Shared.equipid_array.push(idsarr[i]);
						}
					}
					if(idsarr[idsarr.length-1]!=idsarr[0]){
						Shared.equipid_array.push(idsarr[idsarr.length-1]);
					}
					
					var strIds:String="";
					/*
					for(i = 0; i<Shared.ocables.length; i++){
						var linkOb:Object = Shared.ocables[i];
						var ob:Object = Shared.getConnectedEquipIndexOcables(i);
						var id1:int = ob.id1,id2:int = ob.id2;
						
						if(Shared.info_array[id1][id2] == 0){
							Shared.info_array[id1][id2] = 1;
							Shared.info_array[id2][id1] = 1;
							
						}
					}
					*/
					/*var tempstr:String="";
					for(var k:int=0;k<Shared.info_array.length;k++){
						tempstr=tempstr+Shared.equipname_array[k]+": ";
						for(var j:int=0;j<Shared.info_array[k].length;j++){
							if(Shared.info_array[k][j]>0){
								tempstr=tempstr+Shared.equipname_array[j]+",,,";
							}
						}
						tempstr+="\n";
					}
					Alert.show(tempstr);*/
					//Alert.show(strIds);
					for(i = 0; i<Shared.fibers.length; i++){
						var fiberOb:Object = Shared.fibers[i];
						var ob:Object = Shared.getConnectedEquipIndexFibers(i);
						var id1:int = ob.id1,id2:int = ob.id2;
						if(Shared.info_array1[id1][id2] == 0){
							Shared.info_array1[id1][id2] = 1;
							Shared.info_array1[id2][id1] = 1;
							
						}
					}
					//获取对应的设备数  网络关键点为 有多少个孤立点 即设备有多少个复用段
					var systemcode:String=tree.selectedItem.@code;
					var rtobj:RemoteObject=new RemoteObject("fiberWire");
					rtobj.endpoint=ModelLocator.END_POINT;
					rtobj.showBusyCursor=true;
					parentApplication.faultEventHandler(rtobj);
					rtobj.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void
					{
						if(cob.selectedLabel.toString()!="网络关键点分析"){
						var xml:String=event.result.toString();
						var equips:Array=(JSON.decode(xml.split("---")[0].toString()) as Array); //获取该系统的设备数组
						var business_n:Array=(JSON.decode(xml.split("---")[1].toString()) as Array); //获取业务             //liao
						var ocables:Array=(JSON.decode(xml.split("---")[2].toString()) as Array); //获取该系统的复用段数组
						var fibers:Array=(JSON.decode(xml.split("---")[3].toString()) as Array);
						equipsCount=equips;//设备数组初始 mawj分析
						//						Shared.ocables=ocables;
						}
						if(type="todo"){//执行分析功能
							cob_todoAnaly();
						}
					});

//						// 暂时注释掉 zmc
//						if(cob.selectedLabel.toString()=="网络关键点分析"){
//						var count:String="2";
//						if(cob_add!=null&&cob_add.selectedLabel!=null){
//							count=cob_add.selectedLabel.toString();
//						}
//						//rtobj.getSystemDataByCount(systemcode,false,count);//查询当前系统的设备和复用段(不包含对接设备)  分段查询  用于关键点 的孤立点个数
//					}else{
//						//rtobj.getSystemData(systemcode,false);//查询当前系统的设备和复用段(不包含对接设备)  
//					}
					
					
					//Alert.show("网络关键点分析前");
					cob_todoAnaly();
					
				}
				
						
					
				
				
				protected function equipGridList_itemClickHandler(event:ListEvent):void
				{
					
					
					if(selectflag ==3){			
						
						var node_id:String = this.equipGrid.selectedItem.ID;
						
						systemorgmap.elementBox.forEach(function(element:IElement):void
						{
							if(element is Node)
							{
								var node:Node=element as Node;
								if(node.id==node_id)
								{
									/*
									systemorgmap.elementBox.selectionModel.clearSelection();
									systemorgmap.elementBox.selectionModel.appendSelection(node);
									systemorgmap.centerByLogicalPoint(node.centerLocation.x,node.centerLocation.y);
									*/
									
									systemorgmap.centerByLogicalPoint(node.centerLocation.x,node.centerLocation.y);
									// 点击后该点出现闪烁效果
									
									var node_color:Number = getNodeColor(node);
									var temp_node_array:Array = new Array();
									var temp_color_array:Array = new Array();
									temp_node_array.push(node);
									temp_color_array.push(node_color);
						
									var effect_util:Effect_util = new Effect_util();
									effect_util.sprinkle_effect(0,null,null,null,1,temp_node_array,
															temp_color_array);
									
									return;
								}
							}
						});
						
					}else if(selectflag ==4)
					{
						//网络直径分析
						systemorgmap.elementBox.selectionModel.clearSelection();
						//var str:String = this.equipGrid.selectedItem.IDPath;	
						var str:String = this.equipGrid.selectedItem.Path;
						var arr:Array = str.split("-->");
						//Alert.show("id path: " + str);
						
						
						var node_and_link_array:Array = new Array();
						var temp_color_array:Array = new Array();
						
						
						for(var i:int=0; i<arr.length; i++){
							var equip_node:Node=dataBox.getDataByID((arr[i]).toString()) as Node;
							if(equip_node!=null)
							{
								
//								systemorgmap.selectionModel.appendSelection(equip_node);
//								
//								equip_node.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
//								//值设为0，清除黄色背景框 xgyin
//								equip_node.setStyle(Styles.VECTOR_FILL_ALPHA, 0);
//								equip_node.setStyle(Styles.VECTOR_FILL_COLOR, 0xFF6600);
								node_and_link_array.push(equip_node);
								temp_color_array.push( getNodeColor(equip_node) );
								systemorgmap.centerByLogicalPoint(equip_node.centerLocation.x,equip_node.centerLocation.y);
							}
							
							
						}
						
						for(var i:int=arr.length; i>0; i--){
							
							systemorgmap.elementBox.forEach(function(element:IElement):void
							{	
								if(element is Link)
								{
									
									var link:Link=element as Link;
									if(link.toNode.id.toString()==arr[i-1]&&link.fromNode.id.toString()==arr[i]){
										
										//node_and_link_array.push(link);
										link.setStyle(Styles.SELECT_COLOR,"0xFF6600");
										link.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
										link.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
										link.setStyle(Styles.VECTOR_FILL_COLOR, 0x7697C9);
										systemorgmap.elementBox.selectionModel.appendSelection(link);//显示不完全 有问题 mawj
									}
									if(link.toNode.id.toString()==arr[i]&&link.fromNode.id.toString()==arr[i-1]){
										
										
										//node_and_link_array.push(link);
										
										link.setStyle(Styles.SELECT_COLOR,"0xFF6600");
										
										link.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
										link.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
										link.setStyle(Styles.VECTOR_FILL_COLOR, 0x7697C9);
										systemorgmap.elementBox.selectionModel.appendSelection(link);//显示不完全 有问题 mawj
									}
									
								}		
								
							});
						}
						
						for(var i:int=0; i<arr.length-1; i++){
							
							systemorgmap.elementBox.forEach(function(element:IElement):void
							{	
								if(element is Link)
								{
									
									var link:Link=element as Link;
									if(link.toNode.id.toString()==arr[i+1]&&link.fromNode.id.toString()==arr[i]){
										
										node_and_link_array.push(link);
										
										link.setStyle(Styles.SELECT_COLOR,"0xFF6600");
										link.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
										link.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
										link.setStyle(Styles.VECTOR_FILL_COLOR, 0x7697C9);
										systemorgmap.elementBox.selectionModel.appendSelection(link);//显示不完全 有问题 mawj
									}
									if(link.toNode.id.toString()==arr[i]&&link.fromNode.id.toString()==arr[i+1]){
										
										
										node_and_link_array.push(link);
										link.setStyle(Styles.SELECT_COLOR,"0xFF6600");
										
										link.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
										link.setStyle(Styles.VECTOR_FILL_ALPHA, 0.6);
										link.setStyle(Styles.VECTOR_FILL_COLOR, 0x7697C9);
										systemorgmap.elementBox.selectionModel.appendSelection(link);//显示不完全 有问题 mawj
									}
									
								}		
								
							});
						}
						
						var get_color_node:Node = (Node)(node_and_link_array[0]);
						
						var effect_util:Effect_util = new Effect_util();
						effect_util.sprinkle_effect(0,null,null,null,1,node_and_link_array,
							temp_color_array);
						
					}else if(selectflag ==5)
					{//网络关键点分析	
						systemorgmap.elementBox.selectionModel.clearSelection();
						var str:String = this.equipGrid.selectedItem.ID;
						//Alert.show("selected id " + str);
						
						systemorgmap.elementBox.forEach(function(element:IElement):void
						{
							if(element is Node)
							{
								var node:Node=element as Node;
								if(node.id==str){
									
									
//									systemorgmap.elementBox.selectionModel.clearSelection();
//									systemorgmap.elementBox.selectionModel.appendSelection(node);
//									systemorgmap.centerByLogicalPoint(node.centerLocation.x,node.centerLocation.y);
									
									systemorgmap.centerByLogicalPoint(node.centerLocation.x,node.centerLocation.y);
									// 点击后该点出现闪烁效果
									
									var node_color:Number = getNodeColor(node);
									var temp_node_array:Array = new Array();
									var temp_color_array:Array = new Array();
									temp_node_array.push(node);
									temp_color_array.push(node_color);
									
									var effect_util:Effect_util = new Effect_util();
									effect_util.sprinkle_effect(0,null,null,null,1,temp_node_array,
										temp_color_array);
								}
								/*
								else{
								if(id.length>0){
								for(var i=0; i<id.length; i++){
								if(node.id==id[i]){
								systemorgmap.elementBox.selectionModel.appendSelection(node);
								//node.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
								//node.setStyle(Styles.VECTOR_FILL_COLOR, 0xFF0033);
								}
								}
								}
								
								}
								*/
							}
						});
					}
					
					
				}
				
				
				/**
				 * 获取node节点当前的颜色值
				 */
				private function getNodeColor(node:Node):Number {
					
					// 尚未进行检修状态查看时，返回灰色
					if (Shared.ana_flag == 0)
						//return 0xB4B2A2;
						return 0xBCB9AA;
					
					if ( node.getClient("incheck") ) {
						return Effect_util.color_incheck;
					}
					
					else if (node.getClient("checkable")) {
						return Effect_util.color_checkable;
					}
					
					else
						return Effect_util.color_invalid;
				}
				
				
				protected function equipGridList1_itemClickHandler(event:ListEvent):void{
					systemorgmap.elementBox.selectionModel.clearSelection();
					var str:String = this.equipGrid_1.selectedItem.ID;
					
					var idstr:String = this.equipGrid_1.selectedItem.SubG_singleNet;
					var id:Array = new Array();
					if(idstr==""){
						
					}else{
						id=idstr.split(",");
					}
					//Alert.show(id.length.toString()+"\n"+id.toString());
					//Alert.show(idstr+",,,,,"+str);
					if(id.length>0){
						for(var i=0; i<id.length; i++){
							systemorgmap.elementBox.forEach(function(element:IElement):void{
								if(element is Node){
									var node:Node=element as Node;
									if(node.id==id[i]){
										systemorgmap.elementBox.selectionModel.appendSelection(node);
										//node.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT_VECTOR);
										//node.setStyle(Styles.VECTOR_FILL_COLOR, 0xFF0033);
									}
								}
							});							
						}
					}
					
					systemorgmap.elementBox.forEach(function(element:IElement):void{
						if(element is Node){
							var node:Node=element as Node;
							if(node.id==str){
								//systemorgmap.elementBox.selectionModel.clearSelection();
								//systemorgmap.elementBox.selectionModel.appendSelection(node);
								
								var node_color:Number = getNodeColor(node);
								var temp_node_array:Array = new Array();
								var temp_color_array:Array = new Array();
								temp_node_array.push(node);
								temp_color_array.push(node_color);
								
								var effect_util:Effect_util = new Effect_util();
								effect_util.sprinkle_effect(0,null,null,null,1,temp_node_array,
									temp_color_array);
								
								systemorgmap.centerByLogicalPoint(node.centerLocation.x,node.centerLocation.y);
							}
						}
					});							
					
				}

				protected function getlink(id1:String, id2:String){
					var linkid:String="";
					systemorgmap.elementBox.forEach(function(element:IElement):void
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
					systemorgmap.elementBox.forEach(function(element:IElement):void
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
				protected function dfs(array:Array,node:int,colornum:int):void{
					Shared.visited[node]=1; 
					refreshArray("");
					for(var i:int=0;i<array.length;i++){
						if(Shared.visited[i]==0 && array[node][i]==1 ){
							var linkid:String =getlink(Shared.equipid_array[node],Shared.equipid_array[i]);
							
							if(colornum==0){
								var equip_node:Node=dataBox.getDataByID(Shared.equipid_array[i]) as Node;
								systemorgmap.selectionModel.appendSelection(equip_node);
								equip_node.setStyle(Styles.SELECT_COLOR,0x00FF00);
								
								/*for(var i:int=0;i<arr.length;i++){
								var linkid=arr[i];
								var link:Link= dataBox.getDataByID(linkid) as Link;
								systemorgmap.selectionModel.appendSelection(link)
								link.setStyle(Styles.SELECT_COLOR,0x0000FF);
								}*/
								var link:Link= dataBox.getDataByID(linkid) as Link;
								systemorgmap.selectionModel.appendSelection(link);
								link.setStyle(Styles.SELECT_COLOR,0x00FF00);
								//systemorgmap.elementBox.getElementByID(Shared.equipid_array[i]).setStyle(Styles.INNER_COLOR,0x008000);
								//systemorgmap.elementBox.getElementByID(linkid).setStyle(Styles.INNER_COLOR,0x008000);
							}else if(colornum==1){
								var equip_node:Node=dataBox.getDataByID(Shared.equipid_array[i]) as Node;
								systemorgmap.selectionModel.appendSelection(equip_node);
								equip_node.setStyle(Styles.SELECT_COLOR,0xFFFF00);
								/*for(var i:int=0;i<arr.length;i++){
								linkid=arr[i];
								var link:Link= dataBox.getDataByID(linkid) as Link;
								systemorgmap.selectionModel.appendSelection(link)
								link.setStyle(Styles.SELECT_COLOR,0xFFFF00);
								}*/
								var link:Link= dataBox.getDataByID(linkid) as Link;
								systemorgmap.selectionModel.appendSelection(link)
								link.setStyle(Styles.SELECT_COLOR,0xFFFF00);
								// systemorgmap.elementBox.getElementByID(Shared.equipid_array[i]).setStyle(Styles.INNER_COLOR,0xFFFF00);
								//systemorgmap.elementBox.getElementByID(linkid).setStyle(Styles.INNER_COLOR,0xFFFF00);
							}else if(colornum==2){
								var equip_node:Node=dataBox.getDataByID(Shared.equipid_array[i]) as Node;
								systemorgmap.selectionModel.appendSelection(equip_node);
								equip_node.setStyle(Styles.SELECT_COLOR,0x800080);
								
								/*for(var i:int=0;i<arr.length;i++){
								var linkid=arr[i];
								var link:Link= dataBox.getDataByID(linkid) as Link;
								systemorgmap.selectionModel.appendSelection(link)
								link.setStyle(Styles.SELECT_COLOR,0x800080);
								}*/
								var link:Link= dataBox.getDataByID(linkid) as Link;
								systemorgmap.selectionModel.appendSelection(link);
								link.setStyle(Styles.SELECT_COLOR,0x800080);
								//systemorgmap.elementBox.getElementByID(Shared.equipid_array[i]).setStyle(Styles.INNER_COLOR,0x800080);
								//systemorgmap.elementBox.getElementByID(linkid).setStyle(Styles.INNER_COLOR,0x800080);
							}else if(colornum==3){
								var equip_node:Node=dataBox.getDataByID(Shared.equipid_array[i]) as Node;
								systemorgmap.selectionModel.appendSelection(equip_node);
								equip_node.setStyle(Styles.SELECT_COLOR,0xFF4500);
								
								/*for(var i:int=0;i<arr.length;i++){
								var linkid=arr[i];
								var link:Link= dataBox.getDataByID(linkid) as Link;
								systemorgmap.selectionModel.appendSelection(link)
								link.setStyle(Styles.SELECT_COLOR,0xFF4500);
								}*/
								var link:Link= dataBox.getDataByID(linkid) as Link;
								systemorgmap.selectionModel.appendSelection(link);
								link.setStyle(Styles.SELECT_COLOR,0xFF4500);
								//systemorgmap.elementBox.getElementByID(Shared.equipid_array[i]).setStyle(Styles.INNER_COLOR,0xFF4500);
								//systemorgmap.elementBox.getElementByID(linkid).setStyle(Styles.INNER_COLOR,0xFF4500);
							}else if(colornum==4){
								var equip_node:Node=dataBox.getDataByID(Shared.equipid_array[i]) as Node;
								systemorgmap.selectionModel.appendSelection(equip_node);
								equip_node.setStyle(Styles.SELECT_COLOR,0x0000FF);
								
								/*	for(var i:int=0;i<arr.length;i++){
								var linkid=arr[i];
								var link:Link= dataBox.getDataByID(linkid) as Link;
								systemorgmap.selectionModel.appendSelection(link)
								link.setStyle(Styles.SELECT_COLOR,0x0000FF);
								}*/
								var link:Link= dataBox.getDataByID(linkid) as Link;
								systemorgmap.selectionModel.appendSelection(link);
								link.setStyle(Styles.SELECT_COLOR,0x0000FF);
								//systemorgmap.elementBox.getElementByID(Shared.equipid_array[i]).setStyle(Styles.INNER_COLOR,0x0000FF);
								//systemorgmap.elementBox.getElementByID(linkid).setStyle(Styles.INNER_COLOR,0x0000FF);
							}
							dfs(array, i,colornum);
						}
						
					}    	    	
				}
				
				//选择分析
				protected function cob1_clickHandler(event:MouseEvent):void
				{
				/*	acc.visible=false;    //将此行注释掉后依然可见
					acc.currentState="hide";  //上面不注释，将此行注释掉后什么都没了
					vb.visible=false;
					vb.currentState="hide";
					eqp_Analysis.selectedIndex=0;*/
					acc.currentState="hide"; 
					vb.currentState="hide";
					//dbl
				
					//dbl
				}
				
				protected function cob_clickHandler(event:MouseEvent):void
				{   
					
					if (Shared.ana_flag == 0) {
						var alert:Alert = new Alert();
						alert.text = "请先进行状态检修";
						alert.buttonFlags = 1;
						Alert.yesLabel = "确定";  
						alert.addEventListener(CloseEvent.CLOSE,function(event:CloseEvent):void{
							PopUpManager.removePopUp(alert);
						});  
						PopUpManager.addPopUp(alert,this, true);   
						PopUpManager.centerPopUp(alert);  
						return;
					}
					vb.visible=true;
					vb.currentState="show";
					acc.visible=true;
					/*acc.currentState="show";*/
					acc.selectedIndex=3;
					
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
				
				private function diClickHandler():void{
					var info_array:Array = Shared.info_array;
					var nodename_array:Array = Shared.equipname_array;
					var input:int = Number(ddd.text);
					D_Analysis.removeAll();
					Subgraph.main(info_array);
					for(var k:int=0; k<Subgraph.sub_num_sub; k++){
						var subarr:Array = new Array();
						var subname:Array = new Array();
						var subid:Array = new Array();
						var line:int = Subgraph.subn_sub[k];
						var strr:String = Subgraph.subg_sub[k];
						var subg:Array = strr.split(",");
						for(var i:int=0; i<line; i++){
							subarr[i]=new Array();
							var from:int = int(subg[i]);						
							subname[i]= Shared.equipnamelist[from];
							subid[i]= Shared.equipid_array[from];
							for(var j:int=0; j<line; j++){
								var to:int = int(subg[j]);								
								subarr[i][j]=info_array[from][to];
							}
						}
						
						var info:Array = new Array();
						info = subarr;
						Diameter.main(info,subname,subid,input);
						if(Diameter.network_diameter >= input){
							for(var i:int = 0; i<Diameter.longpath.length; i++){
								var Citem:Object = new Object();
								var temp:Array=Diameter.longpath[i].split("-->");
								//var node_from:int=DFloyd.from[i];
								//var node_to:int  = DFloyd.to[i];
								Citem.Diameter = Diameter.network_diameter;
								Citem.P_Node=temp[0]+"-->"+temp[temp.length-1];
								//Citem.P_Node = subname[node_from]+"-->"+subname[node_to];
								Citem.Path  = Diameter.longpath[i];
								Citem.IDPath = Diameter.idlongpath[i];
								D_Analysis.addItem(Citem);
							}	
							/*
							for(var i:int = 0; i<Diameter.longpath_num; i++){
							var Citem:Object = new Object();
							var node_from:int=Diameter.from[i];
							var node_to:int  = Diameter.to[i];
							Citem.Diameter = Diameter.network_diameter;
							Citem.P_Node = subname[node_from]+"-->"+subname[node_to];
							Citem.Path  = Diameter.longpath[i];	
							Citem.IDPath = Diameter.idlongpath[i];
							D_Analysis.addItem(Citem);
							}
							*/
						}
						
						di.visible = true;
						di.headerText="路径数："+D_Analysis.length;
						no.visible = false;
						su.visible=false;
						equipGrid.dataProvider = D_Analysis;
					}
					
//					di.visible = true;
//					di.headerText="路径数："+D_Analysis.length;
//					no.visible = false;
//					su.visible=false;
//					equipGrid.dataProvider = D_Analysis;
				}
				
				public function Floyd(G:Array,name:Array):void { 
					network_diameter=0;
					for(var i:int=0;i<row;i++){
						for(var j:int=0;j<row;j++){
							for(var k:int=0;k<row;k++){
								allspot[i][j][k]=-1;
							}
						}
					}
					
					for (var i:int = 0; i < row; i++){
						for (var j:int = 0; j < row; j++) { 
							if (G[i][j] == 0){
								length[i][j] = MAX;
								spot[i][j] = -1;
							}else{
								length[i][j] = 1;
								spot[i][j] = j;//spot[i][j]表示从节点i到节点j的最短路径中，i的下一个节点为j
								allspot[i][j][0]=j;
							}
							
							if (i == j) 
								length[i][j] = MAX;					
						}
					}
					for (var u :int= 0; u < row; u++){
						for (var v:int = 0; v < row; v++){//分析节点v,w之间是否存在更短的路径（该路径将经过中间节点u）
							if(v!=u){
								for (var w:int = v+1; w < row; w++) {
									if(w!=u){
										if (length[v][w] > length[v][u] + length[u][w]){//v,w间存在通过了中间节点u，而且更短的路径
											length[v][w] = length[v][u] + length[u][w];//更新v,w的最短路径
											length[w][v] = length[v][w];
											spot[v][w] = u;
											spot[w][v] = u;
										}
									}
								}
							}
						}
					}
					
					for(var u:int=0;u<row;u++){
						for(var v:int=0;v<row;v++){
							if(v!=u){
								spot_num=0;
								for(var w:int=0;w<row;w++){
									if(allspot[u][v][0]!=-1){
										spot_num=1;
									}
									if(length[u][v]==length[u][w]+length[w][v]&&w!=allspot[u][v][0]){
										allspot[u][v][spot_num++]=w;
									}
								}
							}
						}
					}
				}
				
				private function outputPath(i:int, j:int, tempflag:int):void {
					if(tempflag==0){
						if (i == j) 
							return;
						if(spot[i][j]==-1){
							tempflag=1;
							return;
						}
						if (spot[i][j] == j)//如果最短路径的输出已经到了最后，即本层递归的节点i,j最短路径就是[i,j]
							onePath[point++] = j;//
						else {//如果本层递归的节点i,j之间存在中间节点为spot[i][j]的更短路径
							outputPath( i, spot[i][j],tempflag);//首先试图寻找本层的节点i到达本层的spot[i][j]之间的更短路径，即检查是否在经过中间节点时路径更短
							outputPath( spot[i][j], j,tempflag); //然后试图寻找本层的节点spot[i][j]到本层的节点j之间的更短路径
						} 
					}				
					
				}
				
				public function afterdelnode(event:ResultEvent):void{
					//var new_from:Array=temp.getItemAt(0).from as Array;//本行出错，0 is out of bound 
					//var new_to:Array=temp.getItemAt(0).to as Array;
					var new_from:ArrayCollection=event.result["from"] as ArrayCollection;
					var new_to:ArrayCollection=event.result["to"] as ArrayCollection;
					var temp_diamter:int=event.result["diameter"] as int;
					var tempflag:int;
					if(temp_diamter == d){
						from=new Array();
						to=new Array();
						from=new_from.source;
						to=new_to.source;
						real_pathnum=0;
						for (var j:int = 0; j <from.length; j++){	
							//Alert.show("3");
							nodea=from[j];
							nodeb=to[j];
							for(var k:int=0;k<row;k++){
								if(allspot[nodea][nodeb][k]!=-1){
									
									//Alert.show(nodea+" ; "+nodeb+" ; "+k);
									//Alert.show(nodea+" to "+nodeb+":"+allspot[nodea][nodeb][k]);						
									spot[nodea][nodeb]=allspot[nodea][nodeb][k];
									refresh();
									tempflag=0;
									onePath[point++] = nodea;//onePath[0,1,2,..]依次存储了节点nodea到节点nodeb的第0，1，2...条最短路径
									outputPath(nodea, nodeb,tempflag);
									longpath[real_pathnum]="";
									idlongpath[real_pathnum]="";
									//Alert.show(onePath[0]+",,,,,"+onePath[1]);
									if(tempflag==0){
										for (var p:int=0;p<onePath.length;p++){
											//Alert.show("......."+name[onePath[p]]);
											longpath[real_pathnum]+=node_name[onePath[p]]+"-->";
											idlongpath[real_pathnum]+=node_id[onePath[p]]+"-->";
										}
										longpath[real_pathnum]=longpath[real_pathnum].substr(0,longpath[real_pathnum].length-3);
										idlongpath[real_pathnum]=idlongpath[real_pathnum].substr(0,idlongpath[real_pathnum].length-3);
										if(checkpath(longpath,longpath[real_pathnum])==1){
											longpath[real_pathnum]="";
											idlongpath[real_pathnum]="";
										}
										else{
											real_pathnum++;
										}
									}						
								}
							}
						}
						
						for(var i:int = 0; i<longpath.length; i++){
							var Citem:Object = new Object();
							var temp:Array=longpath[i].split("-->");
							//var node_from:int=DFloyd.from[i];
							//var node_to:int  = DFloyd.to[i];
							Citem.Diameter = temp_diamter;
							Citem.P_Node=temp[0]+"-->"+temp[temp.length-1];
							//Citem.P_Node = subname[node_from]+"-->"+subname[node_to];
							Citem.Path  = longpath[i];
							Citem.IDPath = idlongpath[i];
							D_Analysis.addItem(Citem);
						}
						var xmllist:*=tree.dataProvider;
						var xmlcollection:XMLListCollection=xmllist;	
						var flag:String="0";
						for each ( var systemelement:XML in xmlcollection.children())
						{
							if(systemelement.@checked=="1")
							{
								flag="1";
							}
							
						}
						//DFloyd.network_diameter
						if(flag=="1"){
							lab.text = "网络直径分析";
							di.visible = true;
							di.headerText="直径长度："+d;
							no.visible = false;
							su.visible=false;
							equipGrid.dataProvider = D_Analysis;
						}
					}
					
				}
				private function refresh():void{
					point = 0; 
					onePath = new Array();
				}
				private function Initialization():void{
					longpath_num=1;
					longpath= new Array();
					idlongpath= new Array();
					from = new Array();
					to = new Array();							
				}
				
				private function add_dimension(arr:Array,n:int,d:int):void
				{
					if(d==2)
					{
						for(var i:int=0;i<n;i++)
						{ 
							arr[i]=new Array(); 
						}
						return;
					}
					else if (d==3)
					{
						for(var i:int=0;i<n;i++)
						{ 
							arr[i]=new Array();
							for(var j:int=0;j<n;j++)
							{
								arr[i][j]= new Array();
							}
						}
						return;
					}
					else return;
				}
				
				private function checkpath(path:Array, temppath:String){
					var res:int=0;
					for(var i:int=0;i<path.length-1;i++){
						if(path[i]==temppath){
							res=1;
							return res;
						}
					}
					return res;
				}
				protected function switchshow():void{
					if(equipGrid.visible){
						equipGrid.visible=false;
						equipGrid.includeInLayout=false;
						equipGrid_1.visible=true;
						equipGrid_1.includeInLayout=true;
					}
					else if(equipGrid_1.visible){
						equipGrid_1.visible=false;
						equipGrid_1.includeInLayout=false;
						equipGrid.visible=true;
						equipGrid.includeInLayout=true;
					}
				}
