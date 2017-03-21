import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.actionscript.Registry;

import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.ui.ContextMenuItem;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.ToolTip;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import sourceCode.autoGrid.view.ShowProperty;
import sourceCode.ocableroute.model.OcableRouteData;
import sourceCode.ocableroute.views.OcableRoute;
import sourceCode.systemManagement.model.PermissionControlModel;
import sourceCode.wireConfiguration.actionscript.DDFPanel;
import sourceCode.wireConfiguration.model.OdfOdmSubModel;
import sourceCode.wireConfiguration.views.DDFPortRelation;
import sourceCode.wireConfiguration.views.DeleteOdfOdmSub;
import sourceCode.wireConfiguration.views.OdfOdmSubLabel;
import sourceCode.wireConfiguration.views.OdfPortWireconfig;
import sourceCode.wireConfiguration.views.RelationWireConfig;
import sourceCode.wireConfiguration.views.SingleAddOdfOdmSub;

import twaver.*;
import twaver.DemoUtils;
import twaver.ElementBox;
import twaver.Follower;
import twaver.Node;
import twaver.Utils;
import twaver.XMLSerializer;

public var moduleName:String;
private var _dmcode:String;
private var _dmtype:String;

[Embed(source="assets/images/wireConfiguration/DDF-PORT.png")]
public static const DDF_PORT:Class;			
[Embed(source="assets/images/wireConfiguration/odf_port.png")]
public static const odfport:Class;
[Embed(source="assets/images/wireConfiguration/odf_a.png")]
public static const odf_a:Class; 
[Embed(source="assets/images/wireConfiguration/odf_b.png")]
public static const odf_b:Class; 
[Embed(source="assets/images/wireConfiguration/odf_c.png")]
public static const odf_c:Class;
[Embed(source="assets/images/wireConfiguration/odf_d.png")]
public static const odf_d:Class;
[Embed(source="assets/images/wireConfiguration/odf_e.png")]
public static const odf_e:Class;
[Embed(source="assets/images/wireConfiguration/odf_f.png")]
public static const odf_f:Class;			
[Embed(source="assets/images/wireConfiguration/odf_0.png")]
public static const odf_0:Class;
[Embed(source="assets/images/wireConfiguration/odf_1.png")]
public static const odf_1:Class;
[Embed(source="assets/images/wireConfiguration/odf_2.png")]
public static const odf_2:Class;
[Embed(source="assets/images/wireConfiguration/odf_3.png")]
public static const odf_3:Class;
[Embed(source="assets/images/wireConfiguration/odf_4.png")]
public static const odf_4:Class;
[Embed(source="assets/images/wireConfiguration/odf_5.png")]
public static const odf_5:Class;
[Embed(source="assets/images/wireConfiguration/odf_6.png")]
public static const odf_6:Class;
[Embed(source="assets/images/wireConfiguration/odf_7.png")]
public static const odf_7:Class;
[Embed(source="assets/images/wireConfiguration/odf_8.png")]
public static const odf_8:Class;
[Embed(source="assets/images/wireConfiguration/odf_9.png")]
public static const odf_9:Class;
[Embed(source="assets/images/wireConfiguration/odf_10.png")]
public static const odf_10:Class;
[Embed(source="assets/images/wireConfiguration/odf_11.png")]
public static const odf_11:Class;
[Embed(source="assets/images/wireConfiguration/odf_12.png")]
public static const odf_12:Class;
[Embed(source="assets/images/wireConfiguration/ODF-PORT.png")]
public static const odf_port:Class;			
[Embed(source="assets/images/wireConfiguration/ODF-PORT-GREEN.png")]
public static const odf_green:Class;
[Embed(source="assets/images/wireConfiguration/ODF-PORT-YELLOW.png")]
public static const odf_yellow:Class;
[Embed(source="assets/images/wireConfiguration/ODF-PORT-RED.png")]
public static const odf_red:Class;			
[Embed(source="assets/images/wireConfiguration/DDF-PORT-1-YELLOW.png")]
public static const ddf_yellow:Class;
[Embed(source="assets/images/wireConfiguration/DDF-PORT-1-RED.png")]
public static const ddf_red:Class;
[Embed(source="assets/images/wireConfiguration/DDF-PORT-1-GREEN.png")]
public static const ddf_green:Class;			

