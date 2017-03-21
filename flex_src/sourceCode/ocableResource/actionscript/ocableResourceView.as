import VButtonEvents.selectedItemEvent;

import common.actionscript.CustomInteractionHandler;
import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.actionscript.Registry;

import flash.display.BitmapData;
import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.FileReference;
import flash.ui.ContextMenuItem;
import flash.utils.ByteArray;

import mx.collections.ArrayCollection;
import mx.collections.XMLListCollection;
import mx.containers.Box;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.ButtonBar;
import mx.controls.CheckBox;
import mx.controls.ComboBox;
import mx.controls.Label;
import mx.controls.Spacer;
import mx.controls.TextInput;
import mx.controls.Tree;
import mx.core.Application;
import mx.core.DragSource;
import mx.core.UIComponent;
import mx.effects.AnimateProperty;
import mx.effects.CompositeEffect;
import mx.effects.Parallel;
import mx.events.CloseEvent;
import mx.events.DragEvent;
import mx.events.EffectEvent;
import mx.events.ItemClickEvent;
import mx.events.ListEvent;
import mx.events.MenuEvent;
import mx.events.TreeEvent;
import mx.formatters.DateFormatter;
import mx.graphics.codec.PNGEncoder;
import mx.managers.DragManager;
import mx.managers.PopUpManager;
import mx.messaging.errors.NoChannelAvailableError;
import mx.printing.FlexPrintJob;
import mx.printing.FlexPrintJobScaleType;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;
import mx.utils.ObjectProxy;

import org.flexunit.runner.Result;

import sourceCode.autoGrid.view.ShowProperty;
import sourceCode.faultSimulation.titles.InterposeOcableFaultTitle;
import sourceCode.faultSimulation.titles.InterposeOcableTitle;
import sourceCode.ocableResource.Titles.OcableSectionTitleAllInOne;
import sourceCode.ocableResource.events.ApplyFilter;
import sourceCode.ocableResource.model.MapCoordinate;
import sourceCode.ocableResource.model.OcableModel;
import sourceCode.ocableResource.model.OcableSection;
import sourceCode.ocableResource.model.OcableSectionGeoModel;
import sourceCode.ocableResource.model.OcableSectionInfoModel;
import sourceCode.ocableResource.model.OcableSectionModule;
import sourceCode.ocableResource.model.ResultModel;
import sourceCode.ocableResource.model.StationModule;
import sourceCode.ocableResource.model.TnodeModel;
import sourceCode.ocableResource.model.ocableModelLocator;
import sourceCode.ocableResource.model.ocableStationModel;
import sourceCode.ocableResource.other.StationNode;
import sourceCode.ocableResource.views.BuildFiberDispatch;
import sourceCode.ocableResource.views.CarryBusiness;
import sourceCode.ocableResource.views.RelatedInfo;
import sourceCode.ocableResource.views.RelationWireConfig;
import sourceCode.ocableResource.views.businessInfluenced;
import sourceCode.ocableResource.views.link.ActionTile;
import sourceCode.ocableResource.views.link.IElementCreator;
import sourceCode.ocableResource.views.ocableDetails;
import sourceCode.ocableResource.views.ocableResource;
import sourceCode.ocableResource.views.viewFiberDetails;
import sourceCode.ocableResource.views.viewFiberDetailsInfo;
import sourceCode.resManager.resNode.model.Ocable;
import sourceCode.resManager.resNode.model.Station;
import sourceCode.resManager.resNode.views.enStationTree;
import sourceCode.systemManagement.model.PermissionControlModel;

import twaver.Collection;
import twaver.Constant;
import twaver.Consts;
import twaver.Data;
import twaver.DataBox;
import twaver.DemoImages;
import twaver.DemoUtils;
import twaver.Element;
import twaver.ElementBox;
import twaver.Follower;
import twaver.ICollection;
import twaver.IElement;
import twaver.Layer;
import twaver.Link;
import twaver.Node;
import twaver.SelectionChangeEvent;
import twaver.SelectionModel;
import twaver.SerializationSettings;
import twaver.ShapeLink;
import twaver.Styles;
import twaver.Utils;
import twaver.network.Network;
import twaver.network.Overview;
import twaver.network.interaction.DefaultInteractionHandler;
import twaver.network.interaction.InteractionEvent;
import twaver.network.interaction.MapFilterInteractionHandler;
import twaver.network.interaction.MoveInteractionHandler;
import twaver.network.interaction.SelectInteractionHandler;

private var _modelName:String;
[Bindable]
public function get modelName():String {return _modelName;}
public function set modelName(value:String):void {_modelName = value;}

private var _province:String;
private var  str:Object=null;
[Bindable]
public function get province():String {return _province;}
public function set province(value:String):void {_province = value;}

private var _setoperDesc:String;

[Bindable]
public function get setoperDesc():String {return _setoperDesc;}
public function set setoperDesc(value:String):void {_setoperDesc = value;}

public function get dataBox():DataBox{
	return elementBox;
}

[Embed(source='assets/images/toolbar/equipment.png')]
[Bindable]
private var cs:Class;
[Embed(source='assets/images/toolbar/equipmodel.png')]
[Bindable]
private var sb:Class;
[Embed(source='assets/images/toolbar/topolink.png')]
[Bindable]
private var fy:Class;

[Bindable] 
private var ac:ArrayCollection = new ArrayCollection([
	{label:'局站',icon:cs},
	{label:'站点模板',icon:sb},
	{label:'搜索',icon:sb}]);		

private var itemAdd:ContextMenuItem =  new ContextMenuItem("添加快捷方式",true,true);
private var itemDel:ContextMenuItem =  new ContextMenuItem("取消快捷方式");
private var item0:ContextMenuItem = new ContextMenuItem("属性",true,true);
private var item1:ContextMenuItem = new ContextMenuItem("属性",true,true);
private var item3:ContextMenuItem = new ContextMenuItem("属性",true,true);
private var item2:ContextMenuItem = new ContextMenuItem("光缆业务信息");
private var item4:ContextMenuItem = new ContextMenuItem("混合敷设方式分界信息");
private var item5:ContextMenuItem = new ContextMenuItem("光缆承载业务");
private var fibersimulation:ContextMenuItem = new ContextMenuItem("新建演习科目");
private var fiberfault:ContextMenuItem = new ContextMenuItem("新建故障");
private var item6:ContextMenuItem = new ContextMenuItem("机房平面图",true,true);
private var item7:ContextMenuItem = new ContextMenuItem("光缆截面图");
private var item8:ContextMenuItem = new ContextMenuItem("站内连接关系");
private var item9:ContextMenuItem = new ContextMenuItem("T接点连接关系",true,true);
private var item10:ContextMenuItem = new ContextMenuItem("显示纤芯数",true,true);
private var item12:ContextMenuItem = new ContextMenuItem("隐藏纤芯数",true,true);
private var item11:ContextMenuItem = new ContextMenuItem("\"N-1\"分析");
private var item13:ContextMenuItem = new ContextMenuItem("添加拐点",true,Application.application.isEdit);
private var item14:ContextMenuItem = new ContextMenuItem("删除光缆",false,Application.application.isEdit);
private var item15:ContextMenuItem = new ContextMenuItem("删除局站",true,Application.application.isEdit);
private var item16:ContextMenuItem = new ContextMenuItem("删除拐点",false,Application.application.isEdit);
private var item20:ContextMenuItem=new ContextMenuItem("杆塔/接头盒");
private var item22:ContextMenuItem= new ContextMenuItem("相关资料");
private var item21:ContextMenuItem = new ContextMenuItem("光纤详细信息");
private var item23:ContextMenuItem = new ContextMenuItem("显示无光缆局站");
private var item24:ContextMenuItem = new ContextMenuItem("隐藏无光缆局站");
private var item25:ContextMenuItem = new ContextMenuItem("删除T接点");
//	wuwenqi 20110913
private var item_fiberdis:ContextMenuItem = new ContextMenuItem("制作光纤方式");

private var contextmenu:ContextMenu;
private var elementBox:ElementBox;
//private var netWorkSelectItem:*;//当前选中的对象
private var bounds:Rectangle = new Rectangle(0,0,1200,1700);//network的布局大小
private var mapLayer:Layer;//地图图层
private var nodeLayer:Layer;
private var followerLayer:Layer;
private var linkLayer:Layer;

private var pointerLayer:Layer;//指针图层
private var stationLayer:Layer;//指针图层
private var showfibercount:Boolean = false;

[Bindable]public var xmlOcableProperty:XMLList=new XMLList();
[Bindable]public var xmlOcableModel:XMLList=new XMLList();
[Bindable]public var xmlPointType:XMLList=new XMLList();
[Bindable]public var xmlRunUnit:XMLList=new XMLList();
[Bindable]public var xmlCheckUnit:XMLList=new XMLList();
[Bindable]public var xmlVoltLevel:XMLList=new XMLList();

private var isXmlListInit:Boolean=false;
private var positionX:Number;
private var positionY:Number;
private var showOcableVolt:String = "'1000kV','500kV','220kV','110kV','35kV','20kV','10kV','其他'";//初始加载500kV,220kV,110kV光缆
private var dragDropStation:Node;
private var property:ShowProperty;
private var acStation:ArrayCollection = new ArrayCollection();
private var acTnode:ArrayCollection = new ArrayCollection();
private var acOcablesection:ArrayCollection = new ArrayCollection();
private var preSelectedNodes:ArrayCollection=new ArrayCollection();
//public var province:String="山西省"
private var centerFlag:Boolean=true;
private var minzoom=0;
private var centerFlag2:Boolean=true;
private var xoffset:Number=0;
private var yoffset:Number=0;
private var fontsize:int=10; //字号
private var lastLinkID:String=null;

private var isAddInterpose:Boolean=false;
private var isAddInterposeFault:Boolean=false;

private var xmlDeviceModel:XMLList=new XMLList();
[Bindable]
private var xmlListColl:XMLListCollection=new XMLListCollection();

public function init():void{
//	Alert.show("registerImage");
	elementBox=network.elementBox;
	registerImage();//注册图片
	addNetWorkToolBar();
	network.addInteractionListener(netWorkFunction);// 监听network所有的事件
	addEventListenerForMenuItemSelect();//监听右键事件
	createBackgroundImage();                //根据区域查询缩放比例
	
	initLegend();
	//getStationInfo();//加载光缆
	getProvinceList();//加载区域信息
	network.selectionModel.addSelectionChangeListener(selectItemChange);
	network.addEventListener(MouseEvent.MOUSE_MOVE,handleMouseMove);
	network.visibleFunction = this.visibleFunction;
	this.addEventListener("addFiber1",addFiberReturn);
	this.addEventListener(MouseEvent.MOUSE_WHEEL,linkWidthChange);//鼠标滑动放大，
}

private function addFiberReturn(event:Event):void{
	
}

private function linkWidthChange(event:MouseEvent){
	if(network.zoom>minzoom){//用于缩放时 控制线的宽度
		for(var i:int = 0;i<elementBox.datas.count;i++){
			if(elementBox.datas.getItemAt(i) is ShapeLink){
				var link:ShapeLink = elementBox.datas.getItemAt(i);
				link.setStyle(Styles.LINK_WIDTH,3/(network.zoom<1?1:network.zoom));
			}
		}
	}
}

//设置默认模式函数
private function addInteractionHandler():void{
	network.interactionHandlers=new Collection([  
		new CustomInteractionHandler(network),  
		new MoveInteractionHandler(network),
		new DefaultInteractionHandler(network),]);
}

private function handleMouseMove(e:MouseEvent):void{
	if (lastLinkID !=null)
	{
		var lastLink:Link=network.elementBox.getElementByID(lastLinkID) as Link;
		if(lastLink!=null){
			lastLink.setStyle(Styles.LINK_WIDTH,3);
		}
	}
	var element:IElement=network.getElementByMouseEvent(e);
	if (element is Link)
	{
		element.setStyle(Styles.LINK_WIDTH,8);
		lastLinkID=element.id.toString();
	}
}


private var stationvisible:Boolean = true;//没有光缆的站点显示属性

