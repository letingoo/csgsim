import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.actionscript.Registry;
import common.component.OI_Follower.OI_Follower;
import common.component.OI_Follower.Optical_Interface_Follower;

import flash.display.DisplayObject;
import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.system.Capabilities;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import mx.collections.ArrayCollection;
import mx.containers.TitleWindow;
import mx.controls.Alert;
import mx.core.Application;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.InvokeEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import sourceCode.alarmmgr.model.AlarmMangerModel;
import sourceCode.alarmmgr.views.AlarmManager;
import sourceCode.autoGrid.view.ShowProperty;
import sourceCode.channelRoute.views.ViewChannelroute;
import sourceCode.channelRoute.views.tandemcircuit;
import sourceCode.faultSimulation.titles.InterposeFaultTitle;
import sourceCode.faultSimulation.titles.InterposePortCutTitle;
import sourceCode.faultSimulation.titles.InterposeTitle;
import sourceCode.faultSimulation.titles.userEventMaintainTitle;
import sourceCode.ocableResource.views.OcableRoutInfo;
import sourceCode.ocableTopo.views.businessInfluenced;
import sourceCode.ocableroute.model.OcableRouteContent;
import sourceCode.ocableroute.model.OcableRouteData;
import sourceCode.ocableroute.views.OcableRoute;
import sourceCode.packGraph.model.LogicPort;
import sourceCode.packGraph.model.OpticalPortDetail;
import sourceCode.packGraph.model.OpticalPortList;
import sourceCode.packGraph.model.OpticalPortStatus;
import sourceCode.packGraph.views.viewEquipPackDuanKouPropertiesInfo;
import sourceCode.rootalarm.views.HisRootAlarm;
import sourceCode.rootalarm.views.RootAlarmMgr;
import sourceCode.sysGraph.views.CarryOpera;
import sourceCode.sysGraph.views.PerformanceTrend;
import sourceCode.systemManagement.model.PermissionControlModel;

import twaver.AlarmSeverity;
import twaver.Constant;
import twaver.Consts;
import twaver.DemoUtils;
import twaver.Element;
import twaver.Follower;
import twaver.Grid;
import twaver.ICollection;
import twaver.IElement;
import twaver.SelectionModel;
import twaver.Styles;
import twaver.Utils;
import twaver.core.util.h.OI;
import twaver.network.ui.BackgroundUI;
		
		[Embed(source="assets/images/equipPack/bg_list.png")]
		private static const bg_list:Class;
		[Embed(source="assets/images/equipPack/bg_vc.png")]
		public static const bg_vc:Class;
		[Embed(source="assets/images/equipPack/port_selected.png")]
		private static const port_selected:Class;
		[Embed(source="assets/images/equipPack/port_unselected.png")]
		private static const port_unselected:Class;
		[Embed(source="assets/images/equipPack/bad_port_selected.png")]
		private static const bad_port_selected:Class;
		[Embed(source="assets/images/equipPack/bad_port_unselected.png")]
		private static const bad_port_unselected:Class;
		[Embed(source="assets/images/equipPack/vc0.png")]
		public static const vc0:Class;
		
		[Embed(source="assets/images/equipPack/vc4.png")]
		public static const vc4:Class;
		
		[Bindable]
		public var cm:ContextMenu;
		private var tw:TitleWindow;
		public var equipcode:String="";
		public var frameserial:String="";
		public var slotserial:String="";
		public var packserial:String="";
		public var x_capability:String="";
		private var rt:RemoteObject;
		private var scoll:Number=0;
		private var preSelectOI:Follower=null;
		private var belongEquip:String="";
		private var isAddInterpose:Boolean = false;
		private var showOper:Boolean = false;
		private var isAddInterposeFault:Boolean=false;
		private var belongPortCode:String="";
		private var isAddCutFault:Boolean=false;
		
		private var duanKouProperties : viewEquipPackDuanKouPropertiesInfo;//属性
		

		private function preinitialize():void{
			if(ModelLocator.permissionList!=null&&ModelLocator.permissionList.length>0){
				isAddInterpose = false;
				showOper = false;
				isAddCutFault=false;
				for(var i:int=0;i<ModelLocator.permissionList.length;i++){
					var model:PermissionControlModel = ModelLocator.permissionList[i];
					if(model.oper_name!=null&&model.oper_name=="新建演习科目"){
						isAddInterpose = true;
					}
					if(model.oper_name!=null&&model.oper_name=="新建故障"){
						isAddInterposeFault = true;
					}
					if(model.oper_name!=null&&model.oper_name=="处理操作")
					{
						showOper = true;
					}
					if(model.oper_name!=null&&model.oper_name=="新建割接")
					{
						isAddCutFault = true;
					}
				}
			}
		}

		private function init():void{
			
			title1.text=label+" —— 机盘管理视图";
			Utils.registerImageByClass("bg_list",bg_list);
			Utils.registerImageByClass("bg_vc",bg_vc);
			Utils.registerImageByClass("port_selected",port_selected);
			Utils.registerImageByClass("port_unselected",port_unselected);
			Utils.registerImageByClass("bad_port_selected",bad_port_selected);
			Utils.registerImageByClass("bad_port_unselected",bad_port_unselected);
			Utils.registerImageByClass("vc0", vc0);
			Utils.registerImageByClass("vc4", vc4);
			
			sub_network.elementBox.layerBox.defaultLayer.movable=false;
			sub_network.selectionModel.selectionMode=SelectionModel.SINGLE_SELECTION;
			
			network.elementBox.setStyle(Styles.BACKGROUND_TYPE,Consts.BACKGROUND_TYPE_IMAGE);
			//net.setStyle(Styles.BACKGROUND_IMAGE_SCOPE,Consts.SCOPE_VIEWSIZE);
			network.elementBox.setStyle(Styles.BACKGROUND_IMAGE_STRETCH,Consts.STRETCH_FILL);
			network.elementBox.setStyle(Styles.BACKGROUND_IMAGE,"bg_list");
			network.elementBox.layerBox.defaultLayer.movable=false;
			network.selectionModel.selectionMode=SelectionModel.SINGLE_SELECTION;
			network.selectionModel.filterFunction=function (data:Element):Boolean{
				if(data is Follower){
					return true;
				}
				else{
					return false;
				}
			}
			
			rt=new RemoteObject("equipPack");	
			rt.endpoint=ModelLocator.END_POINT;
			rt.showBusyCursor = true;
			rt.getOpticalPortList(equipcode,frameserial,slotserial,packserial);//获取光口显示列表
			rt.addEventListener(ResultEvent.RESULT,opticalPortList_reusultHandel);
			Application.application.faultEventHandler(rt);
			network.contextMenu=new ContextMenu();
			network.contextMenu.hideBuiltInItems();
			//network.selectionModel.selectionMode=SelectionModel.SINGLE_SELECTION;
			network.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,function(e:ContextMenuEvent):void{
				//右键选中网元
				var p:Point = new Point(e.mouseTarget.mouseX / network.zoom, e.mouseTarget.mouseY / network.zoom);
				var datas:ICollection = network.getElementsByLocalPoint(p);
				
				if (datas.count > 0) 
				{
					network.selectionModel.setSelection(datas.getItemAt(0));
				}
				else
				{
					network.selectionModel.clearSelection();
				}	
				
				//定制右键菜单
				var flexVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLEX_SDK_VERSION, false, false);
				var playerVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLASH_PLAYER_VERSION, false, false);
				
				if(network.selectionModel.count == 0){//选中元素个数
					network.contextMenu.customItems = [flexVersion, playerVersion];
				}
				else{
					var item55:ContextMenuItem = new ContextMenuItem("新建演习科目");
					item55.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
					item55.visible=isAddInterpose;
					var item56:ContextMenuItem = new ContextMenuItem("新建故障",true);
					item56.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,itemSelectHandler);
					item56.visible=isAddInterposeFault;
					var contextMenuItem1:ContextMenuItem = new ContextMenuItem("查看属性",true);
					contextMenuItem1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, ContexMenuItemSelect);
					var contextMenuItem2:ContextMenuItem = new ContextMenuItem("查看端口承载业务");
					contextMenuItem2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handlerContextMenuCarryOpera);
