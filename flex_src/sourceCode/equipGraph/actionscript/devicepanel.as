	import com.adobe.serialization.json.JSON;
	
	import common.actionscript.ModelLocator;
	import common.actionscript.Registry;
	import common.other.events.CustomEvent;
	import common.other.events.EventNames;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import flexlib.controls.SuperTabBar;
	import flexlib.controls.tabBarClasses.SuperTab;
	import flexlib.events.SuperTabEvent;
	import flexlib.events.TabReorderEvent;
	
	import mx.collections.*;
	import mx.collections.ArrayCollection;
	import mx.containers.dividedBoxClasses.BoxDivider;
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.controls.SWFLoader;
	import mx.controls.Tree;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.IndexChangedEvent;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	import sourceCode.alarmmgrGraph.model.AlarmModel;
	import sourceCode.equipGraph.views.checkdevicepanelchild;
	
	import twaver.*;
	import twaver.network.Network;
	
	[Bindable]   
	public var folderList:XMLList= new XMLList(); 
	
	[Bindable]   
	public var folderCollection:XMLList;
	
	
	private var selectedNode:XML;  
	private var catalogsid:String;  
	private var type:String;
	private var curIndex:int;
	private var systemcode:String;
	private var equipcode:String;
	private var slotdir:String;

	public function init():void{//initEvent->init->resultHandler
		treedevice.dataProvider = null;
		devicetreeremote.addEventListener(ResultEvent.RESULT,resultHandler);
		devicetreeremote.getDeviceTree(" ","root");
		this.addEventListener("toggle",toggle);
	}
	private function toggle(event:Event):void{
		var visible:Boolean=!treedevice.visible;
		treedevice.visible=visible;
		treedevice.includeInLayout=visible;
	}
	
	private function resultHandler(event:ResultEvent):void {
				devicetreeremote.removeEventListener(ResultEvent.RESULT,resultHandler);
		folderList = new XMLList(event.result.toString());
		folderCollection=new XMLList(folderList); 
		treedevice.dataProvider = folderCollection.system;
		systemcode = Registry.lookup("systemcode");
		equipcode = Registry.lookup("equipcode");
		slotdir = Registry.lookup("slotdir");
		//Alert.show(systemcode+"...."+equipcode+"...."+slotdir);
		if(systemcode!=null){
			var rt:RemoteObject = new RemoteObject("devicePanel");
			rt.endpoint = ModelLocator.END_POINT;
			rt.showBusyCursor =true;
			rt.addEventListener(ResultEvent.RESULT, getChildrenNode);
			Application.application.faultEventHandler(rt);
			rt.getDeviceTree(systemcode,"system");
		}
		Registry.unregister("systemcode");
		Registry.unregister("equipcode");
		Registry.unregister("slotdir");
	}
	
	public function DealFault(event:FaultEvent):void {
		Alert.show(event.fault.toString());
		trace(event.fault);
	}
	
	private function deviceiconFun(item:Object):*
	{
		if(item.@isBranch==false)
			return ModelLocator.equipIcon;
		else
			return ModelLocator.systemIcon;
	}

	private function getChildrenNode(event:ResultEvent):void
	{
		var xmllist= treedevice.dataProvider;
		var xml:XMLListCollection = xmllist;
		//Alert.show("getChildrenNode");
		for each (var element:XML in xml) {
			if(element.@id==systemcode ){
				var str:String = event.result as String;
				//Alert.show(str);
				if(str!=null&&str!=""){  
					var child:XMLList= new XMLList(str);
					if(element.children()==null||element.children().length()==0){ 
						element.appendChild(child);
						//
						this.treedevice.expandItem(element,true);
					}
				}
			}
		}
		for each(var element1:XML in xml.elements()){
			if(element1.@id==equipcode){
				this.treedevice.selectedItem=element1;
				if(element1.@checked!="1"){
					element1.@checked="1";
					var rtobj:RemoteObject=new RemoteObject("devicePanel");
					rtobj.endpoint=ModelLocator.END_POINT;
					rtobj.showBusyCursor=true;
					rtobj.addEventListener(ResultEvent.RESULT, getPanelModel);
					Application.application.faultEventHandler(rtobj);
					rtobj.getPanelModel(equipcode);
				}
			}
		}
	}
	
	public  function initParameter():void
	{
		systemcode = Registry.lookup("systemcode");
		equipcode = Registry.lookup("equipcode");
		slotdir = Registry.lookup("slotdir");
		if(systemcode!=null){
			var rt:RemoteObject = new RemoteObject("devicePanel");
			rt.endpoint = ModelLocator.END_POINT;
			rt.showBusyCursor =true;
			rt.addEventListener(ResultEvent.RESULT, getChildrenNode);
			Application.application.faultEventHandler(rt);
			rt.getDeviceTree(systemcode,"system");
		}
	}
	
	private var x_model:String = "";
	private var x_vendor:String = "";

	private function getPanelModel(event:ResultEvent):void{
		//Alert.show("getPanelModel");
		var vm:Array=event.result.toString().split(',');
		x_model = vm[1];
		x_vendor = vm[0];
		var rt:RemoteObject=new RemoteObject("devicePanel");
		rt.endpoint = ModelLocator.END_POINT;
		rt.showBusyCursor = true;
		rt.addEventListener(ResultEvent.RESULT,getModelContextResult);
		Application.application.faultEventHandler(rt);
		if(slotdir==null||slotdir==""){
			slotdir="0";
		}
		rt.getModelContextNew(x_vendor,x_model,slotdir);//获取设备模板内容
	}

	private function getModelContextResult(event:ResultEvent):void{
		var xml:String= event.result.toString();
		var child:checkdevicepanelchild = new checkdevicepanelchild();
		child.x_vendor = x_vendor;
		child.x_model = x_model;
		child.parentObj=this;
		child.label=treedevice.selectedItem.@name;
		child.id="tabpanel"+treedevice.selectedItem.@id;
		child.name="tabpanel"+treedevice.selectedItem.@id;
		child.equipcode = treedevice.selectedItem.@id;
		child.equipname = treedevice.selectedItem.@name;
		child.systemcode=treedevice.selectedItem.@systemcode;
		child.slotdirc = slotdir;
		child.xml=xml;
		child.alarmequip.belongequip=treedevice.selectedItem.@id;
		child.setStyle("tabCloseButtonStyleName","document_icon");
		tabDevices.addChild(child);
		
		var index:int = tabDevices.getChildIndex(child);
		tabDevices.selectedIndex=index;	
	}
	
	
	
	public function treeCheck(e:Event):void{
		try{
		if(e.target is CheckBox){
			//Alert.show("treeCheck");
			if(treedevice.selectedItem.@isBranch==false)
			{
				if(e.target.hasOwnProperty('selected')){
					if(e.target.selected)
					{
						var equipcode:String=treedevice.selectedItem.@id;
						slotdir = "0";
						var rtobj:RemoteObject=new RemoteObject("devicePanel");
						rtobj.endpoint=ModelLocator.END_POINT;
						rtobj.showBusyCursor=true;
						rtobj.addEventListener(ResultEvent.RESULT, getPanelModel);
						Application.application.faultEventHandler(rtobj);
						rtobj.getPanelModel(equipcode);//获取设备厂家和型号
					}else{
						var child1:DisplayObject = tabDevices.getChildByName("tabpanel"+treedevice.selectedItem.@id);
							if(child1 != null)
								tabDevices.removeChild(child1);
						}
					}
				}
			}
}catch(e:Error){
			Alert.show(e.toString());
		}
	}
	
	private function tree_itemClick(evt:ListEvent):void {
	try{
		var item:Object = Tree(evt.currentTarget).selectedItem;
		if (treedevice.dataDescriptor.isBranch(item)) {
			treedevice.expandItem(item, !treedevice.isItemOpen(item), true);
	}
		}catch(e:Error){
			Alert.show(e.message);
		}
	}
	
	//点击树触发事件：
	private function treeChange():void{//treechange->gettree 	
		try{
			//Alert.show("treeChange");
		treedevice.selectedIndex = curIndex;
		if(this.treedevice.selectedItem.@isBranch==true){
			selectedNode = this.treedevice.selectedItem as XML; 
			catalogsid = this.treedevice.selectedItem.@id;
			type="system";
			this.dispatchEvent(new Event(EventNames.CATALOGROW));
	}
		}catch(e:Error){
			Alert.show(e.message);
		}
	}  
	
	//点击树项目取到其下一级子目录  
	private function initEvent():void{
		this.addEventListener(EventNames.CATALOGROW,gettree);
	}  
	private function gettree(e:Event):void{  
	try{
		this.removeEventListener(EventNames.CATALOGROW,gettree);
		var rt_DeviceTree:RemoteObject = new RemoteObject("devicePanel");
		rt_DeviceTree.endpoint = ModelLocator.END_POINT;
		rt_DeviceTree.showBusyCursor =true;
		devicetreeremote.addEventListener(ResultEvent.RESULT, generateDeviceTreeInfo);
		Application.application.faultEventHandler(rt_DeviceTree);
	    devicetreeremote.getDeviceTree(catalogsid,type);//获取传输设备树的数据
		//Alert.show(catalogsid+" "+type);
	}catch(e:Error){
			Alert.show(e.toString());
		}
	}  
	
	private function generateDeviceTreeInfo(event:ResultEvent):void
	{
		try{
			
			var str:String = event.result as String;  
			//Alert.show("generateDeviceTreeInfo"+str);
			if(str!=null&&str!="")
			{  
				var child:XMLList= new XMLList(str);
				if(selectedNode)
				{
				
					if(selectedNode.children()==null||selectedNode.children().length()==0)
					{ 			
						treedevice.expandItem(selectedNode, false, true);
						selectedNode.appendChild(child);
						treedevice.expandItem(selectedNode, true, true);
					}
				}
					
			}
			this.addEventListener(EventNames.CATALOGROW,gettree);
		}catch(e:Error)
		{
			Alert.show(e.message);	
		}  
	}
	
	private function deleteTab(event:flexlib.events.SuperTabEvent):void{
		var child:checkdevicepanelchild = tabDevices.getChildAt(event.tabIndex) as checkdevicepanelchild;
		var equipcode:String = child.equipcode;
		var systemcode:String=child.systemcode;
		var xmllist= treedevice.dataProvider;
		var xml:XMLListCollection = xmllist;
		readXMLCollection(xml,systemcode,equipcode);
	}
	
	private function readXMLCollection(node:XMLListCollection,systemcode:String,equipcode:String):void {
		
		for each (var element:XML in node.elements()) {
			if(element.@id==equipcode ){
				if(element.@systemcode==systemcode){
					element.@checked="0";
				}
				break;
			}
		}
	}
