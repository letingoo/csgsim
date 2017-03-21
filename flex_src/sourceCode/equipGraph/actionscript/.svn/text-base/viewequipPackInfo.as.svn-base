	import common.actionscript.MyPopupManager;
	
	import mx.controls.*;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	import sourceCode.equipGraph.model.*;
	import twaver.Constant;
	import twaver.Data;
	import twaver.Follower;
	public var packcode:String;
	public var node:Follower;
	private function close():void  
	{  
		MyPopupManager.removePopUp(this);  
	}
	//更新属性信息
	private function savePackInfo():void{
		
		var packInfo:PackInfoModel = new PackInfoModel();
		packInfo.frameserial = frameserial.text;//机框序号
		packInfo.slotserial = slotserial.text;//机槽序号
		packInfo.packmodel = packmodel.text;//机盘型号
		packInfo.packserial = packserial.text;//机盘序号
		packInfo.updatedate = updatedate.text;//更新时间
		packInfo.remark =remark.text;//备注
		packInfo.updateperson = updateperson.text;//更新人
		var rtobj:RemoteObject = new RemoteObject("devicePanel");
		rtobj.endpoint = ModelLocator.END_POINT;
		rtobj.showBusyCursor = true;
		rtobj.addEventListener(ResultEvent.RESULT,updateResult);
		Application.application.faultEventHandler(rtobj);
		rtobj.updateEquipPack(packInfo,packcode);//更新属性信息
	}

	private function updateResult(event:ResultEvent):void{
		if(event.result.toString()=="success"){
			packcode=(packcode.split(","))[0]+","+frameserial.text+","+slotserial.text+","+packserial.text;
			node.setClient("packcode",packcode);
			Alert.show("更新成功","提示");
		}else{
			Alert.show("更新失败","提示");
		}
	}