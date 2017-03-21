	// ActionScript file
	import common.actionscript.ModelLocator;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	import mx.validators.DateValidator;
	import mx.validators.NumberValidator;
	import mx.validators.Validator;
	
	import sourceCode.systemManagement.model.Problems;
	import sourceCode.systemManagement.model.ProblemsModel;
	public var comobo_module:ArrayCollection = new ArrayCollection();
	public var comobo_module2:ArrayCollection = new ArrayCollection();
	public var comobo_module3:ArrayCollection = new ArrayCollection();
	public var comobo_module4:ArrayCollection = new ArrayCollection();
	public var remotCall:RemoteObject = new RemoteObject("netresDao");
	public var remotCall2:RemoteObject = new RemoteObject("netresDao");
	public var remotCall3:RemoteObject = new RemoteObject("netresDao");
	public var remotCall4:RemoteObject = new RemoteObject("netresDao");
	public var days:Array = new Array("日", "一", "二", "三", "四", "五","六");
	public var monthNames:Array = new Array("一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月");		
	protected function canvas1_initializeHandler(event:FlexEvent):void
	{
		// TODO Auto-generated method stub
		remotCall.endpoint = ModelLocator.END_POINT;
		remotCall2.endpoint= ModelLocator.END_POINT;
		remotCall3.endpoint= ModelLocator.END_POINT;
		remotCall4.endpoint= ModelLocator.END_POINT;
		
		remotCall.getModule();
		remotCall3.getStatus();
		remotCall4.getHandler();
		remotCall2.getHandlePopHlr();
		
		remotCall.addEventListener(ResultEvent.RESULT,modelResultHandler);
		remotCall2.addEventListener(ResultEvent.RESULT,modelResultHandler2);
		remotCall3.addEventListener(ResultEvent.RESULT,modelResultHandler3);
		remotCall4.addEventListener(ResultEvent.RESULT,modelResultHandler4);
		//var dataValidator:DateValidator = new DateValidator();
	}
	
	protected function btn_clickHandler(event:MouseEvent):void
	{
		if(this.btn.label=="添加")
		{
			var add:RemoteObject = new RemoteObject("netresDao");
			add.endpoint = ModelLocator.END_POINT;
			add.showBusyCursor=true;
			var problem:Problems  = new Problems();
			problem.setpmodule(this.module.text);
			problem.setpdescription(this.discrip.text);
			problem.setpdealer(this.per.text);
			problem.setpstatus(this.st.text);
			problem.setptreatmethod(this.method.text);
			problem.setpremark(this.remark.text);
			problem.setppopperson(this.pop.text);
			problem.setpmakedate(this.poptime.text);
			//problem.setphelper(this.hel.text);
			problem.setdeadlinedate(this.deadLineTime.text);
			problem.setfinisheddate(this.actFinishTime.text);
			problem.setpproperty(this.problemProperty.text);
			add.addProblem(problem);
			add.addEventListener(ResultEvent.RESULT,addResultHandler);
			//parentApplication.faultEventHandler(add);
		}else	if(this.btn.label=="修改")
		{
			var mod:RemoteObject = new RemoteObject("netresDao"); 
			mod.endpoint = ModelLocator.END_POINT;
			mod.showBusyCursor=true;
			var problem:Problems  = new Problems();
			problem.setproblemid(parentDocument.ProblemdataGrid.selectedItem.problemid);
			problem.setpmodule(this.module.text);
			problem.setpdescription(this.discrip.text);
			problem.setpdealer(this.per.text);
			problem.setpstatus(this.st.text);
			problem.setptreatmethod(this.method.text);
			problem.setpremark(this.remark.text);
			problem.setppopperson(this.pop.text);
			problem.setpmakedate(this.poptime.text);
			//problem.setphelper(this.hel.text);
			problem.setdeadlinedate(this.deadLineTime.text);
			problem.setfinisheddate(this.actFinishTime.text);
			problem.setpproperty(this.problemProperty.text);
			mod.updateProblem(problem);
			mod.addEventListener(ResultEvent.RESULT,updateProblemHandler);
			//parentApplication.faultEventHandler(mod);
		}else	if(this.btn.label=="查询")
		{
			var srh:RemoteObject = new RemoteObject("netresDao"); 
			srh.endpoint = ModelLocator.END_POINT;
			srh.showBusyCursor=true;
			//var problem:Problems  = new Problems();
			parentDocument.problem.setpmodule(this.module.text);
			parentDocument.problem.setpdescription(this.discrip.text);
			parentDocument.problem.setpdealer(this.per.text);
			parentDocument.problem.setpstatus(this.st.text);
			parentDocument.problem.setptreatmethod(this.method.text);
			parentDocument.problem.setpremark(this.remark.text);
			parentDocument.problem.setppopperson(this.pop.text);
			parentDocument.problem.setpmakedate(this.poptime.text);
			//parentDocument.problem.setphelper(this.hel.text);
			parentDocument.problem.setdeadlinedate(this.deadLineTime.text);
			parentDocument.problem.setfinisheddate(this.actFinishTime.text);
			parentDocument.problem.setpproperty(this.problemProperty.text);
			srh.getProblem(parentDocument.problem);
			srh.addEventListener(ResultEvent.RESULT,srhResultHandler);
			//parentApplication.faultEventHandler(srh);
		}
		// TODO Auto-generated method stub
	}
	
	public function addResultHandler(event:ResultEvent):void
	{
		if(event.result =="success")
		{
			Alert.show("添加成功！","提示");
		}else if(event.result =="blank")
		{
			Alert.show("请按要求填写数据！","提示");
		}
		else if(event.result =="timeblank")
		{
			Alert.show("时间不能为空！","提示");
		}else{
			Alert.show("添加失败！","很抱歉");
		}
		var addData:RemoteObject = new RemoteObject("netresDao");
		addData.endpoint = ModelLocator.END_POINT;
		var problem:Problems = new Problems();
		problem.setreSort("pstatus");
		addData.getProblem(problem); 
		addData.addEventListener(ResultEvent.RESULT,addDataHandler);
		//parentApplication.faultEventHandler(addData);
	}
	
	public function addDataHandler(event:ResultEvent):void
	{
		var result:ProblemsModel=event.result as ProblemsModel;
		parentDocument.onResult(result);
		removeEventListener(ResultEvent.RESULT,addDataHandler);
	}
	
	public function srhResultHandler(event:ResultEvent):void
	{
		var result:ProblemsModel=event.result as ProblemsModel;
		parentDocument.onResult(result);
	}
	
	public function updateProblemHandler(event:ResultEvent):void{
		if(event.result =="success")
		{
			Alert.show("修改成功！","提示");
		}else if(event.result =="blank")
		{
			Alert.show("请按要求填写数据！","提示");
		}
		else if(event.result =="timeblank")
		{
			Alert.show("请按要求填写数据！","提示");
		}else{
			Alert.show("修改失败！","提示");
		}
		var getData:RemoteObject = new RemoteObject("netresDao");
		getData.endpoint = ModelLocator.END_POINT;
		getData.getProblem(parentDocument.problem); 
		getData.addEventListener(ResultEvent.RESULT,getDataHandler);
		//parentApplication.faultEventHandler(getData);
	}
	
	public function getDataHandler(event:ResultEvent):void
	{
		var result:ProblemsModel=event.result as ProblemsModel;
		parentDocument.onResult(result);
		removeEventListener(ResultEvent.RESULT,getDataHandler);
	}
	
	public function modelResultHandler(event:ResultEvent):void{
		this.comobo_module = event.result as ArrayCollection;
		module.dataProvider = comobo_module;
		remotCall.removeEventListener(ResultEvent.RESULT,modelResultHandler);
	}
	public function modelResultHandler2(event:ResultEvent):void{
		this.comobo_module2 = event.result as ArrayCollection;
		pop.dataProvider = comobo_module2;
		//hel.dataProvider = comobo_module2;
		remotCall2.removeEventListener(ResultEvent.RESULT,modelResultHandler2);
	}
	
	public function modelResultHandler3(event:ResultEvent):void{
		this.comobo_module3 = event.result as ArrayCollection;
		st.dataProvider = comobo_module3;
		remotCall3.removeEventListener(ResultEvent.RESULT,modelResultHandler3);
	}
	
	public function modelResultHandler4(event:ResultEvent):void{
		this.comobo_module4 = event.result as ArrayCollection;
		per.dataProvider = comobo_module4;
		remotCall4.removeEventListener(ResultEvent.RESULT,modelResultHandler4);
	}
	
	protected function reset_Btn_clickHandler(event:MouseEvent):void
	{
		// TODO Auto-generated method stub
		this.resetAddNavValues();
	}
	
	public function resetAddNavValues():void
	{
		this.module.text ="请选择..";
		this.module.selectedIndex = 0;
		this.discrip.text = "";
		this.per.text = "请选择..";
		this.per.selectedIndex = 0;
		this.st.text = "请选择..";
		this.st.selectedIndex = 0;
		this.remark.text = "";
		this.problemProperty.text = "请选择..";
		this.problemProperty.selectedIndex = 0;
		this.deadLineTime.text = "";
		this.actFinishTime.text = "";
		this.method.text = "";
		this.pop.text = "请选择..";
		this.pop.selectedIndex = 0;
		this.poptime.text = "";
		//this.hel.text = "请选择..";
	}