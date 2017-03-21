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

import sourceCode.resManager.resNode.model.Frame;

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
	var ct:Frame = new Frame();
	
	ct.equipcode = equipcode.text;
	ct.shelfinfo = shelfinfo.text;
//	ct.s_framename = s_framename.text;
	if(frame_state.selectedItem != null){
		ct.frame_state = frame_state.selectedItem.@id;
	}else{
		ct.frame_state = frame_state1.text;
	}
	ct.frontheight = frontheight.text;
	ct.frameserial = frameserial.text;
	if(framemodel.selectedItem != null){
		ct.framemodel = framemodel.selectedItem.@id;
	}else{
		ct.framemodel = framemodel1.text;
	}
	ct.frontwidth = frontwidth.text;
	ct.remark = remark.text;
	ct.updatedate=this.getNowTime();
	ct.updateperson = parentApplication.curUserName;
	
	obj.modifyEquipFrame(ct);
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
///**
// * 
// * 获取状态列表
// * 
// * */
//private function getFrameState():void{
//	var re:RemoteObject=new RemoteObject("resNodeDwr");
//	re.endpoint = ModelLocator.END_POINT;
//	re.showBusyCursor = true;
//	re.addEventListener(ResultEvent.RESULT,resultStateLstHandler);
//	re.getFrameState(); 
//	
//}
//
////获取状态列表
//public function resultStateLstHandler(event:ResultEvent):void{
//	var x_purposeList:XMLList= new XMLList(event.result);
//	frame_state.dropdown.dataProvider=x_purposeList;
//	frame_state.dataProvider=x_purposeList;
//	frame_state.labelField="@label";
//	frame_state.text="";
//	frame_state.selectedIndex=-1;
//	frame_state.text = frame_state1.text;
//}
///**
// * 
// * 获取型号列表
// * 
// * */
//private function getFrameModel():void{
//	var re:RemoteObject=new RemoteObject("resNodeDwr");
//	re.endpoint = ModelLocator.END_POINT;
//	re.showBusyCursor = true;
//	re.addEventListener(ResultEvent.RESULT,resultModelLstHandler);
//	re.getFrameModel(); 
//	
//}
//
////获取型号列表
//public function resultModelLstHandler(event:ResultEvent):void{
//	var x_purposeList:XMLList= new XMLList(event.result);
//	framemodel.dropdown.dataProvider=x_purposeList;
//	framemodel.dataProvider=x_purposeList;
//	framemodel.labelField="@label";
//	framemodel.text="";
//	framemodel.selectedIndex=-1;
//	framemodel.text = framemodel1.text;
//}
/**
 * 获取当前时间
 */
protected function getNowTime():String{
	var dateFormatter:DateFormatter = new DateFormatter();
	dateFormatter.formatString = "YYYY-MM-DD JJ:NN:SS";
	var nowDate:String= dateFormatter.format(new Date());
	return nowDate;
}

