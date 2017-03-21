import com.adobe.utils.StringUtil;

import common.actionscript.ModelLocator;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

public var odfodmcode:String;
public var startserial:String;
public var listSubOdfOdm:ArrayCollection;

private function init():void{
	var ro:RemoteObject = new RemoteObject("wireConfiguration");
	ro.endpoint = ModelLocator.END_POINT;
	ro.showBusyCursor = true;
}

private function close():void{
	PopUpManager.removePopUp(this);
}

private function save():void{
	var pattern:RegExp = /^[a-z|A-Z]{1}$|^[a-z|A-Z]{1}[0-9]{1,2}$/;
	var result:Object ;
	if(StringUtil.trim(txtnewlabel.text) == ""){
		Alert.show("新起始标签不能为空！","提示");
		return;
	}
	
	result = pattern.exec(txtnewlabel.text);
	if(result == null){
		Alert.show("请输入正确的标签！","提示");
		return;
	}
	
//	if(txtoldlabel.text.substring(0,1).toLocaleUpperCase() != txtnewlabel.text.substring(0,1).toLocaleUpperCase() ){
//		Alert.show("新标签前置字母与原标签前置字母不一致！","提示");
//		return;
//	}
	
	if(txtoldlabel.text == txtnewlabel.text){
		Alert.show("标签没有改变！","提示");
		return;
	}
	var ro:RemoteObject = new RemoteObject("wireConfiguration");
	ro.endpoint= ModelLocator.END_POINT;
	ro.showBusyCursor = true;
	ro.modifySubOdfOdmLabel(cmbStart.selectedIndex,cmbEnd.selectedIndex,txtnewlabel.text.toLocaleUpperCase(),listSubOdfOdm,parentApplication.curUser);
	ro.addEventListener(ResultEvent.RESULT,wireconfigResultHandler);
}

private function wireconfigResultHandler(evetn:ResultEvent):void{
	PopUpManager.removePopUp(this);
	dispatchEvent(new Event("saveCompleteHandler"));
}	