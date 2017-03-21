import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;

import flash.display.BitmapData;
import flash.utils.ByteArray;

import flexunit.utils.Collection;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.graphics.codec.PNGEncoder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import sourceCode.ocableroute.model.OcableRouteContent;
import sourceCode.ocableroute.model.OcableRouteData;
import sourceCode.ocableroute.model.OcableStation;

import twaver.DemoImages;
import twaver.IElement;
import twaver.XMLSerializer;

public var opticalPort:String;
public var xml:String ="";
public var ocableRouteData:OcableRouteData;
public var content:OcableRouteContent;

public var nodecode:String; //节点编码
public var nodetype:String; //节点类型

private function init():void{
	if(ocableRouteData == null){
		Alert.show("没有数据","提示");
		return;
	}
	if(ocableRouteData.xml ==""){
		Alert.show("没有数据","提示");
		return;
	}
	content = ocableRouteData.content;
	this.start.text = content.astationname;
	this.end.text = content.zstationname;
	this.RoutMapLabel.text = "\"" +this.start.text + "\" 至 \"" + this.end.text + "\" 光路路由图";
	network.elementBox.clear();
	var serializer:XMLSerializer = new XMLSerializer(network.elementBox);
	serializer.deserialize(content.content);
	network.id = content.fiberroutecode;
}

private function drawPic(event:ResultEvent):void{
	if(event.result.toString() =="blank"){
		Alert.show("没有数据，请检查数据");
		return;
	}else if(event.result.toString() == "fault"){
		Alert.show("串接失败");
		return;
	}
	network.elementBox.clear();
	var serializer:XMLSerializer = new XMLSerializer(network.elementBox);
	serializer.deserialize(event.result.toString());
	
}

private function faultHandler(event:FaultEvent):void{
	Alert.show("串接失败");
//	MyPopupManager.removePopUp(this);
}

private function dataTipFunction(ielement:IElement){
	var tooltip:String="";
	if(ielement.layerID.toString() == "linklayer"){
		tooltip = ielement.toolTip;
	}
	return tooltip;
}

//导出操作
protected function linkbutton1_clickHandler(event:MouseEvent):void
{
	// TODO Auto-generated method stub
	var bitmapData:BitmapData=network.exportAsBitmapData();
	var encoder:PNGEncoder = new PNGEncoder();
	var data:ByteArray = encoder.encode(bitmapData);
	roocablerouteinfo.getByteData(data);
}

protected function rooocableinfo_resultHandler(event:ResultEvent):void
{
	var url:String = getURL();
	ro.exportOcableRouteExcel(network.id,url);
	ro.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void{exportExcelResult(event,network,url)});
}

public static function exportExcelResult(event:ResultEvent,network:Network,url:String):void{
	var fileName:String = event.result.toString();
	var path:String = url+"assets/excels/expfiles/"+fileName+".xls";
	var request:URLRequest = new URLRequest(encodeURI(path));
	navigateToURL(request,"_blank");
}

private static function getURL():String{
	var currSwfUrl:String; 
	var doMain:String = Application.application.stage.loaderInfo.url;  
	var doMainArray:Array = doMain.split("/");  
	
	if (doMainArray[0] == "file:") {  
		if(doMainArray.length<=3){  
			currSwfUrl = doMainArray[2];  
			currSwfUrl = currSwfUrl.substring(0,currSwfUrl.lastIndexOf(currSwfUrl.charAt(2)));  
		}else{  
			currSwfUrl = doMain;  
			currSwfUrl = currSwfUrl.substring(0,currSwfUrl.lastIndexOf("/"));  
		}  
	}else{  
		currSwfUrl = doMain;  
		currSwfUrl = currSwfUrl.substring(0,currSwfUrl.lastIndexOf("/"));  
	}  
	currSwfUrl += "/";
	return currSwfUrl;
}

//保存
private function linkbutton2_clickHandler(event:MouseEvent):void
{
	var serializer:XMLSerializer = new XMLSerializer(network.elementBox);
	var xmlString:String = serializer.serialize();
	var ro:RemoteObject = new RemoteObject("ocableRoute");
	ro.endpoint = ModelLocator.END_POINT;
	ro.showBusyCursor = true;
	ro.saveOcableRouteContent(network.id,xmlString,parentApplication.curUser);
//	ro.saveOcableRouteContent(nodecode,nodetype,parentApplication.curUser,xmlString);
	ro.addEventListener(ResultEvent.RESULT,saveResultHandler);
}

private function saveResultHandler(event:ResultEvent):void{
	var result:String = event.result as String;
	if(result == "success"){
		Alert.show("保存成功","提示");
	}else{
		Alert.show("保存失败","提示");
	}
}