private function visibleFunction(element:IElement):Boolean{
	if(element is Link){
		if(showOcableVolt!=null&&showOcableVolt != '' ){
			var link:Link = element as Link;
			if(link!=null&&link.getClient('volt')!=null&&showOcableVolt.indexOf(link.getClient('volt').toString()) != -1){
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}
		
	else if(element is Follower){
		var linkbyfollower:ICollection = (element as Follower).host.links;
		if((linkbyfollower==null || linkbyfollower.count==0) && (element as Follower).host.getClient('nodeorlabel') == 'node' ){
			return stationvisible;
		}
	}
		
	else if (element is Node){
		var linkByNode:ICollection = (element as Node).links;
		if((linkByNode==null || linkByNode.count==0) && (element as Node).getClient('nodeorlabel') == 'node' ){
			return stationvisible;
		}
		
		/*for(var i:int=0; i<links.count; i++){
		var link:Link = links.getItemAt(i) as Link;
		if(!link.getClient("LinkVisible")){
		return false;
		}
		}*/
	}
	
	
	return true;
}   

private var proArray1:ArrayCollection;
private function addNetWorkToolBar():void{
	proArray1=new ArrayCollection([
		{label:"默认模式",icon:DemoImages.select},
		{label:"放大",icon:DemoImages.zoomIn},
		{label:"缩小",icon:DemoImages.zoomOut},
		{label:"重置",icon:DemoImages.zoomReset},
		{label:"导出",icon:DemoImages.export},
		//{label:"添加站点",icon:DemoImages.addStation},
		{label:"添加光缆",icon:DemoImages.addOcableSection},
		{label:"编辑拐点",icon:DemoImages.editGeo},
		{label:"保存拐点",icon:DemoImages.save},
		{label:"保存站点",icon:DemoImages.save},
		{label:"图例",icon:DemoImages.legend}
	//	,{label:"添加T接点",icon:DemoImages.legend} //屏蔽T接点
		]);
	var btns:ButtonBar=new ButtonBar();
	
	btns.styleName = 'myButtonBar';
	btns.dataProvider=proArray1;
	btns.addEventListener(ItemClickEvent.ITEM_CLICK,clickBtns);
	toolbar.addChild(btns);	
	
	
	//加载电压等级复选框
	//此处添加地图上方电压等级checkBox
//	var s:Spacer = new Spacer();
//	s.width = 30;
//	toolbar.addChild(s);
//	var label:Label = new Label();
//	label.text = '电压等级:';
//	label.setStyle("fontSize",12);
//	label.setStyle("fontWeight","bold");
//	label.setStyle("color","#cc0000");
//	toolbar.addChild(label);
//	if(province == '主干'){
//		toolbar.addChild(createCheckBox('500'));
//		toolbar.addChild(createCheckBox('220'));
//		toolbar.addChild(createCheckBox('110'));
//	}else{
//		toolbar.addChild(createCheckBox('500'));
//		toolbar.addChild(createCheckBox('220'));
//		toolbar.addChild(createCheckBox('110'));
//		toolbar.addChild(createCheckBox('66'));
//		toolbar.addChild(createCheckBox('35'));
//	}
}


private function clickBtns(e:ItemClickEvent):void
{
	//initNetworkToolbar(toolbar, network);//添加功能按钮
	
	
	if (e.index==0)
	{
		addInteractionHandler();
		for each(var item:* in e.target.getChildren()){
			if(item is Button){
				item.styleName='';
			}
		}
		Button(e.target.getChildAt(e.index)).styleName='myStyles';
	}
	else if (e.index==1)
	{
		if(network.zoom <1.0){
			fontnummber = fontnummber + 2;
			network.zoomIn(false);
			network.callLater(function():void{reSetFontSize(); if(centerFlag2)network.centerByLogicalPoint(network.getScopeRect
				
				(Consts.SCOPE_ROOTCANVAS).width/2,network.getScopeRect(Consts.SCOPE_ROOTCANVAS).height/2); centerFlag2=false;});
		}
		linkWidthChange(new MouseEvent(MouseEvent.MOUSE_WHEEL));
	}
	else if (e.index==2)
	{
		if(network.zoom >0.3&&network.zoom>minzoom){
			fontnummber = fontnummber - 2;
			if(network.verticalScrollBar||network.horizontalScrollBar){network.zoomOut(false); network.callLater(function():void{reSetFontSize
				
				();if(network.verticalScrollBar==null&&network.horizontalScrollBar==null){centerFlag2=true;}});} 
		}
		
	}
	else if (e.index==3)
	{
		fontnummber=0;
		network.zoomOverview(false);
		centerFlag2=true;
		network.callLater(function():void{reSetFontSize();});
	}
	else if (e.index==4) 
	{
		var fr:Object = new FileReference();	
		if(fr.hasOwnProperty("save")){
			//var bitmapData:BitmapData = network.exportAsBitmapData(); //---flex4版本用
			//以下2行是flex3版本用
			var bitmapData:BitmapData = new BitmapData(network.width,network.height,true,0x00ffffff);      
			bitmapData.draw(network);  
			var encoder:PNGEncoder = new PNGEncoder();
			var data:ByteArray = encoder.encode(bitmapData);
			fr.save(data, 'ocablework.png');
		}else{
			Alert.show("install Flash Player 10 to run this feature", "Not Supported"); 
		}
	}
	else if (e.index==5)
	{
		addOcableSectionHandler();
		for each(var item:* in e.target.getChildren()){
			if(item is Button){
				item.styleName='';
			}
		}
		Button(e.target.getChildAt(e.index)).styleName='myStyles';
	}
	else if(e.index==6)
	{
		network.setEditInteractionHandlers();
		for each(var item:* in e.target.getChildren()){
			if(item is Button){
				item.styleName='';
			}
		}
		Button(e.target.getChildAt(e.index)).styleName='myStyles';
	}
	else if(e.index==7)
	{
		if(network.selectionModel.count > 0){
			var item:Object = network.selectionModel.selection.getItemAt(0);
			if(item is ShapeLink){
				var link:ShapeLink = network.selectionModel.selection.getItemAt(0) as ShapeLink;
				remoteObject("ocableResources",true,saveOcableSectionGeoHandler).saveOcableSectionGeo(link.getClient("ocablecode").toString
					
					(),getOcableSectionGeo(link));
			}else{
				Alert.show("请选择一条光缆!","温馨提示!");
			}
		}
	}
	else if(e.index==8){
		//保存站点坐标
		var array:ArrayCollection=new ArrayCollection();
		for (var i:int=0; i < dataBox.count; i++) //遍历图中所有节点
		{
			var ielement:IElement=dataBox.datas.getItemAt(i);
			if (ielement is Node&&(ielement.getClient("nodeorlabel")=="node" ))
			{
				var sys_node:Node=ielement as Node;
				
				var equipinfo:Station=new Station();						
				
				equipinfo.stationcode=sys_node.getClient("stationcode");
//				equipinfo.STATIONNAME=sys_node.name;
				equipinfo.lng=sys_node.centerLocation.x+"";//经纬度
				equipinfo.lat=sys_node.centerLocation.y+"";
//				equipinfo.systemcode=sys_node.getClient("parent");							
				array.addItem(equipinfo);
			}
		}
		var rtobj1:RemoteObject=new RemoteObject("ocableResources");
		rtobj1.endpoint=ModelLocator.END_POINT;
		rtobj1.showBusyCursor=true;
		rtobj1.SaveStationLocation(array);
		rtobj1.addEventListener(ResultEvent.RESULT, afterSaveSysOrgMap);
	}
	else if(e.index==9)
	{
		legendPanel.visible=!legendPanel.visible;
		legendPanel.includeInLayout=!legendPanel.includeInLayout;	
	}
	else if(e.index==10)
	{
		dragDropStation = new Node();
		dragDropStation.width=22;
		dragDropStation.height=22;
		var centerLocation:Point= new Point(700,200);
		dragDropStation.centerLocation=centerLocation;
		dragDropStation.layerID="nodelayer";
		dragDropStation.image="GLZJ";
		//		dragDropStation.setStyle(Styles.LABEL_SIZE,fontsize);
		elementBox.add(dragDropStation);
		var tnode:TnodeModel=new TnodeModel();
		tnode.globalx = (dragDropStation.x-xoffset).toString();
		tnode.globaly = (dragDropStation.y-yoffset).toString();
		
		//		var model:TnodeModel = new TnodeModel();
		//		model.name_std = "";
		//		model.globalx = "300";
		//		model.globaly = "200";
		remoteObject("ocableResources",true,resultaddTnodeHandler).addTnodebyocablesection(tnode,this.province,"光缆路由图");
	}
	
}

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

public var tnodecode:String = '';
public function  resultaddTnodeHandler(event:ResultEvent):void{
	dragDropStation.setClient('stationcode',event.result.toString());
	dragDropStation.setClient('TFLAG',"TNODE");
	tnodecode = event.result.toString();
	property = new ShowProperty();
	property.paraValue = tnodecode;
	property.tablename = "VIEW_TNODE_PROPERTY";
	property.key = "TNODECODE";
	property.title = "添加T接点";
	PopUpManager.addPopUp(property, this, true);
	PopUpManager.centerPopUp(property);
	property.addEventListener("savePropertyComplete",saveTnodeCompleteHandler);
	property.addEventListener("closeProperty",closeTnodeHandler);
	
	//	tnodecode = event.result.toString();
	//	property = new ShowProperty();
	//	property.paraValue =tnodecode;
	//	property.tablename = "VIEW_TNODE_PROPERTY";
	//	property.key = "TNODECODE";
	//	property.title = "属性";
	//	PopUpManager.addPopUp(property, this, true);
	//	PopUpManager.centerPopUp(property);
	//	property.addEventListener("savePropertyComplete",saveTnodeCompleteHandler);
	//	property.addEventListener("closeProperty",closeTnodeHandler);
	
	
}

private function saveTnodeCompleteHandler(event:Event):void{
	dragDropStation.name = (property.getElementById("NAME_STD",property.arrayList) as TextInput).text;
	dragDropStation.setClient("isTnode","0");
	dragDropStation.setClient("name",dragDropStation.name);
	PopUpManager.removePopUp(property);
	dragDropStation.toolTip=dragDropStation.name;
	dragDropStation.setStyle(Styles.LABEL_COLOR,'0x666666');
	dragDropStation.setStyle(Styles.LABEL_SIZE,fontsize);
	var f:Follower = new Follower("label"+tnodecode);
	f.layerID='followerLayer';
	f.setClient('stationcode',tnodecode);
	f.setClient('isTnode','3');
	f.setClient('nodeorlabel','label');
	f.host = dragDropStation;
	//	f.name = (property.getElementById("NAME_STD",property.arrayList) as TextInput).text;
	f.image = "";
	f.width = 0;
	f.height = 0;
	f.setStyle(Styles.LABEL_SIZE,fontsize);
	f.location =new Point(700,220);
	f.setStyle(Styles.LABEL_COLOR,'0x666666');
	f.setClient('TFLAG',"TNODE");
	elementBox.add(f);
	
	
	//	var model:Object = new Object();
	//	model.STATIONCODE = tnodecode;
	//	model.ISTNODE = '0';
	//	model.STATIONNAME = (property.getElementById("NAME_STD",property.arrayList) as TextInput).text;
	//	model.NODE_X = 300;
	//	model.NODE_Y = 200;
	//	model.LABEL_X = 300;
	//	model.LABEL_Y = 230;
	//	elementBox.add(createStationNode(model));
}
private function closeTnodeHandler(event:Event):void{
	remoteObject("ocableResources",true,null).deleteTnode(tnodecode);
	elementBox.remove(dragDropStation);
	//elementBox.remove(elementBox.getElementByID(tnodecode));
}


//加载右侧局站列表数据
public function getProvinceList():void{
	//remoteObject("ocableResources",true,resultProvinceHandler).getProvinceList();
	remoteObject("ocableResources",true,resultProvinceHandler).getDomain(" ","root");
}
//[Bindable] private var xml:XML = new XML(<node PROVINCE=''  PROVINCENAME='局站'  PARENT_ID='' checked='0'/>);

[Bindable] public var folderCollection:XMLList;
[Bindable]  private var selectedNode:XML;
private var type:String;
private var xml:XMLList = new XMLList(<node PROVINCE=''  PROVINCENAME='局站'  PARENT_ID='' checked='0'/>);
public function resultProvinceHandler(event:ResultEvent):void{
	folderCollection = new XMLList(event.result.toString()); 
	treeProvince.dataProvider = folderCollection;
	
}


//打开某县获取局站
public function treeItemOpen(e:TreeEvent):void{
    
	selectedNode = e.item as XML;
	if(selectedNode!=null&&'true'!=selectedNode.@leaf ){
		if(selectedNode.attribute("isHasChild")!=null&&selectedNode.attribute("isHasChild")=='false'){
		}else{
			if(selectedNode.children().length() == 0){
				
				type = selectedNode.@type == 'city'?"ocablesectioin":selectedNode.@type;
				var rt_TimeslotTree:RemoteObject = new RemoteObject("ocableResources");
				rt_TimeslotTree.endpoint = ModelLocator.END_POINT;
				rt_TimeslotTree.showBusyCursor =true;
				rt_TimeslotTree.getStationOcablesection(selectedNode.@code.toString(),type,province);//获取树的数据
				rt_TimeslotTree.addEventListener(ResultEvent.RESULT, generateRateTreeInfo);
			}
		}
	}
}


private function expandTreeNode(xml:XML):void{
	treeProvince.expandItem(selectedNode,true);
}
private function generateRateTreeInfo(event:ResultEvent):void
{
	var str:String = event.result as String;  
	
	if(str!=null&&str!="")
	{  
		var child:XMLList= new XMLList(str);
		if(selectedNode.children()==null||selectedNode.children().length()==0)
		{ 	
			treeProvince.expandItem(selectedNode,false);
			selectedNode.folder += child;
			treeProvince.callLater(expandTreeNode,[selectedNode]);
		}
	} 
}

public function tree_itemClick(evt:ListEvent,tree:Tree):void {
	
	var item:Object = Tree(evt.currentTarget).selectedItem;
	if (tree.dataDescriptor.isBranch(item)) {
		
		tree.expandItem(item, !tree.isItemOpen(item), true);
	}
	
}

public function resultgetOcableSectionbystation(event:ResultEvent):void{
	var ac:ArrayCollection = ArrayCollection(event.result);
	//Alert.show(ac.length.toString());
}


private function selectItemChange(e:SelectionChangeEvent):void{
	for each(var node:Node in preSelectedNodes){
		if(node.followers!=null&&node.followers.count>0){
			(node.followers.getItemAt(0) as Follower).setStyle(Styles.LABEL_COLOR,0x666666);
		}
	}
	preSelectedNodes.removeAll();
	for(var i:int=0;i<network.selectionModel.selection.count;i++){
		var element:Element=network.selectionModel.selection.getItemAt(i) as Element;
		if(element){
			if(element.getClient("nodeorlabel")=="node"){
				if((element as Node).followers.count>0){
					(element as Node).followers.getItemAt(0).setStyle(Styles.LABEL_COLOR,0x31C200);
					preSelectedNodes.addItem(element);
				}
			}
			if(element is Link){
				(element as Link).setStyle(Styles.SELECT_STYLE, Consts.SELECT_STYLE_BORDER);
				(element as Link).setStyle(Styles.SELECT_WIDTH, '10');
				(element as Link).setStyle(Styles.SELECT_COLOR, 0x00FF00);
			}
		}
		
		
	}
}
//初始加载局站
private function getStationInfo():void{
	acStation.removeAll();
	acTnode.removeAll();
	remoteObject("ocableResources",true,resultStationInfo).getStationInfo(showOcableVolt,setoperDesc);
	remoteObject("ocableResources",true,resultTnodeInfo).getTnodeInfo(showOcableVolt,setoperDesc);
}



//返回T接点信息
private function resultTnodeInfo(event:ResultEvent):void{
	var ac:ArrayCollection = ArrayCollection(event.result);
	for (var i:int = 0;i < ac.length; i++) {
		acTnode.addItem(new ObjectProxy(ac[i]));
		
	} 
	resultTnodeHandler();
}	

//返回局站信息
private function resultStationInfo(event:ResultEvent):void{
	var ac:ArrayCollection = ArrayCollection(event.result);
	for (var i:int = 0;i < ac.length; i++) {
		acStation.addItem(new ObjectProxy(ac[i]));
	} 
	
	/*for each(var item:Object in acStation){
	if(elementBox.getElementByID(item.STATIONCODE) == null){
	elementBox.add(createStationNode(item));
	}
	
	
	}*/
	//根据局站获取光缆                              
	remoteObject("ocableResources",true,resultOcableSectionInfo).getOcableSectionbystation(showOcableVolt,province);
}

private function resultOcableSectionInfo(event:ResultEvent):void{
	var ac:ArrayCollection = ArrayCollection(event.result);
	acOcablesection=new ArrayCollection();
	for (var i:int = 0;i < ac.length; i++) {
		acOcablesection.addItem(new ObjectProxy(ac[i]));
	} 

	
	//获取拐点信息
	remoteObject("ocableResources",true,resultOcableGeoHandler).getOcablesectiongeo(showOcableVolt,province);
	
}

private function resultTnodeHandler():void{
	//Alert.show(event.result.toString());
	
	for(var i:int = 0;i<elementBox.toDatas().count;i++)
	{
		var ielement:IElement=elementBox.toDatas().getItemAt(i);
		if(ielement is Node)
		{
			var node:Node=ielement as Node;
			if(node.getClient("TFLAG")=='TNODE'){
				elementBox.remove(node);
			}
		}
		else if(ielement is Follower)
		{
			var node1:Follower=ielement as Follower;
			if(node1.getClient("TFLAG")=='TNODE'){
				elementBox.remove(node1);
			}
		}
	}
	for each(var itemStation:Object in acTnode){
		if(elementBox.getElementByID(itemStation.STATIONCODE) == null){
			elementBox.add(createStationNode(itemStation));
		}
	}
	
}	
private var aaaa:Boolean = true;
private function resultOcableGeoHandler(event:ResultEvent):void{
//	Alert.show((acOcablesection.length%10).toString()+"--aa-");
	for each(var itemStation:Object in acStation){
		if(elementBox.getElementByID(itemStation.STATIONCODE) == null){
			elementBox.add(createStationNode(itemStation));
		}
	}
	
	for each(var itemOcablesection:Object in acOcablesection){
		if(elementBox.getElementByID(itemOcablesection.SECTIONCODE) == null){
			var link:Link = createOcableSection(itemOcablesection);
			if(link != null){
				//elementBox.add(createOcableSection(itemOcablesection));
				elementBox.add(link);
			}
			
		}
	}
	/*if(aaaa){
	hideStationFunction();
	aaaa = false;
	}*/
	
	
	var acOcableGeo:ArrayCollection = ArrayCollection(event.result);
	for each(var item:Object in acOcableGeo){
		if(elementBox.getElementByID(item.SECTIONCODE) != null){
			(elementBox.getElementByID(item.SECTIONCODE) as ShapeLink).addPoint(new Point(Number(item.X)+xoffset,Number(item.Y)+yoffset));
		}
	}
	mapLayer.visible=true;
	network.zoom = minzoom;
}


//创建局站图标
private function createStationNode(item:Object):Node{
	var node:Node = new Node(item.STATIONCODE);
	node.layerID = 'nodeLayer';
	node.setClient('stationcode',item.STATIONCODE);
	if(item.STATIONNAME != null){
		node.setClient('stationname',item.STATIONNAME);
	}else{
		node.setClient('stationname','');
	}
	
	node.setClient('isTnode',item.ISTNODE);
	node.setClient('nodeorlabel','node');
	node.toolTip = "局站名称:"+item.STATIONNAME;
	node.name = " ";
	
	
	if(item.ISTNODE == '0'){
		node.image = 'GLZJ';
	}else{
		
		node.image = ocableModelLocator.getStationType(item.ISTNODE,item.STATIONTYPE);
//		node.image = ocableModelLocator.getStationType(item.ISTNODE,item.VOLT+item.STATIONTYPE);
	}
//	Alert.show("---"+node.image);
	
	var nodesizewidth:Number;
	var nodesizeheight:Number;
	if(province == '主干'){
		nodesizewidth = 24;
		nodesizeheight = 24;
	}else{
		nodesizewidth = 18;
		nodesizeheight = 18;
	}
	node.width = nodesizewidth;
	node.height = nodesizeheight;
	node.setStyle(Styles.LABEL_SIZE,fontsize);
	var node_x:Number =Number(item.NODE_X);
	
	var node_y:Number =Number(item.NODE_Y);
	
	node.location = new Point(node_x,node_y);
//	node.location = new Point(node_x+xoffset,node_y+yoffset);
	node.setClient("name",item.STATIONNAME);
	
	var f:Follower = new Follower();
	//	var f:Follower = new Follower("label"+item.STATIONCODE);
	f.layerID='followerLayer';
	f.setClient('stationcode',item.STATIONCODE);
	f.setClient('isTnode','3');
	f.setClient('nodeorlabel','label');
	f.host = node;
	f.name = item.STATIONNAME;
	f.image = "";
	f.width = 0;
	f.height = 0;
	f.setStyle(Styles.LABEL_SIZE,fontsize);
	f.location = new Point(node_x,node_y);
//	f.location =new Point(node_x+xoffset,node_y+yoffset);
	f.setStyle(Styles.LABEL_COLOR,'0x666666');
	elementBox.add(f);
	return node;
}

//创建光缆
private function createOcableSection(item:Object):ShapeLink{
	if( elementBox.getElementByID(item.A_POINT) == null || elementBox.getElementByID(item.Z_POINT) ==null){
		return null;
	}
	var from:Node = elementBox.getElementByID(item.A_POINT) as Node;
	var to:Node = elementBox.getElementByID(item.Z_POINT) as Node;
	var link:ShapeLink = new ShapeLink(item.SECTIONCODE,from,to);
	link.layerID = 'linkLayer';
	link.setClient("ocabledata",item);
	link.setClient("ocablecode",item.SECTIONCODE);
	link.setClient("volt",item.SECVOLTNAME);
	link.setClient("ocablelength",item.LENGTH);
	link.setStyle(Styles.LABEL_SIZE,6);
	link.setStyle(Styles.LINK_COLOR, item.SECCOLOR.toString());
	link.setStyle(Styles.LINK_WIDTH, 3);
	link.setStyle(Styles.OUTER_WIDTH, 6);
	link.setClient("fiberName",item.OCABLESECTIONNAME);
	link.setClient("voltageGrade",item.SECVOLTNAME);
	link.setClient("lineLength",item.LENGTH);
	link.setClient("fiberCount",item.FIBERCOUNT);
	link.setClient("maintainUnit",item.FUNCTION_UNIT);//没有
	link.toolTip = "线路名称:"+item.OCABLESECTIONNAME+"\n"+"电压等级:"+item.SECVOLTNAME+"\n"+"线路长度:"+item.LENGTH+"\n"+"纤芯数目:"+item.FIBERCOUNT+"\n"+"维护单位:"+item.PROPERTY+"\n"+"备    注:";
	link.setStyle(Styles.LINK_BUNDLE_GAP,6);
	
	link.setStyle(Styles.LABEL_POSITION,Consts.POSITION_RIGHT);
	link.setStyle(Styles.LINK_BUNDLE_EXPANDED, true);
	link.setStyle(Styles.LINK_BUNDLE_ENABLE,true);
	link.setStyle(Styles.LINK_BUNDLE_INDEPENDENT,true);
	
	return link;
}


//remoteObject对象
private function remoteObject(servicename:String,showBusyCursor:Boolean=true,resultfunction:Function=null):RemoteObject{
	var remoteObject:RemoteObject = new RemoteObject(servicename);
	remoteObject.endpoint = ModelLocator.END_POINT;
	remoteObject.showBusyCursor = showBusyCursor;
	if(resultfunction != null){
		remoteObject.addEventListener(ResultEvent.RESULT,resultfunction);
	}
	remoteObject.addEventListener(FaultEvent.FAULT,faultFunction);
	return remoteObject;
}

private function faultFunction(event:FaultEvent):void{
	Alert.show(event.fault.toString());
}

//注册主干光缆图中应用的图片
private function registerImage():void{
	
	//注册地图图片
//	Utils.registerImageByClass("广东",ocableModelLocator.province,true);//山西省  主干
//	Utils.registerImageByClass("太原",ocableModelLocator.taiyuan,true);//太原
//	Utils.registerImageByClass("大同",ocableModelLocator.datong,true);//大同
//	Utils.registerImageByClass("阳泉",ocableModelLocator.yangquan,true);//阳泉
//	Utils.registerImageByClass("晋城",ocableModelLocator.jincheng,true);//晋城
//	Utils.registerImageByClass("吕梁",ocableModelLocator.lvliang,true);//吕梁
//	Utils.registerImageByClass("长治",ocableModelLocator.changzhi,true);//长治
//	Utils.registerImageByClass("临汾",ocableModelLocator.linfen,true);//临汾
//	Utils.registerImageByClass("运城",ocableModelLocator.yuncheng,true);//运城
//	Utils.registerImageByClass("晋中",ocableModelLocator.jinzhong,true);//晋中
//	Utils.registerImageByClass("忻州",ocableModelLocator.xinzhou,true);//忻州
//	Utils.registerImageByClass("朔州",ocableModelLocator.shuozhou,true);//朔州
//	Utils.registerImageByClass("默认",ocableModelLocator.shuozhou,true);//朔州
	//县地图
	
	//太原
//	Utils.registerImageByClass("古交市",ocableModelLocator.gujiaoshi,true);
//	Utils.registerImageByClass("娄烦县",ocableModelLocator.loufanxian,true);
//	Utils.registerImageByClass("清徐县",ocableModelLocator.qingxuxian,true);
//	Utils.registerImageByClass("太原市",ocableModelLocator.taiyuanshi,true);
//	Utils.registerImageByClass("阳曲县",ocableModelLocator.yangquxian,true);
//	//阳泉
//	Utils.registerImageByClass("阳泉市",ocableModelLocator.yangquanshi,true);
//	Utils.registerImageByClass("盂县",ocableModelLocator.mengxian,true);//盂县
//	Utils.registerImageByClass("平定县",ocableModelLocator.pingdingxian,true);//平定县
	
	Utils.registerImageByClass("direction",ocableModelLocator.direction,true);//注册方向标图片
	Utils.registerImageByClass("ocable",ocableModelLocator.ocable,true);//图例
	//变电站
	Utils.registerImageByClass("station_1000kV",ocableModelLocator.station_1000kV,true);
	Utils.registerImageByClass("station_500kV",ocableModelLocator.station_500kV,true);
	Utils.registerImageByClass("station_200kV",ocableModelLocator.station_200kV,true);
	Utils.registerImageByClass("station_110kV",ocableModelLocator.station_110kV,true);
	//电厂
	Utils.registerImageByClass("power_500kV",ocableModelLocator.power_220kV,true);
	Utils.registerImageByClass("power_220kV",ocableModelLocator.power_220kV,true);
	Utils.registerImageByClass("power_110kV",ocableModelLocator.power_110kV,true);
	Utils.registerImageByClass("power",ocableModelLocator.power_220kV,true);
	
	Utils.registerImageByClass("zhongxinzhan",ocableModelLocator.zhongxinzhan,true);
	Utils.registerImageByClass("didiao",ocableModelLocator.didiao,true);
	Utils.registerImageByClass("other",ocableModelLocator.other,true);
	Utils.registerImageByClass("GLZJ",ocableModelLocator.GLZJ,true);
	Utils.registerImageByClass("CB",ocableModelLocator.CB,true);
	Utils.registerImageByClass("KB",ocableModelLocator.KB,true);
	Utils.registerImageByClass("WB",ocableModelLocator.WB,true);
	Utils.registerImageByClass("YH",ocableModelLocator.YH,true);
	
	Utils.registerImageByClass("assets/images/swf/ocable/legend/zhongxinzhan.swf",ocableModelLocator.zhongxinzhanswf,true);
	Utils.registerImageByClass("assets/images/swf/ocable/legend/s_35kV.swf",ocableModelLocator.station_1000kV,true);
	Utils.registerImageByClass("assets/images/swf/ocable/legend/s_10kV.swf",ocableModelLocator.power_110kV,true);
	Utils.registerImageByClass("assets/images/swf/ocable/legend/didiao.swf",ocableModelLocator.didiaoswf,true);
	Utils.registerImageByClass("assets/images/swf/ocable/legend/1000_s.swf",ocableModelLocator.s1000swf,true);
	Utils.registerImageByClass("assets/images/swf/ocable/legend/500_s.swf",ocableModelLocator.s500swf,true);
	Utils.registerImageByClass("assets/images/swf/ocable/legend/220_s.swf",ocableModelLocator.s220swf,true);
	Utils.registerImageByClass("assets/images/swf/ocable/legend/110_s.swf",ocableModelLocator.s110swf,true);
	Utils.registerImageByClass("assets/images/swf/ocable/legend/500_d.swf",ocableModelLocator.d500swf,true);
	Utils.registerImageByClass("assets/images/swf/ocable/legend/220_d.swf",ocableModelLocator.d220swf,true);
	Utils.registerImageByClass("assets/images/swf/ocable/legend/110_d.swf",ocableModelLocator.d110swf,true);
	Utils.registerImageByClass("assets/images/swf/ocable/legend/chuanbuzhan.swf",ocableModelLocator.chuanbuzhanswf,true);
	Utils.registerImageByClass("assets/images/swf/ocable/legend/kaibizhan.swf",ocableModelLocator.kaibizhanswf,true);
	Utils.registerImageByClass("assets/images/swf/ocable/legend/yonghuzhan.swf",ocableModelLocator.yonghuzhanswf,true);
	Utils.registerImageByClass("assets/images/swf/ocable/legend/qita.swf",ocableModelLocator.qitaswf,true);
	
	
	
	Utils.registerImageByClass("showPointer",ocableModelLocator.showPointer,true);
	
	SerializationSettings.registerGlobalClient("stationdata", Consts.TYPE_DATA);
	SerializationSettings.registerGlobalClient("ocabledata", Consts.TYPE_DATA); 
	SerializationSettings.registerGlobalClient("volt", Consts.TYPE_STRING);
	SerializationSettings.registerGlobalClient("stationcode", Consts.TYPE_STRING);
	SerializationSettings.registerGlobalClient("stationname", Consts.TYPE_STRING);
	SerializationSettings.registerGlobalClient("ocablecode", Consts.TYPE_STRING);
	SerializationSettings.registerGlobalClient("isTnode", Consts.TYPE_STRING);
	SerializationSettings.registerGlobalClient("nodeorlabel", Consts.TYPE_STRING);
}

private function addEventListenerForMenuItemSelect():void{
	itemAdd.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,itemAddSelectHanlder);
	itemDel.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,itemDelSelectHandler);
	item0.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,item1ItemSelectHandler);
	item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,item1ItemSelectHandler);
	item2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,item2ItemSelectHandler);
	item3.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,item1ItemSelectHandler);
	item4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,item4ItemSelectHandler);
	item5.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,item5ItemSelectHandler);
	fibersimulation.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,fibersimulationSelectHandler);
	fiberfault.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,fiberfaultSelectHandler);
	
	item6.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,item6ItemSelectHandler);
	item7.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,item7ItemSelectHandler);
	item8.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,item8ItemSelectHandler);
	item9.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,item9ItemSelectHandler);
	item10.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,item10ItemSelectHandler);
	item11.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,item11ItemSelectHandler);
	item12.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,item12ItemSelectHandler);
	item13.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,item13ItemSelectHandler);
	item14.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,item14ItemSelectHandler);
	item15.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,item15ItemSelectHandler);
	item16.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,item16ItemSelectHandler);
	item20.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,item20ItemSelectHandler);
	item21.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,item21ItemSelectHandler);
	item22.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,item22ItemSelectHandler);
	
	item23.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,item23ItemSelectHandler);
	item24.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,item24ItemSelectHandler);
	item25.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,item15ItemSelectHandler);
	//		wuwenqi 20110913
	item_fiberdis.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemFiberdisHandler);
	contextmenu = new ContextMenu();
	network.contextMenu = contextmenu;
	contextmenu.addEventListener(ContextMenuEvent.MENU_SELECT, contextMenu_menuSelect);
}