//					var contextMenuItem3:ContextMenuItem = new ContextMenuItem('"N-1"分析');
//					contextMenuItem3.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handlerContextMenuCarryOperaN1);
					var item4:ContextMenuItem = new ContextMenuItem("串接光路",true);
					item4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,joinOcableRouteHandler);
					var item5:ContextMenuItem = new ContextMenuItem("查看光路路由",false);
					item5.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,showOcableRouteHandler);
					
					var item6:ContextMenuItem = new ContextMenuItem("查看当前告警",true);
					item6.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
				    var item7:ContextMenuItem = new ContextMenuItem("查看当前原始告警");
				    item7.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
					
					var item:ContextMenuItem = new ContextMenuItem("处理操作");
					item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
					item.visible = showOper;
					var itemCutFault:ContextMenuItem = new ContextMenuItem("新建割接");
					itemCutFault.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
//					var item8:ContextMenuItem = new ContextMenuItem("查看历史根告警");
//					item8.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
//					var item9:ContextMenuItem = new ContextMenuItem("查看历史原始告警");
//					item9.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
//					var item10:ContextMenuItem = new ContextMenuItem("查看性能",true);
//					item10.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,itemSelectHandler);
					
					//network.contextMenu = new ContextMenu();
					//network.contextMenu.hideBuiltInItems();	
		//			network.contextMenu.customItems=[contextMenuItem1,contextMenuItem2,contextMenuItem3,item4,item5,item6,item7,item8,item9];
					network.contextMenu.customItems=[contextMenuItem1,contextMenuItem2,item7,item5,item55,item,item56];
					if(isAddCutFault){//用此种方法添加较方便
						network.contextMenu.customItems.push(itemCutFault);
					}
				}
			})
			
			sub_network_contextMenu();
		}
		
		private function sub_network_contextMenu():void{
			sub_network.contextMenu = new ContextMenu();
			sub_network.contextMenu.hideBuiltInItems();
			sub_network.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,function(e:ContextMenuEvent):void{
				
				var p:Point = new Point(e.mouseTarget.mouseX / sub_network.zoom, e.mouseTarget.mouseY / sub_network.zoom);
				var datas:ICollection = sub_network.getElementsByLocalPoint(p);
				if (datas.count > 0) 
				{
					sub_network.selectionModel.setSelection(datas.getItemAt(0));
				}
				else
				{
					sub_network.selectionModel.clearSelection();
				}	
				//定制右键菜单
				var flexVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLEX_SDK_VERSION, false, false);
				var playerVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLASH_PLAYER_VERSION, false, false);
				
				var ielement:IElement = sub_network.elementBox.selectionModel.lastData as IElement;
				if(ielement is Follower){
					var follower:Follower  = ielement as Follower;
					var circuitcode:String = follower.toolTip;
				}
				
				if(sub_network.selectionModel.count == 0){//选中元素个数
					sub_network.contextMenu.customItems = [flexVersion,playerVersion];
				}
				else{
					if(((Element)(sub_network.elementBox.selectionModel.lastData).getClient("flag")!= null
						&&(Element)(sub_network.elementBox.selectionModel.lastData).getClient("flag")=="VC12"
						&&(Element)(sub_network.elementBox.selectionModel.lastData).getClient("hasCC")!=null)
						||((Element)(sub_network.elementBox.selectionModel.lastData).getClient("flag")!= null
							&&(Element)(sub_network.elementBox.selectionModel.lastData).getClient("flag")== "VC4$100"))
					{
						var item1 : ContextMenuItem = new ContextMenuItem("电路信息",true);
						item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, getCircuitPic);
						var item2:ContextMenuItem=new ContextMenuItem("查看路由信息",true);
						item2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,joinchannalrount);
//						var item3:ContextMenuItem = new ContextMenuItem("解除关联",true);
//						item3.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,releaseCircuit);
//						if(circuitcode!=null){
						sub_network.contextMenu.customItems = [item1,item2]; 
//						}else{
//							sub_network.contextMenu.customItems = [item1,item2];
//						}
					}			
					else
					{
						sub_network.contextMenu.customItems = [flexVersion,playerVersion];
					}
				}
			});	
		}
		
