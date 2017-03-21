    import com.adobe.serialization.json.JSON;
    
    import common.actionscript.ModelLocator;
    import common.actionscript.MyPopupManager;
    import common.actionscript.Registry;
    import common.component.myAlert.AlertTip;
    import common.other.events.EventNames;
    
    import flash.events.ContextMenuEvent;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.external.ExternalInterface;
    import flash.geom.Point;
    import flash.system.Capabilities;
    import flash.ui.*;
    import flash.utils.Timer;
    
    import mx.collections.*;
    import mx.containers.TitleWindow;
    import mx.controls.Alert;
    import mx.controls.Tree;
    import mx.core.Application;
    import mx.events.CloseEvent;
    import mx.events.IndexChangedEvent;
    import mx.events.ListEvent;
    import mx.managers.PopUpManager;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.remoting.mxml.RemoteObject;
    
    import sourceCode.autoGrid.view.ShowProperty;
    import sourceCode.channelRoute.views.portTree;
    import sourceCode.rootalarm.views.RootAlarmMgr;
    import sourceCode.systemManagement.model.PermissionControlModel;
    
    import twaver.*;
    import twaver.network.Network;
    import twaver.network.interaction.InteractionEvent;

	private var box:ElementBox = new ElementBox();
	private var serializable:ISerializable = null;
	/**
	 *加入重点电路监控功能。 
	 */
    private var itemAdd:ContextMenuItem; 
	/**
	 *取消重点电路监控功能 
	 */
	private var itemDel:ContextMenuItem;
	/**
	 *是否可以进行添加操作 
	 */
	private var isAdd:Boolean = false;
	/**
	 *是否可以进行删除操作 
	 */
	private var isDel:Boolean = false;
	/**
	 * 是否定位过当前电路的告警
	 */
    private var flagFix:Boolean=false;
    private var tw:TitleWindow;
	 /**
	  *为了过滤电路弄的参数 
	  */    
    [Bindable]
	 /**
	  *查询条件：电路编号 
	  */
     public var circuitcode1:String="";
	 /**
	  *查询条件：申请单号 
	  */
     public var requisitionid1:String="";
	 /**
	  *查询条件：业务名称 
	  */
     public var username1:String="";
	 /**
	  *查询条件：业务类型 
	  */
     public var operationtype1:String="";
	 /**
	  *查询条件：速率 
	  */
     public var rate1:String="";
	 /**
	  *查询条件：电路状态 
	  */
     public var state1:String="";


	/**
	 * 
	 */
    public var network_config:Network;
	
	[Embed(source="assets/images/device/equipment.png")]
	public static const equipIcon:Class;
	
	
	[Bindable]
	public var elementBox:ElementBox;
	/**
	 *当前选中的方式单编号 
	 */
	[Bindable]
	public var NodeLabel:String ;
	private var timer:Timer=new Timer(200);
	private var fillAlpha:Number=0.8;
	private var increase:Boolean=true;

	public function get dataBox():DataBox{
		return box;
	}
	
	[Bindable]   
	/**
	 *方式单树的数据源 
	 */
	public var folderCollection:XMLListCollection;
	/**
	 *网元位置是否发生了变化 
	 */
    private var ismove:Boolean = false;
	/**
	 *记录电路路由图模式一种选中的上一个元素 
	 */
	private var preElement:Element;

    public var portA:String;
    public var portZ:String;
	
	/**
	 *是否可进行保存操作 
	 */
	public var isSave:Boolean = false;
	
	/**
	 *初始化预处理函数 
	 * 
	 */
	private function preinitialize():void
	{
		if(ModelLocator.permissionList!=null&&ModelLocator.permissionList.length>0)
		{
			for(var i:int=0;i<ModelLocator.permissionList.length;i++)
			{
				var model:PermissionControlModel = ModelLocator.permissionList[i];
				if(model.oper_name!=null&&model.oper_name=="保存操作")
				{
					isSave = true;
				}
			}
		}
	}
	/**
	 * 创建完成后的处理函数
	 * 
	 */
	public function init():void
	{
		this.addEventListener(EventNames.CATALOGROW,gettree);//为左侧业务树添加事件
		channelbox.label='路由图';//刷新 
		toolbar.removeAllChildren();
		channelPic.elementBox.clear();
		DemoUtilsForChannel.initNetworkToolbarForChannel(toolbar, channelPic,this,height,width,"默认模式");//初始化电路路由图模式1的菜单
		var width:int=this.width;
		var height:int=this.height;
		channelPic.addSelectionChangeListener(function (e:SelectionChangeEvent):void{
			if(preElement!=null)
			{
				preElement.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT);
			}
			
			if(channelPic.selectionModel.lastData!=null)
			{
				preElement=channelPic.selectionModel.lastData as Element;				
			}
		});
			
		Utils.registerImageByClass("portalarm1",ModelLocator.portalarm1);	
		Utils.registerImageByClass("portalarm2",ModelLocator.portalarm2);	
		Utils.registerImageByClass("equipIcon", equipIcon);
		SerializationSettings.registerGlobalClient("flag", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("isbranch", Consts.TYPE_STRING);//是否是支路口
		SerializationSettings.registerGlobalClient("position", Consts.TYPE_STRING);//端口位置
		SerializationSettings.registerGlobalClient("equipcode", Consts.TYPE_STRING);//设备编号
		SerializationSettings.registerGlobalClient("portcode", Consts.TYPE_STRING);//端口编号
		SerializationSettings.registerGlobalClient("topoid", Consts.TYPE_STRING);//复用段编号
		SerializationSettings.registerGlobalClient("cc", Consts.TYPE_STRING);//cc
		SerializationSettings.registerGlobalClient("portlabel", Consts.TYPE_STRING);//端口的名称
		SerializationSettings.registerGlobalClient("timeslot", Consts.TYPE_STRING);//时隙
		SerializationSettings.registerGlobalClient("timeslot373", Consts.TYPE_STRING);//373格式时隙
		SerializationSettings.registerGlobalClient("systemcode", Consts.TYPE_STRING);//系统编号
		SerializationSettings.registerGlobalClient("rate", Consts.TYPE_STRING);//速率
		SerializationSettings.registerGlobalClient("slot", Consts.TYPE_STRING);//时隙
		channeltreeremote.TreeRouteActionForAsynch(circuitcode1,requisitionid1,username1,operationtype1,rate1,state1,"root","");//加载树
	
		 
		itemAdd=new ContextMenuItem("加入重点电路监控");
		itemAdd.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,addHandler);
		itemDel=new ContextMenuItem("取消重点电路监控");
		itemDel.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,delHandler);
		channeltree.contextMenu = new ContextMenu();
		channeltree.contextMenu.hideBuiltInItems();
		channeltree.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,menuSelectHandler);
		
		channelPic.keyboardRemoveEnabled=false;//设置network的键盘键del删除不可用
		channelPic.contextMenu = new ContextMenu();
		channelPic.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, function(e:ContextMenuEvent):void{
			//右键选中网元
			var p:Point = new Point(e.mouseTarget.mouseX / channelPic.zoom, e.mouseTarget.mouseY / channelPic.zoom);
			var datas:ICollection = channelPic.getElementsByLocalPoint(p);
			
			if (datas.count > 0)
			{
				channelPic.selectionModel.setSelection(datas.getItemAt(0));
			}
			else
			{
				channelPic.selectionModel.clearSelection();
			}
			//定制右键菜单
			var flexVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLEX_SDK_VERSION, false, false);
			var playerVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLASH_PLAYER_VERSION, false, false);
			
			if(channelPic.selectionModel.count == 0)
			{//选中元素个数
				channelPic.contextMenu.customItems = [flexVersion, playerVersion];
			}
			else
			{
				//初始清空右键选项
				channelPic.contextMenu.hideBuiltInItems();
				channelPic.contextMenu.customItems = [];
				if (((Element)(channelPic.selectionModel.selection.getItemAt(0)) is Node)&&(channelPic.selectionModel.selection.getItemAt(0).getClient("flag")=='equipment')) 
			      {//选中节  
					var item:ContextMenuItem = new ContextMenuItem("查看设备属性");
					item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (e:ContextMenuEvent):void{
						itemSelectHandler(e,channelPic);
					});
					channelPic.contextMenu.hideBuiltInItems();
					channelPic.contextMenu.customItems = [item];
				}
				else if (((Element)(channelPic.selectionModel.selection.getItemAt(0)) is Link)&&(channelPic.selectionModel.selection.getItemAt(0).getClient("flag")=='topolink'))
				{ //选中线 
					var item4:ContextMenuItem = new ContextMenuItem("查看复用段属性");
					item4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (e:ContextMenuEvent):void{
						itemSelectHandler_Ocable(e,channelPic);
					});
					
					channelPic.contextMenu.hideBuiltInItems();
					channelPic.contextMenu.customItems = [item4];
					
				}
				else if(((Element)(channelPic.selectionModel.selection.getItemAt(0)) is Follower)&&(channelPic.selectionModel.selection.getItemAt(0).getClient("flag")=='port'))
				{
					var portItem:ContextMenuItem = new ContextMenuItem("查看端口属性");
					portItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (e:ContextMenuEvent):void{
						itemSelectHandler_port(e,channelPic);
					});
					
					var alarmItem:ContextMenuItem = new ContextMenuItem("查看告警详情");
					alarmItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e:ContextMenuEvent):void{
						getRootAlarmDetail(e,channelPic);
					});
					
					var startPortItem:ContextMenuItem = new ContextMenuItem("指定起始端");
					startPortItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,function(event:ContextMenuEvent):void{
						confirmStartOrEndPort('start');
					});
					var endPortItem:ContextMenuItem = new ContextMenuItem("指定终止端");
					endPortItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,function(event:ContextMenuEvent):void{
						confirmStartOrEndPort('end');
					});
					channelPic.contextMenu.hideBuiltInItems();
					if(channelPic.selectionModel.selection.getItemAt(0).getClient("alarm")=='alarm')
					{
						channelPic.contextMenu.customItems = [portItem,startPortItem,endPortItem,alarmItem]; 
					}
					else
					{
						channelPic.contextMenu.customItems = [portItem,startPortItem,endPortItem]; 
					}	
				}
			}
		});	
		
		var msg:String = "网元位置变化了,请及时保存!";
		channelPic.addInteractionListener(function(e:InteractionEvent):void{
			if(isSave)
			{
				if(e.kind=='liveMoveEnd')
				{
					ismove = true;
					AlertTip.show(height-28,width,msg, 
						2000,false,{style:"AlertTip"});
				}
			}
			
			if(e.kind=='doubleClickElement')
			{
			
				var selectElement:IElement = e.element;
				if(selectElement is Node)
				{
					var node:Node = selectElement as Node;
					if(node.getClient("flag")!=null&&node.getClient("flag")=="equipment"){
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
					if(link.getClient("flag")!=null&&link.getClient("flag")=='topolink'){
						channelShowProperty(link);
						
					}
				
				}
			
			}
		});
	}

	/**
	 *查看告警详情 
	 * @param e
	 * @param network
	 * 
	 */
	private function getRootAlarmDetail(e:ContextMenuEvent,network:Network):void
	{
		
		var portcode:String=network.selectionModel.selection.getItemAt(0).getClient("portcode");
		
		if(portcode!=null && portcode!="")
		{
			portcode = portcode.split(",")[0];
		}
		else
		{
			portcode="";
		}
		
		tw =new TitleWindow();
		tw.layout="absolute";
		tw.x=0;
		tw.y=0;
		tw.horizontalScrollPolicy="off";
		tw.verticalScrollPolicy="off" ;
		tw.styleName="popwindow";
		tw.showCloseButton=true;
		tw.title="告警信息";
		
		tw.width=Capabilities.screenResolutionX-50;
		tw.height=Capabilities.screenResolutionY-250;
		
		var ram:RootAlarmMgr=new RootAlarmMgr();
		ram.flag=1;
		ram.belongportcode=portcode;
		ram.currentGrid="currentrootalarm";
		
		tw.addEventListener(CloseEvent.CLOSE,function(event:CloseEvent):void{PopUpManager.removePopUp(tw);});
		tw.addChild(ram);
		PopUpManager.addPopUp(tw,main(Application.application),false);
		PopUpManager.centerPopUp(tw);
	}

	/**
	 *方式单树菜单选择处理函数 
	 * @param event
	 * 
	 */
	private function menuSelectHandler(event:ContextMenuEvent):void
	{  
		var item:Object = channeltree.selectedItem;
		if(item!=null&&item.@leaf=='true')
		{
			if(item.@ismonitored=='1')
			{
				channeltree.contextMenu.customItems=[itemDel];
			}
			else
			{
				channeltree.contextMenu.customItems=[itemAdd];
			}
		}
	}

	private function tick(event:TimerEvent = null):void 
	{
		if(this.parent == null)
		{
			return;
		}
		if(this.increase)
		{
			this.fillAlpha += 0.2
			if(this.fillAlpha > 1)
			{
				this.fillAlpha = 1;
				this.increase = false;
			} 
		}
		else
		{
			this.fillAlpha -= 0.2
			if(this.fillAlpha < 0)
			{
				this.fillAlpha = 0.4;
				this.increase = true;
			} 					
		}
		preElement.setStyle(Styles.VECTOR_FILL_ALPHA, fillAlpha);
	}
	/**
	 *右键菜单查看端口属性 
	 * @param evt
	 * @param network
	 * 
	 */
	private function itemSelectHandler_port(evt:ContextMenuEvent,network:Network):void{
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
	 *右键菜单处理函数 
	 * @param e
	 * @param network
	 * 
	 */
	private function itemSelectHandler(e:ContextMenuEvent,network:Network):void{
		var node:Node = network.selectionModel.selection.getItemAt(0);
		channelShowProperty(node);		
	}
	/**
	 *显示选中元素的属性 
	 * @param ielement
	 * 
	 */
    private function channelShowProperty(ielement:IElement):void
	{
		var property:ShowProperty = new ShowProperty();
		property.isVisible = false;
		if((ielement is Node)&&ielement.getClient("flag")=='equipment')//设备
		{
			var node:Node = ielement as Node;
			var equipcode:String = node.getClient("equipcode");
			var equipname:String = node.children.getItemAt(0).name;
			
			property.paraValue = equipcode;
			property.tablename = "EQUIPMENT_VIEW";
			property.key = "EQUIPCODE";
			property.title = equipname+"—设备属性";
		}
		else if((ielement is Follower)&&ielement.getClient("flag")=='port')//端口
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
		else if(ielement is Link)//复用段
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
	 *从后台请求方式单树的返回结果处理函数 
	 * @param event
	 * 
	 */
	private function resultHandler(event:ResultEvent):void 
	{
		var para_circuitype:String=Registry.lookup("para_circuitype");
		var folderList:XMLList= new XMLList(event.result.toString());
		folderCollection=new XMLListCollection(folderList); 
		channeltree.dataProvider = folderCollection;
		if(para_circuitype!=null&&para_circuitype!="")
		{
			channeltree.callLater(function():void
			{
				var xmllist :XMLListCollection= channeltree.dataProvider as XMLListCollection;
				//遍历树结点，选中业务类型
				for each (var elementList:XML in xmllist)
				{
					if(elementList.@label==para_circuitype )
					{
						selectedNode = elementList;
						channeltree.selectedItem=elementList;
						var ptTreeRO:RemoteObject = new RemoteObject("channelTree");
						ptTreeRO.endpoint = ModelLocator.END_POINT;
						ptTreeRO.showBusyCursor =true;
						ptTreeRO.TreeRouteActionForAsynch(circuitcode1,requisitionid1,username1,operationtype1,rate1,state1,"leaf",para_circuitype);
						ptTreeRO.addEventListener(ResultEvent.RESULT,getNextTreeNode);
						ptTreeRO.addEventListener(FaultEvent.FAULT,DealFault);
						break;
					}
				}		
			});
		}
		Registry.unregister("para_circuitype");
	}
	/**
	 * 从后台获取业务树失败处理函数
	 * @param event
	 * 
	 */
	public function DealFault(event:FaultEvent):void
	{
		Alert.show(event.fault.toString());
	}
	/**
	 *业务树结点图标定义函数 
	 * @param item
	 * @return 
	 * 
	 */
	private function deviceiconFun(item:Object):*
	{
		if(item.@leaf==true)
		{
			return equipIcon;
		}
		else
		{
			return DemoImages.file;
		}
	}


	/**
	 *生成电路路由图 
	 * @param e
	 * 
	 */
	private function getChannelPic(e:Event):void
	{	
		channeltab.selectedIndex=0;
		network_config = channelPic;
		var node:XML = channeltree.selectedItem as XML;
		if(node!=null&&node.@leaf=='true')//选中为方式单
		{
			var box:ElementBox = channelPic.elementBox;
			box.clear();
			var circuitcode:String = node.@label;//方式单编号
			NodeLabel=circuitcode;
			var rtobj:RemoteObject = new RemoteObject("channelRoute");
			rtobj.endpoint = ModelLocator.END_POINT;
			rtobj.showBusyCursor = true;			
			rtobj.addEventListener(ResultEvent.RESULT,drawPic);
			rtobj.getChannelRoute(circuitcode);//从后台请求当前方式单的电路路由图
			channelPic.name=circuitcode;
			channelbox.label = circuitcode;
			
			flagFix=false;
		}
		
	}
	/**
	 *将从后台返回的电路路由图呈现到前端 
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
			if(channeltree.selectedItem.@label !=null && channeltree.selectedItem.@label!="")
			{
//				fixAlarmPort();	//获取告警端口
			}
			else
			{}		
		
			var rt:RemoteObject = new RemoteObject("channelTree");
			Application.application.faultEventHandler(rt);
			rt.endpoint = ModelLocator.END_POINT;
			rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void
			{
				if(event.result!=null&&event.result.toString()!="")
				{
					var json:Object = JSON.decode(event.result.toString())
				  	if(json!=null)
					{
					  portShow.selected = json.portShow!="true"?false:true;
					  portHide.selected = json.portHide!="true"?false:true;
					  slotserial.selected = json.slotserial!="true"?false:true;
					  portserial.selected = json.portserial!="true"?false:true;
					  topoLinkShow.selected = json.topoLinkShow!="true"?false:true;
					  topoLinkHide.selected = json.topoLinkHide!="true"?false:true;
					  systemcode.selected = json.systemcode!="true"?false:true;
					  timeslot.selected = json.timeslot!="true"?false:true;
					  timeslot373.selected = json.timeslot373!="true"?false:true;
					  timeslotno373.selected = json.timeslotno373!="true"?false:true;
					  if(portHide.selected)
					  {
						  configSlot.visible=false;
					  }
					  else
					  {
						  configSlot.visible=true;
					  }
					  if(topoLinkShow.selected)
					  {
						  configTopoLink.visible=true;
						  configTimeSlot.visible=true;
					  }
					  else
					  {
						  configTopoLink.visible=false;
						  configTimeSlot.visible=false;
					  }
					  if(timeslot.selected&&topoLinkShow.selected) 
					  {
						  configTimeSlot.visible=true;
					  } 
					  else 
					  {
						  configTimeSlot.visible=false;
					  }
				  }
				
				}
			
			});
			rt.getChannelConfig();
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
 *获取当前电路中有告警的端口 
 * 
 */
private function fixAlarmPort():void
{
	var circuitcode:String=channeltree.selectedItem.@label;
	var rtobj:RemoteObject = new RemoteObject("channelRoute");
	rtobj.endpoint = ModelLocator.END_POINT;
	rtobj.showBusyCursor = true;
	rtobj.addEventListener(ResultEvent.RESULT,setFixAlarm);
	rtobj.getFixAlarmPort(circuitcode);//获取当前电路中有告警的端口
	
}

/**
 *定位电路端口告警 
 * @param event
 * 
 */
private function setFixAlarm(event:ResultEvent):void{
	
	var params:ArrayCollection=event.result as ArrayCollection;
	if(params.length>0)
	{
		if(flagFix==false)
		{
			
			var count1:int = channelPic.elementBox.datas.count;
			for(var i:int;i<count1;i++)
			{
				var ele:IElement=channelPic.elementBox.datas.getItemAt(i);
				if(ele is Follower)
				{
					var str:String=ele.getClient("portcode");
					if(str !=null && str !="")
					{
						var port:String=str.split(",")[0];
						for each(var a:Object in params)
						{
							if(port==a.PORTCODE)
							{
								if(Follower(ele).image.toString()=="node1" || Follower(ele).image.toString()=="node1alarm")
								{
								}
								else
								{
									
									if(ele.getClient("isbranch"))
									{
										Follower(ele).image="portalarm2";
									}
									else
									{
										Follower(ele).image="portalarm1";
									}
								}
								Follower(ele).setClient("alarm","alarm");
							}
							
						}
						
					}
				}
			}
		}
	}
}

	var num:int=0;
	/**
	 *tab页签切换页面
	 *  
	 * @param evt
	 * 
	 */
	private function changeItems(evt: IndexChangedEvent):void
	{
		var flag : String = channeltab.getTabAt(channeltab.selectedIndex).label;
		if(flag.indexOf("方式单")!=-1)
		{
			if(channeltree.selectedItem!=null)
			{
//				tmis_request.source="http://188.154.202.34:8088/tmis/showFlow/operationFlowDetail.jsp?circuitcode="+NodeLabel;
			//	tmis_request.source="http://www.baidu.com/s?wd="+NodeLabel;
			}
		}
	}
	/**
	 *业务树点击事件 
	 * @param evt
	 * 
	 */
	private function tree_itemClick(evt:ListEvent):void 
	{
		var item:Object = Tree(evt.currentTarget).selectedItem;
		if (channeltree.dataDescriptor.isBranch(item)) 
		{
			channeltree.expandItem(item, !channeltree.isItemOpen(item), true);
		}
	}
	private var curIndex:int;
	/**
	 *当前选中的结点 
	 */
	private var selectedNode:XML; 
	private var catalogsid:String;
	/**
	 *业务树选中结点发生改变 
	 * 
	 */
	private function treeChange():void
	{ 		
		channeltree.selectedIndex = curIndex;
		selectedNode = channeltree.selectedItem as XML;
		if(selectedNode.@leaf==false&&(selectedNode.children()==null||selectedNode.children().length()==0))
		{
			catalogsid = selectedNode.@label; 
			this.dispatchEvent(new Event(EventNames.CATALOGROW));
		}
	}
	/**
	 *获取业务树的下层结点 
	 * @param e
	 * 
	 */
	private function gettree(e:Event):void
	{ 
		this.removeEventListener(EventNames.CATALOGROW,gettree);
		var ptTreeRO:RemoteObject = new RemoteObject("channelTree");
		ptTreeRO.endpoint = ModelLocator.END_POINT;
		ptTreeRO.showBusyCursor =true;
		ptTreeRO.TreeRouteActionForAsynch(circuitcode1,requisitionid1,username1,operationtype1,rate1,state1,"leaf",catalogsid);
		ptTreeRO.addEventListener(ResultEvent.RESULT,getNextTreeNode);
		ptTreeRO.addEventListener(FaultEvent.FAULT,DealFault);
	} 
	
	/**
	 *获取电路路由图树的二级结点(电路编号层) 
	 * @param e
	 * 
	 */
	private function getNextTreeNode(e:ResultEvent):void
	{
		var str:String = e.result as String;  
		if(str!=null&&str!="")
		{  
			var child:XMLList= new XMLList(str);
			if(selectedNode.children()==null||selectedNode.children().length()==0)
			{ 									 
				selectedNode.appendChild(child);
				channeltree.callLater(openTreeNode,[selectedNode]);
				var para_circuitcode:String=Registry.lookup("para_circuitcode");
				if(para_circuitcode!=null)
				{
					for each (var element:XML in selectedNode.children()) 
					{
						if(element.@label==para_circuitcode )
						{
								var parent:XML = element.parent();
								channeltree.expandItem(parent,true);
								channeltree.selectedItem = element;	
								channeltree.dispatchEvent(new MouseEvent(MouseEvent.DOUBLE_CLICK));
						}
					}
					Registry.unregister("para_circuitcode");
				}
					
			}
		}
		this.addEventListener(EventNames.CATALOGROW,gettree);//获取树的下层结点
	}
	/**
	 *展开当前结点的下层 
	 * @param xml
	 * 
	 */
	private function openTreeNode(xml:XML):void
	{
		if(channeltree.isItemOpen(xml))
		{	
			channeltree.expandItem(xml,false);
		}
		channeltree.expandItem(xml,true);
	}
    
	/**
	 *对电路呈现的属性进行保存
	 * @param e
	 * 
	 */
    private function submitChannel(e:Event):void
	{
		if(portShow.selected&&slotserial.selected&&portserial.selected)
		{
			var count:int = network_config.elementBox.datas.count;
			for(var i:int=0;i<count;i++)
			{
				var ielement:IElement = network_config.elementBox.datas.getItemAt(i);
				if((ielement is Follower)&&ielement.getClient("flag")=="port")
				{
					ielement.setStyle(Styles.LABEL_ALPHA,1);
					var portlabel:String = ielement.getClient("portlabel");
					if(portlabel!=null)
					{
						var slot:Array = portlabel.split("$");
						ielement.name = (slot[1]==null?"":slot[1])+"["+(slot[3]==null?"":slot[3])+"]";
					}
				}
			}
			
		}
		if(portShow.selected&&slotserial.selected&&!portserial.selected)
		{
			var count:int = network_config.elementBox.datas.count;
			for(var i:int=0;i<count;i++)
			{
				var ielement:IElement = network_config.elementBox.datas.getItemAt(i);
				if((ielement is Follower)&&ielement.getClient("flag")=="port")
				{
					ielement.setStyle(Styles.LABEL_ALPHA,1);
					var portlabel:String = ielement.getClient("portlabel");
					if(portlabel!=null)
					{
						var slot:Array = portlabel.split("$");
						ielement.name = slot[1];
					}
				}
			}
			
		}
		if(portShow.selected&&!slotserial.selected&&portserial.selected)
		{
			var count:int = network_config.elementBox.datas.count;
			for(var i:int=0;i<count;i++)
			{
				var ielement:IElement = network_config.elementBox.datas.getItemAt(i);
				if((ielement is Follower)&&ielement.getClient("flag")=="port")
				{
					ielement.setStyle(Styles.LABEL_ALPHA,1);
					var portlabel:String = ielement.getClient("portlabel");
					if(portlabel!=null)
					{
						var slot:Array = portlabel.split("$");
						ielement.name = slot[3];
					}
				}
			}
			
		}
		if(portShow.selected&&!slotserial.selected&&!portserial.selected)
		{
			var count:int = network_config.elementBox.datas.count;
			for(var i:int=0;i<count;i++)
			{
				var ielement:IElement = network_config.elementBox.datas.getItemAt(i);
				if((ielement is Follower)&&ielement.getClient("flag")=="port")
				{
					ielement.setStyle(Styles.LABEL_ALPHA,0);
				}
			}
			
		}
		if(portHide.selected)
		{
		  var count:int = network_config.elementBox.datas.count;
		  for(var i:int=0;i<count;i++)
		  {
			  var ielement:IElement = network_config.elementBox.datas.getItemAt(i);
			  if((ielement is Follower)&&ielement.getClient("flag")=="port")
			  {
			      ielement.setStyle(Styles.LABEL_ALPHA,0);
			  }
		  }
		
		}
		if(topoLinkShow.selected&&systemcode.selected&&timeslot.selected)
		{
			var count:int = network_config.elementBox.datas.count;
			for(var i:int=0;i<count;i++)
			{
				var ielement:IElement = network_config.elementBox.datas.getItemAt(i);
				if((ielement is Link)&&ielement.getClient("flag")=="topolink")
				{
					ielement.setStyle(Styles.LABEL_ALPHA,1);
					var label:String = "";
					if(timeslot373.selected)
					{
						
						if(ielement.getClient("timeslot373")!=null&&ielement.getClient("timeslot373")!="")
						{
							label = (ielement.getClient("systemcode")==null?"":ielement.getClient("systemcode"))+"\n" +ielement.getClient("timeslot373");
						}
						else
						{	
							label = ielement.getClient("systemcode")==null?"":ielement.getClient("systemcode");
						}
					}
					if(timeslotno373.selected)
					{
					  if(ielement.getClient("timeslot")!=null&&ielement.getClient("timeslot")!="")
					  {
						  label = (ielement.getClient("systemcode")==null?"":ielement.getClient("systemcode"))+"\n" +ielement.getClient("timeslot");
					  }
					  else
					  {
						  label = ielement.getClient("systemcode")==null?"":ielement.getClient("systemcode"); 
					  }
					}
					ielement.name = label;
				}
			}
		
		}
		if(topoLinkShow.selected&&systemcode.selected&&!timeslot.selected)
		{
			var count:int = network_config.elementBox.datas.count;
			for(var i:int=0;i<count;i++)
			{
				var ielement:IElement = network_config.elementBox.datas.getItemAt(i);
				if((ielement is Link)&&ielement.getClient("flag")=="topolink")
				{
					ielement.setStyle(Styles.LABEL_ALPHA,1);
					var label:String = "";
					label = ielement.getClient("systemcode")==null?"":ielement.getClient("systemcode");
					ielement.name = label;
				}
			}
			
		}
		
		if(topoLinkShow.selected&&!systemcode.selected&&timeslot.selected)
		{
			var count:int = network_config.elementBox.datas.count;
			for(var i:int=0;i<count;i++)
			{
				var ielement:IElement = network_config.elementBox.datas.getItemAt(i);
				if((ielement is Link)&&ielement.getClient("flag")=="topolink")
				{
					ielement.setStyle(Styles.LABEL_ALPHA,1);
					var label:String = "";
					if(timeslot373.selected)
					{
						if(ielement.getClient("timeslot373")!=null&&ielement.getClient("timeslot373")!="")
						{
							label = ielement.getClient("timeslot373");
						}
						else
						{
							label = "";
						}
					}
					if(timeslotno373.selected)
					{
						if(ielement.getClient("timeslot")!=null&&ielement.getClient("timeslot")!="")
						{
							label = ielement.getClient("timeslot");
						}		
						else
						{	
							label = "";
						}
					}
					ielement.name = label;
				}
			}
			
		}
		
		if(topoLinkShow.selected&&!systemcode.selected&&!timeslot.selected)
		{
			var count:int = network_config.elementBox.datas.count;
			for(var i:int=0;i<count;i++)
			{
				var ielement:IElement = network_config.elementBox.datas.getItemAt(i);
				if((ielement is Link)&&ielement.getClient("flag")=="topolink")
				{
					ielement.setStyle(Styles.LABEL_ALPHA,0);
				}
			}
			
		}
		if(topoLinkHide.selected)
		{
			var count:int = network_config.elementBox.datas.count;
			for(var i:int=0;i<count;i++)
			{
				var ielement:IElement = network_config.elementBox.datas.getItemAt(i);
				if((ielement is Link)&&ielement.getClient("flag")=="topolink")
				{
					ielement.setStyle(Styles.LABEL_ALPHA,0);
				}
			}
		}
		var rt:RemoteObject = new RemoteObject("channelTree");
		Application.application.faultEventHandler(rt);
		var content:String = "{"
			                   +"\"portShow\":\""+portShow.selected+"\""
							   +",\"portHide\":\""+portHide.selected+"\""
							   +",\"slotserial\":\""+slotserial.selected+"\""
							   +",\"portserial\":\""+portserial.selected+"\""
							   +",\"topoLinkShow\":\""+topoLinkShow.selected+"\""
							   +",\"topoLinkHide\":\""+topoLinkHide.selected+"\""
							   +",\"systemcode\":\""+systemcode.selected+"\""
							   +",\"timeslot\":\""+timeslot.selected+"\""
							   +",\"timeslot373\":\""+timeslot373.selected+"\""
							   +",\"timeslotno373\":\""+timeslotno373.selected+"\""
			                   + "}";
        rt.endpoint = ModelLocator.END_POINT;							  
	    rt.saveChannelConfig(content);
		rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
		if(event.result!=null)
		{
			Alert.show("应用成功！","提示");
		}
		});
	}

	private function setConfig():void
	{
		if(portShow.selected&&slotserial.selected&&portserial.selected)
		{
			var count:int = network_config.elementBox.datas.count;
			for(var i:int=0;i<count;i++){
				var ielement:IElement = network_config.elementBox.datas.getItemAt(i);
				if((ielement is Follower)&&ielement.getClient("flag")=="port"){
					ielement.setStyle(Styles.LABEL_ALPHA,1);
					var portlabel:String = ielement.getClient("portlabel");
					if(portlabel!=null){
						var slot:Array = portlabel.split("$");
						ielement.name = slot[1]+"["+slot[3]+"]";
					}
				}
			}
			
		}
		if(portShow.selected&&slotserial.selected&&!portserial.selected){
			var count:int = network_config.elementBox.datas.count;
			for(var i:int=0;i<count;i++){
				var ielement:IElement = network_config.elementBox.datas.getItemAt(i);
				if((ielement is Follower)&&ielement.getClient("flag")=="port"){
					ielement.setStyle(Styles.LABEL_ALPHA,1);
					var portlabel:String = ielement.getClient("portlabel");
					if(portlabel!=null){
						var slot:Array = portlabel.split("$");
						ielement.name = slot[1];
					}
				}
			}
			
		}
		if(portShow.selected&&!slotserial.selected&&portserial.selected){
			var count:int = network_config.elementBox.datas.count;
			for(var i:int=0;i<count;i++){
				var ielement:IElement = network_config.elementBox.datas.getItemAt(i);
				if((ielement is Follower)&&ielement.getClient("flag")=="port"){
					ielement.setStyle(Styles.LABEL_ALPHA,1);
					var portlabel:String = ielement.getClient("portlabel");
					if(portlabel!=null){
						var slot:Array = portlabel.split("$");
						ielement.name = slot[3];
					}
				}
			}
			
		}
		if(portShow.selected&&!slotserial.selected&&!portserial.selected){
			var count:int = network_config.elementBox.datas.count;
			for(var i:int=0;i<count;i++){
				var ielement:IElement = network_config.elementBox.datas.getItemAt(i);
				if((ielement is Follower)&&ielement.getClient("flag")=="port"){
					ielement.setStyle(Styles.LABEL_ALPHA,0);
				}
			}
			
		}
		if(portHide.selected){
			var count:int = network_config.elementBox.datas.count;
			for(var i:int=0;i<count;i++){
				var ielement:IElement = network_config.elementBox.datas.getItemAt(i);
				if((ielement is Follower)&&ielement.getClient("flag")=="port"){
					ielement.setStyle(Styles.LABEL_ALPHA,0);
				}
			}
			
		}
		if(topoLinkShow.selected&&systemcode.selected&&timeslot.selected){
			var count:int = network_config.elementBox.datas.count;
			for(var i:int=0;i<count;i++){
				var ielement:IElement = network_config.elementBox.datas.getItemAt(i);
				if((ielement is Link)&&ielement.getClient("flag")=="topolink"){
					ielement.setStyle(Styles.LABEL_ALPHA,1);
					var label:String = "";
					if(timeslot373.selected){
						if(ielement.getClient("timeslot373")!=null&&ielement.getClient("timeslot373")!="")
						    label = ielement.getClient("systemcode")+"\n" +ielement.getClient("timeslot373");
						else
							label = ielement.getClient("systemcode"); 
					}
					if(timeslotno373.selected){
						if(ielement.getClient("timeslot")!=null&&ielement.getClient("timeslot")!=""){
							label = ielement.getClient("systemcode")+"\n" +ielement.getClient("timeslot");
						}else{
							label = ielement.getClient("systemcode");
						}
						
					}
					ielement.name = label;
				}
			}
			
		}
		if(topoLinkShow.selected&&systemcode.selected&&!timeslot.selected){
			var count:int = network_config.elementBox.datas.count;
			for(var i:int=0;i<count;i++){
				var ielement:IElement = network_config.elementBox.datas.getItemAt(i);
				if((ielement is Link)&&ielement.getClient("flag")=="topolink"){
					ielement.setStyle(Styles.LABEL_ALPHA,1);
					var label:String = "";
					label = ielement.getClient("systemcode");
					ielement.name = label;
				}
			}
			
		}
		
		if(topoLinkShow.selected&&!systemcode.selected&&timeslot.selected){
			var count:int = network_config.elementBox.datas.count;
			for(var i:int=0;i<count;i++){
				var ielement:IElement = network_config.elementBox.datas.getItemAt(i);
				if((ielement is Link)&&ielement.getClient("flag")=="topolink"){
					ielement.setStyle(Styles.LABEL_ALPHA,1);
					var label:String = "";
					if(timeslot373.selected){
						if(ielement.getClient("timeslot373")!=null&&ielement.getClient("timeslot373")!="")
						    label = ielement.getClient("timeslot373");
						else
							label = "";
					}
					if(timeslotno373.selected){
						if(ielement.getClient("timeslot")!=null&&ielement.getClient("timeslot")!="")
						    label = ielement.getClient("timeslot");
						else
							label = "";
					}
					ielement.name = label;
				}
			}
			
		}
		
		if(topoLinkShow.selected&&!systemcode.selected&&!timeslot.selected){
			var count:int = network_config.elementBox.datas.count;
			for(var i:int=0;i<count;i++){
				var ielement:IElement = network_config.elementBox.datas.getItemAt(i);
				if((ielement is Link)&&ielement.getClient("flag")=="topolink"){
					ielement.setStyle(Styles.LABEL_ALPHA,0);
				}
			}
			
		}
		if(topoLinkHide.selected){
			var count:int = network_config.elementBox.datas.count;
			for(var i:int=0;i<count;i++){
				var ielement:IElement = network_config.elementBox.datas.getItemAt(i);
				if((ielement is Link)&&ielement.getClient("flag")=="topolink"){
					ielement.setStyle(Styles.LABEL_ALPHA,0);
				}
			}
		}
	}

	/**
	 *取消设置电路路由图呈现的属性 
	 * @param event
	 * 
	 */
    private function cancelChannel(event:Event):void
	{
		optionPane.visible=false;
	}

   