//新建演习科目
private function fibersimulationSelectHandler(event:ContextMenuEvent):void{
	if(network.selectionModel.count>0)
	{
		var item:Object = network.selectionModel.selection.getItemAt(0);
		if (item is Link)
		{	
			var link:ShapeLink = network.selectionModel.selection.getItemAt(0) as ShapeLink;
			var interpose:InterposeOcableTitle = new InterposeOcableTitle();
			interpose.title = "添加";
			interpose.paraValue = link.id.toString();//光缆ID
			interpose.type = "ocable";
			interpose.mainApp=this;
			PopUpManager.addPopUp(interpose,Application.application as DisplayObject,true);
			PopUpManager.centerPopUp(interpose);
			interpose.addEventListener("RefreshDataGrid",RefreshDataGrid);
			
		}
	}
}
private function RefreshDataGrid(event:Event):void{
	Application.application.openModel("演习科目管理", false);
}
//新建故障
private function fiberfaultSelectHandler(event:ContextMenuEvent):void{
	if(network.selectionModel.count>0)
	{
		var item:Object = network.selectionModel.selection.getItemAt(0);
		if (item is Link)
		{	
			var link:ShapeLink = network.selectionModel.selection.getItemAt(0) as ShapeLink;
			var interposeFault:InterposeOcableFaultTitle = new InterposeOcableFaultTitle();
			interposeFault.title = "添加";
			interposeFault.paraValue = link.id.toString();
			interposeFault.type="ocable";
			interposeFault.mainApp=this;
			interposeFault.user_id=parentApplication.curUser;
			interposeFault.txt_user_name =parentApplication.curUserName;
			PopUpManager.addPopUp(interposeFault,Application.application as DisplayObject,true);
			PopUpManager.centerPopUp(interposeFault);
			interposeFault.addEventListener("RefreshDataGrid",RefreshDataGrid);
		}
	}
}

