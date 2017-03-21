	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	
	import flash.display.DisplayObject;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import sourceCode.faultSimulation.titles.ClassicFaultAlarmConfigTitle;
	import sourceCode.faultSimulation.titles.SelectCheckUserInfoTitle;
	import sourceCode.faultSimulation.views.WinClassicFault;
	import sourceCode.systemManagement.model.OperationModel;
	
	[Bindable]
	public var _treeXML:XML;
	
	[Bindable]
	private var copyXML:XML = new XML();
	private var contextMeau:ContextMenu;
	private var lastRollIndex:int;
	private var winFunc:WinClassicFault;
	private var update_itemMeau:ContextMenuItem;
	private var add_itemMeau:ContextMenuItem;
	private var del_itemMeau:ContextMenuItem;
	private var executeMenu:ContextMenuItem;
	private var alarmConf:ContextMenuItem;
	public var userids:String="";
	
	private function init():void{
		update_itemMeau = new ContextMenuItem("修 改");
		update_itemMeau.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,updateSelectHandler);
		add_itemMeau = new ContextMenuItem("添 加");
		add_itemMeau.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,addSelectHandler);
		del_itemMeau = new ContextMenuItem("删 除");
		del_itemMeau.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,delSelectHandler);
		executeMenu = new ContextMenuItem("执行");
		executeMenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,executeSelectHandler);
		
		alarmConf = new ContextMenuItem("告警配置");
		alarmConf.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,alarmConfigHandler);
		
		contextMeau = new ContextMenu();
		contextMeau.hideBuiltInItems();
		contextMeau.customItems = [update_itemMeau,add_itemMeau,del_itemMeau,executeMenu,alarmConf];
		contextMeau.addEventListener(ContextMenuEvent.MENU_SELECT,meauSelectHandler);
		treeFunc.contextMenu = contextMeau;
		
		roFuncMgr.getAllClassicFault();
		
	}
	
	private function expendTree():void{
		treeFunc.expandItem(_treeXML,true);
	}
	
	private function refreshDataHandler(event:Event):void{
		roFuncMgr.getAllClassicFault();
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
		winFunc = new WinClassicFault();
		winFunc.addEventListener("RefreshData",refreshDataHandler);
		winFunc.resizeWin(280,160);
		winFunc.winTitle = "修改故障";
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
		winFunc = new WinClassicFault();
		winFunc.addEventListener("RefreshData",refreshDataHandler);
		winFunc.resizeWin(280,123);
		winFunc.winTitle = "典型故障";
		MyPopupManager.addPopUp(winFunc);
		winFunc.vs.selectedIndex = 1;
		PopUpManager.centerPopUp(winFunc);
		if(treeFunc.selectedItem != null){
			var operModel:OperationModel = new OperationModel();
			operModel.parent_id = treeFunc.selectedItem.@id;
		}
		winFunc.operationModel = operModel;
	}

	private function alarmConfigHandler(event:ContextMenuEvent):void{
		//告警配置页面,传递故障ID
		var alarmConf:ClassicFaultAlarmConfigTitle = new ClassicFaultAlarmConfigTitle();
		alarmConf.oper_id = treeFunc.selectedItem.@id;
		PopUpManager.addPopUp(alarmConf,Application.application as DisplayObject,true);
		PopUpManager.centerPopUp(alarmConf);
	}
	
	private function executeSelectHandler(event:ContextMenuEvent):void{
		//判断是否选择参与人，是，弹出人员选择框，否则，为全部
		if(treeFunc.selectedItem != null){
			Alert.show("是否指定参演人员?","提示",Alert.YES|Alert.NO,null,closeExecuteHandler);
		}
	}
	
	private function closeExecuteHandler(event:CloseEvent):void{
		if(event.detail == Alert.YES){
			//弹出选择框
			var sqsearch:SelectCheckUserInfoTitle=new SelectCheckUserInfoTitle();
			sqsearch.user_id="";
			//	sqsearch.page_parent=this;
			PopUpManager.addPopUp(sqsearch,this,true);
			PopUpManager.centerPopUp(sqsearch);
			sqsearch.myCallBack=this.UserInfo_changeHandler;
		}else{
			//默认指定几个人，或全部
			userids = "root,chenxuan,chenxn,admin,fanjc,wangli,huangyu,hongdk";
			executeFault(treeFunc.selectedItem.@id,userids);
		}
	}

	public function UserInfo_changeHandler(obj:Object):void
	{	
		var id:String=obj.id;
		if(id.length>0){
			id=id.substr(0,id.length-1);
		}
		userids = id;
		executeFault(treeFunc.selectedItem.@id,userids);
	}

	private function executeFault(faultid:String,userids:String):void{
		var remoteObject:RemoteObject=new RemoteObject("faultSimulation");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		remoteObject.executeFault(faultid,userids);
		remoteObject.addEventListener(ResultEvent.RESULT,setEventIsActiveResultHandler);
	}
	
	private function setEventIsActiveResultHandler(event:ResultEvent):void{
		if(event.result.toString()=="success"){
			Alert.show("操作成功,是否查看告警列表？","提示",3,this,openAlarmCallBack);
			MyPopupManager.removePopUp(this);
		}else{
			Alert.show("操作失败！","提示");
		}
	}
	
	private function openAlarmCallBack(event:CloseEvent):void{
		if(event.detail==Alert.YES){
			subMessage.stopSendMessage("stop");
			subMessage.startSendMessage(Application.application.curUser);
		}
	}
	
	protected function subMessage_resultHandler(event:ResultEvent):void  
	{} 

	private function delSelectHandler(event:ContextMenuEvent):void{
		Alert.show("确定要删除该功能吗?","提示",Alert.YES|Alert.NO,null,closeHandler);
	}
	
	private function closeHandler(event:CloseEvent):void{
//		if(event.detail == Alert.YES){
//			if(treeFunc.selectedItem != null){
//				var roFuncMgr:RemoteObject = new RemoteObject("funcManager");
//				roFuncMgr.showBusyCursor = true;
//				roFuncMgr.endpoint = ModelLocator.END_POINT;
//				roFuncMgr.addEventListener(ResultEvent.RESULT,delHandler);
//				var oper_id:String = treeFunc.selectedItem.@id;
//				roFuncMgr.delFunction(oper_id);
//			}
//		}
	}
	
	private function delHandler(event:ResultEvent):void{
		roFuncMgr.getAllClassicFault();
	}
	
	private function meauSelectHandler(event:ContextMenuEvent):void{
		treeFunc.selectedIndex = lastRollIndex;
		if(treeFunc.selectedItem.@parentid == "0")
			contextMeau.customItems = [add_itemMeau];
		else
			contextMeau.customItems = [update_itemMeau,add_itemMeau,del_itemMeau,executeMenu,alarmConf];
	}
	
	private function tree_itemClick(evt:ListEvent):void {
		var item:Object = Tree(evt.currentTarget).selectedItem;
		if (treeFunc.dataDescriptor.isBranch(item)) {
			treeFunc.expandItem(item, !treeFunc.isItemOpen(item), true);
		}
	}