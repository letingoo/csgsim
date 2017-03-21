	// ActionScript file
	import common.actionscript.ModelLocator;
	import com.fusionwidgets.components.*;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	import sourceCode.systemManagement.model.UserModel;
	import sourceCode.systemManagement.views.comp.userAndRoleInfos;
	private var detailInfos:userAndRoleInfos = new userAndRoleInfos();
	import common.actionscript.MyPopupManager;
	
	import sourceCode.systemManagement.views.comp.User;
	import common.other.gauges.brightPoint.controls.*;
	[Bindable]
	private var dataXML:String ="";
	public function init():void{
		var size:int = parentApplication.acOnlineUser.length;
		dataXML= "<Chart bgColor='009999,333333' baseFontColor='000000'  baseFontSize='12' fillAngle='45' upperLimit='180' lowerLimit='0' majorTMNumber='10' majorTMHeight='8' showGaugeBorder='0' gaugeOuterRadius='180' gaugeOriginX='255' gaugeOriginY='306' gaugeInnerRadius='2' formatNumberScale='1' numberPrefix='' displayValueDistance='30' decimalPrecision='2' tickMarkDecimalPrecision='1' pivotRadius='17' showPivotBorder='1' pivotBorderColor='000000' pivotBorderThickness='5' pivotFillMix='FFFFFF,000000' >"
			    +  "<colorRange>"
			    +    "<color minValue='0' maxValue='90' code='399E38' />"
			    +    "<color minValue='90' maxValue='140' code='E48739' />"
			    +    "<color minValue='140' maxValue='180' code='B41527' />"
			    +  "</colorRange>"
			    +  "<dials>"
			    +    "<dial value='" +  size + "' showValue='1' borderAlpha='0' bgColor='000000' baseWidth='20' topWidth='1' radius='170' />"   
			    +  "</dials>"
			    +  "<annotations>"
                +    "<annotationGroup xPos='250' yPos='350' showBelow='1'>"
				+      "<annotation type='text' x='0' y='0' label='当前在线人数" + size + "' align='center' font='Arial' size='12' color='FFFFFF'/>"
				+    "</annotationGroup>" 
			    +  "</annotations>"
			    +"</Chart>";
        userContent.removeAllChildren();
		for(var i:int = 0; i < size; i++){
			var user:User = new User();
			user.usename = parentApplication.acOnlineUser[i].user_id;
			user.ip = "["+parentApplication.acOnlineUser[i].user_ip+"]";
			user.time="["+parentApplication.acOnlineUser[i].log_time+"]";
			userContent.addChild(user);
		}
	}
	public function doubleClickHandle(event:MouseEvent):void{
		if(event.target.parent.parent is User){
			var userId:String = User(event.target.parent.parent).usename;
			var to_rolesShow:RemoteObject=new RemoteObject("userManager");
			to_rolesShow.endpoint = ModelLocator.END_POINT;
			to_rolesShow.showBusyCursor = true;
			to_rolesShow.getroles(userId); 
			to_rolesShow.addEventListener(ResultEvent.RESULT,getRolesinfos);
			
			var to_user:RemoteObject=new RemoteObject("userManager");
			to_user.endpoint = ModelLocator.END_POINT;
			to_user.showBusyCursor = true;
			to_user.getUserInfoByUserId(userId); 
			to_user.addEventListener(ResultEvent.RESULT,getUserInfo);
		}
	}
	
	public function getUserInfo(event:ResultEvent):void{
		var user:UserModel = event.result as UserModel;
		MyPopupManager.addPopUp(detailInfos,true);
		detailInfos.user_id.text=user.user_id;
		detailInfos.user_name.text=user.user_name;
		detailInfos.user_sex.text=user.user_sex;
		detailInfos.user_dept.text=user.user_dept;
		detailInfos.user_post.text=user.user_post;
		detailInfos.birthday.text=user.birthday;
		detailInfos.telephone.text=user.telephone;
		detailInfos.address.text=user.address;
		detailInfos.mobile.text=user.mobile;
		detailInfos.education.text=user.education;
		
	}
	
	private function getRolesinfos(event:ResultEvent):void{
		var rolesInfos:String= String(event.result);
		detailInfos.forUserInfo=rolesInfos;
	}