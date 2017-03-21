import common.actionscript.ModelLocator;
import common.actionscript.Registry;
import common.other.events.*;

import flash.events.ContextMenuEvent;
import flash.ui.ContextMenu;

import flexlib.events.SuperTabEvent;

import mx.collections.*;
import mx.controls.Alert;
import mx.controls.CheckBox;
import mx.core.Application;
import mx.events.ListEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

import sourceCode.autoGrid.view.ShowProperty;
import sourceCode.slotGraph.views.checkslotpanelchild;

import twaver.*;

[Embed(source="assets/images/slotgraph/timeslot.png")] //这是图片的相对地址 
[Bindable]
public var Sloticon:Class;

[Bindable]

private var folderList:XMLList=new XMLList();

[Bindable]
/**
 *时隙树数据源 
 */
private var folderCollection:XMLList;
/**
 *树当前选中的结点 
 */
private var selectedNode:XML;
/**
 *当前结点的id 
 */
private var catalogsid:String;
/**
 *当前结点的类型 
 */
private var type:String;
private var curIndex:int;
/**
 *系统编号 
 */
private var systemcode:String;
/**
 *速率 
 */
private var linerate:String;
/**
 *复用段label 
 */
private var linklabel:String;


private var count:int=0;
public function initApp():void
{
	
	systemcode=Registry.lookup("systemcode"); //this.parameters["systemcode"];	
	linerate=Registry.lookup("linerate");
	linklabel=Registry.lookup("label");
	Registry.unregister("systemcode");
	Registry.unregister("linerate");
	Registry.unregister("label");
	timeslottreeremote.getTimeSlotMapTree(" ", "root");
    treetimeslot.contextMenu=new ContextMenu();
	treetimeslot.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, function(e:ContextMenuEvent):void{
		//定制右键菜单
		var flexVersion:ContextMenuItem=new ContextMenuItem(DemoUtils.FLEX_SDK_VERSION, false, false);
		var playerVersion:ContextMenuItem=new ContextMenuItem(DemoUtils.FLASH_PLAYER_VERSION, false, false);
		treetimeslot.contextMenu.hideBuiltInItems();
		if(treetimeslot.selectedItem.@isBranch==false)
		{
			var item1:ContextMenuItem=new ContextMenuItem("查看复用段属性", true);
			item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler_Ocable);
			treetimeslot.contextMenu.customItems=[item1];
		}
		else
		{
			treetimeslot.contextMenu.customItems=[flexVersion,playerVersion];
		}
	});
}

/**
 *复用段属性右键事件 
 * @param e
 * 
 */
private function itemSelectHandler_Ocable(e:ContextMenuEvent):void
{
	var property:ShowProperty = new ShowProperty();
	property.paraValue = treetimeslot.selectedItem.@qtip;
	property.tablename = "VIEW_ENTOPOLINKPROPERTY";
	property.key = "label";
	property.title = treetimeslot.selectedItem.@name+"—复用段属性";
	PopUpManager.addPopUp(property, this, true);
	PopUpManager.centerPopUp(property);
}

private function resultHandler(event:ResultEvent):void
{

	folderList=new XMLList(event.result.toString());
	folderCollection=new XMLList(folderList);
	treetimeslot.dataProvider=folderCollection.system;	;
	if (systemcode != null)
	{

		var rt_TimeslotTree:RemoteObject=new RemoteObject("timeslotMap");
		rt_TimeslotTree.endpoint=ModelLocator.END_POINT;
		rt_TimeslotTree.showBusyCursor=true;
		rt_TimeslotTree.addEventListener(ResultEvent.RESULT, getChildrenNode);
		Application.application.faultEventHandler(rt_TimeslotTree);
		rt_TimeslotTree.getTimeSlotMapTree(systemcode, "system"); //获取传输系统下的速率的数据

	}	


}

/**
 *异步树调用后台代码 
 * @param e
 * 
 */
private function treeChange(e:Event):void
{
	treetimeslot.selectedIndex=curIndex;
	selectedNode=Tree(e.target).selectedItem as XML;
	if (selectedNode.children().length() == 0&&this.treetimeslot.selectedItem.@isBranch == true)
	{
		if (this.treetimeslot.selectedItem.@type == "system")
		{
			
			catalogsid=this.treetimeslot.selectedItem.@id;
			type="system";
			dispatchEvent(new Event(EventNames.CATALOGROW));
		}
		else if(this.treetimeslot.selectedItem.@type == "rate")
		{
			catalogsid=this.treetimeslot.selectedItem.@id + "-" + this.treetimeslot.selectedItem.@systemcode;
			type="rate";
			dispatchEvent(new Event(EventNames.CATALOGROW));
			
		}
	}
}

