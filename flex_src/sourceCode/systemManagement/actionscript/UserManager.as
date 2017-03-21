	// ActionScript file
	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	

	
	import sourceCode.*;
	import sourceCode.systemManagement.model.PermissionControlModel;
	import sourceCode.systemManagement.model.UserModel;
	import sourceCode.systemManagement.views.comp.addUser;

	[Embed(source="assets/images/sysManager/hide.png")]          //这是图片的相对地址 
	[Bindable] 
	public var PointIcon:Class; 
	[Embed(source="assets/images/sysManager/hide.png")]
	[Bindable] 
	public var PointRight:Class; 
	[Embed(source="assets/images/sysManager/show.png")] 
	[Bindable] 
	public var PointLeft:Class;
	[Bindable]
	public var user_Model:UserModel;
	public var obj_query:Object;
	public var labels:String = "用户信息列表";
	public var titles:Array = new Array("用户名","真实姓名","性别",
		"所属单位","职位","生日","学历","固定电话",
		"移动电话","电子邮箱","通信地址","备注");
	public var path:String;
  
    private var isAdd:Boolean = false;
    private var isEdit:Boolean = false;
    private var isDelete:Boolean = false;
    private var isExport:Boolean = false;
    private function preinitialize():void{
	    if(ModelLocator.permissionList != null && ModelLocator.permissionList.length > 0){
		    var model:PermissionControlModel;
		    for(var i:int=0,max:int=ModelLocator.permissionList.length; i<max; i++){
			    model = ModelLocator.permissionList[i];
			    if(model.oper_name != null && model.oper_name == "添加操作"){
				    isAdd = true;
			    }
			    if(model.oper_name != null && model.oper_name == "修改操作"){
				    isEdit = true;
			    }
			    if(model.oper_name != null && model.oper_name == "删除操作"){
				    isDelete = true;
			    }
				if(model.oper_name != null && model.oper_name == "导出操作"){
					isExport = true;
				}
		     }
	    }
    } 

	private function init():void{
		var userModel:UserModel = new UserModel();
		get_userInfos.selectUserInfos(userModel);
		get_userInfos.userManager = this;
	}

	//增加用户
	private var winadduser:addUser = new addUser();
    private function add_user():void{
		parentApplication.openModel("用户信息配置",true,winadduser);
		
		winadduser.checkdo=true;
		winadduser.refreshUser = this;
		winadduser.refreshRoleinfos = this.get_userInfos;
	}
	//菜单修改用户
	private function edit_User():void{
		if(get_userInfos.user_infos.selectedItem == null){
			Alert.show("请先选择要修改的用户！","提示");
			return;
		}
		get_userInfos.c_updaeUser();
	}
	//删除用户
	private function del_User():void{
		if(get_userInfos.user_infos.selectedItem == null){
			Alert.show("请先选择要删除的用户！","提示");
			return;
		}
		get_userInfos.c_delUser();
	}
	//将数据导出到excel表
	private function export_excel():void{
		con_UserMgr.UserExportEXCEL(labels,titles,getselectedUserModel());
	}
	private function faultCallBack(event:FaultEvent):void{
		Alert.show(event.message.toString(),"错误");
	}
	protected function con_UserMgr_resultHandler(event:ResultEvent):void
	{
		var url:String = Application.application.stage.loaderInfo.url;
		
		url=url.substring(0,url.lastIndexOf("/"))+"/";
		var path = url+event.result.toString();
		var request:URLRequest = new URLRequest(encodeURI(path)); 
		navigateToURL(request,"_blank");
	}
	public function changeState():void{
		if(queryVbox.visible){
			queryVbox.visible=!queryVbox.visible;
			queryCavas.width=30;
			PointIcon=PointLeft;
		}else{
			queryVbox.visible=!queryVbox.visible;
			queryCavas.width=261;
			PointIcon=PointRight;
		}
	}
	public function all_Reset():void{
		user_id.text="";
		user_name.text="";
		user_sex.text="";
		user_dept.text="";
		user_post.text="";
		telephone.text="";
		mobile.text="";
		email.text="";	
	}
	public function getselectedUserModel():UserModel{
		user_Model = new UserModel();
		user_Model.user_id=user_id.text;
		user_Model.user_name=user_name.text;
		user_Model.user_sex=user_sex.text;
		user_Model.user_dept=user_dept.text;
		user_Model.user_post=user_post.text;
		user_Model.telephone=telephone.text;
		user_Model.mobile=mobile.text;
		user_Model.email=email.text;
		user_Model.remark="";
		return user_Model;
	}
	public function user_selected():void{
		get_userInfos.selectUserInfos(getselectedUserModel());
	}