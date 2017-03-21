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
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;
[Event(name="CircuitChannelEvent",type="sourceCode.resManager.resBusiness.events.CircuitChannelEvent")]
import sourceCode.autoGrid.view.TreeWindow;
import sourceCode.resManager.resBusiness.events.CircuitChannelEvent;
import sourceCode.resManager.resBusiness.model.CircuitChannelModel;
import mx.core.Application;

public var days:Array=new Array("日", "一", "二", "三", "四", "五", "六");
public var monthNames:Array=new Array("一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月");
private var XMLData_Rate:XMLList;

//public var circuitcode_bak:String="";

/**
 *点击按钮后的处理函数
 * @param event
 * 
 */
protected function btn_clickHandler(event:MouseEvent):void
{
	var obj:RemoteObject = new RemoteObject("resBusinessDwr");
	obj.endpoint = ModelLocator.END_POINT;
	obj.showBusyCursor = true;
	var ct:CircuitChannelModel = new CircuitChannelModel();
	
	ct.channelcode = channelcode.text;
	ct.circuit = circuit.text;
	ct.porta = porta.text;
	ct.portz = portz.text;
	ct.slot1 = slot1.text;
	ct.slot2 = slot2.text;
	if(rate.selectedItem!=null){
		ct.rate = rate.selectedItem.@label;
	}
	
	this.dispatchEvent(new CircuitChannelEvent("CircuitChannelEvent",ct));
	PopUpManager.removePopUp(this);
}



protected function initApp():void
{
	//获取速率列表
	var rtobj11:RemoteObject = new RemoteObject("equInfo");
	Application.application.faultEventHandler(rtobj11);
	rtobj11.endpoint = ModelLocator.END_POINT;
	rtobj11.showBusyCursor = true;
	rtobj11.getFromXTBM('YW0102__');//根据系统编码查询对应信息(速率)
	rtobj11.addEventListener(ResultEvent.RESULT, function(e:ResultEvent):void{
		XMLData_Rate = new XMLList(e.result.toString());
		rate.dataProvider = XMLData_Rate.children();
		rate.selectedIndex = -1;
	});
}
