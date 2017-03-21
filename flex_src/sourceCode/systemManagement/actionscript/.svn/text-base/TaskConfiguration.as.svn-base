	// ActionScript file
	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.ItemClickEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	import mx.utils.ObjectProxy;
	
	import org.flexunit.runner.Result;
	
	import sourceCode.systemManagement.model.TaskModel;
	import sourceCode.systemManagement.model.TaskResultModel;
	import sourceCode.systemManagement.views.popup.TaskTtitle;
	
	import twaver.DemoUtils;
	import twaver.SequenceItemRenderer;
	private var pageIndex:int=0;
	private var pageSize:int=50;
	private var datanumbers:int;
	private var indexRenderer:Class = SequenceItemRenderer;
	private var taskXML:ArrayCollection = new ArrayCollection;
	private var lastRollOverIndex:int;
	private var task:TaskModel;
	private var tasktsearch:TaskTtitle;
	private var tasksearch:Boolean=false;
	[Bindable]			
	private var cm:ContextMenu;
	
	public function init():void
	{
		task=new TaskModel();
		tasktsearch=new TaskTtitle();
		tasktsearch.addEventListener("RefreshDataGrid",getTasks);
		var item1:ContextMenuItem = new ContextMenuItem("添 加");
		item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
		var item2:ContextMenuItem = new ContextMenuItem("修 改");
		item2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
		var item3:ContextMenuItem = new ContextMenuItem("删 除");
		item3.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
		var item4:ContextMenuItem = new ContextMenuItem("查 询");
		item4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
		cm=new ContextMenu();
		cm.hideBuiltInItems();
		cm.customItems = [item1,item2,item3];
		cm.addEventListener(ContextMenuEvent.MENU_SELECT,contextMenu_menuSelect);
		
		serverPagingBar.dataGrid=dg;
		serverPagingBar.pagingFunction=pagingFunction;
		serverPagingBar.addEventListener("returnALL",showAllDataHandler);
		getTaskInfos("0",pageSize.toString());
	}
	
	private function contextMenu_menuSelect(evt:ContextMenuEvent):void {	
		dg.selectedIndex = lastRollOverIndex;
	}
	
	private function itemSelectHandler(e:ContextMenuEvent):void{
		switch(e.target.caption){
			case "添 加":
				addTask(null);
				break;
			case "修 改":
				editTask(null);
				break;
			case "删 除":
				delTask(null);
				break;
			case "查 询":
				searchTask(null);
				break;
			default:
				break;
		}
	}
	
	private function showAllDataHandler(event:Event):void{
		getTaskInfos("0",serverPagingBar.totalRecord.toString());
	}
	
	private function getTaskInfos(start:String,end:String):void{
		var to_task:RemoteObject=new RemoteObject("taskConfigDao");
		if(tasktsearch._search!=null){
			task=tasktsearch._search;
		}
		task.start = start;
		task.end = end ;
		to_task.addEventListener(ResultEvent.RESULT,resultTaskHandler);
		parentApplication.faultEventHandler(to_task);
		to_task.endpoint = ModelLocator.END_POINT;
		to_task.showBusyCursor = true;
		to_task.getTaskInfos(task); 
	}
	
	public function resultTaskHandler(event:ResultEvent):void{
		var result:TaskResultModel=event.result as TaskResultModel;
		this.datanumbers = result.totalCount;
		onResult(result);
	}
	
	private function pagingFunction(pageIndex:int,pageSize:int):void{
		this.pageSize=pageSize;
		getTaskInfos((pageIndex*pageSize).toString(),(pageIndex*pageSize+pageSize).toString());
	}
	
	public function onResult(result:TaskResultModel):void 
	{	
		serverPagingBar.orgData=result.taskList;
		serverPagingBar.totalRecord=result.totalCount;
		serverPagingBar.dataBind(true);					
	}
	
	private function RefreshStation(event:Event):void{
		getTaskInfos("0",pageSize.toString());
	}
	
	
	/**
	 * 
	 * 添加快捷方式
	 * 
	 * */
	protected function toolbar_toolEventAddShortcutHandler():void
	{
		parentApplication.addShorcut('任务配置','task');
	}
	
	/**
	 * 
	 * 删除快捷方式
	 * 
	 * */
	protected function toolbar_toolEventDelShortcutHandler():void
	{
		parentApplication.delShortcut('任务配置');
	}
	
	private function addTask(event:Event):void{
		var taskt:TaskTtitle = new TaskTtitle();
		taskt.title="添加";
		taskt.init();
		MyPopupManager.addPopUp(taskt);
		taskt.addlistener();
		taskt.addEventListener("RefreshDataGrid",getTasks);
	}
	private function editTask(event:Event):void{
		if(dg.selectedItem!= null){
			var taskt:TaskTtitle = new TaskTtitle();
			taskt.init();
			taskt.title="修改";
			taskt.taskData = dg.selectedItem;
			MyPopupManager.addPopUp(taskt);
			taskt._tasktype=dg.selectedItem.task_type.toString();
			taskt._isactivated=dg.selectedItem.isactivated.toString();
			taskt._performer=dg.selectedItem.performer.toString();
			if(dg.selectedItem.sourceid != null)
				taskt._sourceid = dg.selectedItem.sourceid.toString();
			if(dg.selectedItem.sourcename != null)
				taskt._sourcename = dg.selectedItem.sourcename.toString();
			taskt.addlistener();
			if(null!=dg.selectedItem.starttime&&""!=dg.selectedItem.starttime){
				taskt._starttime = dg.selectedItem.starttime.toString();
			}
			if(null!=dg.selectedItem.task_period&&""!=dg.selectedItem.task_period){
				taskt._task_period = dg.selectedItem.task_period.toString();
			}
			taskt.addEventListener("RefreshDataGrid",getTasks);
		}else{
			Alert.show("请先选中一个任务！","提示");
		}
	}
	private function getTasks(event:Event):void{
		getTaskInfos("0",pageSize.toString());
	}
	
	private function searchTask(event:Event):void{
		tasktsearch.title="查询";
		MyPopupManager.addPopUp(tasktsearch);
		if(tasksearch==false){
			tasktsearch.init();
			tasksearch=true;
			tasktsearch.btnReset.label="重置";
			tasktsearch.addlistener();
		}
	}
	private function delTask(event:Event):void{
		var taskid:String = "";
		if(dg.selectedItem!= null){
			taskid = dg.selectedItem.task_id.toString();
			Alert.yesLabel = "是";
			Alert.noLabel = "否";
			Alert.show("是否要删除，请确认！","提示",3,this,function deleletJudged(event:CloseEvent):void{
				if(event.detail == Alert.YES){
					var totask:RemoteObject=new RemoteObject("taskConfigDao");
					totask.addEventListener(ResultEvent.RESULT,deleteHandle);
					//parentApplication.faultEventHandler(totask);
					totask.endpoint = ModelLocator.END_POINT;
					totask.showBusyCursor = true;
					totask.deleteTask(taskid);
				}
			});
			Alert.yesLabel = "Yes";
			Alert.noLabel = "No";
			//					Alert.show(taskid);
		}else{
			Alert.show("请先选中一个任务！","提示");
		}
	}
	
	private function deleteHandle(event:ResultEvent):void{
		var reStr:String = "";
		if(null!=event.result.toString()&&""!=event.result.toString()){
			reStr = event.result.toString();
			if(reStr=="success"){
				Alert.show("任务删除成功！","提示");
				getTaskInfos("0",pageSize.toString());
				this.init();
			}else{
				Alert.show("任务删除失败！","提示");
			}
		}
	}