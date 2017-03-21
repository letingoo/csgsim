// ActionScript file
import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;

import mx.controls.Alert;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.remoting.mxml.RemoteObject;
import mx.core.Application;


import sourceCode.resManager.resNet.events.topolinkSearchEvent;
import sourceCode.resManager.resNode.model.Station;
import sourceCode.resManager.resNet.model.TopoLink;
import sourceCode.resManager.resNet.views.porttreeForTopoLink;

[Event(name="topolinkSearchEvent",type="sourceCode.resManager.resNet.events.topolinkSearchEvent")]

import common.actionscript.MyPopupManager;

import mx.managers.PopUpManager;
//以下是新加的byxujao
import sourceCode.resManager.resNet.titles.TopoLinkeqsearchTitle;
import common.other.events.CustomEvent;
import mx.events.FlexEvent;

//保存选择完系统的code,传给选择设备的子页面
[Bindable]private var parent_systemcode:String;
//保存从子页面传回来的A端设备的，选中设备的code
[Bindable]private var Aequipmentcode:String="";
//保存从子页面传回来的Z端设备的，选中设备的code
[Bindable]private var Zequipmentcode:String="";


public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");	
public var aendptpcode:String="";
public var zendptpcode:String="";
/**
 *重置 
 * @param event
 * 
 */
protected function button1_clickHandler(event:MouseEvent):void
{
	cmbEquipmentA.text = "";
	cmbEquipmentZ.text = "";
	txtLineLength.text = '';
	cmbLineRate.selectedIndex = -1;
	txtAendptp.text = '';
	aendptpcode='';
	zendptpcode='';
	txtRemark.text=''
	dfstartUpdateDate.text = "";
	dfendUpdateDate.text = "";
	//重置后之前选的所属系统的code也为空
	parent_systemcode="";
	
}

/**
 *查询操作 
 * @param event
 * 
 */
protected function searchClickHandler(event:MouseEvent):void
{
	var topolink:TopoLink = new TopoLink();
	
	
	if(cmbEquipmentA.text!=null&&cmbEquipmentA.text!=""){
		topolink.equipcode_a = Aequipmentcode;
		topolink.equipname_a = cmbEquipmentA.text;
	}
	if(cmbEquipmentZ.text!=null&&cmbEquipmentZ.text!=""){
		topolink.equipcode_z = Zequipmentcode;
		topolink.equipname_z = cmbEquipmentZ.text;
	}
	
	if(cmbLineRate.selectedItem!=null){
		topolink.linerate=cmbLineRate.selectedItem.@label;
		topolink.lineratecode=cmbLineRate.selectedItem.@id;
	}
//	topolink.aendptpcode = aendptpcode;
//	topolink.zendptpcode = zendptpcode;
	topolink.aendptp = txtAendptp.text;
	topolink.zendptp = txtZendptp.text;
	topolink.linelength = txtLineLength.text;
	
	topolink.remark = txtRemark.text;
	topolink.updatedate_start = dfstartUpdateDate.text;
	topolink.updatedate_end = dfendUpdateDate.text;
	
	this.dispatchEvent(new topolinkSearchEvent("topolinkSearchEvent",topolink));
	MyPopupManager.removePopUp(this);
}
/**
 *选择端口 
 * @param event
 * @param flag
 * 
 */
public function portClickHanlder(event:MouseEvent,flag:String):void{
	if(cmbLineRate.selectedItem != null){
		if(flag!=null&&flag=="aptp"){
			if(cmbEquipmentA.text==null||cmbEquipmentA.text=="")
			{
				Alert.show("请先选择A端设备!","提示");
			}else
			{
				var treeport:porttreeForTopoLink = new porttreeForTopoLink();
				treeport.parent_page = this;
				treeport.equipcode = Aequipmentcode;
				treeport.rate = cmbLineRate.selectedItem.@id;
				treeport.flag = flag;
				treeport.isSearch = true;
				treeport.rate=cmbLineRate.selectedItem.@id;
				MyPopupManager.addPopUp(treeport, true);
			}
		}
		if(flag!=null&&flag=="zptp"){
			if(cmbEquipmentZ.text==null||cmbEquipmentZ.text=="")
			{
				Alert.show("请先选择Z端设备!","提示");
			}else
			{
				var treeport:porttreeForTopoLink = new porttreeForTopoLink();
				treeport.parent_page = this;
				treeport.equipcode =Zequipmentcode;
				treeport.rate = cmbLineRate.selectedItem.@id;
				treeport.flag = flag;
				treeport.isSearch = true;
				treeport.rate=cmbLineRate.selectedItem.@id;
				MyPopupManager.addPopUp(treeport, true);
			}
		}
	}else{
		Alert.show("请先选择端口速率!","提示");
	}
	
}
/**
 *选择系统后，记录 systemcode
 * @param event
 * 
 */
private function SystemChange(event:Event):void{
//	if(this.title!=null&&this.title=="查询"){
//		parent_systemcode=systemcode;
//	}
}

/**
 *点击设备之后弹出个框，可进行模糊查询
 * @param event
 * 
 */
private function eqsearchHandler(event:MouseEvent,flag:String):void{
	
	var topolinkeqsearch:TopoLinkeqsearchTitle=new TopoLinkeqsearchTitle();
	topolinkeqsearch.page_parent=this;
	topolinkeqsearch.child_systemcode=parent_systemcode;
	if(flag=="equipA"){
		topolinkeqsearch.flog=true;
	}
	PopUpManager.addPopUp(topolinkeqsearch,this,true);
	PopUpManager.centerPopUp(topolinkeqsearch);
	topolinkeqsearch.myCallBack=this.callBack;
	topolinkeqsearch.myCallBack1=this.callBack1;
	
}

/**
 *回调函数，从子页面返回A端端口的code值 
 * @param obj
 * 
 */
public function callBack(obj:Object):void{ 
	Aequipmentcode = obj.name; 
}

/**
 *回调函数，从子页面返回Z端端口的code值 
 * @param obj
 * 
 */
public function callBack1(obj1:Object):void{ 
	Zequipmentcode = obj1.name; 
}