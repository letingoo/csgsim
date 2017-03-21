// ActionScript file
import mx.controls.Alert;

import sourceCode.resManager.resNode.model.Fiber;
import sourceCode.resManager.resNode.model.Testframe;
[Event(name="fibersSearchEvent",type="sourceCode.resManager.resNode.Events.FibersSearchEvent")]
import common.actionscript.MyPopupManager;
import mx.managers.PopUpManager;
import sourceCode.resManager.resNode.Events.FibersSearchEvent;
import sourceCode.resManager.resNode.Events.ModifyEvent;
import sourceCode.sysGraph.model.UsrSelectEvent;
import flash.events.Event;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;
import mx.utils.ObjectProxy;
import common.actionscript.ModelLocator;
import flash.events.MouseEvent;
import mx.controls.ComboBox;
import mx.controls.CheckBox;
import mx.collections.ArrayCollection;  
import sourceCode.autoGrid.actionscript.ItemRenderer;
import sourceCode.sysGraph.model.BusssinessRouteModel;
import mx.collections.SortField;
import mx.collections.Sort;
public var PRI_old:Number; 
public var PRI_new:Number; 

[Bindable]
public var bus_list:Array=new Array();
public var select_list:Object;


public var select_result:Array=new Array();


[Bindable]
private var show_list:Array=new Array();


[Bindable]
private var selected_bus_list:Array=new Array();


[Bindable]
private var usr_list_2:ArrayCollection =new ArrayCollection();


[Bindable]
public var risk_mod: Array =new Array();

//用户选择重复项
private var duplicate_list:Array=new Array();
private function init(){
	for each (var arr:Array in select_list){
		for(var a:int=0;a<arr.length;a++){
			usr_list_2.addItem(arr[a]);
		}
	}
	usr_list_2.sort = new Sort();
	usr_list_2.sort.fields = [new SortField("name",false,true)];
	usr_list_2.refresh();
	
	usr_select_lst.rowCount=usr_list_2.length*2;
//	cbox.dataProvider=bus_list;
//	selectedGrid.dataProvider=selected_bus_list;
//	var initgrid:String=cbox.selectedItem.toString();
}

private function changeview(select_bus:String):void{
	for(var label:String in select_list){
		if(select_bus==label){
			show_list=select_list[label];
			break;
		}
	}

	
}

/**
 * 
 * 用户选择路由时，将选择条目从可选择列表中删除并刷新dataprovider
 * 
 */
public function select_clickHandler(event:Event):void{
	var target:CheckBox = event.currentTarget as CheckBox;
	var select_bus:String=usr_select_lst.selectedItem.bus_id;
	if (target.selected) {//选中
		for(var label:String in select_list){
			if(select_bus==label){
				show_list=select_list[label];
				break;
			}
		}
		var selected_route:Array=new Array();
		selected_route.push(usr_select_lst.selectedItem.route);
		for(var temp:int=0;temp<show_list.length;temp++){
			if(show_list[temp].route!=selected_route)
				selected_route.push(show_list[temp].route);
		}		
		for(var temp:int=selected_route.length;temp<3;temp++)
		{
			selected_route.push("");
		}
		//查找选择重复项
		for each(var item:BusssinessRouteModel in select_result){
			if(item.getbusid()==select_bus)
			{
				duplicate_list.push(select_bus);
				break;
			}
		}
		select_result.push(new BusssinessRouteModel(select_bus,usr_select_lst.selectedItem.name,usr_select_lst.selectedItem.type,selected_route[0],selected_route[1],selected_route[2]));
	} else {//取消
		var route_tp:String=usr_select_lst.selectedItem.route;
		for(var i:int=0;i<select_result.length;i++){
			//结果集删除选择项
			var item:BusssinessRouteModel=select_result[i];
			if(item.getbusid()==select_bus && item.getmainroute()==route_tp)
			{
				
				select_result.splice(i,1);
				//Alert.show(select_result.length.toString(),"find route");
				break;
			}
			
		}
		//查找重复项
		for(var i:int=0;i<duplicate_list.length;i++){
			if(select_bus==duplicate_list[i]){
				duplicate_list.splice(i,1);
				//Alert.show(duplicate_list.toString(),"find duplicate");
				break;
				
			}
		}
		
	}
	

//	//删除已经选择的业务id表项
//	for(var i:int=0;i<usr_list_2.length;i++){  
//		var item:Object=usr_list_2.getItemAt(i);  
//		if(item.bus_id==select_bus){  
//			usr_list_2.removeItemAt(i);  
//			i--;  
//		}  
//	}  
	
//	for(var temp:int =0;temp<bus_list.length;temp++){
//		if(bus_list[temp]==select_bus){
//			//更新已选择列表
////			var tpobj:Object=new Object;
////			tpobj.bus_name=bus_list[temp];
////			selected_bus_list.push(tpobj);
////			selectedGrid.dataProvider=selected_bus_list;
////			selectedGrid.invalidateList();
////			
////			//更新combobox及对应显示业务的列表
////			bus_list.splice(temp,1);
////			cbox.dataProvider=bus_list;
//			if(bus_list.length!=0){		
//				var initgrid:String=cbox.selectedItem.toString();
//				changeview(initgrid);
//			}
//			else{
//				show_list=new Array();
//			}
//			break;
//		}
//	}
}

public function reset_btn_click_handler(event:MouseEvent):void{
	selected_bus_list.slice(0);
	select_result.slice(0);
//	cbox.dataProvider=bus_list;
//	selectedGrid.dataProvider=selected_bus_list;
//	var initgrid:String=cbox.selectedItem.toString();
//	changeview(initgrid);
	Alert.show("reset");
	
}



public function submit_btn_click_handler(event:MouseEvent):void{
	var count:int=0;
	for(var label:String in select_list){
		count++;
	}
	if(duplicate_list.length!=0){
		ModelLocator.showErrorMessage("为同一业务选择了多条主用路由，请重新检查!",this);
	}
	else if(count!=select_result.length){
		ModelLocator.showErrorMessage("有业务未选择主用路由，请重新检查!",this);
	}
	else{
		this.dispatchEvent(new UsrSelectEvent("UsrSelectEvent",select_result));
		MyPopupManager.removePopUp(this);
	}

}