SerializationSettings.registerGlobalClient("porttype","String");
SerializationSettings.registerGlobalClient("dmcode","String");
SerializationSettings.registerGlobalClient("name_std","String");
SerializationSettings.registerGlobalClient("portcode","String");
SerializationSettings.registerGlobalClient("state","String");
SerializationSettings.registerGlobalClient("serial","String");
SerializationSettings.registerGlobalClient("label","String");

public function get dmtype():String
{
	return _dmtype;
}

public function set dmtype(value:String):void
{
	_dmtype = value;
}

public function get dmcode():String
{
	return _dmcode;
}

public function set dmcode(value:String):void
{
	_dmcode = value;
}

private var isDeleteODF:Boolean = false;
private var isDeleteDDF:Boolean = false;

private function preinitialize():void{
	if(ModelLocator.permissionList!=null&&ModelLocator.permissionList.length>0){
		isDeleteODF = false;
		isDeleteODF = false;
		for(var i:int=0;i<ModelLocator.permissionList.length;i++){
			var model:PermissionControlModel = ModelLocator.permissionList[i];
			if(model.oper_name!=null&&model.oper_name=="删除ODF模块"){
				isDeleteODF = true;
			}
			if(model.oper_name!=null&&model.oper_name=="删除DDF模块"){
				isDeleteDDF = true;
			}
		}
	}
}

public function initApp():void  
{   
	
	Utils.registerImageByClass("DDF_PORT",DDF_PORT);
	Utils.registerImageByClass("odfport",odfport);
	Utils.registerImageByClass("odf_a",odf_a); 
	Utils.registerImageByClass("odf_b",odf_b);
	Utils.registerImageByClass("odf_c",odf_c);
	Utils.registerImageByClass("odf_d",odf_d);
	Utils.registerImageByClass("odf_e",odf_e);
	Utils.registerImageByClass("odf_0",odf_0);
	Utils.registerImageByClass("odf_f",odf_f);
	Utils.registerImageByClass("odf_1",odf_1);
	Utils.registerImageByClass("odf_2",odf_2);
	Utils.registerImageByClass("odf_3",odf_3);
	Utils.registerImageByClass("odf_4",odf_4);
	Utils.registerImageByClass("odf_5",odf_5);
	Utils.registerImageByClass("odf_6",odf_6);
	Utils.registerImageByClass("odf_7",odf_7);
	Utils.registerImageByClass("odf_8",odf_8);
	Utils.registerImageByClass("odf_9",odf_9);
	Utils.registerImageByClass("odf_10",odf_10);
	Utils.registerImageByClass("odf_11",odf_11);
	Utils.registerImageByClass("odf_12",odf_12);
	Utils.registerImageByClass("odf_green",odf_green);
	Utils.registerImageByClass("odf_yellow",odf_yellow);
	Utils.registerImageByClass("odf_red",odf_red);
	Utils.registerImageByClass("ddf_green",ddf_green);
	Utils.registerImageByClass("ddf_yellow",ddf_yellow);
	
	DemoUtils.initNetworkToolbar(childtoolbar, network);
	network.contextMenu = new ContextMenu();
	network.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,MenuSelectHandler);
	drawNetworkByDmcode();
}
public function drawNetworkByDmcode():void
{
	var rtobj1:RemoteObject = new RemoteObject("wireConfiguration");
	rtobj1.endpoint = ModelLocator.END_POINT;				
	rtobj1.getDMByCode(this._dmcode,this._dmtype);
	rtobj1.addEventListener(ResultEvent.RESULT, drawPic); 
}

