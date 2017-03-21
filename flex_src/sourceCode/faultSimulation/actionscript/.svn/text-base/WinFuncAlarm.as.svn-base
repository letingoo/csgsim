	// ActionScript file
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	import mx.collections.ArrayCollection; 
	
	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	
	import sourceCode.faultSimulation.model.OperateListModel;
	import sourceCode.faultSimulation.titles.SelectAlarmInfoOneTitle;
	
	[Bindable]
	public var winTitle:String = "";
	[Bindable]
	public var winOperType:String = "";
	
	[Bindable]
	public var operationModel:OperateListModel;

	[Bindable]
	public var oper_descs:ArrayCollection = new ArrayCollection(
		[ {label:"本端", data:"本端"}, 
			{label:"对端", data:"对端"}]);
		
	public function resizeWin(width:int,height:int):void{
		this.width = width;
		this.height = height;
	}
	
	private function closeWin():void{
		this.closeButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
	}
	
	private function saveFunc(type:String):void{
		if(type == "Update"){
			if(operationModel.oper_type=="厂家"){
				operationModel.alarm_name=cmbName.selectedItem.@label;
				operationModel.alarm_id=cmbName.selectedItem.@id;
				operationModel.vender=cmbName.selectedItem.@label;
				operationModel.vendercode=cmbName.selectedItem.@id;
				operationModel.oper_desc="";
			}else{
				operationModel.alarm_name=txtName.text;
				operationModel.oper_desc=cmbDesc.selectedItem.data;
			}
			
			roOperManager.updateAlarmOperationByOperId(operationModel);
		}else if(type == "Add"){
			if(operationModel.oper_type=="厂家"){
				operationModel.alarm_name=cmbNodeName.selectedItem.@label;
				operationModel.alarm_id=cmbNodeName.selectedItem.@id;
				operationModel.vender=cmbNodeName.selectedItem.@label;
				operationModel.vendercode=cmbNodeName.selectedItem.@id;
				operationModel.oper_desc="";
			}else{
				operationModel.alarm_name=txtNodeName.text;
				operationModel.oper_desc=cmbNodeDesc.selectedItem.data;
			}
	
			roOperManager.insertAlarmOper(operationModel);
		}
	}
	
	private function resultHandler(event:ResultEvent):void{
		this.dispatchEvent(new Event("RefreshData"));
		closeWin();
	}
	
	private function faultHandler(event:Event):void{
		Alert.show("操作失败!","提示");
	}
//查询告警列表
protected function queryAlarmInfoHandler(event:MouseEvent):void{
	var trueOrFalse:String="false";
	if(winOperType == "Update"){
		if(operationModel!=null&&operationModel.oper_type=="告警"){trueOrFalse="true";}
	}else if(winOperType == "Add"){
		if(operationModel!=null&&operationModel.oper_type=="告警"){trueOrFalse="true";}
	}else{
		trueOrFalse="false";
	}
	if(trueOrFalse=="true"){//选择告警
		var alarmInfo:SelectAlarmInfoOneTitle = new SelectAlarmInfoOneTitle();
		PopUpManager.addPopUp(alarmInfo,this,true);
		PopUpManager.centerPopUp(alarmInfo);
		alarmInfo.x_vendor = operationModel.vendercode;
		alarmInfo.init();
		alarmInfo.myCallBack=this.selectAlarmInfoHandler;
	}else{//选择厂家
		
	}
	
}

protected function selectAlarmInfoHandler(obj:Object):void{
	if(winOperType=="Update"){
		txtName.text=obj.name;
	}else{
		txtNodeName.text=obj.name;
	}
	operationModel.alarm_id = obj.id;
}
//下拉框赋值
public function setData():void{
	getEquipVendor();
	txtId.text=operationModel.oper_id;
   setOperDescData();
	
}
public function getEquipVendor():void{
	var re:RemoteObject=new RemoteObject("resNetDwr");
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.addEventListener(ResultEvent.RESULT,getX_VendorLstHandler);
	Application.application.faultEventHandler(re);
	re.getX_VendorLst();
}
//初始化厂家下拉框
private function getX_VendorLstHandler(event:ResultEvent):void{
	var list:XMLList = new XMLList(event.result);
	if(winOperType=="Update"){
		cmbName.dataProvider = list;
		cmbName.dropdown.dataProvider = list;
		cmbName.labelField="@label";
		//cmbName.text="";
		var index:int=-1;
		for each(var employee:Object in cmbName.dataProvider)
		{ 	
			index+=1;
			if(operationModel.vendercode== employee.@id){
				cmbName.selectedIndex=index;
				break;
			}
		} 
	}else if(winOperType=="Add"){
		cmbNodeName.dataProvider = list;
		cmbNodeName.dropdown.dataProvider = list;
		cmbNodeName.labelField="@label";
		cmbNodeName.text="";
		cmbNodeName.selectedIndex=-1;
	}
	
	//
	
}
//初始化节点描述下拉框
private function setOperDescData():void{
	//oper_desc
	var index:int=-1;
	if(winOperType=="Update"){//修改
		for each(var employee:Object in cmbDesc.dataProvider)
		{ 	
			index+=1;
			if(operationModel.oper_desc== employee.data){
				cmbDesc.selectedIndex=index;
				break;
			}
		} 
	}else{//新增
		for each(var employee:Object in cmbNodeDesc.dataProvider)
		{ 	
			index+=1;
			if(operationModel.oper_desc== employee.data){
				cmbNodeDesc.selectedIndex=index;
				break;
			}
		} 
	}
}