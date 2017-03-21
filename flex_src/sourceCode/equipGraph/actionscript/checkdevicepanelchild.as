import com.adobe.serialization.json.JSON;
import com.adobe.utils.StringUtil;

import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.actionscript.Registry;
import common.other.blogagic.util.HTMLToolTip;

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.net.FileReference;
import flash.system.Capabilities;
import flash.ui.ContextMenuItem;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.Timer;

import flexlib.scheduling.Timeline;

import flexunit.utils.ArrayList;

import mx.collections.ArrayCollection;
import mx.collections.XMLListCollection;
import mx.containers.TitleWindow;
import mx.controls.Alert;
import mx.controls.CheckBox;
import mx.controls.Spacer;
import mx.controls.Tree;
import mx.core.Application;
import mx.core.DragSource;
import mx.events.CloseEvent;
import mx.events.DragEvent;
import mx.events.ItemClickEvent;
import mx.graphics.codec.PNGEncoder;
import mx.managers.PopUpManager;
import mx.managers.ToolTipManager;
import mx.messaging.events.ChannelEvent;
import mx.printing.FlexPrintJob;
import mx.printing.FlexPrintJobScaleType;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import org.flexunit.runners.ParentRunner;

import sourceCode.alarmmgr.model.AlarmMangerModel;
import sourceCode.alarmmgr.views.AlarmManager;
import sourceCode.alarmmgrGraph.model.AlarmModel;
import sourceCode.alarmmgrGraph.views.currentOrHistoryOriginalAlarmView;
import sourceCode.alarmmgrGraph.views.currentOrHistoryRootAlarmView;
import sourceCode.equipGraph.model.CardModel;
import sourceCode.equipGraph.model.PackInfoModel;
import sourceCode.equipGraph.views.viewequipPackInfo;
import sourceCode.equipGraph.views.viewslotInfo;
import sourceCode.faultSimulation.titles.InterposeFaultTitle;
import sourceCode.faultSimulation.titles.InterposePackCutTitle;
import sourceCode.faultSimulation.titles.InterposeTitle;
import sourceCode.faultSimulation.titles.userEventMaintainTitle;
import sourceCode.ocableTopo.views.businessInfluenced;
import sourceCode.rootalarm.views.HisRootAlarm;
import sourceCode.rootalarm.views.RootAlarmMgr;
import sourceCode.sysGraph.views.CarryOpera;
import sourceCode.sysGraph.views.ShowPerDatas;
import sourceCode.systemManagement.model.PermissionControlModel;

import twaver.AlarmSeverity;
import twaver.Consts;
import twaver.DataBox;
import twaver.DemoImages;
import twaver.DemoUtils;
import twaver.Element;
import twaver.ElementBox;
import twaver.Follower;
import twaver.Grid;
import twaver.ICollection;
import twaver.ISerializable;
import twaver.Node;
import twaver.SelectionModel;
import twaver.SerializationSettings;
import twaver.Styles;
import twaver.Utils;
import twaver.XMLSerializer;
import twaver.controls.GifImage;
import twaver.network.Network;

[Embed(source="assets/swf/pack/screw.png")]
public static const png_screw:Class;
[Embed(source="assets/swf/pack/fan1.swf")]
public static const fan1:Class;
[Embed(source="assets/swf/pack/pw.swf")]
public static const pw:Class;
[Embed(source="assets/swf/pack/plate2.swf")]
public static const plate2:Class;
[Embed(source="assets/swf/pack/plate4.swf")]
public static const plate4:Class;
[Embed(source="assets/swf/pack/plate6.swf")]
public static const plate6:Class;
[Embed(source="assets/swf/pack/plate8.swf")]
public static const plate8:Class;
[Embed(source="assets/swf/pack/plate10.swf")]
public static const plate10:Class;
[Embed(source="assets/swf/pack/plate12.swf")]
public static const plate12:Class;
[Embed(source="assets/swf/pack/plate14.swf")]
public static const plate14:Class;
[Embed(source="assets/swf/pack/standard1_0.swf")]
public static const standard1_0:Class;
[Embed(source="assets/swf/pack/standard1_1.swf")]
public static const standard1_1:Class;
[Embed(source="assets/swf/pack/standard1_2.swf")]
public static const standard1_2:Class;
[Embed(source="assets/swf/pack/standard1_3.swf")]
public static const standard1_3:Class;
[Embed(source="assets/swf/pack/standard1_4.swf")]
public static const standard1_4:Class;
[Embed(source="assets/swf/pack/standard1_n.swf")]
public static const standard1_n:Class;
[Embed(source="assets/swf/pack/standard1_blank.swf")]
public static const standard1_blank:Class;
[Embed(source="assets/swf/pack/standard2_0.swf")]
public static const standard2_0:Class;
[Embed(source="assets/swf/pack/standard2_1.swf")]
public static const standard2_1:Class;
[Embed(source="assets/swf/pack/standard2_2.swf")]
public static const standard2_2:Class;
[Embed(source="assets/swf/pack/standard2_3.swf")]
public static const standard2_3:Class;
[Embed(source="assets/swf/pack/standard2_4.swf")]
public static const standard2_4:Class;
[Embed(source="assets/swf/pack/standard2_n.swf")]
public static const standard2_n:Class;
[Embed(source="assets/swf/pack/standard2_blank.swf")]
public static const standard2_blank:Class;
[Embed(source="assets/swf/pack/standard3_0.swf")]
public static const standard3_0:Class;
[Embed(source="assets/swf/pack/standard3_1.swf")]
public static const standard3_1:Class;
[Embed(source="assets/swf/pack/standard3_2.swf")]
public static const standard3_2:Class;
[Embed(source="assets/swf/pack/standard3_3.swf")]
public static const standard3_3:Class;
[Embed(source="assets/swf/pack/standard3_4.swf")]
public static const standard3_4:Class;
[Embed(source="assets/swf/pack/standard3_n.swf")]
public static const standard3_n:Class;
[Embed(source="assets/swf/pack/standard3_blank.swf")]
public static const standard3_blank:Class;
[Embed(source="assets/swf/pack/standard05_1_0.swf")]
public static const standard05_1_0:Class;
[Embed(source="assets/swf/pack/standard05_1_1.swf")]
public static const standard05_1_1:Class;
[Embed(source="assets/swf/pack/standard05_1_2.swf")]
public static const standard05_1_2:Class;
[Embed(source="assets/swf/pack/standard05_1_3.swf")]
public static const standard05_1_3:Class;
[Embed(source="assets/swf/pack/standard05_1_4.swf")]
public static const standard05_1_4:Class;
[Embed(source="assets/swf/pack/standard05_1_n.swf")]
public static const standard05_1_n:Class;
[Embed(source="assets/swf/pack/standard05_1_blank.swf")]
public static const standard05_1_blank:Class;
[Embed(source="assets/swf/pack/horizontal1_2_0.swf")]
public static const horizontal1_2_0:Class;
[Embed(source="assets/swf/pack/horizontal1_2_1.swf")]
public static const horizontal1_2_1:Class;
[Embed(source="assets/swf/pack/horizontal1_2_2.swf")]
public static const horizontal1_2_2:Class;
[Embed(source="assets/swf/pack/horizontal1_2_3.swf")]
public static const horizontal1_2_3:Class;
[Embed(source="assets/swf/pack/horizontal1_2_4.swf")]
public static const horizontal1_2_4:Class;
[Embed(source="assets/swf/pack/horizontal1_2_n.swf")]
public static const horizontal1_2_n:Class;
[Embed(source="assets/swf/pack/horizontal1_2_blank.swf")]
public static const horizontal1_2_blank:Class;
[Embed(source="assets/swf/pack/horizontal1_3_0.swf")]
public static const horizontal1_3_0:Class;
[Embed(source="assets/swf/pack/horizontal1_3_1.swf")]
public static const horizontal1_3_1:Class;
[Embed(source="assets/swf/pack/horizontal1_3_2.swf")]
public static const horizontal1_3_2:Class;
[Embed(source="assets/swf/pack/horizontal1_3_3.swf")]
public static const horizontal1_3_3:Class;
[Embed(source="assets/swf/pack/horizontal1_3_4.swf")]
public static const horizontal1_3_4:Class;
[Embed(source="assets/swf/pack/horizontal1_3_n.swf")]
public static const horizontal1_3_n:Class;
[Embed(source="assets/swf/pack/horizontal1_3_blank.swf")]
public static const horizontal1_3_blank:Class;
[Embed(source="assets/swf/pack/horizontal2_2_0.swf")]
public static const horizontal2_2_0:Class;
[Embed(source="assets/swf/pack/horizontal2_2_1.swf")]
public static const horizontal2_2_1:Class;
[Embed(source="assets/swf/pack/horizontal2_2_2.swf")]
public static const horizontal2_2_2:Class;
[Embed(source="assets/swf/pack/horizontal2_2_3.swf")]
public static const horizontal2_2_3:Class;
[Embed(source="assets/swf/pack/horizontal2_2_4.swf")]
public static const horizontal2_2_4:Class;
[Embed(source="assets/swf/pack/horizontal2_2_n.swf")]
public static const horizontal2_2_n:Class;
[Embed(source="assets/swf/pack/horizontal2_2_blank.swf")]
public static const horizontal2_2_blank:Class;