//加载地图
private function createBackgroundImage():void{
//	if(province != '主干'){
//		showOcableVolt =  "'500kV','220kV','110kV','66kV','35kV'";
//	}
	mapLayer=new Layer("mapLayer");
	elementBox.layerBox.add(mapLayer,0);
	mapLayer.movable = false;
	//	mapLayer.visible=false;
	//var mapName:String = getMapName(this.province);
//	var nodeMap:Node = new Node(this.setoperDesc);//背景地图
	//nodeMap.image="assets/images/swf/ocable/map/" + this.province+ ".swf"
	var nodeMap:Node = new Node(this.setoperDesc);//背景地图
	nodeMap.layerID="mapLayer";
	//nodeMap.location = new Point(0,0);
	try{       
	//			nodeMap.image="assets/images/swf/ocable/map/" + this.setoperDesc+ ".swf";
//		nodeMap.image=this.setoperDesc;//显示功能不完善  暂时屏蔽，时有时无
		nodeMap.image="assets/images/swf/ocable/map/gdMap.png";
		nodeMap.image="assets/images/swf/ocable/map/blankMap.png";
		nodeMap.setStyle(Styles.BACKGROUND_TYPE, Consts.BACKGROUND_TYPE_VECTOR);//设置矢量图
		elementBox.add(nodeMap);
	}catch(e:Error){ 
		nodeMap.image="assets/images/swf/ocable/map/blank.png";
		elementBox.add(nodeMap);
	}  
	var nodeDirection:Node = new Node("direction");//方向标
	nodeDirection.image = "direction";
	nodeDirection.layerID="mapLayer";                          
	nodeDirection.width=300;
	nodeDirection.height=300;
	//	if(province != '主干'){
	//		
	//	}
	nodeDirection.location = new Point(2000,100);
	
	
	elementBox.add(nodeDirection);
	var nodeOcable:Node = new Node();
	nodeOcable.setSize(1,1);
	elementBox.add(nodeOcable);
	
	setTimeout(function():void{
		centerFlag2=true;
		var node:Node = new Node("node0");
		node.layerID = "mapLayer";
		node.setSize(1,1);
		node.setLocation(nodeMap.width, nodeMap.height);
		elementBox.add(node);
		network.callLater(function():void{
			if(centerFlag){
				network.zoomOverview(false);
//				Alert.show(network.zoom.toString());
				reSetFontSize();
				centerFlag=false;
				var mapx:Number = network.width/network.zoom/2 - nodeMap.width/2;
				var mapy:Number = network.height/network.zoom/2 - nodeMap.height/2;
				xoffset = mapx - nodeMap.x;
				yoffset = mapy - nodeMap.y;
				nodeMap.setLocation(mapx, mapy);
				//				xoffset=network.width/2/network.zoom-(network.getScopeRect(Consts.SCOPE_ROOTCANVAS).width)/2;
				//				yoffset=network.height/2/network.zoom-network.getScopeRect(Consts.SCOPE_ROOTCANVAS).height/2;
				//				nodeMap.setLocation(network.width/network.zoom/2 - nodeMap.width/2,network.height/network.zoom/2 - nodeMap.height/2);
				//				nodeDirection.setLocation(nodeDirection.x+xoffset,nodeDirection.y+yoffset);
				if(province!='广东'&&province!=''
				){
					nodeDirection.width=200;
					nodeDirection.height=200;
					nodeDirection.setLocation(network.width/network.zoom-500,30);
				}else{
					nodeDirection.setLocation(network.width/network.zoom-500,nodeDirection.y+yoffset);
				}
				//nodeOcable.setLocation(nodeOcable.x+xoffset,nodeOcable.y+yoffset);
				var node:Node=new Node();
				node.layerID="mapLayer";
				//									node.image="";
				node.setSize(1,1);
				node.setLocation(network.width/network.zoom-2,network.height/network.zoom-2);
				network.elementBox.add(node);
				network.alpha=1;
				getStationInfo();//加载光缆
				minzoom=network.zoom;
			}});},2000);
	
	
	network.selectionModel.filterFunction=function(data:Element):Boolean{//地图中设置不允许点击地图图层和指针图层
		return data.layerID != "mapLayer" && data.layerID != "pointerLayer";
	};
	
	followerLayer=new Layer("followerLayer");//局站名字图层
	elementBox.layerBox.add(followerLayer,1);
	
	linkLayer=new Layer("linkLayer");//光缆图层
	elementBox.layerBox.add(linkLayer,2);
	
	nodeLayer=new Layer("nodeLayer");//局站图层
	elementBox.layerBox.add(nodeLayer);
	
	addOverview(network);//添加雷达图 右下角可缩放
	
	addInteractionHandler();//默认模式
}

public function addOverview(network:Network):void{
	var show:Parallel = new Parallel();
	show.duration = 250;
	addAnimateProperty(show, "alpha", 0.6, false);
	addAnimateProperty(show, "width", 250, false);
	addAnimateProperty(show, "height", 200, false);
	
	var hide:Parallel = new Parallel();
	hide.duration = 250;
	addAnimateProperty(hide, "alpha", 0, false);	
	addAnimateProperty(hide, "width", 0, false);
	addAnimateProperty(hide, "height", 0, false);
	
	var overview:Overview = new Overview();
	overview.visible = false;
	overview.width = 0;
	overview.height = 0;
	overview.backgroundColor = 0xFFFFFF;
	overview.backgroundAlpha = 0.6;
	overview.setStyle("right", 17);
	overview.setStyle("bottom", 17);
	overview.setStyle("showEffect", show);
	overview.setStyle("hideEffect", hide);
	
	var toggler:Button = new Button();
	toggler.width = 17;
	toggler.height = 17;
	toggler.setStyle("right", 0);
	toggler.setStyle("bottom", 0);
	toggler.setStyle("icon", DemoImages.show);
	toggler.addEventListener(MouseEvent.CLICK, function(e:*):void{
		if(toggler.getStyle("icon") == DemoImages.show){
			toggler.setStyle("icon", DemoImages.hide);
			overview.network = network;
			overview.visible = true;
		}else{
			toggler.setStyle("icon", DemoImages.show);
			overview.visible = false;
		}					
	});	
	hide.addEventListener(EffectEvent.EFFECT_END, function(e:*):void{
		overview.network = null;
	});				
	cas.addChild(overview);
	cas.addChild(toggler);		
}

private static function addAnimateProperty(effect:CompositeEffect, property:String, toValue:Number, isStyle:Boolean = true):AnimateProperty{
	var animateProperty:AnimateProperty = new AnimateProperty();
	animateProperty.isStyle = isStyle;
	animateProperty.property = property;
	animateProperty.toValue = toValue; 
	effect.addChild(animateProperty);
	return animateProperty;
}

public function getMapName():String{
	var name:String = "";
	return name;
}


private var fontnummber:int = 0;
private function reSetFontSize():void{
	var zoom:Number=network.zoom;
	//	if(province == '主干'){
	fontsize= 9;
	//	}
	if(zoom<=1.2){
		fontsize=parseInt((fontsize/zoom).toString());
		
		var count:int=elementBox.datas.count;
		//微调字体
		
		for(var i:int=0;i<count;i++){
			if((elementBox.datas.getItemAt(i) as Element).id!="Legend"){
				(elementBox.datas.getItemAt(i) as Element).setStyle(Styles.LABEL_SIZE,fontsize+fontnummber);
			}else{
				(elementBox.datas.getItemAt(i) as Element).setStyle(Styles.LABEL_SIZE,fontsize*2+fontnummber);
			}
		}
	}
}

private function setZoomFontSize():void{
	var count:int=elementBox.datas.count;
	for(var i:int=0;i<count;i++){
		if((elementBox.datas.getItemAt(i) as Element).id!="Legend"){
			(elementBox.datas.getItemAt(i) as Element).setStyle(Styles.LABEL_SIZE,22);
		}else{
			(elementBox.datas.getItemAt(i) as Element).setStyle(Styles.LABEL_SIZE,22);
		}
	}
}

//
private function preinitialize():void{
	if(ModelLocator.permissionList!=null&&ModelLocator.permissionList.length>0){
		
		for(var i:int=0;i<ModelLocator.permissionList.length;i++){
			var model:PermissionControlModel = ModelLocator.permissionList[i];
			if(model.oper_name!=null&&model.oper_name=="新建演习科目"){
				isAddInterpose = true;
			}
			if(model.oper_name!=null&&model.oper_name=="新建故障"){
				isAddInterposeFault = true;
			}
		}
	}
}

//设置右键菜单
private function contextMenu_menuSelect(e:Event):void{
	contextmenu.hideBuiltInItems();
	if(network.selectionModel.count > 0){
		if((Element)(network.selectionModel.selection.getItemAt(0)) is Link){
			//contextmenu.customItems = [item0,item2,item4,item5,item7,item11,item14];
			
			contextmenu.customItems = [];
//			contextmenu.customItems = [item5,item7,item4,item2,item21,item20,item22,item0,item13,item16,item14];
			contextmenu.customItems = [item5,item7,item21,item0,item13,item16,item14];
			//添加演习和故障
			if(isAddInterpose){
				contextmenu.customItems.push(fibersimulation);
			}
			if(isAddInterposeFault){
				contextmenu.customItems.push(fiberfault);
			}
		}else if ((Element)(network.selectionModel.selection.getItemAt(0)) is Node){
			var node:Node = (Element)(network.selectionModel.selection.getItemAt(0)) as Node;
			contextmenu.customItems = [];
			
			if(node.getClient("isTnode").toString() == '0'){
//站内连接关系				contextmenu.customItems.push(node.getClient("isTnode").toString()=='1'?item8:item9);
				contextmenu.customItems.push(node.getClient("isTnode").toString()=='1'?item1:item3);
				contextmenu.customItems.push(item25);
				return;
			}
			if(node.getClient("isTnode").toString() == '1'){
//机房平面图				contextmenu.customItems.push(item6);
			}
			
//站内连接关系			contextmenu.customItems.push(node.getClient("isTnode").toString()=='1'?item8:item9);
			contextmenu.customItems.push(node.getClient("isTnode").toString()=='1'?item1:item3);
			contextmenu.customItems.push(item15);
			
			if(node.getClient("isTnode").toString() == '3'){
				contextmenu.customItems = [];
				return;
			}
		}
		
	}else{
		if(showfibercount){
			contextmenu.customItems = [];
			contextmenu.customItems = [item12];
		}else{
			contextmenu.customItems = [];
			contextmenu.customItems = [item10]; 
		}
		
		if(!stationvisible){
			contextmenu.customItems.push(item23);
		}else{
			contextmenu.customItems.push(item24);
		}
	}
	
//	contextmenu.customItems.push(itemAdd);//快捷方式
//	contextmenu.customItems.push(itemDel);//快捷方式
	
}
/**
 *  站点平面图 
 */
private function itemToInnerWringHandler(event:ContextMenuEvent):void{
	if(network.selectionModel.count > 0){
		if (network.selectionModel.selection.getItemAt(0) is Node){
			var node:Node = network.selectionModel.selection.getItemAt(0) as Node;
			if(node.getClient('isTnode').toString()=='1'){
				var stationcode:String = node.getClient('stationcode').toString().substr(1,node.getClient('stationcode').toString().length);
				var stationname:String = node.name.toString();
				
				Registry.register("stationcode", stationcode);
				Registry.register("stationname", stationname);
				Application.application.openModel("站点平面图", false);
			}
		}
	}
}


public function createCheckBox(volt:String):CheckBox{
	var chk:CheckBox = new CheckBox();
	chk.label = volt+"kV";
	chk.selected = true;
	chk.addEventListener(Event.CHANGE,checkbox_changeHandler);
	chk.setStyle("fontSize",12);
	chk.setStyle("fontStyle",'italic');
	return chk;
}

private function itemAddSelectHanlder(event:ContextMenuEvent):void{
//	ocableResource(this.parent.parent.parent).controlBar.addShurtCut();
}

private function itemDelSelectHandler(event:ContextMenuEvent):void{
//	ocableResource(this.parent.parent.parent).controlBar.delShurtCut();
}
//属性
private function item1ItemSelectHandler(event:ContextMenuEvent):void{
	if(network.selectionModel.count > 0){
		if ((Element)(network.selectionModel.selection.getItemAt(0)) is Node)
		{
			var node:Node = (Element)(network.selectionModel.selection.getItemAt(0)) as Node;
//			Alert.show("==="+node.getClient("isTnode").toString());
			if(node.getClient("isTnode").toString()=='1'){
				var item:Object = network.selectionModel.selection.getItemAt(0);
				var s:String;
				var stationcode:String = item.getClient("stationcode").substr(0,item.getClient("stationcode").length);
				var property:ShowProperty = new ShowProperty();
				property.paraValue = stationcode;
				property.tablename = "STATION";
				property.key = "STATIONCODE";
				property.title = "属性";
				PopUpManager.addPopUp(property, this, true);
				PopUpManager.centerPopUp(property);
			}else if(node.getClient("isTnode").toString()=='0'){
				//					var item:Object = network.selectionModel.selection.getItemAt(0);
				//					var tnodeproperty:TnodeProperty = new TnodeProperty();
				//					var tnodecode:String = item.getClient("stationcode").substr(1,item.getClient("stationcode").length);
				//					var tnodename:String = item.name.toString();
				//					Registry.register("tnodecode",tnodecode);
				//					Registry.register("tnodename",tnodename);
				//					PopUpManager.addPopUp(tnodeproperty,this,true);
				//					PopUpManager.centerPopUp(tnodeproperty);
				//					tnodeproperty.title="查看属性";
				
				var item:Object = network.selectionModel.selection.getItemAt(0);
				var s:String;
				var stationcode:String = item.getClient("stationcode").substr(0,item.getClient("stationcode").length);
				var property:ShowProperty = new ShowProperty();
				property.paraValue = stationcode;
				property.tablename = "VIEW_TNODE_PROPERTY";
				property.key = "TNODECODE";
				property.title = "T接点属性";
				PopUpManager.addPopUp(property, this, true);
				PopUpManager.centerPopUp(property);
			}
			
		}else if((Element)(network.selectionModel.selection.getItemAt(0)) is ShapeLink)
		{
			var ocableCode:String = (network.selectionModel.selection.getItemAt(0) as ShapeLink).id.toString();
			var OcableSectionrt:RemoteObject=new RemoteObject("ocableResources");
			var ocablesection:OcableSection= new OcableSection();
			ocablesection.start="0";
			ocablesection.end="1";
			ocablesection.sectioncode=ocableCode;
			OcableSectionrt.addEventListener(ResultEvent.RESULT,resultOcableSectionHandler);
			OcableSectionrt.endpoint = ModelLocator.END_POINT;
			OcableSectionrt.showBusyCursor=true;
			OcableSectionrt.getOcableSectionByOcableResources(ocablesection);
			state ="修改";
		}
	}
}

