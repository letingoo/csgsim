// ActionScript file
import mx.controls.Alert;

import sourceCode.resManager.resNode.model.Fiber;
import sourceCode.resManager.resNode.model.Testframe;
[Event(name="fibersSearchEvent",type="sourceCode.resManager.resNode.Events.FibersSearchEvent")]
import common.actionscript.MyPopupManager;
import mx.managers.PopUpManager;
import sourceCode.resManager.resNode.Events.FibersSearchEvent;
import sourceCode.resManager.resNode.Events.ModifyEvent;
import flash.events.Event;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;
import mx.utils.ObjectProxy;
import common.actionscript.ModelLocator;
import flash.events.MouseEvent;
import mx.controls.ComboBox;
import mx.collections.ArrayCollection;  
import sourceCode.autoGrid.actionscript.ItemRenderer;

public var PRI_old:Number; 
public var PRI_new:Number; 

public var check_flag:int=0;
public var estimate_flag:int=0;

public var stp:Array=new Array();
public var spec_old:Array;
public var spec_new:Array;
public var risk_report_list:Array;


[Bindable]
private var show_list:Array=new Array();

[Bindable]
public var risk_mod: Array =new Array();
private function init(){
	for(var temp:int=0;temp<stp.length;temp++){
		var tp_list:Array=stp[temp].split("//");
		var ob:Object={col1:tp_list[0],col2:tp_list[1],col3:tp_list[2],col4:tp_list[3]};
		show_list.push(ob);
	}
//	dataGrid.dataProvider=show_list;
	var ob:Object={col1:String(PRI_old),col2:String(PRI_new)};
	risk_mod.push(ob);
	risk_modification.dataProvider=risk_mod;
	
	var ob:Object={col1:String(PRI_old),col2:String(PRI_new)};
	if(check_flag==1){
		estimate_comp.height=0;
		estimate_comp.visible=false;
		estimate_comp2.height=0;
		estimate_comp2.visible=false;
		header.visible=false;
		header.height=0;
	}
	else if(estimate_flag==1){
		check_comp.height=0;
		check_comp.visible=false;
		
	}
	
}

private function searchClickHandler(event:MouseEvent):void{
	Alert.show("12345");
}

public function modrecResult(event:ResultEvent):void{
	if(event.result.toString()=="success")
	{
		ModelLocator.showSuccessMessage("修改成功!",this);
		this.dispatchEvent(new ModifyEvent("ModifyEvent"));
		//this.getFibers("0",pageSize.toString());
	}else
	{
		ModelLocator.showErrorMessage("修改失败!",this);
	}
	MyPopupManager.removePopUp(this);
}

