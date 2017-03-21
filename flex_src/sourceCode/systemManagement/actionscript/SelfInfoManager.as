	// ActionScript file
	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	import common.other.SuperPanelControl.nl.wv.extenders.panel.PanelWindow;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	import sourceCode.systemManagement.events.DeptParameterEvent;
	import sourceCode.systemManagement.model.UserModel;
	import sourceCode.systemManagement.views.comp.DeptTree;
	
	[Bindable]
	private var user_Model:UserModel;
	private var editedModel:UserModel;
	private var editresult:String;
	
	public function get userModel():UserModel{
		return user_Model;
	}
	
	public function set userModel(model:UserModel):void{
		this.user_Model = model;
	}
	
	private function getSelInfos(event:ResultEvent):void{  
		userModel = UserModel(event.result);
	}
	private function faultCallBack(event:FaultEvent):void{
		Alert.show(event.message.toString(),"错误");
	}
	
	private function user_save():void  
	{   
		editedModel = new UserModel();
		editedModel.user_id=user_id.text.toString();
		editedModel.user_name=user_name.text.toString();
		editedModel.user_pwd=user_pwd.text.toString();
		editedModel.user_sex=user_sex.selection.value.toString();
		editedModel.user_dept=this.user_Model.user_deptcode;
		editedModel.user_post=user_post.text.toString();
		editedModel.birthday=birthday.text.toString();
		editedModel.education=education.text.toString();
		editedModel.telephone=telephone.text.toString();
		editedModel.mobile=mobile.text.toString();
		editedModel.email=email.text.toString();
		editedModel.address=address.text.toString();
		editedModel.remark="";
		var objedit:RemoteObject = new RemoteObject("userManager");
		objedit.showBusyCursor = true;
		objedit.endpoint = ModelLocator.END_POINT;
		objedit.addEventListener(ResultEvent.RESULT,editResult);
		if(editedModel.user_name==""){
			Alert.show("真实姓名不能为空！","提示");
		}else if(editedModel.user_name!=""){
			editedModel.user_name=editedModel.user_name.replace( /^\s*/, "");
			editedModel.user_name=editedModel.user_name.replace( /\s*$/, "");
			if(editedModel.user_name.length>200){
				Alert.show("真实姓名长度大于最大长度限制，最大长度为200个字符，请重新输入！","提示");
			}else if(editedModel.user_pwd==""){
				Alert.show("密码不能为空！","提示");
			}else if(editedModel.user_pwd!=""){
				editedModel.user_pwd=editedModel.user_pwd.replace( /^\s*/, "");
				editedModel.user_pwd=editedModel.user_pwd.replace( /\s*$/, "");
				if(editedModel.user_pwd.length>30){
					Alert.show("密码长度大于最大长度限制，最大长度为30个字符，请重新输入！","提示");
				}else{
					if(editedModel.email!=""){
						editedModel.email=editedModel.email.replace( /^\s*/, "");
						editedModel.email=editedModel.email.replace( /\s*$/, "");
						if(editedModel.email.length>100){
							Alert.show("邮箱长度大于最大长度限制，最大长度为100个字符，请重新输入！","提示");
						}else{
							if(editedModel.email!=""){
								if (editedModel.email.search(/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/) == -1){ 
									Alert.show("请输入正确的邮箱格式！","提示");
								}else{
									objedit.editUser(editedModel);
								}
							}
							else{
								objedit.editUser(editedModel);
							}
						}
					}
					else{
						objedit.editUser(editedModel);
					}
				}
			}
		}
	} 
	private function editResult(event:ResultEvent):void{  
		editresult = event.result.toString();
		if(editresult=="editsuccess"){					
			Alert.show("信息修改成功！","提示");
			close();
		}else if(editresult=="editfailed"){
			Alert.show("信息修改失败！","提示");
		}
	}
	
	protected function init():void{
		selInfoMgr.getUserInfoByUserId(parentApplication.curUser);
	}
	
	private function close():void{
		PanelWindow(this.parent).closeButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}
public function dbClickDept(event:MouseEvent):void
{
	var deptsTree:DeptTree=new DeptTree();	
	MyPopupManager.addPopUp(deptsTree, true);
	deptsTree.addEventListener("departmentEvent",departmentSearchHandler);	
	
}
public function departmentSearchHandler(event:DeptParameterEvent):void
{
	this.user_Model.user_deptcode=event.dept_code;
	this.user_Model.user_dept=event.dept_name;
}