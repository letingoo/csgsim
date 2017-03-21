import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import org.flexunit.runner.Result;

[Bindable]
public var aname:String;
[Bindable]
public var zname:String;
[Bindable]
public var del:Boolean;
public var aslots:ArrayCollection;
public var zslots:ArrayCollection;
public var astartslot:String;
public var zstartslot:String;
public var parentObject:Object; 
private function initPage():void{
	if(aslots != null && aslots.length > 0){
		for(var i:int = 0; i < aslots.length; i++){
			cmbStartA.dataProvider.addItem({label:aslots.getItemAt(i).rate + "-" +aslots.getItemAt(i).aslot});
			if(aslots.getItemAt(i).aslot == astartslot)
				cmbStartA.selectedIndex = i;
			cmbEndA.dataProvider.addItem({label:aslots.getItemAt(i).rate + "-" +aslots.getItemAt(i).aslot});
		}
	}
	
	if(zslots != null && zslots.length > 0 ){
		for(var j:int = 0; j < zslots.length; j++){
			cmbStartZ.dataProvider.addItem({label:zslots.getItemAt(j).rate + "-" + zslots.getItemAt(j).aslot});
			if(zslots.getItemAt(j).aslot == zstartslot)
				cmbStartZ.selectedIndex = j;
			cmbEndZ.dataProvider.addItem({label:zslots.getItemAt(j).rate + "-" +zslots.getItemAt(j).aslot});
		}
	}
	
	cmbEndA.selectedIndex = cmbEndA.dataProvider.length - 1;
	cmbEndZ.selectedIndex = cmbEndZ.dataProvider.length - 1;
}

private function save():void{
	var startA:int = cmbStartA.selectedIndex;
	var endA:int = cmbEndA.selectedIndex;
	var startZ:int = cmbStartZ.selectedIndex;
	var endZ:int = cmbEndZ.selectedIndex;
	if(startA > endA || startZ > endZ){
		Alert.show("起始时隙不能大于终止时隙！","提示");
		return;
	}
	var ro:RemoteObject = new RemoteObject("channelTree");
	ro.showBusyCursor = true;
	ro.endpoint = ModelLocator.END_POINT;
	if(!del){
		ro.batchInsertCC(startA,endA,startZ,endZ,aslots,zslots);
		ro.addEventListener(ResultEvent.RESULT,addResultHandler);
	}else{
		ro.batchDelCC(startA,endA,startZ,endZ,aslots,zslots);
		ro.addEventListener(ResultEvent.RESULT,delResultHandler);
	}
}

private function delResultHandler(event:ResultEvent):void{
	MyPopupManager.removePopUp(this);
	var str:String = event.result.toString();
	if(str != null && str != "")
		this.parentObject.batchDelSuccessResultHanler(str);
}
private function addResultHandler(event:ResultEvent):void{
	this.dispatchEvent(new Event("SaveComplete"));
}
private function close():void{
	this.dispatchEvent(new Event("CancelComplete"));
}