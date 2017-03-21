	import com.adobe.serialization.json.JSON;
	
	import common.actionscript.ModelLocator;
	import common.actionscript.MyImageFollower;
	import common.actionscript.MyPopupManager;
	
	import flash.display.Loader;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.ui.ContextMenu;
	import flash.utils.setTimeout;
	
	import mx.collections.*;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.controls.Image;
	import mx.controls.Tree;
	import mx.core.Application;
	import mx.core.DragSource;
	import mx.events.CloseEvent;
	import mx.events.DragEvent;
	import mx.events.IndexChangedEvent;
	import mx.events.ItemClickEvent;
	import mx.managers.PopUpManager;
	import mx.messaging.events.ChannelEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	import sourceCode.autoGrid.view.ShowProperty;
	import sourceCode.channelRoute.model.ResultModel;
	import sourceCode.channelRoute.views.circuitReq;
	import sourceCode.channelRoute.views.relatecircuit;
	import sourceCode.packGraph.views.OpticalPort;
	import sourceCode.packGraph.views.checkedEquipPack;
	
	import twaver.*;
	import twaver.ElementBox;
	import twaver.network.Network;
	import twaver.network.interaction.InteractionEvent;

	private var pageIndex:int=0;
	private var pageSize:int=5;
	private var box:ElementBox = new ElementBox();
	public var c_circuitcode:String ="";
	public var logicport:String = "00000500000030205049";
	public var equippack:checkedEquipPack;
	public var opticalport:OpticalPort;

	public var flag:String = null;

	private var serializable:ISerializable = null;
	[Embed(source="assets/images/sysorg.png")]          //这是图片的相对地址 
	[Bindable] 
	public var systemIcon:Class; 
	
	[Embed(source="assets/images/device/equipment.png")]
	public static const equipIcon:Class;
	

	public var equippack_follower:Follower;
	public var slot:String =null;
	
	[Embed(source="assets/images/sysorg.png")]          //这是图片的相对地址 
	[Bindable] 
	public var channelIcon:Class; 
	
	
	[Bindable]
	public var elementBox:ElementBox;
	[Bindable]
	public var XMLData:XML;	
	public var isClick:Boolean=false ;
	public var NodeLabel:String ;
	
	public function get dataBox():DataBox{
		return box;
	}
	[Bindable]   
	public var folderList:XMLList= new XMLList(); 
	[Bindable]   
	public var folderCollection:XMLListCollection;
	private function close():void  
	{  
		MyPopupManager.removePopUp(this);  
	}
	private function init():void  
	{   
		DemoUtilsForChannel.initNetworkToolbarfortandem1(toolbar, channelPic,this,logicport,"默认模式");
		Utils.registerImageByClass("equipIcon", equipIcon);
		elementBox = channelPic.elementBox;
		elementBox.clear();
		var layer:Layer= new Layer("equipment");
		elementBox.layerBox.add(layer);
		var port1:Layer = new Layer("port1");
		elementBox.layerBox.add(port1);
		var linklayer:Layer = new Layer("linklayer");
		elementBox.layerBox.add(linklayer);
		
//		var node:Node = new Node("node");
//		node.name='aaa';
//		node.image="twaverImages/channelroute/luyou_bg.png";
//		node.setLocation(20,20);;
//		node.width=133;
//		node.height=153;
//		node.layerID="equipment";
//		box.add(node);
//		
//			
//		 var follower:Follower = new Follower("aaav");
//		follower.name="bbbb";
//		follower.parent=node;
//		follower.setStyle(Styles.LABEL_SIZE, 12);
//		follower.image="twaverImages/channelroute/luyou_port.png";
//		follower.layerID="port1";
//		follower.host=node;
//		follower.setLocation(20,20);
//		
//		box.add(follower);
//		channelPic.callLater(function():void{
//			setTimeout(function():void{
				if(c_circuitcode!=""){
					var rtobj:RemoteObject = new RemoteObject("operaTopo");
					rtobj.endpoint = ModelLocator.END_POINT;
					rtobj.showBusyCursor = "true";
					rtobj.tandemCircuit_new(c_circuitcode);
					if(c_circuitcode!=null&&c_circuitcode!=""){
						channelPic.name=c_circuitcode;
						channelbox.label = c_circuitcode;
					}
					//			rtobj.addEventListener(ResultEvent.RESULT,drawPic);
					rtobj.addEventListener(ResultEvent.RESULT,addImage);
				}
//			},2000);
//		
//		});
				
//	
				channelPic.addInteractionListener(function(e:InteractionEvent):void{
					if(e.kind == "clickElement"){
//						Alert.show("come");
						var box:ElementBox = channelPic.elementBox;
						var element:IElement = e.element;
						if(element is Node){
//							Alert.show("come1");
							var node:Node = element as Node;
							node.setLocation(0,120);
						}
					}
					
				});
		
		
		
	}
	

	private function itemSelectHandler_port(evt:ContextMenuEvent,network:Network):void{
		var follow:Follower = network.selectionModel.selection.getItemAt(0) as Follower;
		channelShowProperty(follow);	
	}
	
	private function itemSelectHandler_Ocable(e:ContextMenuEvent,network:Network):void{
		var link:Link = network.selectionModel.selection.getItemAt(0);
		channelShowProperty(link);
	}
	
	private function itemSelectHandler(e:ContextMenuEvent,network:Network):void{
		var node:Node = network.selectionModel.selection.getItemAt(0);
		channelShowProperty(node);		
	}
	private function channelShowProperty(ielement:IElement):void{
		if((ielement is Node)&&ielement.getClient("flag")=='equipment'){
			var node:Node = ielement as Node;
			var equipcode:String = node.getClient("equipcode");
			var equipname:String = node.children.getItemAt(0).name;
			var property:ShowProperty = new ShowProperty();
			property.paraValue = equipcode;
			property.tablename = "VIEW_EQUIPMENT";
			property.key = "EQUIPCODE";
			property.title = equipname+"—设备属性";
			PopUpManager.addPopUp(property, this, true);
			PopUpManager.centerPopUp(property);
		}else if((ielement is Follower)&&ielement.getClient("flag")=='port'){
			var follower:Follower = ielement as Follower;
			var portcode:String=follower.getClient("portcode");
			if(portcode!=null){
				portcode = portcode.split(",")[0];
			}
			
			var portname:String = follower.host.children.getItemAt(0).name+"-"+follower.toolTip;
			var property:ShowProperty = new ShowProperty();
			property.paraValue = portcode;
			property.tablename = "VIEW_EQUIPLOGICPORT_PROPERTY";
			property.key = "LOGICPORT";
			property.title = portname+"—端口属性";
			PopUpManager.addPopUp(property, this, true);
			PopUpManager.centerPopUp(property);
		}else if(ielement is Link){
			var link:Link = ielement as Link;
			var topolinkid:Object = link.getClient('topoid');
			var labelname:String="";
			labelname = link.fromNode.name+'至'+link.toNode.name;
			var property:ShowProperty = new ShowProperty();
			property.paraValue = topolinkid.toString();
			property.tablename = "VIEW_ENTOPOLINKPROPERTY";
			property.key = "label";
			property.title = labelname+"—复用段属性";
			PopUpManager.addPopUp(property, this, true);
			PopUpManager.centerPopUp(property);		
		}
	}

	private function relateCircuit(e:ContextMenuEvent):void{
	}
	
	private function relateCircuit1(e:ContextMenuEvent):void{
	}
	
	private function deviceiconFun(item:Object):*
	{
		if(item.@leaf==true)
			return equipIcon;
		else
			return DemoImages.file;
	}
	
	private function drawPic(e:ResultEvent):void{
		
		channelPic.elementBox.clear();
		var x:int=0;
		var listResult:ArrayCollection =e.result as ArrayCollection;
			if(listResult.length>0){
				operadatagrid.dataProvider=listResult;
				for(var i:int=0;i<listResult.length;i++){
					var c:Object=listResult[i] as Object;
					var exist_node:Node=elementBox.getDataByID(c.EQUIP) as Node;
					if(exist_node){
						var follower:Follower = new Follower(c.PORTID);
						follower.name=c.PORT+"/n"+c.SLOT;
						follower.parent=exist_node;
						follower.setStyle(Styles.LABEL_SIZE, 12);
						follower.image="twaverImages/channelroute/luyou_port.png";
						follower.layerID="port1";
						follower.host=exist_node;
						follower.setLocation(exist_node.centerLocation.x+exist_node.width/2-follower.width/2-6,exist_node.centerLocation.y);
						elementBox.add(follower);
					}else{
						var node:Node = new Node(c.EQUIP);
						node.name=c.EQUIP;
						node.image="twaverImages/channelroute/luyou_bg.png";
						node.width=133;
						node.height=153;
						node.setLocation(x,channelPic.height/2-node.height/2);
						node.layerID="equipment";
						x=x+node.width+20;
						elementBox.add(node);
						
						var follower:Follower = new Follower(c.PORTID);
						follower.name=c.PORT+"\n"+c.SLOT;
						follower.parent=node;
						follower.setStyle(Styles.LABEL_SIZE, 12);
						follower.image="twaverImages/channelroute/luyou_port.png";
						follower.layerID="port1";
						follower.host=node;
						follower.setLocation(node.x+follower.width/2,node.centerLocation.y);
						elementBox.add(follower);
					}
				}
				for(var j:int=0;j<listResult.length;j++){
					var c1:Object=listResult[j] as Object;
					var node_a:Node=null;
					var node_z:Node=null;
					var existlink1:Link=elementBox.getDataByID(c1.PORTID+c1.CNPORT) as Link;
					var existlink2:Link=elementBox.getDataByID(c1.CNPORT+c1.PORTID) as Link;
					if((existlink1==null)&&(existlink2==null))
					{
						node_a=elementBox.getDataByID(c1.PORTID) as Node;
						node_z=elementBox.getDataByID(c1.CNPORT) as Node;
						if(node_a!=null&&node_z!=null)
						{
							var link:Link=new Link(c1.PORTID+c1.CNPORT,node_a, node_z);
							elementBox.add(link);
						}
					}
				}
				
			}
		
	}
	private function confirmStartOrEndPort(flag:String):void{
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
			rt.confirmStartOrEndPort(portcode,slot,c_circuitcode,flag);
			rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
				Alert.show("操作成功！","提示");
				follow.image = "twaverImages/channelroute/luyou_port2.png";
			});
		}
	}

