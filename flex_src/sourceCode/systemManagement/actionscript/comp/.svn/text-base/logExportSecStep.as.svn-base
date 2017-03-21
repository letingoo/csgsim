	// ActionScript file
	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	
	import sourceCode.systemManagement.views.SysLogManager;
	public var dataNumber:int;
	public var exportTypes:String;
	public var labels:String;
	public var titles:Array = null;
	[bindable]
	public var logs:SysLogManager;
	private function close():void  
	{  
		MyPopupManager.removePopUp(this);  
	} 
	
	
	protected function button1_clickHandler(event:MouseEvent):void
	{
		// TODO Auto-generated method stub
		this.close();
	}
	
	protected function Confirm_clickHandler(event:MouseEvent):void
	{
		// TODO Auto-generated method stub
		//PopUpManager.addPopUp(iora, this, true);
		//PopUpManager.centerPopUp(iora);
		//iora.intiliz();
		if(event.target.label=="导出")
		{
			logs.exportExcelBySubPage();
		}
		
	}