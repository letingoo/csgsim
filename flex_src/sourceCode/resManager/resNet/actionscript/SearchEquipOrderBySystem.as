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
import flash.events.MouseEvent;
import flash.events.Event;
import common.actionscript.Registry;
import mx.core.Application;
import mx.collections.XMLListCollection;

public var myCallBack:Function;//定义的方法变量
public var mainApp:Object = null;
public var XMLData:XMLList;
private var curIndex:int;

/**
 * 查询条件：设备名称
 */
private var s_sbmc:String;

/**
 * 查询条件：设备所属系统
 */
private var catalogsid:String; 
private var selectedNode:XML;
[Bindable]   
public var folderList:XMLList= new XMLList(); 
[Bindable]   
public var folderCollection:XMLListCollection;
public var page_parent:Object;
public var flag:Boolean=false;

/**
 *初始化进入时查出设备
 * @param event
 * 
 */
protected function initApp(event:FlexEvent):void
{
	this.addEventListener(EventNames.CATALOGROW,gettree);
	var obj:RemoteObject = new RemoteObject("resNodeDwr");
	obj.endpoint = ModelLocator.END_POINT;
	obj.showBusyCursor = true;
	obj.getEquipments("","root","");
	obj.addEventListener(ResultEvent.RESULT,getEquipmentsTree);
}

/**
 * 获取系统树
 */ 
private function gettree(e:Event):void{  
	this.removeEventListener(EventNames.CATALOGROW,gettree);
	var rt_TimeslotTree:RemoteObject = new RemoteObject("resNodeDwr");
	rt_TimeslotTree.endpoint = ModelLocator.END_POINT;
	rt_TimeslotTree.showBusyCursor =true;
	rt_TimeslotTree.getEquipments(catalogsid,"leaf",s_sbmc);//获取树的数据
//	rt_TimeslotTree.addEventListener(ResultEvent.RESULT, generateEquipTreeInfo);
	rt_TimeslotTree.addEventListener(ResultEvent.RESULT,getNextTreeNode);
}  
/**
 *获取系统设备树二级结点(设备编号层) 
 * @param e
 * 
 */
private function getNextTreeNode(e:ResultEvent):void
{
	var str:String = e.result as String;  
	if(str!=null&&str!="")
	{  
		var child:XMLList= new XMLList(str);
		if(selectedNode.children()==null||selectedNode.children().length()==0)
		{ 									 
			selectedNode.appendChild(child);
			equipmentsTree.callLater(openTree,[selectedNode]);
		}
	}
	this.addEventListener(EventNames.CATALOGROW,gettree);//获取树的下层结点
}

private function openTree(xml:XML):void{
	if(equipmentsTree.isItemOpen(xml)){
		equipmentsTree.expandItem(xml,false);
	}
	equipmentsTree.expandItem(xml,true);
}

/**
 * 树的系统节点
 */ 
public function getEquipmentsTree(e:ResultEvent):void{
	folderList = new XMLList(e.result.toString());
	folderCollection=new XMLListCollection(folderList); 
	equipmentsTree.dataProvider = folderCollection;
}

/**
 *设备树选中结点发生改变 
 * 
 */
protected function equipmentsTree_changeHandler():void
{
	equipmentsTree.selectedIndex = curIndex;
	selectedNode = equipmentsTree.selectedItem as XML;
	if(selectedNode.@leaf==false&&(selectedNode.children()==null||selectedNode.children().length()==0))
	{
		catalogsid = selectedNode.@code; 
		this.dispatchEvent(new Event(EventNames.CATALOGROW));
	}
	
}

/**
 * 判断树枝节点是否展开
 */
protected function equipmentsTree_itemClickHandler(e:ListEvent):void
{
	var item:Object = equipmentsTree.selectedItem;
	if (equipmentsTree.dataDescriptor.isBranch(item)) {
		equipmentsTree.expandItem(item, !equipmentsTree.isItemOpen(item), true);
	}
}

/**
 * 双击树叶节点
 */ 
protected function equipmentsTree_doubleClickHandler(event:MouseEvent):void
{ 
	
	try
	{	
		if(equipmentsTree.selectedItem.@isBranch==false &&equipmentsTree.selectedItem.@leaf==true){
			if(flag){
				page_parent.equipname.text= equipmentsTree.selectedItem.@label;
			}else{
				page_parent.cmbEquipment.text= equipmentsTree.selectedItem.@label;
			}
			var obj:Object=new Object;
			obj.name=equipmentsTree.selectedItem.@label;
			obj.id=equipmentsTree.selectedItem.@code;
			myCallBack.call(mainApp,obj);
			this.close();
		}
	}
	catch(e:Error)
	{
		Alert.show(e.toString());
	}
}

/**
 * 关闭当前窗口
 */ 
public function close():void{
	PopUpManager.removePopUp(this);
}

/**
 * 模糊查询：监听查询图标按钮事件
 */ 
private function searchText_clickHandler(event:Event):void{
	this.addEventListener(EventNames.CATALOGROW,gettree);
	s_sbmc=searchText.txt.text;
	var rt:RemoteObject=new RemoteObject("resNodeDwr");
	rt.endpoint=ModelLocator.END_POINT;
	rt.showBusyCursor=true;
	rt.getEquipments("","root",s_sbmc);
	rt.addEventListener(ResultEvent.RESULT,getEquipmentsTree);
	Application.application.faultEventHandler(rt);
	
}
/**
 * 模糊查询：监听enter按钮事件
 */ 
protected function searchText_searchEnterHandler(event:Event):void
{
	this.addEventListener(EventNames.CATALOGROW,gettree);
	s_sbmc=searchText.txt.text;
	var rt:RemoteObject=new RemoteObject("resNodeDwr");
	rt.endpoint=ModelLocator.END_POINT;
	rt.showBusyCursor=true;
	rt.getEquipments("","root",s_sbmc);
	rt.addEventListener(ResultEvent.RESULT,getEquipmentsTree);
	Application.application.faultEventHandler(rt);
}