private var state:String = "修改";
private var allInOne:OcableSectionTitleAllInOne;
private function resultOcableSectionHandler(event:ResultEvent):void{
	var	result:ResultModel = event.result as ResultModel;	
	//有问题 mawj
	if(result!=null){
		var property:ShowProperty = new ShowProperty();
		if(state=="修改"){
			property.title = "光缆修改";
			property.paraValue = (result.orderList[0] as OcableSection).sectioncode;
		}else if(state == "添加"){
			property.title = "光缆添加";
			property.paraValue = (result.orderList[0] as OcableSection).sectioncode;
			property.addEventListener("closeOcableSectionTitle",closeOcableSectionTitleHandler);
		}
		
		property.tablename = "VIEW_EN_OCABLE_PROPERTY";
		property.key = "OCABLECODE";
		
		PopUpManager.addPopUp(property, this, true);
		PopUpManager.centerPopUp(property);		
		property.addEventListener("RefreshDataGrid",refreshOcableSection);
		property.addEventListener("savePropertyComplete",function (event:Event):void{
			PopUpManager.removePopUp(property);
			
			
			//更新标准命名
			var ocableCode:String = (property.getElementById("OCABLECODE",property.propertyList) as mx.controls.TextInput).text ;
			if(null != ocableCode && "" != ocableCode){
				var rmObj:RemoteObject = new RemoteObject("resNodeDwr");
				rmObj.endpoint = ModelLocator.END_POINT;
				rmObj.showBusyCursor = false;
				rmObj.updateOcableNameStd(ocableCode);
				rmObj.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
					property.dispatchEvent(new Event("RefreshDataGrid"));
				});
			}
			
			});
		
		property.addEventListener("initFinished",function (event:Event):void{
			
//			(property.getElementById("STATION_A_NAME",property.propertyList) as mx.controls.TextInput).addEventListener(MouseEvent.CLICK,function(event:Object):void{
//				var stations:enStationTree=new enStationTree();
//				stations.page_parent=property;
//				stations.textId="STATION_A_NAME";
//				PopUpManager.addPopUp(stations, property, true);
//				PopUpManager.centerPopUp(stations);  
//			});
//			(property.getElementById("STATION_Z_NAME",property.propertyList) as mx.controls.TextInput).addEventListener(MouseEvent.CLICK,function(event:Object):void{
//				var stations:enStationTree=new enStationTree();
//				stations.page_parent=property;
//				stations.textId="STATION_Z_NAME";
//				PopUpManager.addPopUp(stations, property, true);
//				PopUpManager.centerPopUp(stations);  
//			});
			//查找所属地区
			var stationAcode:String = (property.getElementById("STATION_A",property.propertyList) as mx.controls.TextInput).text ;
			var rmObj:RemoteObject = new RemoteObject("resNodeDwr");
			rmObj.endpoint = ModelLocator.END_POINT;
			rmObj.showBusyCursor = false;
			rmObj.getAProvinceByStaioncode(stationAcode);
			rmObj.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
				(property.getElementById("A_AREA",property.propertyList) as mx.controls.TextInput).text = event.result.toString();
			});
			var stationZcode:String = (property.getElementById("STATION_Z",property.propertyList) as mx.controls.TextInput).text ;
			var rm:RemoteObject = new RemoteObject("resNodeDwr");
			rm.endpoint = ModelLocator.END_POINT;
			rm.showBusyCursor = false;
			rm.getAProvinceByStaioncode(stationZcode);
			rm.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
				(property.getElementById("Z_AREA",property.propertyList) as mx.controls.TextInput).text = event.result.toString();
			});
			
			(property.getElementById("STATION_A_NAME",property.propertyList) as mx.controls.TextInput).enabled = false;
			(property.getElementById("STATION_Z_NAME",property.propertyList) as mx.controls.TextInput).enabled = false;
			(property.getElementById("UPDATEPERSON",property.propertyList) as mx.controls.TextInput).enabled = false;
			(property.getElementById("UPDATEPERSON",property.propertyList) as mx.controls.TextInput).text = parentApplication.curUserName;
			//			(property.getElementById("UPDATEDATE",property.propertyList) as mx.controls.TextInput).enabled = false;
			(property.getElementById("UPDATEDATE",property.propertyList) as mx.controls.TextInput).text = getNowTime();
		});
	}else if(2==1){//废弃 不用 
		allInOne = new OcableSectionTitleAllInOne();		
		//	Alert.show(event.result.toString());
		//allInOne.title=result.orderList[0].ocablesectionname == null?"光缆属性":result.orderList[0].ocablesectionname + "-属性";
		allInOne.title="属性";
		if(result!=null){
			allInOne.ocableSectionData = result.orderList[0];
		}
		if((network.selectionModel.selection.getItemAt(0) as ShapeLink).fromNode.getClient("isTnode")=="0"){
			allInOne.ocableSectionData.a_pointtype="T接";
			allInOne.ocableSectionData.a_pointname=(network.selectionModel.selection.getItemAt(0) as ShapeLink).fromNode.getClient("name");
			//		Alert.show(allInOne.ocableSectionData.a_pointname);
		}
		allInOne.state = "修改";	
		
		MyPopupManager.addPopUp(allInOne,true);
		allInOne.btn.label ="保存";
		allInOne.addEventListener("RefreshDataGrid",refreshOcableSection);
		if(state == "添加"){
			allInOne.addEventListener("closeOcableSectionTitle",closeOcableSectionTitleHandler);
		}
	}
	
	
}

public function closeOcableSectionTitleHandler(event:Event):void{
	//isXmlListInit = false;
	if(state == "添加"){
		remoteObject("ocableResources",true,null).deleteOcableSectionInfo((network.selectionModel.selection.getItemAt(0) as ShapeLink).getClient
			
			("ocablecode").toString());
	}
	elementBox.removeSelection();
}


private function refreshOcableSection(event:Event){
	//Alert.show("加载数据");
	//elementBox.removeSelection();
	getStationInfo();
	//network.invalidateElementVisibility();
	//network.callLater2(network.invalidateElementVisibility);
}
private function getComboDataHandler(event:Event):void{
	
}

private function getStationPropertiesHandler(event:ResultEvent):void{
	var station:StationModule = event.result as StationModule;
	var vsp:viewStationProperty = new viewStationProperty();
	//给弹出页面赋值
	PopUpManager.addPopUp(vsp,this,true);
	PopUpManager.centerPopUp(vsp);
	vsp.PROVINCE.text = station.PROVINCE;
	vsp.STATIONNAME.text = station.STATIONNAME;
	vsp.X_STATIONTYPE.text = station.X_STATIONTYPE;
	vsp.DETAILADDR.text = station.DETAILADDR;
	vsp.ADDRESS.text = station.ADDRESS;
	vsp.TEL.text = station.TEL;
	vsp.FOUNDDATE.text = station.FOUNDDATE;
	vsp.CONDITION.text = station.CONDITION;
	vsp.LNG.text = station.LNG;
	vsp.LAT.text = station.LAT;
	vsp.PROPERTY.text = station.PROPERTY;
	vsp.REMARK.text = station.REMARK;
	vsp.title = "查看属性";
	
	
}

private function getOcablePropertiesHandler(event:ResultEvent):void{
	var ocablesection:OcableSectionModule = event.result as OcableSectionModule;
	var vop:viewOcableProperty = new viewOcableProperty();
	//				//给弹出页面赋值
	//				PopUpManager.addPopUp(vop,this,true);
	//				PopUpManager.centerPopUp(vop);
	//				vop.OCABLESECTIONNAME.text = ocablesection.OCABLESECTIONNAME;
	//				vop.ANAME.text = ocablesection.ANAME
	//				vop.ZNAME.text = ocablesection.ZNAME;
	//				vop.A_POINTTYPE.text = ocablesection.A_POINTTYPE;
	//				vop.Z_POINTTYPE.text = ocablesection.Z_POINTTYPE;
	//				vop.FIBERCOUNT.text = ocablesection.FIBERCOUNT;
	//				vop.OCCUPYFIBERCOUNT.text = ocablesection.OCCUPYFIBERCOUNT;
	//				vop.OCABLEMODEL.text = ocablesection.OCABLEMODEL;
	//				vop.LENGTH.text = ocablesection.LENGTH;
	//				vop.LAYMODE.text = ocablesection.LAYMODE;
	//				vop.LAYMODELEN.text = ocablesection.LAYMODELEN;
	//				vop.RUN_UNIT.text = ocablesection.RUN_UNIT;
	//				vop.ASSET_UNIT.text = ocablesection.ASSET_UNIT;
	//				vop.FUNCTION_UNIT.text = ocablesection.FUNCTION_UNIT;
	//				vop.X_MODEL.text = ocablesection.X_MODEL;
	//				vop.ONE_NAME.text = ocablesection.ONE_NAME;
	//				vop.VOLTLEVEL.text = ocablesection.VOLTLEVEL;
	//				vop.REMARK.text = ocablesection.REMARK;
	//				vop.title = "查看光缆段属性";
	
}

//光缆业务信息
private function item2ItemSelectHandler(event:ContextMenuEvent):void{
	if(network.selectionModel.count > 0){
		if((Element)(network.selectionModel.selection.getItemAt(0)) is Link)
		{
			var ocableCode:String = (network.selectionModel.selection.getItemAt(0) as ShapeLink).id.toString();
			var vfd:viewFiberDetails = new viewFiberDetails();
			vfd.sectioncode = ocableCode;
			vfd.title = "光缆业务信息";
			MyPopupManager.addPopUp(vfd);
			vfd.y=0;
		}
	}
	
}

//光纤详细信息
private function item21ItemSelectHandler(event:ContextMenuEvent):void{
	if(network.selectionModel.count > 0){
		if((Element)(network.selectionModel.selection.getItemAt(0)) is Link)
		{
			var ocableCode:String = (network.selectionModel.selection.getItemAt(0) as ShapeLink).id.toString();
			var vfd:viewFiberDetailsInfo = new viewFiberDetailsInfo();
			vfd.sectioncode = ocableCode;
			vfd.title = "光纤详细信息";
			MyPopupManager.addPopUp(vfd);
			vfd.y=0;
		}
	}
	
}
//wuwenqi 20110909
//弹出纤芯方式制作窗口
private function itemFiberdisHandler(event:ContextMenuEvent):void{
	var eles:ICollection = new Collection();
	var linkic:ICollection = new Collection();
	var ic:ICollection = network.selectionModel.selection;
	if(ic != null){
		for(var k:int=0; k<ic.count; k++){
			if(ic.getItemAt(k) is Link){
				linkic.addItem(ic.getItemAt(k));
			}
		}
		for(var i:int=0; i<linkic.count; i++){
			var mlink:Link = linkic.getItemAt(i);
			for(var j:int=0; j<linkic.count; j++){
				var link:Link = linkic.getItemAt(j);
				if(link.id != mlink.id && (mlink.fromNode == link.fromNode || mlink.fromNode == link.toNode || mlink.toNode == link.fromNode || 
					
					mlink.toNode == link.toNode)){
					eles.addItem(mlink);
					break;
				}
			}
		}
		if(eles.count == 0 && linkic.count != 0){
			eles.addItem(linkic.getItemAt(0));
		}
	}
	if(linkic.count != 0){
		var tw:BuildFiberDispatch = new BuildFiberDispatch();
		tw.eles = eles;
		PopUpManager.addPopUp(tw, this, true);
	}else{
		Alert.show("请选择至少一条光缆！", "提示");
	}
}
//敷设方式
private function item3ItemSelectHandler(event:ContextMenuEvent):void{
	
} 

//杆塔/接头盒
private function item20ItemSelectHandler(event:ContextMenuEvent):void{
	if(network.selectionModel.count>0)
	{
		var item:Object = network.selectionModel.selection.getItemAt(0);
		if (item is Link)
		{	
			var link:ShapeLink = network.selectionModel.selection.getItemAt(0) as ShapeLink;
			Registry.register("sectioncode",link.getClient("ocablecode").toString());
			Registry.register("startNode",link.fromNode.id.toString().substr(0,20));
			Registry.register("startNodeName",link.fromNode.followers.getItemAt(0).name);
			Registry.register("startNodeType",link.fromNode.getClient("isTnode"));
			Registry.register("endNode",link.toNode.id.toString().substr(0,20));
			Registry.register("endNodeName",link.toNode.followers.getItemAt(0).name);
			Registry.register("endNodeType",link.toNode.getClient("isTnode"));
			parentApplication.openModel("杆塔/接头盒",true);
		}
	}
}

//相关资料
private function item22ItemSelectHandler(event:ContextMenuEvent):void{
	if(network.selectionModel.count>0)
	{		
		if((Element)(network.selectionModel.selection.getItemAt(0)) is Link)
		{  
			var ocableCode:String = (network.selectionModel.selection.getItemAt(0) as ShapeLink).id.toString();
			var ocableFileDir:String = "/relatedinfo/"+ocableCode+"/";
			var remoteObj:RemoteObject = new RemoteObject("myDocument");
			remoteObj.endpoint = ModelLocator.END_POINT;
			remoteObj.showBusyCursor = true;
			remoteObj.addFolder(ocableFileDir);
			remoteObj.addEventListener(ResultEvent.RESULT,function(evnet:ResultEvent):void{
				var relatedInfo:RelatedInfo = new RelatedInfo();
				relatedInfo.title = "相关资料";
				relatedInfo.filepath = ocableFileDir;
				relatedInfo.filelocation = ocableCode;
				MyPopupManager.addPopUp(relatedInfo,true);
			});
		}
	}
}

//显示无光缆局站
private function item23ItemSelectHandler(event:ContextMenuEvent):void{
	stationvisible = true;
	network.invalidateElementVisibility();
	network.callLater2(network.invalidateElementVisibility);
}

private function item24ItemSelectHandler(event:ContextMenuEvent):void{
	stationvisible = false;
	network.invalidateElementVisibility();
	network.callLater2(network.invalidateElementVisibility);
	
	
}
/* //隐藏无光缆局站
private function hideStationFunction():void{
for(var n:int=0 ; n<network.elementBox.toDatas().count ; n++){
var ielement:IElement=network.elementBox.toDatas().getItemAt(n);
if(ielement is Node){
var node:Node=ielement as Node;
if(Node(elementBox.datas.getItemAt(n)).links < 1 
&& Node(elementBox.datas.getItemAt(n)).getClient('nodeorlabel') == 'node'){
network.elementBox.selectionModel.selection.addItem(node);	
network.elementBox.selectionModel.selection.addItem(node.followers.getItemAt(0));

}
}
}
network.elementBox.removeSelection();
}
*/

//混合敷设方式分界信息
private function item4ItemSelectHandler(event:ContextMenuEvent):void{
	if(network.selectionModel.count>0)
	{
		var item:Object = network.selectionModel.selection.getItemAt(0);
		if (item is Link)
		{	
			var link:ShapeLink = network.selectionModel.selection.getItemAt(0) as ShapeLink;
			Registry.register("sectioncode",link.getClient("ocablecode").toString());
			Registry.register("startNode",link.fromNode.id.toString().substr(0,20));
			Registry.register("startNodeName",link.fromNode.followers.getItemAt(0).name);
			Registry.register("startNodeType",link.fromNode.getClient("isTnode"));
			Registry.register("endNode",link.toNode.id.toString().substr(0,20));
			Registry.register("endNodeName",link.toNode.followers.getItemAt(0).name);
			Registry.register("endNodeType",link.fromNode.getClient("isTnode"));
			Registry.register("length",link.getClient("ocablelength"));
			parentApplication.openModel("混合敷设方式分界信息",true);
		}
	}
}

//光缆承载业务 <!--为改问题，改的，被屏的地方是原来的东西.byxujiao2012-7-23-->
private function item5ItemSelectHandler(event:ContextMenuEvent):void{
	
	if(network.selectionModel.count>0)
	{
		var item:Object = network.selectionModel.selection.getItemAt(0);
		if (item is Link)
		{	
			var link:ShapeLink = network.selectionModel.selection.getItemAt(0) as ShapeLink;
			var winCarryBusiness:CarryBusiness = new CarryBusiness();
			winCarryBusiness.flag=true;
			winCarryBusiness.sectioncode = link.id.toString()
			//parentApplication.openModel("光缆承载业务",true,winCarryBusiness);
			winCarryBusiness.title = "光缆承载业务";
			MyPopupManager.addPopUp(winCarryBusiness);
			winCarryBusiness.y=0;
		}
	}
	
}

//机房平面图
private function item6ItemSelectHandler(event:ContextMenuEvent):void{
	if(network.selectionModel.count>0)
	{
		var item:Object = network.selectionModel.selection.getItemAt(0);
		if (item is Node)
		{
			var node:Node = item as Node;
			var stationcode:String = node.getClient("stationcode").substr(0,item.getClient("stationcode").length);
			Registry.register("stationcode",stationcode);
			Application.application.openModel("机房平面图", false);
		}
	}
}

//光缆截面图  <!--为改问题，改的，被屏的地方是原来的东西.byxujiao2012-7-23-->
private function item7ItemSelectHandler(event:ContextMenuEvent):void{
	if(network.selectionModel.count>0)
	{
		var item:Object = network.selectionModel.selection.getItemAt(0);
		if (item is Link)
		{	
			var link:ShapeLink = network.selectionModel.selection.getItemAt(0) as ShapeLink;
			var winOcableDetails:ocableDetails = new ocableDetails();
			var fiberName:String=link.getClient("fiberName");
			var voltageGrade:String=link.getClient("voltageGrade");
			var lineLength:int=link.getClient("lineLength");
			var fiberCount:int=link.getClient("fiberCount");
			var maintainUnit:String=link.getClient("maintainUnit");
			winOcableDetails.apointcode =link.fromNode.getClient('stationcode').toString().substr(0,20);
			winOcableDetails.zpointcode = link.toNode.getClient('stationcode').toString().substr(0,20);
			//winOcableDetails.ocableresourceview=this;
			winOcableDetails.ocablecode = link.id.toString();//.id.toString().substr(1,20);
			//parentApplication.openModel("光缆截面图",true,winOcableDetails);
			winOcableDetails.title = "光缆截面图";
			MyPopupManager.addPopUp(winOcableDetails);
			winOcableDetails.y=0;
		}
	}
}