public function MenuSelectHandler(e:ContextMenuEvent):void{
	var p:Point = new Point(e.mouseTarget.mouseX / network.zoom, e.mouseTarget.mouseY / network.zoom);
	var datas:ICollection = network.getElementsByLocalPoint(p);
	if (datas.count > 0) {
		network.selectionModel.setSelection(datas.getItemAt(0));
	}
	else
	{
		network.selectionModel.clearSelection();
	}
	
	var flexVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLEX_SDK_VERSION, false, false);
	var playerVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLASH_PLAYER_VERSION, false, false);
	if(network.selectionModel.count > 0)
	{
		var element:Element=network.selectionModel.selection.getItemAt(0);
		
		if(element is Follower&&element.getClient("porttype")!=null&&element.getClient("porttype")=="ODFODM"){
			var item:ContextMenuItem = new ContextMenuItem("查看ODF模块属性");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, showOdfOdmProperty);
			var item1:ContextMenuItem = new ContextMenuItem("删除ODF模块");
			item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, deleteOdfOdm);
			network.contextMenu.hideBuiltInItems();
			network.contextMenu.customItems = [item,item1];
		}else if(element is Follower && element.getClient("porttype") != null && element.getClient("porttype")=="DDFDDM"){
			var item:ContextMenuItem = new ContextMenuItem("查看DDF模块属性");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, showDdfDdmProperty);
			var item1:ContextMenuItem = new ContextMenuItem("删除DDF模块",true);
			item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, deleteDdfDdm);
			item1.visible = isDeleteDDF;
			network.contextMenu.hideBuiltInItems();
			network.contextMenu.customItems = [item,item1];         	
		}else if(element is Follower && element.getClient("porttype") != null && (
			element.getClient("porttype")=="ZY23010499" || element.getClient("porttype")=="ZY13010499")){
			var item:ContextMenuItem = new ContextMenuItem("配线关系",true);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, ItemSelect_Handler);
			var item1:ContextMenuItem = new ContextMenuItem("",true);
			var itemddfcircuit:ContextMenuItem = new ContextMenuItem("查看端到端连接关系",false);
			if(element.getClient("porttype") == "ZY23010499"){
				item1.caption = "查看ODF端口属性";
				item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, showPortProperty);
				var item2:ContextMenuItem = new ContextMenuItem("光路路由","提示");
				item2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,showOcableRouteHandler);
				network.contextMenu.hideBuiltInItems();
				network.contextMenu.customItems = [item,item1,item2];         
			}else if(element.getClient("porttype") == "ZY13010499"){
				item1.caption = "查看DDF端口属性";
				item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, showPortProperty);
				itemddfcircuit.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,showDDFCircuitHandler);
				network.contextMenu.hideBuiltInItems();
				network.contextMenu.customItems = [item,itemddfcircuit,item1];         
			}
			
		}else if(element is Follower && element.getClient("porttype") == "label"){
			var itemLabel:ContextMenuItem = new ContextMenuItem("修改标签");
			itemLabel.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,modifyLabelHandler);
			var itemDelete:ContextMenuItem = new ContextMenuItem("删除子模块",true);
			itemDelete.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,deleteOdfSUbHandler);
			network.contextMenu.hideBuiltInItems();
			network.contextMenu.customItems = [itemLabel,itemDelete];   
		} else if(element is Follower && element.getClient("porttype") == "ODFODMSUB"){
			var item:ContextMenuItem = new ContextMenuItem("查看ODF模块属性");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, showOdfOdmProperty);
			var item1:ContextMenuItem = new ContextMenuItem("删除ODF模块");
			item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, deleteOdfOdm);
			if(element.getClient("state") == "false"){
				var itemLabel:ContextMenuItem = new ContextMenuItem("修改标签",true);
				itemLabel.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,modifyLabelHandler);
				var itemDelete:ContextMenuItem = new ContextMenuItem("删除子模块");
				itemDelete.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,deleteOdfSUbHandler);
				network.contextMenu.hideBuiltInItems();
				network.contextMenu.customItems = [item,item1,itemLabel,itemDelete];   
			}else{
				var item2:ContextMenuItem = new ContextMenuItem("添加子模块",true);
				item2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,addOdfOdmSubHandler);
				var item3:ContextMenuItem = new ContextMenuItem("批量添加子模块");
				item3.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,addOdfPortHandler);
				network.contextMenu.hideBuiltInItems();
				network.contextMenu.customItems = [item,item1,item2,item3];         
			}
		}
		else
		{
			network.contextMenu.customItems = [flexVersion, playerVersion];
		}
	}
	else
	{
		network.contextMenu.customItems = [flexVersion, playerVersion];
	}
}

