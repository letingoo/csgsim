
import common.actionscript.ModelLocator;
import common.actionscript.Registry;

import flash.events.ContextMenuEvent;
import flash.geom.Point;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import mx.controls.Alert;
import mx.core.Application;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import sourceCode.autoGrid.view.ShowProperty;

import twaver.DemoUtils;
import twaver.Element;
import twaver.ElementBox;
import twaver.Follower;
import twaver.ICollection;
import twaver.Layer;
import twaver.LayerBox;
import twaver.Node;
import twaver.XMLSerializer;


private var layer1:Layer = new Layer("equipment");     		//画模块或设备或光缆段的图层
private var layer2:Layer = new Layer("port");		

private var elementBox:ElementBox;
private var layerBox:LayerBox;

private var dmcode:String; //DDF模块编号
private var ddfport:String //DDF端口编号

[Bindable]
public var xml:String;

//初始化界面
public function initApp():void  { 
	DemoUtils.initNetworkToolbar(toolbar, network);
	network.setPanInteractionHandlers();
	network.contextMenu = new ContextMenu();
	network.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,contextMenuEvent);
	network.contextMenu.hideBuiltInItems();
	
	if(xml != ""){
		network.elementBox.clear();
		var serializer:XMLSerializer = new XMLSerializer(network.elementBox);
		serializer.deserialize(xml);
	}
}

private function contextMenuEvent(event:ContextMenuEvent):void{
	var p:Point = new Point(event.mouseTarget.mouseX / network.zoom, event.mouseTarget.mouseY / network.zoom);
	var datas:ICollection = network.getElementsByLocalPoint(p);
	if (datas.count > 0)
		network.selectionModel.setSelection(datas.getItemAt(0));
	else
		network.selectionModel.clearSelection();
	if(network.selectionModel.count > 0){
		var element:Element=network.selectionModel.selection.getItemAt(0);
		if(element is Node && element.layerID.toString() == "equipment"){  
			var flag:String = element.id.toString();
			if(flag.split("-")[0] =="CIRCUIT"){ //选择方式
				var item1:ContextMenuItem = new ContextMenuItem("方式信息");
				item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,itemSelectEventHandler);
				network.contextMenu.customItems = [item1];
			}else if(flag.split("-")[0] == "EQUIPMENT"){	//选择设备
				var item1:ContextMenuItem = new ContextMenuItem("查看设备属性");
				item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,showEquipmentPropertyEventHandler);
				network.contextMenu.customItems = [item1];
			}else if(flag.split("-")[0] == "DDFDDM"){	//选择DDF模块
				var item1:ContextMenuItem = new ContextMenuItem("查看DDF模块属性");
				item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,showDdfDdmEventHandler);
				network.contextMenu.customItems = [item1];
			} 
			else{
				network.contextMenu.customItems = [];
			}
		}else if(element is Follower && element.layerID.toString()=="port"){
			var flag:String = element.id.toString();
			if(flag.split("-")[0] =="DDFPORT"){ //选择DDF端口
				var item1:ContextMenuItem = new ContextMenuItem("查看DDF端口属性");
				item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,showDdfPortEventHandler);
				network.contextMenu.customItems = [item1];
			}else if(flag.split("-")[0] =="EQUIPPORT"){ //选择设备端口
				var item1:ContextMenuItem = new ContextMenuItem("查看设备端口属性");
				item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,showEequipPortEventHandler);
				network.contextMenu.customItems = [item1];
			}else{
				network.contextMenu.customItems = [];
			}
		}else{
			network.contextMenu.customItems = [];
		}
	}
}

//查看方式信息
private function itemSelectEventHandler(event:ContextMenuEvent):void{
	var element:Element=network.selectionModel.selection.getItemAt(0);
	var circuitcode:String = element.getClient("code");
	if(circuitcode != ""){
		Registry.register("para_circuitcode", circuitcode);
		Application.application.openModel("方式信息", false);
	}else{
		Alert.show("电路编号为空","提示");
	}
}

//查看设备属性
private function showEquipmentPropertyEventHandler(event:ContextMenuEvent):void{
	var element:Element=network.selectionModel.selection.getItemAt(0);
	var equipcode:String = element.getClient("code");
	var equipname:String = element.name;
	var property:ShowProperty = new ShowProperty();
	property.paraValue = equipcode;
	property.tablename = "VIEW_EQUIPMENT";
	property.key = "EQUIPCODE";
	property.title = equipname+"—设备属性";
	PopUpManager.addPopUp(property, this, true);
	PopUpManager.centerPopUp(property);
}

//查看DDF模块属性
private function showDdfDdmEventHandler(event:ContextMenuEvent):void{
	var element:Element=network.selectionModel.selection.getItemAt(0);
	var property:ShowProperty = new ShowProperty();
	property.title = element.name;
	property.paraValue =element.getClient("code");
	property.tablename = "VIEW_EN_DDFDDM";
	property.key = "DDFDDMCODE";
	PopUpManager.addPopUp(property, this, true);
	PopUpManager.centerPopUp(property);		
}

//显示DDF端口属性
private function showDdfPortEventHandler(event:ContextMenuEvent):void{
	var element:Element=network.selectionModel.selection.getItemAt(0);
	var property:ShowProperty = new ShowProperty();
	property.title = element.toolTip;
	property.paraValue =element.getClient("code");
	property.tablename = "VIEW_EN_DDFPORT";
	property.key = "DDFPORTCODE";
	PopUpManager.addPopUp(property, this, true);
	PopUpManager.centerPopUp(property);		
}

//显示设备端口属性
private function showEequipPortEventHandler(event:ContextMenuEvent):void{
	var element:Element=network.selectionModel.selection.getItemAt(0);
	var property:ShowProperty = new ShowProperty();
	property.paraValue = element.getClient("code");
	property.tablename = "VIEW_EQUIPLOGICPORT_PROPERTY";
	property.key = "LOGICPORT";
	property.title = element.parent.name+"-"+element.toolTip+"—端口属性";
	PopUpManager.addPopUp(property, this, true);
	PopUpManager.centerPopUp(property);
}

//双击打开方式信息
protected function network_doubleClickHandler(event:MouseEvent):void
{
	var flexVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLEX_SDK_VERSION, false, false);
	var playerVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLASH_PLAYER_VERSION, false, false);
	
	if(network.selectionModel.count == 0){//选中元素个数
		network.contextMenu.customItems = [flexVersion, playerVersion];
	}
	else{
		var element:Element=network.selectionModel.selection.getItemAt(0);
		if(element is Node && element.layerID.toString() == "equipment"){  
			var flag:String = element.id.toString();
			if(flag.split("-")[0] =="CIRCUIT"){ 
				var circuitcode:String = element.getClient("code");
				if(circuitcode != ""){
					Registry.register("para_circuitcode", circuitcode);
					Application.application.openModel("方式信息", false);
				}else{
					Alert.show("电路编号为空","提示");
				}
			}
		}
	}
}