private function addImage(e:ResultEvent):void{
//	Alert.show(toolbar.height+"");
	var mo:Layer = new Layer("cannot");
	mo.movable = false;
	mo.editable = false;
	channelPic.elementBox.layerBox.add(mo);
//	channelPic.setPanInteractionHandlers();
	var rm:ResultModel = e.result as ResultModel;
	if(rm.string!=""){
		channelPic.elementBox.clear();
		var loader:Loader = new Loader();  
		loader.load(new URLRequest("assets/circuitImages/test.jpg"));
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(e:Event){
		var node:MyImageFollower = new MyImageFollower();
		node.image = "";
		node.setClient("source",e.currentTarget.content);
		node.setClient("height",e.currentTarget.content.height);
		node.setClient("width",e.currentTarget.content.width);	
		node.setLocation(0,0);
		
		node.layerID = "cannot";
		channelPic.elementBox.add(node);
		channelPic.dispatchEvent(new InteractionEvent("clickElement",channelPic,new MouseEvent(MouseEvent.CLICK),node));
//		if(e.currentTarget.content.width>900)channelPic.horizontalScrollPolicy = "on";
		channelPic.initialize();
//		channelPic.elementBox.selectionModel.selection.addItem(node);
//		channelPic.elementBox.selectionModel.setSelection(node);
		} );

		
	}else{
		Alert.show("请联系管理员!","提示");
	}
	if(rm.orderList.length!=0){
		var listResult:ArrayCollection =rm.orderList as ArrayCollection;
		if(listResult.length>0){
			operadatagrid.dataProvider=listResult;
	}
}
}
