	// ActionScript file
	import common.actionscript.ModelLocator;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	
	import sourceCode.systemManagement.model.OperateDepartModel;
	
	public var refreshDepart:PaginationDataGrid;
	
	[Bindable]
	public var userid:String;
	[Bindable]
	private var operateDepart:ArrayCollection;
	[Bindable]
	private var nOperateDepart:ArrayCollection;
	public function get operateDepartSet():ArrayCollection
	{
		return operateDepart;
	}
	
	public function set operateDepartSet(value:ArrayCollection):void
	{
		operateDepart = value;
	}
	
	public function get nOperateDepartSet():ArrayCollection
	{
		return nOperateDepart;
	}
	
	public function set nOperateDepartSet(value:ArrayCollection):void
	{
		nOperateDepart = value;
	}
	public function init():void{
		to_configOperate.getConfigOperation(userid);
		to_notConfigOperate.getNotConfigOperation(userid);
	}
	
	private function getConfigOperateHandler(event:ResultEvent):void{
		operateDepartSet=ArrayCollection(event.result);
		
	}
	
	private function getNotConfigOperateHandler(event:ResultEvent):void{
		nOperateDepartSet=ArrayCollection(event.result);
	}
	
	private function save():void{
		var changeDepartsObject:RemoteObject = new RemoteObject("userManager");
		changeDepartsObject.endpoint = ModelLocator.END_POINT;
		changeDepartsObject.addEventListener(ResultEvent.RESULT,resultString);
		//parentApplication.faultEventHandler(changeDepartsObject);
		changeDepartsObject.departChanged(userid,operateDepart);
		close();
	}
	
	private function resultString(event:ResultEvent):void{
		var resultStr:String = event.result as String;
		if(resultStr=="setSuccess"){
			Alert.show("操作配置成功","提示",0,this,setSucces);
		}else{
			close();
			Alert.show("配置失败，请确认用户是否还存在！","提示",0,this,setSucces);
		}
	}
	
	private function setSucces(event:CloseEvent):void{
		if(event.detail == Alert.OK){
			refreshDepart.c_updaeUser();
		}
	}
	
	private function operateReset():void{
		init();
	}
	private function close():void{  
		PopUpManager.removePopUp(this);  
	} 
	
	
	private function notseted_itemDoubleClick():void
	{
		// TODO Auto-generated method stub
		
		var departNotSeted:OperateDepartModel=new OperateDepartModel();
		departNotSeted.departCode = notseted.selectedItem.departCode.toString();
		departNotSeted.departName = notseted.selectedItem.departName.toString();
		operateDepart.addItem(departNotSeted);
		nOperateDepart.removeItemAt(notseted.selectedIndex);
	}
	
	
	private function seted_itemDoubleClick():void
	{
		// TODO Auto-generated method stub
		var departSeted:OperateDepartModel=new OperateDepartModel();
		departSeted.departCode = seted.selectedItem.departCode.toString();
		departSeted.departName = seted.selectedItem.departName.toString();
		nOperateDepart.addItem(departSeted);
		operateDepart.removeItemAt(seted.selectedIndex);
	}