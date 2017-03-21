package common.actionscript
{
	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	import common.actionscript.Registry;
	import common.other.events.LinkParameterEvent;
	
	import flash.display.DisplayObject;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.ui.ContextMenuItem;
	
	import mx.collections.ArrayCollection;
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	import org.flexunit.runner.Result;
	
	import sourceCode.alarmmgr.model.AlarmMangerModel;
	import sourceCode.alarmmgr.model.AlarmResultModel;
	import sourceCode.alarmmgr.views.AckAlarmLogTitle;
	import sourceCode.alarmmgr.views.AckRootAlarmTitle;
	import sourceCode.alarmmgr.views.AlarmConfirm;
	import sourceCode.alarmmgr.views.PopUpKeyBusiness;
	import sourceCode.flashalarm.ShowFlashAlarmDetail;
	import sourceCode.rootalarm.model.AckRootAlarmModel;
	import sourceCode.rootalarm.myAlert.AlertCanvas;
	import sourceCode.rootalarm.myAlert.AlertTip;
	import sourceCode.rootalarm.views.AlarmHelpEXP;
	import sourceCode.rootalarm.views.ChangToCompanyAlarm;
	import sourceCode.rootalarm.views.ChangeExistFault;
	import sourceCode.rootalarm.views.FollowAlarm;
	import sourceCode.rootalarm.views.RootAlarmDetails;
	import sourceCode.sysGraph.views.CarryOpera;
	import sourceCode.tableResurces.views.FileExportFirstStep;
	
	/**
	 * 告警处理邮件操作
	 *@author hjl
	 * @param alarms
	 * @return
	 */
	public class PopupMenu_AlarmDeal
	{
		public var parent:DisplayObject;
		public var customItems:Array;
		public var alarm:Object;
		public var alarmList:Array=new Array();
		public var getrootalarmdetail_itemMeau:ContextMenuItem;  //查询告警详细信息
		public var changeordinaryalarm_itemmeau:ContextMenuItem;  //转为普通告警
		public var getconcomitantalarm_itemMeau:ContextMenuItem;  //查看伴随告警
		public var getalarmexp_itemMeau:ContextMenuItem;  //查看告警处理经验
		public var getpsalarm_itemMeau:ContextMenuItem;  //查看频闪告警
		public var getbsalarm_itemMeau:ContextMenuItem;  //查看伴随告警
		public var toFaultHandlerContextItem:ContextMenuItem;//转故障流程
		public var toExistFaultContextItem:ContextMenuItem;//转故障流程
		public var getglalarm_itemMeau:ContextMenuItem;  //查看告警关联业务
		public var fixAlarmMeau:ContextMenuItem;  //定位告警
		public var delAlarmMeau:ContextMenuItem; //删除选择告警
		public var setAlarm_itemMeau:ContextMenuItem;//确认根告警 
		public var showAckAlarmLog:ContextMenuItem;//查看确认告警日志
		[Embed(source="assets/images/mntsubject/bubble-chat.png")] 
		private var iconClass:Class; 
		
		[Embed(source="assets/images/rootalarm/alarm_message.png")]
		public var AlarmIcon:Class; 
		
		public function get refreshFunction():Function
		{
			return _refreshFunction;
		}

		public function set refreshFunction(value:Function):void
		{
			_refreshFunction = value;
		}

		public function get saveProperty():Function
		{
			return _saveProperty;
		}

		public function set saveProperty(value:Function):void
		{
			_saveProperty = value;
		}

//		public function set callbackFunction(value:Function):void{
//			_callbackFunction = value;
//		}
//		
//		public function get callbackFunction():Function{
//			return _callbackFunction;
//		}
		
		private var _saveProperty:Function;
		public var _refreshFunction:Function;
		public var _callbackFunction:Function;
		public function PopupMenu_AlarmDeal()
		{
			setAlarm_itemMeau =new ContextMenuItem("编辑确认信息");
			setAlarm_itemMeau.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,alarmConfirm);
			
			toFaultHandlerContextItem = new ContextMenuItem("转故障处理流程");	
			toFaultHandlerContextItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,toFaultHandler);
			toExistFaultContextItem = new ContextMenuItem("转至已有故障");	
			toExistFaultContextItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,toExistFaultHandler);
			
			
			getbsalarm_itemMeau =new ContextMenuItem("转为伴随告警");
			getbsalarm_itemMeau.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,changAlarmBSOk);		
			
			getrootalarmdetail_itemMeau = new ContextMenuItem("查看告警详情");
			getrootalarmdetail_itemMeau.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,getRootAlarmDetail); 
			
			getconcomitantalarm_itemMeau =new ContextMenuItem("查看伴随告警");
			getconcomitantalarm_itemMeau.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,getAlarmBSOk);
			
			getpsalarm_itemMeau =new ContextMenuItem("查看频闪告警");
			getpsalarm_itemMeau.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,getAlarmPSOk);
			
			getalarmexp_itemMeau =new ContextMenuItem("查看处理经验");
			getalarmexp_itemMeau.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,getAlarmExpOk);
			
			getglalarm_itemMeau =new ContextMenuItem("查看影响电路");
			getglalarm_itemMeau.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,getAlarmGLOk);
			
			fixAlarmMeau =new ContextMenuItem("定位告警");
			fixAlarmMeau.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,getFixAlarm);
			
			delAlarmMeau =new ContextMenuItem("删除选中告警");
			delAlarmMeau.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,delFixAlarm);
			
			var carrycircuit:ContextMenuItem =new ContextMenuItem("查看承载业务");
			carrycircuit.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,getCarryCircuitLst);
			carrycircuit.visible=true;
			
			showAckAlarmLog = new ContextMenuItem("查看告警确认日志");
			showAckAlarmLog.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,getAckAlarmLog);
