	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import sourceCode.systemManagement.model.OperationModel;
	import sourceCode.systemManagement.views.popup.WinFunc;
	
	[Bindable]
	public var _treeXML:XML;
	
	[Bindable]
	private var copyXML:XML = new XML();
	private var contextMeau:ContextMenu;
	private var lastRollIndex:int;
	private var winFunc:WinFunc;
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
		treeFunc.contextMenu = contextMeau;
		
		roFuncMgr.getAllFunctions();
		
//		if(parentApplication.funcXML == null){
//			roFuncMgr.getAllFunctions();
//		}else{
//			copyXML = parentApplication.funcXML.copy();
//			_treeXML = parentApplication.funcXML.copy();
//			treeFunc.callLater(expendTree);
//		}
	}
	
	private function expendTree():void{
		treeFunc.expandItem(_treeXML,true);
	}
	
	private function refreshDataHandler(event:Event):void{
		roFuncMgr.getAllFunctions();
	}
	
	private function iconFunction(item:Object):*{ 
		return ModelLocator.funcIcon;
	}
	
	private function funcResult(event:ResultEvent):void{
		var xml:XML = new XML(event.result);
		copyXML = xml.copy();
		parentApplication.funcXML = xml.copy();
		_treeXML = xml.copy();
		treeFunc.callLater(expendTree);
	}
	
	private function faultCallBack(event:FaultEvent):void{
		Alert.show(event.message.toString(),"错误");
	}
	
	private function updateSelectHandler(event:ContextMenuEvent):void{
		winFunc = new WinFunc();
		winFunc.addEventListener("RefreshData",refreshDataHandler);
		winFunc.resizeWin(280,160);
		winFunc.winTitle = "修改节点";
		MyPopupManager.addPopUp(winFunc);
		winFunc.vs.selectedIndex = 0;
		if(treeFunc.selectedItem != null){
			var operModel:OperationModel = new OperationModel();
			operModel.oper_id = treeFunc.selectedItem.@id;
			operModel.oper_name = treeFunc.selectedItem.@name;
			operModel.parent_id = treeFunc.selectedItem.@parentid;
			winFunc.operationModel = operModel;
			winFunc.txtName.setFocus();
		}
	}
	
	private function addSelectHandler(event:ContextMenuEvent):void{
		winFunc = new WinFunc();
		winFunc.addEventListener("RefreshData",refreshDataHandler);
		winFunc.resizeWin(280,123);
		winFunc.winTitle = "功能节点";
		MyPopupManager.addPopUp(winFunc);
		winFunc.vs.selectedIndex = 1;
		PopUpManager.centerPopUp(winFunc);
		if(treeFunc.selectedItem != null){
			var operModel:OperationModel = new OperationModel();
			operModel.parent_id = treeFunc.selectedItem.@id;
		}
		winFunc.operationModel = operModel;
	}
	
	private function delSelectHandler(event:ContextMenuEvent):void{
		Alert.show("确定要删除该功能吗?","提示",Alert.YES|Alert.NO,null,closeHandler);
	}
	
	private function closeHandler(event:CloseEvent):void{
		if(event.detail == Alert.YES){
			if(treeFunc.selectedItem != null){
				var roFuncMgr:RemoteObject = new RemoteObject("funcManager");
				roFuncMgr.showBusyCursor = true;
				roFuncMgr.endpoint = ModelLocator.END_POINT;
				roFuncMgr.addEventListener(ResultEvent.RESULT,delHandler);
				var oper_id:String = treeFunc.selectedItem.@id;
				roFuncMgr.delFunction(oper_id);
			}
		}
	}
	
	private function delHandler(event:ResultEvent):void{
		roFuncMgr.getAllFunctions();
	}
	
	private function meauSelectHandler(event:ContextMenuEvent):void{
		treeFunc.selectedIndex = lastRollIndex;
		if(treeFunc.selectedItem.@name == "功能节点")
			contextMeau.customItems = [add_itemMeau];
		else
			contextMeau.customItems = [update_itemMeau,add_itemMeau,del_itemMeau];
	}
	
	private function tree_itemClick(evt:ListEvent):void {
		var item:Object = Tree(evt.currentTarget).selectedItem;
		if (treeFunc.dataDescriptor.isBranch(item)) {
			treeFunc.expandItem(item, !treeFunc.isItemOpen(item), true);
		}
	}