/**
 *加入重点电路监控功能 
 * @param event
 * 
 */
private function addHandler(event:ContextMenuEvent):void
{   var item:Object = channeltree.selectedItem;
	var str:String =item.@label;
	var remote:RemoteObject = new RemoteObject("channelRouteForm");	
	remote.endpoint = ModelLocator.END_POINT;
	remote.addEventListener(ResultEvent.RESULT,function():void{
		Alert.show("加入重点电路监控成功！");
		channeltree.selectedItem.@ismonitored = '1';
		
	});
	remote.addCircuitmonitoring(str);
	
}
/**
 *取消重点电路监控功能 
 * @param event
 * 
 */
private function delHandler(event:ContextMenuEvent):void
{   var item:Object = channeltree.selectedItem;
	var str:String =item.@label;
	var remote:RemoteObject = new RemoteObject("channelRouteForm");
	remote.endpoint = ModelLocator.END_POINT;
	remote.addEventListener(ResultEvent.RESULT,function():void{
		Alert.show("取消重点电路监控成功！");
		channeltree.selectedItem.@ismonitored = '0';		
	});
	remote.delCircuitmonitoring(str);
	
}

	/**
	 *指定起始（终止）端口 
	 * @param flag
	 * 
	 */
	private function confirmStartOrEndPort(flag:String):void{
		var follow:Follower = channelPic.selectionModel.selection.getItemAt(0) as Follower;
		if(follow!=null){
			var T:Boolean = true;
			var collection:ICollection = follow.links;
			var count:int = collection.count;
			for(var i:int=0;i<count;i++){
				var idata:IData = collection.getItemAt(i);
				var ccOrtopo:String = idata.getClient("flag");
				if(ccOrtopo!=null&&ccOrtopo=='topolink'){
					T = false;
					break;
				}
			}
			if(T){
				var alertString:String = "您确认要指定该端口为起始端口吗？";
				if(flag=="end"){
					alertString = "您确认要指定该端口为终止端口吗？";
				}
				Alert.show(alertString,
					"提示",
					Alert.YES|Alert.NO,
					null,
					function(e:CloseEvent):void{confirm(e,flag)}
				);
			}else{
				Alert.show("不能指定线路口为起始或者终止端口！","提示");
			}
		}
	}
	private function confirm(e:CloseEvent,flag:String):void{
		if(e.detail==Alert.YES){
			var follow:Follower = channelPic.selectionModel.selection.getItemAt(0) as Follower;
			var portcode:String = follow.getClient("portcode");
			if(portcode!=null){
				portcode = portcode.split(",")[0];
			}
			var slot:String = follow.getClient("slot");
			var rt:RemoteObject = new RemoteObject("channelTree");
			rt.endpoint = ModelLocator.END_POINT;
			rt.showBusyCursor = true;
			var node:XML = channeltree.selectedItem as XML
			var circuitcode:String = node.@label;
			rt.confirmStartOrEndPort(portcode,slot,circuitcode,flag);
			rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
				Alert.show("操作成功！","提示");
				follow.image = "twaverImages/channelroute/luyou_port2.png";
			});
		}
	}
   /**
    *查询电路 
    * 
    */
   private function select():void
   {
	   circuitcode1=SearchBar.f_circuitcode.text;
	   if(SearchBar.currentState=='more')
	   {
		   if(SearchBar.f_userName.selectedItem!=null && SearchBar.f_userName.selectedItem.@label!="---全部---")
		   {    
			   username1 = SearchBar.f_userName.selectedItem.@label;
		   }
		   else
		   {
			   username1=null;
		   }
	 
		  if(SearchBar.f_rate.selectedItem!=null)
		  {
			  rate1=SearchBar.f_rate.selectedItem.@code;
		  }
		  if(SearchBar.f_state.selectedItem!=null)
		  {
			  state1=SearchBar.f_state.selectedItem.@code;
		  }
	  }
	  if(circuitcode1!=null&&circuitcode1!=""&&requisitionid1&&requisitionid1!=""&&username1&&username1!=""&&operationtype1&&operationtype1!=""&&rate1&&rate1!=""&&state1&&state1!="")
	  {
		  channeltreeremote.TreeRouteActionNew(circuitcode1,requisitionid1,username1,null,rate1,state1);
	  } 
	  else
	  {
		  channeltreeremote.TreeRouteActionForAsynch(circuitcode1,requisitionid1,username1,operationtype1,rate1,state1,"root","");
	  }  
   }
	/**
	 *将填写的内容清空！ 
	 * 
	 */
	private function reset():void{
		SearchBar.f_circuitcode.text="";//电路编号
		SearchBar.f_userName.selectedIndex = -1;//业务类型
		SearchBar.f_rate.selectedIndex = -1;//速率
		SearchBar.f_state.selectedIndex = -1;//电路状态
		username1=null;
		circuitcode1=null;
		requisitionid1=null;
		operationtype1=null;
		rate1=null;
		state1=null;
	}
