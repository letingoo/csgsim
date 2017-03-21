
import common.actionscript.ModelLocator;

import flash.ui.ContextMenuItem;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import sourceCode.resourcesChanges.model.*;

import twaver.DemoUtils;

public var pageIndex:int=0;
public var pageSize:int=50;



public function init():void
{
	serverPagingBar1.dataGrid=updatelist;
	serverPagingBar1.pagingFunction=pagingFunction;
	serverPagingBar1.pageSize=50;

	var contextMenu:ContextMenu=new ContextMenu();
	updatelist.contextMenu=contextMenu;
	updatelist.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, function(e:ContextMenuEvent):void
	{

//		if (updatelist.selectedItems.length > 0)
//		{
//			updatelist.selectedItem=updatelist.selectedItems[0];
//		}
		//定制右键菜单
		var flexVersion:ContextMenuItem=new ContextMenuItem(DemoUtils.FLEX_SDK_VERSION, false, false);
		var playerVersion:ContextMenuItem=new ContextMenuItem(DemoUtils.FLASH_PLAYER_VERSION, false, false);

		if (updatelist.selectedItems.length == 0)
		{ //选中元素个数
			updatelist.contextMenu.customItems=[flexVersion, playerVersion];
		}
		else
		{
			var cmi_ack:ContextMenuItem=new ContextMenuItem("确认", true);
			cmi_ack.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, ackUpdateResources);
			updatelist.contextMenu.hideBuiltInItems();
			updatelist.contextMenu.customItems=[cmi_ack];
		}
	})
}

private function ackUpdateResources(evt:ContextMenuEvent):void
{
	
	var res_type:String=updatelist.selectedItem.res_type;
	var res_code:String=updatelist.selectedItem.res_code;
	var res_ackperson:String=parentApplication.curUser;
	var ackresources:ArrayCollection=new ArrayCollection();
	for(var i:int=0;i<updatelist.selectedItems.length;i++)
	{
		var ackresource:AckResourceModel=new AckResourceModel();
		ackresource.res_type=updatelist.selectedItems[i].res_type;
		ackresource.res_code=updatelist.selectedItems[i].res_code;
		ackresource.res_ackperson=parentApplication.curUser;
		ackresource.sync_status=updatelist.selectedItems[i].sync_status;				
		ackresources.addItem(ackresource);
	}
	var rtobj1:RemoteObject=new RemoteObject("resChangesDao");
	rtobj1.endpoint=ModelLocator.END_POINT;
	rtobj1.showBusyCursor=true;
	rtobj1.addEventListener(ResultEvent.RESULT, afterAckUpdateResources);
	parentApplication.faultEventHandler(rtobj1);
	rtobj1.ackUpdateResources(ackresources);
	

}

private function afterAckUpdateResources(event:ResultEvent):void
{
	Alert.show("确认成功", "提示");
	reLoadData();
}

private function pagingFunction(pageIndex:int, pageSize:int):void
{
	this.pageSize=pageSize;
	this.pageIndex=pageIndex;
	parentDocument.dispatchEvent(new Event("getResult"));
}

public function reLoadData():void
{
	
	serverPagingBar1.navigateButtonClick("firstPage");
}

public function onResult(result:ResultModel):void
{
	serverPagingBar1.orgData=result.orderList;
	serverPagingBar1.totalRecord=result.totalCount;
	serverPagingBar1.dataBind(true);
}