public function test():void{
	var link:ShapeLink = network.selectionModel.selection.getItemAt(0) as ShapeLink;
	var fiberName:String=link.getClient("fiberName");
	var voltageGrade:String=link.getClient("voltageGrade");
	var lineLength:int=link.getClient("lineLength");
	var fiberCount:int=link.getClient("fiberCount");
	var maintainUnit:String=link.getClient("maintainUnit");
	link.toolTip = "线路名称:"+fiberName+"\n"+"电压等级:"+voltageGrade+"\n"+"线路长度:"+lineLength+"\n"+"纤芯数目:"+(fiberCount+1)+"\n"+"维护单位:"+maintainUnit+"\n"+"备    注:";
	link.setClient("fiberCount",fiberCount+1);
}
//站内连接关系
private function item8ItemSelectHandler(event:ContextMenuEvent):void{
	if(network.selectionModel.count>0){
		var item:Object = network.selectionModel.selection.getItemAt(0);
		if (item is Node)
		{
			var node:Node = item as Node;
			var stationcode:String = node.getClient("stationcode").substr(0,item.getClient("stationcode").length);
			var stationname:String = node.name.toString();
			
			//				var ro:RemoteObject = new RemoteObject("wireConfiguration");
			//				ro.showBusyCursor = true;
			//				ro.endpoint = ModelLocator.END_POINT;
			//				ro.addEventListener(ResultEvent.RESULT,getTempHandler);
			//				ro.getTempTree(stationcode,stationname);
			
			var rewc:RelationWireConfig =  new RelationWireConfig();	
			rewc.stationCode = stationcode;
			rewc.isModel = true;
			parentApplication.openModel("配线关系",true,rewc);
		}
	}
}

private function getTempHandler(event:ResultEvent):void{
	var temp:String = event.result.toString();
	Registry.register("portcode",temp.split(",")[2]);	
	Registry.register("porttype",temp.split(",")[1]);
	Registry.register("dmcode",temp.split(",")[0]);
	var rewc:RelationWireConfig =  new RelationWireConfig();	
	//		rewc.moduleName = this.moduleName ;
	parentApplication.openModel("配线关系",true,rewc);
}

//T接点连接关系
private function item9ItemSelectHandler(event:ContextMenuEvent):void{
	if(network.selectionModel.count>0){
		var item:Object = network.selectionModel.selection.getItemAt(0);
		if (item is Node)
		{
			var node:Node = item as Node;
			var tnodecode:String = node.getClient("stationcode").substr(0,item.getClient("stationcode").length);
			var tnodename:String = node.name.toString();
			Registry.register("tnodecode",tnodecode);
			Registry.register("tnodename",tnodename);
			Application.application.openModel("T接点连接关系", false);
		}
	}
}

//显示光芯数
private function item10ItemSelectHandler(event:ContextMenuEvent):void{
	showfibercount = true;
	for(var i:int = 0;i<elementBox.datas.count;i++){
		if(elementBox.datas.getItemAt(i) is ShapeLink){
			var link:ShapeLink = elementBox.datas.getItemAt(i);
			if(link.getClient("ocabledata").FIBERCOUNT != null && link.getClient("ocabledata").LENGTH != null){
				link.name = link.getClient("ocabledata").FIBERCOUNT.toString()+"芯/"+link.getClient("ocabledata").LENGTH.toString()+'km';
				//Alert.show(link.getClient("ocabledata").fibercount);
			}
		}
	}
}


//隐藏光芯数
private function item12ItemSelectHandler(event:ContextMenuEvent):void{
	showfibercount = false;
	for(var i:int = 0;i<elementBox.datas.count;i++){
		if(elementBox.datas.getItemAt(i) is ShapeLink){
			var link:ShapeLink = elementBox.datas.getItemAt(i);
			link.name = "";
		}
	}
	
	
}


//(N-1)分析
private function item11ItemSelectHandler(event:ContextMenuEvent):void{
	
	if(network.selectionModel.count>0)
	{
		var item:Object = network.selectionModel.selection.getItemAt(0);
		if (item is Link)
		{	
			var link:ShapeLink = network.selectionModel.selection.getItemAt(0) as ShapeLink;
			var winBusinessInfluenced:businessInfluenced = new businessInfluenced();
			var ocableCode:String = (network.selectionModel.selection.getItemAt(0) as ShapeLink).id.toString();
			winBusinessInfluenced.setParameters(ocableCode, "ocable");
			parentApplication.openModel("\"N-1\"分析",true,winBusinessInfluenced);
		}
	}
	
}

private function resultOcableHandler(event:ResultEvent):void{
	acStation.removeAll();
	var ac:ArrayCollection = ArrayCollection(event.result);
	for (var i:int = 0;i < ac.length; i++) {
		acStation.addItem(new ObjectProxy(ac[i]));
	} 
	for each(var item:Object in acStation){
		
		if(elementBox.getElementByID(item.a_point) == null 
			&& item.a_point_name !=null 
			&& item.a_point_volt != null 
			&& item.z_point_volt != null){
			elementBox.add(createNode(
				item.a_point,
				item.a_point_name,
				new Point(item.a_point_x,item.a_point_y),
				new Point(item.a_point_label_x,item.a_point_label_y),
				ocableModelLocator.getStationType(item.a_pointtype,item.a_point_class),
				item.a_pointtype,
				item.a_point_type_name,
				item.a_point_volt,
				item.a_point_provincename,
				item));
			//				
			//				elementBox.add(createLabel(
			//					item.a_point,
			//					item.a_point_name,
			//					new Point(item.a_point_label_x,item.a_point_label_y),
			//					ocableModelLocator.getStationType(item.a_pointtype,item.a_point_class),
			//					item.a_pointtype,
			//					item.a_point_type_name,
			//					item.a_point_volt,
			//					item.a_point_provincename,
			//					item));
			
		}
		
		if(elementBox.getElementByID(item.z_point) == null 
			&& item.z_point_name !=null 
			&& item.a_point_volt != null   
			&& item.z_point_volt != null ){
			elementBox.add(createNode(
				item.z_point,
				item.z_point_name,
				new Point(item.z_point_x,item.z_point_y),
				new Point(item.z_point_label_x,item.z_point_label_y),
				ocableModelLocator.getStationType(item.z_pointtype,item.z_point_class),
				item.z_pointtype,
				item.z_point_type_name,
				item.z_point_volt,
				item.z_point_provincename,
				item));
			
			//				elementBox.add(createLabel(
			//					item.z_point,
			//					item.z_point_name,
			//					
			//					new Point(item.z_point_label_x,item.z_point_label_y),
			//					ocableModelLocator.getStationType(item.z_pointtype,item.z_point_class),
			//					item.z_pointtype,
			//					item.z_point_type_name,
			//					item.z_point_volt,
			//					item.z_point_provincename,
			//					item));
			
		}
	}
	
	//获取拐点信息
	remoteObject("ocableResources",true,resultOcableGeoHandler).getOcablesectiongeo(showOcableVolt,province);
}


private function resultOcableByProvinceHandler(event:ResultEvent):void{
	acStation.removeAll();
	var ac:ArrayCollection = ArrayCollection(event.result);
	for (var i:int = 0;i < ac.length; i++) {
		acStation.addItem(new ObjectProxy(ac[i]));
	} 
	for each(var item:Object in acStation){
		
		if(elementBox.getElementByID(item.a_point) == null 
			&& item.a_point_name !=null 
			&& item.a_point_volt != null 
			&& item.z_point_volt != null){
			elementBox.add(createNode(
				item.a_point,
				item.a_point_name,
				new Point(item.a_point_x,item.a_point_y),
				new Point(item.a_point_label_x,item.a_point_label_y),
				ocableModelLocator.getStationType(item.a_pointtype,item.a_point_class),
				item.a_pointtype,
				item.a_point_type_name,
				item.a_point_volt,
				item.a_point_provincename,
				item));
			
		}
		
		if(elementBox.getElementByID(item.z_point) == null 
			&& item.z_point_name !=null 
			&& item.a_point_volt != null   
			&& item.z_point_volt != null ){
			elementBox.add(createNode(
				item.z_point,
				item.z_point_name,
				new Point(item.z_point_x,item.z_point_y),
				new Point(item.z_point_label_x,item.z_point_label_y),
				ocableModelLocator.getStationType(item.z_pointtype,item.z_point_class),
				item.z_pointtype,
				item.z_point_type_name,
				item.z_point_volt,
				item.z_point_provincename,
				item));
			
		}
	}
	
	//获取拐点信息
	remoteObject("ocableResources",true,resultOcableGeoHandler).getOcablesectiongeo(showOcableVolt,province);
	
}

//创建node
private function createNode(id:String,name:String,
							location:Point,
							labellocation:Point,
							image:String,
							type:String,
							stationType:String,
							volt:String,
							provincename,
							data:Object):Node{
	var node:Node =new Node(id);
	//node.layerID = "stationLayer";
	node.setClient('stationdata',data);
	node.setClient('stationcode',id);
	node.setClient('isTnode',type);
	node.setClient('nodeorlabel','node');
	node.toolTip = "局站名称:"+name+"\n"+"所属地区:"+provincename;
	node.name = " ";
	node.image = image;
	var nodesizewidth:Number;
	var nodesizeheight:Number;
	var fountSize:Number;
	if(province == '主干'){
		nodesizewidth = 16;
		nodesizeheight = 16;
		fountSize= 22;
	}else{
		nodesizewidth = 30;
		nodesizeheight = 30;
		fountSize= 20;
		//Alert.show(province);
	}
	node.width = nodesizewidth;
	node.height = nodesizeheight;
	node.setStyle(Styles.LABEL_SIZE,fountSize);
	node.location = location;
	
	var f:Follower = new Follower("label"+id);
	//f.layerID = "stationLayer";
	//f.setClient('stationdata',data);
	f.setClient('stationcode',"label"+id);
	f.setClient('isTnode','3');
	f.setClient('nodeorlabel','label');
	f.host = node;
	f.name = name;
	f.image = "";
	f.width = 0;
	f.height = 0;
	f.setStyle(Styles.LABEL_SIZE,fountSize);
	f.location =labellocation;
	//f.location =new Point(node.x,node.y+25);
	elementBox.add(f);
	
	
	
	return node;
}

private function createLabel(id:String,name:String,
							 location:Point,
							 image:String,
							 type:String,
							 stationType:String,
							 volt:String,
							 provincename,
							 data:Object):Follower{
	var follower:Follower =new Follower('label'+id);
	follower.layerID = "stationLayer";
	follower.setClient('stationdata',data);
	follower.setClient('stationcode',id);
	follower.setClient('isTnode',type);
	follower.toolTip = "局站名称:"+name+"\n"+"所属地区:"+provincename;
	follower.name = name;
	follower.image = '';
	follower.width = 0;
	follower.height = 0;
	follower.setStyle(Styles.LABEL_SIZE,12);
	follower.location =location;
	return follower
	
}


//创建link方法
private function createLink(item:Object):Link{
	var from:Node = elementBox.getElementByID(item.a_point) as Node;
	var to:Node = elementBox.getElementByID(item.z_point) as Node;
	var link:ShapeLink = new ShapeLink(item.sectioncode,from,to);
	link.setClient("ocabledata",item);
	link.setClient("ocablecode",item.sectioncode);
	link.setStyle(Styles.LABEL_SIZE,10);
	link.setStyle(Styles.LINK_COLOR, item.seccolor.toString());
	link.setStyle(Styles.LINK_WIDTH, 2);
	link.setStyle(Styles.OUTER_WIDTH, 2);
	link.toolTip = "线路名称:"+item.ocablename+"\n"+"线路长度:"+item.length+"\n"+"纤芯数目:"+item.fibercount+"\n"+"维护单位:"+item.function_unit+"\n"+"备   注:";
	link.setStyle(Styles.LINK_BUNDLE_GAP,4);
	return link;
}

//添加拐点
private function item13ItemSelectHandler(event:ContextMenuEvent):void{
	if(network.selectionModel.count>0)
	{
		var item:Object = network.selectionModel.selection.getItemAt(0);
		if (item is Link)
		{	//Alert.show('添加拐点');
			var link:ShapeLink = network.selectionModel.selection.getItemAt(0) as ShapeLink;
			var p:Point = new Point(event.mouseTarget.mouseX / network.zoom, event.mouseTarget.mouseY / network.zoom);
			positionX = network.contentMouseX / network.zoom;
			positionY =network.contentMouseY / network.zoom;
			link.addPoint(new Point(positionX,positionY));
			network.setEditInteractionHandlers();
		}
	}
}

//删除光缆段
private function item14ItemSelectHandler(event:ContextMenuEvent):void{
	if(network.selectionModel.count>0)
	{
		var item:Object = network.selectionModel.selection.getItemAt(0);
		if (item is ShapeLink)
		{	
			Alert.show("您确认要删除吗？","温馨提示",Alert.YES|Alert.NO,this,alertdDelOcableHandler);
		}
	}
}

private function alertdDelOcableHandler(event:CloseEvent):void{
	if(event.detail == Alert.YES){
		remoteObject("ocableResources",true,deleteOcableSectionInfoHandler).deleteOcableSectionInfo((network.selectionModel.selection.getItemAt(0) as 
			
			ShapeLink).id.toString());
		elementBox.removeSelection();
	}
}


private function deleteOcableSectionInfoHandler(event:ResultEvent):void{
	Alert.show("光缆删除成功");
}

//删除站点
private function item15ItemSelectHandler(event:ContextMenuEvent):void{
	if(network.selectionModel.count>0)
	{
		var item:Object = network.selectionModel.selection.getItemAt(0);
		if (item is Node)
		{	
			Alert.show("您确认要删除吗？","温馨提示",Alert.YES|Alert.NO,this,alertDeleteStationHandler);
		}
	}
}

private function alertDeleteStationHandler(event:CloseEvent):void{
	if(event.detail == Alert.YES){
		//删除局站
		remoteObject("ocableResources",true,deleteStationHandler).deleteStation((network.selectionModel.selection.getItemAt(0) as Node).getClient('stationcode').toString().substr(0,(network.selectionModel.selection.getItemAt(0) as Node).getClient('stationcode').toString().length));
		//删除坐标
		remoteObject("ocableResources",true,deleteStationHandler).deleteCoordinatesByOcableSection((network.selectionModel.selection.getItemAt(0) as Node).getClient('stationcode').toString().substr(0,(network.selectionModel.selection.getItemAt(0) as Node).getClient('stationcode').toString().length),this.province,"光缆路由图");
		if((network.selectionModel.selection.getItemAt(0) as Node).getClient("isTnode")=="0"){
			//删除T节点
			remoteObject("ocableResources",true,null).deleteTnode((network.selectionModel.selection.getItemAt(0) as Node).getClient('stationcode').toString().substr(0,(network.selectionModel.selection.getItemAt(0) as Node).getClient('stationcode').toString().length));
		}
	}
}

private function deleteStationHandler(event:ResultEvent):void{
	var node:Object = network.selectionModel.selection.getItemAt(0);
	if (node is Node){
		elementBox.remove((node.followers.getItemAt(0) as Follower));
	}
	elementBox.removeSelection();
	//	elementBox.removeSelection();
	Alert.show("删除成功");
}

//删除拐点
private function item16ItemSelectHandler(event:ContextMenuEvent):void{
	if(network.selectionModel.count>0){
		var item:Object = network.selectionModel.selection.getItemAt(0);
		if (item is Link)
		{	
			var link:ShapeLink = network.selectionModel.selection.getItemAt(0) as ShapeLink;
			if(link.points.count<1){
				Alert.show("此处没有拐点");
			}else{
				link.points.removeItemAt(link.points.count - 1);
			}
			
			network.setEditInteractionHandlers();
		}
	}
}

