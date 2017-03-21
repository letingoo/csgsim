	// ActionScript file
	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	import common.other.SuperPanelControl.nl.wv.extenders.panel.PanelWindow;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.effects.easing.Bounce;
	import mx.events.CloseEvent;
	import mx.formatters.DateFormatter;
	import mx.formatters.Formatter;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	import sourceCode.systemManagement.events.DeptParameterEvent;
	import sourceCode.systemManagement.model.UserModel;
	import sourceCode.systemManagement.views.UserManager;
	import sourceCode.systemManagement.views.comp.CheckDeptTree;
	import sourceCode.systemManagement.views.comp.DeptTree;
	
	[Bindable]					
	private var limitmanager:limitManager;
	[Bindable]
	public var doType:String;
	[Bindable]
	public var checkdo:Boolean;
	[Bindable]
	public var checkroledo:Boolean;
	[Bindable]
	private var user_Model:UserModel;
	[Bindable]
	private var roleInformations:String;
	public var refreshUser:UserManager;
	public var refreshRoleinfos:PaginationDataGrid;
	[Bindable]
	private var configOperateObject:ConfigOperate;
	[Bindable]
	private var departMentInfo:String;
    public var departMentCodes:Array=new Array();
	public var user_deptcode:String;
	public var operateDepart:ArrayCollection = new ArrayCollection();
	
	public function get roleInfor():String{
		return roleInformations;
	}
	
	public function set roleInfor(roles:String):void{
		this.roleInformations = roles;
		
	} 
	
	public function get departInformation():String{
		return departMentInfo;
	}
	
	public function set departInformation(depart:String):void{
		this.departMentInfo = depart;
		
	} 
	
	public function get userModel():UserModel{
		return user_Model;
	}
	
	public function set userModel(model:UserModel):void{
		this.user_Model = model;
		
	} 
	
	private function close():void{  
		userInfosReset();
		PanelWindow(this.parent).closeButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK,false,false));
	} 
	
	public function userInfosReset():void{
		user_id.text="";
		user_name.text="";
		user_pwd.text="";
		user_dept.text="";
		user_post.text="";
		birthday.text="";
		education.text="";
		telephone.text="";
		mobile.text="";
		email.text="";
		address.text="";
	}
	
	private function user_save(doType:String):void  
	{   
		var objedit:RemoteObject = new RemoteObject("userManager");
		objedit.showBusyCursor = true;
		objedit.endpoint = ModelLocator.END_POINT;
		objedit.addEventListener(ResultEvent.RESULT,editResult);
		//parentApplication.faultEventHandler(objedit);
		
		var objadd:RemoteObject = new RemoteObject("userManager");
		objadd.showBusyCursor = true;
		objadd.endpoint = ModelLocator.END_POINT;
		objadd.addEventListener(ResultEvent.RESULT,addResult);
		//parentApplication.faultEventHandler(objadd);
		
		user_Model = new UserModel();
		user_Model.user_id=user_id.text.toString();
		user_Model.user_name=user_name.text.toString();
		user_Model.user_pwd=user_pwd.text.toString();
		user_Model.user_sex=user_sex.selectedValue.toString();
		if(user_deptcode==null){
			Alert.show("请选择所属单位！");
		 return;
		}
		user_Model.user_dept=user_deptcode;
	
		user_Model.user_post=user_post.text.toString();
		user_Model.birthday=birthday.text.toString();
		user_Model.education=education.text.toString();
		user_Model.telephone=telephone.text.toString();
		user_Model.mobile=mobile.text.toString();
		user_Model.email=email.text.toString();
		user_Model.address=address.text.toString();
		user_Model.remark="";
		if(doType=="edit"){
			if(user_Model.user_name==""){
				Alert.show("真实姓名不能为空！","提示");
			}else if(user_Model.user_name!=""){
				user_Model.user_name=user_Model.user_name.replace( /^\s*/, "");
				user_Model.user_name=user_Model.user_name.replace( /\s*$/, "");
				if(user_Model.user_name.length>200){
					Alert.show("真实姓名长度大于最大长度限制，最大长度为200个字符，请重新输入！","提示");
				}else if(user_Model.user_pwd==""){
					Alert.show("密码不能为空！","提示");
				}else if(user_Model.user_pwd!=""){
					user_Model.user_pwd=user_Model.user_pwd.replace( /^\s*/, "");
					user_Model.user_pwd=user_Model.user_pwd.replace( /\s*$/, "");
					if(user_Model.user_pwd.length>30){
						Alert.show("密码长度大于最大长度限制，最大长度为30个字符，请重新输入！","提示");
					}else{
						if(user_Model.email!=""){
							user_Model.email=user_Model.email.replace( /^\s*/, "");
							user_Model.email=user_Model.email.replace( /\s*$/, "");
							if(user_Model.email.length>100){
								Alert.show("邮箱长度大于最大长度限制，最大长度为100个字符，请重新输入！","提示");
							}
								//不为空时判断邮箱格式。
							else if(user_Model.email!=""){
								if (user_Model.email.search(/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/) == -1){ 
									Alert.show("请输入正确的邮箱格式！","提示");
								}else{
									objedit.editUser(user_Model);
									//														close();
								}
							}else{
								objedit.editUser(user_Model);
								//													close();
							}
						}else{
							objedit.editUser(user_Model);
							//											close();
						}
						
					} 
				}
			}
		}else{
			//新增用户数据验证。
			if(user_Model.user_id==""){
				Alert.show("用户名不能为空！","提示");
			}else{
				if(user_Model.user_id!=""){
					user_Model.user_id=user_Model.user_id.replace( /^\s*/, "");
					user_Model.user_id=user_Model.user_id.replace( /\s*$/, "");
					if(user_Model.user_id.length>100){
						Alert.show("用户名大于最大长度限制，最大长度为100位字符，请重新输入！","提示");
					}else if(user_Model.user_name==""){
						Alert.show("真实姓名不能为空！","提示");
					}else if(user_Model.user_name!=""){
						user_Model.user_name=user_Model.user_name.replace( /^\s*/, "");
						user_Model.user_name=user_Model.user_name.replace( /\s*$/, "");
						if(user_Model.user_name.length>200){
							Alert.show("真实姓名长度大于最大长度限制，最大长度为200个字符，请重新输入！","提示");
						}else if(user_Model.user_pwd==""){
							Alert.show("密码不能为空！","提示");
						}else if(user_Model.user_pwd!=""){
							user_Model.user_pwd=user_Model.user_pwd.replace( /^\s*/, "");
							user_Model.user_pwd=user_Model.user_pwd.replace( /\s*$/, "");
							if(user_Model.user_pwd.length>30){
								Alert.show("密码长度大于最大长度限制，最大长度为30个字符，请重新输入！","提示");
							}else{
								if(user_Model.email!=""){
									user_Model.email=user_Model.email.replace( /^\s*/, "");
									user_Model.email=user_Model.email.replace( /\s*$/, "");
									if(user_Model.email.length>100){
										Alert.show("邮箱长度大于最大长度限制，最大长度为100个字符，请重新输入！","提示");
									}
										//不为空时判断邮箱格式。
									else if(user_Model.email!=""){
										if (user_Model.email.search(/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/) == -1){ 
											Alert.show("请输入正确的邮箱格式！");
										}else{
											objadd.addUser(user_Model);
											//													close();
										}
									}else{
										Alert.show("请输入正确的邮箱格式！，不能为空格。","提示");
									}
								}else{
									objadd.addUser(user_Model);
									//											close();
								}
								
							} 
						}
					}
				}
			}
		}
		//数据刷新
		
	}  	
	private function editResult(event:ResultEvent):void{
		var resultString:String;
		resultString=event.result.toString();
		if(resultString=="editsuccess"){					
			Alert.show("用户信息修改成功！","提示");
			refreshUser.user_selected();
		}
		if(resultString=="editfailed"){
			Alert.show("用户信息修改失败！","提示");
		}
		
		
	}
	private function addResult(event:ResultEvent):void{
		var resultString:String;
		resultString=event.result.toString();
		if(resultString=="addsuccess"){
			Alert.show("用户添加成功！","提示");
			refreshUser.user_selected();
		}
		if(resultString=="addfailed"){
			Alert.show("用户添加失败！","提示");
		}
	}
	
	private function resultCallBack(event:ResultEvent):void{
		//				close();
		parentDocument.roUserMgr.getUserInfos();
	}
	private function rights_save():void  
	{  
		limitmanager = new limitManager();
		limitmanager.userid=user_id.text;
		limitmanager.refreshRoleinfos = this.refreshRoleinfos;
		PopUpManager.addPopUp(limitmanager, this.parent, true);  
		PopUpManager.centerPopUp(limitmanager); 
		//				close();
	} 
	private function saveToConfigOperate():void{

		
		var deptsTree:CheckDeptTree=new CheckDeptTree();
		deptsTree.page_parent = this;
		deptsTree.user_id=user_id.text.toString();
//		deptsTree.setValue(this.departMentCodes);
		deptsTree.addEventListener("SaveDept",saveDeptHandler);
		MyPopupManager.addPopUp(deptsTree, true);
	}

	private function saveDeptHandler(event:Event):void{
		var changeDepartsObject:RemoteObject = new RemoteObject("userManager");
		changeDepartsObject.endpoint = ModelLocator.END_POINT;
		changeDepartsObject.addEventListener(ResultEvent.RESULT,resultString);
		//parentApplication.faultEventHandler(changeDepartsObject);
		changeDepartsObject.departChanged(user_id.text,operateDepart);
	}

	private function resultString(event:ResultEvent):void{
		var resultStr:String = event.result as String;
		if(resultStr=="setSuccess"){
			refreshRoleinfos.to_depart.getDepartIfos(user_id.text);
			Alert.show("配置成功","提示");
		}else{
			Alert.show("配置失败，请确认用户是否还存在！","提示");
		}
	}

	public function dbClickDept(event:MouseEvent):void
	{
		var deptsTree:DeptTree=new DeptTree();	
		MyPopupManager.addPopUp(deptsTree, true);
		deptsTree.addEventListener("departmentEvent",departmentSearchHandler);	
		
	}
	public function departmentSearchHandler(event:DeptParameterEvent):void
	{
		this.user_deptcode=event.dept_code;
		this.user_dept.text=event.dept_name;
	}