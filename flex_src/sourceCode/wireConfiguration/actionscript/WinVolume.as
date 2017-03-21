import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;

import flash.events.Event;
import flash.geom.Point;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import sourceCode.wireConfiguration.views.WireConfigRelationList;

import twaver.DataBox;

[Bindable]public var nameA:String = "";
[Bindable]public var nameZ:String = "";

public var startA:String;
public var startZ:String;
public var countA:int;
public var countZ:int;
public var acPortsA:ArrayCollection;
public var acPortsZ:ArrayCollection;
public var field:String;
public var markType:String;
public var resetModule:String;
public var point:Point;
public var point1:Point;
private var type:String = "";
private var code:String = "";
private var code1:String = "";
private var type1:String = "";

[Bindable]public var del:Boolean;
public var relationWireConfig:RelationWireConfig;

private function initPage():void{
	if(acPortsA.length > 0 && acPortsZ.length > 0){
		var arr:Array = resetModule.split("-");
		if(arr.length == 2){
			type = arr[0];
			if(type == "ODF"){
				for(var i:int = 0; i < acPortsA.length; i ++){
					cmbStartA.dataProvider.addItem({label:acPortsA.getItemAt(i).name});
					if(acPortsA.getItemAt(i).name == startA)
						cmbStartA.selectedIndex = i;
					cmbEndA.dataProvider.addItem({label:acPortsA.getItemAt(i).name});
				}
				for(var j:int = 0; j < acPortsZ.length; j ++){
					cmbStartZ.dataProvider.addItem({label:acPortsZ.getItemAt(j).name});
					if(acPortsZ.getItemAt(j).name == startZ)
						cmbStartZ.selectedIndex = j;
					cmbEndZ.dataProvider.addItem({label:acPortsZ.getItemAt(j).name});
				}
			}else{
				for(var i:int = 0; i < acPortsA.length; i ++){
					cmbStartA.dataProvider.addItem({label:acPortsA.getItemAt(i).portserial});
					if(acPortsA.getItemAt(i).portserial == startA)
						cmbStartA.selectedIndex = i;
					cmbEndA.dataProvider.addItem({label:acPortsA.getItemAt(i).portserial});
				}
				for(var j:int = 0; j < acPortsZ.length; j ++){
					cmbStartZ.dataProvider.addItem({label:acPortsZ.getItemAt(j).portserial});
					if(acPortsZ.getItemAt(j).portserial == startZ)
						cmbStartZ.selectedIndex = j;
					cmbEndZ.dataProvider.addItem({label:acPortsZ.getItemAt(j).portserial});
				}
			}
		}else if(arr.length == 4){
			type = arr[0];
			type1 = arr[2];
			code = arr[1];
			code1 = arr[3];
			if(type == "ODF"){
				for(var i:int = 0; i < acPortsA.length; i ++){
					cmbStartA.dataProvider.addItem({label:acPortsA.getItemAt(i).name});
					if(acPortsA.getItemAt(i).name == startA)
						cmbStartA.selectedIndex = i;
					cmbEndA.dataProvider.addItem({label:acPortsA.getItemAt(i).name});
				}
			}else{
				for(var i:int = 0; i < acPortsA.length; i ++){
					cmbStartA.dataProvider.addItem({label:acPortsA.getItemAt(i).portserial});
					if(acPortsA.getItemAt(i).portserial == startA)
						cmbStartA.selectedIndex = i;
					cmbEndA.dataProvider.addItem({label:acPortsA.getItemAt(i).portserial});
				}
			}
			
			if(type1 == "ODF"){
				for(var j:int = 0; j < acPortsZ.length; j ++){
					cmbStartZ.dataProvider.addItem({label:acPortsZ.getItemAt(j).name});
					if(acPortsZ.getItemAt(j).name == startZ)
						cmbStartZ.selectedIndex = j;
					cmbEndZ.dataProvider.addItem({label:acPortsZ.getItemAt(j).name});
				}
			}else{
				for(var j:int = 0; j < acPortsZ.length; j ++){
					cmbStartZ.dataProvider.addItem({label:acPortsZ.getItemAt(j).portserial});
					if(acPortsZ.getItemAt(j).portserial == startZ)
						cmbStartZ.selectedIndex = j;
					cmbEndZ.dataProvider.addItem({label:acPortsZ.getItemAt(j).portserial});
				}
			}
		}
		
		cmbEndA.selectedIndex = cmbEndA.dataProvider.length - 1;
		cmbEndZ.selectedIndex = cmbEndZ.dataProvider.length - 1;
	}else{
		Alert.show("未找到端口数据","提示");
	}
}


