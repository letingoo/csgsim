	// ActionScript file
	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	import sourceCode.systemManagement.model.TaskModel;
	import sourceCode.systemManagement.views.popup.ConnectSourceWin;

	[Bindable] public var taskData:Object;	
	public var totask:RemoteObject=new RemoteObject("taskConfigDao");
	[Bindabel] public var taskTypeXML:XMLList;
	[Bindabel] public var isactivateXML:XMLList;
	[Bindable] public var performerXML:XMLList;
	
	public var _tasktype:String;
	public var _isactivated:String;
	public var _performer:String;
	public var _task_period:String;
	public var _starttime:String;
	public var _search:TaskModel;
	public var _sourceid:String;
	public var _sourcename:String;

	public function init():void{
		_search=new TaskModel();
		totask.endpoint=ModelLocator.END_POINT;
		totask.showBusyCursor = true;
		totask.addEventListener(ResultEvent.RESULT,taskTypeHandle);
		totask.getTaskTpyeInfosForFlex();
	}
	
	private function taskTypeHandle(event:ResultEvent):void{
		taskTypeXML = new XMLList(event.result);
		tasktype.dataProvider = taskTypeXML;
		tasktype.selectedIndex = -1;
		totask.removeEventListener(ResultEvent.RESULT,taskTypeHandle);
		getIsactivated();
	}
	
	private function getIsactivated():void{
		var xml:XMLList = new XMLList("<name label='有效' id='1'></name><name label='无效' id='0' ></name>");
		isactivated.dataProvider = xml;
		isactivated.selectedIndex = -1;
		getperformers();
//		totask.addEventListener(ResultEvent.RESULT,isactivatedHandle);
//		totask.getIsactivatedInfosForFlex();
	}
	