//		private function releaseCircuit(event:ContextMenuEvent):void{
//			var alertString:String = "确认解除此端口的方式关联？";
//			Alert.show(alertString,
//				"提示",
//				Alert.YES|Alert.NO,
//				null,
//				confirm
//			);
//		}
//		private function confirm(event:CloseEvent):void{
//			if(event.detail==Alert.YES){		
//				var ielement:IElement = sub_network.elementBox.selectionModel.lastData as IElement;
//				if(ielement is Follower){
//					var follower:Follower  = ielement as Follower;
//					var circuitcode:String = follower.toolTip;
//				var rt:RemoteObject = new RemoteObject("channelTree");
//				rt.endpoint = ModelLocator.END_POINT;
//				rt.showBusyCursor = true;
//				rt.releasePortCircuit(circuitcode);
//				rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
//					if(event.result!=null&&event.result.toString()=="true"){
//						Alert.show("解除成功！","提示");
//						showdetails();
//						sub_network_contextMenu();
//					}else{
//						Alert.show("解除失败！","提示");
//					}
//				});
//				rt.addEventListener(FaultEvent.FAULT,function(event:FaultEvent):void{
//					Alert.show("解除失败！","提示");
//				});
//			}
//			}
//		}
		
		private function opticalPortList_reusultHandel(event:ResultEvent):void{
			rt.removeEventListener(ResultEvent.RESULT,opticalPortList_reusultHandel);
			var opticalPortArray:ArrayCollection=event.result as ArrayCollection;
			var opticalPortCount:int=opticalPortArray.length;
			var grid:Grid=new Grid();
			grid.width=network.width*0.92;
			grid.height=opticalPortCount*60;
			grid.setStyle(Styles.GRID_ROW_COUNT,opticalPortCount);
			grid.setStyle(Styles.GRID_COLUMN_COUNT,1);
			grid.setStyle(Styles.GRID_BORDER,0);
			grid.setStyle(Styles.GRID_PADDING,0);
			grid.setLocation(0,0);
			network.elementBox.add(grid);
			var portcode:String=Registry.lookup("portcode");
			Registry.unregister("portcode");
			for(var i:int=0;i<opticalPortCount;i++){
				var opticalPort:OpticalPortList=opticalPortArray[i] as OpticalPortList;
				var logicport:String=opticalPort.logicport;
				var f:OI_Follower=new OI_Follower(logicport);
				f.setStyle(Styles.LABEL_POSITION,Consts.POSITION_CENTER);
				f.setStyle(Styles.LABEL_XOFFSET,12);
				f.setStyle(Styles.LABEL_YOFFSET,-15);
				f.setStyle(Styles.FOLLOWER_ROW_INDEX,i);
				f.setStyle(Styles.LABEL_COLOR,0xFFFFFF);
				f.setStyle(Styles.IMAGE_STRETCH,Consts.STRETCH_FILL);
				f.host=grid;
				//Alert.show(opticalPort.status.toString());
				if(opticalPort.status.toString() =="ZY13100203"){
					f.image="bad_port_unselected";
				}else{
					f.image="port_unselected";
				}
				f.name=opticalPort.logicportname;
				f.setClient("status",opticalPort.status);
				f.setClient("logicport",opticalPort.logicport);
				f.setClient("alarmport",equipcode+"="+frameserial+"="+slotserial+"="+packserial+"="+opticalPort.portserial);
				f.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
				f.setStyle(Styles.SELECT_COLOR,"0x00FF00");
				f.setStyle(Styles.SELECT_WIDTH,5);
				network.elementBox.add(f);
				if(portcode){
					if(portcode==opticalPort.logicport){
						network.selectionModel.setSelection(f);
					}
				}
				else if(i==0){
					network.selectionModel.setSelection(f);
				}
				ModelLocator.registerAlarm();
				getAlarms();
				var rt1:RemoteObject=new RemoteObject("equipPack");	
				rt1.endpoint=ModelLocator.END_POINT;
				rt1.showBusyCursor = true;
				rt1.addEventListener(ResultEvent.RESULT,getopticalPortDetail);
				Application.application.faultEventHandler(rt1);
				rt1.getOpticalPortDetail(equipcode,logicport);//获取光口显示列表
				
			}
		}
		//给label赋值
		private function getopticalPortDetail(e:ResultEvent):void{
			var opticalPortDetail:OpticalPortDetail = (OpticalPortDetail)(e.result);
			var rate:String = opticalPortDetail.rate;//时隙使用率
			var allvc4:int = Number(opticalPortDetail.allvc4);//VC4个数
			if(rate == "  .00%") {
				rate = "    0%";
			}
			var f:Follower=network.elementBox.getElementByID(opticalPortDetail.portcode) as Follower;
			f.setClient("rate",rate);
			f.setClient("allvc4",allvc4);
			f.setClient("usrvc4",opticalPortDetail.usrvc4);
			f.setClient("usrvc12",opticalPortDetail.usrvc12);
			if(f==network.selectionModel.lastData){
				showdetails();
			}
		}
		
/**
 *显示该光口的详细时隙占用情况 
 * 
 */
public function showdetails():void
{
			sub_network.elementBox.clear();
			sub_title.text="";
			if(preSelectOI!=null){
				if(preSelectOI.getClient("status").toString()=="ZY13100203"){
					preSelectOI.image="bad_port_unselected";
				}else{
					preSelectOI.image="port_unselected";
				}
			}
			if(network.selectionModel.count>0){
				preSelectOI=network.selectionModel.lastData as Follower;
				sub_title.text=preSelectOI.name+"时隙占用情况";
				if(preSelectOI.getClient("status").toString()=="ZY13100203"){
					preSelectOI.image="bad_port_selected";
				}else{
					preSelectOI.image="port_selected";
				}
				rt.getOpticalPortStatus(preSelectOI.getClient("logicport"));//获取光口占用状态
				rt.addEventListener(ResultEvent.RESULT,opticalPortStatus_reusultHandel);
			}
		}
		
