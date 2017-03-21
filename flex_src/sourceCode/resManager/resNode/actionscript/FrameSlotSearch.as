// ActionScript file
import sourceCode.resManager.resNode.Events.slotSearchEvent;
import sourceCode.resManager.resNode.Titles.SearchSlotTitle;
import sourceCode.resManager.resNode.model.FrameSlot;

[Event(name="slotSearchEvent",type="sourceCode.resManager.resNode.Events.slotSearchEvent")]

import common.actionscript.MyPopupManager;
import common.actionscript.ModelLocator;
import mx.rpc.remoting.mxml.RemoteObject;
import mx.rpc.events.ResultEvent;
import mx.events.ListEvent;
import mx.managers.PopUpManager;
import mx.controls.Alert;

public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");

/**
 * 查询。
 **/
protected function searchClickHandler(event:MouseEvent):void
{
	var frameModel:FrameSlot = new FrameSlot();
	
	if(frameserial.selectedItem !=null){
		frameModel.frameserial = frameserial.selectedItem.@code;
	}
	if(slot_status.selectedItem != null){
		frameModel.status=slot_status.selectedItem.@id;
	}
	if(slotserial.selectedItem != null){
		frameModel.slotserial = slotserial.selectedItem.@code;
	}
	frameModel.equipname = equipname.text;
//	frameModel.slotserial = slotserial.text;
	frameModel.panelwidth = panelwidth.text;
	frameModel.panellength = panellength.text;
	this.dispatchEvent(new slotSearchEvent("slotSearchEvent",frameModel));
	MyPopupManager.removePopUp(this);
}

/**
 * 重置。
 **/
protected function button1_clickHandler(event:MouseEvent):void
{
	slot_status.selectedIndex=-1;
	frameserial.dropdown.dataProvider=null;
	frameserial.text="";
	frameserial.selectedIndex = -1;
	
	slotserial.dropdown.dataProvider = null;
	slotserial.text = "";
	slotserial.selectedIndex = -1;
	
	panelwidth.text = "";
	panellength.text = "";
	equipname.text = "";
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
		equipname.text=obj.id;
		equipcode.text = obj.name;
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
/**
 * 根据设备ID和机框ID查询机槽序号列表
 * 
 */
 private function selectFrameSlotEvent(event:ListEvent):void{
	 var code = equipcode.text;
	 var frameSerial = frameserial.text;
	 if(code!= null&&code!="" &&frameSerial!=null&&frameSerial!=""){
		 var rt:RemoteObject=new RemoteObject("resNodeDwr");
		 rt.endpoint=ModelLocator.END_POINT;
		 rt.showBusyCursor=true;
		 rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent){
			 var eqsearchLst:XMLList= new XMLList(event.result);
			 slotserial.dropdown.dataProvider=eqsearchLst;
			 slotserial.dataProvider=eqsearchLst;
			 slotserial.text="";
			 slotserial.selectedIndex=-1;
			 
		 });
		 rt.getSlotserialByeIds(code,frameSerial);
	 }
 }

