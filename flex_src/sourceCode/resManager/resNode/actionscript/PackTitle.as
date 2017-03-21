// ActionScript file
import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;

import mx.controls.Alert;
import mx.core.Application;
import mx.events.ListEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;
import mx.utils.StringUtil;

import sourceCode.resManager.resNode.Titles.SearchEquipTitle;
import sourceCode.resManager.resNode.model.Pack;
//保存选择完系统的code,传给选择设备的子页面,byxujiao
[Bindable]private var parent_systemcode:String;
//保存选择的供应商的code，传给选择设备子页面，byxujiao
[Bindable]private var parent_vendor:String;
//保存从子页面传回来的equipcode，以备选择机框
private var parent_equipcode:String;

private var pack:Pack=new Pack();
public var days:Array=new Array("日", "一", "二", "三", "四", "五", "六");
public var monthNames:Array=new Array("一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月");
[Bindable]
public var packData:Object;
/**
 *添加或修改的操作 
 * @param event
 * 
 */
protected function btn_clickHandler(event:MouseEvent):void
{
	if (this.title == "添加")
	{
		if (cmbEquipment.text ==null||cmbEquipment.text =="")
		{
			Alert.show("设备名称不能为空", "提示");
			return;
		}
		else
		{
			pack.equipcode=parent_equipcode;
			pack.equipname=cmbEquipment.text;
		}
		if (cmbEquipframe.selectedIndex == -1)
		{
			Alert.show("机框序号不能为空", "提示");
			return;
		}
		else
		{
			pack.frameserial=cmbEquipframe.text;
		}
		if (cmbEquipSlot.selectedIndex == -1)
		{
			Alert.show("机槽序号不能为空", "提示");
			return;
		}
		else
		{
			pack.slotserial=cmbEquipSlot.text;
		}
		pack.packserial=txtEquipPack.text;
		pack.packmodel=cmbPackmodel.text;
		pack.updatedate=dfUpdateDate.text;
		
		if (StringUtil.trim(txtEquipPack.text) == "")
		{
			Alert.show("机盘序号不能为空", "提示");
			return;
		}
		//验证机盘序号重复
		else{
			checkPackSerial(pack.equipcode,pack.frameserial,
				pack.slotserial,pack.packserial);
		}
	}
	else if (this.title == "修改")
	{
		//修改之前的框、槽、盘号
		pack.gb_frameserial=packData.frameserial;
		pack.gb_slotserial=packData.slotserial;
		pack.gb_packserial=packData.packserial;
		pack.gb_equipcode=packData.equipcode;
		if (StringUtil.trim(txtEquipPack.text) == "")
		{
			Alert.show("机盘序号不能为空", "提示");
			return;
		}else{
			pack.packserial=txtEquipPack.text;
			if(pack.packserial!=pack.gb_packserial){
				//验证机盘序号重复
				checkPackSerial(pack.gb_equipcode,pack.gb_frameserial,
					pack.gb_slotserial,pack.packserial);
			}else{
				if (StringUtil.trim(cmbPackmodel.text) == "")
				{
					Alert.show("机盘型号不能为空", "提示");
					return;
				}
//				pack.vender = cmbVendor.text;
//				pack.system = cmbTransystem.text;
				pack.packmodel=cmbPackmodel.text;
				pack.updatedate=dfUpdateDate.text;
				
				var remoteObject:RemoteObject=new RemoteObject("resNodeDwr");
				remoteObject.endpoint=ModelLocator.END_POINT;
				remoteObject.showBusyCursor=true;
				remoteObject.addEventListener(ResultEvent.RESULT, modifyPackResult);
				Application.application.faultEventHandler(remoteObject);
				remoteObject.ModifyPack(pack);
			}
		}
	}
}

/**
 * 验证机盘序号是否占用
 */ 
