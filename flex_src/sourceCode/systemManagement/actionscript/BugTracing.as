	// ActionScript file
	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	
	import mx.collections.ArrayCollection;
	import mx.containers.TabNavigator;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.events.DataGridEvent;
	import mx.events.FlexEvent;
	import mx.events.IndexChangedEvent;
	import mx.events.ItemClickEvent;
	import mx.events.ListEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	import mx.validators.DateValidator;
	import mx.validators.NumberValidator;
	import mx.validators.Validator;
	
	import sourceCode.systemManagement.model.Problems;
	import sourceCode.systemManagement.model.ProblemsModel;
	import sourceCode.systemManagement.views.comp.DataImportFirstStep;
	
	import twaver.SequenceItemRenderer;

	public var Nav:TabNavigator = new TabNavigator();
	public var navadd:Navigators = new Navigators();
	public var navmod:Navigators = new Navigators();
	public var navsrh:Navigators = new Navigators();
	private var alert:Alert;
	private var exalert:Alert;
	public var path:String;
	public var pageIndex:int=0;
	public var pageSize:int=50;
	private var downloadURL:URLRequest;
	private var DownLoadfile:FileReference;
	[Embed(source="assets/images/sysManager/show.png")]         
	[Bindable] 
	public var PointIcon:Class; 
	[Embed(source="assets/images/sysManager/show.png")]
	[Bindable] 
	public var PointRight:Class; 
	[Embed(source="assets/images/sysManager/hide.png")] 
	[Bindable]
	public var PointLeft:Class;
	public 	var problem:Problems = new Problems();
	public var labels:String = "问题跟踪数据导出";
	public var titles:Array = new Array("问题编号", "所属模块", "问题描述", "问题修改人", "问题状态","问题属性","问题提出人","问题提出时间","要求完成时间","实际完成时间");
	private var indexRenderer:Class = SequenceItemRenderer;
	private var exora:DataImportFirstStep;
	
	public function vbox1_creationCompleteHandler(event:FlexEvent):void
	{
		serverPagingBar1.addEventListener("returnALL",returnALL);
		serverPagingBar1.pagingFunction = PagingFunction;
		serverPagingBar1.dataGrid =ProblemdataGrid;
		problem.setreSort("pstatus");
		problem.setstart("0");
		problem.setend(pageSize.toString());
		//parentApplication.faultEventHandler(rm);
		rm.getProblem(problem); 
		navadd.initialize();
		navadd.label="添加";
		navadd.btn.label="添加";
		navmod.initialize();
		navmod.label="修改";
		navmod.btn.label="修改";
		navsrh.initialize();
		navsrh.label="查询";
		navsrh.btn.label="查询";
		Nav.addChild(navadd);
		Nav.addChild(navmod);
		Nav.addChild(navsrh);
		queryPanel.addChild(Nav);
		Nav.addEventListener(IndexChangedEvent.CHANGE,IndexChangedHandler);
		ProblemdataGrid.addEventListener(ListEvent.CHANGE,selectItemChangeHandler);
		ProblemdataGrid.addEventListener(DataGridEvent.HEADER_RELEASE,headerRelease);
		
	}
	
	public function returnALL(event:Event = null):void
	{
		problem = new Problems();
		problem.setreSort("pstatus");
		problem.setstart("0");
		problem.setend(pageSize.toString());
		var data:RemoteObject = new RemoteObject("netresDao"); 
		data.endpoint = ModelLocator.END_POINT;
		data.showBusyCursor = true;
		data.getProblem(problem); 
		data.addEventListener(ResultEvent.RESULT,RegetdataHandler);
		//parentApplication.faultEventHandler(data);
	}
	
	public function RegetdataHandler(event:ResultEvent):void{
		var result:ProblemsModel=event.result as ProblemsModel;
		this.onResult(result);
	}
	
	public function headerRelease(event:DataGridEvent):void
	{
		var sortInfo:String  = event.dataField.toString();
		problem.setreSort(sortInfo);
		var data:RemoteObject = new RemoteObject("netresDao"); 
		data.endpoint = ModelLocator.END_POINT;
		data.showBusyCursor = true;
		data.reSort(problem); 
		data.addEventListener(ResultEvent.RESULT,reSortHandler);
		//parentApplication.faultEventHandler(data);
	}
	
	public function reSortHandler(event:ResultEvent):void{
		var result:ProblemsModel=event.result as ProblemsModel;
		this.onResult(result);
	}
	
	
	public function PagingFunction(pageIndex:int,pageSize:int):void
	{
		this.pageSize=pageSize;
		problem.start=(pageIndex*pageSize).toString();
		problem.end =(pageIndex*pageSize+pageSize).toString();
		var data:RemoteObject = new RemoteObject("netresDao"); 
		data.endpoint = ModelLocator.END_POINT;
		data.showBusyCursor = true;
		data.getProblem(problem); 
		data.addEventListener(ResultEvent.RESULT,dataHandler);
		//parentApplication.faultEventHandler(data);
	}
	
	public function dataHandler(event:ResultEvent):void{
		var result:ProblemsModel=event.result as ProblemsModel;
		this.onResult(result);
	}
	
	public function setText():void{
		navmod.module.text = this.ProblemdataGrid.selectedItem.pmodule;
		navmod.discrip.text =  this.ProblemdataGrid.selectedItem.pdescription;
		navmod.per.text = this.ProblemdataGrid.selectedItem.pdealer;
		navmod.st.text = this.ProblemdataGrid.selectedItem.pstatus;
		navmod.method.text = this.ProblemdataGrid.selectedItem.ptreatmethod;
		navmod.remark.text = this.ProblemdataGrid.selectedItem.premark;
		navmod.pop.text = this.ProblemdataGrid.selectedItem.ppopperson;
		navmod.poptime.text = this.ProblemdataGrid.selectedItem.pmakedate==null?"":this.ProblemdataGrid.selectedItem.pmakedate;
		//navmod.hel.text = this.ProblemdataGrid.selectedItem.phelper;
		navmod.problemProperty.text = this.ProblemdataGrid.selectedItem.pproperty;
		navmod.actFinishTime.text = this.ProblemdataGrid.selectedItem.finisheddate==null?"":this.ProblemdataGrid.selectedItem.finisheddate;
		navmod.deadLineTime.text = this.ProblemdataGrid.selectedItem.deadlinedate==null?"":this.ProblemdataGrid.selectedItem.deadlinedate;
	}
	
	public function selectItemChangeHandler(event:ListEvent):void{
		navmod.resetAddNavValues();
		this.setText();
	}
	
	public function IndexChangedHandler(event:IndexChangedEvent):void{
		
		if(event.target.selectedIndex==1)
		{
			if(ProblemdataGrid.selectedItem==null||ProblemdataGrid.selectedItem=="")
			{
				Alert.show("请先选择一条数据!","提示");
			}
		}
		navadd.resetAddNavValues();
		navsrh.resetAddNavValues();
	}
	protected function rm_resultHandler(event:ResultEvent):void
	{
		// TODO Auto-generated method stub
		var result:ProblemsModel=event.result as ProblemsModel;
		this.onResult(result);
	}
	public function onResult(result:ProblemsModel):void 
	{	
		serverPagingBar1.orgData=result.orderList;
		serverPagingBar1.totalRecord=result.totalCount;
		serverPagingBar1.dataBind(true);	
	}
	
	/**
	 * 菜单控制
	 * */
	public function changeState():void{
		if(queryPanel.visible){
			queryPanel.visible=!queryPanel.visible;
			queryCanvas.width=20;
			Nav.width=20;
			PointIcon=PointRight;
		}else{
			queryPanel.visible=!queryPanel.visible;
			queryCanvas.width=360;
			Nav.width=360;
			PointIcon=PointLeft;
		}
	}
	
	public function itemClickHandler(funLabel:String):void{
		switch(funLabel){
			case "添加":
				queryPanel.visible=true;
				queryCanvas.width=360;
				Nav.width=360;
				Nav.selectedIndex =0;
				var discrip_validator:Validator = new Validator();
				discrip_validator.source = navadd.discrip;
				discrip_validator.property="text";
				discrip_validator.requiredFieldError="不能为空！";
				
				var date_validator:Validator = new Validator();
				date_validator.source = navadd.poptime;
				date_validator.property="text";
				date_validator.requiredFieldError="不能为空！";
				navadd.resetAddNavValues();
				
				break;
			case "修改":
				if(ProblemdataGrid.selectedItem==null||ProblemdataGrid.selectedItem=="")
				{
					Alert.show("请先选择一条数据!","提示");
				}else
				{
					navmod.resetAddNavValues();
					queryPanel.visible=true;
					queryCanvas.width=360;
					Nav.width=360;
					Nav.selectedIndex =1;
					this.setText();
				}
				break;
			case "删除":
				//						if(ProblemdataGrid.selectedItem==null||ProblemdataGrid.selectedItem=="")
				//						{
				//						  Alert.show("请先选择一条数据!","提示");
				//						}else
				//						  {
				//								 this.delconfirm();
				//						   }
				
				break;
			case "查询":
				queryPanel.visible=true;
				queryCanvas.width=360;
				Nav.selectedIndex =2;
				Nav.width=360;
				navsrh.resetAddNavValues();
				break;
			case "导出Excel":
				var excelexport:RemoteObject = new RemoteObject("netresDao"); 
				excelexport.endpoint = ModelLocator.END_POINT;
				excelexport.showBusyCursor = true;
//				problem.setend(serverPagingBar1.totalRecord.toString()); 
				excelexport.ProblemExportEXCEL(problem,labels,titles,"问题跟踪数据");
				excelexport.addEventListener(ResultEvent.RESULT,ProblemExportHandler);
				//parentApplication.faultEventHandler(excelexport);
				break;
			case "添加快捷方式":
				parentApplication.addShorcut('问题跟踪','track');
				break;
			case "删除快捷方式":
				parentApplication.delShortcut('问题跟踪');
				break;
			case "导入数据":
				exora = new DataImportFirstStep();
				MyPopupManager.addPopUp(exora,true);
				break;
			default:
				break;
		}
	}
	
	public function exportExcelFunction(event:Event = null):void
	{
		this.confirm();
	}
	private function confirm():void {
		exalert =  Alert.show("您确认要进行导出吗？","请您确认！",Alert.YES|Alert.NO,this,confirmHandler,null,Alert.NO);
	}
	
	private function confirmHandler(event:CloseEvent):void {
		if (event.detail == Alert.YES) {
			this.downLoadFiles(path);
		} else if (event.detail == Alert.NO) {
		}
	}
	
	public function ProblemExportHandler(event:ResultEvent):void
	{
		path = event.result.toString();
		this.exportExcelFunction();
	}
	
	private function downLoadFiles(urlAdd:String):void
	{
		var str:Array = urlAdd.split("/");
		downloadURL = new URLRequest(encodeURI(urlAdd));
		DownLoadfile = new FileReference();
		DownLoadfile.addEventListener(IOErrorEvent.IO_ERROR,eventHandler);
		DownLoadfile.download(downloadURL,str[str.length - 1]);
		DownLoadfile.addEventListener(Event.COMPLETE,CompeteHandler);
	}
	
	public function CompeteHandler(event:Event):void{
		Alert.show("文件导出成功！","文件导出");
	}
	
	public function eventHandler(event:IOErrorEvent):void
	{
		Alert.show(event.toString());
	}
	
	private function delconfirm(event:Event=null):void {
		alert =  Alert.show("您确认要删除吗？","请您确认！",Alert.YES|Alert.NO,this,delconfirmHandler,null,Alert.NO);
	}
	
	private function delconfirmHandler(event:CloseEvent):void {
		if (event.detail == Alert.YES) {
			var del:RemoteObject = new RemoteObject("netresDao"); 
			del.endpoint = ModelLocator.END_POINT;
			del.showBusyCursor=true;
			del.DeleteProblem(ProblemdataGrid.selectedItem.problemid);
			del.addEventListener(ResultEvent.RESULT,delEventHandler);
			//parentApplication.faultEventHandler(del);
		} else if (event.detail == Alert.NO) {
			
		}
	}
	
	public function delEventHandler(event:ResultEvent):void{
		if(event.result=="success")
		{
			Alert.show("删除成功！","提示");
			var problem:Problems = new Problems();
			//parentApplication.faultEventHandler(rm);
			rm.getProblem(problem); 
			
		}else 
		{
			Alert.show("删除失败！","提示");
		}
		this.removeEventListener(ResultEvent.RESULT,delEventHandler);
	}
	
	private function setColorFunction(item:Object, color:uint):uint 
	{ 
		if( item['pstatus'] == "待确认" )
		{ 
			return 0xFF0000; 
		}else if(item['pstatus'] == "尚未启动")
		{
			return 0xFF0000; 
		}else if(item['pstatus'] == "已确认")
		{
			return 0xFF6633; 
		}else if(item['pstatus'] == "部分完成")
		{
			return 0xFFFF00;
		}else if(item['pstatus'] == "进行中")
		{
			return 0xFFFF00;
		}else if(item['pstatus'] == "已完成")
		{
			return 0x33CC33;
		}
		return color; 
	} 