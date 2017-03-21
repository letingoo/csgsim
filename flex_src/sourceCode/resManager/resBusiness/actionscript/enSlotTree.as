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
import mx.events.IndexChangedEvent;
import mx.events.TreeEvent;

public var XMLData:XMLList;
private var curIndex:int;
private var type:String;
private var catalogsid:String;
private var selectedNode:XML;
[Bindable]   
public var folderList:XMLList= new XMLList(); 
[Bindable]   
public var folderCollection:XMLList;
public var page_parent:Object;
public var s_sbmc:String="";//查询条件
public var equiplogicport:String="";
public var textId:String="";
/**
 *初始化进入时查出局站
 * @param event
 * 
 */
protected function App(event:FlexEvent):void
{
	var obj:RemoteObject = new RemoteObject("resBusinessDwr");
	obj.endpoint = ModelLocator.END_POINT;
	obj.showBusyCursor = true;
	obj.getSlots(equiplogicport,"","VC4",s_sbmc);//查找端口下的VC4,
	obj.addEventListener(ResultEvent.RESULT,getStationsTree);
}
/**
 *初始化监听 
 * 
 */
private function initEvent():void{  
	addEventListener(EventNames.CATALOGROW,gettree);
}  

private function gettree(e:Event):void{  
	
	var rt_TimeslotTree:RemoteObject = new RemoteObject("resBusinessDwr");
	rt_TimeslotTree.endpoint = ModelLocator.END_POINT;
	rt_TimeslotTree.showBusyCursor =true;
	rt_TimeslotTree.getSlots(equiplogicport,catalogsid,type,s_sbmc);//获取树的数据
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
	if(stationsTree.selectedItem.@isBranch==true && stationsTree.selectedItem.@node=="2"){
		selectedNode = stationsTree.selectedItem as XML; 				
		catalogsid = this.stationsTree.selectedItem.@code;
		type="VC12";
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
			if(page_parent.title!=null){
				if(textId=="slot1"){
					page_parent.slot1.text= "VC4:"+catalogsid+"_"+"VC12:"+stationsTree.selectedItem.@code;
				}else if(textId=="slot2"){
					page_parent.slot2.text="VC4:"+ catalogsid+"_"+"VC12:"+ stationsTree.selectedItem.@code;
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

/**
 * 模糊查询：监听查询图标按钮事件
 */ 
//private function stationsTree_clickHandler(event:Event):void{
//	this.addEventListener(EventNames.CATALOGROW,gettree);
//	s_sbmc=searchText.txt.text;
//	var rt:RemoteObject=new RemoteObject("resBusinessDwr");
//	rt.endpoint=ModelLocator.END_POINT;
//	rt.showBusyCursor=true;
//	rt.getSlots(equiplogicport,"","VC4",s_sbmc);
//	rt.addEventListener(ResultEvent.RESULT,getStationsTree);
//	
//}


