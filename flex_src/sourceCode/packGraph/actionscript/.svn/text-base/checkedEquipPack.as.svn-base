import common.actionscript.MyPopupManager;
import common.actionscript.Registry;
import common.component.EI_Follower.Electrical_Interface_Follower;

import mx.collections.ArrayCollection;
import mx.collections.ArrayList;
import mx.containers.HBox;
import mx.containers.TitleWindow;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.Label;
import mx.core.Application;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import org.flexunit.internals.namespaces.classInternal;

import sourceCode.alarmmgr.model.AlarmMangerModel;
import sourceCode.alarmmgr.views.AlarmManager;
import sourceCode.alarmmgrGraph.model.AlarmModel;
import sourceCode.autoGrid.view.ShowProperty;
import sourceCode.channelRoute.views.ViewChannelroute;
import sourceCode.channelRoute.views.tandemcircuit;
import sourceCode.faultSimulation.titles.InterposeFaultTitle;
import sourceCode.faultSimulation.titles.userEventMaintainTitle;
import sourceCode.packGraph.model.LogicPort;
import sourceCode.rootalarm.views.HisRootAlarm;
import sourceCode.rootalarm.views.RootAlarmMgr;

import twaver.AlarmSeverity;
import twaver.Consts;
import twaver.DataBox;
import twaver.DemoUtils;
import twaver.Element;
import twaver.ElementBox;
import twaver.Follower;
import twaver.Grid;
import twaver.ICollection;
import twaver.IData;
import twaver.IElement;
import twaver.Node;
import twaver.SelectionModel;
import twaver.SerializationSettings;
import twaver.Styles;
import twaver.Utils;
	private var logicPort:LogicPort;
	private var tw:TitleWindow;
	import twaver.*;
	import twaver.network.Network;
	import common.actionscript.ModelLocator;
	import flash.ui.ContextMenuItem;
	import flash.events.ContextMenuEvent;
	import sourceCode.sysGraph.views.configSlot;
	import mx.events.CloseEvent;
	import mx.controls.CheckBox;
	import mx.controls.Spacer;
	import mx.graphics.codec.PNGEncoder;
	import mx.containers.TabNavigator;
	import flash.ui.ContextMenu;
	import sourceCode.packGraph.views.OpticalPort;
	import sourceCode.packGraph.views.equipPackalarm;
	import flash.geom.Point;
	import flash.system.Capabilities;
	import flash.events.MouseEvent;
	import sourceCode.faultSimulation.titles.InterposeTitle;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import sourceCode.systemManagement.model.PermissionControlModel;
	import sourceCode.faultSimulation.titles.InterposePortCutTitle;



	private var equipPackArray:ArrayCollection;//电口列表
	private var box:ElementBox = new ElementBox();
	private var c_x:int = 0, c_y:int = 0; // 系统初始化坐标
	private var count_sys:int = 0; // 初始化系统个数
	private var systemArray:Array = new Array();
	private var itemAlarm:equipPackalarm;//告警页面
	private var orgData:ArrayCollection = new ArrayCollection();//业务列表
	private var z_port:String;
	[Bindable]
	public var equipcode:String ="";//设备编码
	[Bindable]
	public var frameserial:String ="";//机框序号
	[Bindable]
	public var slotserial:String ="";//机槽序号
	[Bindable]
	public var packserial:String ="";//机盘序号
	public var alarmpack:AlarmModel=new AlarmModel();
	public var x_capability:String ="";//速率
	public var  logicport:String = "";//端口序号
	public var circuitcode:String;
	public var XMLData:XML;	

	[Embed(source="assets/images/equipPack/unUsingPort.png")]
	public static const unUsingPort:Class;
	
	[Embed(source="assets/images/equipPack/usingPort.png")]
	public static const usingPort:Class;
	
	[Embed(source="assets/images/equipPack/badPort.png")]
	public static const badPort:Class;
	
	[Embed(source="assets/images/equipPack/bg_title.png")]
	public static const bg_title:Class;
	
	private var hbox_id:String,network_id:String;
	private var isAddInterpose:Boolean = false;
	private var belongEquip:String="";
	private var showOper:Boolean = false;
	private var isAddInterposeFault:Boolean=false;
	private var belongPortCode:String="";
	private var isAddCutFault:Boolean=false;
	
	public function get dataBox():DataBox{
		return box; 
	}		

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

	public function initApp():void{
		SerializationSettings.registerGlobalClient("circuitcode", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("equipname", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("portlabel", Consts.TYPE_STRING);
		//注册图片
		Utils.registerImageByClass("unUsingPort", unUsingPort);
		Utils.registerImageByClass("usingPort", usingPort);
		Utils.registerImageByClass("badPort",badPort);
		Utils.registerImageByClass("bg_title", bg_title);
		DemoUtils.initNetworkContextMenu(equipPackPic,null);
		var rt:RemoteObject=new RemoteObject("equipPack");
		rt.endpoint=ModelLocator.END_POINT;
		rt.showBusyCursor=true;
		ModelLocator.registerAlarm();
		rt.addEventListener(ResultEvent.RESULT,getPackTypeResultHandler);
		rt.getPackType(equipcode,frameserial,slotserial,packserial);//获取机盘端口的类型
		box.layerBox.defaultLayer.movable = false;//设置图不能移动
		equipPackPic.elementBox = box;	
		equipPackPic.outerColorFunction=function(data:IData):Object{
			if(data is Electrical_Interface_Follower){
				var element:IElement = IElement(data);
				var severity:AlarmSeverity = element.alarmState.propagateSeverity;
				if(severity != null){
					return severity.color;
				}
				return element.getStyle(Styles.OUTER_COLOR);
			}
			return null;
		};
		equipPackPic.selectionModel.selectionMode=SelectionModel.SINGLE_SELECTION;
		equipPackPic.selectionModel.filterFunction=function (data:Element):Boolean{
			if(data is Electrical_Interface_Follower){
				return true;
			}else{
				return false;
			}
		}
		
		equipPackPic.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,function(e:ContextMenuEvent):void{
			//右键选中网元
			var p:Point = new Point(e.mouseTarget.mouseX / equipPackPic.zoom, e.mouseTarget.mouseY / equipPackPic.zoom);
			var datas:ICollection = equipPackPic.getElementsByLocalPoint(p);
				if (datas.count > 0) 
				{
					equipPackPic.selectionModel.setSelection(datas.getItemAt(0));
				}
				else
				{
				equipPackPic.selectionModel.clearSelection();
			}	
			//定制右键菜单
			var flexVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLEX_SDK_VERSION, false, false);
			var playerVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLASH_PLAYER_VERSION, false, false);
			
			if(equipPackPic.selectionModel.count == 0){//选中元素个数
				equipPackPic.contextMenu.customItems = [flexVersion, playerVersion];
			}
			else{
				var item55:ContextMenuItem = new ContextMenuItem("新建演习科目");
				item55.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
				var item56:ContextMenuItem = new ContextMenuItem("新建故障",true);
				item56.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,itemSelectHandler);
				var item66:ContextMenuItem = new ContextMenuItem("查看当前告警",true);
				item66.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
				var item77:ContextMenuItem = new ContextMenuItem("查看当前原始告警");
				item77.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
//				var item88:ContextMenuItem = new ContextMenuItem("查看历史根告警");
//				item88.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
//				var item99:ContextMenuItem = new ContextMenuItem("查看历史原始告警");
//				item99.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
				var itemCutFault:ContextMenuItem = new ContextMenuItem("新建割接");
				itemCutFault.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
				var item:ContextMenuItem = new ContextMenuItem("处理操作");
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
				item.visible = showOper;
				//选中节点  
				if((Element)(equipPackPic.selectionModel.selection.getItemAt(0)).image != "unUsingPort"&&(Element)(equipPackPic.selectionModel.selection.getItemAt(0)).image != ""&&((Element)(equipPackPic.selectionModel.selection.getItemAt(0)).getClient("circuitcode")==null||(Element)(equipPackPic.selectionModel.selection.getItemAt(0)).getClient("circuitcode")==""))
				{
					var follow:Follower = equipPackPic.selectionModel.selection.getItemAt(0) as Follower;
					var item1 : ContextMenuItem = new ContextMenuItem("本端口属性",true);
					item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, ContexMenuItemSelect);
					var item4 : ContextMenuItem = new ContextMenuItem("串接电路");
					item4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, ContextMenuLuYouTu);
					var item5:ContextMenuItem = new ContextMenuItem("以太网端口绑定");
					item5.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,bindPort);
					if(x_capability!=null&&x_capability=='ZY070116'){
//						equipPackPic.contextMenu.customItems = [item1, item4,item5,item66,item77,item88,item99];
						equipPackPic.contextMenu.customItems = [item1, item4,item5,item77,item];
					}else{
						equipPackPic.contextMenu.customItems = [item1, item4,item77,item];
						}
