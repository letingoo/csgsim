	// ActionScript file
	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	import sourceCode.systemManagement.model.RoleModel;
	import sourceCode.systemManagement.views.RoleManager;
	
	[Bindable]
	private var _roleModel:RoleModel;
	
	public var roleManager:RoleManager;
	
	public function get roleModel():RoleModel{
		return _roleModel;
	}
	
	public function set roleModel(model:RoleModel):void{
		this._roleModel = model;
	}
	
	private function closeWin():void{
		_roleModel.clear();
		this.closeButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
	}
	
	private function saveRole():void{
		var ro:RemoteObject = new RemoteObject("roleManager");
		ro.showBusyCursor = true;
		ro.endpoint = ModelLocator.END_POINT;
		ro.addEventListener(ResultEvent.RESULT,resultCallBack);
		//parentApplication.faultEventHandler(ro);
		_roleModel.role_name = txtRoleName.text;
		_roleModel.role_desc = txtRoleDesc.text;
		if(title == "修改角色"){
			ro.updateRole(_roleModel);
		}else{
			ro.insertRole(_roleModel);
		}
	}
	
	private function resultCallBack(event:ResultEvent):void{
		closeWin();
		roleManager.roRoleMgr.getRoles();
	}