[Embed(source="assets/images/toggle.gif")]
public static const toggle:Class;
[Embed(source="assets/swf/pack/mainbg.png")]
public static const mainbg:Class;
[Embed(source="assets/swf/pack/unode.png")]
public static const unode:Class;

[Embed(source="assets/swf/pack/nobusiness.swf")]
public static const nobusiness:Class;


private var pageIndex:int=0;
private var pageSize:int=5;
private var tw:TitleWindow;
private var box:ElementBox = new ElementBox();
private var serializable:ISerializable = null;
private var timer:Timer=new Timer(200);
private var fillAlpha:Number=0.8;
private var increase:Boolean=true;

public var slotdirc:String="0";//机槽正反面，0表示正面

private var c_x:int = 0, c_y:int = 0; // 系统初始化坐标
private var i:int = 0; // 初始化系统个数
private var systemArray:Array = new Array();
private var itemEquipPackInfo:sourceCode.equipGraph.views.viewequipPackInfo; //机盘属性页面	
private var addEquipPackInfo:sourceCode.equipGraph.views.viewequipPackInfo;
private var itemSlotInfo:viewslotInfo;//插槽业务页面

public var parentObj:Object;
public var equipcode : String = "";
public var equipname : String = "";
public var systemcode:String="";
public var xml:String="";
public var x_vendor:String = "";
public var x_model:String = "";
public var preElement:Element=new Element();
public var alarmequip:AlarmModel=new AlarmModel();
public var element_:Element = new Element();

public var tooltipStr:String = "";
private  var belongCode:String="";


//public var arraylist2:flexunit.utils.ArrayList = new flexunit.utils.ArrayList();
public var arraylist2:ArrayCollection = new ArrayCollection();

private var flag = true;

[Bindable]
public var elementBox:ElementBox;

[Bindable]
public var XMLData:XML;	

public function get dataBox():DataBox{
	return box;
}

[Bindable]   
public var folderList:XMLList= new XMLList(); 

[Bindable]   
public var folderCollection:XMLListCollection;

private var isAdd:Boolean = false;
private var isAddInterpose:Boolean = false;
private var belongEquip:String="";
private var showOper:Boolean = false;
private var isAddInterposeFault:Boolean=false;
private var isAddCutFault:Boolean=false;

