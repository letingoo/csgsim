// ActionScript file
import mx.controls.Alert;
[Event(name="carryBusinessSearchEvent",type="sourceCode.ocableResource.actionscript.CarryBusinessSearchEvent")]
import common.actionscript.MyPopupManager;
import mx.managers.PopUpManager;
import sourceCode.ocableResource.model.CarryingBusinessModel;
import sourceCode.ocableResource.actionscript.CarryBusinessSearchEvent;

private function init():void{
//	username.selectedIndex=-1;//username  不做下拉框选择 ，一则数据太多，查询慢，二则下拉框显示不全，以后可改为弹出树
	rate.selectedIndex=-1;
	this.title="查询";
}

private function searchClickHandler(event:MouseEvent):void{
	var carryBusiness:CarryingBusinessModel = new CarryingBusinessModel();
	carryBusiness.circuitcode=circuitcode.text;
	carryBusiness.remark=remark.text;
	carryBusiness.port_a=port_a.text;
	carryBusiness.port_z=port_z.text;
	carryBusiness.username=username.text;
//	if(username.selectedIndex != -1){
//		carryBusiness.username=username.selectedItem.@label;
//	}
	if(rate.selectedIndex != -1){
		carryBusiness.rate=rate.selectedItem.@label;
	}
	this.dispatchEvent(new CarryBusinessSearchEvent("carryBusinessSearchEvent",carryBusiness));
	MyPopupManager.removePopUp(this);
}

private function clear_clickHandler(event:MouseEvent):void{
	this.circuitcode.text="";
//	this.username.selectedIndex=-1;
	this.username.text="";
	this.remark.text="";
	this.rate.selectedIndex=-1;
	this.port_a.text="";
	this.port_z.text="";
}