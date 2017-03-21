// ActionScript file

import common.actionscript.ModelLocator;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

[Event(name="RessSearchEvent",type="sourceCode.businessResources.events.BusinessRessEvent")]
import sourceCode.resManager.resBusiness.model.BusinessRessModel;
import flash.events.MouseEvent;
import flash.events.Event;

//var xml:XML = <list><item label='是' code = '1'></item><item label='否' code = '0'></item></list>;
import sourceCode.resManager.resBusiness.events.BusinessRessEvent;

public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");
public var business_name_bak :String=null;


protected function submit_clickHandler(event:MouseEvent):void
{
	var obj:RemoteObject = new RemoteObject("resBusinessDwr");
	obj.endpoint = ModelLocator.END_POINT;
	obj.showBusyCursor = true;
	var br:BusinessRessModel = new BusinessRessModel();
	if(this.currentState!='search'){
		br.business_name = business_name.text;
		br.end_id_a = end_id_a.text;
		br.end_id_z = end_id_z.text;
		br.business_type = business_type.text;
		br.business_rate = business_rate.text;
		br.business_state = business_state.text;
		br.circuitcode = circuitcode.text;
		br.version_id = version_id.text;
	}else{
		br.business_name = business_name.text;
		br.circuitcode = circuitcode.text;
		br.end_id_a = end_id_a.text;
		br.end_id_z = end_id_z.text;
		br.business_type = business_type.text;
		br.business_rate = business_rate.text;
		br.business_state = business_state.text;
		br.version_id = version_id.text;
		
	}
	if(this.title=='添加'){
		if(business_name.text==""){
			Alert.show("业务名称不能为空！","提示");
		}else if(business_rate.text==""){
			Alert.show("业务速率不能为空！","提示");
		}else if(business_state.text==""){
			Alert.show("业务状态不能为空！","提示");
		}else{
			obj.addRess(br);
			obj.addEventListener(ResultEvent.RESULT,addHandle);
		}
	}else if(this.title=='查询'){
		this.dispatchEvent(new BusinessRessEvent("RessSearchEvent",br));
		
	}else if(this.title=='修改'){
		if(business_name.text==""){
			Alert.show("业务名称不能为空！","提示");
		}else if(business_rate.text==""){
			Alert.show("业务速率不能为空！","提示");
		}else if(business_state.text==""){
			Alert.show("业务状态不能为空！","提示");
		}else{
			//business_name_bak保存的是要修改的业务名称business_name是修改后的业务名称
			br.business_name_bak = business_name_bak;
			obj.updateRess(br);
			obj.addEventListener(ResultEvent.RESULT,updateHandler);
		}
	}else{
	}
	PopUpManager.removePopUp(this);
}
private function updateHandler(e:ResultEvent):void{
	if(e.result!=null){
		if(e.result.toString()=="success")
		{
			Alert.show("更新成功!","提示");
			this.dispatchEvent(new Event("RefreshDataGrid"))
		}else
		{
			Alert.show("请按要求填写数据！","提示");
		}
	}
}
private function addHandle(e:ResultEvent):void{
	if(e.result!=null){
		if(e.result.toString()=="success")
		{
			Alert.show("添加成功!","提示");
			this.dispatchEvent(new Event("RefreshDataGrid"))
		}else
		{
			Alert.show("请按要求填写数据！","提示");
		}
	}
	
}


protected function intApp():void
{
//					if(this.currentState=='search'){
//						this.business_name_bak.setPropertyIsEnumerable(visible,false);
//						this.isdouble.selectedIndex=-1;
//						this.isFiber.selectedIndex=-1;	
//					}
//					if(this.title=='添加'){
//						isFiber.selectedIndex=-1;
//					}
	
}
