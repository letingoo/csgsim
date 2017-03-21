// ActionScript file
import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;

import mx.controls.Alert;
import mx.core.Application;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import sourceCode.resManager.resNet.model.TopoLink;
import sourceCode.resManager.resNet.views.porttreeForTopoLink;


public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");	
[Bindable] public var topoLinkData:Object;
public var enable:Boolean = true;
public var aendptpcode:String="";
public var zendptpcode:String="";
public var topolink:TopoLink = new TopoLink();

//private var topolink:TopoLink = new TopoLink;

//以下是新加的byxujao
import sourceCode.resManager.resNet.titles.TopoLinkeqsearchTitle;
import common.other.events.CustomEvent;
import mx.events.FlexEvent;

//保存选择完系统的code,传给选择设备的子页面
[Bindable]private var parent_asystemcode:String;
[Bindable]private var parent_zsystemcode:String;
//保存从子页面传回来的A端设备的，选中设备的code
[Bindable]private var Aequipmentcode:String="";
//保存从子页面传回来的Z端设备的，选中设备的code
[Bindable]private var Zequipmentcode:String="";
/**
 *给 SystemCode赋值
 * @param xml
 * @param id
 * 
 */
public function setSystemCode(xml:XMLList,id:String):void{
	aSystemcode.dataProvider = xml;
	for each(var item:Object in aSystemcode.dataProvider){
		if(item.@id == id){
			aSystemcode.selectedItem = item;
		}
		
	}
	zSystemcode.dataProvider = xml;
	for each(var item:Object in zSystemcode.dataProvider){
		if(item.@id == id){
			zSystemcode.selectedItem = item;
		}
		
	}
}
/**
 * 给速率赋值
 * @param xml
 * @param id
 * 
 */
public function setLineRate(xml:XMLList,id:String):void{
	cmbLineRate.dataProvider = xml;
	for each(var item:Object in cmbLineRate.dataProvider){
		if(item.@id == id){
			cmbLineRate.selectedItem = item;
		}
		
	}
}

/**
 *添加或修改的处理函数 
 * @param event
 * 
 */
protected function btn_clickHandler(event:MouseEvent):void
{
//	if(cmbSystemcode.selectedItem==null){
//		Alert.show("请选择所属系统","提示");
//		return;
//	}
	if(cmbLineRate.selectedItem==null){
		Alert.show("请选择速率","提示");
		return;
	}
	if(aSystemcode.selectedItem==null){
		Alert.show("请选择A端传输系统","提示");
		return ;
	}else{
		topolink.a_systemcode = aSystemcode.selectedItem.@id;
	}
	if(zSystemcode.selectedItem==null){
		Alert.show("请选择Z端传输系统","提示");
		return ;
	}else{
		topolink.z_systemcode = zSystemcode.selectedItem.@id;
	}
	if(cmbEquipmentA.text==null||cmbEquipmentA.text==""){
		Alert.show("请选择A端设备","提示");
		return;
	}
	
	if(txtAendptp.text==null||txtAendptp.text==""){
		Alert.show("A端端口不能为空！","提示");
		return ;
	}
	if(cmbEquipmentZ.text==null||cmbEquipmentZ.text==""){
		Alert.show("请选择Z端设备","提示");
		return;
	}
	if(txtZendptp.text==null||txtZendptp.text==""){
		Alert.show("Z端端口不能为空！","提示");
		return ;
	}
	
	topolink.remark = txtRemark.text;
	topolink.linelength = txtLineLength.text;
	
	topolink.lineratecode = cmbLineRate.selectedItem.@id;
	topolink.aendptp = txtAendptp.text;
	topolink.zendptp = txtZendptp.text;
	
//	if(this.title == "添加"){
	if(cmbEquipmentA.text==cmbEquipmentZ.text){
		Alert.show("A端设备和Z端设备不能相同！","提示");
		return;
	}
	
	topolink.updatedate=txtUpdateDate.text;
	topolink.aendptpcode = aendptpcode;
	topolink.zendptpcode = zendptpcode;
	topolink.equipcode_a = cmbEquipmentA.text;
	topolink.equipcode_z = cmbEquipmentZ.text;
	//判断所选端口上是否有复用段
	checkPortUseA(this.aendptpcode);
//	}else if(this.title == "修改"){
//		topolink.label = topoLinkData.label;
//		topolink.aendptpcode = topoLinkData.aendptpcode;
//		topolink.zendptpcode = topoLinkData.zendptpcode;
//		topolink.updatedate=txtUpdateDate.text;
//		remoteObject.addEventListener(ResultEvent.RESULT,modifyTopoLinkResult);
//		remoteObject.ModifyTopoLink(topolink); 
//	}
//	
}

private function checkPortUseA(portcode:String):void{
	var re:RemoteObject=new RemoteObject("resNetDwr");
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.addEventListener(ResultEvent.RESULT,checkPortUseAResult);
	re.checkPortUse(portcode);
}

