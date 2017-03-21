	
	import com.adobe.serialization.json.JSON;
	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	
	import mx.collections.*;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.controls.Tree;
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
	
	import twaver.*;
	import twaver.ElementBox;
	import twaver.network.Network;
	private var pageIndex:int=0;
	private var pageSize:int=5;
	private var box:ElementBox = new ElementBox();
	public var c_circuitcode:String =null;
	private var serializable:ISerializable = null;
	[Embed(source="assets/images/sysorg.png")]          //这是图片的相对地址 
	[Bindable] 
	public var systemIcon:Class; 
	
	[Embed(source="assets/images/device/equipment.png")]
	public static const equipIcon:Class;
	
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
		//DemoUtils.addOverview(powerPic);
		DemoUtilsForChannel.initNetworkToolbar(toolbar, channelPic,"默认模式");
		DemoUtilsForChannel.initNetworkContextMenu(channelPic,'电路路由');
		Utils.registerImageByClass("equipIcon", equipIcon);
		SerializationSettings.registerGlobalClient("flag", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("isbranch", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("position", Consts.TYPE_INT);
		SerializationSettings.registerGlobalClient("equipcode", Consts.TYPE_STRING);
		SerializationSettings.registerGlobalClient("portcode", Consts.TYPE_STRING);	
		if(c_circuitcode!=null){
			var box:ElementBox = channelPic.elementBox;
			box.clear();
			var rtobj:RemoteObject = new RemoteObject("channelRoute");
			rtobj.endpoint = ModelLocator.END_POINT;
			rtobj.showBusyCursor = "true";
			rtobj.getChannelRoute(c_circuitcode);
			channelPic.name=c_circuitcode;
			channelbox.label = c_circuitcode;
			channelbox1.label = '方式单-'+c_circuitcode;
			rtobj.addEventListener(ResultEvent.RESULT,drawPic);
		}
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
		var serializer:XMLSerializer = new XMLSerializer(channelPic.elementBox);
		serializer.deserialize(e.result.toString());	
		channelPic.labelFunction= function(element:IElement):String{			
			var label:String = element.getStyle(Styles.NETWORK_LABEL);
			if(element is Group){
				var group:Group = element as Group;
				if(group.expanded){
					return "";
				}
			}
			if(label != null){
				return label;
			}
			return element.name;
		};
	}
	private function getChannelRouteResult(e:ResultEvent):void{
		if(e.result != null){
			circuitcode.text=c_circuitcode;
			remark.text=e.result.remark;
			userCom.text=e.result.userCom;
			requestCom.text=e.result.requestCom;
			//					requisitionId.text=e.result.requisitionId;//by sjt
			userName.text=e.result.userName;
			operationType.text=e.result.operationType;
			rate.text=e.result.rate;
			circuitLevel.text=e.result.circuitLevel;
			interfaceType.text=e.result.interfaceType;
			state.text=e.result.state;
			station1.text=e.result.station1;
			station2.text=e.result.station2;
			equipCode1.text=e.result.equipCode1;
			equipCode2.text=e.result.equipCode2;
			//beiZhu.text=e.result.beiZhu;beiZhu
			//					netManagerId.text=e.result.netManagerId; //by sjt
			portserialno1.text=e.result.portserialno1;
			portserialno2.text=e.result.portserialno2;
			leaser.text=e.result.leaser;
			createTime.text=e.result.createTime;
			//					requestFinish_time=e.result.useTime;
			useTime.text=e.result.useTime;
			requiSitionId.text=e.result.beiZhu;
			TxtFSDcode.text = e.result.form_name;//add by sjt
			TxtImplementation_units.text = e.result.implementation_units;//add by sjt
			
		}
	}
	private function changeItems(evt: IndexChangedEvent):void{
		var flag : String = channeltab.getTabAt(channeltab.selectedIndex).label;
		if(flag.indexOf("方式单")!=-1){
			var remoteobj:RemoteObject = new RemoteObject("channelRouteForm");
			remoteobj.endpoint = ModelLocator.END_POINT;
			remoteobj.showBusyCursor =true;
			remoteobj.getItems(c_circuitcode);		
			remoteobj.addEventListener(ResultEvent.RESULT,getChannelRouteResult);	
		}
	}
	
	protected function channelPic_keyDownHandler(event:KeyboardEvent):void
	{
		if(channelPic.selectionModel.count==1)
			var element:* = channelPic.selectionModel.selection.getItemAt(0);
		if(event.keyCode == Keyboard.DELETE){
			if(element is Link){
				Alert.show("确定要删除"+Link(element).name+"吗?","请您确认！",Alert.YES|Alert.NO,this,function(e:CloseEvent):void{
					if(e.detail == Alert.YES){
						channelPic.elementBox.remove(element);
					}
				},null,Alert.NO);
			}else  
				if(element is Node){
					Alert.show("确定要删除吗?","请您确认！",Alert.YES|Alert.NO,this,function(e:CloseEvent):void{
						if(e.detail == Alert.YES){
							channelPic.elementBox.remove(element);
						}
					},null,Alert.NO);	
				}
			
		}
		
	}