protected function network_mouseDownHandler(event:MouseEvent):void
{
	
	// TODO Auto-generated method stub
	
	if(network.selectionModel.count > 0){
		//netWorkSelectItem = network.selectionModel.selection.getItemAt(0);
		
		if(network.selectionModel.selection.getItemAt(0) is ShapeLink){
			//(network.selectionModel.selection.getItemAt(0) as ShapeLink).setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
			//(network.selectionModel.selection.getItemAt(0) as ShapeLink).setStyle(Styles.SELECT_WIDTH,'5');
			network.selectionModel.appendSelection(network.selectionModel.selection.getItemAt(0));
			//(network.selectionModel.selection.getItemAt(0) as ShapeLink).setStyle(Styles.SELECT_COLOR, 0x00FF00);
		}
		
		
		if(network.selectionModel.selection.getItemAt(0) is Node ){
			//nodeorlabel
			//Alert.show((network.selectionModel.selection.getItemAt(0) as Node).getClient('nodeorlabel').toString());
			//Alert.show((network.selectionModel.selection.getItemAt(0) as Node).links.count.toString());
			if((network.selectionModel.selection.getItemAt(0) as Node).getClient('nodeorlabel') == 'node'){
				//Node(network.selectionModel.selection.getItemAt(0)).setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
				//Node(network.selectionModel.selection.getItemAt(0)).setStyle(Styles.SELECT_WIDTH,'3');
				network.selectionModel.appendSelection(network.selectionModel.selection.getItemAt(0));
			}
			
			if((network.selectionModel.selection.getItemAt(0) as Node).getClient('nodeorlabel') == 'label'){
				
				var nodeid:String=Node(network.selectionModel.selection.getItemAt(0)).getClient("stationcode").toString();
				var node:Node = elementBox.getElementByID(nodeid) as Node;
				node.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
				node.setStyle(Styles.SELECT_WIDTH,'3');
				network.selectionModel.appendSelection(network.selectionModel.selection.getItemAt(0));
				//Follower(network.selectionModel.selection.getItemAt(0)).setStyle(Styles.LABEL_FILL_COLOR,'#888888');
				//Follower(network.selectionModel.selection.getItemAt(0)).setStyle(Styles.LABEL_COLOR,'#888888');
			}
			
		}
		
		//			if(netWorkSelectItem is Node && (netWorkSelectItem as Node).id != "showPointer"){
		//				Node(netWorkSelectItem).setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
		//				Node(netWorkSelectItem).setStyle(Styles.SELECT_WIDTH,'2');
		//			}
		
	}
	
	
}

private function network_mouseDoubleClickHandler(event:MouseEvent):void{
	if(network.selectionModel.count>0)
	{
		var item:Object = network.selectionModel.selection.getItemAt(0);
		if (item is Node)
		{
			var node:Node = item as Node;
			var stationcode:String = node.getClient("stationcode").substr(0,item.getClient("stationcode").length);
			Registry.register("stationcode",stationcode);
			Application.application.openModel("机房平面图", false);
		}
		
		if (item is Link)
		{	
			
			var item:Object = network.selectionModel.selection.getItemAt(0);
			if (item is Link)
			{	
				var link:ShapeLink = network.selectionModel.selection.getItemAt(0) as ShapeLink;
				Registry.register("sectioncode",link.getClient("ocablecode").toString());
				Registry.register("startNode",link.fromNode.id.toString().substr(0,20));
				Registry.register("startNodeName",link.fromNode.followers.getItemAt(0).name);
				Registry.register("startNodeType",link.fromNode.getClient("isTnode"));
				Registry.register("endNode",link.toNode.id.toString().substr(0,20));
				Registry.register("endNodeName",link.toNode.followers.getItemAt(0).name);
				Registry.register("endNodeType",link.toNode.getClient("isTnode"));
				parentApplication.openModel("杆塔/接头盒",true);
			}
			//				var link:ShapeLink = network.selectionModel.selection.getItemAt(0) as ShapeLink;
			//				var winOcableDetails:ocableDetails = new ocableDetails();
			//				winOcableDetails.apointcode =link.fromNode.getClient('stationcode').toString().substr(1,20);
			//				winOcableDetails.zpointcode = link.toNode.getClient('stationcode').toString().substr(1,20);
			//				winOcableDetails.ocablecode = link.id.toString();//.id.toString().substr(1,20);
			//				parentApplication.openModel("光缆截面图",true,winOcableDetails);
		}
	}
}

/**
 * @netWork的所有事件。
 * */
private function netWorkFunction(e:InteractionEvent):void{
	if(network.selectionModel.selection.count >0){
		if(network.selectionModel.selection.getItemAt(0) is Node){
			if(e.kind == "removeElement"){
				//Alert.show("您确认要删除吗？","温馨提示",Alert.YES|Alert.NO,this,alertdDelStationHandler);
				
			}
			
			if(e.kind =="liveMoveEnd"){//liveMoveEnd  移动站点结束
				if((network.selectionModel.selection.getItemAt(0) as Node).getClient("isTnode").toString()== '1'){
					//if(province == '中心'){
					var node:Node = network.selectionModel.selection.getItemAt(0) as Node;
					var model:MapCoordinate = new MapCoordinate();
					model.stationcode = node.getClient('stationcode').toString();//.substr(1, node.getClient('stationcode').toString().length);
					model.node_x = (node.x-xoffset).toString();
					model.node_y = (node.y-yoffset).toString();
					model.province = this.setoperDesc;// this.province;
					model.istnode = "1";
					remoteObject("ocableResources",false,null).updateStationLocation(model);
					
					
					var follower:Follower = node.followers.getItemAt(0) as Follower;
					var stationModel:MapCoordinate = new MapCoordinate();
					stationModel.stationcode = follower.getClient('stationcode').toString();
					stationModel.label_x = (follower.x-xoffset).toString();
					stationModel.label_y = (follower.y-yoffset).toString();
					stationModel.province =  this.setoperDesc;// this.province;
					stationModel.istnode = "3";
					remoteObject("ocableResources",false,null).updateStationLabelLocation(stationModel);
					
					
				}else if((network.selectionModel.selection.getItemAt(0) as Node).getClient("isTnode").toString() == '0'){
					
					
					var node:Node = network.selectionModel.selection.getItemAt(0) as Node;
					var model:MapCoordinate = new MapCoordinate();
					model.stationcode = node.getClient('stationcode').toString();//.substr(1, node.getClient('stationcode').toString().length);
					model.node_x = (node.x-xoffset).toString();
					model.node_y = (node.y-yoffset).toString();
					model.province =  this.setoperDesc;// this.province;
					model.istnode = "0";
					remoteObject("ocableResources",false,null).updateStationLocation(model);
					
					var follower:Follower = node.followers.getItemAt(0) as Follower;
					var stationModel:MapCoordinate = new MapCoordinate();
					stationModel.stationcode = follower.getClient('stationcode').toString();
					stationModel.label_x = (follower.x-xoffset).toString();
					stationModel.label_y = (follower.y-yoffset).toString();
					stationModel.province =  this.setoperDesc;// this.province;
					stationModel.istnode = "3";
					remoteObject("ocableResources",false,null).updateStationLabelLocation(stationModel);
					
				}else if((network.selectionModel.selection.getItemAt(0) as Follower).getClient("isTnode").toString() == '3'){
					
					var follower:Follower = network.selectionModel.selection.getItemAt(0) as Follower;
					var stationModel:MapCoordinate = new MapCoordinate();
					stationModel.stationcode = follower.getClient('stationcode').toString();
					stationModel.label_x = (follower.x-xoffset).toString();
					stationModel.label_y = (follower.y-yoffset).toString();
					stationModel.province = this.setoperDesc;// this.province;
					stationModel.istnode = "3";
					remoteObject("ocableResources",false,null).updateStationLabelLocation(stationModel);
					//						if(province == "中心"){
					//							remoteObject("ocableResources",false,null).updateStationLabelLocation(stationModel);
					//						}else{
					//							remoteObject("ocableResources",false,null).updateStationCityLabelLocation(stationModel);
					//						}
					
				}
				
				
			}
			
		}
		
		
		if(e.kind == "createElement"){//createElement  连接结束
			
			var acOcableSectionGeo:ArrayCollection = new ArrayCollection();
			var ocableSectionModel:OcableSectionInfoModel = new OcableSectionInfoModel();
			
			
			var link:ShapeLink = network.selectionModel.selection.getItemAt(0) as ShapeLink;
			link.setClient('volt','无');
			link.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
			link.setStyle(Styles.SELECT_WIDTH,'1');
			//(network.selectionModel.selection.getItemAt(0) as ShapeLink).setStyle(Styles.LINK_COLOR,uint(listLink.selectedItem.linkColor));
			for(var i:int=0;i<link.points.count;i++){
				var itemGeo:OcableSectionGeoModel = new OcableSectionGeoModel();
				itemGeo.GEOX=(link.points.getItemAt(i).x - xoffset).toString();
				itemGeo.GEOY=(link.points.getItemAt(i).y - yoffset).toString();
				itemGeo.SERIAL=(i+1).toString();
				itemGeo.STATUS = province;
				acOcableSectionGeo.addItem(itemGeo);
			}
			//Alert.show("wancheng");
			//var link:ShapeLink =  network.selectionModel.selection.getItemAt(0) as ShapeLink;
			ocableSectionModel.A_POINT=(link.fromNode as Node).getClient("stationcode").substr(0,(link.fromNode as Node).getClient
				
				("stationcode").length);
			ocableSectionModel.Z_POINT=(link.toNode as Node).getClient("stationcode").substr(0,(link.toNode as Node).getClient
				
				("stationcode").length);
			ocableSectionModel.A_POINTTYPE=(link.fromNode as Node).getClient("isTnode");
			ocableSectionModel.Z_POINTTYPE=(link.toNode as Node).getClient("isTnode");
			remoteObject("ocableResources",true,resultOcableSectionInfoHandler).addOcableSection(ocableSectionModel,acOcableSectionGeo);
			
		}
	}
	

	
}

//获取link的拐点信息
private function getOcableSectionGeo(link:ShapeLink):ArrayCollection{
	var ac:ArrayCollection = new ArrayCollection();
	//Alert.show(link.getClient('ocablecode').toString());
	for(var i:int=0;i<link.points.count;i++){
		var itemGeo:OcableSectionGeoModel = new OcableSectionGeoModel();
		itemGeo.SECTIONCODE = link.getClient('ocablecode').toString();
		itemGeo.GEOX=(link.points.getItemAt(i).x - xoffset).toString();
		itemGeo.GEOY=(link.points.getItemAt(i).y - yoffset).toString();
		itemGeo.SERIAL=(i+1).toString();
		itemGeo.STATUS = province;
		ac.addItem(itemGeo);
	}
	//Alert.show(ac.length.toString());
	return ac;
}


//查询站后执行的方法
protected function stationsearch1_ApplyFilterHandler(event:ApplyFilter):void
{
	// TODO Auto-generated method stub
	network.setDefaultInteractionHandlers();
	if(event.searchType == "station"){
		var stationcode:String=event.value.code;
		//var isNode:String=event.value.type;
		var node:Node=elementBox.getElementByID(stationcode) as Node;
		if(node!=null)
		{
			clearPointer();
			network.selectionModel.clearSelection();
			network.selectionModel.appendSelection(node);
			//				node.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
			//				node.setStyle(Styles.SELECT_WIDTH,'2');
			//				network.centerByLogicalPoint(node.centerLocation.x,node.centerLocation.y);
			addPointer(node);
		}
	}else if(event.searchType == "ocable"){
		var ocablecode:String=event.value.code;
		var link:ShapeLink=elementBox.getElementByID(ocablecode) as ShapeLink;
		if(link!=null)
		{
			//				link.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
			//				link.setStyle(Styles.SELECT_WIDTH,'1');
			//				link.setStyle(Styles.SELECT_COLOR,"0xF6FD00");
			network.selectionModel.clearSelection();
			network.selectionModel.appendSelection(link);
			
			//network.centerByLogicalPoint(node.centerLocation.x,node.centerLocation.y);
		}
	}else if(event.searchType == 'onename'){
		var ocablecode:String=event.value.code;
		var link:ShapeLink=elementBox.getElementByID(ocablecode) as ShapeLink;
		if(link!=null)
		{
			network.selectionModel.clearSelection();
			network.selectionModel.appendSelection(link);
			link.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
			link.setStyle(Styles.SELECT_WIDTH,'2');
			//network.centerByLogicalPoint(node.centerLocation.x,node.centerLocation.y);
		}
	}
}

[Bindable] private var show:Follower;
//设置搜索指针
private function addPointer(node:Node):void{
	var item:Node=elementBox.getElementByID('showPointer'+node.id) as Node;
	if(item == null){
		show = new Follower('showPointer'+node.id);
		show.setClient('isTnode',"3");
		show.image = "showPointer";
		show.width=70;
		show.layerID="pointerLayer";
		show.location = new Point(node.x-22,node.y-75);
		show.host = node;
		elementBox.add(show);
	}
}
//清空指针
private function clearPointer():void{
	if(elementBox){
		elementBox.selectionModel.selection.clear();
		elementBox.selectionModel.selection.addItem(show);
		elementBox.removeSelection();
	}
}

//添加局站
private function addStationHandler():void{
	var centerLocation:Point=new Point(120,40);
	dragDropStation = new Node();
	dragDropStation.centerLocation=centerLocation;
	elementBox.add(dragDropStation);
	var model:ocableStationModel = new ocableStationModel();
	model.x_stationtype = '1';
	model.globalx = dragDropStation.x.toString();
	model.globaly = dragDropStation.y.toString();
	model.province = this.province;
	remoteObject("ocableResources",true,resultaddOcableSectionStationHandler).addOcableSectionStation(model);
}


private function resultaddOcableSectionStationHandler(event:ResultEvent):void{
	//var ac:ArrayCollection = new ArrayCollection(event.result);
	dragDropStation.setClient('stationcode',event.result.toString());
	var s:String;
	var stationcode:String = event.result.toString();
	property = new ShowProperty();
	property.paraValue = stationcode;
	property.tablename = "STATION";
	property.key = "STATIONCODE";
	property.title = "添加局站";
	PopUpManager.addPopUp(property, this, true);
	PopUpManager.centerPopUp(property);
	property.addEventListener("savePropertyComplete",savePropertyCompleteHandler);
	property.addEventListener("closeProperty",closePropertyHandler);
}

private function savePropertyCompleteHandler(evnet:Event):void{
	PopUpManager.removePopUp(property);
	dragDropStation.name = (property.getElementById("STATIONNAME",property.arrayList) as TextInput).text;
	dragDropStation.setClient("isTnode",((property.getElementById("X_STATIONTYPE",property.arrayList) as ComboBox).text == "光缆转接点"?"2":"1"));
	var type:String=(property.getElementById("VOLT",property.arrayList) as ComboBox).text+(property.getElementById("X_STATIONTYPE",property.arrayList) as 
		
		ComboBox).text;
	dragDropStation.image = ocableModelLocator.getStationType(dragDropStation.getClient("isTnode"),type);
	//dragDropStation.toolTip = dragDropStation.name;
	dragDropStation.width = 16;
	dragDropStation.height = 16;
	dragDropStation.setStyle(Styles.LABEL_SIZE,12);
}

private function closePropertyHandler(event:Event):void{
	remoteObject("ocableResources",true,null).deleteStation(dragDropStation.getClient('stationcode').toString().substr(0,dragDropStation.getClient
		
		('stationcode').toString().length));
	elementBox.remove(dragDropStation);
	//elementBox.removeSelection();
}

//添加光缆
private function addOcableSectionHandler():void{
	network.setCreateShapeLinkInteractionHandlers();
}

