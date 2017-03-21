	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import sourceCode.faultSimulation.model.OperateListModel;
	import sourceCode.faultSimulation.titles.WinFuncFaultType;
	
	[Bindable]
	public var _treeXML:XML;
	
	[Bindable]
	private var copyXML:XML = new XML();
	private var contextMeau:ContextMenu;
	private var lastRollIndex:int;
	private var winFuncFaultType:WinFuncFaultType;
	private var update_itemMeau:ContextMenuItem;
	private var add_itemMeau:ContextMenuItem;
	private var del_itemMeau:ContextMenuItem;
	
	private function init():void{
		update_itemMeau = new ContextMenuItem("修 改");
		update_itemMeau.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,updateSelectHandler);
		add_itemMeau = new ContextMenuItem("添 加");
		add_itemMeau.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,addSelectHandler);
		del_itemMeau = new ContextMenuItem("删 除");
		del_itemMeau.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,delSelectHandler);
		
		contextMeau = new ContextMenu();
		contextMeau.hideBuiltInItems();
		contextMeau.customItems = [update_itemMeau,add_itemMeau,del_itemMeau];
		contextMeau.addEventListener(ContextMenuEvent.MENU_SELECT,meauSelectHandler);
		treeFuncFault.contextMenu = contextMeau;
		
		
		roFuncMgr.getAllFaultFunctions();
		
	}
	
	private function expendTree():void{
		treeFuncFault.expandItem(_treeXML,true);
	}
	
	private function refreshDataHandler(event:Event):void{
		roFuncMgr.getAllFaultFunctions();
	}
	
	private function iconFunction(item:Object):*{ 
		return ModelLocator.funcIcon;
	}
	
	private function funcResult(event:ResultEvent):void{
		var xml:XML = new XML(event.result);
		copyXML = xml.copy();
		parentApplication.funcXML = xml.copy();
		_treeXML = xml.copy();
		treeFuncFault.callLater(expendTree);
	}
	
	private function faultCallBack(event:FaultEvent):void{
		Alert.show(event.message.toString(),"错误");
	}
	
	private function updateSelectHandler(event:ContextMenuEvent):void{
		winFuncFaultType = new WinFuncFaultType();
		winFuncFaultType.addEventListener("RefreshData",refreshDataHandler);
		winFuncFaultType.resizeWin(280,260);
		winFuncFaultType.winTitle = "修改节点";
		winFuncFaultType.winOperType="Update";
		MyPopupManager.addPopUp(winFuncFaultType);
		winFuncFaultType.vs.selectedIndex = 0;
		if(treeFuncFault.selectedItem != null){
			var operModel:OperateListModel = new OperateListModel();
			operModel.projectid = treeFuncFault.selectedItem.@id;
			operModel.projectname = treeFuncFault.selectedItem.@name;
			operModel.operatetypeid = treeFuncFault.selectedItem.@operatetypeid;
			operModel.operatetype = treeFuncFault.selectedItem.@operatetype;
			operModel.parent_id = treeFuncFault.selectedItem.@parentid;
			
			winFuncFaultType.txtName.setFocus();
			winFuncFaultType.operationModel = operModel;
			winFuncFaultType.setData();
		}
	}
	
	private function addSelectHandler(event:ContextMenuEvent):void{
		winFuncFaultType = new WinFuncFaultType();
		winFuncFaultType.addEventListener("RefreshData",refreshDataHandler);
		winFuncFaultType.resizeWin(280,223);
		winFuncFaultType.winTitle = "故障类型";
		winFuncFaultType.winOperType="Add";
		MyPopupManager.addPopUp(winFuncFaultType);
		winFuncFaultType.vs.selectedIndex = 1;
		PopUpManager.centerPopUp(winFuncFaultType);
		if(treeFuncFault.selectedItem != null){
			var operModel:OperateListModel = new OperateListModel();
			operModel.parent_id = "0";//treeFuncFault.selectedItem.@id; //此处只有一级目录
			if(treeFuncFault.selectedItem.@operatetypeid!=null){
				operModel.operatetypeid = treeFuncFault.selectedItem.@operatetypeid;
				operModel.operatetype = treeFuncFault.selectedItem.@operatetype;
			}
			
		}
		
		winFuncFaultType.operationModel = operModel;
		winFuncFaultType.setData();
			
	}
	
	private function delSelectHandler(event:ContextMenuEvent):void{
		Alert.show("确定要删除该功能吗?","提示",Alert.YES|Alert.NO,null,closeHandler);
	}
	
	private function closeHandler(event:CloseEvent):void{
		if(event.detail == Alert.YES){
			if(treeFuncFault.selectedItem != null){
				var roFuncMgr:RemoteObject = new RemoteObject("faultSimulation");
				roFuncMgr.showBusyCursor = true;
				roFuncMgr.endpoint = ModelLocator.END_POINT;
				roFuncMgr.addEventListener(ResultEvent.RESULT,delHandler);
				var oper_id:String = treeFuncFault.selectedItem.@id;
				roFuncMgr.delFaultType(oper_id);
			}
		}
	}
	
	private function delHandler(event:ResultEvent):void{
		roFuncMgr.getAllFaultFunctions();
	}
	
	private function meauSelectHandler(event:ContextMenuEvent):void{
		treeFuncFault.selectedIndex = lastRollIndex;
		if(treeFuncFault.selectedItem.@name == "功能节点")
			contextMeau.customItems = [add_itemMeau];
		else
			contextMeau.customItems = [update_itemMeau,add_itemMeau,del_itemMeau];
	}
	
	private function tree_itemClick(evt:ListEvent):void {
		var item:Object = Tree(evt.currentTarget).selectedItem;
		if (treeFuncFault.dataDescriptor.isBranch(item)) {
			treeFuncFault.expandItem(item, !treeFuncFault.isItemOpen(item), true);
		}
	}