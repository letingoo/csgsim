// ActionScript file
import com.adobe.serialization.json.JSON;

import common.actionscript.ModelLocator;
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
import mx.events.IndexChangedEvent;
import mx.events.ItemClickEvent;
import mx.events.ListEvent;
import mx.managers.PopUpManager;
import mx.messaging.events.ChannelEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import twaver.*;
import twaver.ElementBox;
import twaver.network.Network;
[Bindable]
private var folderCollection:XMLList;
private var selectedNode:XML;  
private var curIndex:int;
private var type:String;
public var parent_page:Object;
private var systemcode:String;
private var equipcode:String;
private var catalogsid:String;
public var task_ro:RemoteObject = new RemoteObject("taskConfigDao");

public function init():void{
	treeTaskSoure.dataProvider = null;
	task_ro.endpoint = ModelLocator.END_POINT;
	task_ro.showBusyCursor = true;
	task_ro.addEventListener(ResultEvent.RESULT,resultHandler);
	parentApplication.faultEventHandler(task_ro);
	task_ro.getConnectSWTree(" ","root");
	this.addEventListener("toggle",toggle);
}
private function toggle(event:Event):void{
	var visible:Boolean=!treeTaskSoure.visible;
	treeTaskSoure.visible=visible;
	treeTaskSoure.includeInLayout=visible;
}

private function resultHandler(event:ResultEvent):void {
	task_ro.removeEventListener(ResultEvent.RESULT,resultHandler);
	folderCollection = new XMLList(event.result.toString());
	treeTaskSoure.dataProvider = folderCollection.system;
	//				if(systemcode!=null){
	//					task_ro.getConnectSWTree(systemcode,"system");
	//					task_ro.addEventListener(ResultEvent.RESULT, getChildrenNode);
	//				}
}

private function getChildrenNode(event:ResultEvent):void
{
	task_ro.removeEventListener(ResultEvent.RESULT,getChildrenNode);
	var xmllist= treeTaskSoure.dataProvider;
	var xml:XMLListCollection = xmllist;
	
	for each (var element:XML in xml.children()) {
		if(element.@id==systemcode ){
			var str:String = event.result as String; 
			if(str!=null&&str!=""){  
				var child:XMLList= new XMLList(str);
				if(element.children()==null||element.children().length()==0){ 
					element.appendChild(child);
					//
					this.treeTaskSoure.expandItem(element.parent(),true);	
					this.treeTaskSoure.expandItem(element,true);					}
			}
		}
	}
	for each(var element:XML in xml.elements().elements()){
		if(element.@id==equipcode){
			this.treeTaskSoure.selectedItem=element;
			if(element.@checked!="1"){
				//							element.@checked="1";
				//							rtobj.getPanelModel(equipcode);
				//							rtobj.addEventListener(ResultEvent.RESULT, getPanelModel);
			}
		}
	}
}
/**
 * 点击树触发事件。
 * */
private function treeChange():void{ 	
	try{	
		treeTaskSoure.selectedIndex = curIndex;
		if(this.treeTaskSoure.selectedItem.@isBranch==true){
			selectedNode = this.treeTaskSoure.selectedItem as XML; 
			catalogsid = this.treeTaskSoure.selectedItem.@id;
			type="system";
			dispatchEvent(new Event(EventNames.CATALOGROW));
		}
	}catch(e:Error){
		Alert.show(e.message);
	}
} 

private function tree_itemClick(evt:ListEvent):void {
	try{
		var item:Object = Tree(evt.currentTarget).selectedItem;
		if (treeTaskSoure.dataDescriptor.isBranch(item)) {
			treeTaskSoure.expandItem(item, !treeTaskSoure.isItemOpen(item), true);
		}
	}catch(e:Error){
		Alert.show(e.message);
	}
}

public function treeCheck(e:Event):void{

	try
	{
		if(treeTaskSoure.selectedItem.@isBranch==false ){
			
			var parent:TaskTtitle = parent_page as TaskTtitle;
			var equipcode:String=treeTaskSoure.selectedItem.@id;
			var equipname:String=treeTaskSoure.selectedItem.@name;
			parent.con_sources.text = equipname;
			parent.con_sourcesid.text = equipcode;
			close();
			
		}
	}
	catch(e:Error)
	{
		Alert.show(e.toString());
	}
}			

//点击树项目取到其下一级子目录  
private function initEvent():void{  
	
	addEventListener(EventNames.CATALOGROW,gettree);
}  
private function gettree(e:Event):void{  
	try{
		removeEventListener(EventNames.CATALOGROW,gettree);
		task_ro.addEventListener(ResultEvent.RESULT, generateDeviceTreeInfo);
		task_ro.getConnectSWTree(catalogsid,type);//获取传输设备树的数据
		
	}catch(e:Error){
		Alert.show(e.message);
	}
}  

private function generateDeviceTreeInfo(event:ResultEvent):void
{
	task_ro.removeEventListener(ResultEvent.RESULT,generateDeviceTreeInfo);
	try{
		
		var str:String = event.result as String;  
		if(str!=null&&str!="")
		{  
			var child:XMLList= new XMLList(str);
			if(selectedNode)
			{
				
				if(selectedNode.children()==null||selectedNode.children().length()==0)
				{ 			
					treeTaskSoure.expandItem(selectedNode, false, true);
					selectedNode.appendChild(child);
					treeTaskSoure.expandItem(selectedNode, true, true);
				}
			}
			
		}
		addEventListener(EventNames.CATALOGROW,gettree);
	}catch(e:Error)
	{
		Alert.show(e.message);	
	}  
}

private function deviceiconFun(item:Object):*
{
	if(item.@isBranch==false)
		return ModelLocator.equipIcon;
	else
		return ModelLocator.systemIcon;
}

private function close():void  
{  
	PopUpManager.removePopUp(this);  
}