private function RefreshCompletedHandler(event:Event):void{
	relationWireConfig.removeEventListener("RefreshCompleted",RefreshCompletedHandler);
	var arr:Array = resetModule.split("-");
	if(arr.length == 2){
		type = arr[0];
		code = arr[1];
		if(type == "DDF" || type == "ODF")
			relationWireConfig.addMoreModules(code,type,point);
	}else if(arr.length == 4){
		type = arr[0];
		type1 = arr[2];
		code = arr[1];
		code1 = arr[3];
		relationWireConfig.addEventListener("graphicsModuleCompleted",graphicNextHandler);
		relationWireConfig.addMoreModules(code,type,point);
	}
	PopUpManager.removePopUp(this);
}

private function graphicNextHandler(event:Event):void{
	relationWireConfig.removeEventListener("graphicsModuleCompleted",graphicNextHandler);
	relationWireConfig.addMoreModules(code1,type1,point1);
}

private function save():void{
	//				if(check.selected){
	sendRequest();
	//				}else{
	//					if(acPortsA.length != acPortsZ.length){
	//						Alert.show("两端端口数量不一致,是否继续?","提示",Alert.YES|Alert.NO,this,closeHandler);
	//					}
	//				}
}

private function closeHandler(event:CloseEvent):void{
	if(event.detail == Alert.YES){
		sendRequest();
	}
}

private function sendRequest():void{
	var startA:int = cmbStartA.selectedIndex;
	var endA:int = cmbEndA.selectedIndex;
	var startZ:int = cmbStartZ.selectedIndex;
	var endZ:int = cmbEndZ.selectedIndex;
	if(startA > endA || startZ > endZ){
		Alert.show("起始端口序不能大于终止端口序号！","提示");
		return;
	}
	var numA:int = startA;
	var numZ:int = startZ;
	var tempPorts:ArrayCollection = new ArrayCollection();
	var arr:Array = resetModule.split("-");
	if(arr.length == 2){
		type = arr[0];
		while(numA <= endA && numZ <= endZ){
			if(!del){
				if(parseInt(acPortsA.getItemAt(numA).linecount) < 2 && parseInt(acPortsZ.getItemAt(numZ).linecount) < 2){
					if(type =="ODF"){
						tempPorts.addItem({nameA:acPortsA.getItemAt(numA).name,nameZ:acPortsZ.getItemAt(numZ).name});
					}else{
						tempPorts.addItem({nameA:acPortsA.getItemAt(numA).portserial,nameZ:acPortsZ.getItemAt(numZ).portserial});
					}
					numA++;
					numZ++;
				}else if(parseInt(acPortsA.getItemAt(numA).linecount) < 2 && parseInt(acPortsZ.getItemAt(numZ).linecount) >= 2){
					numZ++;
				}else if(parseInt(acPortsA.getItemAt(numA).linecount) >= 2 && parseInt(acPortsZ.getItemAt(numZ).linecount) < 2){
					numA++;	
				}else{
					numA++;
					numZ++;
				}
			}else{
				if(type =="ODF"){
					tempPorts.addItem({nameA:acPortsA.getItemAt(numA).name,nameZ:acPortsZ.getItemAt(numZ).name});
				}else{
					tempPorts.addItem({nameA:acPortsA.getItemAt(numA).portserial,nameZ:acPortsZ.getItemAt(numZ).portserial});
				}
				numA++;
				numZ++;
			}
		}
	}else{
		type = arr[0];
		type1 = arr[2];
		while(numA <= endA && numZ <= endZ){
			if(!del){
				if(parseInt(acPortsA.getItemAt(numA).linecount) < 2 && parseInt(acPortsZ.getItemAt(numZ).linecount) < 2){
					if(type =="ODF" && type1 == "ODF"){
						tempPorts.addItem({nameA:acPortsA.getItemAt(numA).name,nameZ:acPortsZ.getItemAt(numZ).name});
					}else if(type =="ODF" && type1 != "ODF"){
						tempPorts.addItem({nameA:acPortsA.getItemAt(numA).name,nameZ:acPortsZ.getItemAt(numZ).portserial});
					}else if(type != "ODF" && type1 == "ODF"){
						tempPorts.addItem({nameA:acPortsA.getItemAt(numA).portserial,nameZ:acPortsZ.getItemAt(numZ).name});
					}else{
						tempPorts.addItem({nameA:acPortsA.getItemAt(numA).portserial,nameZ:acPortsZ.getItemAt(numZ).portserial});
					}
					numA++;
					numZ++;
				}else if(parseInt(acPortsA.getItemAt(numA).linecount) < 2 && parseInt(acPortsZ.getItemAt(numZ).linecount) >= 2){
					numZ++;
				}else if(parseInt(acPortsA.getItemAt(numA).linecount) >= 2 && parseInt(acPortsZ.getItemAt(numZ).linecount) < 2){
					numA++;	
				}else{
					numA++;
					numZ++;
				}
			}else{
				if(type =="ODF" && type1 == "ODF"){
					tempPorts.addItem({nameA:acPortsA.getItemAt(numA).name,nameZ:acPortsZ.getItemAt(numZ).name});
				}else if(type =="ODF" && type1 != "ODF"){
					tempPorts.addItem({nameA:acPortsA.getItemAt(numA).name,nameZ:acPortsZ.getItemAt(numZ).portserial});
				}else if(type != "ODF" && type1 == "ODF"){
					tempPorts.addItem({nameA:acPortsA.getItemAt(numA).portserial,nameZ:acPortsZ.getItemAt(numZ).name});
				}else{
					tempPorts.addItem({nameA:acPortsA.getItemAt(numA).portserial,nameZ:acPortsZ.getItemAt(numZ).portserial});
				}
				numA++;
				numZ++;
			}
		}
	}
	
	var form:WireConfigRelationList = new WireConfigRelationList();
	form.acPorts = tempPorts;
	form.headertextA = nameA;
	form.headertextZ = nameZ;
	MyPopupManager.addPopUp(form,true);
	form.addEventListener("confrimCompleted",function(event:Event = null):void{
		relationWireConfig.addEventListener("RefreshCompleted",RefreshCompletedHandler);
		if(!del){
			if(markType == "matrix")
				getRemoteObject("wireConfiguration",volumeCompleted).addPortsToMatrix(startA,endA,startZ,endZ,acPortsA,acPortsZ);
			else
				getRemoteObject("wireConfiguration",volumeCompleted).addPortsToFiber(startA,endA,startZ,endZ,acPortsA,acPortsZ,field);
		}else{
			if(markType == "matrix"){
				getRemoteObject("wireConfiguration",delvolumeCompleted).delPortsFromMatrix(startA,endA,startZ,endZ,acPortsA,acPortsZ);
			}
			else{
				getRemoteObject("wireConfiguration",delvolumeCompleted).delPortsToFiber(startA,endA,startZ,endZ,acPortsA,acPortsZ,field);
			}
		}
	});
}

