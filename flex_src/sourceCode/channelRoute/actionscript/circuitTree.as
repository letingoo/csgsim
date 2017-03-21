	import com.adobe.serialization.json.JSON;
	
	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	import common.actionscript.Registry;
	import common.other.events.CustomEvent;
	import common.other.events.EventNames;
	
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	
	import mx.collections.*;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.controls.TextInput;
	import mx.controls.Tree;
	import mx.core.Application;
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
	import sourceCode.channelRoute.views.relatecircuit;
	import sourceCode.packGraph.views.checkedEquipPack;
	
	import twaver.*;
	import twaver.ElementBox;
	import twaver.core.util.l.l;
	import twaver.network.Network;
	[Bindable]
    public var folderCollection:XMLListCollection;
	[Embed(source="assets/images/device/equipment.png")]
	public static const equipIcon:Class;
    public var relate:relatecircuit;
	private function init():void
	{
		var remote:RemoteObject = new RemoteObject("channelTree");
		remote.endpoint = ModelLocator.END_POINT;
		remote.showBusyCursor = true;
		remote.TreeRouteAction();
		remote.addEventListener(ResultEvent.RESULT,function(event:ResultEvent){
			if(event.result!=null){
			folderCollection=new XMLListCollection(new XMLList(event.result.toString())); 
			channelTree.dataProvider = folderCollection;
			}
		});
		channelTree.contextMenu = new ContextMenu();
		channelTree.contextMenu = new ContextMenu();
		channelTree.contextMenu.hideBuiltInItems();
		
		channelTree.contextMenu.customItems = [];
		channelTree.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,menuSelectHandler);
	}
	private function close():void  
	{  
		PopUpManager.removePopUp(this);  
	}
	
	private function menuSelectHandler(event:ContextMenuEvent):void//菜单选择处理函数
	{
		var menu:ContextMenuItem = new ContextMenuItem("方式信息");
		menu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e:ContextMenuEvent){
			var circuitcode:String = channelTree.selectedItem.@label;
			Registry.register("para_circuitcode",circuitcode);
			Application.application.openModel("方式信息",false);
		}); 
		if(channelTree.selectedItem!=null&&channelTree.selectedItem.@leaf=='true')
		{
			channelTree.contextMenu.customItems = [menu];
		}else{
		    channelTree.contextMenu.customItems = [];
		}
		
	}
	
	private function tree_itemClick(evt:ListEvent):void {
		
		var item:Object = Tree(evt.currentTarget).selectedItem;
		if (channelTree.dataDescriptor.isBranch(item)) {
			
			channelTree.expandItem(item, !channelTree.isItemOpen(item), true);
		}
		
	}
	
    private function clickTree():void{
		if(channelTree.selectedItem!=null&&channelTree.selectedItem.@leaf=='true'){
			relate.copy_circuitcode = channelTree.selectedItem.@label;
			relate.circuitCopy();
			relate.isReplace = true;
			MyPopupManager.removePopUp(this);
		}
	}

	private function deviceiconFun(item:Object):*
	{
		if(item.@leaf==true)
			return equipIcon;
		else
			return DemoImages.file;
	}
	
	private function openTreeNode(xml:XML):void{
		if(channelTree.isItemOpen(xml))
			channelTree.expandItem(xml,false);
		channelTree.expandItem(xml,true);
	}
	
	
	