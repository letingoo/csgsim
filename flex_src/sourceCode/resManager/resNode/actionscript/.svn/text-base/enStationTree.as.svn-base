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
private var catalogsid:String; 
private var catalogsid1:String;
private var type:String;
private var type1:String;
public var textId:String;
private var selectedNode:XML;
private var selectedNode1:XML;
[Bindable]   
public var folderList:XMLList= new XMLList(); 
[Bindable]   
public var folderCollection:XMLList;
[Bindable]  
public var folderCollection1:XMLList;
public var page_parent:Object;
public var s_sbmc:String="";
public var searchtex:String="";
/**
 *初始化进入时查出局站
 * @param event
 * 
 */
protected function App(event:FlexEvent):void
{
	var obj:RemoteObject = new RemoteObject("resNodeDwr");
	obj.endpoint = ModelLocator.END_POINT;
	obj.showBusyCursor = true;
//	obj.getStations(" ","root");
	obj.getStations("地区","system",s_sbmc);
	obj.addEventListener(ResultEvent.RESULT,getStationsTree);
}
/**
 *初始化监听 
 * 
 */
private function initEvent():void{  
	addEventListener(EventNames.CATALOGROW,gettree);
	addEventListener("clickTree1",gettree1);
}  

private function gettree(e:Event):void{  
	
	var rt_TimeslotTree:RemoteObject = new RemoteObject("resNodeDwr");
	rt_TimeslotTree.endpoint = ModelLocator.END_POINT;
	rt_TimeslotTree.showBusyCursor =true;
	rt_TimeslotTree.getStations(catalogsid,type,s_sbmc);//获取树的数据
	rt_TimeslotTree.addEventListener(ResultEvent.RESULT, generateRateTreeInfo);
}  
private function gettree1(e:Event):void{  
	removeEventListener("clickTree1",gettree1);
	var rt_TimeslotTree:RemoteObject = new RemoteObject("resNodeDwr");
	rt_TimeslotTree.endpoint = ModelLocator.END_POINT;
	rt_TimeslotTree.showBusyCursor =true;
	rt_TimeslotTree.getDomainForVolt(catalogsid1,type1,searchtex);//获取树的数据
	rt_TimeslotTree.addEventListener(ResultEvent.RESULT, generateRateTreeInfo1);
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
private function generateRateTreeInfo1(event:ResultEvent):void
{
	var str:String = event.result as String;  
	if(str!=null&&str!="")
	{  
		var child:XMLList= new XMLList(str);
		if(selectedNode1.children()==null||selectedNode1.children().length()==0)
		{ 	
			stationsTree1.expandItem(selectedNode1,false);
			selectedNode1.folder += child;
			stationsTree1.callLater(expandTreeNode1,[selectedNode1]);
		}
	} 
	addEventListener('clickTree1',gettree1);
}

private function expandTreeNode1(xml:XML):void{
	stationsTree1.expandItem(selectedNode1,true);
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
	if(stationsTree.selectedItem.@isBranch==true && stationsTree.selectedItem.@type=="domainname"){
		selectedNode = stationsTree.selectedItem as XML; 
		catalogsid = this.stationsTree.selectedItem.@label;
		type="system";
		dispatchEvent(new Event(EventNames.CATALOGROW));
	}else if(stationsTree.selectedItem.@isBranch==true && stationsTree.selectedItem.@node=="2"){
		selectedNode = stationsTree.selectedItem as XML; 				
		catalogsid = this.stationsTree.selectedItem.@code;
		type="rate";
		dispatchEvent(new Event(EventNames.CATALOGROW));
	}
}
/**
 *选择局站 
 * 
 */
private function stationsTree1_changeHandler():void{
	selectedNode1 = stationsTree1.selectedItem as XML;
	if(selectedNode1!=null&&"true"!=selectedNode1.@leaf )
	{		
		type1= selectedNode1.@type;
		catalogsid1 = selectedNode1.@code;
		dispatchEvent(new Event("clickTree1"));

	}
}

protected function stationsTree_itemClickHandler(e:ListEvent):void
{
	var item:Object = stationsTree.selectedItem;
	if (stationsTree.dataDescriptor.isBranch(item)) {
		stationsTree.expandItem(item, !stationsTree.isItemOpen(item), true);
	}
}

private function getAProvinceByStaioncode(code:String):void{
	var rt_TimeslotTree:RemoteObject = new RemoteObject("resNodeDwr");
	rt_TimeslotTree.endpoint = ModelLocator.END_POINT;
	rt_TimeslotTree.showBusyCursor =true;
	rt_TimeslotTree.getAProvinceByStaioncode(code);//获取树的数据
	rt_TimeslotTree.addEventListener(ResultEvent.RESULT, getAProvinceByStaioncodeHandler);
}

private function getAProvinceByStaioncodeHandler(event:ResultEvent):void{
	if(event.result!=null){
		(page_parent.getElementById("A_AREA",page_parent.propertyList) as mx.controls.TextInput).text=event.result.toString();
	}
}

private function getZProvinceByStaioncode(code:String):void{
	var rt_TimeslotTree:RemoteObject = new RemoteObject("resNodeDwr");
	rt_TimeslotTree.endpoint = ModelLocator.END_POINT;
	rt_TimeslotTree.showBusyCursor =true;
	rt_TimeslotTree.getAProvinceByStaioncode(code);//获取树的数据
	rt_TimeslotTree.addEventListener(ResultEvent.RESULT, getZProvinceByStaioncodeHandler);
}

private function getZProvinceByStaioncodeHandler(event:ResultEvent):void{
	if(event.result!=null){
		(page_parent.getElementById("Z_AREA",page_parent.propertyList) as mx.controls.TextInput).text=event.result.toString();
	}
}

protected function stationsTree_doubleClickHandler(event:MouseEvent):void
{ 
	
	try
	{	
		if(tabTree.selectedIndex == 0){
			if(stationsTree.selectedItem.@isBranch==false &&stationsTree.selectedItem.@leaf==true){
				if(page_parent.title!=null){
					if(page_parent.title=="光缆添加"||page_parent.title=="光缆修改"){
						if(textId=="STATION_A_NAME"){
							(page_parent.getElementById("STATION_A_NAME",page_parent.propertyList) as mx.controls.TextInput).text= stationsTree.selectedItem.@label;
							var code:String = stationsTree.selectedItem.@code;
							(page_parent.getElementById("STATION_A",page_parent.propertyList) as mx.controls.TextInput).text=stationsTree.selectedItem.@code;
							//根据站点编码查询站点地区
							getAProvinceByStaioncode(code);
						}else if(textId=="STATION_Z_NAME"){
							(page_parent.getElementById("STATION_Z_NAME",page_parent.propertyList) as mx.controls.TextInput).text= stationsTree.selectedItem.@label;
							(page_parent.getElementById("STATION_Z",page_parent.propertyList) as mx.controls.TextInput).text=stationsTree.selectedItem.@code;
							var code:String = stationsTree.selectedItem.@code;
							getZProvinceByStaioncode(code);
						}
						
						
					}
					if(page_parent.title=="添加"||page_parent.title=="修改"||page_parent.title=="查询"){
						if(textId=="station1"){
							(page_parent.station1).text= stationsTree.selectedItem.@label;
						}
						else if(textId=="station2"){
							(page_parent.station2).text= stationsTree.selectedItem.@label;
						}
						else if(textId=="STATIONCODE"){
							(page_parent.getElementById("STATIONNAME",page_parent.propertyList) as mx.controls.TextInput).text= stationsTree.selectedItem.@label;
							(page_parent.getElementById("STATIONCODE",page_parent.propertyList) as mx.controls.TextInput).text=stationsTree.selectedItem.@code;
						}else if(textId=="cmbStationA"){
							(page_parent.cmbStationA).text= stationsTree.selectedItem.@label;
						}else if(textId=="cmbStationZ"){
							(page_parent.cmbStationZ).text= stationsTree.selectedItem.@label;
						}
					}
					this.close();
				}
				
				
			}
		}else{
			if(stationsTree1.selectedItem.@isBranch==false &&stationsTree1.selectedItem.@leaf==true){
				if(page_parent.title!=null){
					if(page_parent.title=="光缆添加"||page_parent.title=="光缆修改"){
						if(textId=="STATION_A_NAME"){
							(page_parent.getElementById("STATION_A_NAME",page_parent.propertyList) as mx.controls.TextInput).text= stationsTree1.selectedItem.@label;
							(page_parent.getElementById("STATION_A",page_parent.propertyList) as mx.controls.TextInput).text=stationsTree1.selectedItem.@code;
							var code:String = stationsTree1.selectedItem.@code;
							getAProvinceByStaioncode(code);
						}else if(textId=="STATION_Z_NAME"){
							(page_parent.getElementById("STATION_Z_NAME",page_parent.propertyList) as mx.controls.TextInput).text= stationsTree1.selectedItem.@label;
							(page_parent.getElementById("STATION_Z",page_parent.propertyList) as mx.controls.TextInput).text=stationsTree1.selectedItem.@code;
							var code:String = stationsTree1.selectedItem.@code;
							getZProvinceByStaioncode(code);
						}
						
						
					}
					if(page_parent.title=="添加"||page_parent.title=="修改"||page_parent.title=="查询"){
						if(textId=="station1"){
							(page_parent.station1).text= stationsTree1.selectedItem.@label;
						}
						else if(textId=="station2"){
							(page_parent.station2).text= stationsTree1.selectedItem.@label;
						}
						else if(textId=="STATIONCODE"){
							(page_parent.getElementById("STATIONNAME",page_parent.propertyList) as mx.controls.TextInput).text= stationsTree1.selectedItem.@label;
							(page_parent.getElementById("STATIONCODE",page_parent.propertyList) as mx.controls.TextInput).text=stationsTree1.selectedItem.@code;
						}else if(textId=="cmbStationA"){
							(page_parent.cmbStationA).text= stationsTree1.selectedItem.@label;
						}else if(textId=="cmbStationZ"){
							(page_parent.cmbStationZ).text= stationsTree1.selectedItem.@label;
						}
					}
					this.close();
				}
				
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
private function changeItems(event:IndexChangedEvent):void{
	var flag : String = tabTree.getTabAt(tabTree.selectedIndex).label;	
	if((stationsTree1.dataProvider==null||stationsTree1.dataProvider=="")&&flag.indexOf("电压等级")!=-1){
		var rt:RemoteObject = new RemoteObject("resNodeDwr");
		rt.endpoint = ModelLocator.END_POINT;
		rt.getDomainForVolt(" ","root",searchtex);
		rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
			folderCollection1= new XMLList(event.result.toString()); 
			stationsTree1.dataProvider = folderCollection1;
		});
	}
}


/**
 * 模糊查询：监听查询图标按钮事件
 */ 
private function stationsTree_clickHandler(event:Event):void{
	this.addEventListener(EventNames.CATALOGROW,gettree);
	s_sbmc=searchText.txt.text;
	var rt:RemoteObject=new RemoteObject("resNodeDwr");
	rt.endpoint=ModelLocator.END_POINT;
	rt.showBusyCursor=true;
	rt.getStations("地区","system",s_sbmc);
	rt.addEventListener(ResultEvent.RESULT,getStationsTree);
	
}

/**
 * 模糊查询：监听查询图标按钮事件
 */ 
private function stationsTree1_clickHandler(event:Event):void{
	this.addEventListener("clickTree1",gettree1);
	searchtex=searchText1.txt.text;
	var rt:RemoteObject=new RemoteObject("resNodeDwr");
	rt.endpoint=ModelLocator.END_POINT;
	rt.showBusyCursor=true;
	rt.getDomainForVolt(" ","root",searchtex);
	rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
		folderCollection1= new XMLList(event.result.toString()); 
		stationsTree1.dataProvider = folderCollection1;
	});
	
}