protected function checkPackSerial(code:String,frame:String,slot:String,pack:String):void{
	var rt:RemoteObject=new RemoteObject("resNodeDwr");
	rt.endpoint = ModelLocator.END_POINT;
	rt.showBusyCursor = true;
	rt.addEventListener(ResultEvent.RESULT,checkPackSerialResultHandler);
	Application.application.faultEventHandler(rt);
	rt.checkPackSerial(code,frame,slot,pack);
}
protected function checkPackSerialResultHandler(event:ResultEvent):void{
	var flagStr:String =  event.result.toString();
	if(flagStr == "success"){//被占用
		Alert.show("填写的机盘序号被占用，请重新填写","提示");
		return;
	}else{
		var remoteObject:RemoteObject=new RemoteObject("resNodeDwr");
		remoteObject.endpoint=ModelLocator.END_POINT;
		remoteObject.showBusyCursor=true;
		if(this.title=="添加"){
			if (StringUtil.trim(cmbPackmodel.text) == "")
			{
				Alert.show("机盘型号不能为空", "提示");
				return;
			}
			remoteObject.addEventListener(ResultEvent.RESULT, addPackResult);
			Application.application.faultEventHandler(remoteObject);
			remoteObject.addEquipPack(pack);
		}else{
			if (StringUtil.trim(cmbPackmodel.text) == "")
			{
				Alert.show("机盘型号不能为空", "提示");
				return;
			}
//			pack.vender = cmbVendor.text;
//			pack.system = cmbTransystem.text;
			pack.packmodel=cmbPackmodel.text;
			pack.updatedate=dfUpdateDate.text;
			
			remoteObject.addEventListener(ResultEvent.RESULT, modifyPackResult);
			Application.application.faultEventHandler(remoteObject);
			remoteObject.ModifyPack(pack);
		}
	}
}
/**
 *添加后的界面提示处理 
 * @param event
 * 
 */
protected function addPackResult(event:ResultEvent):void
{
	if (event.result.toString() == "success")
	{
		Alert.show("添加成功!", "提示");
		PopUpManager.removePopUp(this);
		this.dispatchEvent(new Event("RefreshDataGrid"))
	}
	else
	{
		Alert.show("请按要求填写数据！", "提示");
	}
}
/**
 *修改后，界面的提示处理 
 * @param event
 * 
 */
public function modifyPackResult(event:ResultEvent):void
{
	if (event.result.toString() == "success")
	{
		Alert.show("修改成功！", "提示");
		PopUpManager.removePopUp(this);
		this.dispatchEvent(new Event("RefreshDataGrid"))
	}
	else
	{
		Alert.show("修改失败！", "提示");
	}
}
/**
 *选择厂商、机槽等后相应的做的处理 
 * @param event
 * 
 */
public function itemSelectChangeHandler(event:ListEvent):void
{
	var systemcode:String;
	var vendor:String;
	var equipcode:String;
	var frameserial:String;
	var slotserial:String;
	if (this.title == "添加")
	{
//		if (event.target.id == "cmbVendor")
//		{
////			parent_vendor=cmbVendor.selectedItem.@id;
//			var rt:RemoteObject=new RemoteObject("resNodeDwr");
//			rt.endpoint=ModelLocator.END_POINT;
//			rt.showBusyCursor=true;
//			rt.getSystemsByVender(parent_vendor);
//			rt.addEventListener(ResultEvent.RESULT, getSystemByVenderHandler);
//			Application.application.faultEventHandler(rt);
//		}
//		else if (event.target.id == "cmbTransystem")
//		{
//			parent_vendor=cmbVendor.selectedItem.@id;
//			parent_systemcode=cmbTransystem.selectedItem.@id;
//		}
		if (event.target.id == "cmbEquipframe")
		{
			equipcode=parent_equipcode;
			frameserial=cmbEquipframe.selectedItem.@code;
			var rt:RemoteObject=new RemoteObject("resNodeDwr");
			rt.endpoint=ModelLocator.END_POINT;
			rt.showBusyCursor=true;
			rt.getEuipSlotSerialByFrameDistinct(equipcode, frameserial);
			rt.addEventListener(ResultEvent.RESULT, getEquipSlotSerialByEquipcode);
			Application.application.faultEventHandler(rt);
		}
		
	}
}

/**
 *
 * 获取厂商
 *
 * */
//public function getVendor():void
//{
//	if (this.title == "修改")
//	{
//		pack.gb_equipcode=packData.equipcode;
//		pack.gb_frameserial=packData.frameserial;
//		pack.gb_slotserial=packData.slotserial;
//		pack.gb_packserial=packData.packserial;
//	}
//	var re:RemoteObject=new RemoteObject("resNodeDwr");
//	re.endpoint=ModelLocator.END_POINT;
//	re.showBusyCursor=true;
//	re.addEventListener(ResultEvent.RESULT, resultVendorHandler);
//	Application.application.faultEventHandler(re);
//	re.getVenders();
//	
//}
/**
 *获取厂商数据之后的处理函数 
 * @param event
 * 
 */
//public function resultVendorHandler(event:ResultEvent):void
//{
//	cmbVendor.dataProvider=new XMLList(event.result);
//	cmbVendor.selectedIndex=-1;
//}
/**
 *获取厂商数据后，给所属系统赋值
 * @param event
 * 
 */
