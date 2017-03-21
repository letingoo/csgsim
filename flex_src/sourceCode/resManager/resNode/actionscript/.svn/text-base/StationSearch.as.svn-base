// ActionScript file
import mx.controls.Alert;

import sourceCode.resManager.resNode.Events.StationSearchEvent;
import sourceCode.resManager.resNode.model.Station;
import sourceCode.resManager.resNode.views.enStationTree;

[Event(name="StationSearchEvent",type="sourceCode.resManager.resNode.Events.StationSearchEvent")]

import common.actionscript.MyPopupManager;

import mx.managers.PopUpManager;
import flash.events.MouseEvent;


public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");	

protected function button1_clickHandler(event:MouseEvent):void
{
	txtlat.text = "";
	txtlng.text = "";
	cmbProperty.text = "";
	txtRemark.text = "";
	cmbStationA.text = "";
	dfstartFoundDate.text = "";
	dfendFoundDate.text = "";
	cmbProvince.selectedIndex = -1;
	cmbStationType.selectedIndex = -1;
	
}


protected function searchClickHandler(event:MouseEvent):void
{
	var station:Station = new Station();
	station.stationname = cmbStationA.text;
	if(cmbProvince.selectedItem != null){
		station.province = cmbProvince.selectedItem.@label;
	}
	if(cmbStationType.selectedItem != null){
		station.x_stationtype = cmbStationType.selectedItem.@label;
	}
	
	station.lat = txtlat.text;
	station.lng = txtlng.text;
	station.remark = txtRemark.text;
	station.property = cmbProperty.text;
	
	station.founddate_start = dfstartFoundDate.text;
	station.founddate_end = dfendFoundDate.text;
	
	this.dispatchEvent(new StationSearchEvent("StationSearchEvent",station));
	MyPopupManager.removePopUp(this);
}

private function getStationName(event:MouseEvent):void{
	var stations:enStationTree=new enStationTree();
	stations.page_parent=this;
	stations.textId="cmbStationA";
	PopUpManager.addPopUp(stations, this, true);
	PopUpManager.centerPopUp(stations);
}