//						equipPackPic.contextMenu.customItems = [item1, item4,item66,item77,item88,item99];
					
				}
				else if((Element)(equipPackPic.selectionModel.selection.getItemAt(0)) is Follower &&(Element)(equipPackPic.selectionModel.selection.getItemAt(0)).image != ""&&(Element)(equipPackPic.selectionModel.selection.getItemAt(0)).image !="unUsingPort" &&(Element)(equipPackPic.selectionModel.selection.getItemAt(0)).getClient("circuitcode")!=null&&(Element)(equipPackPic.selectionModel.selection.getItemAt(0)).getClient("circuitcode")!="" ){
					var follow:Follower = equipPackPic.selectionModel.selection.getItemAt(0) as Follower;
					var item1 : ContextMenuItem = new ContextMenuItem("本端口属性",true);
					item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, ContexMenuItemSelect);
					var contextMenuItem_z : ContextMenuItem = new ContextMenuItem("对端口属性",true);
					contextMenuItem_z.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, ContexMenuItemZSelect);
					var item4 : ContextMenuItem = new ContextMenuItem("串接电路");
					item4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, ContextMenuLuYouTu);
					var item5 : ContextMenuItem = new ContextMenuItem("电路信息");
					item5.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, ContextMenuChannelRoute);
					var item6:ContextMenuItem = new ContextMenuItem("以太网端口绑定");
					item6.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,bindPort);