//	private function isactivatedHandle(event:ResultEvent):void{
//		isactivateXML = new XMLList(event.result);
//		isactivated.dataProvider = isactivateXML;
//		isactivated.selectedIndex = -1;
//		totask.removeEventListener(ResultEvent.RESULT,isactivatedHandle);
//		getperformers();
//	}
	
	private function getperformers():void{
		totask.addEventListener(ResultEvent.RESULT,performersHandle);
		totask.getperformerInfosForFlex();
	}
	
	private function performersHandle(event:ResultEvent):void{
		//				Alert.show(event.result.toString());
		performerXML = new XMLList(event.result);
		performer.dataProvider = performerXML;
		performer.selectedIndex = -1;
		totask.removeEventListener(ResultEvent.RESULT,performersHandle);
		if(this.title == "修改"){
			setTaskTpye(_tasktype);
			setIsactivated(_isactivated);
			setPerformer(_performer);
			setStartTime(_starttime);
			setTaskperiod(_task_period);
			setSource(_sourceid,_sourcename);
		}
	}

	private function setSource(sourceid:String,sourcename:String):void{
		if(sourceid != null){
			con_sourcesid.text = sourceid;
			if(sourcename != null && sourcename != ""){
				con_sources.text = sourcename;	
			}
		}
	}

	public function setTaskTpye(label:String):void
	{
		for each (var item:Object in tasktype.dataProvider)
		{
			if (item.@label == label)
			{
				tasktype.selectedItem=item;
			}
			
		}
	}
	
	public function setIsactivated(label:String):void
	{
		for each (var item:Object in isactivated.dataProvider)
		{
			if (item.@label == label)
			{
				isactivated.selectedItem=item;
			}
			
		}
	}
	
	public function setPerformer(label:String):void
	{
		for each (var item:Object in performer.dataProvider)
		{
			if (item.@label == label)
			{
				performer.selectedItem=item;
			}
		}
	}
	public function setStartTime(starttime:String):void{
		if(null!=starttime&&""!=starttime){
			var timeArray:Array = starttime.split(":");
			var a:Number = Number(timeArray[0].toString());
			hour.value = a;
			var b:Number = Number(timeArray[1].toString());
			minter.value = b;
			var c:Number = Number(timeArray[2].toString());
			second.value = c;
		}
	}
	
	public function setTaskperiod(period:String):void{
		if(null!=period&&""!=period){
			var a:Number = Number(period);
			taskperiod.value = a;
		}
	}
	
	protected function btn_clickHandler(event:MouseEvent):void
	{
		// TODO Auto-generated method stub
		var remoteObject:RemoteObject=new RemoteObject("taskConfigDao");
		remoteObject.endpoint = ModelLocator.END_POINT;
		remoteObject.showBusyCursor = true;
		var task:TaskModel = new TaskModel();			
		
		var nullCtr:String="";
		if(taskname.text==null || taskname.text==""){
			taskname.setFocus();
			Alert.show("任务名称 不能为空！","提示");
			return;
		}
		if(tasktype.text==null || tasktype.text==""){
			tasktype.setFocus();
			Alert.show("任务类型 不能为空！","提示");
			return;
		}
		if(performer.text==null || performer.text==""){
			performer.setFocus();
			Alert.show("启动适配器 不能为空！","提示");
			return;
		}
		if(taskperiod.value==0){
			taskperiod.setFocus();
			Alert.show("任务周期 不能为0！","提示");
			return;
		}
		if(isactivated.text==null || isactivated.text==""){
			isactivated.setFocus();
			Alert.show("任务是否有效 不能为空！","提示");
			return;
		}
		
		if(this.title == "添加"){
			task.task_name = taskname.text.toString();
			if(tasktype.selectedItem!=null){
				task.task_type = tasktype.selectedItem.@id;
			}
			var a:String = "";
			if(hour.value<10){
				a = "0"+hour.value;
			}else{
				a = hour.value.toString();
			}
			var b:String = "";
			if(minter.value<10){
				b = "0"+minter.value;
			}else{
				b = minter.value.toString();
			}
			var c:String = "";
			if(second.value<10){
				c = "0"+second.value;
			}else{
				c = second.value.toString();
			}
			task.starttime = a +":"+ b+":"+ c;
			task.task_period = taskperiod.value.toString();
			if(performer.selectedItem!=null){
				task.performer = performer.selectedItem.@id;
			}
			if(isactivated.selectedItem!=null){
				task.isactivated = isactivated.selectedItem.@id;
			}
			task.sourceid = con_sourcesid.text;
			remoteObject.addEventListener(ResultEvent.RESULT,insertHandle);
			//parentApplication.faultEventHandler(remoteObject);
			remoteObject.insertTask(task);
		}else if(this.title == "修改"){
			task.task_id = taskData.task_id;
			task.task_name = taskname.text.toString();
			task.task_type = tasktype.selectedItem.@id;
			
			var a:String = "";
			if(hour.value<10){
				a = "0"+hour.value;
			}else{
				a = hour.value.toString();
			}
			var b:String = "";
			if(minter.value<10){
				b = "0"+minter.value;
			}else{
				b = minter.value.toString();
			}
			var c:String = "";
			if(second.value<10){
				c = "0"+second.value;
			}else{
				c = second.value.toString();
			}
			task.starttime = a +":"+ b+":"+ c;
			task.task_period = taskperiod.value.toString();
			task.performer = performer.selectedItem.@id;
			task.isactivated = isactivated.selectedItem.@id;
			task.sourceid = con_sourcesid.text;
			remoteObject.addEventListener(ResultEvent.RESULT,updateHandle);
		        parentApplication.faultEventHandler(remoteObject);
			remoteObject.updateTask(task);
		}else if(this.title=="查询"){
			_search.task_name = taskname.text.toString();
			if(tasktype.selectedItem!=null){
				_search.task_type = tasktype.selectedItem.@label;
			}
			var a:String = "";
			if(hour.value<10){
				a = "0"+hour.value;
			}
			var b:String = "";
			if(minter.value<10){
				b = "0"+minter.value;
			}
			var c:String = "";
			if(second.value<10){
				c = "0"+second.value;
			}
		
			_search.starttime = a +":"+ b+":"+ c;
			if(taskperiod.value==0)
			{
				_search.task_period="";
			}
			else
			{
				_search.task_period = taskperiod.value.toString();
			}
			
			if(performer.selectedItem!=null){
				_search.performer = performer.selectedItem.@label;
			}
			if(isactivated.selectedItem!=null){
				_search.isactivated = isactivated.selectedItem.@label;
			}
			_search.sourceid = con_sourcesid.text;
			this.dispatchEvent(new Event("RefreshDataGrid"))
		}
		PopUpManager.removePopUp(this);
	}
	
	public function addlistener():void{
		if(this.title=="查询"){
			btnReset.addEventListener(MouseEvent.CLICK,reset);
		}else{
			btnReset.addEventListener(MouseEvent.CLICK,removePop);
		}
	}
	
	private function removePop(event:MouseEvent):void{
		PopUpManager.removePopUp(this);
	}

	private function reset(event:MouseEvent):void{
		this.taskname.text="";
		this.performer.selectedIndex=-1;
		this.con_sources.text="";
		this.tasktype.selectedIndex=-1;
		this.taskperiod.value=null;
		this.isactivated.selectedIndex=-1;
		this.hour.value=null;
		this.minter.value=null;
		this.second.value=null;
	}

	private function insertHandle(event:ResultEvent):void{
		var reStr:String = "";
		if(null!=event.result.toString()&&""!=event.result.toString()){
			reStr = event.result.toString();
			if(reStr=="success"){
				Alert.show("任务添加成功！","提示");
				this.dispatchEvent(new Event("RefreshDataGrid"))
			}else{
				Alert.show("任务添加失败！","提示");
			}
		}
	}
	
	private function updateHandle(event:ResultEvent):void{
		var reStr:String = "";
		if(null!=event.result.toString()&&""!=event.result.toString()){
			reStr = event.result.toString();
			if(reStr=="success"){
				Alert.show("任务更新成功！","提示");
				this.dispatchEvent(new Event("RefreshDataGrid"))
			}else{
				Alert.show("任务更新失败！","提示");
			}
		}
	}
	
	
	protected function con_sources_clickHandler(event:MouseEvent):void
	{
		
		var conSW:ConnectSourceWin = new ConnectSourceWin();
		conSW.parent_page = this;
		MyPopupManager.addPopUp(conSW, true);
	}