//查看ODF口光路路由
private function showOcableRouteHandler(event:ContextMenuEvent):void{
	var port:Follower=network.selectionModel.selection.getItemAt(0) ;
	var portcode:String = port.getClient("portcode");
	if(portcode == null || portcode == ""){
		Alert.show("请先选中ODF端口","提示");
		return;
	}
	var ro:RemoteObject = new RemoteObject("ocableRoute");
	ro.endpoint= ModelLocator.END_POINT;
	ro.showBusyCursor = true;
	ro.getOcableRouteByOdfPort(portcode);
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

//删除子模块
private function deleteOdfSUbHandler(event:ContextMenuEvent):void{
	var follower:Follower=network.selectionModel.selection.getItemAt(0);
	tempID = follower.parent.id.toString();
	var form:DeleteOdfOdmSub = new DeleteOdfOdmSub();
	var ro:RemoteObject = new RemoteObject("wireConfiguration");
	ro.endpoint = ModelLocator.END_POINT;
	ro.showBusyCursor = true;
	ro.getOdfOdmSubExistsPort(follower.getClient("dmcode"),follower.getClient("serial"));
	ro.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
		var data:ArrayCollection = event.result as ArrayCollection;
		form.odfodmcode = follower.getClient("dmcode");
		form.startserial = follower.getClient("serial");
		MyPopupManager.addPopUp(form,true);
		form.listSubOdfOdm = new ArrayCollection();
		for(var i:int = 0; i < data.length;i++){
			var sub:OdfOdmSubModel = data.getItemAt(i) as OdfOdmSubModel;
			form.cmbEnd.dataProvider.addItem({label:sub.label});
			form.cmbStart.dataProvider.addItem({label:sub.label});
			if(follower.getClient("label") == sub.label)
				form.cmbStart.selectedIndex = i;
			form.listSubOdfOdm.addItem(sub);
		}
		form.cmbEnd.selectedIndex =0;
	});
	
	form.addEventListener("saveCompleteHandler",function(event:Event):void{
		network.elementBox.removeByID(tempID);
		Alert.show("删除成功","提示");
		var ro:RemoteObject = new RemoteObject("wireConfiguration");
		ro.endpoint = ModelLocator.END_POINT;
		ro.showBusyCursor = true;
		ro.getDMByCode(_dmcode,"ODF");
		ro.addEventListener(ResultEvent.RESULT,drawPic);
	});
}

