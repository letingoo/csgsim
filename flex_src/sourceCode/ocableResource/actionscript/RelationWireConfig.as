import com.degrafa.core.utils.ColorKeys;

import common.actionscript.CustomInteractionHandler;
import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.actionscript.Registry;

import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.net.navigateToURL;
import flash.ui.ContextMenuItem;

import flexlib.controls.textClasses.StringBoundaries;
import flexlib.events.SuperTabEvent;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.XMLListCollection;
import mx.controls.Alert;
import mx.controls.CheckBox;
import mx.controls.ComboBox;
import mx.controls.Tree;
import mx.core.Application;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.events.ItemClickEvent;
import mx.events.ListEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;
import mx.utils.StringUtil;

import sourceCode.autoGrid.view.ShowProperty;
import sourceCode.ocableResource.views.FiberRoutInfo;
import sourceCode.ocableResource.model.OcableRouteData;
import sourceCode.ocableResource.views.OcableRoute;
import sourceCode.ocableResource.model.DMModel;
import sourceCode.ocableResource.model.DdfDdmModule;
import sourceCode.ocableResource.model.EquipmentModule;
import sourceCode.ocableResource.model.FiberLinesModel;
import sourceCode.ocableResource.model.FiberModule;
import sourceCode.ocableResource.model.MatrixModel;
import sourceCode.ocableResource.model.ODMMODULE;
import sourceCode.ocableResource.model.OcableGraphicModule;
import sourceCode.ocableResource.model.VolumeModel;
import sourceCode.ocableResource.model.wireConfigurationGraphicsDataModule;
import sourceCode.ocableResource.model.DDFModel;

import twaver.*;
import twaver.Link;
import twaver.Node;
import twaver.QuickFinder;
import twaver.Styles;
import twaver.XMLSerializer;
import twaver.network.Network;
import twaver.network.interaction.DefaultInteractionHandler;
import twaver.network.interaction.InteractionEvent;
import twaver.network.interaction.MoveInteractionHandler;

[Bindable]   
public var folderList:XMLList= new XMLList();  //左侧树
[Bindable]
private  var folderCollection:XMLList;        //左侧树集合

private var portcode:String;
private var porttype:String;
private var equipshelfcode:String;		//机架编号
private var dmcode:String;				//模块编号
public var stationCode:String;		//局站编号
public var moduleName:String;			//模块名称
public var equipLogicportid:String;	//端口ID
public var portcounts:String;
public var Graphdata:wireConfigurationGraphicsDataModule;  //所有资源集合
public var ODFLinesData:ArrayCollection;					//ODF关系集合(不包括与光纤的关系)
public var FiberLinesData:ArrayCollection;					//光纤关系集合
public var DDFLinesData:ArrayCollection;					//DDF关系集合


private var portCount:int;
private var cm:ContextMenu;
private var elementBox:ElementBox;
private var layerBox:LayerBox;
private var layer1:Layer = new Layer("module");     		//画模块或设备或光缆段的图层
private var layer2:Layer = new Layer("cablePort");		
private var layer3:Layer = new Layer("equipmentPort"); //画端口的图层
private var layer4:Layer = new Layer("Port");			   
private var layer5:Layer = new Layer("link");			   //画连接关系的图层

private var tempPoint:Point;          //临时用于存放模块位置


private var isVolume:Boolean; 		  //是否是批量操作
private var markType:String = "";   //标记关系类型 fiber或matrix
private var markValue:String = "";  //标记要跟新的数据是ODF的连接关系还是DDF的连接关系
public var _tempLinkID:Object;      //临时用于存放拖动连线的ID

private var EquipPanel:Follower;
private var equipment:Follower;
private var equippackportdata:ArrayCollection;                   //存放查询的设备都数据
private var acAllPorts:ArrayCollection = new ArrayCollection(); //存放所有的端口数据


private var fibermoduledata:ArrayCollection;  //存放查询出来的光缆信息
private var fiberdata:ArrayCollection;		   //存放查询出来的光纤信息
private var FiberPanel:Follower;
private var _rotationType:String;            //光缆段朝向

private var odfcount:int=0;   		//记录当前ODF数量
private var ddfcount:int=0;       //记录当前DDF数量
private var equipcount:int=0;     //记录当前设备数量
private var ocablecount:int=0;    //记录当前光缆段的数量

private var delodfArray:Array = new Array();    //记录删除ODF的位置
private var delddfArray:Array = new Array();    //记录删除DDF的位置
private var delequipArray:Array = new Array();  //记录删除设备的位置
private var delocableArray:Array = new Array(); //记录删除光缆的位置

public var isModel:Boolean = false;

public function get dataBox():DataBox{
	return elementBox;
}

public function initApp():void  { 
	portcode=Registry.lookup("portcode");
	porttype=Registry.lookup("porttype");
	dmcode=Registry.lookup("dmcode");
	elementBox=network.elementBox;
	layerBox=elementBox.layerBox;
	layerBox.add(layer1);
	layerBox.add(layer2);
	layerBox.add(layer3);
	layerBox.add(layer4);
	layerBox.add(layer5);
	layer1.editable=false;
	layer3.editable=false;
	layer4.editable = false;
	layer5.editable = false;
	
	layer1.movable = true;
	layer3.movable = false;
	layer4.movable = true;
	layer5.movable = true;
	
	var rtobj:RemoteObject = new RemoteObject("wireConfiguration");
	rtobj.endpoint = ModelLocator.END_POINT;				
	if(!isModel){
		rtobj.getWireConfigTree(portcode,porttype);	//获取Tree的数据源
		this.init(this.dmcode,this.porttype,this.portcode);
	}else{
		isModel = false;
		rtobj.getWireConfigTreeByStation(stationCode);	//获取Tree的数据源
		this.ODFLinesData = new ArrayCollection();
		this.FiberLinesData = new ArrayCollection();
		this.DDFLinesData = new ArrayCollection();
	}
	rtobj.addEventListener(ResultEvent.RESULT,generateWireTree);
	
	network.contextMenu = new ContextMenu();
	network.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,contextMenuEvent);
	network.contextMenu.hideBuiltInItems();
	
	SerializationSettings.registerGlobalClient("porttype",Consts.TYPE_STRING);
	SerializationSettings.registerGlobalClient("a_point",Consts.TYPE_STRING);
	SerializationSettings.registerGlobalClient("z_point",Consts.TYPE_STRING);
	
	DemoUtils.initNetworkToolbarForSysGraph(toolbar, network);
