import com.as3xls.xls.ExcelFile;
import com.as3xls.xls.Sheet;

import common.actionscript.ModelLocator;

import mx.collections.ArrayCollection;
import mx.controls.Alert;

import sourceCode.packGraph.views.Color1;
import sourceCode.resManager.resNode.Events.ModifyEvent;
import sourceCode.resManager.resNode.Events.testevent;
import sourceCode.sysGraph.actionscript.DFloyd;
import sourceCode.sysGraph.model.BussinessRoute;
import sourceCode.sysGraph.model.BusssinessRouteModel;
import sourceCode.sysGraph.model.Testmodel;
import sourceCode.sysGraph.views.troubleshoot_window;

import twaver.AlarmSeverity;
import twaver.Consts;
import twaver.DataBox;
import twaver.DemoImages;
import twaver.DemoUtils;
import twaver.Element;
import twaver.ElementBox;
import twaver.Grid;
import twaver.ICollection;
import twaver.IElement;
import twaver.Layer;
import twaver.Link;
import twaver.LinkSubNetwork;
import twaver.Node;
import twaver.SerializationSettings;
import twaver.Size;
import twaver.Styles;
import twaver.Utils;
import twaver.XMLSerializer;
import twaver.network.layout.AutoLayouter;
import twaver.network.layout.SpringLayouter;


private function cal_R(single_route:Array):Number{
	var r_val:Number=0;
	for each(var eq:String in single_route){
		var ele:Element=null;
		ele=systemorgmap.elementBox.getDataByID(eq) as Element;
		var ele_val:Number=get_ele_type_(ele);
		r_val+=ele_val;
	}
	r_val=r_val/single_route.length;
	return r_val;
}
private function  get_ele_type_(ele:Element):Number{
	for (var eletype:String in business_2_val){
		if(eletype ==ele.getClient("type")){
			return Number(business_2_val[eletype]);
		}
	}
	//Alert.show(ele.getClient("type"),"miss");
	return 10;
}

private function cal_P(length:Number):Number{
	return 0.001*length;
}

private function cal_T():Number{
	return 1;
	
	
}

public function cal_PRI_sum(changelog_spec:Array,risk_estimate_report:Array):Number{
	var bus_list:Array=mapobj.busidList();
	var PRI:Number=0;
	risk_estimate_report.splice(0);//清空
	for each(var bus_id in bus_list){		
		//Alert.show(bus_id,"bus_id")
		var bus_arr:Array=mapobj.checkInDanger(bus_id);
		var single_route_risk:Object=new Object;

		
		var R_exp:Number=cal_R(bus_arr);
		var single_route_pri:Number=R_exp*cal_P(bus_arr.length)*cal_T()*10;
		PRI+=single_route_pri;//10为默认业务权重
		//Alert.show(bus_arr.toString(),"单个业务重合项");
		var spec_route:Object=new Object;
		spec_route.bus_id=bus_id;
		var obj:BusssinessRouteModel=mapobj.getBusrouteByID(bus_id);
		var init_route:Array=obj.toString().split("//");
		spec_route.name=obj.getbusname();
		spec_route.type=obj.getbustype();
		spec_route.main=init_route[1];
		spec_route.sub1=init_route[2];
		spec_route.sub2=init_route[3];
		spec_route.pri=single_route_pri;
		changelog_spec.push(spec_route);
		
		single_route_risk.bus_id=bus_id;
		single_route_risk.name=obj.getbusname();
		single_route_risk.eq_list=bus_arr;
		risk_estimate_report.push(single_route_risk);
		
	}
	return Number(PRI.toFixed(3));
}