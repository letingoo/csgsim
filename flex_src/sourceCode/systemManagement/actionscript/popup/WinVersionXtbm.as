	// ActionScript file
	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	import sourceCode.systemManagement.model.VersionModel;
	
	[Bindable]
	public var winTitle:String = "";
	
	[Bindable]
	public var operationModel:VersionModel;
	
	public function resizeWin(width:int,height:int):void{
		this.width = width;
		this.height = height;
	}
	
	private function closeWin():void{
		this.closeButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
	}
	
	private function saveFunc(type:String):void{
		if(type == "Update"){
			if(txtXtbm.text==null||txtXtbm.text==""){
				Alert.show("节点内容未填写");
				txtXtbm.setFocus();
				return;
			}else if(txtXtxx.text==null||txtXtxx.text==""){
				Alert.show("节点描述未填写");
				txtXtxx.setFocus();
				return;
			}
			operationModel.xtbm = txtXtbm.text;
			operationModel.xtxx = txtXtxx.text;
			operationModel.vtype = txtType.text;
			operationModel.remark = txtRemark.text;
			roOperManager.updateVXtbmByOperId(operationModel);
		}else if(type == "Add"){
			if(txtNodeXtbm.text==null||txtNodeXtbm.text==""){
				Alert.show("节点内容未填写");
				txtNodeXtbm.setFocus();
				return;
			}else if(txtNodeXtxx.text==null||txtNodeXtxx.text==""){
				Alert.show("节点描述未填写");
				txtNodeXtxx.setFocus();
				return;
			}
			operationModel.xtbm = txtNodeXtbm.text;
			operationModel.xtxx = txtNodeXtxx.text;
			operationModel.vtype = txtNodeType.text;
			operationModel.remark = txtNodeRemark.text;
		    roOperManager.insertVXtbm(operationModel);
			if(txtNodeType.text=="数据库版本"){
				var rmObj:RemoteObject = new RemoteObject("login");
				rmObj.endpoint = ModelLocator.END_POINT;
				rmObj.showBusyCursor = false;
				//			rmObj.addEventListener(ResultEvent.RESULT,resultHandler);
				rmObj.addVersionUser(txtNodeXtbm.text);//新增数据库 用户
				Application.application.faultEventHandler(rmObj);
			}

		}
	}
	
	private function resultHandler(event:ResultEvent):void{
		this.dispatchEvent(new Event("RefreshData"));
		closeWin();
	}
	
	private function faultHandler(event:Event):void{
		Alert.show("操作失败!","提示");
	}