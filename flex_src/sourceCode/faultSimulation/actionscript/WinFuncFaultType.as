	// ActionScript file
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	
	import sourceCode.faultSimulation.model.OperateListModel;
	import sourceCode.faultSimulation.titles.SelectAlarmInfoTitle;
	
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
			
			operationModel.projectname=txtName.text;
			operationModel.projectid=txtId.text;
			operationModel.operatetype=cmbOperType.selectedItem.@label;
			operationModel.operatetypeid=cmbOperType.selectedItem.@id;
			roOperManager.updateFaultTypeByOperId(operationModel);
		}else if(type == "Add"){
			
			operationModel.projectname=txtNodeName.text;
			operationModel.operatetype=cmbNodeOperType.selectedItem.@label;
			operationModel.operatetypeid=cmbNodeOperType.selectedItem.@id;
			operationModel.oper_desc="";
	
			roOperManager.insertFaultType(operationModel);
		}
	}
	
	private function resultHandler(event:ResultEvent):void{
		this.dispatchEvent(new Event("RefreshData"));
		closeWin();
	}
	
	private function faultHandler(event:Event):void{
		Alert.show("操作失败!","提示");
	}

//下拉框赋值
public function setData():void{
	getInterposeType();
	txtId.text=operationModel.projectid;
	
}
public function getInterposeType():void{
	var re:RemoteObject=new RemoteObject("faultSimulation");
	re.endpoint = ModelLocator.END_POINT;
	re.showBusyCursor = true;
	re.addEventListener(ResultEvent.RESULT,getInterposeTypeResultHandler);
	Application.application.faultEventHandler(re);
	re.getInterposeType();
}
//初始化科目类型下拉框
private function getInterposeTypeResultHandler(event:ResultEvent):void{
	var list:XMLList = new XMLList(event.result);
	if(winOperType=="Update"){
		cmbOperType.dataProvider = list;
		cmbOperType.dropdown.dataProvider = list;
		cmbOperType.labelField="@label";
		//cmbName.text="";
		var index:int=-1;
		for each(var employee:Object in cmbOperType.dataProvider)
		{ 	
			index+=1;
			if(operationModel.operatetypeid== employee.@id){
				cmbOperType.selectedIndex=index;
				break;
			}
		} 
	}else if(winOperType=="Add"){
		cmbNodeOperType.dataProvider = list;
		cmbNodeOperType.dropdown.dataProvider = list;
		cmbNodeOperType.labelField="@label";
		cmbNodeOperType.text="";
		cmbNodeOperType.selectedIndex=-1;
	}
	
	//
	
}