/**
 *绘制某个光口的详细时隙占用情况 
 * @param e
 * 
 */
		private function opticalPortStatus_reusultHandel(e:ResultEvent):void{
			rt.removeEventListener(ResultEvent.RESULT,opticalPortStatus_reusultHandel);
			var opticalPortStatusArray:ArrayCollection = (ArrayCollection)(e.result);						
	//100% 一个VC4占100%,
	//x%   多个VC12组成一个VC4
	//0%   没有占用情况
			drawGrid();	
			var xCount:int;//行数
			var yCount:int;//列数	
			var rowCount:int = 1;//grid行数
			var columnCount:int = 1;//grid列数
			var logicport:String=preSelectOI.getClient("logicport");
			var opticalPortStatus:OpticalPortStatus;//占用光口状态信息	
			var allvc4:int=preSelectOI.getClient("allvc4");
			if(opticalPortStatusArray.length > 0){
				var vc4_num:String,vc12_num:String;//VC4序号,VC12序号 
				var rate:String,aptp:String,aslot:String,circuitcode:String; //速率，a、z端
				var ii:int,jj:int;
				var flag:int = 0;//
				var aslotCount:Number = opticalPortStatusArray.length;//占用数量
				var temp_num:int;//VC12数
				
				var  arr:Array=[];//VC4数组
				var aslot_temp:int;//VC4数组下标
				//置初始值为0
				for(var i:int = 0;i < allvc4;i++){
					arr[i] = 0;
				}
				for each (opticalPortStatus in opticalPortStatusArray){
					rate = opticalPortStatus.rate;
					aptp = opticalPortStatus.aptp;
					aslot = opticalPortStatus.aslot;
					
					if(rate == "VC12"){
						aslot_temp = (int(aslot) - 1)/63;
						arr[aslot_temp] += 1; 
					}
					else if(rate=="VC4"){
						var followerNum:String;//图片vc0序号
						followerNum = logicport + "vc0" + (parseInt(aslot)-1).toString();
						var followerTem:Follower = sub_network.elementBox.getElementByID(followerNum) as Follower;
						followerTem.image = "vc4";
						followerTem.setClient("flag","VC4$100");
						followerTem.setClient("portcode",logicport);
						followerTem.setClient("VC4",aslot);
						var vc_Use:String = logicport + "vc_use" + (parseInt(aslot)-1).toString();//时隙使用率序号
						var followerTt:Follower = sub_network.elementBox.getElementByID(vc_Use) as Follower;
						followerTt.setClient("used",63);
						followerTem.toolTip=opticalPortStatus.circuitcode;
					}
				}
				for(var t:int = 0;t < allvc4;t++){
					if(arr[t] > 0&&(arr[t] <= 63)){	
						vc4_num = logicport+"VC4-" + t;//VC4序号 
						//根据id获取VC4
						var vc4_tmp:String = "VC4-"+(t+1);
						var grid1:Grid = sub_network.elementBox.getElementByID(vc4_num) as Grid;
						var vc_use:String = logicport + "vc_use" + t;//时隙使用率序号
						var follower_t:Follower = sub_network.elementBox.getElementByID(vc_use) as Follower;
						follower_t.setClient("used",arr[t]);
						//生成63个VC12
						rowCount = 7;
						columnCount = 9;
						//设置grid的行列数为7*9
						grid1.setStyle(Styles.GRID_ROW_COUNT, rowCount);
						grid1.setStyle(Styles.GRID_COLUMN_COUNT, columnCount);
						grid1.setStyle(Styles.GRID_PADDING,5);
						
						drawFollower(rowCount,columnCount,grid1,vc4_num,logicport,vc4_tmp);
					}
				}
				
				for each (opticalPortStatus in opticalPortStatusArray){
					rate = opticalPortStatus.rate;
					aptp = opticalPortStatus.aptp;
					aslot = opticalPortStatus.aslot;
					circuitcode = opticalPortStatus.circuitcode;
					if(rate == "VC12"){
						aslot_temp = (int(aslot) - 1)/63;									
						vc4_num = logicport+"VC4-" + aslot_temp;//VC4序号 
						
						//占用的VC12着色
						vc12_num = vc4_num+ "VC12-" + (int(aslot) - 63*aslot_temp);//VC12序号 
						//根据id获取VC12
						var follower1:Follower = sub_network.elementBox.getElementByID(vc12_num) as Follower;
						if(follower1 != null){
							//获取cell，设置颜色
							follower1.setStyle(Styles.INNER_OUTLINE_COLOR,9961367);	
							follower1.setStyle(Styles.INNER_COLOR,9961367);//绿色
							follower1.setClient("hasCC","true");
							if(circuitcode!=null&&circuitcode!="") {
								follower1.setStyle(Styles.INNER_OUTLINE_COLOR,59392);	
								follower1.setStyle(Styles.INNER_COLOR,59392);
								follower1.toolTip = circuitcode;
							}
						}
						
					}
				}
				
			}	
		}
		
