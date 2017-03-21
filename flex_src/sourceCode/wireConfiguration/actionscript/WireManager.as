import common.actionscript.ModelLocator;
import common.actionscript.Registry;

import flash.display.DisplayObject;
import flash.events.Event;

import flexlib.events.SuperTabEvent;

import mx.collections.XMLListCollection;
import mx.controls.Alert;
import mx.controls.treeClasses.ITreeDataDescriptor;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

import sourceCode.wireConfiguration.views.CheckWireChild;

import twaver.network.Network;


[Bindable]   
 public var folderList:XMLList= new XMLList(); 
[Bindable]
 private  var folderCollection:XMLList;
 
private var stationcode:String;
private var equipshelfcode:String;//机架编号
private var  dmcode:String;//模块编号a
private var isrefresh:Boolean = false;
public function initApp():void  { 
	
	//equipshelfcode机架编号
	//odfodmcode/ddfddmcode odf/ddf配线架的模块编号
	
	//初始化操作
	stationcode=Registry.lookup("stationCode");
	//stationcode="00012000000000000045";
	/*equipshelfcode=Registry.lookup("equipshelfcode");*/
	dmcode=Registry.lookup("moduleCode");
	Registry.unregister("stationCode");
	Registry.unregister("moduleCode");
	wiremgr.getStationInfo(stationcode);	
	wiremgr.addEventListener(ResultEvent.RESULT,generateWireTree);
	wiremgr.removeEventListener(FaultEvent.FAULT,faultGetShelfDM);
}
private function generateWireTree(event:ResultEvent):void
{
	folderList = new XMLList(event.result.toString());
	folderCollection=new XMLList(folderList); 
	treeWire.dataProvider = folderCollection;	
	
	for each(var element:XML in folderList.elements())
	{
		for each(var dmelement:XML in element.children().children())
		{
			if(dmelement.@id==dmcode)
			{
				if(dmelement.@checked!='1')
				{
					dmelement.@checked="1";
				}
				treeWire.validateNow();
				this.treeWire.expandItem(element.parent(),true);
				this.treeWire.expandChildrenOf(element,true);
				if(!isrefresh){
					this.treeWire.selectedItem=dmelement;
					checkedPanel(dmelement);
				}
				else
					isrefresh = false;
				break;
			}
		}
	}
}

private function checkedPanel(item:XML):void{
	 
	var child:CheckWireChild= new CheckWireChild();
	child.label=item.@name;	
	child.id="tabpanel"+item.@id;
	child.name="tabpanel"+item.@name;
	child.moduleName = item.@name;
	child.dmcode=item.@id;
	child.dmtype=item.@type;	
	//child.initApp();
	child.setStyle("tabCloseButtonStyleName","document_icon");
	tabPanel.addChild(child);			
	child.addEventListener("deleteModelComplete",function(event:Event):void{
		tabPanel.removeChild(child);
		deleteTreeChild(item);
	});
	var index:int = tabPanel.getChildIndex(child);
	tabPanel.selectedIndex=index;
}



private function faultGetShelfDM(event:FaultEvent):void
{
	Alert.show(event.toString());
}
private function tree_itemClick(evt:ListEvent):void
{
	var item:Object = Tree(evt.currentTarget).selectedItem;
	if (treeWire.dataDescriptor.isBranch(item)) {
		treeWire.expandItem(item, !treeWire.isItemOpen(item), true);
	}
}

public function treeCheck(e:Event):void
{
	if(e.target.hasOwnProperty('selected'))
	{
		if(e.target.selected)
		{
			if(treeWire.selectedItem.@leaf ==true)
			{
				var xml:XML = new XML();
				xml = treeWire.selectedItem as XML;
				var child:CheckWireChild= new CheckWireChild();
				child.label=treeWire.selectedItem.@name;
				child.id="tabpanel"+treeWire.selectedItem.@id;
				child.name="tabpanel"+treeWire.selectedItem.@name;
				child.dmcode=treeWire.selectedItem.@id;
				this.dmcode = treeWire.selectedItem.@id;
				child.dmtype=treeWire.selectedItem.@type;
				//child.initApp();
				child.setStyle("tabCloseButtonStyleName","document_icon");
				tabPanel.addChild(child);							
				var index:int = tabPanel.getChildIndex(child);
				tabPanel.selectedIndex=index;
				child.addEventListener("deleteModelComplete",function(event:Event):void{
					tabPanel.removeChild(child);
					deleteTreeChild(xml);
				});
			}
		}
		else
		{
			var child1:DisplayObject = tabPanel.getChildByName("tabpanel"+treeWire.selectedItem.@name);
			tabPanel.removeChild(child1);
		}
	}
	
}


/**
 * 删除树节点
 */ 
private function deleteTreeChild(xml:XML):void{
	var parent:XML = xml.parent();
	if(parent.elements().length() <=1)
	{
		xml = parent;
		parent = parent.parent();
	}
	for each(var element:XML in parent.elements()){
		if(element.@id == xml.@id){
			treeWire.dataDescriptor.removeChildAt(parent,xml,xml.childIndex(),treeWire.dataProvider);
		}
	}	
}


private function deleteTab(event:flexlib.events.SuperTabEvent):void{
	var child = tabPanel.getChildAt(event.tabIndex);
	var name:String = child.label;
	var xmllist= treeWire.dataProvider;
	var xml:XMLListCollection = xmllist;

	readXMLCollection(xml,name);
	
}
private function readXMLCollection(node:XMLListCollection,name:String):void {
	for each (var element:XML in node.elements()) {		
		for each(var child:XML in element.elements().elements()){
			if(child.@leaf==true){
				if(child.@name==name){
					
					child.@checked = "0";
				}
			}
		}
	}
}