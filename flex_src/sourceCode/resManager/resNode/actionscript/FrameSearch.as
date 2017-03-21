// ActionScript file
import sourceCode.resManager.resNode.Events.frameSearchEvent;
import sourceCode.resManager.resNode.model.Frame;

[Event(name="frameSearchEvent",type="sourceCode.resManager.resNode.Events.frameSearchEvent")]

import common.actionscript.MyPopupManager;
import mx.managers.PopUpManager;
import mx.controls.Alert;
import sourceCode.resManager.resNode.Titles.SearchSlotTitle;
import mx.rpc.remoting.mxml.RemoteObject;
import common.actionscript.ModelLocator;
import mx.rpc.events.ResultEvent;

public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");

/**
 * 查询。
 **/
protected function searchClickHandler(event:MouseEvent):void
{
	var frameModel:Frame = new Frame();
	if(framemodel.selectedItem != null){
		frameModel.framemodel = framemodel.selectedItem.@id;
	}
	if(frame_state.selectedItem != null){
		frameModel.frame_state = frame_state.selectedItem.@id;
	}
	if(frameserial.selectedItem != null){
		frameModel.frameserial = frameserial.selectedItem.@code;
	}
//	frameModel.s_framename = s_framename.text;
//	frameModel.frameserial = frameserial.text;
	frameModel.frontheight = frontheight.text;
	frameModel.frontwidth = frontwidth.text;
//	frameModel.updatedate_start = updatedate_start.text;
//	frameModel.updatedate_end = updatedate_end.text;
	frameModel.remark = remark.text;
	frameModel.shelfinfo = shelfinfo.text;
	this.dispatchEvent(new frameSearchEvent("frameSearchEvent",frameModel));
	MyPopupManager.removePopUp(this);
}

/**
 * 重置。
 **/
protected function button1_clickHandler(event:MouseEvent):void
{
	frame_state.selectedIndex=-1;
	framemodel.selectedIndex=-1;
//	s_framename.text="";
	frontheight.text = "";
	frameserial.dropdown.dataProvider=null;
	frameserial.text = "";
	frameserial.selectedIndex = -1;
	frontwidth.text = "";
	remark.text = "";
//	updatedate_start.text = "";
//	updatedate_end.text = "";
	shelfinfo.text = "";
}

/**
 * @todo 设备的选择 
 * @param event
 * 
 */
private function searchEquipment(event:MouseEvent):void{
	var packeqsearch:SearchSlotTitle=new SearchSlotTitle();
	packeqsearch.page_parent=this;
	packeqsearch.child_systemcode=null;
	packeqsearch.child_vendor=null;
	PopUpManager.addPopUp(packeqsearch,this,true);
	PopUpManager.centerPopUp(packeqsearch);
	packeqsearch.myCallBack=function(obj:Object){
		shelfinfo.text=obj.id;
		var code:String = obj.name;
		var rt:RemoteObject=new RemoteObject("resNodeDwr");
		rt.endpoint=ModelLocator.END_POINT;
		rt.showBusyCursor=true;
		rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent){
			var eqsearchLst:XMLList= new XMLList(event.result);
			frameserial.dropdown.dataProvider=eqsearchLst;
			frameserial.dataProvider=eqsearchLst;
			frameserial.text="";
			frameserial.selectedIndex=-1;
			
		});
		rt.getFrameserialByeId(code);
	}
}



