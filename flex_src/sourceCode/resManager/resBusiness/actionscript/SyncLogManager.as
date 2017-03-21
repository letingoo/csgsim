	// ActionScript file
	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.logging.Log;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import sourceCode.systemManagement.model.LogModel;
	import sourceCode.systemManagement.model.LogResultModel;
	import sourceCode.systemManagement.views.comp.logExportFirstStep;
	import sourceCode.tableResurces.views.FileExportFirstStep;
	
	import twaver.SequenceItemRenderer;

	[Embed(source="assets/images/sysManager/hide.png")]          //这是图片的相对地址 
	[Bindable] 
	public var PointIcon:Class; 
	[Embed(source="assets/images/sysManager/hide.png")]
	[Bindable] 
	public var PointRight:Class; 
	[Embed(source="assets/images/sysManager/show.png")] 
	[Bindable]
	public var PointLeft:Class;
	private var indexRenderer:Class = SequenceItemRenderer;
	
	
	[Bindable]
	public var acLogInfos:LogResultModel;
	public var labels:String = "同步日志信息列表";
	public var titles:Array = new Array("日志类型","模块描述","功能描述",
		"执行数据","用户名","真实姓名","所属单位","IP",
		"操作时间");
	public var path:String;
	
	public var logModel:LogModel;
	private var arrCbo:Array=[{label:"手工同步"},{label:"自动同步"}];
	[Bindable]
	private var selectedCollection:ArrayCollection=new ArrayCollection(arrCbo); 
	[Bindable]
	private var logDataCount:int;
	private function get acLogInfo():LogResultModel
	{
		return acLogInfos;
	}
	
	private function set acLogInfo(value:LogResultModel):void
	{
		acLogInfos = value;
	}
	
	private function getLogModel():void{
//		if(slog_type.selectedIndex==0){
//			logModel.log_type="";
//		}
		if(slog_type.selectedIndex==0){
			logModel.log_type="手工同步";
		}
		else if(slog_type.selectedIndex==1){
			logModel.log_type="自动同步";
		}
		else{
			logModel.log_type="";
		}
		logModel.module_desc=smodule_desc.text;
		logModel.user_name=suser_name.text;
		logModel.log_time=slog_time.text.toString();
	}
	
	private function selected():void{
		queryType = true;
		getLogModel();
		logModel.start="0";
		logModel.end="50";
		con_logMgr.getSyncLogInfos(logModel);
		serverPagingBar1.navigateButtonClick("firstPage");
	}
	private function Reset():void{
		slog_type.selectedIndex=-1;
		smodule_desc.text="";
		suser_name.text="";
		slog_time.text="";
		
	}
	
	private function getLogInfos(event:ResultEvent):void{
		acLogInfos = LogResultModel(event.result);
		serverPagingBar1.orgData=acLogInfos.logList;
		serverPagingBar1.totalRecord=acLogInfos.totalCount;
		logDataCount = acLogInfos.totalCount;
		if(queryType){
			serverPagingBar1.pageSize = 50; 
			serverPagingBar1.isInit = true;
		}			
		serverPagingBar1.dataBind(true);
	}
	
	private function pagingFunction(pageIndex:int,pageSize:int):void{
		var start:String = (pageIndex * pageSize).toString();
		var end:String = ((pageIndex * pageSize) + pageSize).toString();
		getLogModel();
		logModel.start=start;
		logModel.end=end;
		con_logMgr.getSyncLogInfos(logModel);
	}
	private function faultCallBack(event:FaultEvent):void{
		Alert.show(event.message.toString(),"错误");
	}
	
	
	private function export_excel():void{
		var fefs:FileExportFirstStep = new FileExportFirstStep();
		var model:LogModel = new LogModel();
		fefs.dataNumber = logDataCount;
		fefs.exportTypes = "同步日志";
		fefs.titles = titles;
		fefs.labels = labels;
		model = logModel;
		model.start = "0";
		model.end = logDataCount.toString();
		fefs.model = model;
		MyPopupManager.addPopUp(fefs, true);
	}
	
//	
//	public function exportExcelBySubPage():void{
//		var expot_obj:RemoteObject = new RemoteObject("logManager");
//		expot_obj.showBusyCursor = true;
//		expot_obj.endpoint = ModelLocator.END_POINT;
//		expot_obj.addEventListener(ResultEvent.RESULT,expot_obj_result);
//		getLogModel();
//		expot_obj.LogExportEXCEL(labels,titles,logModel);
//		
//	}
//	
//	protected function expot_obj_result(event:ResultEvent):void
//	{
//		var url:String = Application.application.stage.loaderInfo.url;
//		url=url.substring(0,url.lastIndexOf("/"))+"/";
//		path =url + event.result.toString();
//		var request:URLRequest = new URLRequest(encodeURI(path)); 
//		navigateToURL(request,"_blank");
//	}
	
	
	private function init():void{
		controlBar.addImg.visible = true;
		controlBar.addImg.includeInLayout = true;
		slog_type.selectedIndex=-1;
		logModel = new LogModel();
		logModel.start="0";
		logModel.end="50";
		con_logMgr.getSyncLogInfos(logModel);
		serverPagingBar1.dataGrid=sysLog;
		serverPagingBar1.pagingFunction=pagingFunction;
		
		serverPagingBar1.addEventListener("viewAllEvent",Queryall);
	}
	private var queryType:Boolean = true;
	private function Queryall(event:Event):void{
		queryType = false;
	}

	public function changeState():void{
		if(queryVbox.visible){
			queryVbox.visible=!queryVbox.visible;
			queryCavas.width=30;
			PointIcon=PointLeft;
		}else{
			queryVbox.visible=!queryVbox.visible;
			queryCavas.width=261;
			PointIcon=PointRight;
		}
	}