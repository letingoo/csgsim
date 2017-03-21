	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.collections.*;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	import sourceCode.autoGrid.view.ShowProperty;
	import sourceCode.channelRoute.views.circuitReq;
	import sourceCode.channelRoute.views.relatecircuit;
	import sourceCode.packGraph.views.OpticalPort;
	import sourceCode.packGraph.views.checkedEquipPack;
	
	import twaver.*;
	import twaver.network.Network;
	import twaver.network.interaction.InteractionEvent;

	private var pageIndex:int=0;
	private var pageSize:int=5;
	private var box:ElementBox = new ElementBox();
	public var c_circuitcode:String =null;
	public var logicport:String = "00000500000030205049";
	public var equippack:checkedEquipPack;
	public var opticalport:OpticalPort;
	public var flag:String = null;
	public var circuitcode:String = "";
	public var port_a:String = "";
	public var port_z:String = "";
	public var slot_a:String = "";
	public var slot_z:String = "";
	public var rate:String = "";
	
	private var serializable:ISerializable = null;
	[Embed(source="assets/images/device/equipment.png")]
	/**
	 *设备图标 
	 */
	public static const equipIcon:Class;
	public var equippack_follower:Follower;
	public var slot:String =null;
	[Bindable]
	public var elementBox:ElementBox;
	
	public function get dataBox():DataBox{
		return box;
	}
	public function init():void  
	{   
		
		Utils.registerImageByClass("equipIcon", equipIcon);
		SerializationSettings.registerGlobalClient("flag", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("isbranch", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("position", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("equipcode", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("portcode", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("topoid", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("cc", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("isbranch", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("portlabel", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("timeslot", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("timeslot373", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("systemcode", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("rate", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("slot", Consts.TYPE_STRING);
		var box:ElementBox = channelPic.elementBox;
		box.clear();
		var rtobj:RemoteObject = new RemoteObject("channelRoute");
		rtobj.endpoint = ModelLocator.END_POINT;
		rtobj.showBusyCursor = true;			
		rtobj.addEventListener(ResultEvent.RESULT,drawPic);
		rtobj.getChannelRoute2(port_a,slot_a,circuitcode);//从后台请求当前方式单的电路路由图
		channelPic.name=circuitcode;
		channelPic.contextMenu = new ContextMenu();
		channelPic.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, function(e:ContextMenuEvent):void{
			if(channelPic.selectionModel.count == 0)
			{//选中元素个数
				
				var itemcircuit:ContextMenuItem = new ContextMenuItem("关联业务");
				itemcircuit.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, relateCircuit);
				channelPic.contextMenu.hideBuiltInItems();
				channelPic.contextMenu.customItems = [itemcircuit];
				//定制右键菜单
				var flexVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLEX_SDK_VERSION, false, false);
				var playerVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLASH_PLAYER_VERSION, false, false);
				channelPic.contextMenu.customItems = [itemcircuit,flexVersion, playerVersion];
			}
			else
			{
				if (((Element)(channelPic.selectionModel.selection.getItemAt(0)) is Node)&&(channelPic.selectionModel.selection.getItemAt(0).getClient("flag")=='equipment')) 
				{//选中节  
					var item:ContextMenuItem = new ContextMenuItem("显示设备属性");
					item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (e:ContextMenuEvent){
						itemSelectHandler(e,channelPic);
					});
					channelPic.contextMenu.hideBuiltInItems();
					channelPic.contextMenu.customItems = [item];
				}
				else if (((Element)(channelPic.selectionModel.selection.getItemAt(0)) is Link)&&(channelPic.selectionModel.selection.getItemAt(0).getClient("flag")=='topolink'))
				{ //选中线 
					var topolinkItem:ContextMenuItem = new ContextMenuItem("显示复用段属性");
					topolinkItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (e:ContextMenuEvent){
						itemSelectHandler_Ocable(e,channelPic);
					});
					
					channelPic.contextMenu.hideBuiltInItems();
					channelPic.contextMenu.customItems = [topolinkItem];
					
				}
				else if(((Element)(channelPic.selectionModel.selection.getItemAt(0)) is Follower)&&(channelPic.selectionModel.selection.getItemAt(0).getClient("flag")=='port'))
				{
					var portItem:ContextMenuItem = new ContextMenuItem("显示端口属性");
					portItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (e:ContextMenuEvent){itemSelectHandler_port(e,channelPic)});
					var startPortItem:ContextMenuItem = new ContextMenuItem("指定起始端");
					startPortItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,function(event:ContextMenuEvent):void{confirmStartOrEndPort('start')});
					var endPortItem:ContextMenuItem = new ContextMenuItem("指定终止端");
					endPortItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,function(event:ContextMenuEvent):void{confirmStartOrEndPort('end')});
					channelPic.contextMenu.hideBuiltInItems();
					channelPic.contextMenu.customItems = [portItem,startPortItem,endPortItem]; 
				}
			}
			
		});	
		
		channelPic.addInteractionListener(function(e:InteractionEvent):void{
			if(e.kind=='doubleClickElement')
			{
				
				var selectElement:IElement = e.element;
				if(selectElement is Node)
				{
					var node:Node = selectElement as Node;
					if(node.getClient("flag")!=null&&node.getClient("flag")=="equipment")
					{
						channelShowProperty(node);
					}
					
				}
				if(selectElement is Follower)
				{
					var follow:Follower = selectElement as Follower;
					if(follow.getClient("flag")!=null&&follow.getClient("flag")=="port")
					{
						channelShowProperty(follow);	
					}
				}
				if(selectElement is Link)
				{
					var link:Link = selectElement as Link;
					if(link.getClient("flag")!=null&&link.getClient("flag")=='topolink')
					{
						channelShowProperty(link);
						
					}
					
				}
				
			}
		})
		
	}
	
	/**
	 *查看端口属性 
	 * @param evt
	 * @param network
	 * 
	 */
	private function itemSelectHandler_port(evt:ContextMenuEvent,network:Network):void
	{
		var follow:Follower = network.selectionModel.selection.getItemAt(0) as Follower;
		channelShowProperty(follow);	
	}
	
	/**
	 *查看复用段属性 
	 * @param e
	 * @param network
	 * 
	 */
	private function itemSelectHandler_Ocable(e:ContextMenuEvent,network:Network):void{
		var link:Link = network.selectionModel.selection.getItemAt(0);
		channelShowProperty(link);
	}
	
	/**
	 *查看设备属性 
	 * @param e
	 * @param network
	 * 
	 */
	private function itemSelectHandler(e:ContextMenuEvent,network:Network):void{
		var node:Node = network.selectionModel.selection.getItemAt(0);
		channelShowProperty(node);		
	}
	/**
	 *查看network中网元的属性 
	 * @param ielement
	 * 
	 */
	private function channelShowProperty(ielement:IElement):void
	{
		var property:ShowProperty = new ShowProperty();
		property.isVisible = false;
		if((ielement is Node)&&ielement.getClient("flag")=='equipment')
		{
			var node:Node = ielement as Node;
			var equipcode:String = node.getClient("equipcode");
			var equipname:String = node.children.getItemAt(0).name;
			property.paraValue = equipcode;
			property.tablename = "EQUIPMENT_VIEW";
			property.key = "EQUIPCODE";
			property.title = equipname+"—设备属性";
		}
		else if((ielement is Follower)&&ielement.getClient("flag")=='port')
		{
			var follower:Follower = ielement as Follower;
			var portcode:String=follower.getClient("portcode");
			if(portcode!=null)
			{
				portcode = portcode.split(",")[0];
			}
			var portname:String = follower.host.children.getItemAt(0).name+"-"+follower.toolTip;
			property.paraValue = portcode;
			property.tablename = "VIEW_EQUIPLOGICPORT_PROPERTY";
			property.key = "LOGICPORT";
			property.title = portname+"—端口属性";
		}
		else if(ielement is Link)
		{
			var link:Link = ielement as Link;
			var topolinkid:Object = link.getClient('topoid');
			var labelname:String="";
			labelname = link.fromNode.name+'至'+link.toNode.name;
			property.paraValue = topolinkid.toString();
			property.tablename = "VIEW_ENTOPOLINKPROPERTY";
			property.key = "label";
			property.title = labelname+"—复用段属性";
		
		}
		PopUpManager.addPopUp(property, this, true);
		PopUpManager.centerPopUp(property);		
	}

	/**
	 *手动关联方式单
	 *  
	 * @param e
	 * 
	 */
	private function relateCircuit(e:ContextMenuEvent):void{
		var relate:relatecircuit = new relatecircuit();
		relate.port_a = port_a;
		relate.port_z = port_z;
		relate.slot_a = slot_a;
		relate.slot_z = slot_z;
		relate.c_circuitcode = circuitcode;
		MyPopupManager.addPopUp(relate, true);
	}
	
	/**
	 *将从后台获取的电路路由图生成到前台 
	 * @param e
	 * 
	 */
private function drawPic(e:ResultEvent):void
{
	if(e.result!=null&&e.result.toString()!="")
	{
		channelPic.elementBox.clear();
		var serializer:XMLSerializer = new XMLSerializer(channelPic.elementBox);
		serializer.deserialize(e.result.toString());
		channelPic.movableFunction = function(e:IElement):Boolean
		{
			if(e is twaver.Grid)
			{
				return false;
			}
			else
			{
				return true;
			}
		};
		channelPic.elementBox.getElementByID("label").setStyle(Styles.LABEL_POSITION,Consts.POSITION_RIGHT_RIGHT);

		channelPic.labelFunction= function(element:IElement):String{			
			var label:String = element.getStyle(Styles.NETWORK_LABEL);
			if(element is Group)
			{
				var group:Group = element as Group;
				if(group.expanded)
				{
					return "";
				}
			}
			if(label != null)
			{
				return label;
			}
			return element.name;
		};
	}
	else
	{
		Alert.show("电路路由图不存在，电路未开通！","提示");
	}
}
	/**
	 *设置起始（终止）端口 
	 * @param flag
	 * 
	 */
	private function confirmStartOrEndPort(flag:String):void
	{
		if(c_circuitcode!=null&&c_circuitcode!="")
		{
			var follow:Follower = channelPic.selectionModel.selection.getItemAt(0) as Follower;
			if(follow!=null)
			{
				var T:Boolean = true;
				var collection:ICollection = follow.links;
				var count:int = collection.count;
				for(var i:int=0;i<count;i++)
				{
					var idata:IData = collection.getItemAt(i);
					var ccOrtopo:String = idata.getClient("flag");
					if(ccOrtopo!=null&&ccOrtopo=='topolink')
					{
						T = false;
						break;
					}
				}
				if(T)
				{
					var alertString:String = "您确认要指定该端口为起始端口吗？";
					if(flag=="end")
					{
						alertString = "您确认要指定该端口为终止端口吗？";
					}
					Alert.show(alertString,
						"提示",
						Alert.YES|Alert.NO,
						null,
						function(e:CloseEvent):void{confirm(e,flag);}
					);
				}
				else
				{
					Alert.show("不能指定线路口为起始或者终止端口！","提示");
				}
			}
		}
		else
		{
			Alert.show("请先关联方式再指定端口！","提示");
		}
	}
	private function confirm(e:CloseEvent,flag:String):void
	{
		if(e.detail==Alert.YES)
		{
			var follow:Follower = channelPic.selectionModel.selection.getItemAt(0) as Follower;
			var portcode:String = follow.getClient("portcode");
			if(portcode!=null)
			{
				portcode = portcode.split(",")[0];
			}
			var slot:String = follow.getClient("slot");
			var rt:RemoteObject = new RemoteObject("channelTree");
			rt.endpoint = ModelLocator.END_POINT;
			rt.showBusyCursor = true;
			rt.confirmStartOrEndPort(portcode,slot,c_circuitcode,flag);
			rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void
			{
				Alert.show("操作成功！","提示");
				follow.image = "twaverImages/channelroute/luyou_port2.png";
			});
		}
	}