//					var item7:ContextMenuItem = new ContextMenuItem("解除关联");
//					item7.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,releaseCircuit);
					if(x_capability!=null&&x_capability=='ZY070116'){
//						equipPackPic.contextMenu.customItems = [item1, contextMenuItem_z, item4,item5,item6,item7,item66,item77,item88,item99];
						equipPackPic.contextMenu.customItems = [item1, contextMenuItem_z, item4,item5,item6,item77,item];
					}else{
						equipPackPic.contextMenu.customItems = [item1, contextMenuItem_z, item4,item5,item77,item];
					}
					
				
//						equipPackPic.contextMenu.customItems = [item1, contextMenuItem_z, item4,item5,item7,item66,item77,item88,item99];
				}else if(x_capability!=null&&x_capability=='ZY070116'&&(Element)(equipPackPic.selectionModel.selection.getItemAt(0)) is Follower &&(Element)(equipPackPic.selectionModel.selection.getItemAt(0)).image != ""){
					var follow:Follower = equipPackPic.selectionModel.selection.getItemAt(0) as Follower;
					var item1 : ContextMenuItem = new ContextMenuItem("本端口属性",true);
					item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, ContexMenuItemSelect);
					var item4 : ContextMenuItem = new ContextMenuItem("串接电路");
					item4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, ContextMenuLuYouTu);
					var item6:ContextMenuItem = new ContextMenuItem("以太网端口绑定");
					item6.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,bindPort);
//					equipPackPic.contextMenu.customItems = [item1, item4,item6,item66,item77,item88,item99];
					equipPackPic.contextMenu.customItems = [item1, item4,item6,item77,item];
					
				}
				else{
					var item1 : ContextMenuItem = new ContextMenuItem("本端口属性",true);
					item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, ContexMenuItemSelect);