private function modifyLabelHandler(event:ContextMenuEvent):void{
	var follower:Follower=network.selectionModel.selection.getItemAt(0);
	tempID = follower.parent.id.toString();
	var labelForm:OdfOdmSubLabel = new OdfOdmSubLabel();
	var ro:RemoteObject = new RemoteObject("wireConfiguration");
	ro.endpoint = ModelLocator.END_POINT;
	ro.showBusyCursor = true;
	ro.getOdfOdmSubExistsPort(follower.getClient("dmcode"),follower.getClient("serial"));
	ro.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
		var data:ArrayCollection = event.result as ArrayCollection;
		labelForm.odfodmcode = follower.getClient("dmcode");
		labelForm.startserial = follower.getClient("serial");
		MyPopupManager.addPopUp(labelForm,true);
		labelForm.txtoldlabel.text = follower.getClient("label");
		labelForm.txtnewlabel.text = follower.getClient("label");
		labelForm.listSubOdfOdm = new ArrayCollection();
		for(var i:int = 0; i < data.length;i++){
			var sub:OdfOdmSubModel = data.getItemAt(i) as OdfOdmSubModel;
			labelForm.cmbEnd.dataProvider.addItem({label:sub.label});
			labelForm.cmbStart.dataProvider.addItem({label:sub.label});
			if(follower.getClient("label") == sub.label)
				labelForm.cmbStart.selectedIndex = i;
			labelForm.listSubOdfOdm.addItem(sub);
		}
		labelForm.cmbEnd.selectedIndex =data.length-1;
	});
		
	labelForm.addEventListener("saveCompleteHandler",function(event:Event):void{
		network.elementBox.removeByID(tempID);
		Alert.show("修改成功","提示");
		var ro:RemoteObject = new RemoteObject("wireConfiguration");
		ro.endpoint = ModelLocator.END_POINT;
		ro.showBusyCursor = true;
		ro.getDMByCode(_dmcode,"ODF");
		ro.addEventListener(ResultEvent.RESULT,drawPic);
	});
}
//批量添加ODF子模块
private function addOdfPortHandler(event:ContextMenuEvent):void{
	var follower:Follower=network.selectionModel.selection.getItemAt(0);
	tempID = follower.parent.id.toString();
	
	var ro:RemoteObject = new RemoteObject("wireConfiguration");
	ro.endpoint = ModelLocator.END_POINT;
	ro.showBusyCursor = true;
	ro.getOdfOdmSubSerials(follower.getClient("dmcode"),follower.getClient("serial"));
	ro.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
		var data:ArrayCollection = event.result as ArrayCollection;
		var form:OdfPortWireconfig = new OdfPortWireconfig();
		form.startSerial = follower.getClient("serial");
		form.odfodmcode = follower.getClient("dmcode");
		MyPopupManager.addPopUp(form,true);
		form.cmbStartA.enabled =false;
		form.cmbStartA.text = follower.getClient("serial");
		form.listSubOdfOdm = new ArrayCollection();
		for(var i:int = 0; i < data.length;i++){
			var sub:OdfOdmSubModel = data.getItemAt(i) as OdfOdmSubModel;
			form.cmbStartZ.dataProvider.addItem({label:sub.serial});
			form.listSubOdfOdm.addItem(sub);
		}
		form.cmbStartZ.selectedIndex = 0;
		form.addEventListener("savePropertyComplete",refreshOdfPortHandler);
	});
}

//单个添加子模块
private function addOdfOdmSubHandler(event:ContextMenuEvent):void{
	var follower:Follower=network.selectionModel.selection.getItemAt(0);
	tempID = follower.parent.id.toString();
	var form:SingleAddOdfOdmSub  = new SingleAddOdfOdmSub();
	form.startSerial = follower.getClient("serial");
	form.odfodmcode = follower.getClient("dmcode");
	MyPopupManager.addPopUp(form,true);
	form.addEventListener("savePropertyComplete",refreshOdfPortHandler);
}
var tempID:String;

private function refreshOdfPortHandler(event:Event):void{
	this.network.elementBox.removeByID(tempID);
	Alert.show("添加成功","提示");
	var ro:RemoteObject = new RemoteObject("wireConfiguration");
	ro.endpoint = ModelLocator.END_POINT;
	ro.showBusyCursor = true;
	ro.getDMByCode(_dmcode,"ODF");
	ro.addEventListener(ResultEvent.RESULT,drawPic);
}
/**
 * 查看端口属性
 */
