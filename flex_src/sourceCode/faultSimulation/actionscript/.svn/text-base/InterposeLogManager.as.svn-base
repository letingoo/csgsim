	// ActionScript file
	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.logging.Log;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import sourceCode.faultSimulation.model.InterposeLogModel;
	import sourceCode.faultSimulation.model.InterposeLogResult;
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
	public var acLogInfos:InterposeLogResult;
	
	public var logModel:InterposeLogModel;
	private var arrCbo:Array=[{label:"演习"},{label:"故障"},
		{label:"割接"}];
	[Bindable]
	private var selectedCollection:ArrayCollection=new ArrayCollection(arrCbo); 
	[Bindable]
	private var logDataCount:int;
	private function get acLogInfo():InterposeLogResult
	{
		return acLogInfos;
	}
	
	private function set acLogInfo(value:InterposeLogResult):void
	{
		acLogInfos = value;
	}
	
	private function getLogModel():void{

		if(log_type.selectedIndex==-1){
			logModel.logtype="";
		}
		if(log_type.selectedIndex==0){
			logModel.logtype="演习";
		}
		if(log_type.selectedIndex==1){
			logModel.logtype="故障";
		}
		if(log_type.selectedIndex==2){
			logModel.logtype="割接";
		}
		
		logModel.logid = log_id.text;
		logModel.eventname=event_name.text;
		logModel.sourceobj=source_obj.text;
		logModel.accessobj=access_obj.text;
		logModel.eventtype=event_type.text;
		logModel.logtime=log_time.text.toString();
	}
	
	private function selected():void{
		queryType = true;
		getLogModel();
		logModel.start="0";
		logModel.end="50";
//		con_logMgr.getInterposeLogInfos(logModel);
		serverPagingBar1.navigateButtonClick("firstPage");
	}
	private function Reset():void{
		log_type.selectedIndex=-1;
		event_name.text="";
		source_obj.text="";
		log_time.text="";
		access_obj.text="";
		event_type.text="";
		log_id.text="";
	}
	
	private function getLogInfos(event:ResultEvent):void{
		acLogInfos = InterposeLogResult(event.result);
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
		con_logMgr.getInterposeLogInfos(logModel);
	}
	private function faultCallBack(event:FaultEvent):void{
		Alert.show(event.message.toString(),"错误");
	}
	
	
	private function export_excel():void{
		var fefs:FileExportFirstStep = new FileExportFirstStep();
		fefs.dataNumber = logDataCount;	
		logModel.end = logDataCount.toString();				
		fefs.titles = new Array("序号","事件ID","事件名称","事件类型","事件发出时间","事件发出对象","事件接受对象","仿真代理");				
		fefs.exportTypes = "仿真日志管理";
		fefs.labels = "仿真日志信息列表";
		fefs.model = logModel;
		MyPopupManager.addPopUp(fefs, this);
	}
	
	
	public function exportExcelBySubPage():void{
//		var expot_obj:RemoteObject = new RemoteObject("logManager");
//		expot_obj.showBusyCursor = true;
//		expot_obj.endpoint = ModelLocator.END_POINT;
//		expot_obj.addEventListener(ResultEvent.RESULT,expot_obj_result);
//		getLogModel();
//		expot_obj.LogExportEXCEL(labels,titles,logModel);
		
	}
	
	protected function expot_obj_result(event:ResultEvent):void
	{
//		var url:String = Application.application.stage.loaderInfo.url;
//		url=url.substring(0,url.lastIndexOf("/"))+"/";
//		path =url + event.result.toString();
//		var request:URLRequest = new URLRequest(encodeURI(path)); 
//		navigateToURL(request,"_blank");
	}
	
	
	private function init():void{
		controlBar.addImg.visible = true;
		controlBar.addImg.includeInLayout = true;
		log_type.selectedIndex=-1;
		logModel = new InterposeLogModel();
		logModel.start="0";
		logModel.end="50";
		con_logMgr.getInterposeLogInfos(logModel);
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