//					equipPackPic.contextMenu.customItems = [item1,item66,item77,item88,item99];
					equipPackPic.contextMenu.customItems = [item1,item77,item];
				}
				if(isAddInterposeFault){
					equipPackPic.contextMenu.customItems.push(item56); 
				}
				if(isAddInterpose){
					equipPackPic.contextMenu.customItems.push(item55); 
				}
				
				if(isAddCutFault){//用此种方法添加较方便
					equipPackPic.contextMenu.customItems.push(itemCutFault);
				}
				
			}
		});	
	}

	private function itemSelectHandler(e:ContextMenuEvent):void{
		//传个belongportobject给告警页面
		var follow:Follower = equipPackPic.selectionModel.selection.getItemAt(0) as Follower;
		var alarmport:String = follow.getClient("alarmport");
		var equipPackPic:Object =follow.id;
		belongPortCode=alarmport;
		tw =new TitleWindow();
		tw.layout="absolute";
		tw.x=0;tw.y=0;
//		tw.width=Capabilities.screenResolutionX-50;
//		tw.height=Capabilities.screenResolutionY-250;
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
		
		else if(e.currentTarget.caption=="查看当前告警"){
			tw.title="当前告警";
			var historyRootAlarm:HisRootAlarm=new HisRootAlarm();
			historyRootAlarm.myflag=2;
			historyRootAlarm.belongportobject=belongPortCode;
			tw.addEventListener(CloseEvent.CLOSE,twcolse);
			tw.addChild(historyRootAlarm);
			PopUpManager.addPopUp(tw,main(Application.application),true);
			PopUpManager.centerPopUp(tw);					
		}else 
		if(e.currentTarget.caption=="查看当前原始告警"){
			tw.title="告警查询";
			var currentOriginalAlarm:AlarmManager=new AlarmManager();
			currentOriginalAlarm.belongportobject=belongPortCode;
			currentOriginalAlarm.flag = 1;
			currentOriginalAlarm.iscleared="0";
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
			
		}else if(e.currentTarget.caption=="查看历史原始告警"){
			tw.title="告警查询";
			var historyOriginalAlarm:AlarmManager=new AlarmManager();
			historyOriginalAlarm.flag = 1;
			historyOriginalAlarm.iscleared="1";
			historyOriginalAlarm.belongportobject=belongPortCode;
			tw.addEventListener(CloseEvent.CLOSE,twcolse);
			tw.addChild(historyOriginalAlarm);
			PopUpManager.addPopUp(tw,main(Application.application),true);
			PopUpManager.centerPopUp(tw);
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
			
			eventMaintain.eventList = str;
			eventMaintain.equipcode =belongEquip;
			eventMaintain.title="处理操作";
			eventMaintain.myCallBack=this.initApp;
			eventMaintain.mainApp=this;
		}
	}

	private function twcolse(evt:CloseEvent):void{
		PopUpManager.removePopUp(tw);
	}
	private function releaseCircuit(event:ContextMenuEvent):void{
		var alertString:String = "确认解除此端口的方式关联？";
		Alert.show(alertString,
			"提示",
			Alert.YES|Alert.NO,
			null,
			confirm
		);
	}
	private function confirm(event:CloseEvent):void{
		if(event.detail==Alert.YES){
			var follow:Follower = equipPackPic.selectionModel.selection.getItemAt(0) as Follower;
			var circuitcode:String = follow.getClient("circuitcode");
			var rt:RemoteObject = new RemoteObject("channelTree");
			rt.endpoint = ModelLocator.END_POINT;
			rt.showBusyCursor = true;
			rt.releasePortCircuit(circuitcode);
			rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
				if(event.result!=null&&event.result.toString()=="true"){
					Alert.show("解除成功！","提示");
					drawPort();
				}else{
					Alert.show("解除失败！","提示");
				}
			});
			rt.addEventListener(FaultEvent.FAULT,function(event:FaultEvent):void{
				Alert.show("解除失败！","提示");
			});
		}
	}
	private function bindPort(event:ContextMenuEvent):void{
		var follow:Follower = equipPackPic.selectionModel.selection.getItemAt(0) as Follower;
		var slot:configSlot=new configSlot();
		slot.equipcode=equipcode;
		slot.portA_code = follow.id.toString();
		MyPopupManager.addPopUp(slot, true);
		slot.equip.text=follow.getClient("equipname");
		slot.port_a.text = follow.getClient("portlabel");
		slot.addEventListener("configSlotSucess",function():void{
			drawPort();
		});
	}
	public function getPackTypeResultHandler(event:ResultEvent):void{
		//按速率分为两种:1电口，2光口
		var packtype:ArrayCollection=event.result as ArrayCollection;
		if(packtype!=null){
			if(packtype.length==1){
				if(packtype.getItemAt(0).toString()=='1'){
					if(tab_view.numChildren==2){
						tab_view.removeChildAt(1);
					}
					drawPort();
				}
				else{//光口
					tab_view.removeChildAt(0);
					showOpticalPort();
				}
			}else{
				drawPort();
				showOpticalPort();
			}
		}
	}
		/**
		 *画电口 
		 * 
		 */
	public function drawPort():void{
		var rtobj1:RemoteObject = new RemoteObject("equipPack");
		rtobj1.endpoint = ModelLocator.END_POINT;
		rtobj1.showBusyCursor = true;
		rtobj1.drawPort(equipcode,frameserial,slotserial,packserial);//获取电口的信息
		rtobj1.addEventListener(ResultEvent.RESULT,equipPack_reusultHandel);
		Application.application.faultEventHandler(rtobj1);
	}
		/**
		 * 显示光口列表图
		 * 
		 */
		private function showOpticalPort():void
		{
		var portList:OpticalPort=new OpticalPort();
		portList.label=this.label;
		portList.equipcode = equipcode;
		portList.frameserial = frameserial;//机框序号
		portList.slotserial = slotserial;//机槽序号
		portList.packserial = packserial;//机盘序号
		portList.x_capability = x_capability;//速率
		equipPackPic2.addChild(portList);
	}
	//显示电口列表图

		private function equipPack_reusultHandel(event:ResultEvent):void
		{	
		equipPackPic.elementBox.clear();
		var portList:ArrayCollection=event.result as ArrayCollection;
		var portCount:int=portList.length;
		if(portCount < 1){
			Alert.show("该机盘下未找到端口！");
		}
		//计算Grid行数
		var rowCount:int = 0;//行数
		if(portCount%10 != 0){//取余
			rowCount = portCount/10 + 1;//有余数，行数加一行
		}else{
			rowCount = portCount/10;
		}	
		var height:int=150*rowCount+58;
			//机盘名称
		var fwr:Follower=new Follower();
		fwr.setSize(958,35);
		fwr.setLocation(20,15);
		fwr.image="bg_title";
		fwr.setStyle(Styles.LABEL_POSITION,Consts.POSITION_CENTER);
		fwr.setStyle(Styles.LABEL_SIZE,18);
		fwr.setStyle(Styles.LABEL_COLOR,0xFFFFFF);
		fwr.setStyle(Styles.IMAGE_STRETCH,Consts.STRETCH_FILL);
		fwr.name=this.label+" - 机盘管理视图";
		box.add(fwr);
		var grid:twaver.Grid=new twaver.Grid();
		grid.setLocation(20,50);
		grid.setStyle(Styles.GRID_COLUMN_COUNT,1);
		grid.setStyle(Styles.GRID_ROW_COUNT,1);
		grid.setStyle(Styles.GRID_BORDER,4);
		grid.setStyle(Styles.CONTENT_TYPE,Consts.CONTENT_TYPE_VECTOR);
		grid.setStyle(Styles.VECTOR_FILL_COLOR,0x2C394C);
		grid.setStyle(Styles.VECTOR_FILL_ALPHA,1);
		grid.setStyle(Styles.VECTOR_GRADIENT,Consts.GRADIENT_LINEAR_NORTHEAST);
		grid.setStyle(Styles.VECTOR_GRADIENT_COLOR,0x3D4B66);
		grid.setStyle(Styles.VECTOR_GRADIENT_ALPHA,1);
		grid.setSize(958,height);
		box.add(grid);
			var grid2:Grid=new Grid();//端口网格
		grid2.setStyle(Styles.GRID_COLUMN_COUNT,10);
		grid2.setStyle(Styles.GRID_ROW_COUNT,rowCount);
		grid2.setStyle(Styles.CONTENT_TYPE,Consts.CONTENT_TYPE_VECTOR);
		grid2.setStyle(Styles.VECTOR_FILL,true);
		grid2.setStyle(Styles.VECTOR_FILL_ALPHA,1);
		grid2.setStyle(Styles.VECTOR_FILL_COLOR,0xEFEFEF);
		grid2.setStyle(Styles.VECTOR_GRADIENT,Consts.GRADIENT_LINEAR_SOUTH);
		grid2.setStyle(Styles.VECTOR_GRADIENT_ALPHA,1);
		grid2.setStyle(Styles.VECTOR_GRADIENT_COLOR,0xFCFCFC);
		grid2.setStyle(Styles.GRID_PADDING_BOTTOM,70);
		grid2.setStyle(Styles.GRID_CELL_DEEP,0);
		grid2.setStyle(Styles.GRID_BORDER,25);
		grid2.setStyle(Styles.GRID_PADDING_LEFT,5);
		grid2.setStyle(Styles.GRID_PADDING_RIGHT,5);
		grid2.setStyle(Styles.GRID_FILL,true);
		grid2.setStyle(Styles.FOLLOWER_COLUMN_INDEX,0);
		grid2.setStyle(Styles.FOLLOWER_ROW_INDEX,0);
		grid2.host=grid;
		box.add(grid2);
		for(var i:int=0;i<rowCount;i++){
			for(var j:int=0;j<10;j++){
				if(i*10+j>=portCount){
					break;
				}
				var port:LogicPort=portList.getItemAt(i*10+j) as LogicPort;
				var circuitcode:String="";
				var follower:Electrical_Interface_Follower=new Electrical_Interface_Follower(port.logicport);
				follower.setStyle(Styles.FOLLOWER_COLUMN_INDEX,j);
				follower.setStyle(Styles.FOLLOWER_ROW_INDEX,i);
				follower.name=port.portserial;
					if( parseInt(port.totalCount)>0)//有业务
					{
						follower.image="usingPort";
					}
					else
					{
					follower.image="unUsingPort";
				}
					if(port.status=="ZY13100203")//坏端口
					{
						follower.image="badPort";
					}
					if(port.circuitcode == null || port.circuitcode == "")
					{
						follower.setClient("profession", "");
					}
					else
					{
					follower.setClient("profession",port.circuitcode);
					follower.setClient("circuitcode", port.circuitcode);
				}
				follower.setClient("equipname",port.equipname);
				follower.setClient("portlabel",port.portlabel);
				follower.setClient("alarmport",port.equipcode+"="+port.frameserial+"="+port.slotserial+"="+port.packserial+"="+port.portserial);
				follower.setStyle(Styles.IMAGE_STRETCH,Consts.STRETCH_FILL);
				follower.setStyle(Styles.LABEL_POSITION,Consts.POSITION_TOP_BOTTOM);
				follower.setStyle(Styles.LABEL_YOFFSET,10);
				follower.setStyle(Styles.LABEL_FONT,"黑体");
				follower.setStyle(Styles.LABEL_SIZE,12);
				follower.setStyle(Styles.INNER_STYLE,Consts.INNER_STYLE_SHAPE);
				follower.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
				follower.setStyle(Styles.SELECT_COLOR,"0x00FF00");
				follower.setStyle(Styles.SELECT_WIDTH,'10');
				follower.host=grid2;
				if(null != port.username){
					follower.toolTip="业务名称:"+port.username;
				}
				box.add(follower);
			}
		}
		getAlarms();
		setLocation();
	}
	//增加事件监听
	private function preGetPortYewuInfo(rtobj:RemoteObject,id:int):void{
		rtobj.addEventListener(ResultEvent.RESULT, function (e:ResultEvent):void{
			getPortYewuInfo(e,id);
		});	
	}
	//获取该端口上的业务信息
	private function getPortYewuInfo(event:ResultEvent,id:int):void{
		var XMLData:XML = new XML(event.result.toString());	
		var circuitcode:String = XMLData.children().@circuitcode;
		if(event.result != null){
			var circuitcode:String = event.result.toString();
			var circuitcode_temp:String = "";
			circuitcode_temp += circuitcode.substr(0,7)+"\n";	
			circuitcode_temp += circuitcode.substr(7)+"\n";
			var follower11:Follower = box.getElementByID(id) as Follower;
			var node:Node = new Node();
			node.name = circuitcode_temp;
			node.image = "";
			node.getClient("circuitcode");
			var center:Point = follower11.centerLocation;
			node.setCenterLocation(center.x,center.y+3);
			box.add(node);
		}
	}
		//增加事件监听
	private function preAddImage(rtobj:RemoteObject,id:int):void{
		rtobj.addEventListener(ResultEvent.RESULT,function (event:ResultEvent):void{
			addImage(event,id);
		});
	}
	//判断端口是否有业务.根据有无业务，显示不同图片(uningPort:占用，unUsingPort:未占用)
	private function addImage(event:ResultEvent,id:int):void{
		var count:int = Number(event.result);//占用业务数，判断是否占用
		var follower:Follower = box.getElementByID(id) as Follower;
		if(count > 0){				
			follower.image = "uningPort";
			}
			else{
			follower.image = "unUsingPort";
		}
	}
	private  function   setDataProvide(e:ResultEvent):void{		
		XMLData = new XML(e.result.toString());				
		
			for each(var arrxml:XML in XMLData.children())
			{
			orgData.addItem(arrxml);
		}
	}
	//业务
	private  function setDataProvidePack(e:ResultEvent):void{
		XMLData = new XML(e.result.toString());				
		var orgData:ArrayCollection = new ArrayCollection();
		
		for each(var arrxml:XML in XMLData.children())
		{
			orgData.addItem(arrxml);
			
		}
	}	
	//电路路由图
	private function ContextMenuLuYouTu(evt:ContextMenuEvent):void{
		var follow:Follower = equipPackPic.selectionModel.selection.getItemAt(0) as Follower;
		var tandem:tandemcircuit = new tandemcircuit();
		if((Element)(equipPackPic.selectionModel.selection.getItemAt(0)).image != "unUsingPort"&&(Element)(equipPackPic.selectionModel.selection.getItemAt(0)).image != ""){
			tandem.c_circuitcode = follow.getClient("circuitcode");
			tandem.logicport = follow.id as String;
			tandem.equippack = this;
			tandem.equippack_follower = follow;
			if(x_capability!=null&&x_capability=='ZY070112'){
				tandem.flag='64K';
				tandem.slot='1';
			}else if(x_capability!=null&&x_capability =='ZY070116'){
				tandem.flag = '10M-100M';
				tandem.slot='1';
			}
			this.parentApplication.openModel("串接电路",true,tandem);
		}else 
		{
			Alert.show("没有与之关联的串接电路！","提示！");
		}
	}
	private function ContextMenuChannelRoute(evt:ContextMenuEvent):void{
		var follow:Follower = equipPackPic.selectionModel.selection.getItemAt(0) as Follower;
		
		if((Element)(equipPackPic.selectionModel.selection.getItemAt(0)).image != "unUsingPort"&&(Element)(equipPackPic.selectionModel.selection.getItemAt(0)).image != ""){
			
			var rtobj1:RemoteObject=new RemoteObject("fiberWire");
			rtobj1.endpoint=ModelLocator.END_POINT;
			rtobj1.showBusyCursor=true;
			var str:String=follow.getClient("circuitcode");
			rtobj1.getTypeBycircuitCode(str);
			rtobj1.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void
			{
				if(event.result){
					Registry.register("para_circuitcode", str);
					Registry.register("para_circuitype", event.result.toString());
					Application.application.openModel("方式信息", false);
				}
			});
		}else 
		{
			Alert.show("没有相应的电路！","提示！");
		}
	}
	//属性
	private function ContexMenuItemSelect(evt:ContextMenuEvent):void{
		var node:Follower = equipPackPic.selectionModel.selection.getItemAt(0) as Follower;
		var equipPackPic:Object =node.id; 
		var property:ShowProperty = new ShowProperty();
		property.paraValue = equipPackPic.toString();
		property.tablename = "VIEW_EQUIPLOGICPORT_PROPERTY";
		property.key = "LOGICPORT";
		property.title = node.name+"—端口属性";
		PopUpManager.addPopUp(property, this, true);
		PopUpManager.centerPopUp(property);
	}
	private function ContexMenuItemZSelect(evt:ContextMenuEvent):void{
		var node:Follower = equipPackPic.selectionModel.selection.getItemAt(0) as Follower;
		var a_port:String = node.id.toString();
		var portPropertiesRO:RemoteObject = new RemoteObject("equipPack");
		portPropertiesRO.endpoint=ModelLocator.END_POINT;
		portPropertiesRO.getZPort(a_port);
		portPropertiesRO.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void{
			getZPortProperties(event,node);
		});
		Application.application.faultEventHandler(portPropertiesRO);
	}
	private function getZPortProperties(e:ResultEvent,node:Follower):void
	{
		if(e.result){
				z_port = e.result.toString();
				var property:ShowProperty = new ShowProperty();
				property.paraValue = z_port;
				property.tablename = "VIEW_EQUIPLOGICPORT_PROPERTY";
				property.key = "LOGICPORT";
				property.title = node.name+"—对端端口属性";
				PopUpManager.addPopUp(property, this, true);
				PopUpManager.centerPopUp(property);	
		}
	}
	//属性更新
	private function doukouChick(e:MouseEvent):void {
		var flexVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLEX_SDK_VERSION, false, false);
		var playerVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLASH_PLAYER_VERSION, false, false);
		
			if(equipPackPic.selectionModel.count == 0){//选中元素个数
			equipPackPic.contextMenu.customItems = [flexVersion, playerVersion];
		}
		else{
			if((Element)(equipPackPic.selectionModel.selection.getItemAt(0)).image != "")
			{
				var follow:Follower = equipPackPic.selectionModel.selection.getItemAt(0) as Follower;						
				//有业务的端口
				if((Element)(equipPackPic.selectionModel.selection.getItemAt(0)) is Follower 
					&&(Element)(equipPackPic.selectionModel.selection.getItemAt(0)).image != "" 
					&&(Element)(equipPackPic.selectionModel.selection.getItemAt(0)).getClient("circuitcode")!=null 
					&&(Element)(equipPackPic.selectionModel.selection.getItemAt(0)).getClient("circuitcode")!=""){
					var rtobj1:RemoteObject=new RemoteObject("fiberWire");
					rtobj1.endpoint=ModelLocator.END_POINT;
					rtobj1.showBusyCursor=true;
					var str:String=follow.getClient("circuitcode");
					rtobj1.getTypeBycircuitCode(str);
					rtobj1.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void
					{
						if(event.result){
							Registry.register("para_circuitcode", str);
							Registry.register("para_circuitype", event.result.toString());
							Application.application.openModel("方式信息", false);
							
						}
					});
				}else if((Element)(equipPackPic.selectionModel.selection.getItemAt(0)).image != "unUsingPort"){
					var tandem:tandemcircuit = new tandemcircuit();
					tandem.c_circuitcode = follow.getClient("circuitcode");
					tandem.logicport = follow.id as String;
					tandem.equippack = this;
					tandem.equippack_follower = follow;
					this.parentApplication.openModel("串接电路",true,tandem);
				}else{
					//Alert.show("没有与之关联的串接电路！","提示！");
				}
				
			}
		}
	}
		/**
		 *获取当前机盘电口的告警信息 
		 * 
		 */
	private function getAlarms():void{
		var rtc:RemoteObject = new RemoteObject("equipPack");
		rtc.endpoint = ModelLocator.END_POINT;
		rtc.showBusyCursor = true;
		rtc.addEventListener(ResultEvent.RESULT,getAlarmResult);
		Application.application.faultEventHandler(rtc);
		rtc.getPortAlarm(equipcode,frameserial,slotserial,packserial);
		
	}
	private function showa(e:FaultEvent):void{
		Alert.show(e.toString());
	}
	private function getAlarmResult(event:ResultEvent):void{
		//先清除
		box.forEach(function(element:Element):void{
			element.alarmState.clear();
		}
		);
		var alarmarray:ArrayCollection=event.result as ArrayCollection;
		for(var i:int=0;i<alarmarray.length;i++){
			
			refreshAlarm(alarmarray[i].ALARMPORT,alarmarray[i].ALARMLEVEL,alarmarray[i].ALARMCOUNT);
		}
	}
	private function refreshAlarm(packcode:String,alarmlevel:int,alarmcount:int):void{
		box.forEach(function(element:Element):void{
			if(element.getClient("alarmport")!=null&&element.getClient("alarmport")==packcode){
				element.alarmState.setNewAlarmCount(AlarmSeverity.getByValue(alarmlevel),alarmcount);
			}
		}
		);
	}
	//告警定位
	private function setLocation():void{
		var portcode:String=Registry.lookup("portcode");
		Registry.unregister("portcode");
		if(portcode!=null && portcode!=""){
			equipPackPic.elementBox.forEach(function(element:Element):void{
				if(element.id==portcode){
					equipPackPic.elementBox.selectionModel.setSelection(element);
					element.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
					element.setStyle(Styles.SELECT_COLOR,"0x00FF00");
					element.setStyle(Styles.SELECT_WIDTH,10);
				}
			});
		}
	}