private function preinitialize():void{
	if(ModelLocator.permissionList!=null&&ModelLocator.permissionList.length>0){
		isAdd = false;
		isAddInterpose = false;
		showOper = false;
		isAddCutFault=false;
		for(var i:int=0;i<ModelLocator.permissionList.length;i++){
			var model:PermissionControlModel = ModelLocator.permissionList[i];
			if(model.oper_name!=null&&model.oper_name=="添加机盘"){
				isAdd = true;
			}
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

public function initApp():void  
{
	ToolTipManager.toolTipClass = HTMLToolTip;
	initNetworkToolbar(childtoolbar, devicePic);
	
	DemoUtils.initNetworkContextMenu(devicePic,null);
	
	registerImage();
	
	SerializationSettings.registerGlobalClient("card_image", Consts.TYPE_STRING); 
	SerializationSettings.registerGlobalClient("ShapeType", Consts.TYPE_STRING);
	SerializationSettings.registerGlobalClient("frame_name", Consts.TYPE_STRING);
	
	initBox();
	
	devicePic.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,function(e:ContextMenuEvent):void{
		//右键选中网元
		var p:Point = new Point(e.mouseTarget.mouseX / devicePic.zoom, e.mouseTarget.mouseY / devicePic.zoom);
		var datas:ICollection = devicePic.getElementsByLocalPoint(p);
		if (datas.count > 0) {
			devicePic.selectionModel.setSelection(datas.getItemAt(0));
		}else{
			devicePic.selectionModel.clearSelection();
		}
		//定制右键菜单
		var flexVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLEX_SDK_VERSION, false, false);
		var playerVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLASH_PLAYER_VERSION, false, false);
		var addPack:ContextMenuItem = new ContextMenuItem("添加盘");
		addPack.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
		addPack.visible = isAdd;
		if(devicePic.selectionModel.count == 0){//选中元素个数
			devicePic.contextMenu.customItems = [flexVersion, playerVersion];
		}
		else{
			var element:Element=devicePic.selectionModel.selection.getItemAt(0) as Element;
			var iscard:String=element.getClient("iscard") as String;
			
			var item8:ContextMenuItem = new ContextMenuItem("新建演习科目",true);
			item8.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,itemSelectHandler);
			
			var item9:ContextMenuItem = new ContextMenuItem("新建故障",true);
			item9.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,itemSelectHandler);
			
			var item6:ContextMenuItem = new ContextMenuItem("处理操作");
			item6.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
			item6.visible = showOper;
			
			var item5:ContextMenuItem = new ContextMenuItem("查看当前原始告警");
			item5.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
			
			var item10:ContextMenuItem = new ContextMenuItem("新建割接",true);
			item10.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,itemSelectHandler);
			
			if (iscard!=null&&iscard=="yes") {//选中节点 
				//Alert.show(iscard); 
				var item1:ContextMenuItem = new ContextMenuItem("查看属性", true);
				item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
				var item_view:ContextMenuItem = new ContextMenuItem("机盘管理视图", true);
				item_view.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
				var item_add:ContextMenuItem = new ContextMenuItem("查看机盘业务", true);
				item_add.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
				var item4:ContextMenuItem = new ContextMenuItem("查看当前告警",true);
				item4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
//				var item6:ContextMenuItem = new ContextMenuItem("查看历史根告警");
//				item6.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
//				var item7:ContextMenuItem = new ContextMenuItem("查看历史原始告警");
//				item7.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
				
				devicePic.contextMenu.hideBuiltInItems();
//				if(element.getClient("porttype").indexOf('STM')!=-1){
//					item8.enabled=true;
//				}else{
//					item8.enabled=false;
//				}
				var hasPort:String=element.getClient("hasPort") as String;
				devicePic.contextMenu.customItems = [item1,item5,item6];
//				if(hasPort=="1"){
				devicePic.contextMenu.customItems.push(item_view);
				devicePic.contextMenu.customItems.push(item_add);
//					devicePic.contextMenu.customItems = [item1,item_view,item_add,item5,item6];
//				}
//				else{
//					devicePic.contextMenu.customItems = [item1,item5,item6];
//				}
				
				
				if(isAddInterposeFault){
					devicePic.contextMenu.customItems.push(item9);
				}
				if(isAddInterpose){
					devicePic.contextMenu.customItems.push(item8);
				}
				if(isAddCutFault){
					devicePic.contextMenu.customItems.push(item10);
				}
			}
			else{
				if((element as Follower).image == "nobusiness"){
					var item19:ContextMenuItem = new ContextMenuItem("查看属性", true);
					item19.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
					devicePic.contextMenu.customItems = [item19,item6,item5];
					if(isAddInterposeFault){
						devicePic.contextMenu.customItems.push(item9);
					}
					if(isAddInterpose){
						devicePic.contextMenu.customItems.push(item8);
					}
				}else{
					if((element as Follower).image != "image_C3")
						devicePic.contextMenu.customItems = [addPack];
					else
						devicePic.contextMenu.customItems = [];
				}
			}
		}
	});
	
		
	var s:Spacer = new Spacer();
	s.width=10;
	childtoolbar.addChild(s);
	childtoolbar.addChild(createCheckBox('面板图背面',checkbox_alarmHandler));
	var ss:Spacer = new Spacer();
	ss.width=10;
	childtoolbar.addChild(ss);
	childtoolbar.addChild(createCheckBox('呈现机盘端口序号',checkbox_alarmHandler));

	devicePic.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
}


public function createCheckBox(name:String,changeHandler:Function):CheckBox{
	var chk:CheckBox = new CheckBox();
	chk.label =name;	
	chk.id =name;
	chk.selected = false;
	if(name=="面板图背面"&&slotdirc=="1"){
		chk.selected=true;
	}
	
	chk.addEventListener(Event.CHANGE,changeHandler);
	return chk;
}

private function getModelContextNew(flag:String):void{//重新获取面板
	
	var rt:RemoteObject=new RemoteObject("devicePanel");
	rt.endpoint = ModelLocator.END_POINT;
	rt.showBusyCursor = true;
	rt.addEventListener(ResultEvent.RESULT,function(e:ResultEvent):void{
		xml = e.result.toString();
		box = new ElementBox();
		initBox();
	} );
	rt.getModelContextNew(x_vendor,x_model,flag);
}