//点击树项目取到其下一级子目录  
private function initEvent():void
{
	addEventListener(EventNames.CATALOGROW, gettree);
}

/**
 *生成树结点的下一层 
 * @param e
 * 
 */
private function gettree(e:Event):void
{
	removeEventListener(EventNames.CATALOGROW, gettree);
	var rt_TimeslotTree:RemoteObject=new RemoteObject("timeslotMap");
	rt_TimeslotTree.endpoint=ModelLocator.END_POINT;
	rt_TimeslotTree.showBusyCursor=true;

	rt_TimeslotTree.addEventListener(ResultEvent.RESULT, generateRateTreeInfo);
	Application.application.faultEventHandler(rt_TimeslotTree);

	rt_TimeslotTree.getTimeSlotMapTree(catalogsid, type); //获取传输设备树的数据

}

private function getChildrenNode(event:ResultEvent):void
{
	
	
    this.removeEventListener(ResultEvent.RESULT,getChildrenNode);
	var xmllist=treetimeslot.dataProvider;
	var xml:XMLListCollection=xmllist;
	for each (var element:XML in xml)
	{
		if (element.@name == systemcode) //当找到对应的系统结点时
		{
			
			var str:String=event.result as String;
			if (str != null && str != "") //如果当前结点下有孩子
			{
				var child:XMLList=new XMLList(str);
				if (element.children() == null || element.children().length() == 0) //速率这层为空
				{  
					element.appendChild(child); //加载速率这层
					this.treetimeslot.expandItem(element,true);
					for each (var rateitem:XML in element.children())
					{
						
						if (rateitem.@id == linerate)
						{
							selectedNode=rateitem;
							var rt_TimeslotTree:RemoteObject=new RemoteObject("timeslotMap");
							rt_TimeslotTree.endpoint=ModelLocator.END_POINT;
							rt_TimeslotTree.showBusyCursor=true;
							rt_TimeslotTree.getTimeSlotMapTree(linerate + "-" + systemcode, "rate"); //获取传输设备树的数据
							rt_TimeslotTree.addEventListener(ResultEvent.RESULT, generateTopoLinkTreeInfo);
							Application.application.faultEventHandler(rt_TimeslotTree);
							break;
						}
					}

				}
				else
				{
					for each (var rateitem:XML in element.children())
					{
						if (rateitem.@id==linerate)
						{
							
							if (rateitem.children() == null || rateitem.children().length() == 0)
							{ //该处需要添加生成第三层复用段数据
								selectedNode=rateitem;
								var rt_TimeslotTree:RemoteObject=new RemoteObject("timeslotMap");
								rt_TimeslotTree.endpoint=ModelLocator.END_POINT;
								rt_TimeslotTree.showBusyCursor=true;
								rt_TimeslotTree.getTimeSlotMapTree(linerate + "-" + systemcode, "rate"); //获取传输设备树的数据
								rt_TimeslotTree.addEventListener(ResultEvent.RESULT, generateTopoLinkTreeInfo);
								Application.application.faultEventHandler(rt_TimeslotTree);
							}
							else
							{ //如果复用段这一层已经存在，该怎么做

								for each (var toelement:XML in rateitem.children())
								{
									if (toelement.@qtip == linklabel)
									{
										
										this.treetimeslot.selectedItem=toelement;

										if (toelement.@checked != "1")
										{
											toelement.@checked="1";											
											getPanelModel();
										}
										break;
									}
								}
								
							}
							break;
						}
					}
				}
			}
			break;
		}
	}


}

/**
 *处理从后台返回的当前结点的下一层 
 * @param event
 * 
 */
private function generateRateTreeInfo(event:ResultEvent):void
{

	try
	{
		var str:String=event.result.toString();

		if (str != null && str != "")
		{
			var child:XMLList=new XMLList(str);
			if (selectedNode)
			{

				if (selectedNode.children() == null || selectedNode.children().length() == 0)
				{
					this.treetimeslot.expandItem(selectedNode, false, true);
					selectedNode.appendChild(child);
					this.treetimeslot.expandItem(selectedNode, true, true);

				}
			}

		}
		addEventListener(EventNames.CATALOGROW, gettree);
	}
	catch (e:Error)
	{
		Alert.show(e.message);
	}
}


/**
 * 
 * @param event
 * 
 */
