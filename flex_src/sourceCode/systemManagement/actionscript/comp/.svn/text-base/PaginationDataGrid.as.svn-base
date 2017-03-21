	// ActionScript file
	import com.adobe.serialization.json.JSON;
	
	import common.actionscript.ModelLocator;
	
	import flash.utils.setTimeout;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import sourceCode.systemManagement.model.PermissionControlModel;
	import sourceCode.systemManagement.model.UserModel;
	import sourceCode.systemManagement.model.UserResultModel;
	import sourceCode.systemManagement.views.UserManager;
	import sourceCode.systemManagement.views.comp.addUser;
	
	import twaver.SequenceItemRenderer;

	private var pageIndex:int=0;
	private var pageSize:int=5;
	[Bindable]			
	private var cm:ContextMenu;
	private var rolesInfos:String;
	private var user_Counts:int;
	private var itemEdit:addUser = new addUser();
	private var detailInfos:userAndRoleInfos;
	private var lastRollOverIndex:int;
	public var userManager:UserManager;
	[Bindable]
	private var _acUserInfo:UserResultModel;
	private var indexRenderer:Class = SequenceItemRenderer;

    private var isEdit:Boolean = false;
    private var isDelete:Boolean = false;
    private function preinitialize():void{
	    if(ModelLocator.permissionList != null && ModelLocator.permissionList.length > 0){
		    var model:PermissionControlModel;
		    for(var i:int=0,max:int=ModelLocator.permissionList.length; i<max; i++){
			    model = ModelLocator.permissionList[i];
			    if(model.oper_name != null && model.oper_name == "修改操作"){
				    isEdit = true;
			    }
			    if(model.oper_name != null && model.oper_name == "删除操作"){
				    isDelete = true;
			    }
		    }
	    }
		
    }   

	private var queryType:Boolean = true;
	private function Queryall(event:Event):void{
		queryType = false;
	}

	public function get acUserInfo():UserResultModel
	{
		return _acUserInfo;
	}
	public function set acUserInfo(value:UserResultModel):void
	{
		_acUserInfo = value;
	}
	//鼠标右键单击事件
	public function init():void{
		pageToolBar.addEventListener("viewAllEvent",Queryall);	
		var cmi_update:ContextMenuItem=new ContextMenuItem("修 改",true);
		cmi_update.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,updateUser);
		cmi_update.visible = isEdit;
			
		var cmi_delete:ContextMenuItem=new ContextMenuItem("删 除",true);
		cmi_delete.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,delUser);
		cmi_delete.visible = isDelete;
		cm = new ContextMenu();
		cm.hideBuiltInItems();
		cm.customItems = [cmi_update,cmi_delete];
		cm.addEventListener(ContextMenuEvent.MENU_SELECT, contextMenu_menuSelect);
		
		//					serverPagingBar1.dataGrid=user_infos;
		//					serverPagingBar1.pagingFunction=pagingFunction;
	}
	private function contextMenu_menuSelect(evt:ContextMenuEvent):void {	
		user_infos.selectedIndex = lastRollOverIndex;
	}	
	//菜单修改用户信息
	public function c_updaeUser():void{
//		to_depart.getDepartIfos(obj.user_id);
		//				PopUpManager.addPopUp(itemEdit, this.parent, true);  
		//				PopUpManager.centerPopUp(itemEdit); 
		parentApplication.openModel("用户信息配置",true,itemEdit);
		setTimeout(openModelHandler,1000);
	}

	private function openModelHandler():void{
		var obj:Object; 
		obj = user_infos.selectedItem;
		to_rolesSet.getroles(obj.user_id);
		to_depart.getDepartIfos(obj.user_id);
		itemEdit.doType="edit";
		itemEdit.checkdo=false;
		itemEdit.refreshUser = this.userManager;
		itemEdit.refreshRoleinfos = this;
		if(itemEdit == null)
			itemEdit = new addUser();
		if(obj.user_id!=null){
			itemEdit.user_id.text=obj.user_id;
		}else{
			itemEdit.user_id.text="";
		}
		if(obj.user_name!=null){
			itemEdit.user_name.text=obj.user_name;
		}else{
			itemEdit.user_name.text="";
		}
		if(obj.user_pwd!=null){
			itemEdit.user_pwd.text=obj.user_pwd;
		}else{
			itemEdit.user_pwd.text="";
		}
		if(obj.user_sex!=null){
			itemEdit.user_sex.selectedValue=obj.user_sex;
		}else{
			itemEdit.user_sex.selectedValue="";
		}
		if(obj.birthday!=null){	
			itemEdit.birthday.text=obj.birthday;
		}else{
			itemEdit.birthday.text="";
		}
		if(obj.user_dept!=null){	
			itemEdit.user_dept.text=obj.user_dept;
			
		}else{
			itemEdit.user_dept.text="";
		}
		if(obj.user_deptcode!=null)
		{
			itemEdit.user_deptcode=obj.user_deptcode;
		}
		
		if(obj.user_post!=null){	
			itemEdit.user_post.text=obj.user_post;
		}else{
			itemEdit.user_post.text="";
		}
		if(obj.education!=null){	
			itemEdit.education.text=obj.education;
		}else{
			itemEdit.education.text="";
		}
		if(obj.telephone!=null){	
			itemEdit.telephone.text=obj.telephone;
		}else{
			itemEdit.telephone.text="";
		}
		if(obj.mobile!=null){	
			itemEdit.mobile.text=obj.mobile;
		}else{
			itemEdit.mobile.text="";
		}
		if(obj.email!=null){	
			itemEdit.email.text=obj.email;
		}else{
			itemEdit.email.text="";
		}
		if(obj.address!=null){	
			itemEdit.address.text=obj.address;
		}else{
			itemEdit.address.text="";
		}
	}
	//右键修改用户
	private function updateUser(evt:ContextMenuEvent):void  
	{  
		c_updaeUser();
	}		
	//右键删除用户
	private function delUser(event:ContextMenuEvent):void{
		c_delUser();
	}
	//菜单删除用户信息
	public function c_delUser():void{
		Alert.yesLabel = "是";
		Alert.noLabel = "否";
		Alert.show("是否要删除，请确认！","提示",3,this,deleletJudged);
		Alert.yesLabel = "Yes";
		Alert.noLabel = "No";
	}
	private function deleletJudged(event:CloseEvent):void{
		if(event.detail == Alert.YES){
			var uobj:Object; 
			uobj = user_infos.selectedItem;
			var objdel:RemoteObject = new RemoteObject("userManager");
			objdel.showBusyCursor = true;
			objdel.endpoint = ModelLocator.END_POINT;
			objdel.del_User(uobj);
			objdel.addEventListener(ResultEvent.RESULT,delResult)
			//parentApplication.faultEventHandler(objdel);
		}			
	}
	
	private function delResult(evevt:ResultEvent):void{
		var resultString:String;
		resultString=evevt.result.toString();
		if(resultString=="delsuccess"){
			Alert.show("用户删除成功！","提示");
			var userModel:UserModel= new UserModel();
			this.selectUserInfos(userModel);
			
		}
		if(resultString=="delfailed"){
			Alert.show("用户删除失败！","提示");
		}
	}
	
	private function dgDetailInfos():void{
		//				var detailObj:Object; 
		//				detailObj = user_infos.selectedItem;
		//				to_rolesShow.getroles(detailObj.user_id);
		//				detailInfos = new userAndRoleInfos();
		//				PopUpManager.addPopUp(detailInfos, this.parent, true);  
		//				PopUpManager.centerPopUp(detailInfos); 
		//				detailInfos.user_id.text=detailObj.user_id;
		//				detailInfos.user_name.text=detailObj.user_name;
		//				detailInfos.user_sex.text=detailObj.user_sex;
		//				detailInfos.user_dept.text=detailObj.user_dept;
		//				detailInfos.user_post.text=detailObj.user_post;
		//				detailInfos.birthday.text=detailObj.birthday;
		//				detailInfos.telephone.text=detailObj.telephone;
		//				detailInfos.address.text=detailObj.address;
		//				detailInfos.mobile.text=detailObj.mobile;
		//				detailInfos.education.text=detailObj.education;
		c_updaeUser();
	}		
	private function faultCallBack(event:FaultEvent):void{
		Alert.show(event.message.toString(),"错误");
	}		
	
	
	//			*********************************后台访问***************************//
	//			public function selectUserInfos(userModel:UserModel):void{		
	//				con_UserMgr.queryUserInfos(userModel);
	//			}
	//*******************************后台访问***************************//
	public function selectUserInfos(userModel:UserModel):void{
		queryType = true;
		userModel.start="0";
		userModel.end="50";
		con_UserMgr.getUsers(userModel);
		pageToolBar.navigateButtonClick("firstPage");
	}
	
	//******************************8返回结果**********************//
	private function get_UserInfos(event:ResultEvent = null):void{
		_acUserInfo = UserResultModel(event.result);
		pageToolBar.orgData=_acUserInfo.userList;
		pageToolBar.totalRecord=_acUserInfo.totalCount;
		if(queryType){
			pageToolBar.pageSize = 50; 
			pageToolBar.isInit = true;
		}		
		pageToolBar.dataBind(true);
	}
	
	public function getRolesinformation(event:ResultEvent):void{
		itemEdit.roleInfor= String(event.result);
	}
	
	public function getDepartinformation(event:ResultEvent):void{
		var departstr:String =event.result.toString();
		
		var departs:Array=(JSON.decode(departstr) as Array); 	
		
		var departnames:String="";
		if(departs.length==0)
		{
			itemEdit.departInformation="该用户暂未分配单位";
			itemEdit.departMentCodes=null;
			return;
		}
		for(var i:int=0;i<departs.length;i++)
		{
			departnames+=departs[i].departname+",";
//			itemEdit.departMentCodes.push(departs[i].departcode);
		}		
		itemEdit.departInformation=departnames.substr(0,departnames.length-1);
		
	}
	
	private function getRolesinfos(event:ResultEvent):void{
		rolesInfos= String(event.result);
		detailInfos.forUserInfo=rolesInfos;
	}	
	
	private function pagingFunction(pageIndex:int,pageSize:int):void{
		var userModel:UserModel = new UserModel();
		var start:String = (pageIndex * pageSize).toString();
		var end:String = ((pageIndex * pageSize) + pageSize).toString();
		userModel.start=start;
		userModel.end=end;
		userModel.user_id=parentDocument.user_id.text;
		userModel.user_name=parentDocument.user_name.text;
		userModel.user_sex=parentDocument.user_sex.text;
		userModel.user_dept=parentDocument.user_dept.text;
		userModel.user_post=parentDocument.user_post.text;
		userModel.telephone=parentDocument.telephone.text;
		userModel.mobile=parentDocument.mobile.text;
		userModel.email=parentDocument.email.text;
		con_UserMgr.getUsers(userModel);
	}