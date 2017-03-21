// ActionScript file
import mx.controls.Alert;

import sourceCode.resManager.resNode.model.Ocable;
[Event(name="ocableSearchEvent",type="sourceCode.resManager.resNode.Events.OcablesSearchEvent")]
import common.actionscript.MyPopupManager;
import mx.managers.PopUpManager;
import sourceCode.resManager.resNode.Events.OcablesSearchEvent;
import sourceCode.resManager.resNode.views.enStationTree;

public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");	

private function init(){
	a_area.selectedIndex=-1;
	z_area.selectedIndex=-1;
	cmbProperty.selectedIndex=-1;
	cmbOcableModel.selectedIndex=-1;
	this.title="查询";
}

private function searchClickHandler(event:MouseEvent):void{
	var ocable:Ocable = new Ocable();
	ocable.ocablename=txtOcablename.text;
	ocable.builddate_start=dfstartBuildDate.text;
	ocable.builddate_end=dfendBuildDate.text;
	
	if(cmbOcableModel.selectedIndex != -1){
		ocable.ocablemodel=cmbOcableModel.selectedItem.@label;
	}
	if(a_area.selectedIndex != -1){
		ocable.a_area=a_area.selectedItem.@label;
	}
	if(z_area.selectedIndex != -1){
		ocable.z_area=z_area.selectedItem.@label;
	}
	if(cmbProperty.selectedIndex != -1){
		ocable.property=cmbProperty.selectedItem.@label;
	}
	if(cmbStationA.text!=""){
		ocable.station_a=cmbStationA.text;
	}
	if(cmbStationZ.text!=""){
		ocable.station_z=cmbStationZ.text;
	}
	
	this.dispatchEvent(new OcablesSearchEvent("ocablesSearchEvent",ocable));
	MyPopupManager.removePopUp(this);
}

private function clear_clickHandler(event:MouseEvent):void{
	this.txtOcablename.text="";
	this.cmbStationA.text="";
	this.cmbStationZ.text="";
	this.cmbOcableModel.selectedIndex=-1;
	this.a_area.selectedIndex=-1;
	this.z_area.selectedIndex=-1;
	this.cmbProperty.selectedIndex=-1;
}
protected function cmbStationA_clickHandler(event:MouseEvent):void
{
	var stations:enStationTree=new enStationTree();
	stations.page_parent=this;
	stations.textId="cmbStationA";
	PopUpManager.addPopUp(stations, this, true);
	PopUpManager.centerPopUp(stations);  
}

protected function cmbStationZ_clickHandler(event:MouseEvent):void
{
	var stations:enStationTree=new enStationTree();
	stations.page_parent=this;
	stations.textId="cmbStationZ";
	PopUpManager.addPopUp(stations, this, true);
	PopUpManager.centerPopUp(stations);  
}