private function resultOcableSectionInfoHandler(event:ResultEvent):void{
//	Alert.show('添加光缆返回函数成功');
	(network.selectionModel.selection.getItemAt(0) as ShapeLink).setClient("ocablecode",event.result.toString());
	//Alert.show('添加光缆返回函数--赋值ID成功');
	var ocableCode:String = (network.selectionModel.selection.getItemAt(0) as ShapeLink).getClient("ocablecode");
	var OcableSectionrt:RemoteObject=new RemoteObject("ocableResources");
	var ocablesection:OcableSection= new OcableSection();
	ocablesection.start="0";
	ocablesection.end="1";
	ocablesection.sectioncode=ocableCode;
	
	OcableSectionrt.addEventListener(ResultEvent.RESULT,resultOcableSectionHandler);
	OcableSectionrt.endpoint = ModelLocator.END_POINT;
	OcableSectionrt.showBusyCursor=true;
	OcableSectionrt.getOcableSectionByOcableResources(ocablesection);
	state = "添加";
	
	//Alert.show((network.selectionModel.selection.getItemAt(0) as ShapeLink).getClient("ocableCode").toString());
}
//checkbox选择电压等级
protected function checkbox_changeHandler(event:Event):void
{
	//acOcableGeo.removeAll();
	//clearResourceInfo();
	//ac.removeAll();
	/*var value:String="";
	for each(var item:* in toolbar.getChildren()){
	if(item is CheckBox){
	if(item.selected){
	value+="'"+item.label.toString()+"',";
	}
	}
	}
	if(value != ""){
	value += value+"'1000kV'，";
	showOcableVolt = value.substr(0,value.length-1);
	getStationInfo();
	}else{
	//clearResourceInfo();
	}*/
	
	//*************************************************************
	var value:String="";
	showOcableVolt='';
	for each(var item:* in toolbar.getChildren()){
		if(item is CheckBox){
			if(item.selected){
				value+=item.label.toString()+",";
			}
		}
	}
	showOcableVolt = value.substr(0,value.length-1);
	network.invalidateElementVisibility();
	network.callLater2(network.invalidateElementVisibility);
}

//清除图标
protected function clearResourceInfo():void{
	
	
	for(var i:int = 0;i<elementBox.toDatas().count;i++){
		var ielement:IElement=elementBox.toDatas().getItemAt(i);
		if(ielement is Node){
			if((elementBox.datas.getItemAt(i) as Node).id != this.province && 
				(elementBox.datas.getItemAt(i) as Node).id != 'direction' &&
				(elementBox.datas.getItemAt(i) as Node).id != 'ocable' &&
				ielement.id != 'followerLayer' && 
				ielement.id != 'linkLayer' && 
				ielement.id != 'nodeLayer')
				elementBox.selectionModel.selection.addItem(elementBox.datas.getItemAt(i));
		}
		
		if(elementBox.datas.getItemAt(i) is Link){
			elementBox.selectionModel.selection.addItem(elementBox.datas.getItemAt(i));
		}
	}
	elementBox.removeSelection();
}

private function saveOcableSectionGeoHandler(event:ResultEvent):void{
	Alert.show("保存成功","温馨提示!");
}

private function deviceiconFun(item:Object):* //为传输设备树的结点添加图标
{
	
	
	if (item.@type == "station"){
		var type:String=item.@stationtype;
//		var type:String=item.@stationvolt+item.@stationtype;
		if(type=="变一变电站"){
			ocableModelLocator.station_110kV;
		}else if(type=="变二变电站"){
			ocableModelLocator.station_200kV;
		}else if(type=="电厂"){
			ocableModelLocator.station_500kV;
		}else if(type=="行政单位"){
			ocableModelLocator.station_1000kV;
		}else if(type=="用户站"){
			ocableModelLocator.power_110kV;
		}else {
			return ocableModelLocator.other;
		}
		
	}else{
		return  DemoImages.file;
	}
	
}




private function onDragEnter(event:DragEvent):void {
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
/**
 *  拖拽添加 
 */
private function onGridDragDrop(event:DragEvent):void
{	
	if(acc.selectedIndex==0)//局站
	{
		//显示无光缆局站 否则添加的站点无法显示
		stationvisible = true;
		network.invalidateElementVisibility();
		network.callLater2(network.invalidateElementVisibility);
		//Alert.show(treeProvince.selectedItem.@code.toString());
		//	Alert.show(elementBox.getElementByID(treeProvince.selectedItem.@code.toString()).toString());
		var nodewidth:Number = 16;
		var nodeheight:Number = 16;
		var fsize:Number=14;
		
		if(this.province == '广东'){
			nodewidth = 24;
			nodeheight = 24;
			fsize= 14;
		}else{
			nodewidth = 22;
			nodeheight = 22;
			fsize= 15;
			//Alert.show(province);
		}
		var mynode:Node = new Node(treeProvince.selectedItem.@code.toString());
		mynode.setClient('stationcode',treeProvince.selectedItem.@code.toString());
		mynode.setClient('isTnode','1');
		mynode.setClient('nodeorlabel','node');
		mynode.toolTip = "局站名称:"+treeProvince.selectedItem.@label.toString();
		mynode.width=nodewidth;
		mynode.height = nodeheight;
		//	mynode.image=ocableModelLocator.getStationType('1',treeProvince.selectedItem.@stationvolt.toString()+treeProvince.selectedItem.@stationtype.toString());
		mynode.image=ocableModelLocator.getStationType('1',treeProvince.selectedItem.@stationtype.toString());
		mynode.name = " ";
		mynode.location =network.getLogicalPoint(event as MouseEvent);
		elementBox.add(mynode);
		
		
		var f:Follower = new Follower();
		f.host = mynode;
		f.name = treeProvince.selectedItem.@label.toString();
		f.image = "";
		f.width = 0;
		f.height = 0;
		f.setStyle(Styles.LABEL_SIZE,fontsize);
		var followerPoint:Point=new Point(mynode.x,mynode.y+30);
		f.location =followerPoint;
		//f.location =new Point(node.x,node.y+25);
		elementBox.add(f);
		
		var stationcode:String=treeProvince.selectedItem.@code.toString();
		var province:String="XZ01";// 单位设置为;
		var modelname:String="光缆路由图";
		var nodex:String=(mynode.x-xoffset).toString();
		var nodey:String=mynode.y.toString();
		var labelx:String=(f.x-xoffset).toString();
		var labely:String=f.y.toString();
		
		//Alert.show(network.getLogicalPoint(event as MouseEvent).x.toString()+"--"+network.getLogicalPoint(event as MouseEvent).y.toString()+"--"+nodex+"--"+nodey);
		remoteObject("ocableResources",true,null).addCoordinatesByOcableSection(stationcode,province,modelname,nodex,nodey,labelx,labely);
	}else if(acc.selectedIndex==1){//站点模版
		var matchStr:String="items";
		var ds:DragSource=event.dragSource;
		var sIndex:String=ds.dataForFormat(matchStr)[0].@sindex;	
		var sCode:String=ds.dataForFormat(matchStr)[0].@scode;	
		var logicPoint:Point=network.getLogicalPoint(event as MouseEvent);
		var station_x:String=logicPoint.x.toString();
		var station_y:String=logicPoint.y.toString();
		
		var property:ShowProperty = new ShowProperty();
		property.title = "添加";
		property.paraValue = null;
		property.tablename = "STATION";
		property.key = "STATIONCODE";
		PopUpManager.addPopUp(property, this, true);
		PopUpManager.centerPopUp(property);		
		property.addEventListener("savePropertyComplete",function (event:Event):void{
			PopUpManager.removePopUp(property);
			
			//更新标准命名
			var stationCode:String = property.insertKey;
			if(null != stationCode && "" != stationCode){
				var rmObj:RemoteObject = new RemoteObject("resNodeDwr");
				rmObj.endpoint = ModelLocator.END_POINT;
				rmObj.showBusyCursor = false;
				rmObj.updateStationNameStd(stationCode);
				rmObj.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
//					RefreshStation(event);
					
				});
			//在图中生成站点
			var stationName:String=(property.getElementById("STATIONNAME",property.propertyList) as mx.controls.TextInput).text;
			var stationType:String=(property.getElementById("X_STATIONTYPE",property.propertyList) as mx.controls.ComboBox).selectedItem.@label;
			stationvisible = true;
			network.invalidateElementVisibility();
			network.callLater2(network.invalidateElementVisibility);
			var nodewidth:Number = 24;
			var nodeheight:Number = 24;
			var fsize:Number=14;
			var mynode:Node = new Node(stationCode);
			mynode.setClient('stationcode',stationCode);
			mynode.setClient('isTnode','1');
			mynode.setClient('nodeorlabel','node');
			mynode.toolTip = "局站名称:"+stationName;
			mynode.width=nodewidth;
			mynode.height = nodeheight;
			mynode.image=ocableModelLocator.getStationType('1',stationType);
			mynode.name = " ";
			mynode.location =logicPoint;
			elementBox.add(mynode);
			
			
			var f:Follower = new Follower();
			f.host = mynode;
			f.name = stationName;
			f.image = "";
			f.width = 0;
			f.height = 0;
			f.setStyle(Styles.LABEL_SIZE,fontsize);
			var followerPoint:Point=new Point(mynode.x,mynode.y+30);
			f.location =followerPoint;
			elementBox.add(f);
			
			var stationcode:String=stationCode;
			var province:String=this.setoperDesc;// province;
			var modelname:String="光缆路由图";
			var nodex:String=(mynode.x-xoffset).toString();
			var nodey:String=mynode.y.toString();
			var labelx:String=(f.x-xoffset).toString();
			var labely:String=f.y.toString();
			
			remoteObject("ocableResources",true,null).addCoordinatesByOcableSection(stationCode,province==null?"XZ01":province,modelname,nodex,nodey,labelx,labely);
			}
			
		});	
		property.addEventListener("initFinished",function (event:Event):void{
			(property.getElementById("UPDATEPERSON",property.propertyList) as mx.controls.TextInput).enabled = false;
			(property.getElementById("UPDATEPERSON",property.propertyList) as mx.controls.TextInput).text = parentApplication.curUserName;
			(property.getElementById("X_STATIONTYPE",property.propertyList) as mx.controls.ComboBox).selectedIndex=int(sIndex)-1;
			(property.getElementById("X_STATIONTYPE",property.propertyList) as mx.controls.ComboBox).enabled=false;
			(property.getElementById("LAT",property.propertyList) as mx.controls.TextInput).text =station_x;
			(property.getElementById("LNG",property.propertyList) as mx.controls.TextInput).text =station_y;
			(property.getElementById("UPDATEDATE",property.propertyList) as mx.controls.TextInput).text = getNowTime();
			
		});
	}
	
	
	
}

private function addCoordinatesByOcableSectionHandler():void{
	
}

private function onDragExit(event:DragEvent):void
{
	var dropTarget:Network=Network(event.currentTarget);
	
}

private function getData(evt:DragEvent):Object{
	var data:Object = evt.dragSource.dataForFormat( "items" );
	if( data is Array ) {
		data = data[0];
	}
	return data;
}

private function getElement(e:MouseEvent,elementClass:Class):IElement{
	var element:IElement=network.getElementByMouseEvent(e, false, 2);
	if(element is elementClass){
		return element;
	}
	return null;
}

//图例
private function initLegend():void{
	var legendBox:ElementBox=legendmap.elementBox;
	var datas:ICollection=legendBox.toDatas();
	for(var i:int = 0;i<datas.count;i++)
	{
		legendBox.selectionModel.selection.addItem(datas.getItemAt(i));
	}
	legendBox.removeSelection();
	legendBox.layerBox.removeByID("legLayer");
	var lArrays:ArrayCollection=new ArrayCollection();
	var rtobj:RemoteObject=new RemoteObject("ocableResources");
	rtobj.endpoint=ModelLocator.END_POINT;
	rtobj.showBusyCursor=true;
	rtobj.getLegend("ocable","ZY0811");//fiber,curSysVendor  "ocable","ZY0811"
	//rtobj.addEventListener(FaultEvent.FAULT,faultHandler);
	rtobj.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void
	{
		try{
			var pro_arr:ArrayCollection= event.result as ArrayCollection;
			for(var i:int=0;i<pro_arr.length;i++)
			{
				lArrays.addItem(new ObjectProxy(pro_arr[i]));
			}
			var legLayer:Layer =new Layer("legLayer");
			legendBox.layerBox.add(legLayer,0);
			legLayer.movable = false;	
			
			var tmpX:int=15;
			var tmpY:int=5;
			var iCol:int=0;
			for (var j:int=0;j<lArrays.length;j++)
			{
				if(lArrays[j].LCOLTYPE==1)
				{
					var node:Node=new Node();
					node.layerID="legLayer";
					node.name=lArrays[j].LNAME;
					node.setStyle(Styles.LABEL_POSITION,Consts.POSITION_RIGHT);
					node.setStyle(Styles.LABEL_XOFFSET,70);
					node.setStyle(Styles.LABEL_SIZE,12);
					if (lArrays[j].LNAME=="V-Node设备"||lArrays[j].LNAME=="C-Node设备")
					{
						node.setSize(20,10);
					}
					else
					{
						node.setSize(15,15);//(20,20)
					}						
					tmpY=iCol*20+6;
					node.setLocation(tmpX+10,tmpY);
					node.image=lArrays[j].LPATH;	
					legendBox.add(node);
					iCol++;
				}
				else
				{
					tmpY=iCol*20+6;
					var node1:Node=new Node();
					node1.setLocation(tmpX-2,tmpY)
					node1.setSize(12,12);
					node1.image="";
					legendBox.add(node1);
					var node2:Node=new Node();
					node2.setLocation(tmpX+30-2,tmpY);
					node2.setSize(12,12);
					node2.image="";
					legendBox.add(node2);
					var link:Link=new Link(node1,node2);
					link.name=lArrays[j].LNAME;
					link.setStyle(Styles.LINK_COLOR,lArrays[j].LCOLOR);
					link.setStyle(Styles.LABEL_POSITION,Consts.POSITION_RIGHT);
					link.setStyle(Styles.LABEL_XOFFSET,70);
					link.setStyle(Styles.LABEL_SIZE,12);
					link.setStyle(Styles.LINK_WIDTH,1.5);
					legendBox.add(link);
					if (lArrays[j].ISDOUBLE==1)
					{
						var node12:Node=new Node();
						node12.setLocation(tmpX-2,tmpY+4)
						node12.setSize(12,12);
						node12.image="";
						legendBox.add(node12);
						var node22:Node=new Node();
						node22.setLocation(tmpX+30-2,tmpY+4);
						node22.setSize(12,12);
						node22.image="";
						legendBox.add(node22);
						var link11:Link=new Link(node12,node22);
						link11.setStyle(Styles.LINK_COLOR,lArrays[j].LCOLOR);
						link11.setStyle(Styles.LINK_WIDTH,1.5);
						legendBox.add(link11);
					}									
					iCol++;
				}
			}
		}catch(e:Error)
		{
			Alert.show(e.message,"initLegend");
		}
		legendPanel.height=tmpY+70;
	})
}

import mx.events.StateChangeEvent;

protected function vb_currentStateChangeHandler(event:StateChangeEvent):void
{
	// TODO Auto-generated method stub
	if(event.newState == "show"){
		
	}else if(event.newState == "hide"){
		clearPointer();
	}
	
}
/**
 * 获取当前时间
 */
protected function getNowTime():String{
	var dateFormatter:DateFormatter = new DateFormatter();
	dateFormatter.formatString = "YYYY-MM-DD JJ:NN:SS";
	var nowDate:String= dateFormatter.format(new Date());
	return nowDate;
}

/**
 *点击右侧功能按钮的处理函数 
 * @param event
 * 
 */
private function vb_selectedItemEventHandler(event:selectedItemEvent):void
{
	
	//处理设备面板 的初始化
	if(event.selectedIndex==1&&xmlDeviceModel.children().length() == 0)
	{
		var roDeviceModel:RemoteObject=new RemoteObject("ocableResources");
		roDeviceModel.endpoint=ModelLocator.END_POINT;
		roDeviceModel.showBusyCursor=true;
		roDeviceModel.addEventListener(ResultEvent.RESULT, getDeviceModelHandler);
		parentApplication.faultEventHandler(roDeviceModel);
		roDeviceModel.getStationModel();//从后台请求设备模板列表数据
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