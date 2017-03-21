	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import sourceCode.systemManagement.model.VersionModel;
	import sourceCode.systemManagement.views.popup.WinVersionXtbm;
	
	[Bindable]
	public var _treeXML:XML;
	
	[Bindable]
	private var copyXML:XML = new XML();
	private var contextMeau:ContextMenu;
	private var lastRollIndex:int;
	private var winFunc:WinVersionXtbm;
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
		
		
		roFuncMgr.getAllVersionXtbm();
	}
	
	private function expendTree():void{
		treeFunc.expandItem(_treeXML,true);
	}
	
	private function refreshDataHandler(event:Event):void{
		roFuncMgr.getAllVersionXtbm();
	}
	
	private function iconFunction(item:Object):*{ 
		return ModelLocator.funcIcon;
	}
	
	private function funcResult(event:ResultEvent):void{
		var xml:XML = new XML(event.result);
		copyXML = xml.copy();
		parentApplication.versionXtbmXML = xml.copy();
		_treeXML = xml.copy();
		treeFunc.callLater(expendTree);
	}
	
	private function faultCallBack(event:FaultEvent):void{
		Alert.show(event.message.toString(),"错误");
	}
	
	private function updateSelectHandler(event:ContextMenuEvent):void{
		winFunc = new WinVersionXtbm();
		winFunc.addEventListener("RefreshData",refreshDataHandler);
		winFunc.resizeWin(280,350);
		winFunc.winTitle = "修改节点";
		MyPopupManager.addPopUp(winFunc);
		winFunc.vs.selectedIndex = 0;
		if(treeFunc.selectedItem != null){
			var operModel:VersionModel = new VersionModel();
			operModel.oper_id = treeFunc.selectedItem.@id;
			operModel.xtbm = treeFunc.selectedItem.@xtbm;
			operModel.xtxx = treeFunc.selectedItem.@xtxx;
			operModel.parent_id = treeFunc.selectedItem.@parentid;
			operModel.vtype= treeFunc.selectedItem.@vtype;
			operModel.remark= treeFunc.selectedItem.@remark;
			winFunc.operationModel = operModel;
			if(treeFunc.selectedItem.@parentid=="0"||(treeFunc.selectedItem.@xtbm=="csg_simulate"&&treeFunc.selectedItem.@xtxx=="基础版本")||treeFunc.selectedItem.@vtype=="数据库版本"){
				winFunc.b_save_update.visible=false;//第一节点不可修改和数据库版本不可修改;数据库版本为用户名
			}
			winFunc.txtType.enabled=false;
			winFunc.txtXtbm.setFocus();
		}
	}
	
	private function addSelectHandler(event:ContextMenuEvent):void{
		winFunc = new WinVersionXtbm();
		winFunc.addEventListener("RefreshData",refreshDataHandler);
		winFunc.resizeWin(280,300);
		winFunc.winTitle = "版本字典管理";
		if(treeFunc.selectedItem.@id!="0"&&treeFunc.selectedItem.@xtbm!="版本字典"){
			MyPopupManager.addPopUp(winFunc);
			winFunc.vs.selectedIndex = 1;
			PopUpManager.centerPopUp(winFunc);
			if(treeFunc.selectedItem != null){
				var operModel:VersionModel = new VersionModel();
				operModel.parent_id = treeFunc.selectedItem.@id;
				operModel.vtype= treeFunc.selectedItem.@xtbm;
				winFunc.txtNodeType.enabled=false;
			}
			winFunc.operationModel = operModel;
		}else{
			Alert.show("父节点不可新增");
		}
		
	}
	

	private function delSelectHandler(event:ContextMenuEvent):void{
		if(treeFunc.selectedItem.@id=="0"||treeFunc.selectedItem.@parentid=="0"||(treeFunc.selectedItem.@xtbm=="csg_simulate"&&treeFunc.selectedItem.@xtxx=="基础版本")){
			Alert.show("不可删除!");
		}else{
			Alert.show("确定要删除该功能吗?","提示",Alert.YES|Alert.NO,null,closeHandler);
		}
		
	}
	
	private function closeHandler(event:CloseEvent):void{
		if(event.detail == Alert.YES){
			if(treeFunc.selectedItem != null){
				var roFuncMgr:RemoteObject = new RemoteObject("login");
				roFuncMgr.showBusyCursor = true;
				roFuncMgr.endpoint = ModelLocator.END_POINT;
				roFuncMgr.addEventListener(ResultEvent.RESULT,delHandler);
				var oper_id:String = treeFunc.selectedItem.@id;
				roFuncMgr.delVersionXtbm(oper_id);
				var roLogin:RemoteObject = new RemoteObject("login");
				roLogin.showBusyCursor = false;
				roLogin.endpoint = ModelLocator.END_POINT;
				var oper_name:String = treeFunc.selectedItem.@xtbm;
				var oper_desc:String=treeFunc.selectedItem.@xtxx;
				if(oper_name!="csg_simulate"&&oper_desc!="基础版本"){//最基础的版本不可删除
					roLogin.delVersionUser(oper_name);//删除数据用户
				}	
				
			}
		}
	}
	
	private function delHandler(event:ResultEvent):void{
		roFuncMgr.getAllVersionXtbm();
	}
	
	private function meauSelectHandler(event:ContextMenuEvent):void{
		treeFunc.selectedIndex = lastRollIndex;
		if(treeFunc.selectedItem.@xtbm == "版本字典")
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