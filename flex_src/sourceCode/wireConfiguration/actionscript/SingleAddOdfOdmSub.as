import com.adobe.utils.StringUtil;

import common.actionscript.ModelLocator;

import flash.events.ContextMenuEvent;

import mx.controls.Alert;
import mx.core.Application;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

public var startSerial:String;
public var odfodmcode:String;

private function init():void{
	txtlabel.setFocus();
}

private function save():void{
	var pattern:RegExp = /^[a-z|A-Z]{1}$|^[a-z|A-Z]{1}[0-9]{1,2}$/;
	var result:Object ;
	if(StringUtil.trim(txtlabel.text) == ""){
		Alert.show("子模块标签不能为空！","提示");
		return;
	}
	
	result = pattern.exec(txtlabel.text);
	if(result == null){
		Alert.show("请输入正确的标签！","提示");
		return;
	}
	
	var ro:RemoteObject = new RemoteObject("wireConfiguration");
	ro.endpoint= ModelLocator.END_POINT;
	ro.showBusyCursor = true;
	ro.checkLabelExists(txtlabel.text.toLocaleUpperCase(),odfodmcode);
	ro.addEventListener(ResultEvent.RESULT,checkResultHandler);
	
}

private function checkResultHandler(event:ResultEvent):void{
	var count:int = event.result as Number;
	if(count > 0 ){
		Alert.show("该标签已经存在！","提示");
		return;
	}
	
	var ro:RemoteObject = new RemoteObject("wireConfiguration");
	ro.endpoint= ModelLocator.END_POINT;
	ro.showBusyCursor = true;
	ro.addOdfOdmLabel(txtlabel.text.toLocaleUpperCase(),startSerial,odfodmcode,parentApplication.curUser);
	ro.addEventListener(ResultEvent.RESULT,wireconfigResultHandler);
	
}	

private function wireconfigResultHandler(event:ResultEvent):void{
	PopUpManager.removePopUp(this);
	dispatchEvent(new Event("savePropertyComplete"));
}

private function close():void{
	PopUpManager.removePopUp(this);
}