	// ActionScript file
	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	
	import sourceCode.systemManagement.model.RoleModel;
	private var refreshroleInfo:addUser;
	[Bindable]
	public var userid:String;
	[Bindable]
	private var rolesInfos1:ArrayCollection;
	[Bindable]
	private var rolesInfos2:ArrayCollection;
	public var refreshRoleinfos:PaginationDataGrid;
	public function get rolesInfoSet():ArrayCollection
	{
		return rolesInfos1;
	}
	
	public function set rolesInfoSet(value:ArrayCollection):void
	{
		rolesInfos1 = value;
	}
	public function get rolesInfoSet2():ArrayCollection
	{
		return rolesInfos2;
	}
	
	public function set rolesInfoSet2(value:ArrayCollection):void
	{
		rolesInfos2 = value;
	}
	
	public function close():void{
		MyPopupManager.removePopUp(this); 
	}
	
	private function getRoleslimit():void{
		if(userid==null){
			Alert.show("该用户不存在");
		}else{
			to_userRoles1.getUserRoleForLimit(userid);// 已分配的角色权限
			to_userRoles2.getUserNotRole(userid);//未分配的角色权限
		}				
	}
	
	private function getRoles(event:ResultEvent):void{
		rolesInfoSet=ArrayCollection(event.result);
	}
	private function getRoles2(event:ResultEvent):void{
		rolesInfoSet2=ArrayCollection(event.result);
	}
	//function dgMoveRole1()删除角色权限。
	private function dgMoveRole1():void{
		var roleModel:RoleModel =new RoleModel();
		roleModel.role_id=ResetRole.selectedItem.role_id.toString();
		roleModel.role_name=ResetRole.selectedItem.role_name.toString();
		roleModel.role_desc=ResetRole.selectedItem.role_desc.toString();
		rolesInfos2.addItem(roleModel);
		rolesInfos1.removeItemAt(ResetRole.selectedIndex);
	}
	//function dgMoveRole2()添加角色权限。
	private function dgMoveRole2():void{
		var roleModel:RoleModel =new RoleModel();
		roleModel.role_id=notResetRole.selectedItem.role_id.toString();
		roleModel.role_name=notResetRole.selectedItem.role_name.toString();
		roleModel.role_desc=notResetRole.selectedItem.role_desc.toString();
		rolesInfos1.addItem(roleModel);
		rolesInfos2.removeItemAt(notResetRole.selectedIndex);
		
	}
	private function Reset():void{
		getRoleslimit();
	}
	
	private function save():void{
		// 把rolesInfos1 传给后台进行处理！
		var obj:RemoteObject = new RemoteObject("userManager");
		obj.endpoint = ModelLocator.END_POINT;
		var objrefresh:RemoteObject = new RemoteObject("userManager");
		objrefresh.endpoint = ModelLocator.END_POINT;
		objrefresh.addEventListener(ResultEvent.RESULT,refreshRoleInfos);
		//parentApplication.faultEventHandler(objrefresh);
		//parentApplication.faultEventHandler(obj);
		if(userid!=null&&userid!=""){
			obj.changeUserRoles(userid,rolesInfos1);
			objrefresh.getroles(userid);
			close();
			Alert.show("配置成功！","提示",0,this,setSucces);
			
		}else{
			close();
			Alert.show("配置失败！此用户不存在！");
		}
	}
	private function setSucces(event:CloseEvent):void{
		if(event.detail == Alert.OK){
			refreshRoleinfos.c_updaeUser();
		}
	}
	private function refreshRoleInfos(event:ResultEvent):void{
		refreshroleInfo = new addUser();
		refreshroleInfo.roleInfor=String(event.result);
	}