// ActionScript file
import mx.controls.Alert;
import mx.controls.TextInput;
[Embed('assets/images/file/fileLeaf.gif')]
[Bindable]
public var leafPic:Class;
[Bindable]
private var copyXML:XML = new XML();

import common.actionscript.ModelLocator;
import common.other.events.CustomEvent;
import common.other.events.EventNames;

import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.RemoteObject;
import flash.events.Event;

public var XMLData:XMLList;

[Bindable]   
public var folderCollection:XML;
public var page_parent:Object;

protected function App(event:FlexEvent):void
{
	var obj:RemoteObject = new RemoteObject("regionManager");
	obj.endpoint = ModelLocator.END_POINT;
	obj.showBusyCursor = true;
	obj.getOnlyRegions();
	obj.addEventListener(ResultEvent.RESULT,getRegionTree);
}

public function getRegionTree(e:ResultEvent):void{
	var xml:XML = new XML(e.result);
	copyXML = xml.copy();
	folderCollection = xml.copy();
	regionTree.callLater(expendTree);
}

private function expendTree():void{
	regionTree.expandItem(folderCollection,true);
}

protected function regionTree_doubleClickHandler(event:MouseEvent):void
{
	try
	{
			if(page_parent.titleFlag !=null ){
				 if(page_parent.titleFlag=="光缆段"){
					page_parent.province.text = regionTree.selectedItem.@name;
					page_parent.province.data = new XML("<node datafield='province' value='"+regionTree.selectedItem.@id+"'/>");	
					page_parent.region = regionTree.selectedItem.@id;
				}
				this.close();
			}
	}
	catch(e:Error)
	{
		Alert.show(e.toString());
	}
}
public function close():void{
	PopUpManager.removePopUp(this);
}
private function tree_itemClick(evt:ListEvent):void {
	var item:Object = Tree(evt.currentTarget).selectedItem;
	if (regionTree.dataDescriptor.isBranch(item)) {
		regionTree.expandItem(item, !regionTree.isItemOpen(item), true);
	}
} 
