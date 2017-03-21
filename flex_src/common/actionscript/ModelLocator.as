package common.actionscript
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.controls.Tree;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.events.ListEvent;
	import mx.managers.BrowserManager;
	import mx.managers.IBrowserManager;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	import sourceCode.systemManagement.model.PermissionControlModel;
	
	import twaver.AlarmSeverity;

	public class ModelLocator
	{
		public function ModelLocator(){}
		
		private static var modelLocator:ModelLocator;
		
		public static function getInstance():ModelLocator{
			if(modelLocator == null)
				modelLocator = new ModelLocator();
			return modelLocator;
		}
		
		public static var tempNum:int = 1;
		
		public static const END_POINT : String = getContext()+"/messagebroker/amf/";
          
		public static var permissionList:Array = null;
		
		public static const ROOM_ATTACHMENT_FOLDER:String = "/roomAttachment/";
		public static const POWER_ATTACHMENT_FOLDER:String = "/powerAttachment/";

		
		[Embed('assets/images/help.png')]
		public static const help:Class;
		
		[Embed('assets/images/c-s-d.png')]
		public static const csd:Class;
		
		[Embed('assets/images/btn/newOneWay.png')]
		public static const newOneWay:Class;
		
		[Embed('assets/images/btn/back.png')]
		public static const backIcon:Class;
		
		[Embed('assets/images/btn/search.png')]
		public static const searchIcon:Class;
		
		[Embed('assets/images/icons/fam/addshortcut.png')]
		public static const addshortcutIcon:Class;
		
		[Embed('assets/images/icons/fam/delshortcut.png')]
		public static const delshortcutIcon:Class;
		
		[Embed('assets/images/sysManager/roleMgr.png')]
		public static const addUserIcon:Class;
		
		[Embed(source="assets/images/sysManager/plugin.gif")]
		public static const funcIcon:Class;
		
		[Embed(source="assets/images/file/fileOpen.gif")]
		public static const openIcon:Class; 
		
		[Embed(source="assets/images/file/fileClose.gif")]
		public static const closeIcon:Class;
		
		[Embed(source="assets/images/icons/fam/user.gif")]
		public static const userIcon:Class;
		
		// 电源接线图
		[Embed(source="assets/images/power/acbackup.png")]
		public static const acbackup:Class;
		[Embed(source="assets/images/power/acboard.png")]
		public static const acboard:Class;
		[Embed(source="assets/images/power/allbackup.png")]
		public static const allbackup:Class;
		[Embed(source="assets/images/power/allshow.jpg")]
		public static const allshow:Class;
		[Embed(source="assets/images/power/battery.png")]
		public static const battery:Class;
		[Embed(source="assets/images/power/dcboard.png")]
		public static const dcboard:Class;
		[Embed(source="assets/images/power/dcwordbackup.png")]
		public static const dcwordbackup:Class;
		[Embed(source="assets/images/power/domain.png")]
		public static const domain:Class;
		[Embed(source="assets/images/power/equipbackup.png")]
		public static const equipbackup:Class;
		[Embed(source="assets/images/power/switchclose.png")]
		public static const switchclose:Class;
		[Embed(source="assets/images/power/switchopen.png")]
		public static const switchopen:Class;
		[Embed(source="assets/images/power/sun.png")]
		public static const sun:Class;
		[Embed(source="assets/images/power/station.png")]
		public static const station:Class;
		[Embed(source="assets/images/power/province.png")]
		public static const province:Class;
		[Embed(source="assets/images/power/power.png")]
		public static const power:Class;
		[Embed(source="assets/images/power/switchbackup.png")]
		public static const switchbackup:Class;
		[Embed(source="assets/images/power/sunbackup.png")]
		public static const sunbackup:Class;
		[Embed(source="assets/images/power/batterybackup.png")]
		public static const batterybackup:Class;
		[Embed(source="assets/images/power/supply.png")]
		public static const supply:Class;
		
		
		
		[Embed(source="assets/images/operatopo/safecon.png")]
		public static const safecon:Class;
		[Embed(source="assets/images/operatopo/fileOpen.gif")]
		public static const fileOpen:Class;
		
		[Embed(source="assets/images/operatopo/fileClose.gif")]
		public static const fileClose:Class;
		[Embed(source="assets/images/operatopo/moderes.png")]
		public static const moderes:Class;
		
		[Embed(source="assets/images/device/port.png")]
		public static const port:Class;
		
		//系统组织图
		[Embed(source="assets/images/sysorg.png")]          //这是图片的相对地址 		
		public static const systemIcon:Class; 		
		[Embed(source="assets/images/device/equipment.png")]
		public static const equipIcon:Class;
		
		
		[Embed(source='assets/images/portalarm1.png')]   
		public static const portalarm1:Class;
		
		[Embed(source='assets/images/portalarm2.png')]   
		public static const portalarm2:Class;
		
		
//		[Embed(source="assets/images/device/ZY0801-OSU.png")]
//		public static const ZY0801$OSU:Class;
//		
//		[Embed(source="assets/images/device/ZY0801.png")]
//		public static const ZY0801:Class;
//		[Embed(source="assets/images/device/ZY0801-FT0102.swf")]
//		public static const ZY0801$FT0102:Class;		
//		[Embed(source="assets/images/device/ZY0801-FT010213.swf")]
//		public static const ZY0801$FT010213:Class;
//		[Embed(source="assets/images/device/ZY0801-IT1.png")]
//		public static const ZY0801$IT1:Class;
//		
//
//		[Embed(source="assets/images/device/ZY0801-ONU-128A.png")]
//		public static const ZY0801$ONU$128A:Class;
//		[Embed(source="assets/images/device/ZY0801-OptiX155622.swf")]
//		public static const ZY0801$OptiX155622:Class;
//		[Embed(source="assets/images/device/ZY0801-OptiX155622H.swf")]
//		public static const ZY0801$OptiX155622H:Class;
//		
//		[Embed(source="assets/images/device/ZY0801-OptiX2500+.swf")]
//		public static const ZY0801$OptiX2500$:Class;
//		[Embed(source="assets/images/device/ZY0801-ONU-F02A.swf")]
//		public static const ZY0801$ONU$F02A:Class;
//		[Embed(source="assets/images/device/ZY0801-OptiXMetro1000V3.swf")]
//		public static const ZY0801$OptiXMetro1000V3:Class;
//		[Embed(source="assets/images/device/ZY0801-OptiXMetro1050B.swf")]
//		public static const ZY0801$OptiXMetro1050B:Class;
//		
//		[Embed(source="assets/images/device/ZY0801-OptiXOSN3500.swf")]
//		public static const ZY0801$OptiXOSN3500:Class;		
//		[Embed(source="assets/images/device/ZY0801-OptiXOSN7500.swf")]
//		public static const ZY0801$OptiXOSN7500:Class;
//	
//		[Embed(source="assets/images/device/ZY0801-TT2.png")]
//		public static const ZY0801$TT2:Class;
//		
//		
//		[Embed(source="assets/images/device/ZY0802-ZXMPS385.swf")]
//		public static const ZY0802$ZXMPS385:Class;
//		
//		
//		[Embed(source="assets/images/device/ZY0804-FT010213.swf")]
//		public static const ZY0804$FT010213:Class;
//		
//		[Embed(source="assets/images/device/ZY0804-hiT7020.swf")]
//		public static const ZY0804$hiT7020:Class;
//		[Embed(source="assets/images/device/ZY0804-hiT7025.swf")]
//		public static const ZY0804$hiT7025:Class;
//		[Embed(source="assets/images/device/ZY0804-hiT7030.swf")]
//		public static const ZY0804$hiT7030:Class;
//		[Embed(source="assets/images/device/ZY0804-hiT7050CC.swf")]
//		public static const ZY0804$hiT7050CC:Class;
//		[Embed(source="assets/images/device/ZY0804-hiT7050FP1.swf")]
//		public static const ZY0804$hiT7050FP1:Class;
//		[Embed(source="assets/images/device/ZY0804-hiT7070DC.swf")]
//		public static const ZY0804$hiT7070DC:Class;
//		[Embed(source="assets/images/device/ZY0804-hiT7070SC.swf")]
//		public static const ZY0804$hiT7070SC:Class;		
//		[Embed(source="assets/images/device/ZY0804-hiT7070SCDTC.swf")]
//		public static const ZY0804$hiT7070SCDTC:Class;
//		[Embed(source="assets/images/device/ZY0804-SLD16B.swf")]
//		public static const ZY0804$SLD16B:Class;		
//		[Embed(source="assets/images/device/ZY0804-SLD16BE.swf")]
//		public static const ZY0804$SLD16BE:Class;
//		
//		[Embed(source="assets/images/device/ZY0804-SMA41.swf")]
//		public static const ZY0804$SMA41:Class;
//		
//		[Embed(source="assets/images/device/ZY0804-SMA1k.swf")]
//		public static const ZY0804$SMA1k:Class;
//		[Embed(source="assets/images/device/ZY0804-SMA1k-CP.swf")]
//		public static const ZY0804$SMA1kCP:Class;		
//		
//		[Embed(source="assets/images/device/ZY0804-SLR16.swf")]
//		public static const ZY0804$SLR16:Class;
//		
//		[Embed(source="assets/images/device/ZY0804-SMA14C.swf")]
//		public static const ZY0804$SMA14C:Class;
//		
//	
//		
//		
//		
//		
//		
//		
//		
//		
//		
//		[Embed(source="assets/images/device/ZY0804-SMA16.swf")]
//		public static const ZY0804$SMA16:Class;
//		
//		[Embed(source="assets/images/device/ZY0804-SMA164.swf")]
//		public static const ZY0804$SMA164:Class;
//		
//		[Embed(source="assets/images/device/ZY0805-ADM-U.swf")]
//		public static const ZY0805$ADM$U:Class;
//		[Embed(source="assets/images/device/ZY0806-2.5GSDH.swf")]
//		public static const ZY0806$25GSDH:Class;
//		[Embed(source="assets/images/device/ZY0806-155MPC.swf")]
//		public static const ZY0806$155MPC:Class;
//		[Embed(source="assets/images/device/ZY0806-SCT600II.swf")]
//		public static const ZY0806$SCT600II:Class;
//		[Embed(source="assets/images/device/ZY0806-155MSDH.swf")]
//		public static const ZY0806$155MSDH:Class;
//		[Embed(source="assets/images/device/ZY0806-622MSDH.swf")]
//		public static const ZY0806$622MSDH:Class;
//		[Embed(source="assets/images/device/ZY0806-SCT2500-30.swf")]
//		public static const ZY0806$SCT250030:Class;
//		[Embed(source="assets/images/device/ZY0806-Unknown.swf")]
//		public static const ZY0806$Unknown:Class;
//		[Embed(source="assets/images/device/ZY0806-155MPCM100.swf")]
//		public static const ZY0806$155MPCM100:Class;		
//		[Embed(source="assets/images/device/ZY0806-DSLAMPC.swf")]
//		public static const ZY0806$DSLAMPC:Class;		
//		[Embed(source="assets/images/device/ZY0806-16DWDMADM-II.swf")]
//		public static const ZY0806$16DWDMADMII:Class;
//		[Embed(source="assets/images/device/ZY0806-16DWDMREG.swf")]
//		public static const ZY0806$16DWDMREG:Class;		
//		[Embed(source="assets/images/device/ZY0806-16DWDMADM.swf")]
//		public static const ZY0806$16DWDMADM:Class;		
//		[Embed(source="assets/images/device/ZY0806-8DWDMREG.swf")]
//		public static const ZY0806$8DWDMREG:Class;		
//		[Embed(source="assets/images/device/ZY0806-8DWDMADM.swf")]
//		public static const ZY0806$8DWDMADM:Class;		
//		[Embed(source="assets/images/device/ZY0806-IDXC.swf")]
//		public static const ZY0806$IDXC:Class;		
//		[Embed(source="assets/images/device/ZY0806-OADM.swf")]
//		public static const ZY0806$OADM:Class;		
//		[Embed(source="assets/images/device/ZY0806-SCAPCMII.swf")]
//		public static const ZY0806$SCAPCMII:Class;		
//		[Embed(source="assets/images/device/ZY0806-SCAPCMII(NEW).swf")]
//		public static const ZY0806$SCAPCMIINEW:Class;		
//		[Embed(source="assets/images/device/ZY0806-SCT2500-10.swf")]
//		public static const ZY0806$SCT250010:Class;
//		[Embed(source="assets/images/device/ZY0806-SCT2500-11.swf")]
//		public static const ZY0806$SCT250011:Class;		
//		[Embed(source="assets/images/device/ZY0806-SCT600II8slotPC.swf")]
//		public static const ZY0806$SCT600II8slotPC:Class;		
//		[Embed(source="assets/images/device/ZY0806-SCT600II8slotPC-.swf")]
//		public static const ZY0806$SCT600II8slotPCX:Class;		
//		[Embed(source="assets/images/device/ZY0806-SCT600II4slotPC.swf")]
//		public static const ZY0806$SCT600II4slotPC:Class;					
//		[Embed(source="assets/images/device/ZY0806-DSLAM(DPC).swf")]
//		public static const ZY0806$DSLAMDPC:Class;		
//		[Embed(source="assets/images/device/ZY0806-DSLAM(FC).swf")]
//		public static const ZY0806$DSLAMFC:Class;				
//		[Embed(source="assets/images/device/ZY0807-FT0102.swf")]
//		public static const ZY0807$FT0102:Class;
//		[Embed(source="assets/images/device/ZY0807-XDM-100.swf")]
//		public static const ZY0807$XDM$100:Class;
//		
//		[Embed(source="assets/images/device/ZY0804.png")]
//		public static const ZY0804:Class;
//		
//		[Embed(source="assets/images/device/ZY0807.png")]
//		public static const ZY0807:Class;
//		[Embed(source="assets/images/device/ZY0809-1660SM.swf")]
//		public static const ZY0809$1660SM:Class;
//		
//		[Embed(source="assets/images/device/ZY0809.swf")]
//		public static const ZY0809:Class;
//		
//		[Embed(source="assets/images/device/ZY0809-FT0102.swf")]
//		public static const ZY0809$FT0102:Class;
//		
//		[Embed(source="assets/images/device/ZY0809-GenericNE.swf")]
//		public static const ZY0809$GenericNE:Class;
//		[Embed(source="assets/images/device/ZY0812.png")]
//		public static const ZY0812:Class;
//		
//		[Embed(source="assets/images/device/ZY0812-FT0102.swf")]
//		public static const ZY0812$FT0102:Class;
//		
//		[Embed(source="assets/images/device/ZY0812-FT010213.swf")]
//		public static const ZY0812$FT010213:Class;
//		
//		[Embed(source="assets/images/device/ZY0812-SDM-1.swf")]
//		public static const ZY0812$SDM$1:Class;
//		
//		[Embed(source="assets/images/device/ZY0812-SDM-4L.swf")]
//		public static const ZY0812$SDM$4L:Class;
//		
//		[Embed(source="assets/images/device/ZY0812-SDM-4R.swf")]
//		public static const ZY0812$SDM$4R:Class;
//		
//		[Embed(source="assets/images/device/ZY0812-XDM-100.swf")]
//		public static const ZY0812$XDM$100:Class;
//		
//		[Embed(source="assets/images/device/ZY0812-XDM-500.swf")]
//		public static const ZY0812$XDM$500:Class;
//		
//		[Embed(source="assets/images/device/ZY0812-XDM-500X4.swf")]
//		public static const ZY0812$XDM$500X4:Class;
//		
//		[Embed(source="assets/images/device/ZY0812-XDM-1000.swf")] 
//		public static const ZY0812$XDM$1000:Class;
//		
//		[Embed(source="assets/images/device/ZY0812-XDM-1000X2.swf")] 
//		public static const ZY0812$XDM$1000X2:Class;	
//		[Embed(source="assets/images/device/ZY0812-UME-SDH-SONET-TERMINAL.png")] 
//		public static const ZY0812$UME$SDH$SONET$TERMINAL:Class;	
//		
//		[Embed(source="assets/images/device/ZY0814-FT0102.swf")] 
//		public static const ZY0814$FT0102:Class;	
//		[Embed(source="assets/images/device/ZY0814-FT010213.swf")] 
//		public static const ZY0814$FT010213:Class;	
//		[Embed(source="assets/images/device/ZY0814-SMS-150V.swf")] 
//		public static const ZY0814$SMS$150V:Class;	
//		[Embed(source="assets/images/device/ZY0814-SMS-600V.swf")] 
//		public static const ZY0814$SMS$600V:Class;	
//		[Embed(source="assets/images/device/ZY0815-OMS1664.swf")] 
//		public static const ZY0815$OMS1664:Class;	
//		[Embed(source="assets/images/device/ZY0815-FT0102.swf")] 
//		public static const ZY0815$FT0102:Class;	
//		[Embed(source="assets/images/device/ZY0815-FT010203.swf")] 
//		public static const ZY0815$FT010203:Class;
//		
//		[Embed(source="assets/images/device/ZY0815-FT010213.swf")] 
//		public static const ZY0815$FT010213:Class; 
//		
//		[Embed(source="assets/images/device/ZY0815-OMS1240-4.swf")] 
//		public static const ZY0815$OMS1240$4:Class;	
//		
//		[Embed(source="assets/images/device/ZY0815-OMS1654.swf")] 
//		public static const ZY0815$OMS1654:Class;		
//		
//		[Embed(source="assets/images/device/ZY0815-OMS860.swf")] 
//		public static const ZY0815$OMS860:Class;		
//		[Embed(source="assets/images/device/ZY0815-Series4SMA14(4+4).swf")] 
//		public static const ZY0815$Series4SMA144$4:Class;		
//		[Embed(source="assets/images/device/ZY0815-Series4SMA14c.png")] 
//		public static const ZY0815$Series4SMA14c:Class;	
//		
//		[Embed(source="assets/images/device/ZY0815-Series3SMA14c.swf")] 
//		public static const ZY0815$Series3SMA1$4c:Class;	
//		
//		[Embed(source="assets/images/device/ZY0815-OMS3255(160G).swf")] 
//		public static const ZY0815$OMS3255$160G:Class; 
//		[Embed(source="assets/images/device/ZY0815-OMS3255(720G).swf")] 
//		public static const ZY0815$OMS3255$720G:Class; 
//		[Embed(source="assets/images/device/ZY0815-OMS3240MSH64C.swf")] 
//		public static const ZY0815$OMS3240MSH64C:Class; 
//		
//		[Embed(source="assets/images/device/ZY0815-Series3SMA16.swf")] 
//		public static const ZY0815$Series3SMA16:Class;
//		
//		[Embed(source="assets/images/device/ZY0815-Series3SMA4.swf")] 
//		public static const ZY0815$Series3SMA4:Class;
//		
//		[Embed(source="assets/images/device/ZY0815-Series3SMA416c.swf")] 
//		public static const ZY0815$Series3SMA416c:Class;
//		[Embed(source="assets/images/device/ZY0815-Multihaul3000.png")] 
//		public static const ZY0815$Multihaul3000:Class;
//		//山东添加 author:zwx
//		
//		[Embed(source="assets/images/device/ZY0815-OADM.swf")] 
//		public static const ZY0815$OADM:Class;
//		[Embed(source="assets/images/device/ZY0815-DXC.swf")] 
//		public static const ZY0815$DXC:Class;
//		[Embed(source="assets/images/device/ZY0815-ADM.swf")] 
//		public static const ZY0815$ADM:Class;
//		[Embed(source="assets/images/device/ZY0817-guangxun.png")]
//		public static const ZY0817$guangxun:Class;		
//		[Embed(source="assets/images/device/ZY0899-FT0102.png")]
//		public static const ZY0899$FT0102:Class;
//		[Embed(source="assets/images/device/ZY0899-FT010213.swf")] 
//		public static const ZY0899$FT010213:Class;
//		
	
		
		
	
//		[Embed(source="assets/images/circuit/ZY0823-Series3SMA14c.png")] 
//		public static const ZY0823$Series3SMA14c:Class;
		
//		[Embed(source="assets/images/device/cloud.png")]
//		public static const Cloud:Class;
		
		
//		[Embed(source="assets/images/circuit/ZY0801.png")]
//		public static const ZY0801circuit:Class;
//		[Embed(source="assets/images/circuit/ZY0801-ONU-F02A.png")]
//		public static const ZY0801$ONU$F02Acircuit:Class;
//		[Embed(source="assets/images/circuit/ZY0801-ONU-128A.png")]
//		public static const ZY0801$ONU$128Acircuit:Class;
//		[Embed(source="assets/images/circuit/ZY0801-FT0102.png")]
//		public static const ZY0801$FT0102circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0801-FT010213.png")]
//		public static const ZY0801$FT010213circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0801-IT1.png")]
//		public static const ZY0801$IT1circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0801-TT2.png")]
//		public static const ZY0801$TT2circuit:Class;
//		
//		
//		
//		[Embed(source="assets/images/circuit/ZY0801-OptiX2500+.png")]
//		public static const ZY0801$OptiX2500$circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0801-OptiXOSN3500.png")]
//		public static const ZY0801$OptiXOSN3500circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0801-OptiXOSN7500.png")]
//		public static const ZY0801$OptiXOSN7500circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0802-ZXMPS385.png")]
//		public static const ZY0802$ZXMPS385circuit:Class;		
//		
//		
//		[Embed(source="assets/images/circuit/ZY0804-hiT7070DC.png")]
//		public static const ZY0804$hiT7070DCcircuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0804-hiT7070SC.png")]
//		public static const ZY0804$hiT7070SCcircuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0804-hiT7070SCDTC.png")]
//		public static const ZY0804$hiT7070SCDTCcircuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0804-SLD16B.png")]
//		public static const ZY0804$SLD16Bcircuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0804-SLD16BE.png")]
//		public static const ZY0804$SLD16BEcircuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0804-SLR16.png")]
//		public static const ZY0804$SLR16circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0804-SMA14C.png")]
//		public static const ZY0804$SMA14Ccircuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0804-SMA16.png")]
//		public static const ZY0804$SMA16circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0804-SMA164.png")]
//		public static const ZY0804$SMA164circuit:Class;
//		[Embed(source="assets/images/circuit/ZY0804-FT010213.png")]
//		public static const ZY0804$FT010213circuit:Class;
//		[Embed(source="assets/images/circuit/ZY0805-ADM-U.png")]
//		public static const ZY0805$ADM$Ucircuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0807-FT0102.png")]
//		public static const ZY0807$FT0102circuit:Class;
//		[Embed(source="assets/images/circuit/ZY0807-XDM-100.png")]
//		public static const ZY0807$XDM$100circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0804.png")]
//		public static const ZY0804circuit:Class;
//		
//		[Embed(source="assets/images/device/ZY0804-SMA1$4C.swf")]
//		public static const ZY0804$SMA1$4Ccircuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0807.png")]
//		public static const ZY0807circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0809-1660SM.png")]
//		public static const ZY0809$1660SMcircuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0809.png")]
//		public static const ZY0809circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0809-FT0102.png")]
//		public static const ZY0809$FT0102circuit:Class;		
//	
//		[Embed(source="assets/images/circuit/ZY0809-GennericNE.png")]
//		public static const ZY0809$GennericNEcircuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0809-GenericNE.png")]
//		public static const ZY0809$GenericNEcircuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0899-FT0102.png")]
//		public static const ZY0899$FT0102circuit:Class;
//		[Embed(source="assets/images/circuit/ZY0899-FT010213.png")] 
//		public static const ZY0899$FT010213circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0812.png")]
//		public static const ZY0812circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0812-FT0102.png")]
//		public static const ZY0812$FT0102circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0812-FT010213.png")]
//		public static const ZY0812$FT010213circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0812-SDM-1.png")]
//		public static const ZY0812$SDM$1circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0812-SDM-4L.png")]
//		public static const ZY0812$SDM$4Lcircuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0812-SDM-4R.png")]
//		public static const ZY0812$SDM$4Rcircuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0812-XDM-100.png")]
//		public static const ZY0812$XDM$100circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0812-XDM-500.png")]
//		public static const ZY0812$XDM$500circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0812-XDM-500X4.png")]
//		public static const ZY0812$XDM$500X4circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0812-XDM-1000.png")] 
//		public static const ZY0812$XDM$1000circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0812-XDM-1000X2.png")] 
//		public static const ZY0812$XDM$1000X2circuit:Class;	
//		
//		[Embed(source="assets/images/circuit/ZY0814-FT0102.png")] 
//		public static const ZY0814$FT0102circuit:Class;	
//		[Embed(source="assets/images/circuit/ZY0814-FT010213.png")] 
//		public static const ZY0814$FT010213circuit:Class;	
//		[Embed(source="assets/images/circuit/ZY0814-SMS-150V.png")] 
//		public static const ZY0814$SMS$150Vcircuit:Class;	
//		[Embed(source="assets/images/circuit/ZY0814-SMS-600V.png")] 
//		public static const ZY0814$SMS$600Vcircuit:Class;		
//		
//		[Embed(source="assets/images/circuit/ZY0815-OMS1664.png")] 
//		public static const ZY0815$OMS1664circuit:Class;	
//		
//		[Embed(source="assets/images/circuit/ZY0815-FT0102.png")] 
//		public static const ZY0815$FT0102circuit:Class;	
//		
//		[Embed(source="assets/images/circuit/ZY0815-FT010203.png")] 
//		public static const ZY0815$FT010203circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0815-FT010213.png")] 
//		public static const ZY0815$FT010213circuit:Class; 
//		
//		[Embed(source="assets/images/circuit/ZY0815-OMS1240-4.png")] 
//		public static const ZY0815$OMS1240$4circuit:Class;	
//		
//		[Embed(source="assets/images/circuit/ZY0815-OMS1654.png")] 
//		public static const ZY0815$OMS1654circuit:Class;		
//		
//		[Embed(source="assets/images/circuit/ZY0815-OMS860.png")] 
//		public static const ZY0815$OMS860circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0815-Series4SMA14(4+4).png")] 
//		public static const ZY0815$Series4SMA144$4circuit:Class;	
//		
//		[Embed(source="assets/images/circuit/ZY0815-Series3SMA14c.png")] 
//		public static const ZY0815$Series3SMA1$4ccircuit:Class;	
//		
//		[Embed(source="assets/images/circuit/ZY0815-OMS3255(160G).png")] 
//		public static const ZY0815$OMS3255$160G$circuit:Class; 
//		
//		[Embed(source="assets/images/circuit/ZY0815-OMS3240MSH64C.png")] 
//		public static const ZY0815$OMS3240MSH64Ccircuit:Class; 
//		
//		[Embed(source="assets/images/circuit/ZY0815-Series3SMA16.png")] 
//		public static const ZY0815$Series3SMA16circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0815-Series3SMA4.png")] 
//		public static const ZY0815$Series3SMA4circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0815-Series3SMA416c.png")] 
//		public static const ZY0815$Series3SMA416ccircuit:Class;
//		[Embed(source="assets/images/circuit/ZY0815-Series4SMA14c.png")] 
//		public static const ZY0815$Series4SMA14ccircuit:Class;	
//		[Embed(source="assets/images/circuit/ABB-FT0102.png")]
//		public static const ZY0816$FT0102circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ABB-FT010213.png")]
//		public static const ZY0816$FT010213circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ABB-FT010214.png")]
//		public static const ZY0816$FT010214circuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0817-guangxun.png")]
//		public static const ZY0817$guangxuncircuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0823-Series3SMA14c.png")] 
//		public static const ZY0823$Series3SMA14ccircuit:Class;
//		
//		
//		[Embed(source="assets/images/circuit/ZY0806-155MPC.png")] 
//		public static const ZY0806$155MPCcircuit:Class; 
//		[Embed(source="assets/images/circuit/ZY0806-155MPCM100.png")] 
//		public static const ZY0806$155MPCM100circuit:Class;
//		[Embed(source="assets/images/circuit/ZY0806-155MSDH.png")] 
//		public static const ZY0806$155MSDHcircuit:Class;
//		[Embed(source="assets/images/circuit/ZY0806-16DWDMADM-II.png")] 
//		public static const ZY0806$16DWDMADM$IIcircuit:Class;
//		[Embed(source="assets/images/circuit/ZY0806-16DWDMADM.png")] 
//		public static const ZY0806$16DWDMADMcircuit:Class;
//		[Embed(source="assets/images/circuit/ZY0806-16DWDMREG.png")] 
//		public static const ZY0806$16DWDMREGcircuit:Class;
//		[Embed(source="assets/images/circuit/ZY0806-2.5GSDH.png")] 
//		public static const ZY0806$2$5GSDHcircuit:Class;
//		[Embed(source="assets/images/circuit/ZY0806-622MSDH.png")] 
//		public static const ZY0806$622MSDHcircuit:Class;
//		[Embed(source="assets/images/circuit/ZY0806-8DWDMADM.png")] 
//		public static const ZY0806$8DWDMADMcircuit:Class;
//		[Embed(source="assets/images/circuit/ZY0806-8DWDMREG.png")] 
//		public static const ZY0806$8DWDMREGcircuit:Class;
//		[Embed(source="assets/images/circuit/ZY0806-DSLAM(DPC).png")] 
//		public static const ZY0806$DSLAM$DPC$circuit:Class;
//		[Embed(source="assets/images/circuit/ZY0806-DSLAM(FC).png")] 
//		public static const ZY0806$DSLAM$FC$circuit:Class;
//		[Embed(source="assets/images/circuit/ZY0806-DSLAMPC.png")] 
//		public static const ZY0806$DSLAMPCcircuit:Class;
//		[Embed(source="assets/images/circuit/ZY0806-IDXC.png")] 
//		public static const ZY0806$IDXCcircuit:Class;
//		[Embed(source="assets/images/circuit/ZY0806-OADM.png")] 
//		public static const ZY0806$OADMcircuit:Class;
//		[Embed(source="assets/images/circuit/ZY0806-SCAPCMII.png")] 
//		public static const ZY0806$SCAPCMIIcircuit:Class;
//		[Embed(source="assets/images/circuit/ZY0806-SCAPCMII(NEW).png")] 
//		public static const ZY0806$SCAPCMII$NEW$circuit:Class;
//		[Embed(source="assets/images/circuit/ZY0806-SCT2500-10.png")] 
//		public static const ZY0806$SCT2500$10circuit:Class;
//		[Embed(source="assets/images/circuit/ZY0806-SCT2500-11.png")] 
//		public static const ZY0806$SCT2500$11circuit:Class;	
//		[Embed(source="assets/images/circuit/ZY0806-SCT2500-30.png")] 
//		public static const ZY0806$SCT2500$30circuit:Class;
//		[Embed(source="assets/images/circuit/ZY0806-SCT600II.png")] 
//		public static const ZY0806$SCT600IIcircuit:Class;
//		[Embed(source="assets/images/circuit/ZY0806-SCT600II4slotPC.png")] 
//		public static const ZY0806$SCT600II4slotPCcircuit:Class;
//		[Embed(source="assets/images/circuit/ZY0806-SCT600II8slotPC-.png")] 
//		public static const ZY0806$SCT600II8slotPC$circuit:Class;
//		[Embed(source="assets/images/circuit/ZY0806-SCT600II8slotPC.png")] 
//		public static const ZY0806$SCT600II8slotPCcircuit:Class;
//		[Embed(source="assets/images/circuit/ZY0806-Unknown.png")] 
//		public static const ZY0806$Unknowncircuit:Class;
//		
//		
//
//		[Embed(source="assets/images/circuit/ZY0801-OptiX155622.png")] 
//		public static const ZY0801$OptiX155622circuit:Class;
//		[Embed(source="assets/images/circuit/ZY0801-OptiX155622H.png")] 
//		public static const ZY0801$OptiX155622Hcircuit:Class;
//		[Embed(source="assets/images/circuit/ZY0801-OptiXMetro1000V3.png")] 
//		public static const ZY0801$OptiXMetro1000V3circuit:Class;
//		[Embed(source="assets/images/circuit/ZY0801-OptiXMetro1050B.png")] 
//		public static const ZY0801$OptiXMetro1050Bcircuit:Class;
//
//		[Embed(source="assets/images/circuit/ZY0804-hiT7020.png")] 
//		public static const ZY0804$hiT7020circuit:Class;
//		[Embed(source="assets/images/circuit/ZY0804-hiT7025.png")] 
//		public static const ZY0804$hiT7025circuit:Class;
//		[Embed(source="assets/images/circuit/ZY0804-hiT7030.png")] 
//		public static const ZY0804$hiT7030circuit:Class;
//		[Embed(source="assets/images/circuit/ZY0804-hiT7050CC.png")] 
//		public static const ZY0804$hiT7050CCcircuit:Class;	
//		[Embed(source="assets/images/circuit/ZY0804-hiT7050FP1.png")] 
//		public static const ZY0804$hiT7050FP1circuit:Class;
//		[Embed(source="assets/images/circuit/ZY0804-SMA1k.png")] 
//		public static const ZY0804$SMA1kcircuit:Class;
//		[Embed(source="assets/images/circuit/ZY0804-SMA1k-CP.png")] 
//		public static const ZY0804$SMA1k$CPcircuit:Class;
//		[Embed(source="assets/images/circuit/ZY0804-SMA41.png")] 
//		public static const ZY0804$SMA41circuit:Class;
//		[Embed(source="assets/images/circuit/ZY0812-UME-SDH-SONET-TERMINAL.png")] 
//		public static const ZY0812$UME$SDH$SONET$TERMINALcircuit:Class;
//		[Embed(source="assets/images/circuit/ZY0815-ADM.png")] 
//		public static const ZY0815$ADMcircuit:Class;
//		
//		[Embed(source="assets/images/circuit/ZY0815-DXC.png")] 
//		public static const ZY0815$DXCcircuit:Class;
//		[Embed(source="assets/images/circuit/ZY0815-Multihaul3000.png")] 
//		public static const ZY0815$Multihaul3000circuit:Class;
//		[Embed(source="assets/images/circuit/ZY0815-OADM.png")] 
//		public static const ZY0815$OADMcircuit:Class;	
//		[Embed(source="assets/images/circuit/ZY0815-OMS3255(720G).png")] 
//		public static const ZY0815$OMS3255$720Gcircuit:Class; 
//	//end
//		
//		[Embed(source="assets/images/circuit/port.png")] 
//		public static const portcircuit:Class;
//		
//		[Embed(source="assets/images/circuit/portright.png")] 
//		public static const portrightcircuit:Class; 
		
		
		//文件管理
		[Embed(source="assets/images/mydocument/enter.gif")]
		public static const  enter:Class;
		[Embed(source="assets/images/mydocument/highlevel.png")]
		public static const  highlevel:Class;
		[Embed(source="assets/images/mydocument/view.png")]
		public static const  view:Class;
		[Embed(source="assets/images/mydocument/add_page.png")]
		public static const  add_page:Class;
		[Embed(source="assets/images/mydocument/arrow_up.gif")]
		public static const  arrow_up:Class;
		[Embed(source="assets/images/mydocument/arrow-down.gif")]
		public static const  arrow_down:Class;
		[Embed(source="assets/images/mydocument/del.png")]
		public static const  clear_all:Class;
		[Embed(source="assets/images/mydocument/page.png")]
		public static const  page:Class;
		[Embed(source="assets/images/mydocument/folder.png")]
		public static const  folder:Class;
				
	
		
		[Embed(source="assets/images/mydocument/midview.gif")]
		public static const midview:Class;
		
		[Embed(source="assets/images/mydocument/bigview.png")]
		public static const bigview:Class;
		[Embed(source="assets/images/mydocument/bg_mydocument.png")]
		public static const bg_mydocument:Class;
		
	
		
		[Embed(source="assets/images/mydocument/add_to_folder.png")]
		public static const addfolder:Class;
		
		// 自身监控
		[Embed(source="assets/images/selfmonitor/mshelf.png")]
		public static const mshelf:Class;
		[Embed(source="assets/images/selfmonitor/mtape.png")]
		public static const mtape:Class;
		[Embed(source="assets/images/selfmonitor/mdisk.png")]
		public static const mdisk:Class;
		[Embed(source="assets/images/selfmonitor/mvirus.png")]
		public static const mvirus:Class;
		[Embed(source="assets/images/selfmonitor/mfirewall.png")]
		public static const mfirewall:Class;
		[Embed(source="assets/images/selfmonitor/madapter.png")]
		public static const madapter:Class;
		[Embed(source="assets/images/selfmonitor/mswitch.png")]
		public static const mswitch:Class;
		[Embed(source="assets/images/selfmonitor/mprinter.png")]
		public static const mprinter:Class;
		[Embed(source="assets/images/selfmonitor/misolation.png")]
		public static const misolation:Class;
		[Embed(source="assets/images/selfmonitor/mnet.png")]
		public static const mnet:Class;
		[Embed(source="assets/images/selfmonitor/malarm.png")]
		public static const malarm:Class;
		[Embed(source="assets/images/selfmonitor/mterminal.png")]
		public static const mterminal:Class;
		
		[Embed(source="assets/images/links/link_flexional_icon.png")]
		public static const link_flexional_icon:Class;
		[Embed(source="assets/images/device/jian.png")]
		public static const jian:Class;		

	
	
		
		[Embed(source="assets/images/roomMgr/room.png")]
		public static const room:Class;
		
		[Embed(source="assets/images/floor/addFloor.png")]
		public static const addFloor:Class;
		[Embed(source="assets/images/floor/relatingRoom.png")]
		public static const relatingRoom:Class;

		
		[Embed(source="assets/images/sysManager/show.png")]          //这是图片的相对地址 
		[Bindable]public static var PointIcon:Class;
		[Embed(source="assets/images/sysManager/show.png")]
		[Bindable]public static var PointRight:Class; 
		[Embed(source="assets/images/sysManager/hide.png")] 
		[Bindable]public static var PointLeft:Class;
		
		

		
		[Embed(source="assets/images/confim.png")] 
		[Bindable]public static var confim:Class;
		[Embed(source="assets/images/success.png")] 
		[Bindable]public static var success:Class;
		[Embed(source="assets/images/error.png")] 
		[Bindable]public static var error:Class;
		
		//光缆
		[Embed(source="assets/images/swf/ocable/map/XZ01.swf")]          //这是图片的相对地址 		
		public static const province_XZ01:Class; 
		[Embed(source="assets/images/swf/ocable/map/XZ0101.swf")]          //这是图片的相对地址 		
		public static const province_XZ0101:Class; 
		[Embed(source="assets/images/swf/ocable/map/XZ0102.swf")]          //这是图片的相对地址 		
		public static const province_XZ0102:Class; 
		[Embed(source="assets/images/swf/ocable/map/XZ0103.swf")]          //这是图片的相对地址 		
		public static const province_XZ0103:Class; 
		[Embed(source="assets/images/swf/ocable/map/XZ0104.swf")]          //这是图片的相对地址 		
		public static const province_XZ0104:Class; 
		[Embed(source="assets/images/swf/ocable/map/XZ0105.swf")]          //这是图片的相对地址 		
		public static const province_XZ0105:Class; 
		[Embed(source="assets/images/swf/ocable/map/XZ0106.swf")]          //这是图片的相对地址 		
		public static const province_XZ0106:Class; 
		[Embed(source="assets/images/swf/ocable/map/XZ0107.swf")]          //这是图片的相对地址 		
		public static const province_XZ0107:Class; 
		[Embed(source="assets/images/swf/ocable/map/XZ0108.swf")]          //这是图片的相对地址 		
		public static const province_XZ0108:Class; 
		[Embed(source="assets/images/swf/ocable/map/XZ0109.swf")]          //这是图片的相对地址 		
		public static const province_XZ0109:Class; 
		[Embed(source="assets/images/swf/ocable/map/XZ0110.swf")]          //这是图片的相对地址 		
		public static const province_XZ0110:Class; 
		[Embed(source="assets/images/swf/ocable/map/XZ0111.swf")]          //这是图片的相对地址 		
		public static const province_XZ0111:Class; 
		
		
		//wireConfig
		[Embed(source="assets/images/device/ZY0801-FT0102.swf")]
		public static const ZY0801$FT0102:Class;
		[Embed(source="assets/images/device/ZY0801-OptiX2500+.swf")]
		public static const ZY0801$OptiX2500$:Class;
		[Embed(source="assets/images/device/ZY0801-OptiXOSN3500.swf")]
		public static const ZY0801$OptiXOSN3500:Class;	
		[Embed(source="assets/images/device/ZY0801-OptiXOSN7500.swf")]
		public static const ZY0801$OptiXOSN7500:Class;
		[Embed(source="assets/images/device/ZY0801-FT010213.swf")]
		public static const ZY0801$FT010213:Class;
		[Embed(source="assets/images/device/ZY0801-ONU-128A.png")]
		public static const ZY0801$ONU$128A:Class;
		[Embed(source="assets/images/device/ZY0801-ONU-F02A.swf")]
		public static const ZY0801$ONU$F02A:Class;
		[Embed(source="assets/images/device/ZY0801-IT1.png")]
		public static const ZY0801$IT1:Class;
		[Embed(source="assets/images/device/ZY0801-TT2.png")]
		public static const ZY0801$TT2:Class;
		[Embed(source="assets/images/device/ZY0801-OSU.png")]
		public static const ZY0801$OSU:Class;
		[Embed(source="assets/images/device/ZY0802-ZXMPS385.swf")]
		public static const ZY0802$ZXMPS385:Class;
		[Embed(source="assets/images/device/ZY0804-FT010213.swf")]
		public static const ZY0804$FT010213:Class;
		[Embed(source="assets/images/device/ZY0804-hiT7070DC.swf")]
		public static const ZY0804$hiT7070DC:Class;
		[Embed(source="assets/images/device/ZY0804-hiT7070SC.swf")]
		public static const ZY0804$hiT7070SC:Class;	
		[Embed(source="assets/images/device/ZY0804-hiT7070SCDTC.swf")]
		public static const ZY0804$hiT7070SCDTC:Class;
		[Embed(source="assets/images/device/ZY0804-SLD16B.swf")]
		public static const ZY0804$SLD16B:Class;		
		[Embed(source="assets/images/device/ZY0804-SLD16BE.swf")]
		public static const ZY0804$SLD16BE:Class;
		[Embed(source="assets/images/device/ZY0804-SLR16.swf")]
		public static const ZY0804$SLR16:Class;
		[Embed(source="assets/images/device/ZY0804-SMA14C.swf")]
		public static const ZY0804$SMA14C:Class;
		[Embed(source="assets/images/device/ZY0804-SMA16.swf")]
		public static const ZY0804$SMA16:Class;
		[Embed(source="assets/images/device/ZY0804-SMA164.swf")]
		public static const ZY0804$SMA164:Class;
		[Embed(source="assets/images/device/ZY0805-ADM-U.swf")]
		public static const ZY0805$ADM$U:Class;
		[Embed(source="assets/images/device/ZY0807-FT0102.swf")]
		public static const ZY0807$FT0102:Class;
		[Embed(source="assets/images/device/ZY0807-XDM-100.swf")]
		public static const ZY0807$XDM$100:Class;
		[Embed(source="assets/images/device/ZY0809-1660SM.swf")]
		public static const ZY0809$1660SM:Class;
		[Embed(source="assets/images/device/ZY0809.swf")]
		public static const ZY0809:Class;
		[Embed(source="assets/images/device/ZY0809-FT0102.swf")]
		public static const ZY0809$FT0102:Class;
		[Embed(source="assets/images/device/ZY0899-FT0102.png")]
		public static const ZY0899$FT0102:Class;
		[Embed(source="assets/images/device/ZY0899-FT010213.swf")] 
		public static const ZY0899$FT010213:Class;
		[Embed(source="assets/images/device/ZY0809-GenericNE.swf")]
		public static const ZY0809$GenericNE:Class;
		[Embed(source="assets/images/device/ZY0812-FT0102.swf")]
		public static const ZY0812$FT0102:Class;
		[Embed(source="assets/images/device/ZY0812-FT010213.swf")]
		public static const ZY0812$FT010213:Class;
		[Embed(source="assets/images/device/ZY0812-SDM-1.swf")]
		public static const ZY0812$SDM$1:Class;
		[Embed(source="assets/images/device/ZY0812-SDM-4L.swf")]
		public static const ZY0812$SDM$4L:Class;
		[Embed(source="assets/images/device/ZY0812-SDM-4R.swf")]
		public static const ZY0812$SDM$4R:Class;
		[Embed(source="assets/images/device/ZY0812-XDM-100.swf")]
		public static const ZY0812$XDM$100:Class;
		[Embed(source="assets/images/device/ZY0812-XDM-500X4.swf")]
		public static const ZY0812$XDM$500X4:Class;
		[Embed(source="assets/images/device/ZY0812-XDM-1000.swf")] 
		public static const ZY0812$XDM$1000:Class;
		[Embed(source="assets/images/device/ZY0812-XDM-1000X2.swf")] 
		public static const ZY0812$XDM$1000X2:Class;
		[Embed(source="assets/images/device/ZY0814-FT0102.swf")] 
		public static const ZY0814$FT0102:Class;	
		[Embed(source="assets/images/device/ZY0814-FT010213.swf")] 
		public static const ZY0814$FT010213:Class;	
		[Embed(source="assets/images/device/ZY0814-SMS-150V.swf")] 
		public static const ZY0814$SMS$150V:Class;	
		[Embed(source="assets/images/device/ZY0814-SMS-600V.swf")] 
		public static const ZY0814$SMS$600V:Class;	
		[Embed(source="assets/images/device/ZY0815-OMS1664.swf")] 
		public static const ZY0815$OMS1664:Class;	
		[Embed(source="assets/images/device/ZY0815-FT0102.swf")] 
		public static const ZY0815$FT0102:Class;	
		[Embed(source="assets/images/device/ZY0815-FT010203.swf")] 
		public static const ZY0815$FT010203:Class;
		[Embed(source="assets/images/device/ZY0815-FT010213.swf")] 
		public static const ZY0815$FT010213:Class; 
		[Embed(source="assets/images/device/ZY0815-OMS1240-4.swf")] 
		public static const ZY0815$OMS1240$4:Class;	
		[Embed(source="assets/images/device/ZY0815-OMS1654.swf")] 
		public static const ZY0815$OMS1654:Class;		
		[Embed(source="assets/images/device/ZY0815-OMS860.swf")] 
		public static const ZY0815$OMS860:Class;		
		[Embed(source="assets/images/device/ZY0815-Series4SMA14(4+4).swf")] 
		public static const ZY0815$Series4SMA144$4:Class;	
		[Embed(source="assets/images/device/ZY0815-Series3SMA14c.swf")] 
		public static const ZY0815$Series3SMA1$4c:Class;	
		[Embed(source="assets/images/device/ZY0815-OMS3255(160G).swf")] 
		public static const ZY0815$OMS3255$160G:Class; 
		[Embed(source="assets/images/device/ZY0815-Series3SMA16.swf")] 
		public static const ZY0815$Series3SMA16:Class;
		[Embed(source="assets/images/device/ZY0815-Series3SMA4.swf")] 
		public static const ZY0815$Series3SMA4:Class;
		[Embed(source="assets/images/device/ZY0815-ADM.swf")] 
		public static const ZY0815$ADM:Class;
		[Embed(source="assets/images/device/ZY0815-OMS3255(720G).swf")] 
		public static const ZY0815$OMS3255$720G:Class; 
		[Embed(source="assets/images/device/ZY0815-Multihaul3000.png")] 
		public static const ZY0815$Multihaul3000:Class;
		[Embed(source="assets/images/device/ZY0815-Series3SMA416c.swf")] 
		public static const ZY0815$Series3SMA416c:Class;
		[Embed(source="assets/images/circuit/ZY0823-Series3SMA14c.png")] 
		public static const ZY0823$Series3SMA14c:Class;
		[Embed(source="assets/images/swf/sysGraph/C-Node.swf")]          //这是图片的相对地址 		
		public static const NEC_SDH_C_NODE:Class; 	
		[Embed(source="assets/images/swf/sysGraph/V-Node.swf")]          //这是图片的相对地址 		
		public static const NEC_SDH_V_NODE:Class; 
		[Embed(source="assets/images/swf/sysGraph/U-NODEBBM.swf")]          //这是图片的相对地址 		
		public static const NEC_SDH_UNODE_BBM:Class; 
		[Embed(source="assets/images/swf/sysGraph/U-NODEWBM.swf")]          //这是图片的相对地址 		
		public static const NEC_SDH_UNODE_WBM:Class; 
		[Embed(source="assets/images/swf/sysGraph/C-Node.swf")]          //这是图片的相对地址 		
		public static const C_NODE:Class; 
		[Embed(source="assets/images/swf/sysGraph/马可尼SMA-14EX.swf")]          //这是图片的相对地址 		
		public static const Marconi_SMA_14EX:Class; 		
		[Embed(source="assets/images/swf/sysGraph/马可尼SMA-14UC.swf")]          //这是图片的相对地址 		
		public static const Marconi_SMA_14UC:Class;
		[Embed(source="assets/images/swf/sysGraph/马可尼SMA-3.swf")]          //这是图片的相对地址 		
		public static const Marconi_SMA_3:Class; 
		[Embed(source="assets/images/swf/sysGraph/马可尼SMA-4.swf")]          //这是图片的相对地址 		
		public static const Marconi_SMA_4:Class; 
		[Embed(source="assets/images/device/cloud.png")]
		public static const Cloud:Class;
		[Embed(source="assets/images/device/ZY0812-XDM-500.swf")]
		public static const ZY0812$XDM$500:Class;
		[Embed(source="assets/images/device/ZY0815-OMS3240MSH64C.swf")] 
		public static const ZY0815$OMS3240MSH64C:Class; 
		
		
		
		[Bindable]public static var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
		[Bindable]public static var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");
	
		/*[Embed(source="assets/images/myDocument/add_page.png")]
		public static const  add_page:Class;*/
	
		public static function tree_itemClick(evt:ListEvent,tree:Tree):void {
			
			var item:Object = Tree(evt.currentTarget).selectedItem;
			if (tree.dataDescriptor.isBranch(item)) {
				
				tree.expandItem(item, !tree.isItemOpen(item), true);
			}
			
		}
		
		public static function getContext():String{
			var url:String=ExternalInterface.call("function getURL(){return window.location.href;}");
			var doMain:String = null;
			if(url!=null){
				doMain= url;
			}
			if(doMain==null){
			doMain = Application.application.stage.loaderInfo.url;
			}
			var currpngUrl:String = null;
			if(doMain!=null){
			var doMainArray:Array = doMain.split("/");  
			if (doMainArray[0] == "file:") {  
				if(doMainArray.length<=3){  
					currpngUrl = doMainArray[2];  
					currpngUrl = currpngUrl.substring(0,currpngUrl.lastIndexOf(currpngUrl.charAt(2)));  
				}else{  
					currpngUrl = doMain;  
					currpngUrl = currpngUrl.substring(0,currpngUrl.lastIndexOf("/"));  
				}  
			}else{  
				currpngUrl = doMain;  
				currpngUrl = currpngUrl.substring(0,currpngUrl.lastIndexOf("/"));  
			}
			if(currpngUrl!=null&&currpngUrl.split("/").length>3)
			currpngUrl = currpngUrl.substring(currpngUrl.lastIndexOf("/"));
			else 
			currpngUrl = null;	
			}
			if(currpngUrl==null)currpngUrl = "";
			return currpngUrl;
		}
		
		public static function getURL():String{
			var currpngUrl:String; 
			var doMain:String = Application.application.stage.loaderInfo.url;  
			var doMainArray:Array = doMain.split("/");  
			
			if (doMainArray[0] == "file:") {  
				if(doMainArray.length<=3){  
					currpngUrl = doMainArray[2];  
					currpngUrl = currpngUrl.substring(0,currpngUrl.lastIndexOf(currpngUrl.charAt(2)));  
				}else{  
					currpngUrl = doMain;  
					currpngUrl = currpngUrl.substring(0,currpngUrl.lastIndexOf("/"));  
				}  
			}else{  
				currpngUrl = doMain;  
				currpngUrl = currpngUrl.substring(0,currpngUrl.lastIndexOf("/"));  
			}  
			currpngUrl += "/";
			return currpngUrl;
		}
		
		public static function setSelectedItem(cmb:ComboBox,value:String):void{
			for(var i:int=0;i<cmb.dataProvider.length;i++){
				if(cmb.dataProvider[i].@label == value){
					cmb.selectedIndex = i;
					break;
				}
			}
		}
		
		public static function showErrorMessage(message:String,parent:Sprite):void{
			Alert.show(message,"提示",0,parent,null,ModelLocator.error);
		}
		
		public static function showConfimMessage(message:String,parent:Sprite,func:Function):void{
			Alert.show(message,"请您确认",Alert.YES|Alert.NO,parent,func,ModelLocator.confim,Alert.NO);
		}
		
		public static function showSuccessMessage(message:String,parent:Sprite):void{
			Alert.show(message,"提示",0,parent,null,ModelLocator.success);
		}
		/**
		 *注册告警等级 
		 * 
		 */
		public static function registerAlarm():void{
			AlarmSeverity.clear();
			
			AlarmSeverity.register(5,'CRITICAL','',0xFF0000);//紧急告警
			AlarmSeverity.register(4,'MAJOR','',0xFF9900);//主要告警
			AlarmSeverity.register(3,'MINOR','',0xFFFF00);//次要告警
			AlarmSeverity.register(2,'WARNING','',0x00FFFF);//一般告警
//			AlarmSeverity.register(1,'','',0x00FFFF);//
		}
		//绝对时隙转换成373格式
		public static function timeslotTo373(slot:int):String{
		   
			var realtimeslot:String = "";
			if (slot != 0) {
				var a:int=0,b:int = 0, c:int = 0, d:int = 0, x1:int = 0,x2:int = 0;
				a = slot / 63;
				x1 = slot % 63;
				b = x1 / 21;
				x2 = x1 % 21;
				c = x2 / 3;
				d = x2 % 3;
				if (x1 == 0) {
					b = b + 3;
					c = c + 7;
					d = d + 3;
				} else if (x2 == 0) {
					a = a + 1;
					c = c + 7;
					d = d + 3;
				} else if (d == 0) {
					a = a + 1;
					b = b + 1;
					d = d + 3;
				} else {
					a = a + 1;
					b = b + 1;
					c = c + 1;
				}
				realtimeslot =  a.toString()+"."+b.toString()
					+ c.toString() + d.toString();
			}
			
			return realtimeslot;
			
		}
		
		public static function permissionControlList(modelName:String,remoteObject:RemoteObject):void{
			 remoteObject.endpoint = ModelLocator.END_POINT;
			 remoteObject.showBusyCursor = true;
			 remoteObject.getPermissionByUserId(modelName);
	    }
	    //判断当前登录用户是否有操作该单位的权限，如果返回字符串"true"则有 "false"没有
		public static function getPermissionControlByUserDepartAndConfigDepartAndResouseDept(tablename:String,property:String,key:String,value:String,remoteObject:RemoteObject):void{
			remoteObject.endpoint = ModelLocator.END_POINT;
			remoteObject.showBusyCursor = true;
			remoteObject.getPermissionControlByUserDepartAndConfigDepartAndResouseDept(tablename,property,key,value);
		}
		
		public static function getEndPoint():String{
			var endPoint:String = "";
			var currpngUrl = getContext();
			currpngUrl += "/";
			endPoint = currpngUrl + "messagebroker/amf";
			return endPoint;
		}
		
	}
}