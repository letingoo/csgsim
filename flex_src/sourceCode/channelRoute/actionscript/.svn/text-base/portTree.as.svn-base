	import com.adobe.serialization.json.JSON;
	
	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	import common.other.events.CustomEvent;
	import common.other.events.EventNames;
	
	import mx.collections.*;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.controls.TextInput;
	import mx.controls.Tree;
	import mx.core.DragSource;
	import mx.events.CloseEvent;
	import mx.events.DragEvent;
	import mx.events.IndexChangedEvent;
	import mx.events.ItemClickEvent;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	import mx.messaging.events.ChannelEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	import sourceCode.channelRoute.model.Circuit;
	import sourceCode.channelRoute.views.channelroute;
	import sourceCode.packGraph.views.checkedEquipPack;
	
	import twaver.*;
	import twaver.ElementBox;
	import twaver.core.util.l.l;
	import twaver.network.Network;

	public var equipcode:String;
	public var rate:String;
	private var XMLData:XMLList;
	private var selectedNode:XML; 
	private var curIndex:int;
	private var catalogsid:String;
	private var type:String;
    private var flag1:String;
	private var labeltext:String;
	private var tree_node:String;
	public var flag:String;
    private var stationname:String;
    private var equipname:String;
    public var portAorZ:String;
    public var channel:channelroute;
	[Bindable]
	public var DeviceXML:XMLList; 
	private function init():void
	{
		DeviceXML=new XMLList("<folder state='0' code='ZY03070201' label='传输设备' isBranch='true' leaf='false' type='equiptype' ></folder>");
		
	}
	private function close():void  
	{  
		PopUpManager.removePopUp(this);  
	}
	
	
	
	private function tree_itemClick(evt:ListEvent):void {
		
		var item:Object = Tree(evt.currentTarget).selectedItem;
		if (dTree.dataDescriptor.isBranch(item)) {
			
			dTree.expandItem(item, !dTree.isItemOpen(item), true);
		}
		
	}
	
	private function initEvent():void{  
		addEventListener(EventNames.CATALOGROW,gettree);
	}	
	private function gettree(e:Event):void{ 
		removeEventListener(EventNames.CATALOGROW, gettree);
		var rt_DeviceTree:RemoteObject=new RemoteObject("channelTree");
		rt_DeviceTree.endpoint=ModelLocator.END_POINT;
		rt_DeviceTree.showBusyCursor=true;
		rt_DeviceTree.getTransDevice(catalogsid, type,flag1); //获取传输设备树的数据
		rt_DeviceTree.addEventListener(ResultEvent.RESULT, generateDeviceTreeInfo);
		rt_DeviceTree.addEventListener(FaultEvent.FAULT, faultDeviceTreeInfo);
	}  
	private function generateDeviceTreeInfo(event:ResultEvent):void//对传输设备树展开载事件的处理
	{
		var str:String=event.result as String;
		if (str != null && str != "")
		{
			var child:XMLList=new XMLList(str);
			if (selectedNode.children() == null || selectedNode.children().length() == 0)
			{
				selectedNode.appendChild(child);
				dTree.callLater(openTreeNode, [selectedNode]);
			}
		}
		addEventListener(EventNames.CATALOGROW, gettree);
	}
	private function faultDeviceTreeInfo(event:FaultEvent):void
	{
		Alert.show(event.fault.toString());
	}
	
	private function openTreeNode(xml:XML):void{
		if(dTree.isItemOpen(xml))
			dTree.expandItem(xml,false);
		dTree.expandItem(xml,true);
	}
	
	private function treeChange():void
	{
		dTree.selectedIndex=curIndex;
		selectedNode=dTree.selectedItem as XML;
		if (selectedNode.@leaf == false && (selectedNode.children() == null || selectedNode.children().length() == 0))
		{
			catalogsid=selectedNode.attribute("code");
			type=selectedNode.attribute("type");
			var tr:String = selectedNode.attribute("tree");
			if(type!=null&&type=="equip"){
				equipcode = catalogsid;
				equipname = selectedNode.attribute("label");
				stationname = selectedNode.attribute("stationname");
			}
			if(tr!=null&&tr=="1"){
			type = tr;
			catalogsid = equipcode;
			flag1 = selectedNode.attribute("id");
			}
			if(tr!=null&&tr=="2"){
			type = tr;
			catalogsid = equipcode;
			flag1 = selectedNode.attribute("id");
			}
			dispatchEvent(new Event(EventNames.CATALOGROW));
		}
	}
	private function deviceiconFun(item:Object):* //为传输设备树的结点添加图标
	{
		if (item.@leaf == true)
			return ModelLocator.equipIcon;
		else
			return DemoImages.file;
	}
	private function doubleClickTree(e:Event):void{
		dTree.selectedIndex=curIndex;
		selectedNode=dTree.selectedItem as XML;
		var label:String = selectedNode.attribute("portstandardname");
		var labelid:String = selectedNode.attribute("id");
		if(!dTree.dataDescriptor.isBranch(selectedNode)){
			if(portAorZ!=null&&portAorZ=="A"){
				channel.portserialno1.text = label;
				channel.portA = labelid.replace("port","");
				channel.station1.text = stationname;
				channel.equipCode1.text = equipname;
			}
			if(portAorZ!=null&&portAorZ=="Z"){
				channel.portserialno2.text = label;
				channel.portZ = labelid.replace("port","");
				channel.station2.text = stationname;
				channel.equipCode2.text = equipname;
			}
			MyPopupManager.removePopUp(this);
		}
	}