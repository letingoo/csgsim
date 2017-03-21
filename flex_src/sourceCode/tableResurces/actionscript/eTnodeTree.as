// ActionScript file
import mx.controls.Alert;
import mx.controls.TextInput;
[Embed('assets/images/file/fileLeaf.gif')]
[Bindable]
public var leafPic:Class;

import common.actionscript.ModelLocator;
import common.other.events.CustomEvent;
import common.other.events.EventNames;

import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.RemoteObject;

public var XMLData:XMLList;
private var curIndex:int;
private var catalogsid:String; 
private var type:String;
private var selectedNode:XML;
[Bindable]   
public var folderList:XMLList= new XMLList(); 

[Bindable]   
public var folderCollection:XMLList;
public var page_parent:Object;
protected function App(event:FlexEvent):void
{
	var obj:RemoteObject = new RemoteObject("netresDao");
	obj.endpoint = ModelLocator.END_POINT;
	obj.showBusyCursor = true;
	obj.getTnodes(" ","root");
	obj.addEventListener(ResultEvent.RESULT,gettNodeTree);
}
private function initEvent():void{  
	addEventListener(EventNames.CATALOGROW,gettree);
}  
private function gettree(e:Event):void{  
	
	var rt_TimeslotTree:RemoteObject = new RemoteObject("netresDao");
	rt_TimeslotTree.endpoint = ModelLocator.END_POINT;
	rt_TimeslotTree.showBusyCursor =true;
	rt_TimeslotTree.getTnodes(catalogsid,type);//获取树的数据
	rt_TimeslotTree.addEventListener(ResultEvent.RESULT, generateRateTreeInfo);
}  
private function generateRateTreeInfo(event:ResultEvent):void
{
	var str:String = event.result as String;  
	
	if(str!=null&&str!="")
	{  
		var child:XMLList= new XMLList(str);
		if(selectedNode.children()==null||selectedNode.children().length()==0)
		{ 	
			selectedNode.appendChild(child);
			tNodeTree.callLater(openTree,[selectedNode]);
		}
	}  
}
private function openTree(xml:XML):void{
	if(tNodeTree.isItemOpen(xml))
		tNodeTree.expandItem(xml,false);
	tNodeTree.expandItem(xml,true);
}
public function gettNodeTree(e:ResultEvent):void{
	folderList = new XMLList(e.result.toString());
	folderCollection=new XMLList(folderList); 
	tNodeTree.dataProvider = folderCollection;
}


protected function tNodeTree_changeHandler():void
{
	//				tNodeTree.selectedIndex = curIndex;
	//				if(tNodeTree.selectedItem.@isBranch==true && tNodeTree.selectedItem.@type=="domainname"){
	//					selectedNode = tNodeTree.selectedItem as XML; 
	//					catalogsid = this.tNodeTree.selectedItem.@label;
	//					type="system";
	//					dispatchEvent(new Event(EventNames.CATALOGROW));
	//				}else if(tNodeTree.selectedItem.@isBranch==true && tNodeTree.selectedItem.@node=="2"){
	//					selectedNode = tNodeTree.selectedItem as XML; 				
	//					catalogsid = this.tNodeTree.selectedItem.@code;
	//					type="rate";
	//					dispatchEvent(new Event(EventNames.CATALOGROW));
	//				}
}


protected function tNodeTree_itemClickHandler(e:ListEvent):void
{
	var item:Object = tNodeTree.selectedItem;
	if (tNodeTree.dataDescriptor.isBranch(item)) {
		tNodeTree.expandItem(item, !tNodeTree.isItemOpen(item), true);
	}
}


protected function tNodeTree_doubleClickHandler(event:MouseEvent):void
{
	try
	{
		if(tNodeTree.selectedItem.@isBranch==false &&tNodeTree.selectedItem.@leaf==true){
			if(page_parent.titleFlag !=null ){
				if(page_parent.titleFlag=="光缆段"){
					if(page_parent.stationFlag=="起点"){
						page_parent.a_pointName.text=tNodeTree.selectedItem.@label;
						page_parent.a_pointName.data=new XML("<node datafield='tnodecode' value='"+tNodeTree.selectedItem.@code+"'/>");
						page_parent.a_point = tNodeTree.selectedItem.@code;
					}
					if(page_parent.stationFlag=="终点"){
						page_parent.z_pointName.text=tNodeTree.selectedItem.@label;
						page_parent.z_pointName.data=new XML("<node datafield='tnodecode' value='"+tNodeTree.selectedItem.@code+"'/>");
						page_parent.z_point = tNodeTree.selectedItem.@code;
					}
				}
				//							else if(page_parent.titleFlag=="复用设备"){
				//								page_parent.txtStationName.text = tNodeTree.selectedItem.@label;
				//								page_parent.txtStationName.data = new XML("<node datafield='stationcode' value='"+tNodeTree.selectedItem.@code+"'/>");
				//								page_parent.stationcode = tNodeTree.selectedItem.@code;
				//								page_parent.txtRoomName.text = "";
				//								
				//							}
				this.close();
			}
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
	if (tNodeTree.dataDescriptor.isBranch(item)) {
		tNodeTree.expandItem(item, !tNodeTree.isItemOpen(item), true);
	}
} 