private function checkbox_alarmHandler(event:Event):void
{
	for each(var item:* in childtoolbar.getChildren())
	{
		if(item is CheckBox&& item.label=='面板图背面')
		{			
			if(item.selected)
			{
				slotdirc="1";
				//重新获取面板
				getModelContextNew(slotdirc);
			}
			else{
				slotdirc="0";
				getModelContextNew(slotdirc);
			}
		}
	 if(item is CheckBox && item.label=='呈现机盘端口序号'){
			if(item.selected)
			{
				if(flag){
					for(var i:int=0;i<box.datas.count;i++){
						element_= box.datas.getItemAt(i) as Element;
						if(null != element_ && element_ is Follower){
							var shapetype:String=element_.getClient("ShapeType") as String;
							var hasPort:String = element_.getClient("hasPort") as String;
							var iscard:String = element_.getClient("iscard") as String
							if(shapetype == "板卡" && hasPort == "1" &&hasPort!=null && iscard!=null && iscard == "yes"){
								var packcode:String = element_.getClient("packcode").toString();
								var rate:String = element_.getClient("rate").toString();
								var id:String = element_.id.toString();
								var arraylist1:ArrayCollection = new ArrayCollection();
								arraylist1.addItem(packcode);
								arraylist1.addItem(rate);
								arraylist1.addItem(id);
								arraylist2.addItem(arraylist1);
							}
						}
					}
					var rtobj:RemoteObject=new RemoteObject("devicePanel");
					rtobj.endpoint=ModelLocator.END_POINT;
					rtobj.showBusyCursor=true;
					rtobj.getTooltip(arraylist2);
					rtobj.addEventListener(ResultEvent.RESULT,getTooltip);
					Application.application.faultEventHandler(rtobj);
				}
				flag = false;
			}
		}
	}
}




/*注册图片
*
*/
private function registerImage():void{
	Utils.registerImageByClass("png_unode",unode);
	Utils.registerImageByClass("mainbg",mainbg);
	Utils.registerImageByClass("fan1",fan1,true);
	Utils.registerImageByClass("0",fan1,true);
	Utils.registerImageByClass("pw",pw,true);
	Utils.registerImageByClass("png_screw",png_screw);
	Utils.registerImageByClass("plate2",plate2,true);
	Utils.registerImageByClass("plate4",plate4,true);
	Utils.registerImageByClass("plate6",plate6,true);
	Utils.registerImageByClass("plate8",plate8,true);
	Utils.registerImageByClass("plate10",plate10,true);
	Utils.registerImageByClass("plate12",plate12,true);
	Utils.registerImageByClass("plate14",plate14,true);
	Utils.registerImageByClass("standard1_0",standard1_0,true);
	Utils.registerImageByClass("standard1_1",standard1_1,true);
	Utils.registerImageByClass("standard1_2",standard1_2,true);
	Utils.registerImageByClass("standard1_3",standard1_3,true);
	Utils.registerImageByClass("standard1_4",standard1_4,true);
	Utils.registerImageByClass("standard1_n",standard1_n,true);
	Utils.registerImageByClass("standard1_blank",standard1_blank,true);
	Utils.registerImageByClass("standard2_0",standard2_0,true);
	Utils.registerImageByClass("standard2_1",standard2_1,true);
	Utils.registerImageByClass("standard2_2",standard2_2,true);
	Utils.registerImageByClass("standard2_3",standard2_3,true);
	Utils.registerImageByClass("standard2_4",standard2_4,true);
	Utils.registerImageByClass("standard2_n",standard2_n,true);
	Utils.registerImageByClass("standard2_blank",standard2_blank,true);
	Utils.registerImageByClass("standard3_0",standard3_0,true);
	Utils.registerImageByClass("standard3_1",standard3_1,true);
	Utils.registerImageByClass("standard3_2",standard3_2,true);
	Utils.registerImageByClass("standard3_3",standard3_3,true);
	Utils.registerImageByClass("standard3_4",standard3_4,true);
	Utils.registerImageByClass("standard3_n",standard3_n,true);
	Utils.registerImageByClass("standard3_blank",standard3_blank,true);
	Utils.registerImageByClass("standard05_1_0",standard05_1_0,true);
	Utils.registerImageByClass("standard05_1_1",standard05_1_1,true);
	Utils.registerImageByClass("standard05_1_2",standard05_1_2,true);
	Utils.registerImageByClass("standard05_1_3",standard05_1_3,true);
	Utils.registerImageByClass("standard05_1_4",standard05_1_4,true);
	Utils.registerImageByClass("standard05_1_n",standard05_1_n,true);
	Utils.registerImageByClass("standard05_1_blank",standard05_1_blank,true);
	Utils.registerImageByClass("horizontal1_2_0",horizontal1_2_0,true);
	Utils.registerImageByClass("horizontal1_2_1",horizontal1_2_1,true);
	Utils.registerImageByClass("horizontal1_2_2",horizontal1_2_2,true);
	Utils.registerImageByClass("horizontal1_2_3",horizontal1_2_3,true);
	Utils.registerImageByClass("horizontal1_2_4",horizontal1_2_4,true);
	Utils.registerImageByClass("horizontal1_2_n",horizontal1_2_n,true);
	Utils.registerImageByClass("horizontal1_2_blank",horizontal1_2_blank,true);
	Utils.registerImageByClass("horizontal1_3_0",horizontal1_3_0,true);
	Utils.registerImageByClass("horizontal1_3_1",horizontal1_3_1,true);
	Utils.registerImageByClass("horizontal1_3_2",horizontal1_3_2,true);
	Utils.registerImageByClass("horizontal1_3_3",horizontal1_3_3,true);
	Utils.registerImageByClass("horizontal1_3_4",horizontal1_3_4,true);
	Utils.registerImageByClass("horizontal1_3_n",horizontal1_3_n,true);
	Utils.registerImageByClass("horizontal1_3_blank",horizontal1_3_blank,true);
	Utils.registerImageByClass("horizontal2_2_0",horizontal2_2_0,true);
	Utils.registerImageByClass("horizontal2_2_1",horizontal2_2_1,true);
	Utils.registerImageByClass("horizontal2_2_2",horizontal2_2_2,true);
	Utils.registerImageByClass("horizontal2_2_3",horizontal2_2_3,true);
	Utils.registerImageByClass("horizontal2_2_4",horizontal2_2_4,true);
	Utils.registerImageByClass("horizontal2_2_n",horizontal2_2_n,true);
	Utils.registerImageByClass("horizontal2_2_blank",horizontal2_2_blank,true);
	Utils.registerImageByClass("horizontal2_2_n",horizontal2_2_n,true);
	Utils.registerImageByClass("blank",horizontal2_2_blank,true);
	Utils.registerImageByClass("nobusiness",nobusiness,true);
}