/**
 *绘制某个光口的时隙占用情况的网格 
 * 
 */
		private function drawGrid():void{
			var allvc4:int=preSelectOI.getClient("allvc4");
			var logicport:String=preSelectOI.getClient("logicport");
			var xCount:int;//行数
			var yCount:int;//列数
			
			if(allvc4 == 4){//622M STM-4
				xCount = 1;
				yCount = 4;
			}
			else if(allvc4 == 1){//155M STM-1
				xCount = 1;
				yCount = 1;
			}
			else if(allvc4 == 8){
				xCount = 2;
				yCount = 4;
			}
			else if(allvc4 == 16){//2.5G STM-16
				xCount = 4;
				yCount = 4;
			}
			else if(allvc4 == 64){//10G STM-64
				xCount = 16;
				yCount = 4;
			}
			
			
			var rowCount:int = 1;//grid行数
			var columnCount:int = 1;//grid列数
			var k:int = 0,grid_id:int = -1;//端口中VC4序号
			var xLocation:int,yLocation:int;//grid位置(x轴位置,y轴位置)
			
			//根据速率确定VC4个数,循环生成
			var i:int,j:int;//
			for(i = 0;i < xCount;i++){
				yLocation = 10+i*195;
				for(j = 0;j < yCount;j++){
					xLocation = 10+j*205;
					k += 1;
					grid_id += 1;
					if(grid_id == allvc4){
						break;
					}
					
					
					var grid_1:Grid = new Grid();
					grid_1.setSize(200,180);
					//grid_1.setSize(168, 240);
					grid_1.setLocation(xLocation, yLocation);
					grid_1.setStyle(Styles.GRID_BORDER,5);
					grid_1.setStyle(Styles.GRID_PADDING,0);
					grid_1.setStyle(Styles.GRID_ROW_COUNT,3);
					grid_1.setStyle(Styles.GRID_COLUMN_COUNT,1);
					grid_1.setStyle(Styles.GRID_ROW_PERCENTS,[0.15,0.15,0.7]);	
					grid_1.setStyle(Styles.IMAGE_STRETCH,Consts.STRETCH_FILL);
					grid_1.image="bg_vc";
					sub_network.elementBox.add(grid_1);
					
					var follower_1:Follower = new Follower();
					follower_1.setStyle(Styles.FOLLOWER_ROW_INDEX, 0);
					follower_1.setStyle(Styles.FOLLOWER_COLUMN_INDEX, 0);	
					follower_1.setStyle(Styles.LABEL_POSITION,Consts.POSITION_CENTER);	
					follower_1.image = "";
					follower_1.name = "VC4-"+ k;
					
					follower_1.setStyle(Styles.LABEL_BOLD,true);//是否使用粗体字体
					follower_1.setStyle(Styles.LABEL_FONT,"宋体");//字体
					follower_1.setStyle(Styles.LABEL_SIZE,14);//字体大小
					
					follower_1.host = grid_1;
					sub_network.elementBox.add(follower_1);
					
					var follower_2:Optical_Interface_Follower = new Optical_Interface_Follower(logicport + "vc_use" + grid_id);
					follower_2.setStyle(Styles.FOLLOWER_ROW_INDEX, 1);
					follower_2.setStyle(Styles.FOLLOWER_COLUMN_INDEX, 0);
					follower_2.setClient("used",0);
					follower_2.image="";
					follower_2.host = grid_1;
					sub_network.elementBox.add(follower_2);
					
					var grid:Grid=new Grid(logicport+"VC4-"+ grid_id);
					grid.setLocation(xLocation, yLocation);
					grid.setStyle(Styles.FOLLOWER_ROW_INDEX, 2);
					grid.setStyle(Styles.FOLLOWER_COLUMN_INDEX, 0);
					grid.setStyle(Styles.GRID_BORDER, 0);
					grid.setStyle(Styles.GRID_PADDING,0);
					grid.setStyle(Styles.GRID_CELL_DEEP,0);//单元格深度
					grid.setStyle(Styles.GRID_DEEP,0);
					grid.setStyle(Styles.GRID_ROW_COUNT, rowCount);
					grid.setStyle(Styles.GRID_COLUMN_COUNT, columnCount);
					grid.setStyle(Styles.GRID_FILL,false);//网格是否填充		
					grid.host = grid_1;
					//grid.name = "VC4-"+ k +"";
					sub_network.elementBox.add(grid);
					
					var follower_4:Follower = new Follower(logicport + "vc0" + grid_id);
					follower_4.setStyle(Styles.FOLLOWER_ROW_INDEX, 0);
					follower_4.setStyle(Styles.FOLLOWER_COLUMN_INDEX, 0);
					follower_4.image = "vc0";
					follower_4.setStyle(Styles.IMAGE_STRETCH,Consts.STRETCH_FILL);
					follower_4.host = grid;
					sub_network.elementBox.add(follower_4);
					
				}
			}
		}
		private function drawFollower(rowCount:int,columnCount:int,grid1:twaver.Grid,grid_id:String,logicport:String,vc4:String):void{
			
			var num:int = 0;//序号
			var m:int,n:int;
			sub_network.elementBox.removeByID(logicport+"vc0"+grid_id);
			//Alert.show(logicport+"$$$"+vc4);
			for(m = 0;m < rowCount;m++){					
				for(n = 0;n < columnCount;n++){
					num += 1;
					
					var follower1:Follower = network.elementBox.getElementByID(grid_id+"VC12-" + num) as Follower;
					if(follower1 == null){
						var follower:Follower = new Follower(grid_id+"VC12-" + num);							
						follower.setStyle(Styles.FOLLOWER_ROW_INDEX, m);
						follower.setStyle(Styles.FOLLOWER_COLUMN_INDEX, n);
						
						follower.setStyle(Styles.INNER_STYLE,Consts.INNER_STYLE_SHAPE);
						follower.setStyle(Styles.LABEL_POSITION,Consts.POSITION_CENTER);	
						follower.image = "";
						follower.setStyle(Styles.INNER_OUTLINE_COLOR,0xFFFFFF);	
						follower.setStyle(Styles.INNER_COLOR,0xFFFFFF);
						follower.name = (num).toString();
						follower.setClient("flag","VC12");
						follower.setClient("portcode",logicport);
						follower.setClient("VC4",vc4);
						follower.host = grid1;
						//grid1.addChild(follower);
						sub_network.elementBox.add(follower);
					}
				}
				
			}
		}
		/*
		*属性
		*/
		private function ContexMenuItemSelect(evt:ContextMenuEvent):void{			
			
			
			
			
			var portcode:String=network.selectionModel.lastData.id.toString();
			
			if(portcode!=null){
				portcode = portcode.split(",")[0];
			}
			var portname:String = network.selectionModel.lastData.name;
			var property:ShowProperty = new ShowProperty();
			property.paraValue = portcode;
			property.tablename = "VIEW_EQUIPLOGICPORT_PROPERTY";
			property.key = "LOGICPORT";
			property.title = portname+"—端口属性";
			//				property.title = "—端口属性";
			PopUpManager.addPopUp(property, this, true);
			PopUpManager.centerPopUp(property);
		}
		// 给端口属性赋值
		private function generatePortProperties(event:ResultEvent):void{
			
			duanKouProperties.addEventListener("savePortInfo",saveportproperties);
			
			duanKouProperties.equipname.text=event.result.equipname;
			duanKouProperties.portserial.text=event.result.portserial
			duanKouProperties.frameserial.text=event.result.frameserial;
			duanKouProperties.remark.text=event.result.remark;
			duanKouProperties.slotserial.text=event.result.slotserial;
			duanKouProperties.updatedate.text=event.result.updatedate;
			duanKouProperties.updateperson.text=event.result.updateperson;
			duanKouProperties.logicport.text=event.result.logicport;
			duanKouProperties.connport.text=event.result.connport;
			duanKouProperties.packserial.text=event.result.packserial;
			
			var ppobj1:RemoteObject = new RemoteObject("equipPack");
			ppobj1.endpoint=ModelLocator.END_POINT;
			ppobj1.showBusyCursor=true;
			ppobj1.getFromXTBM("ZY030704_%");//查看端口类型
			Application.application.faultEventHandler(ppobj1);
			ppobj1.addEventListener(ResultEvent.RESULT, function (e: ResultEvent):void{generatePortTypeInfo(e,event.result.y_porttype)});
			var ppobj2:RemoteObject = new RemoteObject("equipPack");
			ppobj2.endpoint=ModelLocator.END_POINT;
			ppobj2.showBusyCursor=true;
			ppobj2.getFromXTBM("ZY0701_%")// 端口速率
			Application.application.faultEventHandler(ppobj2);
			ppobj2.addEventListener(ResultEvent.RESULT, function (e:ResultEvent):void{generatePortRateInfo(	e,event.result.x_capability)});
			var ppobj3:RemoteObject = new RemoteObject("equipPack");
			ppobj3.endpoint=ModelLocator.END_POINT;
			ppobj3.showBusyCursor=true;
			ppobj3.getFromXTBM("ZY131002_%")// 端口状态
			Application.application.faultEventHandler(ppobj3);
			ppobj3.addEventListener(ResultEvent.RESULT, function(e:ResultEvent):void{generatePortStatusInfo(e,event.result.status)});	
		}
		private function generatePortTypeInfo(event:ResultEvent,type:String):void{
			var XMLData:XMLList = new XMLList(event.result.toString());
			duanKouProperties.y_porttype.dataProvider = XMLData.children();
			duanKouProperties.y_porttype.labelField = "@label";
			
			for each (var element:XML in duanKouProperties.y_porttype.dataProvider) {
				
				if(element.@label==type){
					
					duanKouProperties.y_porttype.selectedItem = element as Object;
				}
			}
		}
		private function generatePortRateInfo(event:ResultEvent,rate:String):void{
			var XMLData:XMLList = new XMLList(event.result.toString());
			duanKouProperties.x_capability.dataProvider = XMLData.children();
			duanKouProperties.x_capability.labelField = "@label";	
			
			for each (var element:XML in duanKouProperties.x_capability.dataProvider) {
				
				if(element.@label==rate){
					
					duanKouProperties.x_capability.selectedItem = element as Object;
				}
			}
		}
		private function generatePortStatusInfo(event:ResultEvent,status:String):void{
			var XMLData:XMLList = new XMLList(event.result.toString());
			duanKouProperties.portstatus.dataProvider = XMLData.children();
			duanKouProperties.portstatus.labelField = "@label";
			for each (var element:XML in duanKouProperties.portstatus.dataProvider) {					
				if(element.@label==status){						
					duanKouProperties.portstatus.selectedItem = element as Object;
				}
			}
		} 
		//属性更新
		private function saveportproperties(event:Event):void{
			var logicPort:LogicPort=new LogicPort();
			if(duanKouProperties.connport.text==""){
				logicPort.connport=" ";	
			}else{
				logicPort.connport=duanKouProperties.connport.text
			}
			logicPort.equipname=duanKouProperties.equipname.text;// 设备名称
			logicPort.frameserial=duanKouProperties.frameserial.text;//机框序号
			logicPort.packserial= duanKouProperties.packserial.text;
			logicPort.portserial=duanKouProperties.portserial.text;
			logicPort.slotserial=duanKouProperties.slotserial.text;
			logicPort.logicport=duanKouProperties.logicport.text;
			logicPort.remark=duanKouProperties.remark.text;
			logicPort.status=duanKouProperties.portstatus.selectedItem.@code;
			logicPort.updatedate=duanKouProperties.updatedate.text;
			logicPort.updateperson=duanKouProperties.updateperson.text;
			logicPort.x_capability=duanKouProperties.x_capability.selectedItem.@code;
			
			logicPort.y_porttype=duanKouProperties.y_porttype.selectedItem.@code;
			logicPort.equipcode=equipcode;
			var ppobj:RemoteObject = new RemoteObject("equipPack");
			ppobj.endpoint=ModelLocator.END_POINT;
			ppobj.showBusyCursor=true;
			ppobj.updatePortProperties(logicPort);
			Application.application.faultEventHandler(ppobj);
			ppobj.addEventListener(ResultEvent.RESULT, function (e: ResultEvent):void{
				if(e.result){
					Alert.show("更新成功","提示");
					MyPopupManager.removePopUp(duanKouProperties);  
				}else{
					Alert.show("后台发生错误，请重试","提示");
				}
			});	
		}
		
		//业务
		private function handlerContextMenuCarryOpera(evt:ContextMenuEvent):void{
			var itemCarryOperaInfo:CarryOpera = new CarryOpera();
			var	logicport = network.selectionModel.lastData.id;
			itemCarryOperaInfo.getOperaByCodeAndType(logicport,"logicport");
			//查看端口承载业务
			itemCarryOperaInfo.title= "端口承载业务";
			MyPopupManager.addPopUp(itemCarryOperaInfo, false);
		}
		
		//N-1
		private function handlerContextMenuCarryOperaN1(evt:ContextMenuEvent):void{
			var winBI:businessInfluenced = new businessInfluenced();
			var	logicport = network.selectionModel.lastData.id;
			winBI.setParameters(logicport, "port");
			
			this.parentApplication.openModel("\"N-1\"分析",true,winBI);
		}
		/*
		*
		*/
		//时隙右键
		
		private function joinchannalrount(event:Event=null):void{
			var ielement:IElement = sub_network.elementBox.selectionModel.lastData as IElement;
			if(ielement is Follower){
				var follower:Follower  = ielement as Follower;
				if(follower.getClient("flag")!=null&&follower.getClient("flag")=='VC12'){
					var portcode:String=follower.getClient("portcode");
					var vc4:String=follower.getClient("VC4");
					var vc12:String=follower.name;
					var vc4_int:int = vc4.split("-")[1];
					var vc12_int:int = int(vc12);
					var slot:String = String((vc4_int-1)*63+vc12_int);
					var tandem:tandemcircuit = new tandemcircuit();
					tandem.c_circuitcode = follower.toolTip;
					tandem.logicport = portcode;
					tandem.flag = 'VC12'
					tandem.slot = slot;
					tandem.type_flag=true;
					tandem.equippack_follower = follower; 
					tandem.opticalport = this;
					this.parentApplication.openModel("串接电路",true,tandem);
					
				}
				if(follower.getClient("flag")!=null&&follower.getClient("flag")=="VC4$100"){
					var portcode:String=follower.getClient("portcode");
					var vc4:String=follower.getClient("VC4");
					var tandem:tandemcircuit = new tandemcircuit();
					tandem.c_circuitcode = follower.toolTip;
					tandem.logicport = portcode;
					tandem.slot = vc4;
					tandem.flag = 'VC4';
					tandem.type_flag=true;
					tandem.equippack_follower = follower;
					this.parentApplication.openModel("串接电路",true,tandem);
				}
				
			}
		}
