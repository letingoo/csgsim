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
	import sourceCode.faultSimulation.titles.WinFuncAlarm;
	
	[Bindable]
	public var _treeXML:XML;
	
	[Bindable]
	private var copyXML:XML = new XML();
	private var contextMeau:ContextMenu;
	private var lastRollIndex:int;
	private var winFuncAlarm:WinFuncAlarm;
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
		treeFunc1.contextMenu = contextMeau;
		
		
		roFuncMgr.getAllFunctions();
		
	}
	
	private function expendTree():void{
		treeFunc1.expandItem(_treeXML,true);
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
		treeFunc1.callLater(expendTree);
	}
	
	private function faultCallBack(event:FaultEvent):void{
		Alert.show(event.message.toString(),"错误");
	}
	
	private function updateSelectHandler(event:ContextMenuEvent):void{
		winFuncAlarm = new WinFuncAlarm();
		winFuncAlarm.addEventListener("RefreshData",refreshDataHandler);
		winFuncAlarm.resizeWin(280,260);
		winFuncAlarm.winTitle = "修改节点";
		winFuncAlarm.winOperType="Update";
		MyPopupManager.addPopUp(winFuncAlarm);
		winFuncAlarm.vs.selectedIndex = 0;
		if(treeFunc1.selectedItem != null){
			var operModel:OperateListModel = new OperateListModel();
			operModel.oper_id = treeFunc1.selectedItem.@id;
			operModel.alarm_name = treeFunc1.selectedItem.@name;
			operModel.alarm_id = treeFunc1.selectedItem.@alarm_id;
			operModel.oper_type = treeFunc1.selectedItem.@oper_type;
			operModel.vendercode = treeFunc1.selectedItem.@vendercode;
			operModel.vender = treeFunc1.selectedItem.@vender;
			operModel.oper_desc = treeFunc1.selectedItem.@oper_desc;
			operModel.parent_id = treeFunc1.selectedItem.@parentid;
			if(operModel!=null&&operModel.parent_id=="0"){
				//父节点，只能选择厂家
				winFuncAlarm.txtOperType.text="厂家";
				operModel.oper_type="厂家";
				winFuncAlarm.txtName.visible=false;
				winFuncAlarm.cmbName.visible=true;
				winFuncAlarm.L_Desc.visible=false;
				winFuncAlarm.cmbDesc.visible=false;
			}else{
				winFuncAlarm.txtOperType.text="告警";
				operModel.oper_type="告警";
				winFuncAlarm.txtName.visible=true;
				winFuncAlarm.cmbName.visible=false;
				winFuncAlarm.L_Desc.visible=true;
				winFuncAlarm.cmbDesc.visible=true;
				winFuncAlarm.txtName.setFocus();
			}
			winFuncAlarm.operationModel = operModel;
			winFuncAlarm.setData();
		}
	}
	
	private function addSelectHandler(event:ContextMenuEvent):void{
		winFuncAlarm = new WinFuncAlarm();
		winFuncAlarm.addEventListener("RefreshData",refreshDataHandler);
		winFuncAlarm.resizeWin(280,223);
		winFuncAlarm.winTitle = "告警节点";
		winFuncAlarm.winOperType="Add";
		MyPopupManager.addPopUp(winFuncAlarm);
		winFuncAlarm.vs.selectedIndex = 1;
		PopUpManager.centerPopUp(winFuncAlarm);
		if(treeFunc1.selectedItem != null){
			var operModel:OperateListModel = new OperateListModel();
			operModel.parent_id = treeFunc1.selectedItem.@id;
			operModel.vender=treeFunc1.selectedItem.@vender;
			operModel.vendercode=treeFunc1.selectedItem.@vendercode;
			if(operModel!=null&&operModel.parent_id=="0"){
				//父节点，只能选择厂家
				winFuncAlarm.txtNodeOperType.text="厂家";
				operModel.oper_type="厂家";
				winFuncAlarm.txtNodeName.visible=false;
				winFuncAlarm.cmbNodeName.visible=true;
				winFuncAlarm.L_NodeDesc.visible=false;
				winFuncAlarm.cmbNodeDesc.visible=false;
			}else{
				winFuncAlarm.txtNodeOperType.text="告警";
				operModel.oper_type="告警";
				winFuncAlarm.txtNodeName.visible=true;
				winFuncAlarm.cmbNodeName.visible=false;
				winFuncAlarm.L_NodeDesc.visible=true;
				winFuncAlarm.cmbNodeDesc.visible=true;
			}
		}
		
		winFuncAlarm.operationModel = operModel;
		winFuncAlarm.setData();
			
	}
	
	private function delSelectHandler(event:ContextMenuEvent):void{
		Alert.show("确定要删除该功能吗?","提示",Alert.YES|Alert.NO,null,closeHandler);
	}
	
	private function closeHandler(event:CloseEvent):void{
		if(event.detail == Alert.YES){
			if(treeFunc1.selectedItem != null){
				var roFuncMgr:RemoteObject = new RemoteObject("faultSimulation");
				roFuncMgr.showBusyCursor = true;
				roFuncMgr.endpoint = ModelLocator.END_POINT;
				roFuncMgr.addEventListener(ResultEvent.RESULT,delHandler);
				var oper_id:String = treeFunc1.selectedItem.@id;
				roFuncMgr.delAlarmOperation(oper_id);
			}
		}
	}
	
	private function delHandler(event:ResultEvent):void{
		roFuncMgr.getAllFunctions();
	}
	
	private function meauSelectHandler(event:ContextMenuEvent):void{
		treeFunc1.selectedIndex = lastRollIndex;
		if(treeFunc1.selectedItem.@name == "功能节点")
			contextMeau.customItems = [add_itemMeau];
		else
			contextMeau.customItems = [update_itemMeau,add_itemMeau,del_itemMeau];
	}
	
	private function tree_itemClick(evt:ListEvent):void {
		var item:Object = Tree(evt.currentTarget).selectedItem;
		if (treeFunc1.dataDescriptor.isBranch(item)) {
			treeFunc1.expandItem(item, !treeFunc1.isItemOpen(item), true);
		}
	}