public function checkPortUseAResult(event:ResultEvent):void
{
	if(event.result.toString()=="success"){
		checkPortUseZ(this.zendptpcode);
	}else{
		Alert.show("所选A端端口上已有复用段，请重新选择！","提示");
		return;
	}
}

private function checkPortUseZ(portcode:String):void{
	var re:RemoteObject=new RemoteObject("resNetDwr");
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.addEventListener(ResultEvent.RESULT,checkPortUseZResult);
	re.checkPortUse(portcode);
}

public function checkPortUseZResult(event:ResultEvent):void
{
	if(event.result.toString()=="success"){
		var addrt:RemoteObject=new RemoteObject("resNetDwr");
		addrt.endpoint = ModelLocator.END_POINT;
		addrt.showBusyCursor = true;
		addrt.addEventListener(ResultEvent.RESULT,addTopoLinkResult);
		addrt.AddTopLinks(topolink); 
	}else{
		Alert.show("所选Z端端口上已有复用段，请重新选择！","提示");
		return;
	}
}
/**
 *添加后的处理函数 
 * @param event
 * 
 */
protected function addTopoLinkResult(event:ResultEvent):void{
	if(event.result.toString()=="success")
	{
		Alert.show("添加成功!","提示");
		PopUpManager.removePopUp(this);
		this.dispatchEvent(new Event("RefreshDataGrid"))
	}else
	{
		Alert.show("请按要求填写数据！","提示");
	}
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
				treeport.equipcode =Zequipmentcode ;
				treeport.rate = cmbLineRate.selectedItem.@id;
				treeport.flag = flag;
				MyPopupManager.addPopUp(treeport, true);
			}
		}
	}else{
		Alert.show("请先选择端口速率!","提示");
	}
}
/**
 *所属的系统改变后，获得的 systemcode，以传给选择设备的子页面
 * @param event
 * 
 */
private function SystemAChange(event:Event,str:String):void{
	if(this.title!=null&&this.title=="添加"){
		if(str=="A"){
			parent_asystemcode=aSystemcode.selectedItem.@id;
			cmbEquipmentA.text="";
			txtAendptp.text="";
		}
		if(str=='Z'){
			parent_zsystemcode=zSystemcode.selectedItem.@id;
			cmbEquipmentZ.text="";
			txtZendptp.text="";
		}
	}
}

/**
 *为了使传输设备和速率进来时不呈现 
 * @param event
 * 
 */
protected function init(event:FlexEvent):void
{
	aSystemcode.selectedIndex=-1;//传输设备
	zSystemcode.selectedIndex=-1;
	cmbLineRate.selectedIndex=-1;//速率
	
	
}
/**
 *点击设备之后弹出个框，可进行模糊查询；选择A、Z端设备
 * @param event
 * 
 */
private function eqsearchHandler(event:MouseEvent,flag:String):void{
	if(flag=="equipA"){
		if(parent_asystemcode==null||parent_asystemcode==""){
			Alert.show("请先选择A端所属系统","提示");
			return ;
		}
		var topolinkeqsearch:TopoLinkeqsearchTitle=new TopoLinkeqsearchTitle();
		topolinkeqsearch.page_parent=this;
		topolinkeqsearch.flog=true;
		topolinkeqsearch.child_systemcode=parent_asystemcode;
		PopUpManager.addPopUp(topolinkeqsearch,this,true);
		PopUpManager.centerPopUp(topolinkeqsearch);
		topolinkeqsearch.myCallBack=this.callBack;
		topolinkeqsearch.myCallBack1=this.callBack1;
	}
	else{
		if(parent_zsystemcode==null||parent_zsystemcode==""){
			Alert.show("请先选择Z端所属系统","提示");
			return ;
		}
		var topolinkeqsearch:TopoLinkeqsearchTitle=new TopoLinkeqsearchTitle();
		topolinkeqsearch.page_parent=this;
//		topolinkeqsearch.flog=true;
		topolinkeqsearch.child_systemcode=parent_zsystemcode;
		PopUpManager.addPopUp(topolinkeqsearch,this,true);
		PopUpManager.centerPopUp(topolinkeqsearch);
		topolinkeqsearch.myCallBack=this.callBack;
		topolinkeqsearch.myCallBack1=this.callBack1;
	}
}
/**
 *回调函数，从子页面返回A端端口的code值 
 * @param obj
 * 
 */
public function callBack(obj:Object):void{ 
	Aequipmentcode = obj.name; 
	txtAendptp.text="";
}

/**
 *回调函数，从子页面返回Z端端口的code值 
 * @param obj
 * 
 */
public function callBack1(obj1:Object):void{ 
	Zequipmentcode = obj1.name; 
	txtZendptp.text="";
}