private function volumeCompleted(event:ResultEvent):void{
	relationWireConfig.dispatchEvent(new Event("RefreshLinesData"));
}

private function delvolumeCompleted(event:ResultEvent):void{
	if(event.result.toString() != ""){
		var arr:Array = event.result.toString().split(",");
		if(markType == "matrix"){
			if(nameA.indexOf("ODF") != -1 || nameZ.indexOf("ODF") != -1){
				for(var i:int = 0; i < arr.length - 1; i++){
					this.relationWireConfig.delMatrixsLink(arr[i],"ODF");
				}
			}else{
				for(var j:int = 0; j < arr.length - 1; j++){
					this.relationWireConfig.delMatrixsLink(arr[j],"DDF");
				}
			}
		}else{
			for(var t:int = 0; t < arr.length - 1; t++){
				this.relationWireConfig.delFibersLink(arr[t]);
			}
		}
	}
	relationWireConfig.dispatchEvent(new Event("RefreshLinesData"));
}

private function close():void{
	var data:DataBox = relationWireConfig.dataBox;
	if(!del){
		data.removeByID(relationWireConfig._tempLinkID);		
	}
	PopUpManager.removePopUp(this);
}

protected function getRemoteObject(servicename:String,resultfunction:Function=null):RemoteObject{
	var remoteObject:RemoteObject = new RemoteObject(servicename);
	remoteObject.endpoint = ModelLocator.END_POINT;
	remoteObject.showBusyCursor = true;
	if(resultfunction != null){
		remoteObject.addEventListener(ResultEvent.RESULT,resultfunction);
	}
	remoteObject.addEventListener(FaultEvent.FAULT,function fault(event:FaultEvent):void{
		Alert.show(event.message.toString());
	});
	return remoteObject;
}