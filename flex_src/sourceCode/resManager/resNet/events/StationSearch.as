// ActionScript file
import mx.controls.Alert;

import sourceCode.resManager.resNode.Events.stationSearchEvent;
import sourceCode.resManager.resNode.model.ResStation;

[Event(name="stationSearchEvent",type="sourceCode.resManager.resNode.events.stationSearchEvent")]

import common.actionscript.MyPopupManager;

import mx.managers.PopUpManager;


public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");	

protected function button1_clickHandler(event:MouseEvent):void
{
	
	txtStation.text = "";
	txtstation_location_x.text = "";
	txtstation_location_y.text = "";
	cmbStationType.selectedIndex = -1;
	cmbStationState.selectedIndex = -1;
	
}


protected function searchClickHandler(event:MouseEvent):void
{
	var station:ResStation = new ResStation();
	station.station_name = txtStation.text;
	
	if(cmbStationType.selectedItem != null){
		station.station_type = cmbStationType.selectedItem.@label;
	}
	if(cmbStationState.selectedItem != null){
		station.station_state = cmbStationState.selectedItem.@label;
	}
	station.station_location_x = txtstation_location_x.text;
	station.station_location_y = txtstation_location_y.text;
	
	
	this.dispatchEvent(new stationSearchEvent("stationSearchEvent",station));
	MyPopupManager.removePopUp(this);
}