private  function initNetworkToolbar(toolbar:mx.containers.Box, network:Network, interaction:String = null, showLabel:Boolean = false, perWidth:int = -1, height:int = -1):void{
	toolbar.setStyle("horizontalGap", 4);
	if(perWidth<0){
		perWidth = 28;
	}
	if(height<0){
		height = 20;
	}
	
	DemoUtils.createButtonBar(toolbar, [
		DemoUtils.createButtonInfo("放大", DemoImages.zoomIn, function():void{network.zoomIn(true);}),
		DemoUtils.createButtonInfo("缩小", DemoImages.zoomOut, function():void{network.zoomOut(true);}),
		DemoUtils.createButtonInfo("重置", DemoImages.zoomReset, function():void{network.zoomReset(true);}),
		DemoUtils.createButtonInfo("全局预览", DemoImages.zoomOverview, function():void{network.zoomOverview(true);})
	], false, showLabel, perWidth, height);
	
	DemoUtils.createButtonBar(toolbar, [
		DemoUtils.createButtonInfo("导出图片", DemoImages.export,  function():void{
			var fr:Object = new FileReference();	
			if(fr.hasOwnProperty("save")){
				var bitmapData:BitmapData = network.exportAsBitmapData(); 
				var encoder:PNGEncoder = new PNGEncoder();
				var data:ByteArray = encoder.encode(bitmapData);
				fr.save(data, 'network.png');
			}else{
				Alert.show("install Flash Player 10 to run this feature", "Not Supported"); 
			}	
		}),
			DemoUtils.createButtonInfo("扩展", toggle, function():void{
/*				var visible:Boolean=!devicetab.visible;
				devicetab.visible=visible;
				devicetab.includeInLayout=visible;*/
				parentObj.dispatchEvent(new Event("toggle"));
			})
				
			], false, showLabel, perWidth, height);
			}
			
			private function itemSelectHandler(e:ContextMenuEvent):void{
				var node:Follower = devicePic.selectionModel.selection.getItemAt(0);
				var packcode:String = node.getClient("packcode");
				belongCode=packcode;//记录当前机盘编码
				var alarm:AlarmModel=new AlarmModel();
				var alarm1:AlarmMangerModel=new AlarmMangerModel();
				if(packcode!=null){
					var packcodeArray:Array=packcode.split(",");
					var belongPackCode:String="";
					for(var i:int=0;i<packcodeArray.length;i++)
					{  
						if(i!=packcodeArray.length-1)
							belongPackCode+=packcodeArray[i]+"=";
						else
							belongPackCode+=packcodeArray[i];
					}
					tw =new TitleWindow();
					tw.layout="absolute";
					tw.x=0;tw.y=0;
//					tw.width=Capabilities.screenResolutionX-50;
//					tw.height=Capabilities.screenResolutionY-250;
					tw.width=1280;
					tw.height=660;
					tw.styleName="popwindow";
					tw.showCloseButton=true;
					
					var arr2:Array=new Array();
					if(packcode!=null){
						arr2=packcode.split(',');
					}
					
					if(arr2.length == 4){
						alarm.belongequip=arr2[0].toString();
						alarm.belongframe=arr2[1].toString();
						alarm.belongslot=arr2[2].toString();
						alarm.belongpack=arr2[3].toString();
						alarm1.belongequip=arr2[0].toString();
						alarm1.belongframe=arr2[1].toString();
						alarm1.belongslot=arr2[2].toString();
						alarm1.belongpack=arr2[3].toString();
						belongEquip = belongPackCode;
					}
				}
				
				if(e.currentTarget.caption == "处理操作"){
					//根据当前设备编号，查找演习科目管理里面其对应的演习科目编号
					//编号不为空，查询该科目的告警，有告警则弹出处理页面，否则提示设备无演习告警
					alarm1.iscleared="0";
					var rtobj:RemoteObject=new RemoteObject("faultSimulation");
					rtobj.endpoint= ModelLocator.END_POINT;
					rtobj.showBusyCursor=true;
					rtobj.addEventListener(ResultEvent.RESULT,getInterposeIdsByAlarmModelHandler);
					rtobj.getInterposeIdsByAlarmModel(alarm1);
					
				}
				
				if(e.currentTarget.caption == "机盘管理视图") {
					Registry.register("packcode",packcode);
					Application.application.openModel(e.currentTarget.caption,false);
				}
				else if(e.currentTarget.caption == "查看属性") {
					itemEquipPackInfo = new viewequipPackInfo(); //定义弹出对话框(属性页面)
					itemEquipPackInfo.packcode=packcode;
					itemEquipPackInfo.node=node;
					itemEquipPackInfo.equipCode = equipcode;
					
					MyPopupManager.addPopUp(itemEquipPackInfo, true);
					var ro:RemoteObject = new RemoteObject("devicePanel");
					ro.endpoint = ModelLocator.END_POINT;
					ro.showBusyCursor = true;
					ro.getPackInfo(packcode);
					ro.addEventListener(ResultEvent.RESULT,handlePackInfo);
					Application.application.faultEventHandler(ro);
				}
				else if(e.currentTarget.caption == "查看机盘业务"){					
					var carryOpera:CarryOpera=new CarryOpera();
					carryOpera.title="机盘承载业务";
					carryOpera.getOperaByCodeAndType(packcode,"equippack");
					MyPopupManager.addPopUp(carryOpera);
				} else if (e.currentTarget.caption == "新建演习科目") {
					var interpose:InterposeTitle = new InterposeTitle();
					interpose.title = "添加";
					interpose.isModify=false;
					interpose.isDevicePanel=true;
					interpose.paraValue = packcode;
					PopUpManager.addPopUp(interpose,Application.application as DisplayObject,true);
					PopUpManager.centerPopUp(interpose);
					interpose.addEventListener("RefreshDataGrid",RefreshDataGrid);
				}else if (e.currentTarget.caption == "新建故障") {
					
					var interposeFault:InterposeFaultTitle = new InterposeFaultTitle();
					interposeFault.title = "添加";
					interposeFault.isModify=false;
					interposeFault.isDevicePanel=true;
					interposeFault.paraValue = belongCode;
					interposeFault.user_id=parentApplication.curUser;
					interposeFault.txt_user_name =parentApplication.curUserName;
					PopUpManager.addPopUp(interposeFault,Application.application as DisplayObject,true);
					PopUpManager.centerPopUp(interposeFault);
					interposeFault.setTxtData();
					interposeFault.addEventListener("RefreshDataGrid",RefreshDataGrid);
					
				}
				else if(e.currentTarget.caption == "添加盘"){
					addEquipPackInfo = new viewequipPackInfo();
					MyPopupManager.addPopUp(addEquipPackInfo,true);
					addEquipPackInfo.initialize();
					addEquipPackInfo.title = "添加机盘";
					addEquipPackInfo.x_vendor = x_vendor;
					addEquipPackInfo.showEdit=true;
					addEquipPackInfo.x_model = x_model;
					addEquipPackInfo.equipCode = equipcode;
					addEquipPackInfo.equipName = equipname;
					addEquipPackInfo.node = node;
					addEquipPackInfo.equipname.text = equipname;
					addEquipPackInfo.addEventListener("addEquipPackInfo",function(event:Event):void{
						
					});
					var split:int=node.name.lastIndexOf("_");
					if(split>0){
						addEquipPackInfo.frameserial.text = node.name.substr(0,split);
						addEquipPackInfo.slotserial.text = node.name.substr(split+1,node.name.length-split-1);
					}else{
						addEquipPackInfo.frameserial.text = '1';
						addEquipPackInfo.slotserial.text=node.name;
					}
					addEquipPackInfo.packserial.styleName = "";
					addEquipPackInfo.packserial.editable = true;
					addEquipPackInfo.packserial.enabled = true;
					addEquipPackInfo.init();
				}
				else if(e.currentTarget.caption=="查看当前原始告警"){
					tw.title="告警查询";
					var currentOriginalAlarm:AlarmManager=new AlarmManager();
					currentOriginalAlarm.iscleared="0";
					currentOriginalAlarm.flag = 1;
					currentOriginalAlarm.belongpackobject=belongPackCode;//这个字段应该拆开
					tw.addEventListener(CloseEvent.CLOSE,twcolse);
					tw.addChild(currentOriginalAlarm);
					PopUpManager.addPopUp(tw,main(Application.application),true);
					PopUpManager.centerPopUp(tw);
					
				}
				else if(e.currentTarget.caption=="查看当前告警"){
					tw.title="当前告警";
					var historyRootAlarm:HisRootAlarm=new HisRootAlarm();
					historyRootAlarm.myflag=2;
					historyRootAlarm.belongpackobject=belongPackCode;
					tw.addEventListener(CloseEvent.CLOSE,twcolse);
					tw.addChild(historyRootAlarm);
					PopUpManager.addPopUp(tw,main(Application.application),true);
					PopUpManager.centerPopUp(tw);
				}else if (e.currentTarget.caption == "新建割接") {
					
					//判断当前盘下是否有端口，没有则提示不能进行割接
					
					var rtobj:RemoteObject=new RemoteObject("faultSimulation");
					rtobj.endpoint= ModelLocator.END_POINT;
					rtobj.showBusyCursor=true;
					rtobj.addEventListener(ResultEvent.RESULT,checkPackPortResultHandler);
					rtobj.checkPackPort(belongCode);
				}
					
				
//					else if(e.currentTarget.caption=="查看历史根告警"){
//					tw.title="历史根告警";
//					var historyRootAlarm:HisRootAlarm=new HisRootAlarm();
//					historyRootAlarm.myflag=3;
//					historyRootAlarm.belongpackobject=belongPackCode;
//					tw.addEventListener(CloseEvent.CLOSE,twcolse);
//					tw.addChild(historyRootAlarm);
//					PopUpManager.addPopUp(tw,main(Application.application),true);
//					PopUpManager.centerPopUp(tw);
//					
//					
//				}else if(e.currentTarget.caption=="查看历史原始告警"){
//					tw.title="告警查询";
//					var historyOriginalAlarm:AlarmManager=new AlarmManager();
//					historyOriginalAlarm.iscleared="1";
//					historyOriginalAlarm.flag = 1;
//					historyOriginalAlarm.belongpackobject=belongPackCode;
//					tw.addEventListener(CloseEvent.CLOSE,twcolse);
//					tw.addChild(historyOriginalAlarm);
//					PopUpManager.addPopUp(tw,main(Application.application),true);
//					PopUpManager.centerPopUp(tw);
//				}
//				else if(e.currentTarget.caption=="查看性能"){
//					var pt:ShowPerDatas = new ShowPerDatas();
//					pt.equippack = packcode;
//					PopUpManager.addPopUp(pt,this,true);
//					PopUpManager.centerPopUp(pt);
//				}
			}
			//机盘割接
			private function checkPackPortResultHandler(event:ResultEvent):void{
				if(event.result!=null&&event.result.toString()!='fail'){
					var interposeFault:InterposePackCutTitle = new InterposePackCutTitle();
					interposeFault.title = "添加";
					interposeFault.isModify=false;
					interposeFault.isDevicePanel=true;//机盘
					interposeFault.isCutFault=true;//当前进入为割接操作
					interposeFault.paraValue = belongCode;
					interposeFault.oldport = event.result.toString();
					interposeFault.user_id=parentApplication.curUser;
					interposeFault.txt_user_name =parentApplication.curUserName;
					PopUpManager.addPopUp(interposeFault,Application.application as DisplayObject,true);
					PopUpManager.centerPopUp(interposeFault);
					interposeFault.f_user_name.label="割接人员";
					interposeFault.f_faulttype.label="割接类型";
					interposeFault.setTxtData();
					interposeFault.addEventListener("RefreshDataGrid",RefreshDataGrid);
				}else{
					Alert.show("当前盘不支持割接操作","提示");
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
			
			private function item8SelectHandler(e:ContextMenuEvent):void{
				var node:Follower = devicePic.selectionModel.selection.getItemAt(0);
				var packcode:String = node.getClient("packcode");
				var winBusinessInfluenced:businessInfluenced = new businessInfluenced();
				winBusinessInfluenced.setParameters(packcode, "pack");
				this.parentApplication.openModel("\"N-1\"分析",true,winBusinessInfluenced);
			}
			
			private function getFrameserialHandler(event:ResultEvent):void{
				if(event.result)
					addEquipPackInfo.frameserial.text = event.result.toString();
			}
			
			private function doubleClickHandler(e:MouseEvent):void{
				if(devicePic.selectionModel.selection.count>0)
				{
					var node:Follower = devicePic.selectionModel.selection.getItemAt(0);
					if(node.image == "nobusiness"){
						Alert.show("该盘暂不能进入机盘管理视图！");
						return;
					}
					var packcode:String = node.getClient("packcode");
					var hasPort:String=node.getClient("hasPort") as String;
					var iscard:String=node.getClient("iscard") as String;
//					if(iscard!=null&&iscard=="yes"&&hasPort!=null&&hasPort==1){
					if(iscard!=null&&iscard=="yes"&&hasPort!=null){
						Registry.register("packcode",packcode);
						Application.application.openModel("机盘管理视图", false);
					}
				}
			}
			
			private function handlePackInfo(event:ResultEvent):void {
				var packInfo:PackInfoModel = event.result as PackInfoModel;
				itemEquipPackInfo.title = packInfo.slotserial + "-机盘属性";
				itemEquipPackInfo.equipname.text = packInfo.equipname;//设备名称
				itemEquipPackInfo.frameserial.text = packInfo.frameserial;//机框序号
				itemEquipPackInfo.slotserial.text = packInfo.slotserial;//机槽序号
				itemEquipPackInfo.packmodel.text = packInfo.packmodel;//机盘型号
				itemEquipPackInfo.packserial.text = packInfo.packserial;//机盘序号
				itemEquipPackInfo.updatedate.text = packInfo.updatedate;//更新时间.
				itemEquipPackInfo.remark.text = packInfo.remark;//备注
				itemEquipPackInfo.updateperson.text = packInfo.updateperson;//更新人
				itemEquipPackInfo.packsn.text=packInfo.packsn;//序列号
				itemEquipPackInfo.software_version.text=packInfo.software_version//软件版本
				itemEquipPackInfo.hardware_version.text=packInfo.hardware_version;//硬件版本
				itemEquipPackInfo.x_model = x_model;
				itemEquipPackInfo.packModel = packInfo.packmodel;
				itemEquipPackInfo.init();
			}
			
			private function initBox():void{
				timer.addEventListener(TimerEvent.TIMER, tick);
				devicePic.elementBox=box;
				devicePic.selectionModel.selectionMode= SelectionModel.SINGLE_SELECTION;
				box.setStyle(Styles.BACKGROUND_TYPE,Consts.BACKGROUND_TYPE_IMAGE);
				box.setStyle(Styles.BACKGROUND_IMAGE_STRETCH,Consts.STRETCH_FILL);
				box.setStyle(Styles.BACKGROUND_IMAGE,"mainbg");
				var nodebac:Node=new Node();
				nodebac.setLocation(1150,230);
				nodebac.width=1;
				nodebac.height=1;
				box.add(nodebac);
				drawPic(xml);//画面板图。可根据_vendor,x_model，slotdirc重新绘画
				
				var rtobj:RemoteObject=new RemoteObject("devicePanel");
				rtobj.endpoint=ModelLocator.END_POINT;
				rtobj.showBusyCursor=true;
				rtobj.getCard(equipcode,slotdirc);//画机盘
				rtobj.addEventListener(ResultEvent.RESULT, getCard);
				Application.application.faultEventHandler(rtobj);
/*				devicetab.equipname = equipname;
				devicetab.equipcode = equipcode;
				devicetab.ChangeEvent();
				devicetab.visible=false;*/
			}
			
			private function tick(event:TimerEvent = null):void {
				if(this.parent == null){
					return;
				}
				if(this.increase){
					this.fillAlpha += 0.2
					if(this.fillAlpha > 1){
						this.fillAlpha = 1;
						this.increase = false;
					} 
				}else{
					this.fillAlpha -= 0.2
					if(this.fillAlpha < 0){
						this.fillAlpha = 0.4;
						this.increase = true;
					} 					
				}
				(devicePic.elementBox.selectionModel.lastData as Element).setStyle(Styles.VECTOR_FILL_ALPHA, fillAlpha);
			}
			
			public function getCard(event:ResultEvent):void{
				var lstCard:ArrayCollection=(ArrayCollection)(event.result);
				var flag:Boolean = true;
				//Alert.show(box.datas.count.toString());
				for(var i:int=0;i<box.datas.count;i++){
					var element:Element=box.datas.getItemAt(i) as Element;
					var shapetype:String=element.getClient("ShapeType");
					if(shapetype=="机框"){
						
						element.setStyle(Styles.LABEL_BOLD,true);
						element.setStyle(Styles.LABEL_POSITION,Consts.POSITION_TOP_BOTTOM);
						element.setStyle(Styles.LABEL_YOFFSET,10);
						element.setStyle(Styles.LABEL_SIZE,20);
						if(flag)
						element.name=equipname;
						element.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_VECTOR);
						element.setStyle(Styles.VECTOR_GRADIENT, Consts.GRADIENT_LINEAR_SOUTH);	
						element.setStyle(Styles.VECTOR_FILL_COLOR,9286314);
						element.setStyle(Styles.VECTOR_GRADIENT_COLOR,6851990);
						element.setStyle(Styles.VECTOR_FILL_ALPHA,0.4);
						element.setStyle(Styles.VECTOR_GRADIENT_ALPHA,0.6);
						element.setStyle(Styles.VECTOR_DEEP, 0);
						flag = false;
						continue;
					}
					if(shapetype=="槽框"){
						element.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_VECTOR);
						element.setStyle(Styles.VECTOR_GRADIENT, Consts.GRADIENT_LINEAR_SOUTH);	
						element.setStyle(Styles.VECTOR_FILL_COLOR,6518133);
						element.setStyle(Styles.VECTOR_GRADIENT_COLOR,3820883);
						element.setStyle(Styles.VECTOR_FILL_ALPHA,0.8);
						element.setStyle(Styles.VECTOR_GRADIENT_ALPHA,0.8);
						element.setStyle(Styles.VECTOR_DEEP, 3);
						continue;
					}
					if(shapetype=="板卡"){
						var slot:twaver.Follower=element as Follower;
						var fram_name:String = '';
						
						slot.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
						slot.setStyle(Styles.SELECT_COLOR,"0x00FF00");
						slot.setStyle(Styles.SELECT_WIDTH,'10');
						
						//增加机框名称匹配      开始
						var host:Node = null;
						var grid:Grid = null;
						if(slot.host is Grid) {							
							grid = slot.host as Grid;
						}
						if(grid != null&&grid.getClient("ShapeType") == '槽框'){
							host = grid.host ; 
							if(host != null&&host.getClient("ShapeType") == '机框'&&host.getClient("frame_name") != null) {
								fram_name = host.getClient("frame_name");
							}
						}
						//增加机框名称匹配      结束
						var bool:Boolean=false;
						for each(var card:CardModel in lstCard){
							//Alert.show(card.cardcode+",,,"+card.cardname+",,,"+",,,"+card.packlogo+",,,"+card.portnum+",,,"+card.rate+",,,"+card.slotserial+",,,");
							//Alert.show("aaaaaaaaaaaaaaaaaaaaaa"+slot.name+",,,"+card.slotserial+",,,"+fram_name);
							if(slot.name==card.slotserial&&(fram_name =='' ||fram_name == card.frameserial)){//机框名称匹配
								if(card.packlogo == "0"){//判断是否为非业务盘  0代表非业务盘
									slot.image = "nobusiness";
									slot.setClient("iscard","no");
									slot.setClient("packcode",card.cardcode);
									slot.setStyle(Styles.IMAGE_STRETCH,Consts.STRETCH_FILL);
									bool=true;
									if(card.cardcode!="0"){
										//Alert.show("ccccccccccccccccccccc");

										var pack_model:String=card.cardname;
										slot.setClient("porttype",pack_model);
										if(pack_model.length>5){
											slot.name="<p align='center'>"+slot.name+"\n"+pack_model.substr(0,6)+"</p>";
										}else{
											slot.name="<p align='center'>"+slot.name+"\n"+pack_model+"</p>";
										}
										slot.setStyle(Styles.LABEL_HTML,true);
									}
									//Alert.show("packlogo_0"+card.packlogo);
									break;
								}
								slot.setClient("iscard","yes");
								if(card.cardcode!="0"){
									var pack_model:String=card.cardname;
									slot.setClient("porttype",pack_model);
									if(pack_model.length>5){
										slot.name="<p align='center'>"+slot.name+"\n"+pack_model.substr(0,6)+"</p>";
									}else{
										slot.name="<p align='center'>"+slot.name+"\n"+pack_model+"</p>";
									}
									slot.setStyle(Styles.LABEL_HTML,true);
									//Alert.show("packlogo_1"+card.packlogo);
								}
								if(card.portnum==0){
									slot.setClient("hasPort","0");
								}else{
									slot.setClient("hasPort","1");
								}
								var image:String="";
								if(card.portnum<=4 && card.portnum>=0){
									image=card.portnum.toString();
								}
								else if(card.portnum>4){
									image="n";
								}
								else{
									image="blank";
									slot.setClient("iscard","no");
								}
								if(card.cardname=="xINF_H" || card.cardname=="xINF"){
									image="pw";
								}
								if(card.cardname=="xFCUH" || card.cardname=="xFCU"||card.cardname=="FCU"||card.cardname=="FANM"){
									image="fan1";
								}
								slot.image=slot.getClient("card_image")+image;
								slot.setClient("packcode",card.cardcode);
								slot.setClient("rate",card.rate);
								
//								slot.toolTip=card.tooltip;
								bool=true;
								break;
							}
						}
						if(!bool){
							slot.setClient("iscard","no");
							slot.image=slot.getClient("card_image")+"blank";
							
						}
						continue;
					}
					if(shapetype=="附属"){
						continue;
					}
				}
				
				ModelLocator.registerAlarm();
				getAlarms();
				setLocation();
				devicePic.zoomOverview(true);
			}

			private function getTooltip(e:ResultEvent):void{
				var id_tooltip:String = "";
				var arrayresult:ArrayCollection = e.result as ArrayCollection;  
				for(var i:int = 0;i<arrayresult.length;i++){
					id_tooltip = arrayresult.getItemAt(i) as String;
					var id:String = id_tooltip.split("@@")[0];
					var toolTip:String = id_tooltip.split("@@")[1];
					devicePic.elementBox.getElementByID(id).toolTip = toolTip;
				}
			}
			
			
			//告警定位
			private function setLocation():void{
				
				var packcode:String=Registry.lookup("packcode");
				Registry.unregister("packcode");
				if(packcode!=null){
					devicePic.elementBox.forEach(function(element:Element){
						if(element.getClient("packcode")==packcode){
							devicePic.elementBox.selectionModel.setSelection(element);
							element.setStyle(Styles.SELECT_STYLE,Consts.SELECT_STYLE_BORDER);
							element.setStyle(Styles.SELECT_COLOR,"0x00FF00");
							element.setStyle(Styles.SELECT_WIDTH,10);
						}
					});
				}
			}
			
			public function drawPic(xml:String):void{	
				var serializer:XMLSerializer = new XMLSerializer(devicePic.elementBox);
				serializer.deserialize(xml);
				
				devicePic.selectionModel.filterFunction=function(data:Element):Boolean{
					if(data.getClient("ShapeType")=="板卡"){
						return true;
					}
					return false;
				}
			}
			
			
			private function dragDropFunction(e:DragEvent):void{
				var ds:DragSource = e.dragSource;
			}
			
			/*
			*告警
			*/
			
			private function getAlarms():void{
				var rtobj:RemoteObject = new RemoteObject("devicePanel");
				rtobj.endpoint = ModelLocator.END_POINT;
				rtobj.showBusyCursor = true;
				rtobj.addEventListener(ResultEvent.RESULT,getAlarmResult);
				Application.application.faultEventHandler(rtobj);
				rtobj.getEquipPackAlarm(equipcode);
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
					refreshAlarm(alarmarray[i].PACKCODE,alarmarray[i].ALARMLEVEL,alarmarray[i].ALARMCOUNT);
				}
			}
			
			private function refreshAlarm(packcode:String,alarmlevel:int,alarmcount:int):void{
				box.forEach(function(element:Element):void{
					if(element.getClient("packcode")==packcode){
						element.alarmState.setNewAlarmCount(AlarmSeverity.getByValue(alarmlevel),alarmcount);
					}
				}
				);
			}

