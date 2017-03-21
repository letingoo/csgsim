	// ActionScript file
	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	
	import sourceCode.systemManagement.views.SysLogManager;
	public var dataNumber:int;
	public var exportTypes:String;
	public var labels:String;
	public var titles:Array = null;
	[Bindable]
	public var logObject:SysLogManager;			
	private function close():void  
	{  
		MyPopupManager.removePopUp(this);  
	} 
	
	
	protected function button1_clickHandler(event:MouseEvent):void
	{
		// TODO Auto-generated method stub
		this.close();
	}
	
	protected function NEXT_clickHandler(event:MouseEvent):void
	{
		// TODO Auto-generated method stub
		if(event.target.label=="下一步")
		{
			this.close();
			var fess:logExportSecStep = new logExportSecStep();
			//					fess.exportTypes = this.exportTypes;
			//					fess.titles = this.titles;
			//					fess.labels = this.labels;
			fess.dataNumber = this.dataNumber;
			fess.logs = this.logObject;
			MyPopupManager.addPopUp(fess, true);
		}else if(event.target.label=="导出")
		{
			logObject.exportExcelBySubPage();
		}
	}
	
	
	private static function getURL():String{
		var currSwfUrl:String; 
		var doMain:String = Application.application.stage.loaderInfo.url;  
		var doMainArray:Array = doMain.split("/");  
		
		if (doMainArray[0] == "file:") {  
			if(doMainArray.length<=3){  
				currSwfUrl = doMainArray[2];  
				currSwfUrl = currSwfUrl.substring(0,currSwfUrl.lastIndexOf(currSwfUrl.charAt(2)));  
			}else{  
				currSwfUrl = doMain;  
				currSwfUrl = currSwfUrl.substring(0,currSwfUrl.lastIndexOf("/"));  
			}  
		}else{  
			currSwfUrl = doMain;  
			currSwfUrl = currSwfUrl.substring(0,currSwfUrl.lastIndexOf("/"));  
		}  
		currSwfUrl += "/";
		return currSwfUrl;
	}
	
	public function expot_obj_result(event:ResultEvent):void{
		var url:String = getURL();
		var path = url+event.result.toString();
		//Alert.show(path);
		var request:URLRequest = new URLRequest(encodeURI(path)); 
		navigateToURL(request,"_blank");
	}
	
	
	protected function titlewindow1_creationCompleteHandler(event:FlexEvent):void
	{
		// TODO Auto-generated method stub
		if(this.dataNumber<20000)
		{
			btn_confirm.label ="导出";
		}else
		{
			btn_confirm.label = "下一步";
		}
		var remote:RemoteObject = new RemoteObject("netresDao");
		remote.endpoint = ModelLocator.END_POINT;
		remote.showBusyCursor = true;
		remote.ClearDir("exportExcel");
		//parentApplication.faultEventHandler(remote);
		//remote.addEventListener(ResultEvent.RESULT,ClearDirHandler);
	}