//public function getSystemByVenderHandler(event:ResultEvent):void
//{
//	var comboData:XMLList=new XMLList(event.result);
//	cmbTransystem.text="";
//	cmbTransystem.selectedIndex=-1;
//	cmbTransystem.dropdown.dataProvider=comboData;
//	cmbTransystem.dataProvider=comboData;
//	
//}
/**
 *获取了机框数据后的 ，给cmbEquipframe赋值
 * @param event
 * 
 */
public function getEquipFrameSerialByEquipcode(event:ResultEvent):void
{
	if (event.result != null && event.result.toString() != "")
	{
		var comboData:XMLList=new XMLList(event.result);
		cmbEquipframe.dropdown.dataProvider=comboData;
		cmbEquipframe.dataProvider=comboData;
		cmbEquipframe.text="";
		cmbEquipframe.selectedIndex=-1;
		
	}
}
/**
 *获取机槽数据后给cmbEquipSlot赋值
 * @param event
 * 
 */
public function getEquipSlotSerialByEquipcode(event:ResultEvent):void
{
	if (event.result != null && event.result.toString() != "")
	{
		var comboData:XMLList=new XMLList(event.result);
		cmbEquipSlot.text="";
		cmbEquipSlot.selectedIndex=-1;
		cmbEquipSlot.dropdown.dataProvider=comboData;
		cmbEquipSlot.dataProvider=comboData;
	}
	
}

/**
 *点击选择设备弹出的框 ，以选择设备
 * @param event
 * 
 */
private function eqsearchHandler(event:MouseEvent):void{
	if(cmbEquipment.enabled){
		var packeqsearch:SearchEquipTitle=new SearchEquipTitle();
		packeqsearch.page_parent=this;
		packeqsearch.child_systemcode=parent_systemcode;
		packeqsearch.child_vendor=parent_vendor;
		PopUpManager.addPopUp(packeqsearch,this,true);
		PopUpManager.centerPopUp(packeqsearch);
		packeqsearch.myCallBack=this.EuipFrameSerial;
	}
	
}

/**
 *选择设备后其对应的机框 就可以得到数据 查询对应的机盘型号
 * @param obj
 * 
 */
private function EuipFrameSerial(obj:Object):void{
	
	if(cmbEquipment.text!=null){
		parent_equipcode=obj.name;
		var rt:RemoteObject=new RemoteObject("resNodeDwr");
		rt.endpoint=ModelLocator.END_POINT;
		rt.showBusyCursor=true;
//		rt.getEuipFrameSerial(parent_equipcode);
		rt.getFrameserialByeId(parent_equipcode);
		rt.addEventListener(ResultEvent.RESULT, getEquipFrameSerialByEquipcode);
		Application.application.faultEventHandler(rt);
		//
		var rtt:RemoteObject=new RemoteObject("resNodeDwr");
		rtt.endpoint=ModelLocator.END_POINT;
		rtt.showBusyCursor=true;
		rtt.getPackModels(parent_equipcode);
		rtt.addEventListener(ResultEvent.RESULT, getPackModelByEquipcode);
		Application.application.faultEventHandler(rtt);
	}
}

public function getEquipCodeByName(equipname:String):void{
	//获取设备编码
	if(equipname==null){
		equipname="";
	}
	var rtt:RemoteObject=new RemoteObject("resNodeDwr");
	rtt.endpoint=ModelLocator.END_POINT;
	rtt.showBusyCursor=true;
	rtt.getEquipCodeByName(equipname);//
	rtt.addEventListener(ResultEvent.RESULT, getEquippackModel);
	Application.application.faultEventHandler(rtt);
	
}
private function getEquippackModel(event:ResultEvent):void{
	if(event!=null){
		var rtt:RemoteObject=new RemoteObject("resNodeDwr");
		rtt.endpoint=ModelLocator.END_POINT;
		rtt.showBusyCursor=true;
		rtt.getPackModels(event.result.toString());
		rtt.addEventListener(ResultEvent.RESULT, getPackModelByEquipcode);
		Application.application.faultEventHandler(rtt);
	}
}

/**
 *获取了型号数据后的 ，给cmbPackmodel赋值
 * @param event
 * 
 */
public function getPackModelByEquipcode(event:ResultEvent):void
{
	if (event.result != null && event.result.toString() != "")
	{
		var comboData:XMLList=new XMLList(event.result);
		cmbPackmodel.dropdown.dataProvider=comboData;
		cmbPackmodel.dataProvider=comboData;
		cmbPackmodel.text="";
		if(this.title=="修改"){
			cmbPackmodel.text=packData.packmodel;
		}
		cmbPackmodel.selectedIndex=-1;
		
	}
}