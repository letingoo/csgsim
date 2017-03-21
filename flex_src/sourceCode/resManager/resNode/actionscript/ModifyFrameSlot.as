// ActionScript file
import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.other.events.CustomEvent;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TextEvent;

import mx.controls.Alert;
import mx.controls.TextInput;
import mx.core.IFlexDisplayObject;
import mx.formatters.DateFormatter;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import sourceCode.resManager.resNode.model.FrameSlot;

/**
 *点击按钮后的处理函数
 * @param event
 * 
 */
protected function btn_clickHandler(event:MouseEvent):void
{
	var obj:RemoteObject = new RemoteObject("resNodeDwr");
	obj.endpoint = ModelLocator.END_POINT;
	obj.showBusyCursor = true;
	var ct:FrameSlot = new FrameSlot();
	
	ct.equipcode = equipcode.text;
	ct.equipname = equipname.text;
	ct.slotserial = slotserial.text;
	if(status0.selectedItem != null){
		ct.status = status0.selectedItem.@id;
	}else{
		ct.status = status1.text;
	}
	ct.panellength = panellength.text;
	ct.remark = remark.text;
	ct.frameserial = frameserial.text;
	ct.panelwidth = panelwidth.text;
	
	ct.updatedate=this.getNowTime();
	ct.updateperson = parentApplication.curUserName;
	
	obj.modifyEquipSlot(ct);
	obj.addEventListener(ResultEvent.RESULT,updateHandler);
	
	PopUpManager.removePopUp(this);
}

private function updateHandler(e:ResultEvent):void{
	if(e.result!=null){
		if(e.result.toString()=="success")
		{
			Alert.show("更新成功!","提示");
			this.dispatchEvent(new Event("RefreshDataGrid"))
		}else
		{
			Alert.show("请按要求填写数据！","提示");
		}
	}
}

protected function initApp():void
{
	//	获取状态列表
//	getFrameState();
	//获取设备类型列表
//	getFrameModel();
}

/**
 * 获取当前时间
 */
protected function getNowTime():String{
	var dateFormatter:DateFormatter = new DateFormatter();
	dateFormatter.formatString = "YYYY-MM-DD JJ:NN:SS";
	var nowDate:String= dateFormatter.format(new Date());
	return nowDate;
}

