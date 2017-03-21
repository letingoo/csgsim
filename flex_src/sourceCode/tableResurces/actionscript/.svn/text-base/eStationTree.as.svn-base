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
	obj.getStations(" ","root");
	obj.addEventListener(ResultEvent.RESULT,getStationsTree);
}
private function initEvent():void{  
	addEventListener(EventNames.CATALOGROW,gettree);
}  
private function gettree(e:Event):void{  
	
	var rt_TimeslotTree:RemoteObject = new RemoteObject("netresDao");
	rt_TimeslotTree.endpoint = ModelLocator.END_POINT;
	rt_TimeslotTree.showBusyCursor =true;
	rt_TimeslotTree.getStations(catalogsid,type);//获取树的数据
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
			stationsTree.callLater(openTree,[selectedNode]);
		}
	}  
}
private function openTree(xml:XML):void{
	if(stationsTree.isItemOpen(xml))
		stationsTree.expandItem(xml,false);
	stationsTree.expandItem(xml,true);
}
public function getStationsTree(e:ResultEvent):void{
	folderList = new XMLList(e.result.toString());
	folderCollection=new XMLList(folderList); 
	stationsTree.dataProvider = folderCollection;
}


protected function stationsTree_changeHandler():void
{
	stationsTree.selectedIndex = curIndex;
	if(stationsTree.selectedItem.@isBranch==true && stationsTree.selectedItem.@type=="domain"){
		selectedNode = stationsTree.selectedItem as XML; 
		catalogsid = this.stationsTree.selectedItem.@label;
		type="domain";
		dispatchEvent(new Event(EventNames.CATALOGROW));
	}else if(stationsTree.selectedItem.@isBranch==true && stationsTree.selectedItem.@type=="province"){
		selectedNode = stationsTree.selectedItem as XML; 				
		catalogsid = this.stationsTree.selectedItem.@code;
		type="province";
		dispatchEvent(new Event(EventNames.CATALOGROW));
	}
	else if(stationsTree.selectedItem.@isBranch==true && stationsTree.selectedItem.@type=="city"){
		selectedNode = stationsTree.selectedItem as XML; 				
		catalogsid = this.stationsTree.selectedItem.@code;
		type="city";
		dispatchEvent(new Event(EventNames.CATALOGROW));
	}
}


protected function stationsTree_itemClickHandler(e:ListEvent):void
{
	var item:Object = stationsTree.selectedItem;
	if (stationsTree.dataDescriptor.isBranch(item)) {
		stationsTree.expandItem(item, !stationsTree.isItemOpen(item), true);
	}
}


protected function stationsTree_doubleClickHandler(event:MouseEvent):void
{
	try
	{
		if(stationsTree.selectedItem.@isBranch==false &&stationsTree.selectedItem.@leaf==true){
			if(page_parent.titleFlag !=null ){
				if(page_parent.titleFlag=="光缆段"){
					if(page_parent.stationFlag=="起点"){
						page_parent.a_pointName.text=stationsTree.selectedItem.@label;
						page_parent.a_pointName.data=new XML("<node datafield='stationcode' value='"+stationsTree.selectedItem.@code+"'/>");
						page_parent.a_point = stationsTree.selectedItem.@code;
					}
					if(page_parent.stationFlag=="终点"){
						page_parent.z_pointName.text=stationsTree.selectedItem.@label;
						page_parent.z_pointName.data=new XML("<node datafield='stationcode' value='"+stationsTree.selectedItem.@code+"'/>");
						page_parent.z_point = stationsTree.selectedItem.@code;
					}
				}
				else if(page_parent.titleFlag=="设备"){
					page_parent.txtStationName.text = stationsTree.selectedItem.@label;
					page_parent.txtStationName.data = new XML("<node datafield='stationcode' value='"+stationsTree.selectedItem.@code+"'/>");
					page_parent.stationcode = stationsTree.selectedItem.@code;
					page_parent.txtRoomName.text = "";
					
				}
				else if(page_parent.titleFlag=="交流配电屏"){
					page_parent.txtStationName.text = stationsTree.selectedItem.@label;
					page_parent.txtStationName.data = new XML("<node datafield='stationcode' value='"+stationsTree.selectedItem.@code+"'/>");
//					page_parent.stationcode = stationsTree.selectedItem.@code;					
				}
				else if(page_parent.titleFlag=="开关电源"){
					page_parent.txtStationName.text = stationsTree.selectedItem.@label;
					page_parent.txtStationName.data = new XML("<node datafield='stationcode' value='"+stationsTree.selectedItem.@code+"'/>");
//					page_parent.stationcode = stationsTree.selectedItem.@code;					
				}
				else if(page_parent.titleFlag=="直流分配屏"){
					page_parent.txtStationName.text = stationsTree.selectedItem.@label;
					page_parent.txtStationName.data = new XML("<node datafield='stationcode' value='"+stationsTree.selectedItem.@code+"'/>");
//					page_parent.stationcode = stationsTree.selectedItem.@code;					
				}
				else if(page_parent.titleFlag=="蓄电池组"){
					page_parent.txtStationName.text = stationsTree.selectedItem.@label;
					page_parent.txtStationName.data = new XML("<node datafield='stationcode' value='"+stationsTree.selectedItem.@code+"'/>");
//					page_parent.stationcode = stationsTree.selectedItem.@code;					
				}
				else if(page_parent.titleFlag=="设备供电"){
					page_parent.txtStationName.text = stationsTree.selectedItem.@label;
					page_parent.txtStationName.data = new XML("<node datafield='stationcode' value='"+stationsTree.selectedItem.@code+"'/>");
//					page_parent.stationcode = stationsTree.selectedItem.@code;					
				}
				else if(page_parent.titleFlag=="太阳能"){
					page_parent.txtStationName.text = stationsTree.selectedItem.@label;
					page_parent.txtStationName.data = new XML("<node datafield='stationcode' value='"+stationsTree.selectedItem.@code+"'/>");
//					page_parent.stationcode = stationsTree.selectedItem.@code;					
				}
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
	if (stationsTree.dataDescriptor.isBranch(item)) {
		stationsTree.expandItem(item, !stationsTree.isItemOpen(item), true);
	}
} 
