import common.actionscript.MyPopupManager;

import mx.collections.ArrayCollection;
import mx.controls.Alert;

[Bindable]
public var acPorts:ArrayCollection;
public var headertextA:String;
public var headertextZ:String;

private function init():void{
//	var xml:String = "<data>";
//	for(var i:int = 0; i < acPorts.length;i++){
//		xml+="\n<item label =\""+acPorts.getItemAt(i).name+"\"></item>";
//	}
//	xml+="\n</data>";
//	Alert.show(xml);
//	var dataa:XMLList = new XMLList(xml);
//	dg.dataProvider = dataa.children();
	dg.dataProvider = acPorts;
}

private function save():void{
	dispatchEvent(new Event("confrimCompleted"))
	MyPopupManager.removePopUp(this);
}

private function close():void{
	MyPopupManager.removePopUp(this);
}