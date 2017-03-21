import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.events.CloseEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import sourceCode.channelRoute.model.Circuit;
import sourceCode.channelRoute.views.tandemcircuit;
import sourceCode.packGraph.views.checkedEquipPack;

import twaver.Follower;
import twaver.Node;
import twaver.SequenceItemRenderer;
import twaver.XMLSerializer;

private var lastRollOverIndex:int;
private var XMLData:XML;	
public var c_circuitcode:String=null;
public var port_a:String=null;
public var port_z:String=null;
public var tandem:tandemcircuit;
public var equippack:checkedEquipPack;
public var follower:Follower;
private var indexRenderer = SequenceItemRenderer;
public function init():void{
	businessDispatchRemote.getItems();
	Application.application.showLoading();  
	businessDispatchRemote.addEventListener(ResultEvent.RESULT,setDataProvide);
}
private function close():void  
{  
	MyPopupManager.removePopUp(this);  
}
private function DealFault(event:FaultEvent):void {
	Alert.show(event.fault.toString());
	trace(event.fault);
}
private function setDataProvide(e:ResultEvent):void{
	Application.application.removeLoading();
	var orgData:ArrayCollection = new ArrayCollection();
	XMLData = new XML(e.result.toString());
	
	for each(var arrxml:XML in XMLData.children())
	{
		orgData.addItem(arrxml);
	}
	
	todobusinessGrid.dataProvider=orgData;
	todobusinessGrid.invalidateList();
//	todobusinessGridPagingBar.dataGrid=todobusinessGrid;
//	todobusinessGridPagingBar.orgData=orgData;
//	todobusinessGridPagingBar.dataBind();
}

private function selectData(e:Event):void{
	var alertString:String = "确认关联此条方式申请单？";
	if(c_circuitcode!=null&&c_circuitcode!=""){
		alertString = "该电路已经关联过方式了，方式单编号为："+c_circuitcode+"，您确认替换原来的方式吗？";
	}
	Alert.show(alertString,
		"提示",
		Alert.YES|Alert.NO,
		null,
		confirm
	);
}
private function confirm(e:CloseEvent):void{
	if(e.detail==Alert.YES){
		var serializer:XMLSerializer = new XMLSerializer(tandem.channelPic.elementBox);
		var xml:String = serializer.serialize();
		var circuit:Circuit = new Circuit();
		circuit.circuitcode=c_circuitcode;
		var item:Object = todobusinessGrid.selectedItem;
		//Alert.show(item.@type);
		circuit.requisitionid=item.@form_no;
		circuit.operationtype=item.@type;
		circuit.rate = item.@speedname;
		circuit.requestcom = item.@appdepartment;
		circuit.remark = item.@formName;
		circuit.form_id = item.@form_id;
		circuit.portserialno1 = this.port_a;
		circuit.portserialno2 = this.port_z;
		var rtobj:RemoteObject = new RemoteObject("channelTree");
		rtobj.endpoint = ModelLocator.END_POINT;
		rtobj.showBusyCursor = true;
		rtobj.relateCircuit1(circuit,xml);//更新设备信息
		rtobj.addEventListener(ResultEvent.RESULT,function(e:ResultEvent):void{
			Alert.show("方式关联成功!方式单编号为："+e.result.toString(),"提示");
			c_circuitcode = e.result.toString();
			tandem.channelPic.name = e.result.toString();
			tandem.c_circuitcode = e.result.toString();
			if(equippack!=null){
				equippack.drawPort();
			}
		});	
	}
	
}