public function generateTopoLinkTreeInfo(event:ResultEvent):void
{

	this.removeEventListener(ResultEvent.RESULT, generateTopoLinkTreeInfo);
	
	try
	{
		var str:String=event.result.toString();
		
		if (str != null && str != "")
		{
			var child:XMLList=new XMLList(str);
			if (selectedNode)
			{
				
				if (selectedNode.children() == null || selectedNode.children().length() == 0)
				{
					this.treetimeslot.expandItem(selectedNode, false, true);
					selectedNode.appendChild(child);
					this.treetimeslot.expandItem(selectedNode, true, true);
					for each (var toelement:XML in selectedNode.children())
					{
						if (toelement.@qtip == linklabel)
						{
							
							this.treetimeslot.selectedItem=toelement;
							
							if (toelement.@checked != "1")
							{
								toelement.@checked="1";
								
								getPanelModel();
							}
						}
					}
					
				}
			}
			
		}
		
	}
	catch (e:Error)
	{
		Alert.show(e.message);
	}
	


}

/**
 *添加当前选中的复用段的时隙分布图tab 
 * 
 */
private function getPanelModel():void
{
	
	var times:int;
	if (treetimeslot.selectedItem.@rate == "ZY110604")
	{ //10Gb/s
		times=64;
	}
	else if (treetimeslot.selectedItem.@rate == "ZY110603")
	{ //2.5Gb/s
		times=16;
	}
	else if (treetimeslot.selectedItem.@rate == "ZY110602")
	{ //622Mb/s
		times=4;
	}
	else
	{
		times=1;
	}
	var child:checkslotpanelchild=new checkslotpanelchild();
	child.id="tabpanel" + treetimeslot.selectedItem.@qtip;
	child.name="tabpanel" + treetimeslot.selectedItem.@qtip;
	child.label = treetimeslot.selectedItem.@name;
	child.topolinkid=treetimeslot.selectedItem.@qtip;
	child.size=times;
	child.SlotName=treetimeslot.selectedItem.@name;
	child.setStyle("tabCloseButtonStyleName", "document_icon");

	tabtest.addChild(child);
	var index:int=tabtest.getChildIndex(child);
	tabtest.selectedIndex=index;
}

public function DealFault(event:FaultEvent):void
{
	trace(event.fault);
}


public function treeCheck(e:Event):void
{
	if (e.target is CheckBox)
	{
		if (treetimeslot.selectedItem.@isBranch == false)
		{
			
			if (e.target.selected)
			{
							
					getPanelModel();
				
			}
			else
			{
				
				
				
				var child:DisplayObject=tabtest.getChildByName("tabpanel" + treetimeslot.selectedItem.@qtip);
				if(child!=null)
				{
					tabtest.removeChild(child);
				}
				
			}
			
		}
	}
	
}


/**
 *删除当前的复用段时隙tab 
 * @param event
 * 
 */
private function deleteTab(event:flexlib.events.SuperTabEvent):void
{
	var child:checkslotpanelchild=tabtest.getChildAt(event.tabIndex) as checkslotpanelchild;
	var xmllist=treetimeslot.dataProvider;
	var xml:XMLListCollection=xmllist;

	readXMLCollection(xml, child.topolinkid as String);

}

private function readXMLCollection(node:XMLListCollection, id:String):void
{
	for each (var element:XML in node.elements())
	{
		
		for each (var child:XML in element.elements())
		{
			if (child.@isBranch == false)
			{

				if (child.@qtip == id)
				{
				
					child.@checked="0";
					
					this.treetimeslot.initialize();
				}
			}
		}
	}
}



public function initParameter():void
{
	systemcode=Registry.lookup("systemcode");
	linerate=Registry.lookup("linerate");
	linklabel=Registry.lookup("label");
	Registry.unregister("systemcode");
	Registry.unregister("linerate");
	Registry.unregister("label");

	if (systemcode != null && linerate != null && linklabel != null)
	{


		var rt_TimeslotTree:RemoteObject=new RemoteObject("timeslotMap");
		   rt_TimeslotTree.endpoint=ModelLocator.END_POINT;
		   rt_TimeslotTree.showBusyCursor=true;
		   rt_TimeslotTree.getTimeSlotMapTree(systemcode, "system"); //获取传输设备树的数据
		 rt_TimeslotTree.addEventListener(ResultEvent.RESULT, getChildrenNode);
		 Application.application.faultEventHandler(rt_TimeslotTree);
	}

}


/**
 *点击树结点 
 * @param evt
 * 
 */
private function tree_itemClick(evt:ListEvent):void
{
	var item:Object=Tree(evt.currentTarget).selectedItem;
	if (treetimeslot.dataDescriptor.isBranch(item))
	{
		treetimeslot.expandItem(item, !treetimeslot.isItemOpen(item), true);
	}
}