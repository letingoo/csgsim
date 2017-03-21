//import VButtonEvents.selectedItemEvent;
//
//import com.adobe.flex.extras.controls.pivotComponentClasses.helperClasses.MyCheckBox;
//import com.adobe.serialization.json.JSON;
//
//import common.actionscript.CustomInteractionHandler;
//import common.actionscript.ModelLocator;
//import common.actionscript.MyPopupManager;
//import common.actionscript.Registry;
//import common.other.SuperPanelControl.nl.wv.extenders.panel.PanelWindow;
//import common.other.events.EventNames;
//import common.other.events.LinkParameterEvent;
//import common.other.events.ParameterEvent;
//
//import flash.display.BitmapData;
//import flash.events.ContextMenuEvent;
//import flash.events.ErrorEvent;
//import flash.events.Event;
//import flash.events.MouseEvent;
//import flash.geom.Point;
//import flash.geom.Rectangle;
//import flash.net.URLRequest;
//import flash.net.URLStream;
//import flash.ui.ContextMenuItem;
//import flash.utils.ByteArray;
//
//import flexlib.scheduling.scheduleClasses.schedule_internal;
//
//import mx.automation.events.ListItemSelectEvent;
//import mx.collections.ArrayCollection;
//import mx.collections.XMLListCollection;
//import mx.containers.Box;
//import mx.containers.Panel;
//import mx.controls.Alert;
//import mx.controls.Button;
//import mx.controls.ButtonBar;
//import mx.controls.CheckBox;
//import mx.controls.ComboBox;
//import mx.controls.Label;
//import mx.controls.List;
//import mx.controls.RadioButton;
//import mx.controls.RadioButtonGroup;
//import mx.controls.Spacer;
//import mx.controls.buttonBarClasses.ButtonBarButton;
//import mx.core.Application;
//import mx.core.DragSource;
//import mx.core.UIComponent;
//import mx.events.CloseEvent;
//import mx.events.DragEvent;
//import mx.events.IndexChangedEvent;
//import mx.events.ItemClickEvent;
//import mx.events.ListEvent;
//import mx.events.ResourceEvent;
//import mx.events.ScrollEvent;
//import mx.graphics.codec.PNGEncoder;
//import mx.managers.DragManager;
//import mx.managers.PopUpManager;
//import mx.messaging.messages.ErrorMessage;
//import mx.rpc.events.FaultEvent;
//import mx.rpc.events.ResultEvent;
//import mx.utils.ObjectProxy;
//import mx.utils.StringUtil;
//
//import org.hamcrest.mxml.collection.Array;
//
//import sourceCode.alarmmgrGraph.views.*;
//import sourceCode.autoGrid.view.ShowProperty;
//import sourceCode.ocableResource.model.ocableModelLocator;
//import sourceCode.ocableTopo.views.businessInfluenced;
//import sourceCode.sysGraph.actionscript.StoryLayouter;
//import sourceCode.sysGraph.model.*;
//import sourceCode.sysGraph.views.AddEquInfo;
//import sourceCode.sysGraph.views.EquipCarryOpera;
//import sourceCode.sysGraph.views.WinTopoLink;
//import sourceCode.sysGraph.views.transsystemManager;
//
//import twaver.*;
//import twaver.Collection;
//import twaver.Constant;
//import twaver.Consts;
//import twaver.DataBox;
//import twaver.DemoImages;
//import twaver.DemoUtils;
//import twaver.Element;
//import twaver.ElementBox;
//import twaver.Follower;
//import twaver.ICollection;
//import twaver.IElement;
//import twaver.Layer;
//import twaver.Link;
//import twaver.Node;
//import twaver.SelectionChangeEvent;
//import twaver.SelectionModel;
//import twaver.SerializationSettings;
//import twaver.ShapeLink;
//import twaver.Styles;
//import twaver.Utils;
//import twaver.network.Network;
//import twaver.network.Overview;
//import twaver.network.interaction.DefaultInteractionHandler;
//import twaver.network.interaction.InteractionEvent;
//import twaver.network.interaction.MapFilterInteractionHandler;
//import twaver.network.interaction.MoveInteractionHandler;
//import twaver.network.interaction.SelectInteractionHandler;
//
//private var _modelName:String;
//
//[Bindable]
//public function get modelName():String {return _modelName;}
//public function set modelName(value:String):void {_modelName = value;}
//
//private var _province:String = null;
//[Bindable]
//public function get getProvince():String {
//	return _province;
//}
//
//public function set setProvince(province:String):void {
//	_province = province;
//} 
//
//[Bindable]
//public var _operDesc:String=null;
//[Bindable]
//public function get getoperDesc():String {
//	return _operDesc;
//}
//
//public function set setoperDesc(operDesc:String):void {
//	_operDesc = operDesc;
//}
//[Bindable]
//public var equipCollection:ArrayCollection;
//[Bindable]
//public var DeviceXML:XMLList; //保存系统组织图右侧的传输设备树的数据源
//
//[Embed(source="assets/images/sysManager/show.png")] //这是图片的相对地址 
//[Bindable]
//public var PointIcon:Class;
//[Embed(source="assets/images/sysManager/show.png")]
//[Bindable]
//public var PointRight:Class;
//[Embed(source="assets/images/sysManager/hide.png")]
//[Bindable]
//public var PointLeft:Class;
//
//[Embed(source="assets/images/toolbar/lock.png")]
//[Bindable]
//public var lock:Class;	
//[Embed(source="assets/images/toolbar/unlock.png")]
//[Bindable]
//public var unlock:Class;
//private var  str:Object=null;
//private var selectedNode:XML; //保存当前系统传输设备树选中的结点
//private var catalogsid:String; //保存当前系统传输设备树选中的结点的ID
//private var type:String; //保存当前系统传输设备树选中的结点的类型
//private var addEquInfo:AddEquInfo;
//private var itemSystem:winSystem; //增、改传输系统时的窗口
//private var lordUse:LordUse;
//private var curIndex:int;
//
//private var curComItem:String;
//private var contextmenu:ContextMenu;
//private var elementBox:ElementBox;
//
//private var itemAdd:ContextMenuItem = new ContextMenuItem("添加快捷方式",true,true);
//private var itemDel:ContextMenuItem = new ContextMenuItem("取消快捷方式");
//private var item_device:ContextMenuItem=new ContextMenuItem("设备面板图", true);		
//private var item_config:ContextMenuItem=new ContextMenuItem("配置交叉");		
//private var item_equipproperty:ContextMenuItem=new ContextMenuItem("设备属性");	
//private var item_equipopera:ContextMenuItem=new ContextMenuItem("设备承载业务", true);		
//private var item_analysis:ContextMenuItem=new ContextMenuItem("\"N-1\"分析");		
//private var item_slot:ContextMenuItem=new ContextMenuItem("时隙分布图");		
//private var item_linkproperty:ContextMenuItem=new ContextMenuItem("复用段属性");		
//private var item_linkopera:ContextMenuItem=new ContextMenuItem("复用段承载业务", true);		
//private var item_linkanalysis:ContextMenuItem=new ContextMenuItem("\"N-1\"分析");
//private var item_addpoint:ContextMenuItem = new ContextMenuItem("添加拐点",true,true);		
//private var item_deletepoint:ContextMenuItem = new ContextMenuItem("删除拐点",false,true);
//
//private var radioGroup:RadioButtonGroup;
//private var tree_selectedNode:XML;//表示当前系统树选中的结点
//private var system:Location=new Location("",0,0);
//private var showLineRate:String = "'ZY110602','ZY110603','ZY110604'";//'ZY110601'
//private var arrLineRate:String="ZY110601";
////背景地图图层
//private var mapLayer:Layer;
//private var resLayer:Layer;
//private var pointerLayer:Layer;
//
//[Embed(source='assets/images/toolbar/equipment.png')]
//private var cs:Class;
//[Embed(source='assets/images/toolbar/equipmodel.png')]
//[Bindable]
//private var sb:Class;
//[Embed(source='assets/images/toolbar/topolink.png')]
//[Bindable]
//private var fy:Class;
//
//private var bounds:Rectangle=new Rectangle(0, 0, 1400, 1700); //network的布局大小
//
//[Bindable] 
//private var ac:ArrayCollection = new ArrayCollection([
//	{label:'传输设备',icon:cs},
//	{label:'设备模板',icon:sb},
//	{label:'复用段',icon:fy}]);
//[Bindable]
//private var proArray:ArrayCollection=new ArrayCollection();
//[Bindable]
//private var proArray1:ArrayCollection=new ArrayCollection();
//[Bindable]
//private var colorArray:ArrayCollection=new ArrayCollection();
//
//[Bindable]
//private var mFlag:Boolean=false;
//private var showStr:String;
//[Bindable] 
//private var curSysVendor:String;
//[Bindable] 
//private var curSysPro:String;
//[Bindable] 
//private var isEditMap:Boolean=false;
//
//private var centerFlag:Boolean=true;
//private var minzoom=0;
//private var centerFlag2:Boolean=true;
//private var xoffset:Number=0;
//private var yoffset:Number=0;
//private var fontsize:int=20; //字号
//
//private var lastLinkID:String=null;
//private var curSysname:String; //当前地区传输系统
//private var curSysProCode:String;
//private var curSysProName:String;
//private var curXML:String; //当前地区传输系统
//private var curRootXML:XMLList;
//SerializationSettings.registerGlobalClient("code","String"); 
//SerializationSettings.registerGlobalClient("nodeName","String"); 
//private function init():void
//{
//	Alert.show("init");
////	Utils.registerImageByClass("XZ01", ModelLocator.province_XZ01);
////	Utils.registerImageByClass("XZ0101", ModelLocator.province_XZ0101);
////	elementBox=systemorgmap.elementBox;
////	systemorgmap.doubleClickToLinkBundle = false;
////	systemorgmap.addInteractionListener(interactionHanlder);
////	systemorgmap.addEventListener(MouseEvent.DOUBLE_CLICK, test);//添加系统组织图中的network的双击事件的监听
////	systemorgmap.addEventListener(MouseEvent.MOUSE_MOVE,handleMouseMove);
////	
////	radioGroup=new RadioButtonGroup();
////	radioGroup.addEventListener(Event.CHANGE,radioButtonChangeHandler);
////	ModelLocator.registerAlarm();
////	
////	curSysProCode=getoperDesc;
////	curSysProName=getProvince;
////	//初始化系统组织图右侧传输设备的右侧树的根结点
////	curXML="<folder state='0' code='"+ curSysProCode +"' label='"+curSysProName+"' isBranch='true' leaf='false' type='equiptype' ></folder>"
////	DeviceXML=new XMLList(curXML);
////	
////	
////	if (getoperDesc.length==6){
////		initCombox();
////	}
////	else
////	{
////		//			deviceTree.dragEnabled=false;
////	}
////	//		getColor();//获取复用段颜色
////	initToolBar();//初始化工具条
////	getZoomByProvice();                //根据区域查询缩放比例
////	//	createBackgroundImage();
////	initMenu();//初始化右键菜单
//}
////根据区域查询缩放比例
//private function getZoomByProvice():void{
//	if(this.getProvince != ''&&this.getProvince!=null) {
//		var zoomProvince:RemoteObject=new RemoteObject("fiberWire");
//		zoomProvince.endpoint=ModelLocator.END_POINT;
//		zoomProvince.showBusyCursor=true;
//		zoomProvince.addEventListener(ResultEvent.RESULT, zoomProvinceRetrun);
//		zoomProvince.getProvinceSetting(this.getProvince);
//	}
//}
//private function zoomProvinceRetrun(event:ResultEvent):void 
//{
//	str=event.result as Object;
//	if(str!=null){
//		createBackgroundImage();//加载地图
//	}
//}
//
//private function initMenu():void{
//	itemAdd.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,itemAddSelectHandler);
//	itemDel.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,itemDelSelectHandler);
//	item_device.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
//	item_config.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, configEquipSlot);
//	item_equipproperty.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
//	item_equipopera.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handlerContextMenuCarryOpera);
//	
//	item_slot.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler_TimeSlot);
//	item_linkproperty.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler_Ocable);
//	item_linkopera.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler_CarryOpera);
//	item_linkanalysis.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler_LinkAnalysis);
//	item_addpoint.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler_AddPoint);
//	item_deletepoint.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler_DeletePoint);
//	
//	contextmenu = new ContextMenu();
//	systemorgmap.contextMenu = contextmenu;
//	contextmenu.addEventListener(ContextMenuEvent.MENU_SELECT, contextMenu_menuSelect);
//}
////设置右键菜单
//private function contextMenu_menuSelect(e:Event):void{
//	contextmenu.hideBuiltInItems();
//	if(systemorgmap.selectionModel.count > 0){
//		if((Element)(systemorgmap.selectionModel.selection.getItemAt(0)) is Link){
//			contextmenu.customItems = [];
//			contextmenu.customItems = [item_slot,item_linkproperty,item_linkopera,item_linkanalysis,item_addpoint,item_deletepoint];
//		}else if ((Element)(systemorgmap.selectionModel.selection.getItemAt(0)) is Node){
//			var node:Node = (Element)(systemorgmap.selectionModel.selection.getItemAt(0)) as Node;
//			contextmenu.customItems = [];
//			contextmenu.customItems = [item_device,item_config,item_equipproperty,item_equipopera];
//		}
//	}
//	contextmenu.customItems.push(itemAdd);
//	contextmenu.customItems.push(itemDel);
//}
////按速率过滤
//private var stationvisible:Boolean = false;
//private function visibleFunction(element:IElement):Boolean{
//	if(element is Link){
//		if(element.getClient('isShow') == "no")
//		{
//			Alert.show("no");
//			return stationvisible;
//		}
//	}
//		
//	else if(element is Follower){
//		var links:ICollection = (element as Follower).host.links;
//		if((links==null || links.count==0) && (element as Follower).host.getClient('nodeorlabel') == 'node' ){
//			return stationvisible;
//		}
//	}
//		
//	else if (element is Node){
//		var links:ICollection = (element as Node).links;
//	}
//	return true;
//} 
////鼠标移到线上，线条加粗
//private function handleMouseMove(e:MouseEvent):void{
//	if (lastLinkID !=null)
//	{
//		var lastLink:Link=systemorgmap.elementBox.getElementByID(lastLinkID) as Link;
//		if(lastLink != null)
//		{	
//			lastLink.setStyle(Styles.LINK_WIDTH,3);
//		}
//	}
//	var element:IElement=systemorgmap.getElementByMouseEvent(e);
//	if (element is Link)
//	{
//		element.setStyle(Styles.LINK_WIDTH,5);
//		lastLinkID=element.id.toString();
//	}
//}
////初始化工具条
//private function initToolBar():void{
//	var comLabel:Label=new Label();
//	comLabel.text="速率：";
//	rateControl.addChild(comLabel);
//	rateControl.addChild(createCheckBox('155Mb/s','ZY110601'));
//	rateControl.addChild(createCheckBox('622Mb/s','ZY110602'));
//	rateControl.addChild(createCheckBox('2.5Gb/s','ZY110603'));
//	rateControl.addChild(createCheckBox('10Gb/s','ZY110604'));
//	
//	var tmpPath:String="assets/images/toolbar/";
//	proArray1=new ArrayCollection([
//		{label:"默认模式",icon:DemoImages.select},
//		{label:"放大",icon:DemoImages.zoomIn},
//		{label:"缩小",icon:DemoImages.zoomOut},
//		{label:"重置",icon:DemoImages.zoomReset},
//		{label:"编辑视图",icon:lock},
//		{label:"导出视图",icon:DemoImages.export},
//		{label:"编辑拐点",icon:DemoImages.editGeo},
//		{label:"保存拐点",icon:DemoImages.save},
//		//			{label:"刷新",icon:DemoImages.refresh},
//		{label:"图例",icon:DemoImages.legend},
//		//			{label:"搜索",icon:DemoImages.search}
//	]);
//	
//	var btns:ButtonBar=new ButtonBar();
//	btns.dataProvider=proArray1;
//	btns.addEventListener(ItemClickEvent.ITEM_CLICK,clickBtns);
//	toolbar.addChild(btns);	
//	if(!Application.application.isEdit)
//	{
//		var b4:ButtonBarButton = btns.getChildAt(4) as ButtonBarButton;
//		b4.enabled=false;
//		var b6:ButtonBarButton = btns.getChildAt(6) as ButtonBarButton;
//		b6.enabled=false;
//		var b7:ButtonBarButton = btns.getChildAt(7) as ButtonBarButton;
//		b7.enabled=false;
//	}
//}
//private function faultHandler(event:FaultEvent):void{
//	Alert.show( event.message.toString());
//}
//private function showSystemMap(evt:MouseEvent):void //选中或者撤销传输系统树中某个系统的操作
//{	
//	//		var item:Object=Tree(evt.currentTarget).selectedItem;
//	try{
//		systemorgmap.setDefaultInteractionHandlers();
//		var equipcode:String=Tree(evt.currentTarget).selectedItem.@code;
//		//			Alert.show(equipcode);
//		var equip_node:Node=systemorgmap.elementBox.getElementByID(equipcode) as Node;
//		//			Alert.show(equip_node.id.toString());
//		if(equip_node!=null)
//		{
//			//				Alert.show("clearPointer");
//			clearPointer();
//			systemorgmap.elementBox.selectionModel.clearSelection();
//			systemorgmap.elementBox.selectionModel.appendSelection(equip_node);
//			addPointer(equip_node);
//			//			systemorgmap.centerByLogicalPoint(equip_node.centerLocation.x,equip_node.centerLocation.y);
//		}	
//	}catch(err:Error)
//	{
//		Alert.show(err.message);
//	}
//}
////获取复用段颜色
//private function getColor():void{
//	colorArray.removeAll();
//	var rtobj:RemoteObject=new RemoteObject("fiberWire");
//	rtobj.endpoint=ModelLocator.END_POINT;
//	rtobj.showBusyCursor=true;
//	rtobj.getColorsByElement("topolink");
//	rtobj.addEventListener(FaultEvent.FAULT,faultHandler);
//	rtobj.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void
//	{
//		var pro_arr:ArrayCollection= event.result as ArrayCollection;
//		for (var i:int=0;i<pro_arr.length;i++)
//		{
//			colorArray.addItem(new ObjectProxy(pro_arr[i]));
//		}
//	})
//}
////加载图例信息
//private function initLegend():void{
//	var legendBox:ElementBox=legendmap.elementBox;
//	var datas:ICollection=legendBox.toDatas();
//	for(var i:int = 0;i<datas.count;i++)
//	{
//		legendBox.selectionModel.selection.addItem(datas.getItemAt(i));
//	}
//	legendBox.removeSelection();
//	legendBox.layerBox.removeByID("legLayer");
//	var lArrays:ArrayCollection=new ArrayCollection();
//	var rtobj:RemoteObject=new RemoteObject("fiberWire");
//	rtobj.endpoint=ModelLocator.END_POINT;
//	rtobj.showBusyCursor=true;
//	if(curSysVendor!=""&&curSysVendor!=null){
//		rtobj.getLegend("fiber",curSysVendor);//"fiber",curSysVendor  "ocable","ZY0811"
//	}
//	rtobj.addEventListener(FaultEvent.FAULT,faultHandler);
//	rtobj.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void
//	{
//		try{
//			var pro_arr:ArrayCollection= event.result as ArrayCollection;
//			for(var i:int=0;i<pro_arr.length;i++)
//			{
//				lArrays.addItem(new ObjectProxy(pro_arr[i]));
//			}
//			var legLayer:Layer =new Layer("legLayer");
//			legendBox.layerBox.add(legLayer,0);
//			legLayer.movable = false;	
//			
//			var tmpX:int=15;
//			var tmpY:int=5;
//			var iCol:int=0;
//			for (var j:int=0;j<lArrays.length;j++)
//			{
//				if(lArrays[j].LCOLTYPE==1)
//				{
//					var node:Node=new Node();
//					node.layerID="legLayer";
//					node.name=lArrays[j].LNAME;
//					node.setStyle(Styles.LABEL_POSITION,Consts.POSITION_RIGHT);
//					node.setStyle(Styles.LABEL_XOFFSET,70);
//					node.setStyle(Styles.LABEL_SIZE,10);
//					if (lArrays[j].LNAME=="V-Node设备"||lArrays[j].LNAME=="C-Node设备")
//					{
//						node.setSize(20,10);
//					}
//					else
//					{
//						node.setSize(15,15);//(20,20)
//					}						
//					tmpY=iCol*20+6;
//					node.setLocation(tmpX+10,tmpY);
//					node.image=lArrays[j].LPATH;	
//					legendBox.add(node);
//					iCol++;
//				}
//				else
//				{
//					tmpY=iCol*20+6;
//					var node1:Node=new Node();
//					node1.setLocation(tmpX-2,tmpY);
//					node1.setSize(10,10);
//					node1.image="";
//					legendBox.add(node1);
//					var node2:Node=new Node();
//					node2.setLocation(tmpX+30-2,tmpY);
//					node2.setSize(10,10);
//					node2.image="";
//					legendBox.add(node2);
//					var link:Link=new Link(node1,node2);
//					link.name=lArrays[j].LNAME;
//					link.setStyle(Styles.LINK_COLOR,lArrays[j].LCOLOR);
//					link.setStyle(Styles.LABEL_POSITION,Consts.POSITION_RIGHT);
//					link.setStyle(Styles.LABEL_XOFFSET,70);
//					link.setStyle(Styles.LABEL_SIZE,10);
//					link.setStyle(Styles.LINK_WIDTH,1.5);
//					legendBox.add(link);
//					if (lArrays[j].ISDOUBLE==1)
//					{
//						var node12:Node=new Node();
//						node12.setLocation(tmpX-2,tmpY+4)
//						node12.setSize(10,10);
//						node12.image="";
//						legendBox.add(node12);
//						var node22:Node=new Node();
//						node22.setLocation(tmpX+30-2,tmpY+4);
//						node22.setSize(10,10);
//						node22.image="";
//						legendBox.add(node22);
//						var link11:Link=new Link(node12,node22);
//						link11.setStyle(Styles.LINK_COLOR,lArrays[j].LCOLOR);
//						link11.setStyle(Styles.LINK_WIDTH,1.5);
//						legendBox.add(link11);
//					}									
//					iCol++;
//				}
//			}
//		}catch(e:Error)
//		{
//			Alert.show(e.message,"initLegend");
//		}
//		legendPanel.height=tmpY+80;
//	})
//}
//private function createLink(from:Node,to:Node,name:String,groupID:int=-1,
//							color:int=-1,type:String=null,groupIndependent:Boolean=false,
//							gap:Number=-1,offset:Number=-1,bundleEnable:Boolean=true):Link{
//	var box:ElementBox=legendmap.elementBox;
//	var link:Link=new Link(from,to);
//	link.name=name;
//	if(type){
//		link.setStyle(Styles.LINK_TYPE,type);
//	}
//	if(color>=0){
//		link.setStyle(Styles.LINK_COLOR,color);
//	}
//	if(groupID>=0){
//		link.setStyle(Styles.LINK_BUNDLE_ID,groupID);
//	}
//	if(gap>0){
//		link.setStyle(Styles.LINK_BUNDLE_GAP,gap);
//	}
//	if(offset>0){
//		link.setStyle(Styles.LINK_BUNDLE_OFFSET,offset);
//	}
//	link.setStyle(Styles.LABEL_POSITION,Consts.POSITION_RIGHT);
//	link.setStyle(Styles.LABEL_XOFFSET,50);
//	link.setStyle(Styles.LABEL_SIZE,10);
//	link.setStyle(Styles.LINK_WIDTH,3);
//	link.setStyle(Styles.LINK_BUNDLE_EXPANDED, true);
//	link.setStyle(Styles.LINK_BUNDLE_ENABLE,true);
//	link.setStyle(Styles.LINK_BUNDLE_INDEPENDENT,groupIndependent);
//	box.add(link);
//	return link;
//}
//private function initCombox():void{	
//	//添加县区地图的入口 	added by gjzhang 2011-10-26
//	var comLabel:Label=new Label();
//	comLabel.text="县市";
//	provinceControl.addChild(comLabel);
//	var proCombox:ComboBox=new ComboBox();
//	proCombox.addEventListener(Event.CHANGE,comProvinceHandler);
//	proCombox.dataProvider=proArray;
//	proCombox.labelField="PROVINCENAME";
//	proCombox.width=80;
//	provinceControl.addChild(proCombox);
//	
//	//		var btnTrans:Button=new Button();
//	//		btnTrans.label="传输子系统";
//	//		btnTrans.addEventListener(MouseEvent.CLICK,btnHanlder);
//	//		provinceControl.addChild(btnTrans);
//	
//	var rtobj:RemoteObject=new RemoteObject("fiberWire");
//	rtobj.endpoint=ModelLocator.END_POINT;
//	rtobj.showBusyCursor=true;
//	rtobj.getProvinceByProName(getoperDesc);
//	rtobj.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void
//	{
//		var pro_arr:ArrayCollection= event.result as ArrayCollection;
//		for (var i:int=0;i<pro_arr.length;i++)
//		{
//			proArray.addItem(new ObjectProxy(pro_arr[i]));
//		}
//	})
//}				
//
//private var numZoom:Number=4;
//private function reSetFontSizeZoom(param:String):void{
//	if(param == 'IN'){
//		if(numZoom >= 10){
//			numZoom = 10;
//		}else{
//			numZoom++;
//			systemorgmap.zoomIn(false);
//		}
//	}else if(param == "OUT"){
//		if(numZoom <= -1){
//			numZoom == -1;
//		}else{
//			numZoom--;
//			systemorgmap.zoomOut(false);
//		}
//	}
//	
//	if(numZoom<=10 && numZoom >= -1){
//		//Alert.show(numZoom.toString());
//		
//		if(numZoom == 0){
//			fontsize= 21;
//		}else if(numZoom == 1){
//			fontsize= 19;
//		}else if(numZoom ==2 ){
//			fontsize= 17;
//		}else if(numZoom ==3 ){
//			fontsize= 14;
//		}else if(numZoom ==4 ){
//			fontsize= 12;
//		}else if(numZoom == 5){
//			fontsize= 10;
//		}else if(numZoom ==6 ){
//			fontsize= 9;
//		}else if(numZoom ==7 ){
//			fontsize= 8;
//		}else if(numZoom ==8 ){
//			fontsize= 7;
//		}else if(numZoom ==9 ){
//			fontsize= 6;
//		}else if(numZoom ==10 ){
//			fontsize= 5;
//		}
//		var count:int=elementBox.datas.count;
//		for(var i:int=0;i<count;i++){
//			(elementBox.datas.getItemAt(i) as Element).setStyle(Styles.LABEL_SIZE,fontsize);
//		}
//	}
//	
//}
//
//private function reSetFontSizeReset():void{
//	numZoom = 6;
//	fontsize= 9;
//	var count:int=elementBox.datas.count;
//	for(var i:int=0;i<count;i++){
//		(elementBox.datas.getItemAt(i) as Element).setStyle(Styles.LABEL_SIZE,fontsize);
//	}		
//}
//
//private function reSetFontSizeOverVIew():void{
//	numZoom = 0;
//	fontsize= 21;
//	var count:int=elementBox.datas.count;
//	for(var i:int=0;i<count;i++){
//		(elementBox.datas.getItemAt(i) as Element).setStyle(Styles.LABEL_SIZE,fontsize);
//	}
//}
//
//public function createRadioButton(name:String,value:String,vendor:String):RadioButton
//{
//	var sysRadioButton:RadioButton=new RadioButton();
//	sysRadioButton.label=name;
//	sysRadioButton.value=value+"#"+vendor;
//	return sysRadioButton;
//}
//private function radioButtonChangeHandler(event:Event):void
//{
//	var tmpValue:String;
//	tmpValue=RadioButtonGroup(event.target).selectedValue.toString();
//	system.systemcode= tmpValue.split("#",2)[0].toString();
//	curSysname= tmpValue.split("#",2)[0].toString();
//	this.curSysVendor= tmpValue.split("#",2)[1].toString();
//	curSysProCode=tmpValue.split("#",2)[0].toString();
//	initLegend();//加载图例
//	//刷新树
//	DeviceXML=new XMLList(curXML);
//	addEventListener(EventNames.CATALOGROW, gettree);
//	if (curSysVendor=="ZY0810")
//	{
//		showLineRate="'ZY110601','ZY110602','ZY110603','ZY110604'";
//	}
//	else
//	{
//		var value:String="";
//		for each(var item:* in rateControl.getChildren())
//		{
//			if(item is CheckBox)
//			{
//				if(item.selected)
//				{
//					value+="'"+item.data.toString()+"',";
//				}
//			}
//		}
//		if(value != "")
//		{
//			showLineRate = value.substr(0,value.length-1);
//		}else{
//			showLineRate = '';			
//		}
//	}
//	equipCollection=null;
//	//	   searchText.txt.text="";
//	freshAddNodeAfterExpand(system);	
//}
//public function createCheckBox(name:String,value:String):CheckBox{
//	var chk:CheckBox = new CheckBox();
//	chk.label =name;
//	chk.data=value;
//	if (value!="ZY110601")
//	{
//		chk.selected = true;
//	}
//	chk.addEventListener(Event.CHANGE,checkbox_changeHandler);
//	return chk;
//}	
////checkbox选择电压等级
//protected function checkbox_changeHandler(event:Event):void
//{
//	
//	var value:String="";
//	for each(var item:* in rateControl.getChildren())
//	{
//		if(item is CheckBox)
//		{
//			if(item.selected)
//			{
//				value+="'"+item.data.toString()+"',";
//			}
//		}
//	}
//	if(value != "")
//	{
//		showLineRate = value.substr(0,value.length-1);
//	}else{
//		showLineRate = '';			
//	}
//	
//	if(system.systemcode!="")
//	{
//		freshAddNodeAfterExpand(system);
//	}
//}
//[Bindable] private var show:Follower;
////设置搜索指针
//private function addPointer(node:Node):void{
//	var item:Node=systemorgmap.elementBox.getElementByID('showPointer'+node.id) as Node;
//	if(item == null){
//		show = new Follower('showPointer'+node.id);
//		show.setClient('NodeType',"pointer");
//		show.image = "assets/images/swf/sysgraph/showpointer.swf";//"showPointer";
//		show.layerID="pointerLayer";
//		show.width=24;			
//		show.location = new Point(node.x-4,node.y-56);
//		show.host = node;
//		systemorgmap.elementBox.add(show);
//	}
//}
////清空指针
//private function clearPointer():void{
//	if(show!=null)
//	{
//		systemorgmap.elementBox.selectionModel.clearSelection();
//		systemorgmap.elementBox.selectionModel.appendSelection(show);
//		systemorgmap.elementBox.removeSelection();
//		//			elementBox.selectionModel.selection.clear();
//		//			
//		//			elementBox.selectionModel.selection.addItem(show);
//		//			elementBox.removeSelection();
//	}
//	
//}
//
//private function loadBG():void{
//	
//	var nodeMap:Node = new Node("mapLayer");//背景地图
//	//		nodeMap.image = this.getProvince;
//	//	nodeMap.image="assets/images/swf/ocable/map/" + this.getoperDesc+ ".swf"
//	nodeMap.image=this.getoperDesc;
//	nodeMap.layerID="mapLayer";			
//	
//	elementBox.add(nodeMap);
//	//			if(this.getProvince == '主干'){
//	//	nodeMap.width = 2100;
//	//	nodeMap.height =2600;
//	//	systemorgmap.zoom=1;
//	//			}else {
//	//				nodeMap.location = new Point(200,0);
//	//				nodeMap.width =  1000;
//	//				nodeMap.height = 800;
//	//				systemorgmap.zoom =0.9;				
//	//			}
//	//	if(this.getProvince == '主干'){
//	//		nodeMap.width = 2100;
//	//		nodeMap.height = 2600;
//	//		systemorgmap.zoom = 0.25;
//	//	}else if(this.getProvince == '闻喜县'){
//	//		nodeMap.width = 2100;
//	//		nodeMap.height = 2600;
//	//		systemorgmap.zoom = 0.4;
//	//	}
//	//	else{
//	//		//nodeOcable.width = 300;
//	//		//nodeOcable.height = 600;
//	//		nodeMap.width = 2100;
//	//		nodeMap.height = 2600;
//	//		systemorgmap.zoom = 0.2;
//	//	}
//	
//	//	systemorgmap.zoom = Number(str.ZOOM);
//	//	if(Number(str.WIDTH)!=0){
//	//		nodeMap.width = Number(str.WIDTH);
//	//		nodeMap.height = Number(str.HEIGHT);
//	//	}
//	
//	
//	systemorgmap.callLater(function():void{
//		var item:Node = systemorgmap.elementBox.getElementByID("mapLayer") as Node;
//		var node:Node = new Node("node0");
//		node.layerID = "mapLayer";
//		node.setSize(1,1);
//		node.setLocation(item.width, item.height);
//		elementBox.add(node);
////		systemorgmap.zoom = Number(str.ZOOM);
//		systemorgmap.callLater2(function(){
////			systemorgmap.setZoom(systemorgmap.zoom,false);
//			systemorgmap.zoomOverview();
//			var mapx:Number = systemorgmap.width/systemorgmap.zoom/2 - item.width/2;
//			var mapy:Number = systemorgmap.height/systemorgmap.zoom/2 - item.height/2;
//			xoffset = mapx - item.x;
//			yoffset = mapy - item.y;
//			item.setLocation(mapx, mapy);
//			systemorgmap.alpha=1;
////			fw.getSystemTreeByProvinceName(getProvince);
//		});
//	});
//	systemorgmap.interactionHandlers=new Collection([
//		new CustomInteractionHandler(systemorgmap),  
//		new MoveInteractionHandler(systemorgmap), 
//		new DefaultInteractionHandler(systemorgmap),]);		
//}
///**
// * 加载地图 
// */
//private function createBackgroundImage():void{
//	mapLayer=new Layer("mapLayer");
//	elementBox.layerBox.add(mapLayer,0);
//	mapLayer.movable = false;
//	loadBG();
//	systemorgmap.selectionModel.filterFunction=function(data:Element):Boolean{//地图中设置不允许点击地图图层和指针图层
//		return data.layerID != "mapLayer" && data.layerID != "pointerLayer";
//	};
//}	
//private function reSetFontSize():void{
//	var zoom:Number=systemorgmap.zoom;
//	if(this.getProvince == '主干'){
//		fontsize= 10;
//	}
//	if(zoom<=1.0){
//		fontsize=parseInt((fontsize/zoom).toString());
//		var count:int=elementBox.datas.count;
//		for(var i:int=0;i<count;i++){				
//			(elementBox.datas.getItemAt(i) as Element).setStyle(Styles.LABEL_SIZE,fontsize);
//		}
//	}
//}
//private function deviceTreeItemSelectHandler(event:ContextMenuEvent):void
//{
//	var itemDel:ContextMenuItem=new ContextMenuItem("删除设备");
//	itemDel.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemAddHandler);
//	deviceTree.selectedIndex=curIndex;
//	if (deviceTree.selectedItem)
//	{
//		if (deviceTree.selectedItem.@isBranch == "false")
//			deviceTree.contextMenu.customItems=[itemDel];
//		else
//		{			
//			deviceTree.contextMenu.customItems=null;
//		}
//	}
//}
//
//private function AfterSaveAllSysOrgMap(event:ResultEvent):void
//{
//	Alert.show("保存系统坐标成功，再次打开系统组织图后开始生效", "提示");
//}
//
////获取光缆路由图数据
//private function OcableRoutInfoHandler(e:ContextMenuEvent):void
//{
//	var link:Link=(Element)(systemorgmap.selectionModel.lastData);
//	var toplinkID:String=link.getClient("code");
//	if (toplinkID != null)
//	{
//		var remoteObject:RemoteObject=new RemoteObject("fiberWire");
//		remoteObject.endpoint=ModelLocator.END_POINT;
//		remoteObject.addEventListener(ResultEvent.RESULT, getOcableRoutInfoHandler);
//		parentApplication.faultEventHandler(remoteObject);
//		remoteObject.getOcableRoutInfo(toplinkID);
//	}
//	else
//	{
//		Alert.show("无相关数据!", "提示");
//	}
//}
//
//private function getOcableRoutInfoHandler(event:ResultEvent):void
//{
//	var datas:OcableRoutInfoData=event.result as OcableRoutInfoData;
//	var ori:OcableRoutInfo=new OcableRoutInfo();
//	
//	if (datas != null && datas.channelRoutModelData != null && datas.stationNames != null && datas.systemName != null)
//	{
//		ori.datas=datas;
//		ori.title = "光路信息";
//		
//		MyPopupManager.addPopUp(ori);	
//	}
//	else
//	{
//		Alert.show("无相关数据!", "提示");
//	}
//	
//}
//
//private function configEquipSlot(e:ContextMenuEvent):void
//{
//	var slot:configSlot=new configSlot();
//	var node:Node=(Element)(systemorgmap.selectionModel.lastData);
//	slot.equipcode=node.getClient("code").toString();
//	MyPopupManager.addPopUp(slot, true);
//	slot.equip.text=node.getClient("name");
//}
//
//private function itemAddHandler(event:ContextMenuEvent):void //添加设备
//{
//	Alert.show("您确认要删除吗？", "提示", Alert.YES | Alert.NO, this, delHandler);
//}
//
//private var delEquipcode:String;
//
//private function delHandler(event:CloseEvent):void
//{
//	if (event.detail == Alert.YES)
//	{
//		delEquipcode=deviceTree.selectedItem.@code;
//		var ro:RemoteObject=new RemoteObject("equInfo");
//		ro.endpoint=ModelLocator.END_POINT;
//		ro.showBusyCursor=true;
//		parentApplication.faultEventHandler(ro);
//		ro.addEventListener(ResultEvent.RESULT, hasEquipPackHandler);
//		ro.hasEquipPack(delEquipcode);
//	}
//}
//
//private function hasEquipPackHandler(event:ResultEvent):void
//{
//	if (event.result.toString() == "true")
//	{
//		Alert.show("不能删除此设备!", "提示");
//	}
//	else
//	{
//		var ro:RemoteObject=new RemoteObject("equInfo");
//		ro.endpoint=ModelLocator.END_POINT;
//		ro.showBusyCursor=true;
//		parentApplication.faultEventHandler(ro);
//		ro.addEventListener(ResultEvent.RESULT, delEquipHandler);
//		ro.delEquip(delEquipcode);
//	}
//}
//
//private function delEquipHandler(event:ResultEvent):void
//{
//	Alert.show("设备删除成功!", "提示");
//}
//
//private var vendor:String;
//
//private function addEquInfoHandler(event:ParameterEvent):void
//{
//	var node:Node=systemorgmap.elementBox.getElementByID(nodeId) as Node;
//	if (node)
//	{
//		node.setClient("code",event.parameter1.toString());
//		node.setClient("name",event.parameter2.toString());
//		var f:Follower = new Follower("label"+event.parameter1.toString());				
//		f.setClient('code',event.parameter1.toString());			
//		f.host = node;
//		f.name = event.parameter2.toString();
//		f.image = "";
//		f.width = 0;
//		f.height = 0;
//		f.setStyle(Styles.LABEL_SIZE,10);	
//		f.centerLocation=node.centerLocation;
//		systemorgmap.elementBox.add(f);
//		
//		var rt:RemoteObject=new RemoteObject("fiberWire");
//		rt.endpoint=ModelLocator.END_POINT;
//		rt.showBusyCursor=true;
//		var equipcode:String=event.parameter1.toString();
//		
//		rt.createFrameandSlot("ZY0801","FT0102",equipcode);
//	}
//	
//	Alert.show("设备添加成功!", "友情提示");
//	
//	for (var i:int=0; i < deviceTree.dataProvider.children().length(); i++)
//	{
//		if (vendor == deviceTree.dataProvider.children()[i].@label)
//		{
//			deviceTree.selectedIndex=i + 1;
//			curIndex=i + 1;
//			selectedNode=deviceTree.selectedItem as XML;
//			delete selectedNode.folder;
//			catalogsid=selectedNode.attribute("code");
//			type=selectedNode.attribute("type");
//			var rt_DeviceTree:RemoteObject=new RemoteObject("fiberWire");
//			rt_DeviceTree.endpoint=ModelLocator.END_POINT;
//			rt_DeviceTree.showBusyCursor=true;
//			rt_DeviceTree.addEventListener(ResultEvent.RESULT, generateDeviceTreeInfo);
//			rt_DeviceTree.addEventListener(FaultEvent.FAULT, faultDeviceTreeInfo);
//			rt_DeviceTree.getTransDevice(catalogsid, type); //获取传输设备树的数据
//			break;
//		}
//	}
//	
//}	
////点击树触发事件：
//private function treeChange():void
//{
//	deviceTree.selectedIndex=curIndex;
//	selectedNode=deviceTree.selectedItem as XML;
//	if (selectedNode.@leaf == false && (selectedNode.children() == null || selectedNode.children().length() == 0))
//	{
//		catalogsid=selectedNode.attribute("code");
//		type=selectedNode.attribute("type");	
//		dispatchEvent(new Event(EventNames.CATALOGROW));
//	}
//}
//
////点击树项目取到其下一级子目录  
//private function initEvent():void
//{ //初始化事件	
//	Alert.show("initEvent");
////	addEventListener(EventNames.CATALOGROW, gettree);
//}
//private function gettree(e:Event):void
//{	
//	Alert.show("gettree");
////	removeEventListener(EventNames.CATALOGROW, gettree);
////	var rt_DeviceTree:RemoteObject=new RemoteObject("fiberWire");
////	rt_DeviceTree.endpoint=ModelLocator.END_POINT;
////	rt_DeviceTree.showBusyCursor=true;
////	rt_DeviceTree.getTransEquips(curSysname);
////	rt_DeviceTree.addEventListener(ResultEvent.RESULT, generateDeviceTreeInfo);
////	rt_DeviceTree.addEventListener(FaultEvent.FAULT, faultDeviceTreeInfo);
//}
//private function afterSaveSysOrgMap(e:ResultEvent):void //保存系统组织图后的处理
//{
//	if (e.result == true)
//	{
//		Alert.show("保存成功！", "提示");
//	}
//	else
//	{
//		Alert.show("保存失败！", "提示");
//	}
//}
////对加载树后的处理
//private function resultHandler(event:ResultEvent):void
//{
//	Alert.show("resultHandler");
////	if(event.result!=null)
////	{
////		var comLabel:Label=new Label();
////		comLabel.text="传输系统：";
////		sysControl.addChild(comLabel);
////		
////		var sys_array:ArrayCollection= event.result as ArrayCollection;
////		if(getProvince != '主干'){
////			for(var i:int=0;i<sys_array.length;i++)
////			{
////				var sysRadioButton:RadioButton=createRadioButton(sys_array[i].systemname,sys_array[i].systemcode,sys_array[i].vendor);
////				if(i == 0){
////					sysRadioButton.selected=true;
////					
////					curSysname=sys_array[i].systemcode;
////					system.systemcode=sys_array[i].systemcode;
////					curSysVendor=sys_array[i].vendor
////					freshAddNodeAfterExpand(system);
////				}
////				sysRadioButton.group=radioGroup;
////				sysControl.addChild(sysRadioButton);
////			}
////		}else{
////			for(var i:int=0;i<sys_array.length;i++)
////			{
////				var sysRadioButton:RadioButton=createRadioButton(sys_array[i].systemname,sys_array[i].systemcode,sys_array[i].vendor);
////				if(sys_array[i].systemcode=="全省/主干NEC")
////				{
////					sysRadioButton.selected=true;
////					system.systemcode=sys_array[i].systemcode;
////					curSysname=sys_array[i].systemcode;
////					curSysVendor=sys_array[i].vendor;
////					freshAddNodeAfterExpand(system);
////				}
////				sysRadioButton.group=radioGroup;
////				sysControl.addChild(sysRadioButton);				
////			}	
////		}
////	}
//	initLegend();//加载图例
//}
//// 错误处理
//public function DealFault(event:FaultEvent):void //加载系统树失败的处理
//{
//	Alert.show(event.fault.toString());
//}
//
//private function generateDeviceTreeInfo(event:ResultEvent):void //对传输设备树展开载事件的处理
//{
////	var str:String=event.result as String;
////	if (str != null && str != "")
////	{
////		var child:XMLList=new XMLList(str);
////		curRootXML=child;
////		if (selectedNode.children() == null || selectedNode.children().length() == 0)
////		{
////			selectedNode.appendChild(child);
////			deviceTree.callLater(openTreeNode, [selectedNode]);
////		}
////	}
////	addEventListener(EventNames.CATALOGROW, gettree);
//}
//
//private function openTreeNode(xml:XML):void //展开树结点
//{
//	if (deviceTree.isItemOpen(xml))
//		deviceTree.expandItem(xml, false);
////	deviceTree.expandItem(xml, true);
//}
//
//private function faultDeviceTreeInfo(event:FaultEvent):void
//{
//	Alert.show(event.fault.toString());
//}
//
////设置不同图表           
//private function iconFun(item:Object):*
//{ //为传输系统树的结点设置图标
//	return ModelLocator.systemIcon;
//}
//
//private function deviceiconFun(item:Object):* //为传输设备树的结点添加图标
//{
//	if (item.@leaf == true)
//		if (item.@subnet == null)
//		{
//			return ModelLocator.equipIcon1;
//		}
//		else 
//		{
//			return ModelLocator.equipIcon;
//		}
//		else
//			return DemoImages.file;
//}
//
////清除节点
//private function clearResourceInfo():void{
//	for(var i:int = 0;i<elementBox.toDatas().count;i++){
//		var ielement:IElement=elementBox.toDatas().getItemAt(i);
//		if(ielement is Node){
//			if((elementBox.datas.getItemAt(i) as Node).id != this.getProvince&&(elementBox.datas.getItemAt(i) as Node).id !="node0"&&
//				ielement.id != 'nodeLayer' && ielement.layerID != "mapLayer")
//				elementBox.selectionModel.selection.addItem(elementBox.datas.getItemAt(i));
//		}
//	}
//	systemorgmap.elementBox.removeSelection();
//}
//
///**
// *  获取数据
// *   
// */
//private function freshAddNodeAfterExpand(system:Location):void
//{
////	clearResourceInfo();
////	
////	var equipcode:String=Registry.lookup("equipcode");
////	if(equipcode!=null)
////	{
////		Registry.unregister("equipcode");
////	}
////	var rtobj:RemoteObject=new RemoteObject("fiberWire");
////	rtobj.endpoint=ModelLocator.END_POINT;
////	rtobj.showBusyCursor=true;
////	rtobj.getSystemData(system.systemcode,showLineRate,getoperDesc);
////	parentApplication.faultEventHandler(rtobj);
////	rtobj.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void
////	{
////		var xml:String=event.result.toString();
////		var equips:Array=(JSON.decode(xml.split("---")[0].toString()) as Array); //获取该系统的设备数组
////		var ocables:Array=(JSON.decode(xml.split("---")[1].toString()) as Array); //获取该系统的复用段数组	
////		var topolink_geos:Array=(JSON.decode(xml.split("---")[2].toString()) as Array);//获取该系统的所有拐点
////		try{
////			for (var i:int=0; i < equips.length; i++)
////			{	
////				var equip:Object=equips[i] as Object;			
////				var node:Node=new Node(equip.equipcode);		
////				node.setClient("parent", equip.systemcode);
////				node.setClient("NodeType","equipment");
////				node.layerID="resLayer";
////				node.setClient("code",equip.equipcode);	
////				node.setClient("name",equip.equipname);
////				node.setClient("stationcode",equip.stationcode);
////				node.setClient("stationname",equip.stationname);
////				node.setClient("x_model",equip.x_model);
////				if (equip.x_model=="NEC_SDH_C-NODE")
////				{
////					node.setClient("isShow","no");
////				}
////				else
////				{
////					node.setClient("isShow","yes");
////				}
////				node.setStyle(Styles.LABEL_SIZE,12);
////				var tipInfo:String;
////				tipInfo="设备名称："+equip.equipname+"\n"+"所属局站："+equip.stationname+"\n"+"设备型号："+equip.x_model;
////				node.toolTip=tipInfo;
////				var x_model:String=equip.x_model;
////				var re1:RegExp = new RegExp("/", "g"); 
////				var img_x_model:String=x_model.replace(re1,"");
////				var re2:RegExp = new RegExp(" ", "g");
////				img_x_model=img_x_model.replace(re2,"");
////				img_x_model=img_x_model.replace("马可尼", "Marconi");
////				img_x_model=img_x_model.replace("烽火", "Fenhuo");
////				img_x_model=img_x_model.replace("（华为）", "");
////				img_x_model=img_x_model.replace("(华为Metro3000)", "");
////				img_x_model=img_x_model.replace("(华为Metro1000)", "");
////				node.image="assets/images/swf/sysGraph/"+img_x_model+".swf";
////				node.setSize(40,40);
////				
////				var x:int=equip.x;
////				var y:int=equip.y;				
////				node.setClient("parent_x", system.x);
////				node.setClient("parent_y", system.y);	
////				node.setLocation(x + system.x+xoffset, y + system.y+yoffset);
////				node.setStyle(Styles.LABEL_YOFFSET, -2);
////				node.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
////				node.setStyle(Styles.SELECT_COLOR,"0x7697C9");//0x00FF00
////				node.setStyle(Styles.SELECT_WIDTH,'3');
////				
////				//			var alarmcount:String=equip.alarmcount;
////				//			var alarmlevel:String=equip.alarmlevel;					
////				//			if(alarmlevel!="null"&&alarmcount!="0"&&alarmcount!="null")
////				//			{						
////				//				告警
////				//				node.alarmState.setNewAlarmCount(AlarmSeverity.getByValue(int(alarmlevel)),int(alarmcount));
////				//				
////				//			}
////				systemorgmap.elementBox.add(node);
////				
////				var wdx:int=equip.wdx;
////				var wdy:int=equip.wdy;
////				
////				//组b
////				if((node.getClient("stationcode")!=' ') && node.getClient("stationcode")!=null
////					&& node.getClient("stationcode")!="null"&& node.getClient("stationcode")!=""  )
////				{
////					var stationNode:Node= systemorgmap.elementBox.getDataByID("station"+node.getClient("stationcode")) as Node;
////					if(stationNode==null)
////					{
////						stationNode=new Node("station"+node.getClient("stationcode"));				
////						stationNode.setClient("nodeName",node.getClient("stationname"));
////						stationNode.setClient("NodeType","station");
////						stationNode.setClient("isShow","yes");
////						stationNode.name=node.getClient("stationname");
////						stationNode.layerID="resLayer";
////						if(getProvince != '主干'){
////							stationNode.setStyle(Styles.LABEL_SIZE,16);
////						}else{
////							stationNode.setStyle(Styles.LABEL_SIZE,20);
////						}
////						var stationx:Number = wdx + system.x+10;
////						var stationy:Number = wdy + system.y+10;
////						if(equip.stationx!=null&&equip.stationx!=""){
////							stationx = equip.stationx;
////						}
////						if(equip.stationy!=null&&equip.stationy!=""){
////							stationy = equip.stationy;
////						}						
////						stationNode.setLocation(stationx+xoffset,stationy+yoffset);
////						stationNode.image = "";
////						stationNode.width=0;
////						stationNode.height=0;
////						stationNode.setClient("stationcode",node.getClient("stationcode"));
////						systemorgmap.elementBox.add(stationNode);						
////					}
////					node.parent = stationNode;
////				}		
////			}/*equip*/
////			
////		}catch(e:Error){
////			Alert.show("error:" + e.message);
////		}
////		
////		for ( i=0; i < ocables.length; i++) //把系统内部设备之间的复用段以及与其他系统的复用段添加进来
////		{
////			var ocable:Object=ocables[i] as Object;
////			var equip_a:String=ocable.equip_a;
////			var system_a:String=ocable.system_a;
////			var equip_z:String=ocable.equip_z;
////			var system_z:String=ocable.system_z;
////			var label:String=ocable.label;
////			var labelname:String=ocable.aendptpxx + "-" + ocable.zendptpxx;	
////			var node_a:Node=null;
////			var node_z:Node=null;
////			
////			node_a=systemorgmap.elementBox.getDataByID(equip_a) as Node;
////			node_z=systemorgmap.elementBox.getDataByID(equip_z) as Node;			
////			
////			
////			if(node_a!=null&&node_z!=null)
////			{				
////				var link:ShapeLink=new ShapeLink(label,node_a,node_z);
////				var lorduse:String=ocable.lorduse; //所属主备用的主用复用段
////				var ringid:String=ocable.ringid; //主备用主键	
////				var sparetopolink:String=ocable.sparetopolink; //备用复用段编号组
////				var backupringid:String=ocable.backupringid;	
////				
////				link.setStyle(Styles.LINK_COLOR,ocable.linkcolor);
////				link.setClient("lorduse", lorduse);
////				link.setClient("ringid", ringid);				
////				link.setClient("equip_a", equip_a);
////				link.setClient("equip_z", equip_z);
////				link.setClient("labelname", labelname);
////				link.toolTip=labelname;
////				link.setClient("sparetopolink", sparetopolink);
////				link.setClient("backupringid", backupringid);
////				link.setStyle(Styles.LINK_BUNDLE_OFFSET, 20);
////				link.setStyle(Styles.LINK_BUNDLE_GAP, 10);
////				link.setStyle(Styles.LINK_BUNDLE_EXPANDED, true);
////				link.setStyle(Styles.LINK_BUNDLE_ENABLE,true);
////				link.setStyle(Styles.LINK_TYPE,Consts.LINK_TYPE_TRIANGLE);
////				link.setClient("code",label);
////				link.setClient("linerate", ocable.linerate);
////				link.setClient("systemname",system.systemcode);
////				link.setClient("isShow","yes");
////				link.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
////				link.setStyle(Styles.SELECT_WIDTH,'3');				
////				link.setStyle(Styles.SELECT_COLOR,"0x7697C9");//0x00FF00
////				link.layerID="resLayer";
////				systemorgmap.elementBox.add(link);		
////			}	
////		}/*ocable*/
////		
////		
////		
////		systemorgmap.elementBox.selectionModel.selection.clear();
////		
////		if(showLineRate!=null && showLineRate!="" && showLineRate !== '')
////		{
////			var deleteNodes:Array=new Array();
////			for(var i:int = 0;i<systemorgmap.elementBox.toDatas().count;i++)
////			{
////				var ielement:IElement=systemorgmap.elementBox.toDatas().getItemAt(i);
////				if(ielement is Node)
////				{
////					var node:Node=ielement as Node;
////					if((node.getClient("NodeType")=='equipment'))
////					{
////						if(node.links==null)
////						{
////							systemorgmap.elementBox.selectionModel.selection.addItem(node);
////							
////						}
////					}
////				}
////			}
////			
////			systemorgmap.elementBox.removeSelection();
////			
////			//过滤局站名称
////			for(var i:int = 0;i<systemorgmap.elementBox.toDatas().count;i++)
////			{
////				var ielement:IElement=systemorgmap.elementBox.toDatas().getItemAt(i);
////				if(ielement is Node)
////				{
////					var node:Node=ielement as Node;
////					if(node.getClient("NodeType")=='station'){
////						if(node.childrenCount == 0){
////							systemorgmap.elementBox.selectionModel.selection.addItem(node);							
////						}
////					}
////				}
////			}
////			systemorgmap.elementBox.removeSelection();
////			//			systemorgmap.elementBox.selectionModel.filterFunction
////		}		
////		for(var i:int=0;i<topolink_geos.length;i++)
////		{
////			var label:String=topolink_geos[i].label;
////			var point_x:String=topolink_geos[i].x;
////			var point_y:String=topolink_geos[i].y;
////			var serial:String=topolink_geos.serial;
////			if(systemorgmap.elementBox.getDataByID(label)!=null)
////			{
////				(systemorgmap.elementBox.getDataByID(label) as ShapeLink).addPoint(new Point(Number(point_x)+xoffset,Number(point_y)+yoffset));
////			}
////		}
////		
////		if(equipcode!=null)
////		{
////			
////			var selectnode:Node=systemorgmap.elementBox.getDataByID(equipcode) as Node;
////			if(selectnode!=null)
////			{				
////				systemorgmap.elementBox.selectionModel.selection.addItem(selectnode);
////				systemorgmap.dispatchEvent(new SelectionChangeEvent(twaver.Consts.EVENT_SELECTION_CHANGE));
////			}	
////		}
////	});/*addListener*/
//}
//
//private function comProvinceHandler(e:Event):void{
//	curSysPro="";
//	setProvince=e.currentTarget.selectedItem.PROVINCENAME;
//	setoperDesc=e.currentTarget.selectedItem.PROVINCE;
//	this.getSysNameBy(curSysVendor,e.currentTarget.selectedItem.PROVINCE);
//}
//private function getSysNameBy(tmpVendor:String,tmpPro:String):void{
//	
//	var rtobj:RemoteObject=new RemoteObject("fiberWire");
//	rtobj.endpoint=ModelLocator.END_POINT;
//	rtobj.showBusyCursor=true;
//	rtobj.getSysNameBy(tmpVendor,tmpPro);
//	rtobj.addEventListener(FaultEvent.FAULT,getSysfaultHandler);
//	rtobj.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void
//	{
//		curSysPro= event.result as String;
//		system.systemcode= curSysPro;
//		equipCollection=null;
//		//			searchText.txt.text="";
//		freshAddNodeAfterExpand(system);
//	})
//}
//private function getSysfaultHandler(event:FaultEvent):void{
//	Alert.show(event.message.toString(),"getSysNameBy");
//}
//private function btnHanlder(e:Event):void{
//	var tSystem:transsystemManager=new transsystemManager();
//	tSystem.curSysName=curSysname;
//	MyPopupManager.addPopUp(tSystem, true);
//}
//private var fontnummber:int = 0;
////工具条事件处理
//private function clickBtns(e:ItemClickEvent):void
//{
//	if (e.index==0)
//	{		
//		systemorgmap.setDefaultInteractionHandlers();
//	}
//	else if (e.index==1)
//	{
//		if(systemorgmap.zoom < 1.0){
//			fontnummber = fontnummber + 2;
//			systemorgmap.zoomIn(false);			
//			systemorgmap.callLater(function():void{
//				reSetFontSize(); 
//				if(centerFlag2)
//				{	
//					systemorgmap.centerByLogicalPoint(systemorgmap.getScopeRect(Consts.SCOPE_ROOTCANVAS).width/2,systemorgmap.getScopeRect(Consts.SCOPE_ROOTCANVAS).height/2); 
//					centerFlag2=false;
//				}
//			});
//		}
//	}
//	else if (e.index==2)
//	{
//		if(systemorgmap.zoom >0.3){
//			fontnummber = fontnummber - 2;
//			if(systemorgmap.verticalScrollBar||systemorgmap.horizontalScrollBar)
//			{systemorgmap.zoomOut(false); 
//				systemorgmap.callLater(function():void{
//					reSetFontSize();
//					if(systemorgmap.verticalScrollBar==null&&systemorgmap.horizontalScrollBar==null)
//					{
//						centerFlag2=true;
//					}
//				});
//			}
//		}
//	}
//	else if (e.index==3)
//	{
//		systemorgmap.zoomOverview(false);
//		centerFlag2=true;
//		systemorgmap.callLater(function():void{reSetFontSize();});
//		
//	}
//	else if (e.index==4) 
//	{
//		if  (mFlag)
//		{
//			mFlag=false;										
//			proArray1.setItemAt(e.item,4).icon=lock;
//			proArray1.setItemAt(e.item,4).label="编辑视图";
//		}
//		else
//		{
//			mFlag=true;
//			proArray1.setItemAt(e.item,4).icon=unlock;
//			proArray1.setItemAt(e.item,4).label="锁定视图";
//		}
//	}
//	else if(e.index==5)
//	{
//		var fr:Object = new FileReference();	
//		if(fr.hasOwnProperty("save")){
//			var bitmapData:BitmapData = systemorgmap.exportAsBitmapData(); 
//			var encoder:PNGEncoder = new PNGEncoder();
//			var data:ByteArray = encoder.encode(bitmapData);
//			fr.save(data, 'network.png');
//		}else{
//			Alert.show("install Flash Player 10 to run this feature", "Not Supported"); 
//		}
//	}
//	else if (e.index==6)
//	{
//		systemorgmap.setEditInteractionHandlers();
//	}
//	else if(e.index==7)
//	{
//		if(systemorgmap.selectionModel.count > 0){
//			var item:Object = systemorgmap.selectionModel.selection.getItemAt(0);
//			if(item is ShapeLink){
//				var link:ShapeLink = systemorgmap.selectionModel.selection.getItemAt(0) as ShapeLink;
//				var rtobj1:RemoteObject=new RemoteObject("fiberWire");
//				rtobj1.endpoint=ModelLocator.END_POINT;
//				rtobj1.showBusyCursor=true;
//				rtobj1.addEventListener(ResultEvent.RESULT, saveTopolinkGeoHandler);
//				parentApplication.faultEventHandler(rtobj1);
//				
//				rtobj1.saveTopolinkGeo(link.getClient("code").toString(),getTopolinkGeo(link));					
//			}else{
//				Alert.show("请选择一条复用段!","提示!");
//			}
//		}
//		else
//		{
//			Alert.show("请选中要保存的复用段！","提示");
//		}	
//	}
//		//	else if (e.index==8)
//		//	{
//		//		DeviceXML=new XMLList(curXML);
//		//		addEventListener(EventNames.CATALOGROW, gettree);
//		//		if(system.systemcode!="")
//		//		{
//		//			freshAddNodeAfterExpand(system);
//		//		}	
//		//	}
//	else if(e.index==8)
//	{
//		legendPanel.visible=!legendPanel.visible;
//	}
//	else if(e.index==9)
//	{
//		//			leftpanel.visible=!leftpanel.visible;
//		//			leftpanel.includeInLayout=!leftpanel.includeInLayout;	
//	}
//}
////对系统组织图中的network的双击事件的处理函数
//private function test(e:MouseEvent):void
//{	
//	if (systemorgmap.selectionModel.count > 0) //如果当前选中的结点>0
//	{
//		//获取当前选中的结点
//		var element:IElement=(Element)(systemorgmap.selectionModel.lastData);
//		if (element is Node&&element.getClient("NodeType")=="equipment") //判断选中的元素是不是结点
//		{ //选中节点  
//			var node:Node=element as Node;	
//			Registry.register("systemcode", node.getClient("parent").toString());
//			Registry.register("equipcode", node.getClient("code").toString());
//			Application.application.openModel("设备面板图", false);			
//		}
//		else if (element is Link) //判断选中的元素是不是结点
//		{ //选中节点  			
//			var link:Link=element as Link;	
//			var linkarray:Array=new Array();
//			var backsystem:String=null;
//			var backlinerate:String=null;
//			var backlabel:String=null;
//			if (link.getClient("lorduse") != " ")
//			{
//				for (var i:int=0; i < link.fromNode.links.count; i++)
//				{
//					var item:Link=link.fromNode.links.getItemAt(i);
//					if (item != link)
//					{
//						
//						if ((item.fromNode == link.fromNode && item.toNode == link.toNode) || (item.fromNode == link.toNode && item.toNode == link.fromNode))
//						{
//							var exist:Boolean=false;
//							for (var j:int=0; j < linkarray.length; j++)
//							{
//								if (item == linkarray[j])
//								{
//									exist=true;
//								}
//							}
//							if (!exist)
//							{
//								linkarray.push(item);
//							}
//						}
//					}
//					
//				}
//				for (i=0; i < link.toNode.links.count; i++)
//				{
//					var item:Link=link.toNode.links.getItemAt(i);
//					if (item != link)
//					{
//						if ((item.fromNode == link.fromNode && item.toNode == link.toNode) || (item.fromNode == link.toNode && item.toNode == link.fromNode))
//						{
//							var exist:Boolean=false;
//							for (var j:int=0; j < linkarray.length; j++)
//							{
//								if (item == linkarray[j])
//								{
//									exist=true;
//								}
//							}
//							if (!exist)
//							{
//								linkarray.push(item);
//							}
//						}
//					}
//					
//				}
//				for (i=0; i < linkarray.length; i++)
//				{
//					if (linkarray[i].getClient("code").toString() == link.getClient("lorduse").toString())
//					{
//						backsystem=linkarray[i].getClient("systemname");
//						backlinerate=linkarray[i].getClient("linerate");
//						backlabel=linkarray[i].getClient("code");
//						break;
//					}
//				}
//			}
//			Registry.register("backsystem", backsystem);
//			Registry.register("backlinerate", backlinerate);
//			Registry.register("backlabel", backlabel);
//			Registry.register("label", link.getClient("code").toString());
//			Registry.register("linerate", link.getClient("linerate").toString());
//			Registry.register("systemcode", link.getClient("systemname").toString());
//			Application.application.openModel("时隙分布图", false);
//			
//		}
//	}
//}
//
//private function itemAddSelectHandler(event:ContextMenuEvent):void{
//	//		this.controlBar.addShurtCut();
//}
//
//private function itemDelSelectHandler(event:ContextMenuEvent):void{
//	//		this.controlBar.delShurtCut();
//}
//
//private function handlerContextMenuCarryOpera(e:ContextMenuEvent):void //查看设备业务菜单的处理函数
//{
//	var node:Node=(Element)(systemorgmap.selectionModel.lastData);
//	var equipcode:String=node.getClient("code").toString();
//	var carryOpera:EquipCarryOpera=new EquipCarryOpera();
//	carryOpera.title=node.getClient("name")+"-设备承载业务";
//	carryOpera.getOperaByCodeAndType( equipcode,"equipment");
//	MyPopupManager.addPopUp(carryOpera);
//}
//
//private function viewHistoryFault(event:ContextMenuEvent):void{
//	var node:Node=(Element)(systemorgmap.selectionModel.lastData);
//	var equipcode:String = node.getClient("code").toString();
//	Registry.register("equipcode",equipcode);
//	var fault:faultManager = new faultManager();
//	fault.title =node.name+"-设备历史故障";
//	MyPopupManager.addPopUp(fault);
//}
//
//private function equipAnalysisHandler(e:ContextMenuEvent):void
//{
//	var node:Node=(Element)(systemorgmap.selectionModel.lastData);
//	var winBusinessInfluenced:businessInfluenced=new businessInfluenced();
//	winBusinessInfluenced.setParameters(node.getClient("code").toString(), "equip");
//	parentApplication.openModel("\"N-1\"分析", true, winBusinessInfluenced);
//	/* setParameters的参数含义
//	* type为equip, 从设备查看N-1
//	* type为port, 从端口查看N-1
//	* type为topolink, 从复用段查看N-1
//	* type为ocable, 从光缆查看N-1 */
//}
//
//private function itemSelectHandler_LinkAnalysis(e:ContextMenuEvent):void
//{
//	var link:Link=(Element)(systemorgmap.selectionModel.lastData);
//	var winBusinessInfluenced:businessInfluenced=new businessInfluenced();
//	winBusinessInfluenced.setParameters(link.getClient("code").toString(), "topolink");
//	parentApplication.openModel("\"N-1\"分析", true, winBusinessInfluenced);
//	/* setParameters的参数含义
//	* type为equip, 从设备查看N-1
//	* type为port, 从端口查看N-1
//	* type为topolink, 从复用段查看N-1
//	* type为ocable, 从光缆查看N-1 */
//}
//
//private function itemSelectHandler_CarryOpera(e:ContextMenuEvent):void //查看复用段菜单的处理函数
//{
//	var link:Link=(Element)(systemorgmap.selectionModel.lastData);
//	var label:String=link.getClient("code").toString();
//	var labelname:String=link.getClient("labelname").toString();
//	var carryOpera:CarryOpera=new CarryOpera();
//	carryOpera.getOperaByCodeAndType( label,"topolink");
//	carryOpera.title=labelname+"-复用段承载业务";	
//	MyPopupManager.addPopUp(carryOpera);
//}
//
//private function saveLordUse(event:Event):void
//{
//	var item:TopolinkRing=new TopolinkRing();
//	item=this.lordUse.topolinkRing;
//	var rtobj:RemoteObject=new RemoteObject("fiberWire");
//	rtobj.endpoint=ModelLocator.END_POINT;
//	rtobj.showBusyCursor=true;
//	if (item.ringid == " ")
//	{
//		rtobj.addEventListener(ResultEvent.RESULT, AfterSetLordUse);
//		parentApplication.faultEventHandler(rtobj);
//		rtobj.setLordUse(item);		
//	}
//	else
//	{
//		rtobj.addEventListener(ResultEvent.RESULT, AfterUpdateLordUse);
//		parentApplication.faultEventHandler(rtobj);
//		rtobj.updateLordUse(item);
//	}
//}
//
//private function AfterUpdateLordUse(event:ResultEvent):void
//{
//	Alert.show("修改成功,当再次打开该系统时即可看到效果！", "提示");
//	lordUse.resetValue();
//	PopUpManager.removePopUp(lordUse);
//}
//
//private function AfterSetLordUse(event:ResultEvent):void
//{
//	
//	Alert.show("设置成功,当再次打开该系统时即可看到效果！", "提示");
//	lordUse.resetValue();
//	PopUpManager.removePopUp(lordUse);
//}
//
//private function itemSelectHandler_UpdatePrimaryUsed(e:ContextMenuEvent):void
//{
//	var link:Link=(Element)(systemorgmap.selectionModel.lastData);
//	var label:String=link.getClient("code").toString();
//	var equip_a:String=link.getClient("equip_a").toString();
//	var equip_z:String=link.getClient("equip_z").toString();
//	lordUse.topolinkid=label;
//	lordUse.equip_a=equip_a;
//	lordUse.equip_z=equip_z;
//	lordUse.topolinkname=link.getClient("labelname").toString();
//	
//	PopUpManager.addPopUp(lordUse, this, true);
//	PopUpManager.centerPopUp(lordUse);
//	lordUse.topolinkRing.ringid=link.getClient("ringid").toString();
//	
//	lordUse.setTopoLinkData();
//}
//private function itemSelectHandler_AddPoint(event:ContextMenuEvent):void
//{
//	if(systemorgmap.selectionModel.count>0)
//	{
//		var item:Object = systemorgmap.selectionModel.selection.getItemAt(0);
//		if (item is Link)
//		{	
//			
//			var link:ShapeLink = systemorgmap.selectionModel.selection.getItemAt(0) as ShapeLink;
//			var p:Point = new Point(event.mouseTarget.mouseX / systemorgmap.zoom, event.mouseTarget.mouseY / systemorgmap.zoom);
//			var positionX:int = systemorgmap.contentMouseX / systemorgmap.zoom;
//			var positionY:int =systemorgmap.contentMouseY / systemorgmap.zoom;
//			link.addPoint(new Point(positionX,positionY));
//			systemorgmap.setEditInteractionHandlers();
//		}
//	}
//}
//private function itemSelectHandler_DeletePoint(event:ContextMenuEvent):void
//{
//	if(systemorgmap.selectionModel.count>0)
//	{
//		var item:Object = systemorgmap.selectionModel.selection.getItemAt(0);
//		if (item is Link)
//		{	
//			
//			var link:ShapeLink = systemorgmap.selectionModel.selection.getItemAt(0) as ShapeLink;
//			link.points.removeItemAt(link.points.count - 1);
//			systemorgmap.setEditInteractionHandlers();
//		}
//	}
//}
//
//private function itemSelectHandler_CancelPrimaryUsed(e:ContextMenuEvent):void
//{
//	try
//	{
//		var link:Link=(Element)(systemorgmap.selectionModel.lastData);		
//		var label:String=link.getClient("code").toString();		
//		var rtobj:RemoteObject=new RemoteObject("fiberWire");
//		rtobj.endpoint=ModelLocator.END_POINT;
//		rtobj.showBusyCursor=true;
//		rtobj.cancelPrimaryUsed(label);
//		rtobj.addEventListener(ResultEvent.RESULT, AfterCancelPrimaryUsed);
//		parentApplication.faultEventHandler(rtobj);
//	}
//	catch (error:Error)
//	{
//		Alert.show(error.toString());
//	}
//}
//
//private function AfterCancelPrimaryUsed(event:ResultEvent):void
//{
//	var link:Link=(Element)(systemorgmap.selectionModel.lastData);
//	
//	Alert.show("取消成功，当再次打开系统时生效！", "提示");
//}
//
//private function itemSelectHandler_SetPrimaryUsed(e:ContextMenuEvent):void
//{
//	try
//	{
//		var link:Link=(Element)(systemorgmap.selectionModel.lastData);
//		var label:String=link.getClient("code").toString();
//		var equip_a:String=link.getClient("equip_a").toString();
//		var equip_z:String=link.getClient("equip_z").toString();
//		var labelname:String=link.getClient("labelname").toString();
//		lordUse.topolinkid=label;
//		lordUse.equip_a=equip_a;
//		lordUse.equip_z=equip_z;
//		lordUse.topolinkname=labelname;
//		PopUpManager.addPopUp(lordUse, this, true);
//		PopUpManager.centerPopUp(lordUse);
//		lordUse.setTopoLinkData();
//	}
//	catch (error:Error)
//	{
//		Alert.show(error.toString());
//	}
//}
//
//private function itemSelectHandler(e:ContextMenuEvent):void //查看设备面板图，设备属性的菜单处理函数
//{
//	var node:Node=(Element)(systemorgmap.selectionModel.lastData)
//	var equipcode:String=node.getClient("code");
//	if (e.currentTarget.caption == "设备面板图")
//	{
//		Registry.register("systemcode", node.getClient("parent").toString());
//		Registry.register("equipcode", equipcode);
//		Application.application.openModel(e.currentTarget.caption, false);
//	}
//	else if (e.currentTarget.caption == "设备属性")
//	{		
//		var property:ShowProperty = new ShowProperty();
//		property.paraValue = equipcode;
//		property.tablename = "VIEW_EQUIPMENT";
//		property.key = "EQUIPCODE";
//		property.title = node.getClient("name")+"—设备属性";
//		PopUpManager.addPopUp(property, this, true);
//		PopUpManager.centerPopUp(property);
//	}
//}
//
//private function onItemClick(evt:ListEvent):void
//{
//	if (evt.target is TileList && ((evt.target as TileList).selectedItem is ActionTile))
//	{
//		var item:ActionTile=(evt.target as TileList).selectedItem as ActionTile;
//		if (item.action != null)
//		{
//			item.action();
//		}
//		else
//		{
//			systemorgmap.setEditInteractionHandlers();
//		}
//	}
//}
//
//private function createLinkInteraction(linkClass:Class, linkType:String, callback:Function=null, isByControlPoint:Boolean=false, splitByPercent:Boolean=true, value:Number=-1):void
//{
//	
//	systemorgmap.setCreateLinkInteractionHandlers(linkClass, callback, linkType, isByControlPoint, value, true);
//}
//
//private var linkID:Object;
//private var winTopoLink:WinTopoLink;	
//private function createLinkCallBack(link:Link):void
//{   
//	systemorgmap.setDefaultInteractionHandlers();
//	linkID=link.id;
//	if(link.fromNode.getClient("code")==link.toNode.getClient("code")){
//		systemorgmap.elementBox.removeByID(linkID);
//		Alert.show("复用段两端不能连接设备自身的端口","提示");
//		return;
//	}
//	winTopoLink=new WinTopoLink();
//	winTopoLink.initialize();
//	winTopoLink.addEventListener("AfterAddTopoLink", afterAddTopolinkHandler);
//	winTopoLink.equipCodeA=link.fromNode.getClient("code").toString();
//	winTopoLink.equipCodeZ=link.toNode.getClient("code").toString();
//	winTopoLink.txtEquipNameA.text=link.fromNode.getClient("name").toString();
//	winTopoLink.txtEquipNameZ.text=link.toNode.getClient("name").toString();
//	//	winTopoLink.txtEquipNameA.text=link.fromNode.name.toString();
//	//	winTopoLink.txtEquipNameZ.text=link.toNode.name.toString();
//	
//	winTopoLink.addEventListener("CloseWinTopoLink", cancelClickHandler);
//	MyPopupManager.addPopUp(winTopoLink, true); //创建连线后弹出复用段的属性信息面板
//}
//
//private function afterAddTopolinkHandler(event:LinkParameterEvent):void
//{
//	if(system.systemcode!="")
//	{
//		freshAddNodeAfterExpand(system);
//	}
//}
//
//private function cancelClickHandler(event:Event):void
//{
//	winTopoLink.removeEventListener("CloseWinTopoLink", cancelClickHandler);	
//	if (linkID != null)
//		systemorgmap.elementBox.removeByID(linkID);
//	MyPopupManager.removePopUp(winTopoLink);
//}
//
////复用段时隙分布图右键事件
//private function itemSelectHandler_TimeSlot(e:ContextMenuEvent):void
//{
//	var link:Link=(Element)(systemorgmap.selectionModel.lastData);
//	var linkarray:Array=new Array();
//	var backsystem:String=null;
//	var backlinerate:String=null;
//	var backlabel:String=null;
//	if (link.getClient("lorduse") != " ")
//	{
//		for (var i:int=0; i < link.fromNode.links.count; i++)
//		{
//			var item:Link=link.fromNode.links.getItemAt(i);
//			if (item != link)
//			{
//				
//				if ((item.fromNode == link.fromNode && item.toNode == link.toNode) || (item.fromNode == link.toNode && item.toNode == link.fromNode))
//				{
//					var exist:Boolean=false;
//					for (var j:int=0; j < linkarray.length; j++)
//					{
//						if (item == linkarray[j])
//						{
//							exist=true;
//						}
//					}
//					if (!exist)
//					{
//						linkarray.push(item);
//					}
//				}
//			}
//			
//		}
//		for (i=0; i < link.toNode.links.count; i++)
//		{
//			var item:Link=link.toNode.links.getItemAt(i);
//			if (item != link)
//			{
//				if ((item.fromNode == link.fromNode && item.toNode == link.toNode) || (item.fromNode == link.toNode && item.toNode == link.fromNode))
//				{
//					var exist:Boolean=false;
//					for (var j:int=0; j < linkarray.length; j++)
//					{
//						if (item == linkarray[j])
//						{
//							exist=true;
//						}
//					}
//					if (!exist)
//					{
//						linkarray.push(item);
//					}
//				}
//			}
//			
//		}
//		for (i=0; i < linkarray.length; i++)
//		{
//			if (linkarray[i].getClient("code").toString() == link.getClient("lorduse").toString())
//			{
//				backsystem=linkarray[i].getClient("systemname");
//				backlinerate=linkarray[i].getClient("linerate");
//				backlabel=linkarray[i].getClient("code");
//				break;
//			}
//		}
//	}
//	Registry.register("backsystem", backsystem);
//	Registry.register("backlinerate", backlinerate);
//	Registry.register("backlabel", backlabel);
//	Registry.register("label", link.getClient("code").toString());
//	Registry.register("linerate", link.getClient("linerate").toString());
//	Registry.register("systemcode", link.getClient("systemname").toString());
//	
//	Application.application.openModel(e.currentTarget.caption, false);	
//}
//
////复用段属性右键事件
//private function itemSelectHandler_Ocable(e:ContextMenuEvent):void
//{
//	var link:Link=(Element)(systemorgmap.selectionModel.lastData);
//	var topolinkid:String=link.getClient("code").toString();
//	var labelname:String=link.getClient("labelname").toString();
//	var property:ShowProperty = new ShowProperty();
//	property.paraValue = topolinkid;
//	property.tablename = "VIEW_ENTOPOLINKPROPERTY";
//	property.key = "label";	
//	labelname = labelname+"—复用段属性";
//	property.toolTip = labelname;
//	if(labelname.length>51){
//		labelname = labelname.substring(0,51)+"......";
//	}
//	property.title = labelname;	
//	PopUpManager.addPopUp(property, this, true);
//	PopUpManager.centerPopUp(property);
//	
//	//更新复用段颜色
//	property.addEventListener("savePropertyComplete",function(event:Event):void{
//		var isFourFiberRing:ComboBox = getElementById("ISFOURFIBERRING",property.propertyList) as ComboBox;
//		var fiberColor:ComboBox = getElementById("FIBERCOLOR",property.propertyList) as ComboBox;
//		
//		if(null != isFourFiberRing.selectedItem && "Y" == isFourFiberRing.selectedItem.@code){
//			if(null != fiberColor.selectedItem){
//				link.setStyle(Styles.LINK_COLOR,fiberColor.selectedItem.@code);
//			}
//		}
//		PopUpManager.removePopUp(property);
//	});
//}
//
//private function getElementById(id:String,arrayList:Array):Object{
//	var obj:Object= new Object();
//	if(arrayList!=null&&arrayList.length>0){
//		for(var i:int=0;i<arrayList.length;i++){
//			var object:Object = arrayList[i] as Object;
//			if(id==object.id){
//				obj = object;
//				break;
//			}
//		}
//		
//	}
//	return obj;
//}
//
//private function onDragEnter(event:DragEvent):void
//{
//	if (event.dragInitiator is Tree)
//	{
//		var ds:DragSource=event.dragSource;
//		if (!ds.hasFormat("treeItems"))
//			return; // no useful data
//		if (ds.dataForFormat("treeItems")[0].@leaf == false)
//			return;
//		
//	}
//	// if the tree passes or the dragInitiator is not a tree, accept the drop
//	DragManager.acceptDragDrop(UIComponent(event.currentTarget));
//}
//
//private function onDragOver(event:DragEvent):void
//{
//	if (event.dragInitiator is Tree)
//	{
//		DragManager.showFeedback(DragManager.COPY);
//	}
//	else
//	{
//		if (event.ctrlKey)
//			DragManager.showFeedback(DragManager.COPY);
//		else if (event.shiftKey)
//			DragManager.showFeedback(DragManager.LINK);
//		else
//		{
//			DragManager.showFeedback(DragManager.MOVE);
//		}
//	}
//}
///**
// *  拖拽添加 
// */
//private function onGridDragDrop(event:DragEvent):void
//{
//	if(system.systemcode==null)
//	{
//		Alert.show("请选择系统再添加设备","提示");
//	}
//	else
//	{
//		var matchStr:String;
//		matchStr=acc.selectedIndex == 0 ? "treeItems" : "items";
//		var ds:DragSource=event.dragSource;
//		var dropTarget:Network=Network(event.currentTarget);
//		var centerLocation:Point=systemorgmap.getLogicalPoint(event as MouseEvent);
//		if(acc.selectedIndex==0)//直接添加设备到系统组织图
//		{
//			var node1:Node=systemorgmap.elementBox.getDataByID(ds.dataForFormat("treeItems")[0].@code) as Node;
//			if(node1==null)//该设备在系统中不存在
//			{				
//				//添加设备到图中	
//				var subsys:String=ds.dataForFormat("treeItems")[0].@subnet;
//				if(subsys=="null"&&getoperDesc.length==8)
//				{
//					addNodeToMap(node1,ds,centerLocation,matchStr);	
//					//改变节点图标
//					deviceTree.setItemIcon(selectedNode,ModelLocator.equipIcon,ModelLocator.equipIcon);
//					
//				}
//				else
//				{
//					if(subsys!=system.systemcode&&getoperDesc.length==8)
//					{
//						Alert.show("该设备已归属在"+subsys+"中，确定要改变吗？","请您确认！",Alert.YES|Alert.NO,this,function(e:CloseEvent):void{
//							if(e.detail == Alert.YES)
//							{
//								addNodeToMap(node1,ds,centerLocation,matchStr);	
//							}
//						},null,Alert.NO);
//					}
//				}
//			}
//			else
//			{
//				Alert.show('此设备在视图中已存在，请选择其它设备！', '提示');
//			}
//			
//		}
//		else if(acc.selectedIndex==1)//通过添加设备模板添加设备到系统组织图
//		{
//			var arrPicName:Array=String(ds.dataForFormat("items")[0].@source).split("/");
//			var picName:String=arrPicName[arrPicName.length - 1];
//			if (picName == "noIcon.png")
//				return;
//			var x_model:String=ds.dataForFormat("items")[0].@x_model;
//			var node1:Node=new Node();
//			nodeId=node1.id;	
//			var centerLocation:Point=systemorgmap.getLogicalPoint(event as MouseEvent);
//			node1.centerLocation=centerLocation;
//			node1.setClient("x_model", x_model);
//			node1.setClient("NodeType","equipment");	
//			node1.layerID="resLayer";
//			var re1:RegExp = new RegExp("/", "g"); 
//			var img_x_model:String=x_model.replace(re1,"");
//			var re2:RegExp = new RegExp(" ", "g"); 
//			img_x_model=img_x_model.replace(re2,"");			
//			node1.image=img_x_model;
//			node1.icon=img_x_model;	
//			node1.setClient("parent", system.systemcode);					
//			node1.setClient("parent_x", system.x);
//			node1.setClient("parent_y", system.y);
//			node1.setSize(18,18);	
//			node1.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
//			node1.setStyle(Styles.SELECT_COLOR,"0x7697C9");//0x00FF00
//			node1.setStyle(Styles.SELECT_WIDTH,'10');
//			systemorgmap.elementBox.add(node1);			
//			openAddEquipWin(x_model,centerLocation.x-system.x,centerLocation.y-system.y);			
//		}
//	}
//}
//private function addNodeToMap(node1:Node,ds:DragSource,evtPoint:Point,matchStr:String):void{
//	//	var label:String=ds.dataForFormat("treeItems")[0].@label;
//	var label:String=ds.dataForFormat("treeItems")[0].@stationname;
//	var code:String=ds.dataForFormat("treeItems")[0].@code;
//	var vendor:String=ds.dataForFormat("treeItems")[0].@vendor;
//	var x_model:String=ds.dataForFormat("treeItems")[0].@x_model;
//	var subnet:String=ds.dataForFormat("treeItems")[0].@subnet;
//	node1=new Node(code);
//	nodeId=node1.id;
//	node1.name=label;
//	node1.toolTip=label;
//	node1.centerLocation=evtPoint;	
//	node1.layerID="resLayer";
//	//处理设备型号名称，
//	var re1:RegExp = new RegExp("/", "g"); 
//	var img_x_model:String=x_model.replace(re1,"");
//	var re2:RegExp = new RegExp(" ", "g"); 
//	img_x_model=img_x_model.replace(re2,"");
//	node1.image="assets/images/swf/sysGraph/OptiX_XXForDemo.swf";
//	node1.setClient("parent", system.systemcode);		
//	node1.setClient("code",code);
//	node1.setClient("name",label);
//	node1.setClient("vendor", vendor);
//	node1.setClient("x_model", x_model);
//	node1.setClient("NodeType","equipment");
//	node1.setClient("parent_x", system.x);
//	node1.setClient("parent_y", system.y);
//	node1.setSize(22,22);	
//	node1.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
//	node1.setStyle(Styles.SELECT_COLOR,"0x7697C9");//0x00FF00
//	node1.setStyle(Styles.SELECT_WIDTH,'10');
//	systemorgmap.elementBox.add(node1);
//	var f:Follower = new Follower("label"+node1.id);				
//	f.setClient('code',node1.id);			
//	f.host = node1;
//	f.name = label;
//	f.image = "";
//	f.width = 0;
//	f.height = 0;
//	f.setStyle(Styles.LABEL_SIZE,12);			
//	f.setLocation(evtPoint.x+10,evtPoint.y-10);
//	systemorgmap.elementBox.add(f);
//	//保存设备
//	dragEquipAddSys(subnet,system.systemcode,code,evtPoint);
//	//添加设备与图中已有设备之间的复用段
//	var equip_connections:String=ds.dataForFormat(matchStr)[0].@connections;
//	var connections:Array=equip_connections.split("$$");
//	for (var j:int=0; j < connections.length - 1; j++)
//	{
//		var connection:Array=connections[j].split("@@");
//		var connectequipcode:String=connection[0];
//		var linkid:String=connection[1];
//		var linerate:String=connection[2];
//		
//		var linkNode:Node=systemorgmap.elementBox.getDataByID(connectequipcode) as Node;
//		if(linkNode!=null)
//		{
//			var link:ShapeLink;
//			link=new ShapeLink(linkid,node1, linkNode);
//			link.setClient("code",linkid);
//			var colorValue:String;
//			for each(var item:Object in colorArray)
//			{
//				if (item.ENAME==linerate)
//				{
//					colorValue=item.ECOLOR;
//					break;
//				}
//			}
//			link.setStyle(Styles.LINK_WIDTH,1);
//			link.setStyle(Styles.LINK_COLOR,colorValue.toString());
//			link.setStyle(Styles.LINK_BUNDLE_OFFSET, 50);
//			link.setStyle(Styles.LINK_BUNDLE_GAP, 10);
//			link.setStyle(Styles.LINK_BUNDLE_EXPANDED, true);
//			link.setStyle(Styles.LINK_BUNDLE_ENABLE,true);
//			link.setStyle(Styles.LINK_TYPE,Consts.LINK_TYPE_TRIANGLE);
//			link.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
//			link.setStyle(Styles.SELECT_WIDTH,'3');	
//			link.setStyle(Styles.SELECT_COLOR,"0x7697C9");//0x00FF00
//			link.layerID="resLayer";
//			systemorgmap.elementBox.add(link);
//		}
//	}
//}
//private function dragEquipAddSys(sysnameold:String,sysnamenew:String,equip:String,equiploc:Point):void{
//	var rtobj:RemoteObject=new RemoteObject("fiberWire");
//	rtobj.endpoint=ModelLocator.END_POINT;
//	rtobj.showBusyCursor=true;
//	rtobj.saveEquipToSys(sysnameold,sysnamenew,equip,equiploc.x.toString(),equiploc.y.toString());
//	rtobj.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void
//	{
//		//		for each(var xml:XML in DeviceXML)
//		//		{
//		//			var nodeXml:String=xml.@code;
//		//			if (nodeXml.length==6)
//		//			{
//		//				xml.appendChild(curRootXML);
//		//				openTreeNode(xml);
//		//				break;
//		//			}
//		//		}
//	})
//}
//
//private var nodeId:Object={};
//
//private function openAddEquipWin(x_model:String,x:Number,y:Number):void
//{
//	try{
//		addEquInfo=new AddEquInfo();
//		addEquInfo.addEventListener("AfterAddEquip", addEquInfoHandler);
//		addEquInfo.addEventListener(CloseEvent.CLOSE, closeEquipWinHandler);	
//		MyPopupManager.addPopUp(addEquInfo, true);
//		addEquInfo.setVendorAndModel(system.systemcode,x_model,x,y);	
//		addEquInfo.title="添加设备";	
//	}catch(e:Error)
//	{
//		Alert.show(e.message);
//	}
//}
//
//private function closeEquipWinHandler(event:CloseEvent):void
//{
//	addEquInfo.resetValue(); //清楚添加面板里的值
//	MyPopupManager.removePopUp(addEquInfo);
//	systemorgmap.elementBox.removeByID(nodeId);
//}
//
//private function onDragExit(event:DragEvent):void
//{
//	var dropTarget:Network=Network(event.currentTarget);
//}
//
//private function tree_itemClick(evt:ListEvent):void
//{
//	var item:Object=Tree(evt.currentTarget).selectedItem;
//	if (deviceTree.dataDescriptor.isBranch(item))
//	{
//		deviceTree.expandItem(item, !deviceTree.isItemOpen(item), true);
//	}	
//}
//
//private function generateEquipListInfo(event:ResultEvent):void
//{
//	
//	if (event.result!= null)
//	{
//		
//		equipCollection=event.result as ArrayCollection;
//	}
//	
//}
//private var xmlDeviceModel:XMLList=new XMLList();
//[Bindable]
//private var xmlListColl:XMLListCollection=new XMLListCollection();
//
//private function accordionChange():void
//{
//	if (acc.selectedIndex&& xmlDeviceModel.children().length() == 0)
//	{
//		
//		var roDeviceModel:RemoteObject=new RemoteObject("fiberWire");
//		roDeviceModel.endpoint=ModelLocator.END_POINT;
//		roDeviceModel.showBusyCursor=true;
//		roDeviceModel.addEventListener(ResultEvent.RESULT, getDeviceModelHandler);
//		parentApplication.faultEventHandler(roDeviceModel);
//		roDeviceModel.getDeviceModel();
//	}
//}
//private function vb_selectedItemEventHandler(event:selectedItemEvent):void
//{
//	if(event.selectedIndex==1&&xmlDeviceModel.children().length() == 0)
//	{
//		var roDeviceModel:RemoteObject=new RemoteObject("fiberWire");
//		roDeviceModel.endpoint=ModelLocator.END_POINT;
//		roDeviceModel.showBusyCursor=true;
//		roDeviceModel.addEventListener(ResultEvent.RESULT, getDeviceModelHandler);
//		parentApplication.faultEventHandler(roDeviceModel);
//		roDeviceModel.getDeviceModel();
//	}
//}
//
//private function getDeviceModelHandler(event:ResultEvent):void
//{
//	xmlDeviceModel=XMLList(event.result);
//	xmlListColl.source=xmlDeviceModel.model;
//}
////创建判定告警菜单的方法
//private function AlarmHandler(e:ContextMenuEvent):void
//{
//	if(e.currentTarget.caption == "查看当前根告警"){
//		var currentRootAlarm:currentOrHistoryRootAlarmView=new currentOrHistoryRootAlarmView();
//		var node:Node=(Element)(systemorgmap.selectionModel.lastData);
//		currentRootAlarm.alarmModel.belongequip=node.getClient("code").toString();
//		parentApplication.openModel("查看当前根告警", true, currentRootAlarm);
//	}
//	if(e.currentTarget.caption == "查看历史根告警"){
//		var historyRootAlarm:currentOrHistoryRootAlarmView=new currentOrHistoryRootAlarmView();
//		var node:Node=(Element)(systemorgmap.selectionModel.lastData);
//		historyRootAlarm.alarmModel.belongequip=node.getClient("code").toString();
//		parentApplication.openModel("查看历史根告警", true, historyRootAlarm);
//	}
//	if(e.currentTarget.caption == "查看当前原始告警"){
//		var currentOriginalAlarm:currentOrHistoryOriginalAlarmView=new currentOrHistoryOriginalAlarmView();
//		var node:Node=(Element)(systemorgmap.selectionModel.lastData);
//		currentOriginalAlarm.alarmModel.belongequip=node.getClient("code").toString();
//		parentApplication.openModel("查看当前原始告警", true, currentOriginalAlarm);
//	}
//	if(e.currentTarget.caption == "查看历史原始告警"){
//		var historyOriginalAlarm:currentOrHistoryOriginalAlarmView=new currentOrHistoryOriginalAlarmView();
//		var node:Node=(Element)(systemorgmap.selectionModel.lastData);
//		historyOriginalAlarm.alarmModel.belongequip=node.getClient("code").toString();
//		parentApplication.openModel("查看历史原始告警", true, historyOriginalAlarm);
//	}
//}
//private function verticalAlignHandler(e:ContextMenuEvent):void
//{ 
//	var element:Element;
//	var node:Node;
//	var nodetemp:Node;
//	var array:Array=new Array();
//	
//	for(var i:int=0;i<systemorgmap.selectionModel.selection.count;i++)
//	{
//		element=(Element)(systemorgmap.selectionModel.selection.getItemAt(i));
//		if(element is Node)
//		{
//			array.push(element);
//		}
//	}
//	if(array.length>0)
//	{
//		node=array[0] as Node;
//		for(i=1;i<array.length;i++)
//		{
//			nodetemp=array[i];
//			nodetemp.setCenterLocation(node.centerLocation.x,nodetemp.centerLocation.y);
//		}
//	}
//}
//
//private function levelAlignHandler(e:ContextMenuEvent):void
//{
//	var element:Element;
//	var node:Node;
//	var nodetemp:Node;
//	var array:Array=new Array();
//	
//	for(var i:int=0;i<systemorgmap.selectionModel.selection.count;i++)
//	{
//		element=(Element)(systemorgmap.selectionModel.selection.getItemAt(i));
//		if(element is Node)
//		{
//			array.push(element);
//		}
//	}
//	if(array.length>0)
//	{
//		node=array[0] as Node;
//		for(i=1;i<array.length;i++)
//		{
//			nodetemp=array[i];
//			nodetemp.setCenterLocation(nodetemp.centerLocation.x,node.centerLocation.y);
//		}
//	}
//}
//
//protected function sysNetwork_keyDownHandler(event:KeyboardEvent):void
//{
//	if(systemorgmap.selectionModel.count==1)
//		var element:* = systemorgmap.selectionModel.selection.getItemAt(0);
//	if(event.keyCode == Keyboard.DELETE){
//		if(element is Link){
//			Alert.show("确定要删除吗?","请您确认！",Alert.YES|Alert.NO,this,function(e:CloseEvent):void{
//				if(e.detail == Alert.YES)
//				{
//					systemorgmap.elementBox.remove(element);
//				}
//			},null,Alert.NO);
//		}
//		else if(element is Node&&element.getClient("NodeType")=="equipment"){
//			Alert.show("确认将该设备从系统中删除?", "删除",3,this,deleteEquipReSys);
//		}
//		
//	}	
//}
//private function deleteEquipReSys(event:CloseEvent):void
//{
//	if(event.detail == Alert.YES) 
//	{ 
//		var node:Node=(Element)(systemorgmap.selectionModel.lastData);
//		var systemcode:String=node.getClient("parent").toString();
//		var equipcode:String=node.getClient("code").toString();
//		var roDeleteEquip:RemoteObject=new RemoteObject("fiberWire");
//		roDeleteEquip.endpoint=ModelLocator.END_POINT;
//		roDeleteEquip.showBusyCursor=true;
//		roDeleteEquip.addEventListener(ResultEvent.RESULT, function(e:ResultEvent):void
//		{
//			var node:Node=(Element)(systemorgmap.selectionModel.lastData);
//			systemorgmap.elementBox.remove(node);
//		});
//		parentApplication.faultEventHandler(roDeleteEquip);
//		roDeleteEquip.deleteEquipReSys(equipcode,systemcode);
//	} 
//}
//public function initParameter():void
//{
//	var systemcode:String=Registry.lookup("systemcode");
//	
//	if(systemcode!=null)//如果要查找指定系统下的设备
//	{
//		Registry.unregister("systemcode");		
//		
//		for (var j:int=0;j< radioGroup.numRadioButtons;j++)
//		{
//			if(radioGroup.getRadioButtonAt(j).value==systemcode)
//			{
//				radioGroup.getRadioButtonAt(j).selected=true;
//				system.systemcode=systemcode;
//				freshAddNodeAfterExpand(system);					
//				break;
//			}
//			
//		}
//	}
//}
//
//protected function searchText_clickHandler(event:Event):void
//{
//	//		enter();
//}
//
////获取link的拐点信息
//private function getTopolinkGeo(link:ShapeLink):ArrayCollection{
//	var ac:ArrayCollection = new ArrayCollection();
//	
//	for(var i:int=0;i<link.points.count;i++){
//		var itemGeo:EN_Topolink_Geo = new EN_Topolink_Geo();
//		itemGeo.label = link.getClient("code").toString();
//		itemGeo.x=link.points.getItemAt(i).x.toString();
//		itemGeo.y=link.points.getItemAt(i).y.toString();
//		itemGeo.serial=(i+1).toString();
//		ac.addItem(itemGeo);
//	}
//	return ac;
//}
//private function saveTopolinkGeoHandler(event:ResultEvent):void
//{
//	Alert.show("保存成功","温馨提示!");
//}
//private function interactionHanlder(e:InteractionEvent):void{
//	if(e.kind=="clickElement"){
//		if(e.element is Node){
//			if(e.element.getClient("NodeType")!=null&&e.element.getClient("NodeType")=='station'){
//				var datas:ICollection = systemorgmap.elementBox.toDatas();
//				if(datas!=null&&datas.count>0){
//					for(var i:int=0;i<datas.count;i++){
//						var element:IData = datas.getItemAt(i);
//						if(element.getClient("NodeType")!=null&&element.getClient("NodeType")=='equipment'){
//							if(element.parent!=null&&element.parent==e.element){
//								var enode:Node = element as Node;
//								enode.setStyle(Styles.OUTER_STYLE, Consts.OUTER_STYLE_BORDER);
//								enode.setStyle(Styles.OUTER_COLOR,0x7697C9);
//							}else{
//								var enode:Node = element as Node;
//								enode.setStyle(Styles.OUTER_STYLE, "");
//							}							  
//						}
//						if(element.getClient("NodeType")!=null&&element.getClient("NodeType")=='station'){
//							var enode:Node = element as Node;
//							enode.setStyle(Styles.LABEL_COLOR,0x000000);				  
//						}
//					}
//				}
//			}
//			if(e.element.getClient("NodeType")!=null&&e.element.getClient("NodeType")=='equipment'){
//				var datas:ICollection = systemorgmap.elementBox.toDatas();
//				if(datas!=null&&datas.count>0){
//					for(var i:int=0;i<datas.count;i++){
//						var element:IData = datas.getItemAt(i);
//						if(element.getClient("NodeType")!=null&&element.getClient("NodeType")=='station'){
//							if(e.element.parent!=null&&element==e.element.parent){
//								var enode:Node = element as Node;
//								enode.setStyle(Styles.LABEL_COLOR,0x7697C9);
//							}else{
//								var enode:Node = element as Node;
//								enode.setStyle(Styles.LABEL_COLOR,0x000000);
//							}							  
//						}
//						if(element.getClient("NodeType")!=null&&element.getClient("NodeType")=='equipment'){
//							var enode:Node = element as Node;
//							enode.setStyle(Styles.OUTER_STYLE, "");
//						}
//					}
//				}
//			}
//		}
//	}else if(e.kind=='clickBackground'){
//		var datas:ICollection = systemorgmap.elementBox.toDatas();
//		if(datas!=null&&datas.count>0){
//			for(var i:int=0;i<datas.count;i++){
//				var element:IData = datas.getItemAt(i);
//				if(element.getClient("NodeType")!=null&&element.getClient("NodeType")=='equipment'){
//					var enode:Node = element as Node;
//					enode.setStyle(Styles.OUTER_STYLE, "");
//				}
//				if(element.getClient("NodeType")!=null&&element.getClient("NodeType")=='station'){
//					var enode:Node = element as Node;
//					enode.setStyle(Styles.LABEL_COLOR,0x000000);				  
//				}
//			}
//		} 
//	}else if(e.kind=="liveMoveEnd"){
//		if (mFlag){
//			var moveNode:Node=systemorgmap.selectionModel.selection.getItemAt(0) as Node;
//			if (moveNode.getClient("NodeType")=='equipment'){
//				var equip:String=moveNode.getClient("code");			
//				var rtobj:RemoteObject=new RemoteObject("fiberWire");
//				rtobj.endpoint=ModelLocator.END_POINT;
//				rtobj.showBusyCursor=true;
//				//				Alert.show(system.systemcode);\
//				rtobj.saveEquipToSys(system.systemcode,system.systemcode,equip,(moveNode.x-xoffset).toString(),(moveNode.y-yoffset).toString());
//				rtobj.addEventListener(FaultEvent.FAULT,function(ef:FaultEvent):void{
//					//					Alert.show(ef.message.toString());
//				});
//				rtobj.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void
//				{
//					//					Alert.show("ResultEvent.RESULT");
//				})
//			}
//			else if(moveNode.getClient("NodeType")=='station'){
//				//				Alert.show("station");
//				var station:String=moveNode.getClient("stationcode");			
//				var rtobj:RemoteObject=new RemoteObject("fiberWire");
//				rtobj.endpoint=ModelLocator.END_POINT;
//				rtobj.showBusyCursor=true;				
//				rtobj.saveEquipLabelToSys(system.systemcode,station,moveNode.x.toString(),moveNode.y.toString());
//				rtobj.addEventListener(FaultEvent.FAULT,function(ef:FaultEvent):void{
//					Alert.show(ef.message.toString());
//				});
//				rtobj.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void
//				{
//					//					Alert.show("ResultEvent.RESULT");
//				})
//			}
//		}
//	}
//}
//