//	DemoUtils.initNetworkToolbarForWireConfig(toolbar, network);
	network.setDefaultInteractionHandlers();
	DemoUtils.createButtonBar(toolbar, [DemoUtils.createButtonInfo("展开/收缩面板", DemoImages.toggle, function():void
	{
		var visible:Boolean=!leftpanel.visible;
		leftpanel.visible=visible;
		leftpanel.includeInLayout=visible;
	})], false, false, -1, -1);
		var comboBox:ComboBox=DemoUtils.addInteractionComboBox(toolbar, network, null, -1);
		if(Application.application.isEdit){
			DemoUtils.createButtonBar(toolbar, [DemoUtils.createButtonInfo("导出Excel", DemoImages.excel, exportExcel)], false, false, -1, -1);
			DemoUtils.createButtonBar(toolbar, [DemoUtils.createButtonInfo("连接", DemoImages.createLink, function():void
			{
				createLinkInteraction(Link,Consts.LINK_TYPE_PARALLEL,createLinkCallBack);
			})], false, false, -1, -1);
			var checkBox:CheckBox = new CheckBox();
			checkBox.label = "批量操作";
			toolbar.addChild(checkBox);
			checkBox.addEventListener(Event.CHANGE,checkChangHandler);
		}
		addEventListener("RefreshLinesData",refreshLinesDataHandler);
		}
		
		//导出连接关系
		private function exportExcel():void{
			var ac:ArrayCollection = new ArrayCollection();
			for(var i:int = 0; i < this.ODFLinesData.length; i++){
				var m:MatrixModel = new MatrixModel();
				m.PORTNAME1 = this.ODFLinesData[i].PORTNAME1;
				m.PORTNAME2 = this.ODFLinesData[i].PORTNAME2;
				m.PORTTYPENAME1 = this.ODFLinesData[i].PORTTYPENAME1;
				m.PORTTYPENAME2 = this.ODFLinesData[i].PORTTYPENAME2;
				ac.addItem(m);
			}
			for(var j:int = 0; j < this.DDFLinesData.length; j++){
				var m1:MatrixModel = new MatrixModel();
				m1.PORTNAME1 = this.DDFLinesData[j].PORTNAME1;
				m1.PORTNAME2 = this.DDFLinesData[j].PORTNAME2;
				m1.PORTTYPENAME1 = this.DDFLinesData[j].PORTTYPENAME1;
				m1.PORTTYPENAME2 = this.DDFLinesData[j].PORTTYPENAME2;
				ac.addItem(m1);
			}
			if(ac.length > 0){
				var labels:String = "Matrix配线关系列表";
				var titles:Array = new Array("A端端口", "Z端端口", "A端端口类型","Z端端口类型");
				var remote:RemoteObject = new RemoteObject("wireConfiguration");
				remote.endpoint = ModelLocator.END_POINT;
				remote.showBusyCursor = true;
				remote.exportMatrixEXCEL(labels,titles,ac);
				remote.addEventListener(ResultEvent.RESULT,downloadFile);
			}
			var ac1:ArrayCollection = new ArrayCollection();
			for(var t:int = 0; t < this.FiberLinesData.length; t++){
				var fiber:FiberLinesModel = new FiberLinesModel();
				fiber.name_std = this.FiberLinesData[t].name_std==null?"":this.FiberLinesData[t].name_std;
				fiber.aendeqport = this.FiberLinesData[t].aendeqport==null?"":this.FiberLinesData[t].aendeqport;
				fiber.zendeqport = this.FiberLinesData[t].zendeqport==null?"":this.FiberLinesData[t].zendeqport;
				fiber.aodfportname = this.FiberLinesData[t].aendodfport==null?"":this.FiberLinesData[t].aodfportname;
				fiber.zodfportname = this.FiberLinesData[t].zendodfport==null?"":this.FiberLinesData[t].zodfportname;
				ac1.addItem(fiber);
			}
			if(ac1.length > 0 ){
				var labels1:String = "光纤关系列表";
				var titles1:Array = new Array("光纤名称", "A端设备端口", "Z端设备端口","A端ODF端口","Z端ODF端口");
				var ro:RemoteObject = new RemoteObject("wireConfiguration");
				ro.endpoint = ModelLocator.END_POINT;
				ro.showBusyCursor = true;
				ro.exportFiberEXCEL(labels1,titles1,ac1);
				ro.addEventListener(ResultEvent.RESULT,downloadFile);
			}
			if(ac.length <=0 && ac1.length <= 0){
				Alert.show("没有连接关系需要导出","提示");
			}
		}
		
		private function downloadFile(event:ResultEvent):void{
			var url:String = ModelLocator.getURL();
			var path:String = url+event.result.toString();
			var request:URLRequest = new URLRequest(path); 
			navigateToURL(request,"_blank");
		}
		
		//批量操作与否
		private function checkChangHandler(event:Event):void{
			if(CheckBox(event.target).selected)
				isVolume = true; 
			else
				isVolume = false;
		}
		
		//刷新连接关系数据
		private function refreshLinesDataHandler(event:Event):void{
			var ro:RemoteObject = new RemoteObject("wireConfiguration");
			ro.endpoint = ModelLocator.END_POINT;
			ro.showBusyCursor = true;
			ro.addEventListener(ResultEvent.RESULT,getLinesData);
			ro.addEventListener(FaultEvent.FAULT,faultHandler);
			if(markType == "fiber"){
				ro.getODFLines(dmcode);
			}
			else if(markType == "matrix"){
				if(markValue == "DDF"){
					ro.getDDFLines(dmcode);
				}else{
					ro.getODFLines(dmcode);
				}
			}
		}
		
		private function getLinesData(event:ResultEvent):void{
			var wcgd:wireConfigurationGraphicsDataModule = event.result as wireConfigurationGraphicsDataModule;
			if(markType == "fiber"){
				addMatrixLines(wcgd.ODF_LINES_DATA,ODFLinesData);
				addFiberLines(wcgd.FIBER_LINES_DATA,FiberLinesData);
			}else if(markType == "matrix"){
				if(markValue == "DDF"){
					addMatrixLines(wcgd.DDF_LINES_DATA,DDFLinesData);
				}else{
					addMatrixLines(wcgd.ODF_LINES_DATA,ODFLinesData);
				}
			}
			dispatchEvent(new Event("RefreshCompleted"));  //刷新连接关系完成 广播事件  用于批量时重绘ODF模块或DDF模块
		}
		
		//初始化时打开的模块
		public function init(dmcode:String,porttype:String,portcode:String=null):void{
			var rtobj:RemoteObject = new RemoteObject("wireConfiguration");
			rtobj.endpoint = ModelLocator.END_POINT;		
			rtobj.addEventListener(ResultEvent.RESULT,DrawDataGraphicsHandler);
			rtobj.DrawDataGraphics(this.portcode,this.dmcode,this.porttype);
		}		
		
		private function DrawDataGraphicsHandler(event:ResultEvent):void{
			Graphdata = event.result as wireConfigurationGraphicsDataModule;
			this.DDFLinesData = new ArrayCollection();
			addMatrixLines(Graphdata.DDF_LINES_DATA,this.DDFLinesData);
			this.ODFLinesData = new ArrayCollection();
			addMatrixLines(Graphdata.ODF_LINES_DATA,this.ODFLinesData);
			this.FiberLinesData = new ArrayCollection(); 
			addFiberLines(Graphdata.FIBER_LINES_DATA,this.FiberLinesData);;
			this.DrawGraphics(Graphdata);
		}
		
		
		public function DrawGraphics(Graphdata:wireConfigurationGraphicsDataModule):void
		{
			addEventListener("graphicsCompleted",graphicsCompleted);
			if(Graphdata.EQUIPMENT_MODULE_DATA.length>0){
				var equipmentModuleData:ArrayCollection = Graphdata.EQUIPMENT_MODULE_DATA;
				for(var i:int=0;i<equipmentModuleData.length;i++)
				{
					this.CreateEquipmentModule(500,220,equipmentModuleData.getItemAt(i) as EquipmentModule,"Initialization");
				}
			}
			
			if(Graphdata.DDFDDM_MODULE_DATA.length > 0 ){
				for(var i:int = 0;i < Graphdata.DDFDDM_MODULE_DATA.length;i++){
					this.CreateDDFModule(0,0,300,Graphdata.DDFDDM_MODULE_DATA.getItemAt(i) as DdfDdmModule,"Initialization");
				}
			}
			
			if(Graphdata.OGM_DATA.length > 0){
				var ogmdata:ArrayCollection = Graphdata.OGM_DATA;
				if(ogmdata.length > 0){
					for(var k:int = 0; k < ogmdata.length; k++){
						this.CreateFiberModule(200,30,276,ogmdata.getItemAt(k) as OcableGraphicModule,"Down","Initialization");
					}
				}
			}
			
			if(Graphdata.ODFODM_MODULE_DATA.length > 0){
				for(var i:int =0; i < Graphdata.ODFODM_MODULE_DATA.length;i++){
					this.CreateODFModule(0,0,290,Graphdata.ODFODM_MODULE_DATA.getItemAt(i) as ODMMODULE,"Initialization");	
				}
			}
			
//			dispatchEvent(new Event("graphicsCompleted"));
		}
		
		private var count:int = 0;
		private function graphicsCompleted(event:Event):void{
			createMatrixLink("DDF");
			createMatrixLink("ODF");
			createFiberLink();
		}
		
		private function createLinkInteraction(linkClass:Class, linkType:String, callback:Function=null, isByControlPoint:Boolean=false, splitByPercent:Boolean=true, value:Number=-1):void
		{
			network.setCreateLinkInteractionHandlers(linkClass, callback, linkType, isByControlPoint, value, true);
		}
		
		private function createLinkCallBack(link:Link):void{
			link.setStyle(Styles.LINK_COLOR, 0x005e9b);
			link.setStyle(Styles.LINK_WIDTH, 2);
			link.setStyle(Styles.LINK_BUNDLE_GAP, -2);
			link.setStyle(Styles.LINK_BUNDLE_OFFSET,-1);
			link.setStyle(Styles.LINK_TYPE, Consts.LINK_TYPE_PARALLEL);
			link.layerID = layer5.id;
			Alert.show("您确认要建立连接关系吗？","请您确认！",Alert.YES|Alert.NO,this,function(event:CloseEvent):void{
				if(event.detail == Alert.YES){
					createLinkHandler(link);
				}else{
					elementBox.removeByID(link.id);
				}
			},null,Alert.NO);
		}
		
		private function createLinkHandler(link:Link):void{
			_tempLinkID = link.id;
			var fromNode:String = String(link.fromNode.id).split("-")[1];  //连线起点编码
			var toNode:String = String(link.toNode.id).split("-")[1];		//连线终点编码
			var fromID:String  = link.fromNode.id.toString(); //连线起点ID
			var toID:String  = link.toNode.id.toString();    //连线终点ID
			var fromType:String = StringUtil.trim(link.fromNode.getClient("porttype"));  //连线起点类型
			var toType:String = StringUtil.trim(link.toNode.getClient("porttype"));      //连线终点类型
			var bool:Boolean = true;
			var ro:RemoteObject = new RemoteObject("wireConfiguration");
			ro.showBusyCursor = true;
			ro.endpoint = ModelLocator.END_POINT;
			ro.addEventListener(FaultEvent.FAULT,faultHandler);
			if(fromType != "" && toType != ""){ 
				var stationA:String;			   //A端所在局站
				var stationZ:String;			   //Z端所在局站
				var field:String;				  //用来标识更新光纤的A端或Z端
				var parentNameA:String;     	 //A端模块编号或设备编号或光缆编号
				var parentNameZ:String;      	//Z端模块编号或设备编号或光缆编号
				var slotserial:String;      	 //基槽序号
				var packserial:String;      	 //机盘序号
				var frameserial:String;			 //机框序号
				var acPortsA:ArrayCollection;	//A端端口集合
				var acPortsZ:ArrayCollection;	//Z端端口集合
				var tempPoint1:Point;
				var tempPoint2:Point;
				var apointtype:String;
				var zpointtype:String;
				markType = "";
				if(fromType == "ZY23010499" ){
					this.dmcode =  Follower(link.fromNode).parent.getClient("code");
					this.porttype = "ZY23010499";
					this.portcode = link.fromNode.getClient("code");
				}else if(fromType == "ZY13010499"){
					this.dmcode =  Follower(link.fromNode).parent.getClient("code");
					this.porttype = "ZY13010499";
					this.portcode = link.fromNode.getClient("code");
				}
				
				if(toType == "ZY23010499") {
					this.dmcode =  Follower(link.toNode).parent.getClient("code");
					this.porttype = "ZY23010499";
					this.portcode = link.toNode.getClient("code");
				}else if(toType == "ZY13010499"){
					this.dmcode =  Follower(link.toNode).parent.getClient("code");
					this.porttype = "ZY13010499";
					this.portcode = link.toNode.getClient("code");
				}
				
				if(fromType == "ZY03070401" || fromType == "ZY03070402"){ //线路端口、光支路端口 
					if(toType == "fiber" || toType == "ZY23010499"){      //判断对端是光纤还是ODF
						if(toType == "fiber"){  //如果对端是光纤，则要判断要存入到哪一端
							this.markType = "fiber";
							this.markValue = "fiber";
							stationA = Follower(Follower(link.toNode).host).host.getClient("a_point");
							stationZ = Follower(Follower(link.toNode).host).host.getClient("z_point");
							if(stationA == Follower(link.fromNode).getClient("stationcode")){
								field = "aendodfport";
							}else if(stationZ ==  Follower(link.fromNode).getClient("stationcode")){
								field = "zendodfport";
							}else{
								Alert.show("配线关系两端端口必须在同一局站内！","提示");
								elementBox.removeByID(_tempLinkID);
								return;
							}
							link.setClient("linktype","fiber");
							link.setClient("code",toID + ":" + fromID);
							if(!isVolume){
								ro.addPortToFiber(fromNode,toNode,field);
							}
							parentNameA = link.fromNode.parent.parent.parent.getClient("code");
							parentNameZ = link.toNode.parent.parent.getClient("code");
							frameserial = link.fromNode.parent.parent.getClient("packcode").split("-")[0]
							slotserial = link.fromNode.parent.parent.getClient("packcode").split("-")[1]
							packserial = link.fromNode.parent.parent.getClient("packcode").split("-")[2]
							acPortsA = searchPorts(parentNameA,frameserial,slotserial,packserial);
							acPortsZ = searchPorts(parentNameZ);
							openVoleume("设备端口(A)","光纤端口(Z)",parseInt(link.fromNode.name),parseInt(link.toNode.name),acPortsA,acPortsZ,field+"-z");
						}else{//如果对端是ODF模块
							this.markType = "matrix";
							this.markValue = "ODF";
							link.setClient("linktype","matrix");
							link.setClient("code",fromID + ":" + toID);
							if(!isVolume){
								ro.addPortToMatrix(fromNode,toNode,fromType,toType);
							}
							parentNameA = link.fromNode.parent.parent.parent.getClient("code");
							parentNameZ = Follower(link.toNode).parent.getClient("code");
							frameserial = link.fromNode.parent.parent.getClient("packcode").split("-")[0]
							slotserial = link.fromNode.parent.parent.getClient("packcode").split("-")[1]
							packserial = link.fromNode.parent.parent.getClient("packcode").split("-")[2]
							acPortsA = searchPorts(parentNameA,frameserial,slotserial,packserial);
							acPortsZ = searchPorts(parentNameZ);
							openVoleume("设备端口(A)","ODF端口(Z)",parseInt(link.fromNode.name),parseInt(link.toNode.getClient("name")),acPortsA,acPortsZ,"",false,"ODF-"+parentNameZ+"-equipment-"+parentNameA,getLocation(parentNameZ));
						}
						bool = false;
					}
				}else if(fromType == "ZY03070403"){    //电路端口
					if(toType == "ZY13010499"){        //如果对端是DDF模块
						this.markType = "matrix";
						this.markValue = "DDF";
						link.setClient("linktype","matrix");
						link.setClient("code",fromID + ":" + toID);
						bool = false;
						if(!isVolume){
							ro.addPortToMatrix(fromNode,toNode,fromType,toType);
						}
						parentNameA = link.fromNode.parent.parent.parent.getClient("code");
						parentNameZ = Follower(link.toNode).parent.getClient("code");
						frameserial = link.fromNode.parent.parent.getClient("packcode").split("-")[0]
						slotserial = link.fromNode.parent.parent.getClient("packcode").split("-")[1]
						packserial = link.fromNode.parent.parent.getClient("packcode").split("-")[2]
						acPortsA = searchPorts(parentNameA,frameserial,slotserial,packserial);
						acPortsZ = searchPorts(parentNameZ);
						openVoleume("设备端口(A)","DDF端口(Z)",parseInt(link.fromNode.name),parseInt(link.toNode.name),acPortsA,acPortsZ,"",false,"DDF-"+parentNameZ+"-equipment-"+parentNameA,getLocation(parentNameZ));
					}
				}else if(fromType == "ZY23010499"){   //ODF端口
					if(toType == "ZY03070401" || toType == "ZY03070402" || toType == "fiber" || toType == "ZY23010499"){
						if(toType == "fiber"){
							this.markType = "fiber";
							this.markValue = "fiber";
							stationA = Follower(Follower(link.toNode).host).host.getClient("a_point");
							stationZ = Follower(Follower(link.toNode).host).host.getClient("z_point");
							apointtype =Follower(Follower(link.toNode).host).host.getClient("a_pointtype");
							zpointtype =Follower(Follower(link.toNode).host).host.getClient("z_pointtype");
							if(apointtype == "1"){
								if(stationA == link.fromNode.getClient("stationcode")){
									field = "aendodfport";
								}else if(zpointtype == "1"){
									if(stationZ == link.fromNode.getClient("stationcode")){
										field = "zendodfport";
									}else{
										Alert.show("配线关系两端必须在同一站内","提示");
										elementBox.removeByID(_tempLinkID);
										return;
									}
								}else{
									Alert.show("配线关系两端必须在同一站内","提示");
									elementBox.removeByID(_tempLinkID);
									return;
								}
							}else if(apointtype == "R"){
								if(stationA ==  link.fromNode.getClient("roomcode")){
									field = "aendodfport";
								}else if(zpointtype =="R"){
									if(stationZ ==  link.fromNode.getClient("roomcode")){
										field = "zendodfport";
									}else{
										Alert.show("配线关系两端必须在同一机房内","提示");
										elementBox.removeByID(_tempLinkID);
										return;
									}
								}else{
									Alert.show("配线关系两端必须在同一机房内","提示");
									elementBox.removeByID(_tempLinkID);
									return;
								}
							}else if(apointtype == "2"){
								if(zpointtype == "1"){
									if(stationZ ==  link.fromNode.getClient("stationcode")){
										field = "zendodfport";
									}else{
										Alert.show("配线关系两端必须在同一机房内","提示");
										elementBox.removeByID(_tempLinkID);
										return;
									}
								}else{
									Alert.show("配线关系两端必须在同一机房内","提示");
									elementBox.removeByID(_tempLinkID);
									return;
								}
							}else{
								Alert.show("配线关系两端必须在同一机房内","提示");
								elementBox.removeByID(_tempLinkID);
								return;
							}
							
							link.setClient("linktype","fiber");
							link.setClient("code",toID + ":" + fromID);
							if(!isVolume){
								ro.addPortToFiber(toNode,fromNode,field);
							}
							parentNameA = Follower(link.fromNode).parent.getClient("code");
							parentNameZ = link.toNode.parent.parent.getClient("code");
							openVoleume("ODF端口(A)","光纤端口(Z)",parseInt(link.fromNode.getClient("name")),parseInt(link.toNode.name),searchPorts(parentNameA),searchPorts(parentNameZ),field+"-z",false,"ODF-"+parentNameA+"-ocable-"+parentNameZ,getLocation(parentNameA));
						}
						if(toType == "ZY03070401" || toType == "ZY03070402"){
							this.markType = "matrix";
							this.markValue = "ODF";
							link.setClient("linktype","matrix");
							link.setClient("code",fromID + ":" + toID);
							if(!isVolume){
								ro.addPortToMatrix(fromNode,toNode,fromType,toType);
							}
							parentNameA = Follower(link.fromNode).parent.getClient("code");
							parentNameZ = link.toNode.parent.parent.parent.getClient("code");
							frameserial = link.toNode.parent.parent.getClient("packcode").split("-")[0]
							slotserial = link.toNode.parent.parent.getClient("packcode").split("-")[1]
							packserial = link.toNode.parent.parent.getClient("packcode").split("-")[2]
							acPortsA = searchPorts(parentNameA);
							acPortsZ = searchPorts(parentNameZ,frameserial,slotserial,packserial);
							openVoleume("ODF端口(A)","设备端口(Z)",parseInt(link.fromNode.getClient("name")),parseInt(link.toNode.name),acPortsA,acPortsZ,"",false,"ODF-"+parentNameA+"-equipment-"+parentNameZ,getLocation(parentNameA));
						}
						if(toType == "ZY23010499"){
							this.markType = "matrix";
							this.markValue = "ODF";
							link.setClient("linktype","matrix");
							link.setClient("code",fromID + ":" + toID);
							if(!isVolume){
								ro.addPortToMatrix(fromNode,toNode,fromType,toType);
							}
							parentNameA = Follower(link.fromNode).parent.getClient("code");
							parentNameZ = Follower(link.toNode).parent.getClient("code");
							if(parentNameA == parentNameZ){
								openVoleume("ODF端口(A)","ODF端口(Z)",parseInt(link.fromNode.getClient("name")),parseInt(link.toNode.getClient("name")),searchPorts(parentNameA),searchPorts(parentNameZ),"",false,"ODF-"+parentNameZ,getLocation(parentNameZ));
							}else{
								tempPoint1 = getLocation(parentNameA);
								tempPoint2 = getLocation(parentNameZ);
								openVoleume("ODF端口(A)","ODF端口(Z)",parseInt(link.fromNode.getClient("name")),parseInt(link.toNode.getClient("name")),searchPorts(parentNameA),searchPorts(parentNameZ),"",false,"ODF-"+parentNameA+"-ODF-"+parentNameZ,tempPoint1,tempPoint2);
							}
						}
						bool = false;
					}
				}else if(fromType == "ZY13010499"){	//DDF端口
					if(toType == "ZY03070403" || toType == "ZY13010499"){
						this.markType = "matrix";
						this.markValue = "DDF";
						link.setClient("linktype","matrix");
						link.setClient("code",fromID + ":" + toID);
						bool = false;
						if(!isVolume){
							ro.addPortToMatrix(fromNode,toNode,fromType,toType);
						}
						if(toType == "ZY13010499"){
							parentNameA = Follower(link.fromNode).parent.getClient("code");
							parentNameZ = Follower(link.toNode).parent.getClient("code");
							if(parentNameA == parentNameZ){
								openVoleume("DDF端口(A)","DDF端口(Z)",parseInt(link.fromNode.name),parseInt(link.toNode.name),searchPorts(parentNameA),searchPorts(parentNameZ),"",false,"DDF-"+parentNameA,getLocation(parentNameA));
							}else{
								tempPoint1 = getLocation(parentNameA);
								tempPoint2 = getLocation(parentNameZ);
								openVoleume("DDF端口(A)","DDF端口(Z)",parseInt(link.fromNode.name),parseInt(link.toNode.name),searchPorts(parentNameA),searchPorts(parentNameZ),"",false,"DDF-"+parentNameA+"-DDF-"+parentNameZ,tempPoint1,tempPoint2);
							}
						}else{
							parentNameA = Follower(link.fromNode).parent.getClient("code");
							parentNameZ = link.toNode.parent.parent.parent.getClient("code");
							frameserial = link.toNode.parent.parent.getClient("packcode").split("-")[0]
							slotserial = link.toNode.parent.parent.getClient("packcode").split("-")[1]
							packserial = link.toNode.parent.parent.getClient("packcode").split("-")[2]
							acPortsA = searchPorts(parentNameA);
							acPortsZ = searchPorts(parentNameZ,frameserial, slotserial,packserial);
							openVoleume("DDF端口(A)","设备端口(Z)",parseInt(link.fromNode.name),parseInt(link.toNode.name),acPortsA,acPortsZ,"",false,"DDF-"+parentNameA+"-equipment-"+parentNameZ,getLocation(parentNameA));
						}
					}
				}else if(fromType == "fiber"){   //光纤
					if(toType == "ZY03070401" || toType == "ZY03070402" || toType == "ZY23010499"){
						stationA = Follower(Follower(link.fromNode).host).host.getClient("a_point");
						stationZ = Follower(Follower(link.fromNode).host).host.getClient("z_point");
						apointtype =Follower(Follower(link.fromNode).host).host.getClient("a_pointtype");
						zpointtype =Follower(Follower(link.fromNode).host).host.getClient("z_pointtype");
						if(apointtype == "1"){
							if(stationA == link.toNode.getClient("stationcode")){
								field = "aendodfport";
							}else if(zpointtype == "1"){
								if(stationZ == link.toNode.getClient("stationcode")){
									field = "zendodfport";
								}else{
									Alert.show("配线关系两端必须在同一站内","提示");
									elementBox.removeByID(_tempLinkID);
									return;
								}
							}else{
								Alert.show("配线关系两端必须在同一站内","提示");
								elementBox.removeByID(_tempLinkID);
								return;
							}
						}else if(apointtype == "R"){
							if(stationA ==  link.toNode.getClient("roomcode")){
								field = "aendodfport";
							}else if(zpointtype =="R"){
								if(stationZ ==  link.toNode.getClient("roomcode")){
									field = "zendodfport";
								}else{
									Alert.show("配线关系两端必须在同一机房内","提示");
									elementBox.removeByID(_tempLinkID);
									return;
								}
							}else{
								Alert.show("配线关系两端必须在同一机房内","提示");
								elementBox.removeByID(_tempLinkID);
								return;
							}
						}else if(apointtype == "2"){
							if(zpointtype == "1"){
								if(stationZ ==  link.toNode.getClient("stationcode")){
									field = "zendodfport";
								}else{
									Alert.show("配线关系两端必须在同一站内","提示");
									elementBox.removeByID(_tempLinkID);
									return;
								}
							}else{
								Alert.show("配线关系两端必须在同一站内","提示");
								elementBox.removeByID(_tempLinkID);
								return;
							}
						}else{
							Alert.show("配线关系两端必须在同一站内","提示");
							elementBox.removeByID(_tempLinkID);
							return;
						}
						this.markType = "fiber";
						this.markType = "fiber";
						link.setClient("linktype","fiber");
						link.setClient("code",fromID + ":" + toID);
						bool = false;
						if(!isVolume){
							ro.addPortToFiber(fromNode,toNode,field);
						}
						if(toType == "ZY03070401" || toType == "ZY03070402"){
							if(!isVolume){
							}
							parentNameA = Follower(link.fromNode).host.parent.getClient("code");
							parentNameZ = link.toNode.parent.parent.parent.getClient("code");
							frameserial = link.toNode.parent.parent.getClient("packcode").split("-")[0]
							slotserial = link.toNode.parent.parent.getClient("packcode").split("-")[1]
							packserial = link.toNode.parent.parent.getClient("packcode").split("-")[2]
							acPortsA = searchPorts(parentNameA);
							acPortsZ = searchPorts(parentNameZ,frameserial, slotserial,packserial);
							openVoleume("光纤端口(A)","设备端口(Z)",parseInt(link.fromNode.name),parseInt(link.toNode.name),acPortsA,acPortsZ,field+"-a");
						}
						if(toType == "ZY23010499"){
							if(!isVolume){
							}
							parentNameA = link.fromNode.parent.parent.getClient("code");
							parentNameZ = Follower(link.toNode).parent.getClient("code");
							openVoleume("光纤端口(A)","ODF端口(Z)",parseInt(link.fromNode.name),parseInt(link.toNode.getClient("name")),searchPorts(parentNameA),searchPorts(parentNameZ),field+"-a",false,"ODF-"+parentNameZ+"-ocable-"+parentNameA,getLocation(parentNameZ));
						}
					}
				}
				ro.addEventListener(ResultEvent.RESULT,function (event:ResultEvent):void{
					if(!isVolume){
						var bool:Boolean = event.result as Boolean;
						if(bool)
							Alert.show("操作成功","提示");
						else
							Alert.show("操作失败","提示");
						
					
						if(fromType == "ZY03070401" || fromType == "ZY03070402" || fromType == "ZY03070403"){
							setNodeColor(link.fromNode,"equipment",true);
						}
						else if(fromType == "ZY13010499"){
							setNodeColor(link.fromNode,"DDF",true);
						}else if(fromType == "ZY23010499" ){  
							if(toType == "fiber"){				//光纤与ODF连接关系时做特殊处理
								addMoreModules(parentNameA,"ODF",getLocation(parentNameA));
								setNodeColor(link.toNode,"fiber",true);
								return;
							}else{
								setNodeColor(link.fromNode,"ODF",true);
							}
							
						}else if(fromType == "fiber"){
							if(toType == "ZY23010499"){   //光纤与ODF连接关系时做特殊处理
								addMoreModules(parentNameZ,"ODF",getLocation(parentNameZ));
								setNodeColor(link.fromNode,"fiber",true);
								return;	
							}else{
								setNodeColor(link.toNode,"ODF",true);
							}
						} 
						
						
						if(toType == "ZY03070401" || toType == "ZY03070402" || toType == "ZY03070403"){
							setNodeColor(link.toNode,"equipment",true);
						}
						else if(toType == "ZY13010499"){
							setNodeColor(link.toNode,"DDF",true);
						}else if(toType == "ZY23010499"){
							if(fromType != "fiber"){
								setNodeColor(link.toNode,"ODF",true);
							}
						}
						
						dispatchEvent(new Event("RefreshLinesData"));
					}
				});
			}
			if(bool){
				network.elementBox.removeByID(link.id);
				Alert.show("创建关系失败,请检查所选择的端口是否正确!","提示");
				return;
			}
		}
		
		//获取位置
		private function getLocation(code:String):Point{
			for(var i:int = 0; i < network.elementBox.datas.count; i++){
				var element:IElement = network.elementBox.datas.getItemAt(i);
				if(element is Node){
					if(element.getClient("code") == code)
						return Node(element).location;
				}
			}
			return null;
		}
		
		//更新端口颜色
		private function setNodeColor(node:Node, type:String,isAdd:Boolean):void{
			var count:int = 0;
			count = node.getClient("linecount");
			
			if(type == "fiber"){
				var ro:RemoteObject = new RemoteObject("wireConfiguration");
				ro.showBusyCursor = true;
				ro.endpoint = ModelLocator.END_POINT;
				ro.getFiberLineCount(node.getClient("code"));
				ro.addEventListener(ResultEvent.RESULT,function (event:ResultEvent):void{
					var lineCount:String = event.result as String;
					node.setClient("linecount",lineCount);
					if(lineCount == "0"){
						node.image = "PORTIcon"
					}else if(lineCount == "1"){
						node.image = "PORTYELLOW";
					}else if(lineCount == "2"){
						node.image = "PORTGREEN";
					}else{
						node.image = "PORTRED";
					}
					
					for(var i:int=0; i < acAllPorts.length; i++){ //更新集合里端口连接数量
						var tempAC:ArrayCollection = acAllPorts[i].data as ArrayCollection;
						for each(var obj:Object in tempAC){
							if(obj.portcode == node.getClient("code")){
								obj.linecount = lineCount;
								break;
							}
						}
					}
					
				});
			}else{
				
				if(isAdd){
					node.setClient("linecount",count + 1);
				}else{
					node.setClient("linecount",count - 1);
				}
				
				count = node.getClient("linecount");
				
				if (count == 0){
					if(type=="ODF"){
						node.image="odf_port"
					}else if(type == "DDF"){
						node.image="DDF_PORT";
					}else if(type == "equipment"){
						if(node.getClient("porttype") == "ZY03070403"){
							node.image = "PORT_RECT";
						}else{
							node.image = "PORTIcon";
						}
					}
				}
				else if (count == 1){
					if(type=="ODF"){
						node.image="odf_yellow"
					}else if(type == "DDF"){
						node.image="ddf_yellow";
					}else if(type == "equipment"){
						if(node.getClient("porttype") == "ZY03070403"){
							node.image = "PORT_RECT_YELLOW";
						}else{
							node.image = "PORTYELLOW";
						}
					}
				}
				else if (count == 2){
					if(type=="ODF"){
						node.image="odf_green"
					}else if(type == "DDF"){
						node.image="ddf_green";
					}else if(type == "equipment"){
						if(node.getClient("porttype") == "ZY03070403"){
							node.image = "PORT_RECT_GREEN";
						}else{
							node.image = "PORTGREEN";
						}
					}
				}
				else{
					if(type=="ODF"){
						node.image="odf_red"
					}else if(type == "DDF"){
						node.image="ddf_red";
					}else if(type == "equipment"){
						if(node.getClient("porttype") == "ZY03070403"){
							node.image = "PORT_RECT_RED";
						}else{
							node.image = "PORTRED";
						}
					}
				}
				
				if(type == "equipment"){  //更新设备端口颜色
					for(var i:int=0; i < acAllPorts.length; i++){ //更新集合里端口连接数量
						var tempAC:ArrayCollection = acAllPorts[i].data as ArrayCollection;
						for each(var obj:Object in tempAC){
							if(obj.portcode == node.getClient("code")){
								obj.linecount = count.toString();
								break;
							}
						}
					}
				}
			}
		}
		
		private function openVoleume(lblNameA:String,lblNameZ:String,startA:int,startZ:int,portsA:ArrayCollection,portsZ:ArrayCollection,field:String="",del:Boolean=false,moduleName:String="",point:Point=null,point1:Point = null):void{
			var winVolume:WinVolume = new WinVolume();
			winVolume.markType = this.markType;
			winVolume.nameA = lblNameA;
			winVolume.nameZ = lblNameZ;
			winVolume.relationWireConfig = this;
			winVolume.startA = startA;
			winVolume.startZ = startZ;
			winVolume.field = field;
			winVolume.del = del;
			winVolume.resetModule = moduleName;
			winVolume.point = point;
			winVolume.point1 = point1;
			winVolume.acPortsA = portsA;
			winVolume.acPortsZ = portsZ;
			if(isVolume)
				MyPopupManager.addPopUp(winVolume);
		}
		
		private function addCompletedHandler(event:ResultEvent):void{
			if(!isVolume){
				var bool:Boolean = event.result as Boolean;
				if(bool)
					Alert.show("操作成功","提示");
				else
					Alert.show("操作失败","提示");
				dispatchEvent(new Event("RefreshLinesData"));
			}
		}
		
		private function delCompletedHandler(event:ResultEvent):void{
			if(!isVolume){
				var bool:Boolean = event.result as Boolean;
				if(bool){
					network.elementBox.removeByID(_tempLinkID);
					Alert.show("操作成功","提示");
				}else{
					Alert.show("操作失败","提示");
				}
				dispatchEvent(new Event("RefreshLinesData"));
			}
		}
		
		private function faultHandler(event:FaultEvent):void{
			Alert.show(event.message.toString());
		}
		
		private function contextMenuEvent(event:ContextMenuEvent):void{
			var p:Point = new Point(event.mouseTarget.mouseX / network.zoom, event.mouseTarget.mouseY / network.zoom);
			var datas:ICollection = network.getElementsByLocalPoint(p);
			if (datas.count > 0)
				network.selectionModel.setSelection(datas.getItemAt(0));
			else
				network.selectionModel.clearSelection();
			if(network.selectionModel.count > 0)
			{
				var element:Element = network.selectionModel.selection.getItemAt(0);
				if(element is Follower && element.layerID == layer1.id){
					var itemrevoke:ContextMenuItem = new ContextMenuItem("撤销");
					itemrevoke.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,revokeResHandler);
					network.contextMenu.customItems = [itemrevoke];
					if(element.getClient("type") == "ocable"){
	//					var itemUp:ContextMenuItem = new ContextMenuItem("旋转向上");
	//					itemUp.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,itemSelectEventHandler);
	//					var itemDown:ContextMenuItem = new ContextMenuItem("旋转向下");
	//					itemDown.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,itemSelectEventHandler);
	//					var itemLeft:ContextMenuItem = new ContextMenuItem("旋转向左");
	//					itemLeft.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,itemSelectEventHandler);
	//					var itemRight:ContextMenuItem = new ContextMenuItem("旋转向右");
	//					itemRight.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,itemSelectEventHandler);
	//					network.contextMenu.customItems = [itemUp,itemDown,itemLeft,itemRight];
						network.contextMenu.customItems = [itemrevoke];
					}
				}else if(element is Link){
					if(StringUtil.trim(Link(element).getClient("linktype")) != ""){
						var itemDel:ContextMenuItem = new ContextMenuItem("删 除");
						itemDel.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,itemSelectEventHandler);
						
						var itemShowChannel:ContextMenuItem = new ContextMenuItem("显示通道",true);
						itemShowChannel.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,showChannelEventHandler);
						
						var itemDelChannel:ContextMenuItem = new ContextMenuItem("取消通道显示");
						itemDelChannel.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,deleteChannelEventHandler);
						network.contextMenu.customItems = [itemDel,itemShowChannel,itemDelChannel];
					}
				}else if(element is Follower && element.layerID == layer3.id){
					var itemShowRes:ContextMenuItem = new ContextMenuItem("查看连接关系");
					itemShowRes.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,showResHandler);
					if(element.getClient("porttype") == "fiber" ){
						var itemFiberRoute:ContextMenuItem = new ContextMenuItem("光纤路由",true);
						itemFiberRoute.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,showFiberRouteHandler);
						var itemfiberpropery:ContextMenuItem = new ContextMenuItem("属性",false);
						itemfiberpropery.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,showFiberProperyHandler);
						var itemOcableRoute:ContextMenuItem = new ContextMenuItem("光路路由");
						itemOcableRoute.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,showFiberOcableRouteHandler);
						network.contextMenu.customItems = [itemFiberRoute,itemShowRes,itemOcableRoute];
					}else if( Follower(element).getClient("porttype") == "ZY13010499" ){
						var itemddfportproperty:ContextMenuItem = new ContextMenuItem("属性",false);
						itemddfportproperty.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,showDDFPortPropertyHandler);
						network.contextMenu.customItems = [itemddfportproperty,itemShowRes];
					}else if( Follower(element).getClient("porttype") == "ZY23010499" ){
						var itemodfportpropery:ContextMenuItem = new ContextMenuItem("属性",false);
						itemodfportpropery.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,showODFPortPropertyHandler);
						var itemocableroute:ContextMenuItem = new ContextMenuItem("光路路由",true);
						itemocableroute.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,showOcableRouteHandler);
						network.contextMenu.customItems = [itemodfportpropery,itemShowRes,itemocableroute];
					}else if( Follower(element).getClient("porttype") == "ZY03070403" || Follower(element).getClient("porttype") == "ZY03070402"||Follower(element).getClient("porttype") == "ZY03070401"){
						var itemequiportpropery:ContextMenuItem = new ContextMenuItem("属性",false);
						itemequiportpropery.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,showEquipPortProperyHandler);
						network.contextMenu.customItems = [itemequiportpropery,itemShowRes];
					}else{
						network.contextMenu.customItems = [itemShowRes];
					}
				}
				else{
					network.contextMenu.customItems = [];
				}
			}else{
				var item:ContextMenuItem = new ContextMenuItem("默认模式");
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,function(event:ContextMenuEvent):void{
					network.interactionHandlers=new Collection([  
						new CustomInteractionHandler(network),  
						new MoveInteractionHandler(network),
						new DefaultInteractionHandler(network),]);
				});
				network.contextMenu.customItems = [item];
			}
		}
		
		
		//查看ODF端口光路路由
		private function showOcableRouteHandler(even:ContextMenuEvent):void{
			var port:Follower = network.selectionModel.selection.getItemAt(0);	
			var ro:RemoteObject = new RemoteObject("ocableRoute");
			ro.endpoint= ModelLocator.END_POINT;
			ro.showBusyCursor = true;
			ro.getOcableRouteByOdfPort(port.getClient("code"),parentApplication.curUser);
			ro.addEventListener(ResultEvent.RESULT,joinResultHandler);
		}
		
		
		//查看光纤光路路由
		private function showFiberOcableRouteHandler(event:ContextMenuEvent):void{
			var port:Follower = network.selectionModel.selection.getItemAt(0);	
			var ro:RemoteObject = new RemoteObject("ocableRoute");
			ro.endpoint= ModelLocator.END_POINT;
			ro.showBusyCursor = true;
			ro.getOcableRouteByFiber(port.getClient("code"),parentApplication.curUser);
			ro.addEventListener(ResultEvent.RESULT,joinResultHandler);
		}
		
		private function joinResultHandler(event:ResultEvent):void{
			var port:Follower = network.selectionModel.selection.getItemAt(0);	
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
			ocableRoute.nodecode = port.getClient("code");
			ocableRoute.nodetype = port.getClient("porttype")=="ZY23010499"?"2":"3";
			parentApplication.openModel("光路路由",false,ocableRoute);
			
		}
		
		//查看光纤属性
		private function showFiberProperyHandler(evetnt:ContextMenuEvent):void{
			var property:ShowProperty = new ShowProperty();
			var follower:Follower = network.selectionModel.selection.getItemAt(0);	
			property.paraValue = follower.getClient("code");
			property.tablename = "VIEW_EN_FIBER";
			property.key = "FIBERCODE";
			property.title = follower.name +"纤芯—光纤属性";
			PopUpManager.addPopUp(property, this, true);
			PopUpManager.centerPopUp(property);
			property.addEventListener("savePropertyComplete",function (event:Event):void{
				PopUpManager.removePopUp(property);
			});
		}
		
		//查看设备端口属性
		private function showEquipPortProperyHandler(event:ContextMenuEvent):void{
			var follower:Follower = network.selectionModel.selection.getItemAt(0);	
			var property:ShowProperty = new ShowProperty();
			property.paraValue = follower.getClient("code");
			property.tablename = "VIEW_EQUIPLOGICPORT_PROPERTY";
			property.key = "LOGICPORT";
			property.title = follower.name+"端口—设备端口属性";
			PopUpManager.addPopUp(property, this, true);
			PopUpManager.centerPopUp(property);
		}
		
		
		//查看ODF端口属性
		private function showODFPortPropertyHandler(evetn:ContextMenuEvent):void{
			var follower:Follower = network.selectionModel.selection.getItemAt(0);	
			var property:ShowProperty = new ShowProperty();
			property.title = follower.getClient("name")+"—ODF端口属性";
			property.paraValue =follower.getClient("code");
			property.tablename = "VIEW_EN_ODFPORT";
			property.key = "ODFPORTCODE";
			PopUpManager.addPopUp(property, this, true);
			PopUpManager.centerPopUp(property);		
			property.addEventListener("savePropertyComplete",function (event:Event):void{
				PopUpManager.removePopUp(property);
			});
		}
		
		//查看那DDF端口属性
		private function showDDFPortPropertyHandler(event:ContextMenuEvent):void{
			var follower:Follower = network.selectionModel.selection.getItemAt(0);	
			var property:ShowProperty = new ShowProperty();
			property.title = follower.getClient("name")+"—DDF端口属性";
			property.paraValue =follower.getClient("code");
			property.tablename = "VIEW_EN_DDFPORT";
			property.key = "DDFPORTCODE";
			property.objectValues.circuit = follower.getClient("circuit");
			PopUpManager.addPopUp(property, this, true);
			PopUpManager.centerPopUp(property);		
			property.addEventListener("savePropertyComplete",function (event:Event):void{
				PopUpManager.removePopUp(property);
			});
		}
		
		
		//撤销资源
		private function revokeResHandler(event:ContextMenuEvent):void{
			var follower:Follower = network.selectionModel.selection.getItemAt(0);	
			selectedTreeItem(follower.id.toString().split("-")[1],follower.getClient("type"),false);
			this.removeModule(follower.id.toString().split("-")[1],"code",follower.getClient("type"),twaver.Consts.PROPERTY_TYPE_CLIENT,true);
			this.removeModulePorts(follower.name);
		}
		
		//显示光纤路由
		private function showFiberRouteHandler(event:ContextMenuEvent):void{
			if(network.selectionModel.count > 0){
				if((Element)(network.selectionModel.selection.getItemAt(0)) is Follower)
				{
					var element:Follower = network.selectionModel.selection.getItemAt(0) as Follower;
					var fibercode:String = element.getClient("code");
					if(fibercode != null && fibercode != ""){
						var fri:FiberRoutInfo = new FiberRoutInfo();
						fri.title = "光纤路由";
						fri.fibercode = fibercode;
						MyPopupManager.addPopUp(fri);
					}else{
						Alert.show("请确认是否选择光纤","提示");
					}
				}
			}
		}
		
		
		/**
		 * 取消通道显示
		 */ 
		private function deleteChannelEventHandler(event:ContextMenuEvent):void{
			for(var i:int = 0; i < network.elementBox.datas.count; i++){
				var element:IElement = network.elementBox.datas.getItemAt(i);
				if(element is Link){
					if(element.getStyle(Styles.LINK_COLOR) == ColorKeys.DARKRED){
						element.setStyle(Styles.LINK_COLOR,0x005e9b);	
					}
				}
			}
			
		}
		
		/**
		 * 显示通道
		 */
		private function showChannelEventHandler(event:ContextMenuEvent):void{
			if(network.selectionModel.count > 0){ //如果有选择
				var link:Link  =network.selectionModel.selection.getItemAt(0) as Link;
				link.setStyle(Styles.LINK_COLOR,ColorKeys.DARKRED);
				findNextChannelLink(link.fromNode,link);
				findNextChannelLink(link.toNode,link);
			}
		}
		
		/**
		 * 递归查找相连的通道
		 */
		private function findNextChannelLink(node:Node,link:Link):void{
			for(var i:int = 0; i < network.elementBox.datas.count; i++){
				var element:IElement = network.elementBox.datas.getItemAt(i);
				if(element is Link){
					if(Link(element).layerID == layer5.id){ //确定该连线是连接关系
						
						if( Link(element).fromNode.id == node.id && link.id !=  Link(element).id ){
							if(Link(element).getStyle(Styles.LINK_COLOR) != ColorKeys.DARKRED){//如果已经查找过了 则停止查找
								Link(element).setStyle(Styles.LINK_COLOR,ColorKeys.DARKRED);
								findNextChannelLink( Link(element).toNode,Link(element));
							}
						}else if( Link(element).toNode.id == node.id && link.id !=  Link(element).id){
							if(Link(element).getStyle(Styles.LINK_COLOR) != ColorKeys.DARKRED){
								Link(element).setStyle(Styles.LINK_COLOR,ColorKeys.DARKRED);
								findNextChannelLink( Link(element).fromNode,Link(element));
							}
						}
					}
				}
			}
		}
		
		//删除连接关系 code连线编码 type连线类型
		public function delMatrixsLink(code:String,type:String):void{
			var portA:String = code.split(":")[0].toString().split("-")[1];
			var portAtype:String = code.split(":")[0].toString().split("-")[0];
			var portZ:String = code.split(":")[1].toString().split("-")[1];
			var portZtype:String = code.split(":")[1].toString().split("-")[0];
			if(type == "DDF"){
				for(var i:int = 0; i < DDFLinesData.length; i++){
					if((portA == DDFLinesData[i].PORTSERIALNO1 && portAtype == DDFLinesData[i].PORTTYPE1 && portZ == DDFLinesData[i].PORTSERIALNO2 && portZtype == DDFLinesData[i].PORTTYPE2)||
						(portA == DDFLinesData[i].PORTSERIALNO2 && portAtype == DDFLinesData[i].PORTTYPE2 && portZ == DDFLinesData[i].PORTSERIALNO1 && portZtype == DDFLinesData[i].PORTTYPE1))
						DDFLinesData.removeItemAt(i);
				}
			}else{
				for(var j:int = 0; j < ODFLinesData.length; j++){
					if((portA == ODFLinesData[j].PORTSERIALNO1 && portAtype == ODFLinesData[j].PORTTYPE1 && portZ == ODFLinesData[j].PORTSERIALNO2 && portZtype == ODFLinesData[j].PORTTYPE2)||
						(portA == ODFLinesData[j].PORTSERIALNO2 && portAtype == ODFLinesData[j].PORTTYPE2 && portZ == ODFLinesData[j].PORTSERIALNO1 && portZtype == ODFLinesData[j].PORTTYPE1))
						ODFLinesData.removeItemAt(j);
				}
			}
		}
		
		//删除光纤连接关系
		public function delFibersLink(code:String):void{
			var id:String = code.split(":")[0];
			for(var i:int = 0; i < FiberLinesData.length; i++){
				if(id == FiberLinesData[i].fibercode)
					FiberLinesData.removeItemAt(i);
			}
		}
		
		
		private function itemSelectEventHandler(event:ContextMenuEvent):void{
				Alert.show("您确认要删除连接关系吗？","请您确认！",Alert.YES|Alert.NO,this,delLinkHandler,null,Alert.NO);
		}
		
		private function delLinkHandler(event:CloseEvent):void{
			if(event.detail == Alert.NO){
				return;
			}
			this.markType = "";
			if(network.selectionModel.count > 0){
				var link:Link = network.selectionModel.selection.getItemAt(0) as Link;
				_tempLinkID = link.id;
				var ro:RemoteObject = new RemoteObject("wireConfiguration");
				ro.endpoint = ModelLocator.END_POINT;
				ro.showBusyCursor = true;
				ro.addEventListener(FaultEvent.FAULT,faultHandler);
				var fromType:String = StringUtil.trim(link.fromNode.getClient("porttype"));
				var toType:String = StringUtil.trim(link.toNode.getClient("porttype"));
				if(fromType == "ZY23010499" ){
					this.dmcode =  Follower(link.fromNode).parent.getClient("code");
					this.porttype = "ZY23010499";
					this.portcode = link.fromNode.getClient("code");
				}else if(fromType == "ZY13010499"){
					this.dmcode =  Follower(link.fromNode).parent.getClient("code");
					this.porttype = "ZY13010499";
					this.portcode = link.fromNode.getClient("code");
				}
				
				if(toType == "ZY23010499") {
					this.dmcode =  Follower(link.toNode).parent.getClient("code");
					this.porttype = "ZY23010499";
					this.portcode = link.toNode.getClient("code");
				}else if(toType == "ZY13010499"){
					this.dmcode =  Follower(link.toNode).parent.getClient("code");
					this.porttype = "ZY13010499";
					this.portcode = link.toNode.getClient("code");
				}
				if(link.getClient("linktype") == "matrix"){
					var port1:String = String(link.fromNode.id).split("-")[1];
					var port2:String = String(link.toNode.id).split("-")[1];
					if(!isVolume)
						ro.delRelationFromMatrix(port1,port2,fromType,toType);
					markType = "matrix";
					var parentNameA:String;
					var parentNameZ:String;
					var slotserial:String;
					var packserial:String;
					var frameserial:String;
					var acPortsA:ArrayCollection;
					var acPortsZ:ArrayCollection;
					var tempPoint:Point;
					var tempPoint1:Point;
					if(fromType == "ZY13010499" && toType == "ZY13010499"){//两端是DDF
						if(!isVolume){
							delMatrixsLink(link.getClient("code"),"DDF");
						}
						parentNameA = Follower(link.fromNode).parent.getClient("code");
						parentNameZ = Follower(link.toNode).parent.getClient("code");
						if(parentNameA == parentNameZ){
							openVoleume("DDF端口(A)","DDF端口(Z)",parseInt(link.fromNode.name),parseInt(link.toNode.name),searchPorts(parentNameA),searchPorts(parentNameZ),"",true,"DDF-"+parentNameZ,getLocation(parentNameZ));
						}else{
							tempPoint = getLocation(parentNameA);
							tempPoint1 = getLocation(parentNameZ);
							openVoleume("DDF端口(A)","DDF端口(Z)",parseInt(link.fromNode.name),parseInt(link.toNode.name),searchPorts(parentNameA),searchPorts(parentNameZ),"",true,"DDF-"+parentNameA+"-DDF-"+parentNameZ,tempPoint,tempPoint1);
						}
					}else if(fromType == "ZY23010499" && toType == "ZY23010499"){//两端是ODF
						if(!isVolume){
							delMatrixsLink(link.getClient("code"),"ODF");
						}
						parentNameA = Follower(link.fromNode).parent.getClient("code");;
						parentNameZ = Follower(link.toNode).parent.getClient("code");
						if(parentNameA == parentNameZ){
							openVoleume("ODF端口(A)","ODF端口(Z)",parseInt(link.fromNode.getClient("name")),parseInt(link.toNode.getClient("name")),searchPorts(parentNameA),searchPorts(parentNameZ),"",true,"ODF-"+parentNameA,getLocation(parentNameA));
						}else{
							tempPoint = getLocation(parentNameA);
							tempPoint1 = getLocation(parentNameZ);
							openVoleume("ODF端口(A)","ODF端口(Z)",parseInt(link.fromNode.getClient("name")),parseInt(link.toNode.getClient("name")),searchPorts(parentNameA),searchPorts(parentNameZ),"",true,"ODF-"+parentNameA+"-ODF-"+parentNameZ,tempPoint,tempPoint1);
						}
					}else if(fromType == "ZY13010499" && toType == "ZY03070403"){
						if(!isVolume){
							delMatrixsLink(link.getClient("code"),"DDF");
						}
						parentNameA = Follower(link.fromNode).parent.getClient("code");
						parentNameZ = link.toNode.parent.parent.parent.getClient("code");
						tempPoint = getLocation(parentNameA);
						tempPoint1 = getLocation(parentNameZ);
					frameserial = link.toNode.parent.parent.getClient("packcode").split("-")[0];
					slotserial =  link.toNode.parent.parent.getClient("packcode").split("-")[1];
					packserial =  link.toNode.parent.parent.getClient("packcode").split("-")[2];
						acPortsA = searchPorts(parentNameA);
					acPortsZ = searchPorts(parentNameZ,frameserial,slotserial,packserial);
						openVoleume("DDF端口(A)","设备端口(Z)",parseInt(link.fromNode.name),parseInt(link.toNode.name),acPortsA,acPortsZ,"",true,"DDF-"+parentNameA +"-equipment-"+parentNameZ,getLocation(parentNameA));
					}else if(fromType == "ZY03070403" && toType == "ZY13010499"){
						if(!isVolume){
							delMatrixsLink(link.getClient("code"),"DDF");
						}
						parentNameA = link.fromNode.parent.parent.parent.getClient("code");
						parentNameZ = Follower(link.toNode).parent.getClient("code");
					frameserial = link.fromNode.parent.parent.getClient("packcode").split("-")[0];
					slotserial = link.fromNode.parent.parent.getClient("packcode").split("-")[1];
					packserial = link.fromNode.parent.parent.getClient("packcode").split("-")[2];
					acPortsA = searchPorts(parentNameA,frameserial,slotserial,packserial);
						acPortsZ = searchPorts(parentNameZ);
						openVoleume("设备端口(A)","DDF端口(Z)",parseInt(link.fromNode.name),parseInt(link.toNode.name),acPortsA,acPortsZ,"",true,"DDF-"+parentNameZ+"-equipment-"+parentNameA,getLocation(parentNameZ));
					}else if((fromType == "ZY03070401" || fromType == "ZY03070402") && toType == "ZY23010499"){
						if(!isVolume){
							delMatrixsLink(link.getClient("code"),"ODF");
						}
						parentNameA = link.fromNode.parent.parent.parent.getClient("code");
						parentNameZ = Follower(link.toNode).parent.getClient("code");
					frameserial = link.fromNode.parent.parent.getClient("packcode").split("-")[0];
					slotserial = link.fromNode.parent.parent.getClient("packcode").split("-")[1];
					packserial = link.fromNode.parent.parent.getClient("packcode").split("-")[2];
					acPortsA = searchPorts(parentNameA,frameserial,slotserial,packserial);
						acPortsZ = searchPorts(parentNameZ);
						openVoleume("设备端口(A)","ODF端口(Z)",parseInt(link.fromNode.name),parseInt(link.toNode.getClient("name")),acPortsA,acPortsZ,"",true,"ODF-"+parentNameZ+"-equipment-"+parentNameA,getLocation(parentNameZ));
					}else if(fromType == "ZY23010499" && (toType == "ZY03070401" || toType == "ZY03070402")){
						if(!isVolume){
							delMatrixsLink(link.getClient("code"),"ODF");
						}
						parentNameA = Follower(link.fromNode).parent.getClient("code");
						parentNameZ =link.toNode.parent.parent.parent.getClient("code");
					frameserial = link.toNode.parent.parent.getClient("packcode").split("-")[0];
					slotserial =  link.toNode.parent.parent.getClient("packcode").split("-")[1];
					packserial =  link.toNode.parent.parent.getClient("packcode").split("-")[2];
					acPortsA = searchPorts(parentNameA);
					acPortsZ = searchPorts(parentNameZ,frameserial,slotserial,packserial);
						openVoleume("ODF端口(A)","设备端口(Z)",parseInt(link.fromNode.getClient("name")),parseInt(link.toNode.name),acPortsA,acPortsZ,"",true,"ODF-"+parentNameA+"-equipment-"+parentNameZ,getLocation(parentNameA));
				}
			}else if(link.getClient("linktype") == "fiber"){
				var porttype1:String = link.fromNode.getClient("porttype");
				var porttype2:String = link.toNode.getClient("porttype");
				var stationA:String;
				var stationZ:String;
				var fiberCode:String;  //光纤ID
				var field:String;
				var odfstationcode:String;
				var odfroomocde:String;
				var apointtype:String;
				var zpointtype:String;
				if(porttype1 == "fiber"){
					fiberCode = link.fromNode.id.toString();
					stationA = Follower(Follower(link.fromNode).host).host.getClient("a_point");
					stationZ = Follower(Follower(link.fromNode).host).host.getClient("z_point");
					apointtype =Follower(Follower(link.fromNode).host).host.getClient("a_pointtype");
					zpointtype =Follower(Follower(link.fromNode).host).host.getClient("z_pointtype");
					odfstationcode = link.toNode.getClient("stationcode");
					odfroomocde = link.toNode.getClient("roomcode");
				}else if(porttype2 == "fiber"){
					fiberCode = link.toNode.id.toString();
					stationA = Follower(Follower(link.toNode).host).host.getClient("a_point");
					stationZ = Follower(Follower(link.toNode).host).host.getClient("z_point");
					apointtype =Follower(Follower(link.toNode).host).host.getClient("a_pointtype");
					zpointtype =Follower(Follower(link.toNode).host).host.getClient("z_pointtype");
					odfstationcode = link.fromNode.getClient("stationcode");
					odfroomocde = link.fromNode.getClient("roomcode");
				}
				if(apointtype == "1"){
					if(stationA == odfstationcode){
						field = "aendodfport";
					}else if(zpointtype == "1"){
						if(stationZ == odfstationcode){
							field = "zendodfport";
						}
					}
				}else if(apointtype == "R"){
					if(stationA ==  odfroomocde){
						field = "aendodfport";
					}else if(zpointtype =="R"){
						if(stationZ ==  odfroomocde){
							field = "zendodfport";
						}
					}
				}else if(apointtype == "2"){
					if(zpointtype == "1"){
						if(stationZ ==  odfstationcode){
							field = "zendodfport";
						}
					}
				}
				
				fiberCode = fiberCode.split("-")[1].toString();
				if(!isVolume){
					ro.delRelationFromFiber(fiberCode,field);
					delFibersLink(fiberCode); 
				}
				markType = "fiber";
				if(fromType == "ZY03070401" || fromType == "ZY03070402"){
					if(!isVolume)
					if(toType == "fiber"){
						parentNameA = link.fromNode.parent.parent.parent.getClient("code");
						parentNameZ = link.toNode.parent.parent.getClient("code");
						frameserial = link.fromNode.parent.parent.getClient("packcode").split("-")[0];
						slotserial = link.fromNode.parent.parent.getClient("packcode").split("-")[1];
						packserial = link.fromNode.parent.parent.getClient("packcode").split("-")[2];
						acPortsA = searchPorts(parentNameA,frameserial,slotserial,packserial);
						acPortsZ = searchPorts(parentNameZ);
						openVoleume("设备端口(A)","光纤端口(Z)",parseInt(link.fromNode.name),parseInt(link.toNode.name),acPortsA,acPortsZ,field+"-z",true);
					}else if(toType == "ZY23010499"){
						markType == "matrix";
						parentNameA = link.fromNode.parent.parent.parent.getClient("code");
						parentNameZ = Follower(link.toNode).host.parent.getClient("code");
						frameserial = link.fromNode.parent.parent.getClient("packcode").split("-")[0];
						slotserial = link.fromNode.parent.parent.getClient("packcode").split("-")[1];
						packserial = link.fromNode.parent.parent.getClient("packcode").split("-")[2];
						acPortsA = searchPorts(parentNameA,frameserial,slotserial,packserial);
						acPortsZ = searchPorts(parentNameZ);
						openVoleume("设备端口(A)","ODF端口(Z)",parseInt(link.fromNode.name),parseInt(link.toNode.getClient("name")),acPortsA,acPortsZ,"",true,"ODF-"+parentNameZ,getLocation(parentNameZ));
							}
					}else if(fromType == "fiber" && toType == "ZY23010499"){
						parentNameA = link.fromNode.parent.parent.getClient("code");
						parentNameZ = Follower(link.toNode).parent.getClient("code");
						openVoleume("光纤端口(A)","ODF端口(Z)",parseInt(link.fromNode.name),parseInt(link.toNode.getClient("name")),searchPorts(parentNameA),searchPorts(parentNameZ),field+"-a",true,"ODF-"+parentNameZ+"-ocable-"+ parentNameA,getLocation(parentNameZ));
					}else if(fromType == "ZY23010499" && toType == "fiber"){
						parentNameA = Follower(link.fromNode).parent.getClient("code");
						parentNameZ = link.toNode.parent.parent.getClient("code");
						openVoleume("ODF端口(A)","光纤端口(Z)",parseInt(link.fromNode.getClient("name")),parseInt(link.toNode.name),searchPorts(parentNameA),searchPorts(parentNameZ),field+"-z",true,"ODF-"+parentNameA+"-ocable-"+parentNameZ,getLocation(parentNameA));
					}
				}
				
				ro.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
					if(!isVolume){
						var bool:Boolean = event.result as Boolean;
						if(bool){
							if(toType == "ZY23010499"){
								setNodeColor(link.toNode,"ODF",false);
							}
							else if(toType == "ZY03070401" || toType == "ZY03070402" || toType == "ZY03070403"){
								setNodeColor(link.toNode,"equipment",false);
							}
							else if(toType == "ZY13010499"){
								setNodeColor(link.toNode,"DDF",false);
							}
							else if(toType == "fiber"){
								setNodeColor(link.toNode,"fiber",false);
							}
							
							if(fromType == "ZY23010499"){
								setNodeColor(link.fromNode,"ODF",false);
							}
							else if(fromType == "ZY03070401" || fromType == "ZY03070402" || fromType == "ZY03070403"){
								setNodeColor(link.fromNode,"equipment",false);
							}
							else if(fromType == "ZY13010499"){
								setNodeColor(link.fromNode,"DDF",false);
							}
							else if(fromType == "fiber"){
								setNodeColor(link.fromNode,"fiber",false);
							}
							
							network.elementBox.removeByID(_tempLinkID);
							Alert.show("操作成功","提示");
							
						}else{
							Alert.show("操作失败","提示");
						}
						dispatchEvent(new Event("RefreshLinesData"));
					}
				});
			}
		}
		
		/**
		 * 此函数用于在NETWORK中按照连线关系绘制连线.
		 *@param LinesData:连线关系数据.
		 *@author luoshuai
		 *@version ver.1.0
		 * */
		public function createMatrixLink(type:String):void{
			var elementa:IElement;
			var elementb:IElement;
			if(type == "DDF"){
				if(DDFLinesData != null && DDFLinesData.length > 0){
					for(var i:int =0;i<DDFLinesData.length;i++){
						elementa = findElementByID(DDFLinesData.getItemAt(i).PORTTYPE1 + "-" + DDFLinesData.getItemAt(i).PORTSERIALNO1);
						elementb = findElementByID(DDFLinesData.getItemAt(i).PORTTYPE2 + "-" + DDFLinesData.getItemAt(i).PORTSERIALNO2);
						if(elementa && elementb){
							removeLinks(elementa.id.toString(),elementb.id.toString());
							var link:Link = createLink(Node(elementa),Node(elementb), 0x005e9b,Consts.LINK_TYPE_PARALLEL);
							link.setClient("linktype","matrix");
							link.setClient("code",elementa.id.toString()+":"+elementb.id.toString());
							link.layerID=layer5.id;
						}
					}
				}
			}else{
				if(ODFLinesData != null && ODFLinesData.length > 0){
					for(var j:int =0;j<ODFLinesData.length;j++){
						elementa = findElementByID(ODFLinesData.getItemAt(j).PORTTYPE1 + "-" + ODFLinesData.getItemAt(j).PORTSERIALNO1);
						elementb = findElementByID(ODFLinesData.getItemAt(j).PORTTYPE2 + "-" + ODFLinesData.getItemAt(j).PORTSERIALNO2);
						if(elementa && elementb){
							removeLinks(elementa.id.toString(),elementb.id.toString());
							var link1:Link = createLink(Node(elementa),Node(elementb), 0x005e9b,Consts.LINK_TYPE_PARALLEL);
							link1.setClient("linktype","matrix");
							link1.setClient("code",elementa.id.toString()+":"+elementb.id.toString());
							link1.layerID=layer5.id;
						}
					}
				}
			}
		}
		
		//绘制光纤与ODF的连线
		public function createFiberLink():void{
			if(FiberLinesData != null && FiberLinesData.length > 0) {
				for(var i:int =0;i<FiberLinesData.length;i++){
					var elementa:IElement = null;
					var elementb:IElement = null;
					var elementc:IElement = null;
					elementa = findElementByID("fiber-" + FiberLinesData.getItemAt(i).fibercode);
					if((FiberLinesData.getItemAt(i).aendodfport != null && FiberLinesData.getItemAt(i).aendodfport != "") && 
						(FiberLinesData.getItemAt(i).zendodfport == null || FiberLinesData.getItemAt(i).zendodfport == "")){  //只有A端有ODF连接关系
						elementb = findElementByID("ZY23010499-" + FiberLinesData.getItemAt(i).aendodfport);
					}else if((FiberLinesData.getItemAt(i).zendodfport != null && FiberLinesData.getItemAt(i).zendodfport != "") &&
					         (FiberLinesData.getItemAt(i).aendodfport == null || FiberLinesData.getItemAt(i).aendodfport == "")){  //只有Z端有ODF连接关系
						elementb = findElementByID("ZY23010499-" + FiberLinesData.getItemAt(i).zendodfport);
					}else if((FiberLinesData.getItemAt(i).aendodfport != null && FiberLinesData.getItemAt(i).aendodfport != "") &&
							  (FiberLinesData.getItemAt(i).zendodfport != null && FiberLinesData.getItemAt(i).zendodfport != "")){  //两端都有关系
						elementb = findElementByID("ZY23010499-" + FiberLinesData.getItemAt(i).aendodfport);
						elementc = findElementByID("ZY23010499-" + FiberLinesData.getItemAt(i).zendodfport);
					}
					if(elementa != null && elementb != null){
						removeLinks(elementa.id.toString(),elementb.id.toString());
						var link:Link = createLink(Node(elementa),Node(elementb), 0x005e9b,Consts.LINK_TYPE_PARALLEL);
						link.setClient("linktype","fiber");
						link.setClient("code",elementa.id.toString()+":"+elementb.id.toString());
						link.layerID=layer5.id; 
					}
					if(elementa != null && elementc != null){
						removeLinks(elementa.id.toString(),elementc.id.toString());
						var link:Link = createLink(Node(elementa),Node(elementc), 0x005e9b,Consts.LINK_TYPE_PARALLEL);
						link.setClient("linktype","fiber");
						link.setClient("code",elementa.id.toString()+":"+elementc.id.toString());
						link.layerID=layer5.id; 
					}
				}
			}
		}
		
		//根据ID查找节点
		private function findElementByID(id:String):Follower{
			for(var i:int = 0; i < network.elementBox.datas.count; i++){
				var element:IElement = network.elementBox.datas.getItemAt(i);
				if(element is Follower && element.layerID == layer3.id){
					var foID:String = StringUtil.trim(String(Follower(element).id));
					if(foID == StringUtil.trim(id))
						return Follower(element);
				}
			}
			return null;
		}
		
		//根据两个端口ID删除连接关系
		private function removeLinks(ID1:String,ID2:String):void{
			for(var i:int = 0; i < network.elementBox.datas.count; i++){
				var element:IElement = network.elementBox.datas.getItemAt(i);
				if(element is Link && element.layerID == layer5.id){
					var portA:String = String(Link(element).getClient("code")).split(":")[0]; //端口ID
					var portZ:String = String(Link(element).getClient("code")).split(":")[1]; //端口ID
					if((portA == ID1 && portZ == ID2) ||(portA == ID2 && portZ == ID1))
						network.elementBox.removeByID(element.id);
				}
			}
		}
		
		/**
		 * 此函数用于在NETWORK中绘制一个设备.
		 *@param EquipPanelWidth:设备面板宽度.
		 *@param EquipPanelHeight:设备面板高度.
		 *@param Graphdata:绘制模块所需数据. 
		 *@author luoshuai
		 *@version ver.1.0
		 * */
		public function CreateEquipmentModule(EquipPanelWidth:int,EquipPanelHeight:int,equipmentModel:EquipmentModule,from:String):void{
			var equipmentName:String;
			var tempPort:String = "";
			var tempSlotserial:String = "";
			var tempPackserial:String = "";
			var tempPortserial:String = "";
			var tempFrameserial:String = "";
			tempPort = searchLinkPort(portcode,porttype,"equipment");
			var eid:String = equipmentModel.EQUIPMENT_DATA.equipcode;
			var vendor:String =equipmentModel.EQUIPMENT_DATA.x_vendor
			var model:String = equipmentModel.EQUIPMENT_DATA.x_model;
			var equippackdata:ArrayCollection = equipmentModel.EQUIPPACK_MODULE_DATA;
			var stationcode:String = equipmentModel.EQUIPMENT_DATA.stationcode;
			selectedTreeItem(eid,"equipment",true);
			
			
			model=model.replace("-","$");
			model=model.replace("/","$"); 
			model=model.replace(" ",""); 
			equipmentName = vendor+"$" + model;
			equippackportdata = equipmentModel.EQUIPPACK_PORT_DATA;
			if(equippackportdata){
				var tempAC:ArrayCollection = new ArrayCollection();
				for(var t:int = 0; t < equippackportdata.length; t++){
					var vmodel:VolumeModel = new VolumeModel();
					vmodel.portcode = equippackportdata[t].logicport;
					vmodel.porttype = equippackportdata[t].y_porttype;
					vmodel.slotserial = equippackportdata[t].slotserial;
					vmodel.packserial = equippackportdata[t].packserial;
					vmodel.portserial = equippackportdata[t].portserial;
					vmodel.frameserial = equippackportdata[t].frameserial;
					vmodel.linecount = equippackportdata[t].linecount;
					tempAC.addItem(vmodel);
					if(vmodel.portcode == tempPort){
						tempSlotserial = vmodel.slotserial;
						tempPackserial = vmodel.packserial;
						tempPortserial = vmodel.portserial;
						tempFrameserial = vmodel.frameserial;
					}
				}
				acAllPorts.addItem({id:eid,data:tempAC});
				var position:int = 0;
				var PositionX:int = 500;
				var PositionY:int = 30;
				delequipArray.sort();
				if(delequipArray.length > 0){
					PositionX = PositionX + delequipArray[0]*40;
					PositionY = PositionY + delequipArray[0]*60;
					position = delequipArray[0]+1;
					delequipArray.splice(0,1);
					equipcount++;
				}else{
					PositionX = PositionX + equipcount*40;
					PositionY = PositionY + equipcount*60;
					equipcount++;
					position =equipcount;
				}
				this.portcounts = equipmentModel.EQUIPMENT_DATA.portcounts;
				equipment = createFollower(equipmentModel.EQUIPMENT_DATA.name_std,equipmentName,"", new Point(PositionX,PositionY),Consts.POSITION_TOP_TOP,"equipment-"+eid);
				equipment.layerID=layer1.id;
				equipment.parent = EquipPanel;
				equipment.host = EquipPanel;
				equipment.setClient("eid",eid);
				equipment.setClient("code",eid);
				equipment.setClient("position",position);
				equipment.setClient("stationcode",stationcode);
				equipment.setClient("type","equipment");
				var myLink:Link;
				for(var j:int=0;j<equippackdata.length;j++)
				{    
					var tempx:int =0;
					if(equippackdata.length == 1)
						tempx = equipment.x+equipment.width/2;
					else if(equippackdata.length == 2)
						tempx = equipment.x+60*j;
					else 
						tempx = equipment.x-60*(equippackdata.length/2-1)+60*j;
					var packName:String =equippackdata.getItemAt(j).frameserial +"框\n" +equippackdata.getItemAt(j).slotserial+"槽-"+equippackdata.getItemAt(j).packserial+"盘";
					var packFo:Follower = createFollower(packName,"PORT_NODE","", new Point(tempx, equipment.y + equipment.height+40),Consts.POSITION_BOTTOMLEFT,
						eid+"-"+equippackdata.getItemAt(j).frameserial+"-"+equippackdata.getItemAt(j).slotserial+"-"+equippackdata.getItemAt(j).packserial);
					packFo.parent = equipment;
					packFo.host = equipment;
					packFo.setClient("eid",eid);
					packFo.setClient("type","equip");
					packFo.setClient("packcode",equippackdata.getItemAt(j).frameserial + "-" + equippackdata.getItemAt(j).slotserial + "-" +equippackdata.getItemAt(j).packserial);
					packFo.setClient("stationcode",stationcode);
					myLink = createLink(equipment, packFo, 0x005e9b);
					myLink.parent = equipment;
					myLink.layerID = layer1.id;
					packFo.layerID = layer1.id;
					if(from == "Initialization"){
						if(tempSlotserial != "" && tempPackserial != "" && tempFrameserial != ""){
							if(tempSlotserial == equippackdata.getItemAt(j).slotserial && tempPackserial == equippackdata.getItemAt(j).packserial && tempFrameserial ==equippackdata.getItemAt(j).frameserial ){
								addPackGrounp(packFo,eid,from,tempPortserial);
							}
						}
					}else
					if(j == 0){
						addPackGrounp(packFo,eid,from);
					}
				}
			}else{
				Alert.show("在该设备下未找相应的盘!","提示");
			}
		}		
		//搜索与端口连接的对端端口 返回色设备口或光纤
		private function searchLinkPort(code:String,fromType:String,toType:String):String{
			var tempPort:String = "";
			if(fromType == "ZY13010499"){    //如果code对应端口类型为DDF口
				if(toType == "equipment"){
					for(var i:int = 0 ; i<DDFLinesData.length;i++){
						if(DDFLinesData.getItemAt(i).PORTSERIALNO1 == code && DDFLinesData.getItemAt(i).PORTTYPE1=="ZY13010499" && 
							DDFLinesData.getItemAt(i).PORTTYPE2 == "ZY03070403"){
							return DDFLinesData.getItemAt(i).PORTSERIALNO2;
						}else if(DDFLinesData.getItemAt(i).PORTSERIALNO2 == code && DDFLinesData.getItemAt(i).PORTTYPE2=="ZY13010499" && 
							DDFLinesData.getItemAt(i).PORTTYPE1 == "ZY03070403"){
							return DDFLinesData.getItemAt(i).PORTSERIALNO1;
						}
					}
				}
			}else if(fromType == "ZY23010499"){   //如果code对应端口类型为ODF口
				if(toType == "equipment"){
					for(var j:int = 0; j<ODFLinesData.length;j++){
						if(ODFLinesData.getItemAt(j).PORTSERIALNO1 == code && ODFLinesData.getItemAt(j).PORTTYPE1 == "ZY23010499" && 
							(ODFLinesData.getItemAt(j).PORTTYPE2 == "ZY03070401" || ODFLinesData.getItemAt(j).PORTTYPE2 == "ZY03070402")){
							return ODFLinesData.getItemAt(j).PORTSERIALNO2;
						}else if(ODFLinesData.getItemAt(j).PORTSERIALNO2 == code && ODFLinesData.getItemAt(j).PORTTYPE2 =="ZY23010499" && 
							(ODFLinesData.getItemAt(j).PORTTYPE1 == "ZY03070401" || ODFLinesData.getItemAt(j).PORTTYPE1 == "ZY03070402")){
							return ODFLinesData.getItemAt(j).PORTSERIALNO1;
						}
					}
				}else if(toType == "fiber"){
					for(var k:int = 0; k < FiberLinesData.length; k++){
						if(FiberLinesData.getItemAt(k).aendodfport == code){
							return FiberLinesData.getItemAt(k).fibercode;
						}else if(FiberLinesData.getItemAt(k).zendodfport == code){
							return FiberLinesData.getItemAt(k).fibercode;
						}
					}
				}
			}
			
			return "";
		}
		
		//绘制分组节点
		private function addPackGrounp(packNode:Follower,name:String,from:String,portserial:String = ""):void{
			var frameserial:String = packNode.getClient("packcode").split("-")[0];
			var slotserial:String = packNode.getClient("packcode").split("-")[1];
			var packserial:String = packNode.getClient("packcode").split("-")[2];
			var acPorts:ArrayCollection = searchPorts(name,frameserial,slotserial,packserial);
			var groupsize:int = acPorts.length % 12 == 0 ? acPorts.length / 12 : (int)(acPorts.length/12) + 1;
			var node:Follower;
			var isRun:Boolean;
			for(var k:int=0;k<groupsize;k++)
			{
				var tempx:int = 0;
				if(groupsize == 1)
					tempx = packNode.x;
				else if(groupsize ==2)
					tempx = packNode.x-15+30*k;
				else
					tempx = packNode.x-(groupsize%2==0?(30*(groupsize/2-1)):(30*(groupsize/2)-15)) + 30*k;
				node = createFollower(k*12+1+"-"+(((k+1)*12)<= acPorts.length?(k+1)*12:acPorts.length),"grounpNode","", new Point(tempx,packNode.y+packNode.height+45),Consts.POSITION_BOTTOM_BOTTOM);
				node.parent = packNode;
				node.host = packNode;
				node.setClient("type","equip");
				node.setClient("stationcode",packNode.getClient("stationcode"));
				var link:Link = createLink(packNode, node, 0x005e9b);
				node.layerID = layer1.id;
				link.layerID= layer1.id;
				link.parent = packNode;
				
				if(from == "Initialization"){
					var tempArr:Array = node.name.split("-");
					if(parseInt(portserial) >= parseInt(tempArr[0]) && parseInt(portserial) <= parseInt(tempArr[1])){
						addPortToFiber(parseInt(tempArr[0])-1,parseInt(tempArr[1]),node,"equipment",name,from);
					}
				}else{
					var tempLength:int;
					if(acPorts.length > 12)
						tempLength = 12;
					else
						tempLength = acPorts.length;
					if(k == 0)
						addPortToFiber(0,tempLength,node,"equipment",name,from);
					}
			}
		}
		
		/**
		 * 此方法是从所有设备中找到某一个设备的某一个盘的所有端口
		 * 三个个参数，id代表设备的名称，slotserial代表机槽序号 packserial机盘序号
		 * 返回一个ArrayCollection
		 * xiezhikui
		 */
		private function searchPorts(id:String,frameserial:String = "", slotserial:String = "",packserial:String = ""):ArrayCollection{
			var returnAC:ArrayCollection = new ArrayCollection();
			for(var i:int=0; i < acAllPorts.length; i++){
				if(id == acAllPorts[i].id){
					var tempAC:ArrayCollection = acAllPorts[i].data as ArrayCollection;
					if(frameserial == "" &&  slotserial == "" && packserial == "")
						return tempAC;
					for each(var obj:Object in tempAC){
						if(obj.frameserial == frameserial && obj.slotserial == slotserial && obj.packserial == packserial){
							returnAC.addItem(obj);
						}
					}
					break;
				}
			}
			return returnAC;
		}
		/**
		 * 此方法是为了同步数组跟界面上显示模块的数量一直
		 * 一个参数，id代表模块的名称
		 * xzk 
		 */
		private function removeModulePorts(id:String):void{
			for(var i:int=0; i < acAllPorts.length; i++){
				if(id == acAllPorts[i].id){
					acAllPorts.removeItemAt(i);
				}
			}
		}
		
		//点击分组时绘制其下端口
		private function networkClickHandler():void{
			if(network.selectionModel.count > 0){
				var follower:Follower = network.selectionModel.selection.getItemAt(0) as Follower;
				if(network.selectionModel.selection.getItemAt(0) is Node  && (Node(network.selectionModel.selection.getItemAt(0)).image == "PORT_NODE" || Node(network.selectionModel.selection.getItemAt(0)).image == "grounpNode")){
					if(follower != null && follower.layerID == layer1.id){
						var type:String = follower.getClient("type");
						var tempArr:Array = follower.name.split("-");
						if(tempArr.length == 2){
							if(type == "fiber"){
								if(Follower(follower.parent).followers){
									removeAllFollower(Follower(follower.parent).followers,"PORT_NODE");
									addPortToFiber(parseInt(tempArr[0])-1,parseInt(tempArr[1]),follower,"fiber",follower.parent.getClient("code"),"Single",this._rotationType);
								}
							}else{
								if(follower.getClient("packcode") == null){
									removeAllFollower(Follower(follower.parent).followers,"grounpNode");
									addPortToFiber(parseInt(tempArr[0])-1,parseInt(tempArr[1]),follower,"equipment",follower.parent.parent.getClient("code"),"Single");
								}else{
									removeAllFollower(Follower(follower.parent).followers,"PORT_NODE");
									addPackGrounp(follower,follower.parent.getClient("code"),"Single");
								}
							}
							network.selectionModel.clearSelection();
						}
					}
				}
			}
		}
		
		
		/**
		 * 此函数用于在NETWORK中绘制一个ODF模块.
		 *@param ModuleName:模块的名称.
		 *@param PositionX:模块的X坐标.
		 *@param PositionY:模块的Y坐标.
		 *@param ModuleWidth:模块宽度. 
		 *@param Graphdata:绘制模块所需数据. 
		 *@author luoshuai
		 *@version ver.1.0
		 * */
		public function CreateODFModule(PositionX:int,PositionY:int,ModuleWidth:int,odfodmmodel:ODMMODULE,from:String):void{
			var odfportModuleData:ArrayCollection = odfodmmodel.ODFODMPORT_DATA;
			var dmmodel:DMModel = odfodmmodel.ODFODM_DATA;
			if(odfportModuleData.length>0)
			{
				var ModuleName:String = odfportModuleData.getItemAt(0).odfodm_name_std;
				var moduleCode:String = odfportModuleData.getItemAt(0).odfodmcode;
				var direction:String = dmmodel.direction;
				selectedTreeItem(moduleCode,"odf",true);
				var tempAC:ArrayCollection = new ArrayCollection();
				for(var t:int = 0; t < odfportModuleData.length; t++){
					var model:VolumeModel = new VolumeModel();
					model.portcode = odfportModuleData[t].odfportcode;
					model.porttype = "ZY23010499";
					model.portserial = odfportModuleData[t].portserial;
					tempAC.addItem(model);
				}
				acAllPorts.addItem({id:moduleCode, data:tempAC});
				var portSize:int = odfportModuleData.length;
				var colcount:int = 12;// 列数
				var rowcount:int =0;
				rowcount =parseInt(dmmodel.rowcount);
				colcount = parseInt(dmmodel.col);
				if(colcount > 0){
					if(rowcount > 0){
						if(colcount * rowcount < portSize || colcount * rowcount > portSize){ 
							if (portSize % colcount == 0){
								rowcount = (int)(portSize / colcount);
							}else{
								rowcount =(int)( portSize / colcount) + 1;
							}
						}
					}else{
						if (portSize % colcount == 0)
							rowcount =(int)( portSize / colcount);
						else
							rowcount =(int)( portSize / colcount) + 1;
					}
					
				}else{
					colcount = 12;
					if (portSize % colcount == 0)
						rowcount = (int)(portSize / colcount);
					else
						rowcount = (int)(portSize / colcount) + 1;
				}
				var pid:int =0;
				var name:int =0;
				var xLocation:int ;
				var yLocation:int;  
				var position:int = 0;
				delodfArray.sort();
				if(PositionX ==0 && PositionY ==0){
					if(delodfArray.length > 0){
						PositionX = 250 + (delodfArray[0]-1)*100;
						PositionY = 350 + (delodfArray[0]-1)*20;
						position = delodfArray[0];
						delodfArray.splice(0,1);
						odfcount++;
					}else{
						PositionX = 250 + odfcount*100;
						PositionY = 350 + odfcount*20;
						odfcount++;
						position =odfcount;
					}
				}else{
					if(delodfArray.length > 0){
						position = delodfArray[0];
						delodfArray.splice(0,1);
					}
					odfcount++;
				}
				var MainPanel:Node ;
				if(rowcount <= 12){
					MainPanel= createFollower(ModuleName, "ODFODM"+rowcount.toString(),"",new Point(PositionX, PositionY),Consts.POSITION_BOTTOM_BOTTOM,"odfodm-"+moduleCode);
				}else{
					MainPanel= createFollower(ModuleName, "","ZY23010499", new Point(PositionX, PositionY),Consts.POSITION_BOTTOM_BOTTOM,"odfodm-"+moduleCode);
				}
				
				MainPanel.setClient("code",moduleCode);
				MainPanel.setClient("position",position);
				MainPanel.setClient("type","odf");
				MainPanel.width = (colcount + 3) * 20;
				MainPanel.height = (rowcount + 1) * 19;
				MainPanel.layerID = layer1.id;
				MainPanel.setStyle(Styles.IMAGE_STRETCH,Consts.STRETCH_FILL);
				if(direction != null && direction != ""){
					var follower:Follower = new Follower();
					follower.image = "";
					follower.icon = "";
					follower.host = MainPanel;
					follower.parent = MainPanel;
					follower.name ="连接方向："+ direction;
					follower.setStyle(Styles.LABEL_POSITION,Consts.POSITION_TOP);
					follower.setLocation(MainPanel.x+MainPanel.width/2-10,PositionY-5);
					follower.layerID = layer3.id;
					dataBox.add(follower);
				}
				var port:Follower;
				var image:String = "";
				var num:int = 1;
				for (var row:int = 0; row < rowcount + 1; row++) {
					for (var col:int = 0; col < colcount + 1; col++) {
						if (row == 0) {
							if(col < colcount){
								port = new Follower();
								port.image="";
								port.icon = "";
								port.name=(col+1).toString();
								port.setStyle(Styles.LABEL_COLOR,ColorKeys.BLACK);
								port.setStyle(Styles.FOLLOWER_ROW_INDEX, 0);
								port.setStyle(Styles.FOLLOWER_COLUMN_INDEX, col);
								port.layerID=layer3.id;
								port.host = MainPanel;
								port.parent = MainPanel;
								port.setLocation(PositionX+42+20*col,PositionY+10);
								port.setStyle(Styles.LABEL_POSITION,Consts.POSITION_TOP);
								port.setSize(18,14);
								dataBox.add(port);
							}
						} else {
							if (col == 0) {
								port = new Follower();
								port.name = String.fromCharCode(row+64);
								port.icon = "";
								port.image = "";
								port.setStyle(Styles.LABEL_COLOR, ColorKeys.WHITE);
								port.setStyle(Styles.FOLLOWER_ROW_INDEX, row);
								port.setStyle(Styles.FOLLOWER_COLUMN_INDEX,col);
								port.setLocation(PositionX+10,PositionY+7+19*row);
								port.setStyle(Styles.LABEL_POSITION,Consts.POSITION_TOPLEFT);
								port.setStyle(Styles.LABEL_BOLD,true);
								port.setStyle(Styles.LABEL_SIZE,14);
								port.layerID=layer3.id;
								port.host = MainPanel;
								port.parent = MainPanel;
								dataBox.add(port);
							} else {
								var count:int = (row - 1) * colcount + (col - 1);
								if (count < portSize) {
									portCount++;
									port = new Follower("ZY23010499-"+odfportModuleData.getItemAt(count).odfportcode);
									port.layerID=layer3.id;
									if (odfportModuleData.getItemAt(count).linecount == 0) {
										image = "odf_port";
									} else if (odfportModuleData.getItemAt(count).linecount == 1) {
										image = "odf_yellow";
									} else if (odfportModuleData.getItemAt(count).linecount == 2) {
										image = "odf_green";
									} else {
										image = "odf_red";
									}
									port.setClient("linecount",odfportModuleData.getItemAt(count).linecount);
									port.icon = image;
									port.image = image;
									port.setStyle(Styles.FOLLOWER_ROW_INDEX,row);
									port.setStyle(Styles.FOLLOWER_COLUMN_INDEX,col);
									port.parent = MainPanel;
									port.host = MainPanel;
									port.setClient("porttype","ZY23010499");
									port.setClient("code",odfportModuleData.getItemAt(count).odfportcode);
									port.setClient("name",num);
									port.setClient("roomcode",dmmodel.roomcode);
									port.setClient("stationcode", dmmodel.stationcode);
									port.setSize(18,14);
									port.layerID = layer3.id;
									port.setLocation(PositionX+20+20*col,PositionY+19*row);
									if(odfportModuleData.getItemAt(count).circuit != null && odfportModuleData.getItemAt(count).circuit != ""){
										port.toolTip=odfportModuleData.getItemAt(count).circuit;
									}
									num++;
									dataBox.add(port);
								}
							}
						}
					}
				}
				PositionX =0;
				PositionY =0;
			}
			if(from == "Initialization"){
				dispatchEvent(new Event("graphicsCompleted"));
			}else{
				createMatrixLink("ODF");
				createFiberLink();
			}
			dispatchEvent(new Event("graphicsModuleCompleted"));
		}
		
		/**
		 * 此函数用于在NETWORK中绘制DDF模块.
		 *@param ModuleName:模块的名称.
		 *@param PositionX:模块的X坐标.
		 *@param PositionY:模块的Y坐标.
		 *@param ModuleWidth:模块宽度. 
		 *@param Graphdata:绘制模块所需数据. 
		 *@author luoshuai
		 *@version ver.1.0
		 * */
		public function CreateDDFModule(PositionX:int,PositionY:int,ModuleWidth:int,ddfddmmodel:DdfDdmModule,from:String):void{
			var dmmodel:DMModel = ddfddmmodel.DDFDDM_DATA;
			var ddfportModuleData:ArrayCollection = ddfddmmodel.DDFDDMPORT_DATA;
			if(ddfportModuleData.length>0)
			{ 
				var moduleName:String = ddfportModuleData.getItemAt(0).ddm_name_std;
				var modelCode:String = ddfportModuleData.getItemAt(0).ddfddmcode;
				var direction:String = dmmodel.direction;
				selectedTreeItem(modelCode,"ddf",true);
				var tempAC:ArrayCollection = new ArrayCollection();
				for(var t:int = 0; t < ddfportModuleData.length; t++){
					var model:VolumeModel = new VolumeModel();
					model.portcode = ddfportModuleData[t].ddfportcode;
					model.portserial =ddfportModuleData[t].portserial;
					model.porttype = "ZY13010499";
					tempAC.addItem(model);
				}
				acAllPorts.addItem({id:modelCode,data:tempAC});
				var portSize:int = ddfportModuleData.length;
				var pid:int =0;
				var name:int =0;
				var xLocation:int ;
				var yLocation:int;
				var rowcount:Number;
				var colcount:Number ;
				rowcount =parseInt(dmmodel.rowcount);
				colcount = parseInt(dmmodel.col);
				if(colcount > 0){
					if(rowcount > 0){
						if(colcount * rowcount < portSize || colcount * rowcount > portSize){ 
							if (portSize % colcount == 0){
								rowcount =(int) (portSize / colcount);
							}else{
								rowcount =(int)( portSize / colcount) + 1;
							}
						}
					}else{
						if (portSize % colcount == 0)
							rowcount = (int)(portSize / colcount);
						else
							rowcount =(int)( portSize / colcount) + 1;
					}
					
				}else{
					colcount = 8;
					if (portSize % colcount == 0)
						rowcount =(int) (portSize / colcount);
					else
						rowcount =(int)( portSize / colcount) + 1;
				}
				var position:int = 0;
				delddfArray.sort();
				if(PositionX ==0 && PositionY ==0){
					if(delddfArray.length > 0){
						PositionX = 100 + (delddfArray[0]-1)*110;
						PositionY = 378 + (delddfArray[0]-1)*30;
						position = delddfArray[0];
						delddfArray.splice(0,1);
						ddfcount++;
					}else{
						PositionX = 100 + ddfcount*110;
						PositionY = 378 + ddfcount*30;
						ddfcount++;
						position =ddfcount;
					}
				}else{
					if(delddfArray.length>0){
						position = delddfArray[0];
						delddfArray.splice(0,1);
					}
					ddfcount++;
				}
									
				var panel:Follower = createFollower("", "DDF_BG_S", "", new Point(PositionX, PositionY), Consts.POSITION_BOTTOM_BOTTOM,"ddfddm-"+modelCode);
				panel.setStyle(Styles.IMAGE_STRETCH, Consts.STRETCH_FILL);
				panel.layerID = layer1.id;
				panel.name = moduleName;
				panel.setClient("code",modelCode);
				panel.setClient("position",position);
				panel.setClient("type","ddf");
				panel.width =30*(colcount+1)-10;
				panel.height = rowcount*52;
				panel.setStyle(Styles.IMAGE_STRETCH,Consts.STRETCH_FILL);
				if(direction != null && direction != ""){
					var follower:Follower = new Follower();
					follower.image = "";
					follower.icon = "";
					follower.host = panel;
					follower.parent = panel;
					follower.name ="连接方向："+ direction;
					follower.setStyle(Styles.LABEL_POSITION,Consts.POSITION_TOP);
					follower.setLocation(panel.x+panel.width/2-10,PositionY-2);
					follower.layerID = layer3.id;
					dataBox.add(follower);
				}
				for(var i:int=0;i < rowcount;i++)
				{
					for(var j:int =0;j<colcount;j++){
						var mark:int = pid++;
						if(ddfportModuleData.length > mark){
							var pccode:String = ddfportModuleData.getItemAt(mark).ddfportcode;
							xLocation = PositionX + 7 + j * 30;
							yLocation = PositionY + 18 + i * 50;
							portCount++;
							var ports:Follower = createFollower("", "", "ZY13010499", new Point(xLocation, yLocation), Consts.POSITION_BOTTOMLEFT,"ZY13010499-"+pccode);
							if (ddfportModuleData.getItemAt(mark).linecount == 0)
								ports.image = "DDF_PORT";
							else if (ddfportModuleData.getItemAt(mark).linecount == 1)
								ports.image = "ddf_yellow";
							else if (ddfportModuleData.getItemAt(mark).linecount == 2)
								ports.image = "ddf_green";
							else
								ports.image = "ddf_red";
							ports.setClient("linecount",ddfportModuleData.getItemAt(mark).linecount);
							ports.setClient("code",pccode);
							ports.setClient("stationcode", dmmodel.stationcode);
							ports.name = (++name).toString();
							ports.setStyle(Styles.LABEL_POSITION,Consts.POSITION_TOP_TOP);
							ports.layerID=layer3.id;
							ports.host = panel;
							ports.parent = panel;
							if(ddfportModuleData.getItemAt(mark).realycircuit != null && ddfportModuleData.getItemAt(mark).realycircuit != ""){
								ports.toolTip=ddfportModuleData.getItemAt(mark).realycircuit;
							}else if(ddfportModuleData.getItemAt(mark).circuit != null && ddfportModuleData.getItemAt(mark).circuit != ""){
								ports.toolTip=ddfportModuleData.getItemAt(mark).circuit;
							}else{
								ports.toolTip="";	
							}
						}
					}
				}
				PositionX =0;
				PositionY =0;
			}
			if(from == "Initialization"){
				dispatchEvent(new Event("graphicsCompleted"));
			}else{
				createMatrixLink("DDF");
			}
			dispatchEvent(new Event("graphicsModuleCompleted"));
		}
		
		/**
		 * 此函数用于在NETWORK中绘制一个光缆的模块.
		 *@param PositionX:模块的X坐标.
		 *@param PositionY:模块的Y坐标.
		 *@param ModuleWidth:模块宽度. 
		 *@param Graphdata:绘制模块所需数据. 
		 *@author luoshuai
		 *@version ver.1.0
		 * */
		public function CreateFiberModule(PositionX:int,PositionY:int,ModuleWidth:int,ogmdata:OcableGraphicModule,rotationType:String,from:String):void{
			this._rotationType = rotationType;
			var fibermodule:FiberModule = new FiberModule();
			fibermodule =  ogmdata.FIBER_MODULE_DATA; //光缆信息
			fiberdata = ogmdata.FIBER_DATA;		   //光纤信息
			var ocableCode:String = fibermodule.ocableCode;		   //光缆编码
			var tempPort:String = searchLinkPort(portcode,porttype,"fiber");
			var tempPortserial:String = "";
			selectedTreeItem(ocableCode,"ocable",true);
			delocableArray.sort();   //排序
			var position:int = 0;
			if(delocableArray.length > 0){
				PositionX = PositionX + delocableArray[0]*40;
				PositionY = PositionY + delocableArray[0]*60;
				position = delocableArray[0]+1;
				delocableArray.splice(0,1);
				ocablecount++;
			}else{
				PositionX = PositionX + ocablecount*40;
				PositionY = PositionY + ocablecount*60;
				ocablecount++;
				position =ocablecount;
			}
			var tempAC:ArrayCollection = new ArrayCollection();
			for(var t:int = 0; t < fiberdata.length; t++){
				var model:VolumeModel = new VolumeModel();
				model.portcode = fiberdata[t].fiberCode;
				model.portserial = fiberdata[t].fiberSerial;
				model.porttype = "fiber";
				model.linecount = fiberdata[t].linecount;
				tempAC.addItem(model);
				if(tempPort == model.portcode){
					tempPortserial = model.portserial;
				}
			}
			acAllPorts.addItem({id:ocableCode,data:tempAC});
			var equipment:Follower = createFollower(fibermodule.name_std,"guanglan"+rotationType,"", new Point(PositionX+100,PositionY+10),Consts.POSITION_TOP_TOP,"ocable-"+ocableCode);
			equipment.layerID=layer1.id;
			equipment.setClient("a_point",fibermodule.a_point);
			equipment.setClient("z_point",fibermodule.z_point);
			equipment.setClient("a_pointtype",fibermodule.a_pointtype);
			equipment.setClient("z_pointtype",fibermodule.z_pointtype);
			equipment.setClient("type","ocable");
			equipment.setClient("ocablecode",ocableCode);
			equipment.setClient("code",ocableCode);
			equipment.setClient("position",position);
			
			var groupsize:int = fiberdata.length%12==0?fiberdata.length/12:(int)(fiberdata.length/12)+1;
			var node:Follower;
			var isRun:Boolean;
			var tempX:int;
			var tempY:int;
			for(var j:int=0;j<groupsize;j++)
			{
				if(rotationType == "Down"){
					if(groupsize == 1){
						tempX = equipment.x ;
					}else if(groupsize == 2){
						tempX = equipment.x - 25 + 50 * j;
					}else{
						tempX = equipment.x - 50*groupsize/2+25 + 50 * j;
					}
					tempY = equipment.y + equipment.height + 40;
				}else if(rotationType == "Up"){
					if(groupsize == 1){
						tempX = equipment.x ;
					}else if(groupsize == 2){
						tempX = equipment.x - 25 + 50 * j;
					}else{
						tempX = equipment.x - 50*groupsize/2+25 + 50 * j;
					}
					tempY = equipment.y + equipment.height + 40;
				}else if(rotationType == "Left"){
					
				}else{
					
				}
				node = createFollower(j*12+1+"-"+(((j+1)*12)<= fiberdata.length?(j+1)*12:fiberdata.length),"PORT_NODE","fiber", new Point(tempX,tempY),Consts.POSITION_BOTTOM_BOTTOM,ocableCode+"-"+
										(j*12+1)+"-"+(((j+1)*12)<= fiberdata.length?(j+1)*12:fiberdata.length));
				node.host = equipment;
				node.parent = equipment;
				node.setClient("type","fiber");
				var myLink:Link = createLink(equipment, node, 0x005e9b);
				node.layerID = layer1.id;
				myLink.layerID= layer1.id;
				if(!isRun){
					if(from == "Initialization"){
						var tempArr:Array = node.name.split("-");
						if(parseInt(tempPortserial) >= parseInt(tempArr[0]) && parseInt(tempPortserial) <= parseInt(tempArr[1])){
							isRun = true;
							addPortToFiber(parseInt(tempArr[0])-1,parseInt(tempArr[1]),node,"fiber",ocableCode,from,rotationType);
						}
					}else{
						isRun = true;
						var tempLength:int;
						if(fiberdata.length > 12)
							tempLength = 12;
						else
							tempLength = fiberdata.length;
						addPortToFiber(0,tempLength,node,"fiber",ocableCode,from,rotationType);
					}
				}
			}
		}
		
		//绘制设备端口或光纤口
		private function addPortToFiber(startIndex:int,endIndex:int,node:Node,mark:String,name:String,from:String,rotationType:String=""):void{
			var tempInt:int = 0;
			var acPorts:ArrayCollection;
			if(mark == "fiber"){
				acPorts = searchPorts(name);
			}else{
				var frameserial:String = node.parent.getClient("packcode").split("-")[0];
				var slotserial:String = node.parent.getClient("packcode").split("-")[1];
				var packserial:String = node.parent.getClient("packcode").split("-")[2];
				acPorts = searchPorts(name,frameserial,slotserial,packserial);
			}
			var tempX:int;
			var tempY:int;
			var distinct:int = endIndex - startIndex;
			for(var i:int = startIndex ; i < endIndex; i++)
			{   
				var port:int = i+1;
				var follower:Follower;
				portCount++;
				if(mark == "fiber"){
					if(rotationType == "Down"){
						if(distinct == 1){
							tempX =  node.x;
						}else if(distinct == 2){
							tempX =  node.x + 30 * tempInt -15;
						}else{
							tempX =node.x - 30*(distinct/2)+15 + 30*tempInt;
						}
						tempY = node.y + 60;
					}else if(rotationType == "Up"){
						tempX = 40 * tempInt + node.x - 100;
						tempY = node.y - 50;
					}
					follower = createFollower(port.toString(),"","fiber", new Point(tempX,tempY),Consts.POSITION_TOPRIGHT,"fiber-"+acPorts.getItemAt(i).portcode);
					if(acPorts.getItemAt(i).linecount == "0"){
						follower.image = "PORTIcon";
						
					}else if(acPorts.getItemAt(i).linecount == "1"){
						follower.image = "PORTYELLOW";
						
					}else if(acPorts.getItemAt(i).linecount == "2"){
						follower.image ="PORTGREEN";
						
					}else{
						follower.image="PORTRED";
					}
				}else{
					var porttype:String = acPorts.getItemAt(i).porttype;
					port = acPorts.getItemAt(i).portserial;
					if(distinct == 1){
						tempX =  node.x;
					}else if(distinct == 2){
						tempX =  node.x + 30 * tempInt -15;
					}else{
						tempX =node.x - 30*(distinct/2)+15 + 30*tempInt;
					}
					follower = createFollower(port.toString(),"",porttype, new Point(tempX,node.y + 60),Consts.POSITION_TOPRIGHT,porttype+"-"+acPorts.getItemAt(i).portcode);
					follower.setClient("stationcode",node.getClient("stationcode"));
					if(acPorts.getItemAt(i).porttype == "ZY03070403"){
						if(acPorts.getItemAt(i).linecount == "0"){
							follower.image = "PORT_RECT";
							
						}else if(acPorts.getItemAt(i).linecount == "1"){
							follower.image = "PORT_RECT_YELLOW";
							
						}else if(acPorts.getItemAt(i).linecount == "2"){
							follower.image ="PORT_RECT_GREEN";
							
						}else{
							follower.image="PORT_RECT_RED";
						}
					}else{
						if(acPorts.getItemAt(i).linecount == "0"){
							follower.image = "PORTIcon";
							
						}else if(acPorts.getItemAt(i).linecount == "1"){
							follower.image = "PORTYELLOW";
							
						}else if(acPorts.getItemAt(i).linecount == "2"){
							follower.image ="PORTGREEN";
							
						}else{
							follower.image="PORTRED";
						}
					}
					
				}
				follower.setStyle(Styles.LABEL_XOFFSET,-1);
				follower.setStyle(Styles.LABEL_YOFFSET,-5);
				follower.setClient("code",acPorts.getItemAt(i).portcode);
				follower.setClient("linecount",acPorts.getItemAt(i).linecount);
				follower.host = node;
				follower.parent = node;
				follower.layerID = layer3.id;
				var link:Link = createLink(node, follower, 0x005e9b);
				link.layerID= layer1.id;
				link.parent = node;
				tempInt++;
			}
			if(from == "Initialization"){
				dispatchEvent(new Event("graphicsCompleted"));
			}else{
				createMatrixLink("ODF");
				createMatrixLink("DDF");
				createFiberLink();
			}
		}
		
		
		/**
		 * 此函数用于在NETWORK中添加更多模块.
		 *@param mcode:模块的编号.
		 *@param type:模块的类型.
		 *@author luoshuai
		 *@version ver.1.0
		 * */
		public function addMoreModules(mcode:String,type:String,point:Point):void{
			this.tempPoint = point;
			var rtobj:RemoteObject = new RemoteObject("wireConfiguration");
			rtobj.endpoint = ModelLocator.END_POINT;
			if(type=="ODF")
			{
				rtobj.addEventListener(ResultEvent.RESULT,getODFMuduleHandler);
				rtobj.getODFMudule(mcode);
			}else if(type=="DDF")
			{
				rtobj.addEventListener(ResultEvent.RESULT,getDDFModuleHandler);
				rtobj.getDDFModule(mcode);
			}else if(type=="equipment")
			{
				rtobj.addEventListener(ResultEvent.RESULT,getEquipmentHandler);
				rtobj.getEquipment(mcode);
			}else if(type=="ocable")
			{
				rtobj.addEventListener(ResultEvent.RESULT,getFibersHandler);
				rtobj.getFibers(mcode);//根据光缆编号获取光纤
			}
		}
		
		/**
		 *光缆监听函数
		 * */
		private function getFibersHandler(event:ResultEvent):void{
			var wcgd:wireConfigurationGraphicsDataModule = event.result as wireConfigurationGraphicsDataModule;
			if(wcgd.OGM_DATA.length > 0){
				for(var i:int=0;i<wcgd.OGM_DATA.length;i++)
				{
					var ocablename:String = wcgd.OGM_DATA.getItemAt(i).FIBER_MODULE_DATA.name_std;
					if(isExist("ocable-"+wcgd.OGM_DATA.getItemAt(i).FIBER_MODULE_DATA.ocableCode,"id"))  //查找光缆是否存在  建议用编号查询
					{
						setFiberLineCount(wcgd.OGM_DATA.getItemAt(i).FIBER_DATA);   //如果已经存在则更新光纤口连接数并更新口的颜色
					}else
					{
						this.CreateFiberModule(200,30,276,wcgd.OGM_DATA.getItemAt(i) as OcableGraphicModule,"Down","Single");  //添加光缆到图形中
					}
				}
			}
		}
		
		
		//更改光纤连接数量
		private function setFiberLineCount(fiberdata:ArrayCollection):void{
			if(fiberdata){
				for(var i:int = 0; i < fiberdata.length; i++){
					
					for(var j:int=0; j < acAllPorts.length; j++){
						var tempAC:ArrayCollection = acAllPorts[j].data as ArrayCollection;
						for each(var obj:Object in tempAC){
							if(obj.portcode == fiberdata[i].fiberCode){
								obj.linecount = fiberdata[i].linecount;
								var follower:Follower =elementBox.getElementByID("fiber-" + obj.portcode) as Follower;
								if(follower != null){
									follower.image = obj.linecount == "0" ? "PORTIcon":obj.linecount == "1" ? "PORTYELLOW":obj.linecount == "2" ? "PORTGREEN":"PORTRED"; 
									follower.setClient("linecount",obj.linecount);
								}
							}
						}
					}
				}
			}
		}
		
		
		/**
		 *设备监听函数
		 * */
		private function getEquipmentHandler(event:ResultEvent):void{
			var wcgd:wireConfigurationGraphicsDataModule = event.result as wireConfigurationGraphicsDataModule;
			for(var i:int =0;i<wcgd.EQUIPMENT_MODULE_DATA.length;i++)
			{
				if(isExist("equipment-"+wcgd.EQUIPMENT_MODULE_DATA.getItemAt(i).EQUIPMENT_DATA.equipcode,"id"))  //查找设备是否存在  建议用编号查询
				{
					setEquipPortLineCount(wcgd); //如果设备已经存在则更新端口连接数量和端口颜色
				}else
				{
					this.CreateEquipmentModule(500,220,wcgd.EQUIPMENT_MODULE_DATA.getItemAt(i) as EquipmentModule,"Single");  //添加设备到图形中
				}
			}
		}
		
		//更改设备端口连接数量
		private function setEquipPortLineCount(wcgd:wireConfigurationGraphicsDataModule):void{
			var equipmentModuleData:ArrayCollection = wcgd.EQUIPMENT_MODULE_DATA;
			equippackportdata = equipmentModuleData.getItemAt(i).EQUIPPACK_PORT_DATA;
			if(equippackportdata){
				for(var i:int = 0; i < equippackportdata.length; i++){
					
					for(var j:int=0; j < acAllPorts.length; j++){
						var tempAC:ArrayCollection = acAllPorts[j].data as ArrayCollection;
						for each(var obj:Object in tempAC){
							if(obj.portcode ==equippackportdata[i].logicport){
								obj.linecount = equippackportdata[i].linecount;
								var follower:Follower =elementBox.getElementByID(obj.porttype+"-"+ obj.portcode) as Follower;
								if(follower != null){
									if(equippackportdata[i].y_porttype =="ZY03070403"){
										follower.image = obj.linecount == "0" ? "PORT_RECT":obj.linecount == "1" ? "PORT_RECT_YELLOW":obj.linecount == "2" ? "PORT_RECT_GREEN":"PORT_RECT_RED";
									}else{
										follower.image = obj.linecount == "0" ? "PORTIcon":obj.linecount == "1" ? "PORTYELLOW":obj.linecount == "2" ? "PORTGREEN":"PORTRED";
									}
									follower.setClient("linecount",obj.linecount);
								}
							}
						}
					}
				}
			}
		}
		
		
		
		
		/**
		 *ODF监听函数
		 * */
		private function getODFMuduleHandler(event:ResultEvent):void{
			var wcgd:wireConfigurationGraphicsDataModule = event.result as wireConfigurationGraphicsDataModule;
			if(wcgd.ODFODM_MODULE_DATA.length > 0){
				var odfmoduleName:String = wcgd.ODFODM_MODULE_DATA.getItemAt(0).ODFODM_DATA.dmname_std;
				if(isExist("odfodm-"+wcgd.ODFODM_MODULE_DATA.getItemAt(0).ODFODM_DATA.code,"id"))
					this.removeModule(odfmoduleName,"name","odf");
				addMatrixLines(wcgd.ODF_LINES_DATA,ODFLinesData);
				addFiberLines(wcgd.FIBER_LINES_DATA,FiberLinesData);
				this.CreateODFModule(tempPoint.x,tempPoint.y,300,wcgd.ODFODM_MODULE_DATA.getItemAt(0) as ODMMODULE,"Single");
			}
		}
		
		//添加MATRIX关系到ODFLinesData或DDFLinesData集合中
		private function addMatrixLines(source:ArrayCollection,destination:ArrayCollection):void{
			for(var i:int = 0; i < source.length; i++){
				if(!forEachMatrix(source[i].PORTSERIALNO1,source[i].PORTSERIALNO2,source[i].PORTTYPE1,source[i].PORTTYPE2, destination))
					destination.addItem(source[i]);
			}
		}
		
		//添加光纤关系到FiberLinesData中
		private function addFiberLines(source:ArrayCollection,destination:ArrayCollection):void{
			for(var i:int = 0; i < source.length; i++){
				if(!forEachFiber(source[i].fibercode,destination,source[i].aendodfport,source[i].zendodfport,source[i].aodfportname,source[i].zodfportname)){  
					destination.addItem(source[i]); 				 //添加新查询的数据
				}else{												  //如果在集合中找到该光纤 更新两端ODF数据
					destination.addItem(source[i]); 
				}
			}
		}
		
		//查找MATRIX关系是否存在
		private function forEachMatrix(no1:String,no2:String,type1:String,type2:String,destination:ArrayCollection):Boolean{
			var isExists:Boolean;
			for(var j:int = 0; j < destination.length; j++){
				if((no1 == destination[j].PORTSERIALNO1 && type1 == destination[j].PORTTYPE1 && no2 == destination[j].PORTSERIALNO2 && type2 == destination[j].PORTTYPE2)||
				   (no2 == destination[j].PORTSERIALNO1 && type2 == destination[j].PORTTYPE1 && no1 == destination[j].PORTSERIALNO2 && type1 == destination[j].PORTTYPE2) ){
					isExists = true;
					break;
				}
			}
			return isExists;
		}
		
		//查找光纤是否存在
		private function forEachFiber(fibercode:String,destination:ArrayCollection,aodfport:String,zodfport:String,aodfname:String,zodfname:String):Boolean{
			var isExists:Boolean;
			for(var i:int=0;i<destination.length;i++){
				if(fibercode == destination[i].fibercode){  //如果存在 更新它与ODF连接关系 而不删除
//					destination[i].aendodfport = aodfport;
//					destination[i].zendodfport = zodfport;
//					destination[i].aodfportname = aodfname;
//					destination[i].zodfportname = zodfname;
					destination.removeItemAt(i);
					isExists = true;
					break;
				}
			}
			return isExists;
		}
		
		/**
		 *DDF监听函数
		 * */
		private function getDDFModuleHandler(event:ResultEvent):void{
			var wcgd:wireConfigurationGraphicsDataModule = event.result as wireConfigurationGraphicsDataModule;
			if(wcgd.DDFDDM_MODULE_DATA.length > 0){
				var ddfmoduleName:String = wcgd.DDFDDM_MODULE_DATA.getItemAt(0).DDFDDM_DATA.dmname_std;
				if(isExist("ddfddm-"+wcgd.DDFDDM_MODULE_DATA.getItemAt(0).DDFDDM_DATA.code,"id"))
					this.removeModule(ddfmoduleName,"name","ddf");
				addMatrixLines(wcgd.DDF_LINES_DATA,DDFLinesData);
				this.CreateDDFModule(tempPoint.x,tempPoint.y,300,wcgd.DDFDDM_MODULE_DATA.getItemAt(0) as DdfDdmModule,"Single");
			}
		}
		
		/**
		 * 此函数用于判断某个模块是否存在.
		 *@param name:此模块的标识.
		 *@author luoshuai
		 *@version ver.1.0
		 * */
		private function isExist(markValue:String,property:String,clientType:String=null):Boolean{
			var flag:Boolean = false;
			var nameFilder:QuickFinder = new QuickFinder(this.elementBox,property,clientType);
			var datas:Array = nameFilder.find(markValue);
			if(datas.length>0)
			{
				flag = true;
			}
			return flag;
		}
		
		/**
		 * 此函数用于从NETWORK中删除某个模块.
		 *@param markValue:查找这个模块的标识.
		 *@param property:按照此属性查找.
		 *@param clientType:属性的类型.
		 *@author luoshuai
		 *@version ver.1.0
		 * */
		private function removeModule(markValue:String,property:String,module:String,clientType:String=null,flag:Boolean=false):void{
			var nameFilder:QuickFinder =new QuickFinder(this.elementBox,property,clientType);
			var datas:Array = nameFilder.find(markValue);
			for(var i:int=0;i<datas.length;i++)
			{
				this.elementBox.remove(datas[i]);
				var node:Node = datas[i] as Node;
				var j:int =0;
				if(module =="ddf"){
					j = delddfArray.length ;
					delddfArray[j] = node.getClient("position");
					ddfcount--;
				}else if(module =="odf"){
					j = delodfArray.length ;
					delodfArray[j] = node.getClient("position");
					odfcount--;
				}else if(module =="equipment"){
					j = delequipArray.length ;
					delequipArray[j] = node.getClient("position")-1;
					equipcount--;
				}else if(module == "ocable"){
					j = delocableArray.length ;
					delocableArray.push(node.getClient("position")-1);
					ocablecount--;
				}
			}
		}
		
		private function removeAllFollower(followers:ICollection,type:String):void{
			for(var i:int = 0; i < followers.count; i ++){
				var fo:Follower = followers.getItemAt(i);
				if(fo.image == type){
					network.elementBox.selectionModel.clearSelection();
					network.elementBox.selectionModel.selection.addAll(fo.followers);
					network.elementBox.removeSelection();
				}
			}
		}
		
		//获取左侧资源树
		public function generateWireTree(event:ResultEvent):void
		{
			folderList = new XMLList(event.result.toString());
			folderCollection=new XMLList(folderList); 
			reTreeWire.dataProvider = folderCollection;
			if(folderCollection.length() > 0){
				stationCode = folderCollection[0].@id;
			}
			selectedTreeItem(this.dmcode,this.porttype == "ZY23010499"?"odf":"ddf",true);
		}
		
		//设置ID的节点为选中状态
		private function selectedTreeItem(id:String,type:String,isSelected:Boolean):void{
			for each(var element:XML in folderList.elements())
			{
				for each(var dmelement:XML in element.children())
				{
					if(dmelement.@id == id)
					{
						this.reTreeWire.selectedItem=dmelement;
						if(isSelected){
							if(dmelement.@checked!='1')
							{
								dmelement.@checked="1";
								reTreeWire.validateNow();
								this.reTreeWire.expandItem(element.parent(),true);
								this.reTreeWire.expandChildrenOf(element,true);
							}
							break;
						}else{
							if(dmelement.@checked == '1')
							{
								dmelement.@checked="0";
								reTreeWire.validateNow();
							}
						}
					}
				}
			}
		}
		
		
		//点击展开树
		public function tree_itemClick(evt:ListEvent):void
		{
			var item:Object = Tree(evt.currentTarget).selectedItem;
			if (reTreeWire.dataDescriptor.isBranch(item)) {
				reTreeWire.expandItem(item, !reTreeWire.isItemOpen(item), true);
			}
		}
		/**
		 *函数用于相应树中CHECKBOX的选中事件.
		 *@author luoshuai
		 *@version ver.1.0
		 * */
		public function treeCheck(e:Event):void
		{
			var dmcode:String;
			var dmname:String;
			if(e.target is CheckBox){
				if(e.target.hasOwnProperty('selected'))
				{
					if(e.target.selected)
					{
						if(reTreeWire.selectedItem.@leaf ==true)
						{
							dmcode = reTreeWire.selectedItem.@id;
							var dmtype:String = reTreeWire.selectedItem.@type;
							if(reTreeWire.selectedItem.@type=='ODF')
								this.addMoreModules(dmcode,dmtype,new Point(0,0));
							else if(reTreeWire.selectedItem.@type=='DDF')
								this.addMoreModules(dmcode,dmtype,new Point(0,0));
								//							else if(reTreeWire.selectedItem.@type=='VDF')
							else if(reTreeWire.selectedItem.@type=='equipment')
								this.addMoreModules(dmcode,dmtype,new Point(500,220));
							else if(reTreeWire.selectedItem.@type=='ocable')
								this.addMoreModules(dmcode,dmtype,new Point(300,30));
						}
					}else{
						dmcode = reTreeWire.selectedItem.@id;
						dmname = reTreeWire.selectedItem.@name;
						this.removeModulePorts(dmcode);
						if(reTreeWire.selectedItem.@type=='ODF'){
							this.removeModule(dmcode,"code","odf",twaver.Consts.PROPERTY_TYPE_CLIENT,true);
						}else if(reTreeWire.selectedItem.@type=='DDF'){
							this.removeModule(dmcode,"code","ddf",twaver.Consts.PROPERTY_TYPE_CLIENT);
						}else if(reTreeWire.selectedItem.@type=='VDF'){
							
						}else if(reTreeWire.selectedItem.@type=='equipment'){
							this.removeModule(dmcode,"code","equipment",twaver.Consts.PROPERTY_TYPE_CLIENT);
						}else if(reTreeWire.selectedItem.@type=='ocable'){
							this.removeModule(dmcode,"code","ocable",twaver.Consts.PROPERTY_TYPE_CLIENT);
						}
					}
				}
			}
		}
		
		private function readXMLCollection(node:XMLListCollection,name:String):void {
			for each (var element:XML in node.elements()) {		
				for each(var child:XML in element.elements()){
					if(child.@leaf==true){
						if(child.@name==name){
							child.@checked = "0";
						}
					}
				}
			}
		}
		
		//用于绘制ODF模块时用
		public function createGrid(row:Number,column:Number, image:String, point_x:Number, point_y:Number,labelPosition:String = null):Grid{
			var grid:Grid = new Grid();
			grid.setStyle(Styles.GRID_COLUMN_COUNT,column);
			grid.setStyle(Styles.GRID_ROW_COUNT,row);
			grid.setStyle(Styles.GRID_BORDER,1);
			grid.setStyle(Styles.GRID_DEEP, 0);
			grid.setStyle(Styles.GRID_PADDING,0);
			grid.setStyle(Styles.GRID_CELL_DEEP,0);
			grid.setSize(column*20,row*20);
			grid.setLocation(point_x,point_y);
			grid.setStyle(Styles.GRID_FILL_ALPHA,0);
			elementBox.add(grid);
			return grid;
		}
		
		//创建节点
		public function createNode(name:String, image:String, location:Point, labelPosition:String = null,grid:Grid=null):Node{
			var node:Node = new Node();
			node.name = name;
			node.image = image;
			node.location = location;
			if(labelPosition){
				node.setStyle(Styles.LABEL_POSITION, labelPosition);
			}
			dataBox.add(node);
			if(grid!=null)
			{
				dataBox.add(grid);
				grid.host = node;
			}
			return node;
		}
		
		//创建跟随节点
		public function createFollower(name:String, image:String, type:String, location:Point, labelPosition:String = null,id:Object = null):Follower{
			var follower:Follower;
			if(id)
				follower = new Follower(id);
			else
				follower = new Follower();
			follower.name = name;
			follower.image = image;
			follower.location = location;
			follower.setClient("porttype",type);
			if(labelPosition){
				follower.setStyle(Styles.LABEL_POSITION, labelPosition);
			}
			if(!dataBox.getDataByID(id))
				dataBox.add(follower);
			else
				Alert.show("生成过程中出现错误,请检查端口数据!错误码:"+id.toString(),"提示");
			return follower;
		}
		
		//创建连线
		private function createLink(from:Node, to:Node, color:uint, linkType:String = null,linkFromPosition:String = null,name:String = null, dashed:Boolean = false, labelPosition:String = null, lineWidth:int = 2):Link{
			var link:Link = new Link(from,to);
			link.setStyle(Styles.LINK_COLOR, color);
			link.setStyle(Styles.LINK_BUNDLE_GAP, -2);
			link.setStyle(Styles.LINK_BUNDLE_OFFSET,-1);
			link.setStyle(Styles.LINK_FROM_POSITION,linkFromPosition);
			
			link.setStyle(Styles.LINK_WIDTH, 2);
			link.setStyle(Styles.BODY_BEVEL, true);
			link.setStyle(Styles.BODY_BEVEL_DISTANCE, 4);
			link.setStyle(Styles.BODY_BEVEL_TYPE, Consts.BEVEL_TYPE_INNER);

			if(linkType == null){
				linkType = Consts.LINK_TYPE_ORTHOGONAL_VERTICAL;
				link.setStyle(Styles.LINK_SPLIT_VALUE, 34);
				link.setStyle(Styles.LINK_CORNER, Consts.LINK_CORNER_NONE);
			}
			link.setStyle(Styles.LINK_TYPE, linkType);
			if(name){
				link.name = name;
			}
			if(dashed){
				link.setStyle(Styles.LINK_PATTERN, [25,10]);
			}
			if(labelPosition){
				link.setStyle(Styles.LABEL_POSITION, labelPosition);
			}
			if(!dataBox.getDataByID(link.id))
				dataBox.add(link);
			return link;
		}
		
		//查看端口关联的资源
		private function showResHandler(event:ContextMenuEvent):void{
			var port:Follower = network.selectionModel.selection.getItemAt(0);	
			portcode = port.getClient("code");
			dmcode = port.parent.getClient("code");
			porttype = port.getClient("porttype");
			var ro:RemoteObject = new RemoteObject("wireConfiguration");
			ro.endpoint = ModelLocator.END_POINT;
			ro.showBusyCursor = true;
			ro.geSelectPortRelation(portcode,dmcode,porttype);
			ro.addEventListener(ResultEvent.RESULT,drawPortRelationHandler);
			if(port.getClient("porttype") =="ZY13010499"){  //选中DDF端口
					
			}else if(port.getClient("porttype") =="ZY23010499"){  //选中ODF端口 
				
			}else if(port.getClient("porttype") =="ZY13010499"){  //选中设备端口 
				
			}else if(port.getClient("porttype") =="fiber"){  //选中光纤
				
			}else if(port.getClient("porttype") =="ZY03070401" ||port.getClient("porttype") =="ZY03070402"|| port.getClient("porttype") =="ZY03070403" ){  //选中设备端口
				
			}else{
				Alert.show("你选中的端口不正确，请重新选中","提示");
			}
		} 
		
		
		private function drawPortRelationHandler(event:ResultEvent):void{
			var wcgd:wireConfigurationGraphicsDataModule = event.result as wireConfigurationGraphicsDataModule;
			
			if(porttype == "ZY13010499"){
				addMatrixLines(wcgd.DDF_LINES_DATA,DDFLinesData);
				for(var i:int=0;i<wcgd.DDFDDM_MODULE_DATA.length;i++){
					if(!isExist("ddfddm-"+wcgd.DDFDDM_MODULE_DATA.getItemAt(i).DDFDDM_DATA.code,"id")){  //用于判断关联资源时是否存在 如果存在 就不重画
						this.CreateDDFModule(0,0,300,wcgd.DDFDDM_MODULE_DATA.getItemAt(i) as DdfDdmModule,"Initialization");
					}
				}
				for(var i:int = 0;i<wcgd.EQUIPMENT_MODULE_DATA.length;i++){
					var tempPort:String = "";
					tempPort = searchLinkPort(portcode,porttype,"equipment");
					if(isExist("equipment-"+wcgd.EQUIPMENT_MODULE_DATA.getItemAt(i).EQUIPMENT_DATA.equipcode,"id")){
						var packport:ArrayCollection = wcgd.EQUIPMENT_MODULE_DATA.getItemAt(i).EQUIPPACK_PORT_DATA ;
						for(var j:int =0; j<packport.length;j++){
							if(tempPort == packport[j].logicport){
								var follower:Follower = this.elementBox.getDataByID(wcgd.EQUIPMENT_MODULE_DATA.getItemAt(i).EQUIPMENT_DATA.equipcode+"-"+packport[j].frameserial+"-"+
									packport[j].slotserial +"-" + packport[j].packserial) as Follower;  //根据ID查找盘
								if(follower != null){
									removeAllFollower(Follower(follower.parent).followers,"PORT_NODE");
									addPackGrounp(follower,wcgd.EQUIPMENT_MODULE_DATA.getItemAt(i).EQUIPMENT_DATA.equipcode,"Initialization",packport[j].portserial);
								}
							}
						}
					}else{
						this.CreateEquipmentModule(500,220,wcgd.EQUIPMENT_MODULE_DATA.getItemAt(i) as EquipmentModule,"Initialization");  //添加设备到图形中
					}
				}
				count = 0;
				createMatrixLink("DDF");
			}else if(porttype == "ZY23010499"){
				addMatrixLines(wcgd.ODF_LINES_DATA,ODFLinesData);
				addFiberLines(wcgd.FIBER_LINES_DATA,FiberLinesData);
				for(var i:int=0; i < wcgd.ODFODM_MODULE_DATA.length;i++){
					if(!isExist("odfodm-"+wcgd.ODFODM_MODULE_DATA.getItemAt(i).ODFODM_DATA.code,"id")){  //用于判断关联资源时是否存在 如果存在 就不重画
						this.CreateODFModule(0,0,300,wcgd.ODFODM_MODULE_DATA.getItemAt(i) as ODMMODULE,"Initialization");
					}
				}
				for(var i:int =0;i<wcgd.OGM_DATA.length;i++){
					var tempPort:String = searchLinkPort(portcode,porttype,"fiber");
					var tempPortserial:String = "";
					var ocableCode:String = wcgd.OGM_DATA.getItemAt(i).FIBER_MODULE_DATA.ocableCode;
					fiberdata = wcgd.OGM_DATA.getItemAt(i).FIBER_DATA;
					if(isExist("ocable-"+ocableCode,"id")){   // 关联资源 如果光缆存在 定位连接的光纤
						for(var j:int = 0; j < fiberdata.length; j++){
							if(fiberdata[j].fiberCode == tempPort){
								var serial:int = parseInt( fiberdata[j].fiberSerial);
								var follower:Follower;
								var start:int = 0;
								var end:int  = 0;
								if(serial%12 ==0 ){  //如果端口序号是12的倍数
									follower = this.elementBox.getDataByID(ocableCode+"-"+(serial-12+1)+"-"+serial) as Follower;
									start  = serial-12;
									end = serial;
								}else {
									start = (int(serial/12))*12;
									end = (int(serial/12)+1)*12 > fiberdata.length?fiberdata.length:((int(serial/12)+1)*12);
									follower = this.elementBox.getDataByID(ocableCode + "-" + (int(serial/12)*12+1)+"-"+((int(serial/12)+1)*12 > fiberdata.length ?fiberdata.length:((int(serial/12)+1)*12))) as Follower;
								}
								if(follower != null){
									removeAllFollower(Follower(follower.parent).followers,"PORT_NODE");
									addPortToFiber(start,end,follower,"fiber",follower.parent.getClient("code"),"Initialization",this._rotationType);
								}
								break;
							}
						}
					}else{
						this.CreateFiberModule(200,30,276,wcgd.OGM_DATA.getItemAt(i) as OcableGraphicModule,"Down","Initialization");  //添加光缆到图形中
					}
				}
				for(var i:int = 0;i<wcgd.EQUIPMENT_MODULE_DATA.length;i++){
					if(isExist("equipment-"+wcgd.EQUIPMENT_MODULE_DATA.getItemAt(i).EQUIPMENT_DATA.equipcode,"id")){
						var packport:ArrayCollection = wcgd.EQUIPMENT_MODULE_DATA.getItemAt(i).EQUIPPACK_PORT_DATA ;
						for(var j:int =0; j<packport.length;j++){
							if(tempPort == packport[j].logicport){
								var follower:Follower = this.elementBox.getDataByID(wcgd.EQUIPMENT_MODULE_DATA.getItemAt(i).EQUIPMENT_DATA.equipcode+"-"+packport[j].frameserial+"-"+
									packport[j].slotserial +"-" + packport[j].packserial) as Follower;  //根据ID查找盘
								if(follower != null){
									removeAllFollower(Follower(follower.parent).followers,"PORT_NODE");
									addPackGrounp(follower,wcgd.EQUIPMENT_MODULE_DATA.getItemAt(i).EQUIPMENT_DATA.equipcode,"Initialization",packport[j].portserial);
								}
							}
						}
					}else{
						this.CreateEquipmentModule(500,220,wcgd.EQUIPMENT_MODULE_DATA.getItemAt(i) as EquipmentModule,"Initialization");  //添加设备到图形中
					}
				}
				count = 0;
				createMatrixLink("ODF");
				createFiberLink();
			}else if(porttype == "ZY03070403"){
				addMatrixLines(wcgd.DDF_LINES_DATA,DDFLinesData);
				for(var i:int=0;i<wcgd.DDFDDM_MODULE_DATA.length;i++){
					if(!isExist("ddfddm-"+wcgd.DDFDDM_MODULE_DATA.getItemAt(i).DDFDDM_DATA.code,"id")){  //用于判断关联资源时是否存在 如果存在 就不重画
						this.CreateDDFModule(0,0,300,wcgd.DDFDDM_MODULE_DATA.getItemAt(i) as DdfDdmModule,"Initialization");
					}
				}
				count = 0;
				createMatrixLink("DDF");
			}else if(porttype == "ZY03070401" || porttype == "ZY03070402"){
				addMatrixLines(wcgd.ODF_LINES_DATA,ODFLinesData);
				for(var i:int=0; i < wcgd.ODFODM_MODULE_DATA.length;i++){
					if(!isExist("odfodm-"+wcgd.ODFODM_MODULE_DATA.getItemAt(i).ODFODM_DATA.code,"id")){  //用于判断关联资源时是否存在 如果存在 就不重画
						this.CreateODFModule(0,0,300,wcgd.ODFODM_MODULE_DATA.getItemAt(i) as ODMMODULE,"Initialization");
					}
				}
				count = 0;
				createMatrixLink("ODF");
			}else if(porttype == "fiber"){
				addFiberLines(wcgd.FIBER_LINES_DATA,FiberLinesData);
				for(var i:int=0; i < wcgd.ODFODM_MODULE_DATA.length;i++){
					if(!isExist("odfodm-"+wcgd.ODFODM_MODULE_DATA.getItemAt(i).ODFODM_DATA.code,"id")){  //用于判断关联资源时是否存在 如果存在 就不重画
						this.CreateODFModule(0,0,300,wcgd.ODFODM_MODULE_DATA.getItemAt(i) as ODMMODULE,"Initialization");
					}
				}
				count = 0;
				createFiberLink();
			}
			
		}
			