private function showPortProperty(event:ContextMenuEvent):void{
	
	if(network.selectionModel.selection.count > 0){
		if((Element)(network.selectionModel.selection.getItemAt(0)) is Follower)
		{
			var port:Follower=network.selectionModel.selection.getItemAt(0) ;
			if(port.getClient("porttype")=="ZY23010499")//odf端口
			{
				var property:ShowProperty = new ShowProperty();
				property.title = port.getClient("name_std");
				property.paraValue =port.getClient("portcode");
				property.tablename = "VIEW_EN_ODFPORT";
				property.key = "ODFPORTCODE";
				PopUpManager.addPopUp(property, this, true);
				PopUpManager.centerPopUp(property);		
				property.addEventListener("savePropertyComplete",function (event:Event){
					PopUpManager.removePopUp(property);
				});
			}
			else if(port.getClient("porttype")=="ZY13010499")//ddf端口
			{
				
				var property:ShowProperty = new ShowProperty();
				property.title = port.getClient("name_std");
				property.paraValue =port.getClient("portcode");
				property.tablename = "VIEW_EN_DDFPORT";
				property.key = "DDFPORTCODE";
				property.objectValues.circuit = port.getClient("circuit");
				PopUpManager.addPopUp(property, this, true);
				PopUpManager.centerPopUp(property);		
				property.addEventListener("savePropertyComplete",function (event:Event){
					PopUpManager.removePopUp(property);
				});
			} 
		}
	}
	
}


/**
 * 查看ODF模块属性
 */
private function showOdfOdmProperty(event:ContextMenuEvent):void{
	var follower:Follower = network.selectionModel.selection.getItemAt(0);	
	var property:ShowProperty = new ShowProperty();
	property.title = follower.getClient("name_std");
	property.paraValue =follower.getClient("dmcode");
	property.tablename = "VIEW_EN_ODFODM";
	property.key = "ODFODMCODE";
	PopUpManager.addPopUp(property, this, true);
	PopUpManager.centerPopUp(property);		
	property.addEventListener("savePropertyComplete",function (event:Event){
		PopUpManager.removePopUp(property);
	}); 
}

/**
 * 删除ODF模块确认
 */ 
private function deleteOdfOdm(event:ContextMenuEvent):void{
	Alert.show("您确认要删除吗？","请您确认！",Alert.YES|Alert.NO,this,delOdfOdmHandler,null,Alert.NO);
}

/**
 * 删除ODF模块
 */
private function delOdfOdmHandler(event:CloseEvent):void {
	if(event.detail == Alert.YES){
		var element:IElement = network.elementBox.selectionModel.selection.getItemAt(0);
		if(element is Follower){
			var follow:Follower = element as Follower;
//			if(follow is Follower&&follow.getClient("porttype")!=null&&follow.getClient("porttype")=="ODFODM"){
				var ro:RemoteObject = new RemoteObject("roomMgr");
				ro.endpoint = ModelLocator.END_POINT;
				ro.showBusyCursor = true;
				ro.deleteOdfOdm(follow.getClient("dmcode"));
				ro.addEventListener(ResultEvent.RESULT,deletedHandler);
//			}
		}
	}
}

private function deletedHandler(event:Event):void{
	Alert.show("删除成功","提示");
	this.dispatchEvent(new Event("deleteModelComplete"));
}

/**
 * 查看DDF模块属性 
 */ 
private function showDdfDdmProperty(event:ContextMenuEvent):void{
	var follower:Follower = network.selectionModel.selection.getItemAt(0);	
	var property:ShowProperty = new ShowProperty();
	property.title = follower.getClient("name_std");
	property.paraValue =follower.getClient("dmcode");
	property.tablename = "VIEW_EN_DDFDDM";
	property.key = "DDFDDMCODE";
	PopUpManager.addPopUp(property, this, true);
	PopUpManager.centerPopUp(property);		
	property.addEventListener("savePropertyComplete",function (event:Event){
		PopUpManager.removePopUp(property);
	}); 
}

/**
 * 删除DDF模块确认
 */ 
private function deleteDdfDdm(event:ContextMenuEvent):void{
	Alert.show("您确认要删除吗？","请您确认！",Alert.YES|Alert.NO,this,delDdfDdmHandler,null,Alert.NO);
}

/**
 * 删除DDF模块
 */ 
