	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.ToolTip;
	import mx.events.CloseEvent;
	import mx.events.MenuEvent;
	import mx.events.ToolTipEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import sourceCode.systemManagement.model.RoleModel;
	import sourceCode.systemManagement.model.UserModel;
	import sourceCode.systemManagement.model.UserResultModel;
	import sourceCode.systemManagement.views.popup.WinConfigureRole;
	import sourceCode.systemManagement.views.popup.WinRole;
	
	private var xml:XML;
	private var mouseTarget:DisplayObject;
	
	[Bindable]			
	private var cm:ContextMenu;
	
	[Bindable]
	private var acUserInfo:ArrayCollection;
	
	public var lastRollIndex:int;
	private var winRole:WinRole;
	private var winConfigRole:WinConfigureRole;

	private function init():void{
		roRoleMgr.getRoles();
		
		var cmi_update:ContextMenuItem=new ContextMenuItem("修 改",true);
		cmi_update.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,updateRole);	
		
		var cmi_delete:ContextMenuItem=new ContextMenuItem("删 除",true);
		cmi_delete.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,delRole);
		
		cm = new ContextMenu();
		cm.hideBuiltInItems();
		cm.customItems = [cmi_update,cmi_delete];
		cm.addEventListener(ContextMenuEvent.MENU_SELECT, contextMenu_menuSelect);
	}
	
	private function contextMenu_menuSelect(evt:ContextMenuEvent):void {	
		treeRole.selectedIndex = lastRollIndex;
	}
	
	private function updateRole(event:ContextMenuEvent):void{
		winRole = new WinRole();
		winRole.title = "修改角色";
		winRole.roleManager = this;
		MyPopupManager.addPopUp(winRole);
		var roleModel:RoleModel = new RoleModel();
		roleModel.role_id = treeRole.selectedItem.@id;
		roleModel.role_name = treeRole.selectedItem.@text;
		roleModel.role_desc = treeRole.selectedItem.@desc;
		winRole.roleModel = roleModel;
	}

	private function addRoleHandler():void{
		winRole = new WinRole();
		winRole.title = "添加角色";
		winRole.roleManager = this;
		MyPopupManager.addPopUp(winRole);
		var roleModel:RoleModel = new RoleModel();
		winRole.roleModel = roleModel;
	}
	
	private function delRole(event:ContextMenuEvent):void{
		Alert.show("确定要删除该角色吗?","提示",Alert.YES|Alert.NO,null,closeHandler);
	}
	
	private function closeHandler(event:CloseEvent):void{
		if(event.detail == Alert.YES){
			if(treeRole.selectedItem != null){
				var ro:RemoteObject = new RemoteObject("roleManager");
				ro.showBusyCursor = true;
				ro.endpoint = ModelLocator.END_POINT;
				ro.deleteRole(new String(treeRole.selectedItem.@id));
				ro.addEventListener(ResultEvent.RESULT,delCallBack);
			}
		}
	}

	private function delCallBack(event:ResultEvent):void{
		roRoleMgr.getRoles();
	}
	
	private function resultCallBack(event:ResultEvent):void{
		xml = new XML(event.result.toString());
		treeRole.dataProvider = xml;
		treeRole.callLater(openTree);
	}
	
	private function openTree():void{
		treeRole.expandChildrenOf(xml,true);
	}
	
	private function iconFunction(item:Object):*{ 
		var xml:XML = item as XML; 
		if(xml.attribute("icon") != "" && xml.attribute("icon") != null)
			return ModelLocator.userIcon;
		else if(treeRole.isItemOpen(item))
			return ModelLocator.openIcon;
		else if(!treeRole.isItemOpen(item))
			return ModelLocator.closeIcon;
	}
	
	private var pageIndex:int = 0;
	private var pageSize:int = 50;
	
	private function itemClick():void{
		txtFunc.text = "";
		var tempArr:Array = String(treeRole.selectedItem.@funcs).split(",");
		for(var i:int = 0; i < tempArr.length - 1; i++){
			txtFunc.text += tempArr[i].toString().split(":")[1]+",";
		}
		pagingFunction(pageIndex,pageSize);
	}
	
	private function getUserInfoCallBace(event:ResultEvent):void{
		acUserInfo = new ArrayCollection();
		acUserInfo = ArrayCollection(event.result);
	}
	
	private function configRole():void{
		if(treeRole.selectedItem != null){
			winConfigRole = new WinConfigureRole();
			winConfigRole.tempIndex = treeRole.selectedIndex;
			MyPopupManager.addPopUp(winConfigRole);
			winConfigRole.roleManager = this;
			winConfigRole.init();
		}else{
			Alert.show("请先从右侧选择一个角色!","提示");
		}
	}
	
	private function pagingFunction(pageIndex:int,pageSize:int):void{
		var userModel:UserModel = new UserModel();
		var roUserManager:RemoteObject = new RemoteObject("userManager");
		roUserManager.showBusyCursor = true;
		roUserManager.endpoint = ModelLocator.END_POINT;
		roUserManager.addEventListener(ResultEvent.RESULT,onResult);
		
		var start:String = (pageIndex * pageSize).toString();
		var end:String = ((pageIndex * pageSize) + pageSize).toString();
		var roleId:String = treeRole.selectedItem.@id;
		roUserManager.getUserInfoByRoleIdAndPageSize(roleId,start,end);
	}
	
	private function onResult(event:ResultEvent):void{
		var userResultModel:UserResultModel = UserResultModel(event.result);
		acUserInfo = userResultModel.userList;
		for(var i:int = 0; i < acUserInfo.length; i++){
			acUserInfo[i].rowid = (i + 1).toString();
		}
		pageToolBar.orgData = acUserInfo;
		pageToolBar.totalRecord = int(userResultModel.totalCount);
		pageToolBar.dataBind(true);
	}
	
	private function faultCallBack(event:FaultEvent):void{
		Alert.show(event.message.toString(),"错误");
	}