/**
 *方式信息 
 * @param e
 * 
 */
		private function getCircuitPic(e:Event=null):void{
			var ielement:IElement = sub_network.elementBox.selectionModel.lastData as IElement;
			if(ielement is Follower){
				var follower:Follower  = ielement as Follower;
				var circuitcode:String = follower.toolTip;
				if(circuitcode!=null){
					var rtobj1:RemoteObject=new RemoteObject("fiberWire");
					rtobj1.endpoint=ModelLocator.END_POINT;
					rtobj1.showBusyCursor=true;
					rtobj1.getTypeBycircuitCode(circuitcode);
					rtobj1.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void
					{
						if(event.result){
							Registry.register("para_circuitcode", circuitcode);
							Registry.register("para_circuitype", event.result.toString());
							Application.application.openModel("方式信息", false);
							
						}
					});
//					Registry.register("para_circuitcode", circuitcode);
//					Application.application.openModel("方式信息", false);
				}else{
					Alert.show("该时隙上的所在的电路未串接！","提示");
				}					
			}
		}
		
		private function getCircuitcode(e:ResultEvent):void{
			if(e.result!=null&&e.result.toString()!=""){
				Registry.register("para_circuitcode", e.result.toString());
				Application.application.openModel("方式信息", false);
			}else{
				Alert.show("该时隙上的所在的电路未串接！","提示");
			}
		}
		
		//告警定位
		private function setLocation():void{
			
			var portcode:String=Registry.lookup("portcode");
			Registry.unregister("portcode");
			if(portcode!=null){
				network.elementBox.forEach(function(element:Element):void{
					if(element.getClient("portcode")==portcode){
						network.elementBox.selectionModel.setSelection(element);
						element.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
						element.setStyle(Styles.SELECT_COLOR,"0x00FF00");
						element.setStyle(Styles.SELECT_WIDTH,10);
					}
				});
			}
		}
		
		
		private function itemSelectHandler(e:ContextMenuEvent):void{
		
			
			//传个belongportobject给告警页面
			
//				var	belongPortCode = network.selectionModel.lastData.id;
				var follow:Follower = network.selectionModel.selection.getItemAt(0) as Follower;
				var alarmport:String = follow.getClient("alarmport");
				var equipPackPic:Object =follow.id;
				belongPortCode=alarmport;			
				tw =new TitleWindow();
				tw.layout="absolute";
				tw.x=0;tw.y=0;
//				tw.width=Capabilities.screenResolutionX-50;
//				tw.height=Capabilities.screenResolutionY-250;
				tw.width=1280;
				tw.height=660;
				tw.styleName="popwindow";
				tw.showCloseButton="true";
				
				var alarm1:AlarmMangerModel=new AlarmMangerModel();
				var arr2:Array=new Array();
				if(belongPortCode!=null){
					arr2=belongPortCode.split('=');
				}
				if(arr2.length == 5){
					alarm1.belongequip=arr2[0].toString();//编号
					alarm1.belongframe=arr2[1].toString();//序号
					alarm1.belongslot=arr2[2].toString();//序号
					alarm1.belongpack=arr2[3].toString();//序号
					alarm1.belongport = arr2[4].toString();//序号
					belongEquip = belongPortCode;
					
				}
				if(e.currentTarget.caption == "处理操作"){
					alarm1.iscleared="0";
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
				else if(e.currentTarget.caption=="查看当前原始告警"){
					tw.title="告警查询";
					var currentOriginalAlarm:AlarmManager=new AlarmManager();
					currentOriginalAlarm.flag = 1;
					currentOriginalAlarm.iscleared="0";
					currentOriginalAlarm.belongportobject=belongPortCode;
					tw.addEventListener(CloseEvent.CLOSE,twcolse);
					tw.addChild(currentOriginalAlarm);
					PopUpManager.addPopUp(tw,main(Application.application),true);
					PopUpManager.centerPopUp(tw);
				}else if(e.currentTarget.caption=="新建演习科目"){
					var interpose:InterposeTitle = new InterposeTitle();
					interpose.title = "添加";
					interpose.isModify=false;
					interpose.isEquipPack=true;
					interpose.paraValue = belongPortCode;
					PopUpManager.addPopUp(interpose,Application.application as DisplayObject,true);
					PopUpManager.centerPopUp(interpose);
					interpose.addEventListener("RefreshDataGrid",RefreshDataGrid);	
				}else if (e.currentTarget.caption == "新建故障") {
					var interposeFault:InterposeFaultTitle = new InterposeFaultTitle();
					interposeFault.title = "添加";
					interposeFault.isModify=false;
					interposeFault.isEquipPack=true;
					interposeFault.paraValue = belongPortCode;
					interposeFault.user_id=parentApplication.curUser;
					interposeFault.txt_user_name =parentApplication.curUserName;
					PopUpManager.addPopUp(interposeFault,Application.application as DisplayObject,true);
					PopUpManager.centerPopUp(interposeFault);
					interposeFault.setTxtData();
					interposeFault.addEventListener("RefreshDataGrid",RefreshDataGrid);
					//新建故障后  关闭当前仿真拓扑图  仿真拓扑图中的新建故障针对当前用户 
				}else if (e.currentTarget.caption == "新建割接") {
					var portCut:InterposePortCutTitle = new InterposePortCutTitle();
					portCut.title = "添加";
					portCut.isModify=false;
					portCut.isEquipPack=true;
					portCut.isCutFault=true;//当前进入为割接操作
					portCut.paraValue = belongPortCode;
					portCut.oldport = equipPackPic.toString();
					portCut.user_id=parentApplication.curUser;
					portCut.txt_user_name =parentApplication.curUserName;
					PopUpManager.addPopUp(portCut,Application.application as DisplayObject,true);
					PopUpManager.centerPopUp(portCut);
					portCut.f_user_name.label="割接人员";
					portCut.f_faulttype.label="割接类型";
					portCut.setTxtData();
					portCut.addEventListener("RefreshDataGrid",RefreshDataGrid);
					//新建故障后  关闭当前仿真拓扑图  仿真拓扑图中的新建故障针对当前用户 
					
				}			
				
//				if(e.currentTarget.caption=="查看当前告警"){
//					tw.title="当前告警";
//					var historyRootAlarm:HisRootAlarm=new HisRootAlarm();
//					historyRootAlarm.myflag=2;
//					historyRootAlarm.belongportobject=belongPortCode;
//					tw.addEventListener(CloseEvent.CLOSE,twcolse);
//					tw.addChild(historyRootAlarm);
//					PopUpManager.addPopUp(tw,main(Application.application),true);
//					PopUpManager.centerPopUp(tw);					
//					
//			      }
//				else if(e.currentTarget.caption=="查看当前原始告警"){
//					tw.title="告警查询";
//					var currentOriginalAlarm:AlarmManager=new AlarmManager();
//					currentOriginalAlarm.flag = 1;
//					currentOriginalAlarm.iscleared="0";
//					currentOriginalAlarm.belongportcode=belongPortCode;
//					tw.addEventListener(CloseEvent.CLOSE,twcolse);
//					tw.addChild(currentOriginalAlarm);
//					PopUpManager.addPopUp(tw,main(Application.application),true);
//					PopUpManager.centerPopUp(tw);
//					
//				}else if(e.currentTarget.caption=="查看历史根告警"){
//					tw.title="历史根告警";
//					var historyRootAlarm:HisRootAlarm=new HisRootAlarm();
//					historyRootAlarm.myflag=3;
//					historyRootAlarm.belongportobject=belongPortCode;
//					tw.addEventListener(CloseEvent.CLOSE,twcolse);
//					tw.addChild(historyRootAlarm);
//					PopUpManager.addPopUp(tw,main(Application.application),true);
//					PopUpManager.centerPopUp(tw);
//					
//				}else if(e.currentTarget.caption=="查看历史原始告警"){
//					tw.title="告警查询";
//					var historyOriginalAlarm:AlarmManager=new AlarmManager();
//					historyOriginalAlarm.flag = 1;
//					historyOriginalAlarm.iscleared="1";
//					historyOriginalAlarm.belongportcode=belongPortCode;
//					tw.addEventListener(CloseEvent.CLOSE,twcolse);
//					tw.addChild(historyOriginalAlarm);
//					PopUpManager.addPopUp(tw,main(Application.application),true);
//					PopUpManager.centerPopUp(tw);
					
//				}else 
//				if(e.currentTarget.caption=="查看性能"){
//					var portcode:String=network.selectionModel.lastData.id.toString();
//					
//					if(portcode!=null){
//						portcode = portcode.split(",")[0];
//					}
//					var pt:PerformanceTrend = new PerformanceTrend();
//					pt.logicport = portcode;
//					PopUpManager.addPopUp(pt,this,true);
//					PopUpManager.centerPopUp(pt);
//				}
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
				
				eventMaintain.eventList = str;
				eventMaintain.equipcode =belongEquip;
				eventMaintain.title="处理操作";
				eventMaintain.myCallBack=this.getAlarms;
				eventMaintain.mainApp=this;
			}
		}

		private function RefreshDataGrid(event:Event):void{
			Application.application.openModel("演习科目管理", false);
		}
		
		private function twcolse(evt:CloseEvent):void{
			PopUpManager.removePopUp(tw);
		}
		
		private function move_below():void{
			if(network.verticalScrollPosition<network.maxVerticalScrollPosition){
				network.verticalScrollPosition+=100;
				btn1.enabled=true;
			}else{
				btn2.enabled=false;
			}
		}
		private function move_above():void{
			
			if(network.verticalScrollPosition>0){
				network.verticalScrollPosition-=100;
				btn2.enabled=true;
			}else{
				btn1.enabled=false;
			}
		}
		private function move_scroll(e:MouseEvent):void{
			if(e.delta>0){
				move_above();
			}else{
				move_below();
			}
		}
		
		private function getAlarms():void{
			var rtc:RemoteObject = new RemoteObject("equipPack");
			rtc.endpoint = ModelLocator.END_POINT;
			rtc.showBusyCursor = true;
			rtc.addEventListener(ResultEvent.RESULT,getAlarmResult);
			Application.application.faultEventHandler(rtc);
			rtc.getPortAlarm(equipcode,frameserial,slotserial,packserial);
		}
		
		
		private function getAlarmResult(event:ResultEvent):void{
			//先清除
			network.elementBox.forEach(function(element:Element):void{
				element.alarmState.clear();
			}
			);
			var alarmarray:ArrayCollection=event.result as ArrayCollection;
			for(var i:int=0;i<alarmarray.length;i++){
				
				refreshAlarm(alarmarray[i].ALARMPORT,alarmarray[i].ALARMLEVEL,alarmarray[i].ALARMCOUNT);
			}
		}
		
		private function refreshAlarm(packcode:String,alarmlevel:int,alarmcount:int):void{
			network.elementBox.forEach(function(element:Element):void{
				if(element.getClient("alarmport")!=null&&element.getClient("alarmport")==packcode){
					
					element.alarmState.setNewAlarmCount(AlarmSeverity.getByValue(alarmlevel),alarmcount);
				}
			}
			);
		}
		
		//串接光路
		private function joinOcableRouteHandler(event:ContextMenuEvent):void{
			var portcode:String=network.selectionModel.lastData.id.toString();
			if(portcode!=null){
				portcode = portcode.split(",")[0];
			}else{
				Alert.show("请选择要串接的端口","提示");
				return;
			}
			var ro:RemoteObject = new RemoteObject("ocableRoute");
			ro.endpoint = ModelLocator.END_POINT;
			ro.showBusyCursor = true;
			ro.getOcableChannel(portcode,this.parentApplication.curUser);
			ro.addEventListener(ResultEvent.RESULT,joinResultHandler);
			ro.addEventListener(FaultEvent.FAULT,joinFaultHandler);
		}
		
		private function joinResultHandler(event:ResultEvent):void{
			var ocableRouteData:OcableRouteData = new OcableRouteData();
			ocableRouteData = event.result as OcableRouteData;
			if(ocableRouteData == null){
				Alert.show("没有数据","提示");
				return;
			}
			if(ocableRouteData.content.content =="blank"){
				Alert.show("该光口没有配置连接关系","提示");
				return;
			}else if(ocableRouteData.content.content == "noport"){
				Alert.show("生成端口数据错误","提示");
				return;
			}if(ocableRouteData.content.content =="fault"){
				Alert.show("串接失败","提示");
				return;
			}
			var portcode:String=network.selectionModel.lastData.id.toString();
			var ocableRoute:OcableRoute = new OcableRoute();
			ocableRoute.ocableRouteData = ocableRouteData;
			ocableRoute.nodecode = portcode;
			ocableRoute.nodetype ="1";
			this.parentApplication.openModel("串接光路",false,ocableRoute);
			
		}
		
		private function joinFaultHandler(event:FaultEvent):void{
			Alert.show("串接失败","提示");
		}
		
		//查看光路路由
		private function showOcableRouteHandler(event:ContextMenuEvent):void{
			var portcode:String=network.selectionModel.lastData.id.toString();
			if(portcode!=null){
				portcode = portcode.split(",")[0];
			}else{
				Alert.show("请选择要查看的端口","提示");
				return;
			}
			//根据端口编码查找复用段，根据复用段查找关联的光路ID
			var ro:RemoteObject = new RemoteObject("fiberWire");
			ro.endpoint = ModelLocator.END_POINT;
			ro.showBusyCursor = true;
			ro.getOpticalIDByPortcode(portcode);
			ro.addEventListener(ResultEvent.RESULT,showOcableRouteResultHandler);
			
		}
		
		private function showOcableRouteResultHandler(event:ResultEvent):void{
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
	
	