private function delDdfDdmHandler(event:CloseEvent):void{
	if(event.detail == Alert.YES){
		var element:IElement = network.elementBox.selectionModel.selection.getItemAt(0);
		if(element is Follower){
			var follow:Follower = element as Follower;
			if(follow is Follower&&follow.getClient("porttype")!=null&&follow.getClient("porttype")=="DDFDDM"){
				var ro:RemoteObject = new RemoteObject("roomMgr");
				ro.endpoint = ModelLocator.END_POINT;
				ro.showBusyCursor = true;
				ro.deleteDdfDdm(follow.getClient("dmcode"));
				ro.addEventListener(ResultEvent.RESULT,deletedHandler);
			}
		}
	}
}

public function ItemSelect_Handler(event:ContextMenuEvent):void{
	var port:Follower = network.selectionModel.selection.getItemAt(0);	
	Registry.register("portcode",port.getClient("portcode"));	
	Registry.register("porttype",port.getClient("porttype"));
	Registry.register("dmcode",port.getClient("dmcode"));
	var rewc:RelationWireConfig =  new RelationWireConfig();	
	rewc.moduleName = this.moduleName ;
	parentApplication.openModel("配线关系",true,rewc);
}

public function drawPic(event:ResultEvent):void{			
	var serializer:XMLSerializer = new XMLSerializer(network.elementBox);
	serializer.deserialize(event.result.toString());
} 

protected function network_doubleClickHandler(event:MouseEvent):void
{
	if(network.selectionModel.selection.count > 0){
		if((Element)(network.selectionModel.selection.getItemAt(0)) is Follower)
		{
			var port:Follower=network.selectionModel.selection.getItemAt(0) ;
			if(port.getClient("porttype")=="ZY23010499")//odf端口
			{
				var property:ShowProperty = new ShowProperty();
				property.title = port.getClient("name_std");
				property.paraValue =port.getClient("portcode");
				property.tablename = "VIEW_EN_ODFPORT";
				property.key = "ODFPORTCODE";
				PopUpManager.addPopUp(property, this, true);
				PopUpManager.centerPopUp(property);		
				property.addEventListener("savePropertyComplete",function (event:Event){
					PopUpManager.removePopUp(property);
				});
			}
			else if(port.getClient("porttype")=="ZY13010499")//ddf端口
			{
				var property:ShowProperty = new ShowProperty();
				property.title = port.getClient("name_std");
				property.paraValue =port.getClient("portcode");
				property.tablename = "VIEW_EN_DDFPORT";
				property.key = "DDFPORTCODE";
				PopUpManager.addPopUp(property, this, true);
				PopUpManager.centerPopUp(property);		
				property.addEventListener("savePropertyComplete",function (event:Event):void{
					PopUpManager.removePopUp(property);
				});
			} 
		}
	}
}

//查看DDF端到端效果
private function showDDFCircuitHandler(event:ContextMenuEvent):void{
	var port:Follower = network.selectionModel.selection.getItemAt(0);	
	var ro:RemoteObject = new RemoteObject("wireConfiguration");
	ro.endpoint= ModelLocator.END_POINT;
	ro.showBusyCursor = true;
	ro.getDdfPortRelation(port.getClient("dmcode"),port.getClient("portcode"));
	ro.addEventListener(ResultEvent.RESULT,showRelationHandler);
	
}

//呈现连接关系
private function showRelationHandler(event:ResultEvent):void{
	var result:String = event.result as String;
	if(result =="没有关联设备"){
		Alert.show("该DDF端口没有关联设备","提示");
		return;
	}else if(result == "没有交叉"){
		Alert.show("设备端口没有交叉","提示");
		return;
	}else if(result == "没有电路"){
		Alert.show("设备端口没有串接电路","提示");
		return;
	}else if(result=="该DDF端口没有配线"){
		Alert.show("该DDF端口没有配线","提示");
		return;
	}
	var ddfcircuit:DDFPortRelation = new DDFPortRelation();
	ddfcircuit.xml = event.result as String;
	parentApplication.openModel("查看端到端连接关系",false,ddfcircuit);
}