//			customItems = [setAlarm_itemMeau,getbsalarm_itemMeau,getrootalarmdetail_itemMeau,getconcomitantalarm_itemMeau,
//				getpsalarm_itemMeau,getalarmexp_itemMeau,getglalarm_itemMeau,showAckAlarmLog,fixAlarmMeau,carrycircuit,toFaultHandlerContextItem,toExistFaultContextItem
//			];
			customItems = [getrootalarmdetail_itemMeau,fixAlarmMeau,carrycircuit,delAlarmMeau];
		}
		
		public function setItemStatus():void{
			if(alarm!=null){
				if(alarm.flashcount=="0"){
					
					getpsalarm_itemMeau.enabled=false;
					
				}else{
					
					getpsalarm_itemMeau.enabled=true;
				}
				if(alarm.isrootalarmzh=="根告警"){
					
					setAlarm_itemMeau.enabled=true;//false
					getbsalarm_itemMeau.enabled=true;
				}else{
					
					setAlarm_itemMeau.enabled=true;
					getbsalarm_itemMeau.enabled=false;
				}
				if(alarm.isackedzh=="已确认"){
					showAckAlarmLog.enabled=true;
				}else{
					showAckAlarmLog.enabled=false;
				}
				if(Boolean(Registry.lookup("curUserEnable"))){
					toFaultHandlerContextItem.enabled = true;
					toExistFaultContextItem.enabled = true;						
					setAlarm_itemMeau.enabled = true;
					getbsalarm_itemMeau.enabled = true;
				}else{
					toFaultHandlerContextItem.enabled = false;
					toExistFaultContextItem.enabled = false;							
					setAlarm_itemMeau.enabled = false;
					getbsalarm_itemMeau.enabled = false;
				}
			}
			if(alarmList.length>1){
				setAlarm_itemMeau.visible=false;
				getbsalarm_itemMeau.visible=false;
				getrootalarmdetail_itemMeau.visible=false;
				getconcomitantalarm_itemMeau.visible=false;
				getpsalarm_itemMeau.visible=false;
				getalarmexp_itemMeau.visible=false;
				getglalarm_itemMeau.visible=false;
				showAckAlarmLog.visible=false;
				fixAlarmMeau.visible=false;
				toFaultHandlerContextItem.visible=true;
				toExistFaultContextItem.visible=true;
			}else{
				setAlarm_itemMeau.visible=true;
				getbsalarm_itemMeau.visible=true;
				getrootalarmdetail_itemMeau.visible=true;
				getconcomitantalarm_itemMeau.visible=true;
				getpsalarm_itemMeau.visible=true;
				getalarmexp_itemMeau.visible=true;
				getglalarm_itemMeau.visible=true;
				showAckAlarmLog.visible=true;
				fixAlarmMeau.visible=true;
				toFaultHandlerContextItem.visible=true;
				toExistFaultContextItem.visible=true;
			}
			
		}
		
		//告警确认
		private function alarmConfirm (event:ContextMenuEvent) :void{
			var ackRoot:AckRootAlarmTitle = new AckRootAlarmTitle();
			ackRoot.alarmnumber = alarm.alarmnumber;
			ackRoot.isackedzh=alarm.isackedzh;
			ackRoot.dealresult=alarm.dealresult;
			ackRoot.isworkcase=alarm.isworkcase;	
			ackRoot.ackcontent=alarm.ackcontent;	
			PopUpManager.addPopUp(ackRoot,parent,true);
			PopUpManager.centerPopUp(ackRoot);
			if(_refreshFunction!=null){
				ackRoot.addEventListener("ackrootEvent",_refreshFunction);
			}
		}
		
		
		//转故障流程处理
		var alert:AlertCanvas;
		private function toFaultHandler(e:ContextMenuEvent):void{
			var ac:ArrayCollection = new ArrayCollection();
			if(alarmList.length!=0){
				for(var i:int=0;i<alarmList.length;i++){
					var alarmNo:AckRootAlarmModel = new AckRootAlarmModel();
					alarmNo.alarmnumber = alarmList[i].alarmnumber;	
					if(alarmList[i].bugno==null||alarmList[i].bugno==""){
						ac.addItem(alarmNo);	
					}
				}
			}else{
				var alarmNo:AckRootAlarmModel = new AckRootAlarmModel();
				alarmNo.alarmnumber = alarm.alarmnumber;	
				if(alarm.bugno==null||alarm.bugno==""){
					ac.addItem(alarmNo);	
				}
			}
			
			
			if(ac.length==0){
				Alert.show("该告警已经转故障处理了","温馨提示");
			}/* else if(ac.length<alarms.length){
				Alert.show("选中的告警中已有转故障处理的了");
				} */
			else{
				toFault(ac);
			}
		}
		
		private function toFault(ac:ArrayCollection):void{
			alert = AlertTip.show(parent.height-28,parent.width,"正在转处理流程中，请稍后……", 
				100,false,{style:"AlertTip"},null,true);
			var obj:RemoteObject = new RemoteObject("RealRootAlarmDwr");
			obj.endpoint = ModelLocator.END_POINT;
			obj.showBusyCursor = true;
			obj.toFaultHandler(ac,"1");
			obj.addEventListener(ResultEvent.RESULT,toFaultHandlerResult);	
		}
		private function toFaultHandlerResult(e:ResultEvent):void{
			if(e.result.toString()=="ok"){
				//					Alert.show("转处理流程成功","温馨提示");
				//					AlertCanvas(alert).visible_ = false;
				alert.msg = "转处理流程成功";
				alert.visible  = false;
			}else{
				Alert.show("转处理流程失败，请联系管理员！","温馨提示");
				alert.visible  = false;
			}
		}
		var changeexistfault:ChangeExistFault;
		private function toExistFaultHandler(e:ContextMenuEvent):void{
			var ac:ArrayCollection = new ArrayCollection();
			if(alarmList.length==0){
				alarmList.push(alarm);
			}
			changeexistfault=new ChangeExistFault();
			changeexistfault.addEventListener("AfterChangeExist", afterChangeExist);
			MyPopupManager.addPopUp(changeexistfault, true); 
		}
		private function afterChangeExist(event:LinkParameterEvent):void
		{
			var dutyid:String=event.parameter.toString();
			var ac:ArrayCollection = new ArrayCollection();
			if(alarmList.length!=0){
				for(var i:int=0;i<alarmList.length;i++){
					var alarmNo:AckRootAlarmModel = new AckRootAlarmModel();
					alarmNo.alarmnumber = alarmList[i].alarmnumber;	
					ac.addItem(alarmNo);	
				}
				toExistFault(ac,dutyid);
			}
		}
		private function toExistFault(ac:ArrayCollection,dutyid:String):void{
			alert = AlertTip.show(parent.height-28,parent.width,"正在转至已有故障，请稍后……", 
				100,false,{style:"AlertTip"},null,true);
			var obj:RemoteObject = new RemoteObject("RealRootAlarmDwr");
			obj.endpoint = ModelLocator.END_POINT;
			obj.showBusyCursor = true;
			obj.toExistFaultHandler(ac,dutyid);
			obj.addEventListener(ResultEvent.RESULT,toExistFaultHandlerResult);	
		}
		private function toExistFaultHandlerResult(e:ResultEvent):void{
			if(e.result.toString()=="ok"){
				alert.msg = "转至已有故障成功";
				alert.visible  = false;
			}else{
				Alert.show("转至已有故障失败，请联系管理员！","温馨提示");
				alert.visible  = false;
			}
		}

		//转伴随告警
		private function changAlarmBSOk (event:ContextMenuEvent) :void{
			
			var rootalarmlist:ChangToCompanyAlarm =new ChangToCompanyAlarm();
//			rootalarmlist.owner=parent;
			rootalarmlist.alarmid=alarm.alarmnumber;
			PopUpManager.addPopUp(rootalarmlist,parent,true);
			PopUpManager.centerPopUp(rootalarmlist);
			
		}
		//查询告警详细信息
		private function getRootAlarmDetail(event:ContextMenuEvent):void{
			
			var showDetail:RootAlarmDetails= new RootAlarmDetails();
			showDetail.obj = alarm;
			PopUpManager.addPopUp(showDetail,parent,true);
			PopUpManager.centerPopUp(showDetail);
			
		}
		//查看伴随告警
		private function getAlarmBSOk (event:ContextMenuEvent) :void{
			
			var bsalarm:FollowAlarm=new FollowAlarm();
			bsalarm.alarmNum=alarm.alarmnumber;
			PopUpManager.addPopUp(bsalarm,parent,true); 
			PopUpManager.centerPopUp(bsalarm);
			
		}
		private var rootAlarmWin:TitleWindow;
		private var alarmHelpEXP:TitleWindow;
		//查看频闪告警
		private function getAlarmPSOk (event:ContextMenuEvent) :void{
			
			rootAlarmWin =new TitleWindow();
			rootAlarmWin.layout="absolute";
			rootAlarmWin.x=0;
			rootAlarmWin.y=0;
			
			rootAlarmWin.styleName="popwindow";
			rootAlarmWin.showCloseButton="true";
			rootAlarmWin.title="频闪告警分析";
			rootAlarmWin.titleIcon=AlarmIcon;
			var ram:ShowFlashAlarmDetail = new ShowFlashAlarmDetail();
			ram.alarmNumber = alarm.alarmnumber;
			rootAlarmWin.addEventListener(CloseEvent.CLOSE,rootAlarmWinClose);
			rootAlarmWin.addChild(ram);
			PopUpManager.addPopUp(rootAlarmWin,main(Application.application),true);
			PopUpManager.centerPopUp(rootAlarmWin);
			
			
		}
		
		private function rootAlarmWinClose(evt:CloseEvent):void{
			PopUpManager.removePopUp(rootAlarmWin);
		}
		
		
		//查看告警处理经验
		private function getAlarmExpOk (event:ContextMenuEvent) :void{
			
			alarmHelpEXP =new TitleWindow();
			alarmHelpEXP.layout="absolute";
			alarmHelpEXP.x=0;
			alarmHelpEXP.y=0;
			alarmHelpEXP.width=Capabilities.screenResolutionX-50;
			alarmHelpEXP.height=Capabilities.screenResolutionY-250;
			alarmHelpEXP.styleName="popwindow";
			alarmHelpEXP.showCloseButton="true";
			alarmHelpEXP.title="告警处理经验维护";
			var transAlarmHelpDisplay:AlarmHelpEXP = new AlarmHelpEXP();	
			transAlarmHelpDisplay.vendor=alarm.vendor;
			transAlarmHelpDisplay.alarmtext=alarm.alarmdesc;
			alarmHelpEXP.addEventListener(CloseEvent.CLOSE,alarmHelpEXPClose);
			alarmHelpEXP.addChild(transAlarmHelpDisplay);
			PopUpManager.addPopUp(alarmHelpEXP,main(Application.application),true);
			PopUpManager.centerPopUp(alarmHelpEXP);
		}
		//查看告警关联业务
		private function getAlarmGLOk (event:ContextMenuEvent) :void{
			var keybusiness:PopUpKeyBusiness =new PopUpKeyBusiness();
			keybusiness.circuitname =""  ; 
			keybusiness.isacked = "";
			keybusiness.alarmnumber=alarm.alarmnumber;
			PopUpManager.addPopUp(keybusiness,parent,true);
			PopUpManager.centerPopUp(keybusiness);
			
		}
		//查看告警确认日志add by sjt
		private function getAckAlarmLog(e:ContextMenuEvent):void{
			var acklog:AckAlarmLogTitle = new AckAlarmLogTitle();
			acklog.alarmnumber = alarm.alarmnumber;
			PopUpManager.addPopUp(acklog,parent,true);
			PopUpManager.centerPopUp(acklog);
		}
		
		//查询承载业务列表
		private function getCarryCircuitLst(event:ContextMenuEvent):void{
			var alarmObj=alarm.objclasszh;
			var type:String="";
			var code:String="";
			if(alarmObj!=null && alarmObj!=""){
				if(alarmObj=="端口"){
					//
					type="logicport";
					code=alarm.belongportcode;
				}else if(alarmObj=="设备"){
					//
					type="equipment";
					code=alarm.belongequip;
				}else if(alarmObj=="机盘"){
					type="equippack";
					var strport:String=alarm.belongpackobject;
					if(strport!=null && strport!=""){
						var strarray:Array=strport.split("=");
						strport="";
						for(var i:int=0;i<strarray.length;i++)
						{  
							if(i!=strarray.length-1)
								strport+=strarray[i]+",";
							else
								strport+=strarray[i];
						}
					}
					code=strport;
				}else if(alarmObj=="时隙"){
					var strslot:String = alarm.alarmobject;
					if(strslot!=""&&strslot!=null){
						var strarray:Array=strslot.split("=");
						if(strarray.length==7){
							code=alarm.belongportcode+","+strarray[5];
							type="timeslot";
						}
					}
				}
				
				var carryOpera:CarryOpera=new CarryOpera();
				carryOpera.title="设备承载业务";
				carryOpera.getOperaByCodeAndType(code,type);
				MyPopupManager.addPopUp(carryOpera);
			}else{
				Alert.show("当前无法查看承载业务","提示");
			}
		}
		
		//删除告警
		private function delFixAlarm(event:ContextMenuEvent):void{
			var alarmNum = alarm.alarmnumber;
			var rtobj:RemoteObject=new RemoteObject("AlarmManagerComboboxDwr");
			rtobj.endpoint= ModelLocator.END_POINT;
			rtobj.showBusyCursor=true;
			rtobj.delAlarmInfos(alarmNum);        //表格加载数据
			rtobj.addEventListener(ResultEvent.RESULT,delAllAlarmInfoHandler);
		}
		
		private function delAllAlarmInfoHandler(event:ResultEvent):void{
			if("SUCCESS"==event.result.toString()){
				_callbackFunction.call(parent,event);
			}
		}
		
		//定位到告警
		private function getFixAlarm (event:ContextMenuEvent) :void{
			
			var alarmObj=alarm.objclasszh;
			if(alarmObj!=null && alarmObj!=""){
				if(alarmObj=="时隙" || alarmObj=="端口")
				{
					var strport:String=alarm.belongportobject;
					if(strport!=null && strport!=""){
						var strarray:Array=strport.split("=");
						strport="";
						for(var i:int=0;i<strarray.length;i++)
						{  
							if(i!=strarray.length-1)
								strport+=strarray[i]+",";
							else
								strport+=strarray[i];
						}
						//如果当前已打开，关闭再重开,并让告警呈现复选框选中
						var openFlag:Boolean = Application.application.isOpen("机盘管理视图");
						if(!openFlag){
							//已打开
							Application.application.closeModel("机盘管理视图");
						}
						Registry.register("packcode", strport);
						Registry.register("portcode", alarm.belongportcode);
						Application.application.openModel("机盘管理视图", false);
					}
				}	else if(alarmObj=="机盘"){
					
					var strport:String=alarm.belongpackobject;
					if(strport!=null && strport!=""){
						var strarray:Array=strport.split("=");
						strport="";
						for(var i:int=0;i<strarray.length;i++)
						{  
							if(i!=strarray.length-1)
								strport+=strarray[i]+",";
							else
								strport+=strarray[i];
						}
					}
					var rt:RemoteObject=new RemoteObject("devicePanel");
					rt.endpoint = ModelLocator.END_POINT;
					rt.showBusyCursor = true;
					rt.addEventListener(ResultEvent.RESULT,function(e:ResultEvent):void{
						var slotdirc:String="0";
						if("success"==e.result.toString()){
							slotdirc = "1";//表示反面
						}
						//如果当前已打开，关闭再重开,并让告警呈现复选框选中
						var openFlag:Boolean = Application.application.isOpen("设备面板图");
						if(!openFlag){
							//已打开
							Application.application.closeModel("设备面板图");
						}
						Registry.register("packcode", strport);
						Registry.register("systemcode", alarm.belongtransys);
						Registry.register("equipcode", alarm.belongequip);
						Registry.register("slotdir", slotdirc);
						Application.application.openModel("设备面板图", false);
					} );
					rt.getSlotDirectionByIds(strport);//查询时正面还是反面
					
				}else if(alarmObj=="设备"){
					//如果当前已打开，关闭再重开,并让告警呈现复选框选中  改为仿真拓扑图
					var openFlag:Boolean = Application.application.isOpen("网络拓扑图");
					if(!openFlag){
						//已打开
						Application.application.closeModel("网络拓扑图");
					}
					Registry.register("systemcode",alarm.belongtransys);
					Registry.register("equipcode",alarm.belongequip);
					Application.application.showSysGraphAlarm=true;
					Application.application.openModel("网络拓扑图", false);
//				    Application.application.sysOrgMap.setAlarmShow();
				}else{
					Alert.show("无法定位该告警，请确定该告警类型","提示信息",4,null,null,iconClass);
				}
				
			}else{
				Alert.show("无法定位该告警，请确定该告警类型","提示信息",4,null,null,iconClass);
			}
			
		}
		
		private function alarmHelpEXPClose(evt:CloseEvent):void{
			PopUpManager.removePopUp(alarmHelpEXP);
		}
		
		
		
	}
}