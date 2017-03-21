	// ActionScript file
	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	import sourceCode.systemManagement.model.OperationModel;
	
	[Bindable]
	public var winTitle:String = "";
	
	[Bindable]
	public var operationModel:OperationModel;
	
	public function resizeWin(width:int,height:int):void{
		this.width = width;
		this.height = height;
	}
	
	private function closeWin():void{
		this.closeButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
	}
	
	private function saveFunc(type:String):void{
		if(type == "Update"){
			operationModel.oper_name = txtName.text;
			roOperManager.updateOperationByOperId(operationModel);
		}else if(type == "Add"){
			operationModel.oper_name = txtNodeName.text;
			roOperManager.insertOper(operationModel);
		}
	}
	
	private function resultHandler(event:ResultEvent):void{
		this.dispatchEvent(new Event("RefreshData"));
		closeWin();
	}
	
	private function faultHandler(event:Event):void{
		Alert.show("操作失败!","提示");
	}