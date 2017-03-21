// ActionScript file
import mx.controls.Alert;
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
public var elabel:String;
public var isShowAllRoom:Boolean = false;
protected function App(event:FlexEvent):void
{
	var obj:RemoteObject = new RemoteObject("netresDao");
	obj.endpoint = ModelLocator.END_POINT;
	obj.showBusyCursor = true;
	if(isShowAllRoom){
	    obj.getStationRoomsInRoomTree("",elabel);
	}else{
	    obj.getStationRoomsInRoomTree(page_parent.stationcode,elabel);
	}
	obj.addEventListener(ResultEvent.RESULT,getstationsRoomTree);
}
private function initEvent():void{  
	addEventListener(EventNames.CATALOGROW,gettree);
}  
private function gettree(e:Event):void{  
	
	var rt_TimeslotTree:RemoteObject = new RemoteObject("netresDao");
	rt_TimeslotTree.endpoint = ModelLocator.END_POINT;
	rt_TimeslotTree.showBusyCursor =true;
	rt_TimeslotTree.getStationRooms(catalogsid,type);//获取树的数据
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
			stationsRoomTree.callLater(openTree,[selectedNode]);
		}
	}  
}
private function openTree(xml:XML):void{
	if(stationsRoomTree.isItemOpen(xml))
		stationsRoomTree.expandItem(xml,false);
	stationsRoomTree.expandItem(xml,true);
}
public function getstationsRoomTree(e:ResultEvent):void{
	folderList = new XMLList(e.result.toString());
	folderCollection=new XMLList(folderList); 
	stationsRoomTree.dataProvider = folderCollection;
}


protected function stationsRoomTree_changeHandler():void
{
	stationsRoomTree.selectedIndex = curIndex;
	if(stationsRoomTree.selectedItem.@isBranch==true && stationsRoomTree.selectedItem.@type=="domainname"){
		selectedNode = stationsRoomTree.selectedItem as XML; 
		catalogsid = this.stationsRoomTree.selectedItem.@label;
		type="system";
		dispatchEvent(new Event(EventNames.CATALOGROW));
	}else if(stationsRoomTree.selectedItem.@isBranch==true && stationsRoomTree.selectedItem.@node=="2"){
		selectedNode = stationsRoomTree.selectedItem as XML; 				
		catalogsid = this.stationsRoomTree.selectedItem.@code;
		type="rate";
		dispatchEvent(new Event(EventNames.CATALOGROW));
	}else if(stationsRoomTree.selectedItem.@isBranch==true && stationsRoomTree.selectedItem.@node=="3"){
		selectedNode = stationsRoomTree.selectedItem as XML; 				
		catalogsid = this.stationsRoomTree.selectedItem.@code;
		type="room";
		dispatchEvent(new Event(EventNames.CATALOGROW));
	}
}


protected function stationsRoomTree_itemClickHandler(e:ListEvent):void
{
	var item:Object = stationsRoomTree.selectedItem;
	if (stationsRoomTree.dataDescriptor.isBranch(item)) {
		stationsRoomTree.expandItem(item, !stationsRoomTree.isItemOpen(item), true);
	}
}


protected function stationsRoomTree_doubleClickHandler(event:MouseEvent):void
{
	if(stationsRoomTree.selectedItem.@isBranch==false &&stationsRoomTree.selectedItem.@leaf==true){
		if(page_parent.titleFlag !=null && page_parent.titleFlag=="光缆段"){
			if(page_parent.stationFlag=="起点"){
				page_parent.a_pointName.text = stationsRoomTree.selectedItem.@label;
				page_parent.a_pointName.data = new XML("<node datafield='roomcode' value='"+stationsRoomTree.selectedItem.@code+"'/>");
				page_parent.a_point = stationsRoomTree.selectedItem.@code;
			}
			if(page_parent.stationFlag=="终点"){
				page_parent.z_pointName.text = stationsRoomTree.selectedItem.@label;
				page_parent.z_pointName.data = new XML("<node datafield='roomcode' value='"+stationsRoomTree.selectedItem.@code+"'/>");
				page_parent.z_point = stationsRoomTree.selectedItem.@code;
			}
			this.close();
			return ;
		}
		page_parent.txtRoomName.text = stationsRoomTree.selectedItem.@label;
		page_parent.roomcode = stationsRoomTree.selectedItem.@code;
		page_parent.txtRoomName.data = new XML("<node datafield='roomcode' value='"+stationsRoomTree.selectedItem.@code+"'/>");
		this.close();
	}
}
public function close():void{
	PopUpManager.removePopUp(this);
}
private function tree_itemClick(evt:ListEvent):void {
	var item:Object = Tree(evt.currentTarget).selectedItem;
	if (stationsRoomTree.dataDescriptor.isBranch(item)) {
		stationsRoomTree.expandItem(item, !stationsRoomTree.isItemOpen(item), true);
	}
} 