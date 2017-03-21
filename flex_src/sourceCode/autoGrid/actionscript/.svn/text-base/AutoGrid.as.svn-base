	import com.adobe.serialization.json.JSON;
	
	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	import common.component.ControlBar;
	import common.component.pagetoolbar;
	
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Form;
	import mx.containers.FormItem;
	import mx.containers.Grid;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.ComboBox;
	import mx.controls.DataGrid;
	import mx.controls.DateField;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.Application;
	import mx.core.ClassFactory;
	import mx.events.CloseEvent;
	import mx.events.DataGridEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	import sourceCode.autoGrid.actionscript.AutoGridEvent;
	import sourceCode.autoGrid.actionscript.ItemRenderer;
	import sourceCode.autoGrid.model.AutoGridModel;
	import sourceCode.autoGrid.model.ResultModel;
	import sourceCode.autoGrid.view.ShowProperty;
	import sourceCode.autoGrid.view.ShowSearchView;
	import sourceCode.systemManagement.model.PermissionControlModel;
	import sourceCode.tableResurces.views.DataImportFirstStep;
	
	import twaver.DemoUtils;
	
	
	public var pageIndex:int=0;
	public var pageSize:int=50;
	[Bindable]public var tablename:String;//表名
	[Bindable]public var isShowSerial:Boolean = true;//是否显示序号列
	[Bindable]public var isAddControlBar:Boolean = true;//是否显示工具栏
	[Bindable]public var isShowImportButton:Boolean = true;//是否显示导入按钮
	[Bindable]public var title:String;//标题
	[Bindable]public var key:String;//主键
	[Bindable]public var importType:String;//导入模板标识
	[Bindable]public var useDeleteFunction:Boolean = true;//是否使用默认的删除
	[Bindable]public var useImportFunction:Boolean = true;//是否使用默认的导入
    [Bindable]public var modelName:String;
    [Bindable]public var shortIconSource:String;  //快捷方式图片名
    [Bindable]public var isShowContexMenu:Boolean = true;
	[Bindable]public var isCheckTree:Boolean = false;
    [Bindable]public var showAddShurtCutButton:Boolean = true;
    [Bindable]public var showDelShurtCutButton:Boolean = true;
	public  var auto_grid:DataGrid;
	private var auto_control:ControlBar;
	private var auto_pagebar:pagetoolbar;
	private var serialValue:Class = ItemRenderer;
	private var isEdit:Boolean = false;
	private var isAdd:Boolean = false;
	private var isDelete:Boolean = false;
	public var isSearch:Boolean = true;
	private var isExport:Boolean = false;
	private var isImport:Boolean = false;
	private var exportModel:AutoGridModel;
    private var searchModel:AutoGridModel;
	private var dir:Boolean = true; //排序方式   true 升序 ，false 降序
	private var sortName:String =""; //当前排序的列名
	private function preinitialize():void{
		if(ModelLocator.permissionList!=null&&ModelLocator.permissionList.length>0){
			isAdd = false;
			isEdit = false;
			isDelete = false;
//			isSearch = true;
			isImport = false;
			isExport = false;
			for(var i:int=0;i<ModelLocator.permissionList.length;i++){
				var model:PermissionControlModel = ModelLocator.permissionList[i];
				if(model.oper_name!=null&&model.oper_name=="添加操作"){
					isAdd = true;
				}
				if(model.oper_name!=null&&model.oper_name=="修改操作"){
					isEdit = true;
				}
				if(model.oper_name!=null&&model.oper_name=="删除操作"){
					isDelete = true;
				}
				if(model.oper_name!=null&&model.oper_name=="导出操作"){
					isExport = true;
				}
				if(model.oper_name!=null&&model.oper_name=="导入操作"){
					isImport = true;
				}
			}
		}
	}
	private function init():void
	{
		
		var showRT:RemoteObject = new RemoteObject("autoGrid");
		showRT.endpoint = ModelLocator.END_POINT;
		showRT.showBusyCursor = true;
		showRT.selectGridData(tablename);//根据系统编码查询对应信息(所属系统)
		showRT.addEventListener(ResultEvent.RESULT,show);
		
	}
	private function show(event:ResultEvent):void
	{
		var control:ControlBar = new ControlBar();
		control.showAddShurtCutButton = showAddShurtCutButton;
		control.showDelShurtCutButton = showDelShurtCutButton;
		control.modelName = modelName;
		control.imgName = shortIconSource;
		control.id = "controlBar"
		control.showAddButton = isAdd;
		control.showEditButton = isEdit;
		control.showDelButton = isDelete;
		control.showSearchButton = isSearch;
		control.showExportExcelButton = isExport;
		if(isShowImportButton)control.showImportButton = isImport;
		control.addEventListener("controlAdd",add);
		control.addEventListener("controlEdit",edit);
		control.addEventListener("controlDel",deleteData);
		control.addEventListener("controlExportExcel",export);
		control.addEventListener("controlImport",importExcel);
		control.addEventListener("controlSearch",search);
		control.percentWidth = 100;
		control.height = 38;
		
		var grid:DataGrid = new DataGrid();
		grid.id = "grid";
		grid.percentWidth = 100;
		grid.percentHeight = 100;
		grid.editable = false;
		grid.horizontalScrollPolicy="auto";
		var array:Array = null;
		if(event.result!=null&&event.result.toString()!=""){
			var obj:Array = JSON.decode(event.result.toString()) as Array;
			if(obj!=null){
				array = new Array();
				var count:int = obj.length;
				if(isShowSerial){
					var data:DataGridColumn = new DataGridColumn();
					data.headerText = "序号";
					data.width = 50;
					ItemRenderer.size = 1;
					ItemRenderer.pagesize = 50;
					data.itemRenderer = new ClassFactory(ItemRenderer);
					array.push(data);
				}
				for(var i:int=0;i<count;i++){
					var data:DataGridColumn = new DataGridColumn();
					data.headerText = obj[i].title;
					data.dataField = obj[i].id;
					data.width=obj[i].width;
					if("Y"!=obj[i].show){
						data.visible = false;
					}
					if("Y"==obj[i].key){
						key = obj[i].id;
					}
					array.push(data);
				}
				
			}
			
		}
		var pagebar:pagetoolbar = new pagetoolbar();
		pagebar.percentWidth = 100;
		pagebar.dataGrid=grid;
		pagebar.pagingFunction=pagingFunction;
		pagebar.pageSize=pageSize;
		grid.columns = array;
		if(isAddControlBar){
			gridbox.addChild(control);
		}
		gridbox.addChild(grid);
		gridbox.addChild(pagebar);
		var model:AutoGridModel = new AutoGridModel();
		model.start = 0;
		model.end = pageSize;
		model.tablename = tablename;
		setGridValue(model);
		auto_grid = grid;
		grid.addEventListener(DataGridEvent.HEADER_RELEASE,headerReleaseHandler)
		grid.doubleClickEnabled = true;	
		grid.addEventListener(MouseEvent.DOUBLE_CLICK,function (event:MouseEvent):void{doubleClickHanlder();});	
		auto_control = control;
		auto_pagebar = pagebar;
		if(isShowContexMenu){
			addContextMenu(grid);
		}
	}
    private function doubleClickHanlder():void{
		if(auto_grid.selectedItem!=null)
		edit(null);
		else
			Alert.show("请选择一条数据!","提示");
	}
    private function addContextMenu(grid:DataGrid):void{
		grid.contextMenu = new ContextMenu();
		grid.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,function(e:ContextMenuEvent):void{
			var addItem:ContextMenuItem = new ContextMenuItem("添 加",true);
			addItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(event:ContextMenuEvent):void{
				add(null);
			});
			var searchItem:ContextMenuItem = new ContextMenuItem("查 询", true);
			searchItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(event:ContextMenuEvent):void{
				search(null);
			});
			addItem.visible = isAdd;
			searchItem.visible = isSearch;
			if (grid.selectedItems.length> 0) {
				grid.selectedItem=grid.selectedItems[0];
			}
			if(grid.selectedItems.length==0){//选中元素个数
				grid.contextMenu.hideBuiltInItems();
				grid.contextMenu.customItems = [addItem,searchItem];
			}
			else{
				
				var updateItem:ContextMenuItem = new ContextMenuItem("修 改",true);
				updateItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(event:ContextMenuEvent):void{
				    edit(null);
				});
				var deleteItem:ContextMenuItem = new ContextMenuItem("删 除");
				deleteItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(event:ContextMenuEvent):void{
				    deleteData(null);
				});
				updateItem.visible = isEdit;
				deleteItem.visible = isDelete;
				
				grid.contextMenu.hideBuiltInItems();
				grid.contextMenu.customItems = [addItem,searchItem,updateItem,deleteItem];
			}
		}); 
		
	}
	public function setGridValue(model:AutoGridModel):void{
		var rt:RemoteObject = new RemoteObject("autoGrid");
		rt.endpoint = ModelLocator.END_POINT;
		rt.showBusyCursor = true;
		rt.setGridValue(model);
		rt.addEventListener(ResultEvent.RESULT,setValue);
		
	}
    private function setValue(event:ResultEvent):void{
		if(event.result!=null){
			var result:ResultModel=event.result as ResultModel;
			auto_pagebar.orgData=result.orderList;
			auto_pagebar.totalRecord=result.totalCount;
			auto_pagebar.dataBind(true);
		}
	}
	private function pagingFunction(pageIndex:int,pageSize:int):void{
		ItemRenderer.pagesize = pageSize;
		ItemRenderer.size = pageIndex+1;
		this.pageSize=pageSize;
		this.pageIndex=pageIndex;
		var model:AutoGridModel = new AutoGridModel();
		model.start = pageIndex*pageSize;
		model.end = pageIndex*pageSize+pageSize;
		model.tablename = tablename;
		if(searchModel!=null){
		  model.json = searchModel.json;
		}
		setGridValue(model);
	}
	private function add(event:Event):void{
		var property:ShowProperty = new ShowProperty();
		property.title = "添加";
		property.paraValue = null;
		property.tablename = tablename;
		property.key = key;
		property.isCheckTree = isCheckTree;
		PopUpManager.addPopUp(property, this, true);
		PopUpManager.centerPopUp(property);
		property.addEventListener("savePropertyComplete",function (event:Event):void{
			PopUpManager.removePopUp(property);
			var model:AutoGridModel = new AutoGridModel();
			model.start = 0;
			model.end = 50;
			model.tablename = tablename;
			model.sortColumn = key;
			model.sortOrder ="desc";
			dir=true;
			setGridValue(model);
		});	
	}
	private function edit(event:Event):void{
		if(auto_grid.selectedItem != null){
			var property:ShowProperty = new ShowProperty();
			property.title = "修改";
			property.paraValue = auto_grid.selectedItem[key];
			property.tablename = tablename;
			property.key = key;
			property.isCheckTree = isCheckTree;
			PopUpManager.addPopUp(property, this, true);
			PopUpManager.centerPopUp(property);		
			property.addEventListener("savePropertyComplete",function (event:Event):void{
				PopUpManager.removePopUp(property);
				var model:AutoGridModel = new AutoGridModel();
				model.start = pageIndex*pageSize;
				model.end = pageIndex*pageSize+pageSize;
				if(searchModel!=null)
				   model.json = searchModel.json;
				model.tablename = tablename;
				setGridValue(model);
			});	
		}else{
			Alert.show("请先选中一条记录！","提示");
		}
	}
	private function deleteData(event:Event):void{
		if(auto_grid.selectedItem != null){
			if(useDeleteFunction){
				Alert.show("确定要删除该条记录吗?","请您确认！",Alert.YES|Alert.NO,this,function(e:CloseEvent):void{
					if(e.detail == Alert.YES){
						var rtobj:RemoteObject=new RemoteObject("autoGrid");
						Application.application.faultEventHandler(rtobj);
						rtobj.endpoint=ModelLocator.END_POINT;
						rtobj.showBusyCursor=true;
						var keyValue:String = auto_grid.selectedItem[key];
						rtobj.deleteData(tablename,key,keyValue);
						rtobj.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
							if(event.result!=null&&event.result.toString()=="true"){
								Alert.show("删除成功！","提示");
								var model:AutoGridModel = new AutoGridModel();
								model.start = 0;
								model.end = 50;
								model.tablename = tablename;
								setGridValue(model);
							}else{
								Alert.show("删除失败！","提示");
							}	
						});
					}
				},null,Alert.NO);	
			}else{
				dispatchEvent(new AutoGridEvent('deleteAutoGridEvent',auto_grid.selectedItem));
			}
		}
		else{
			Alert.show("请先选中一条记录！","提示");
		}
	}
	
	private function search(event:Event):void{
		var property:ShowSearchView = new ShowSearchView();
		property.title = "查询";
		property.paraValue = null;
		property.tablename = tablename;
		property.key = key;
		property.addEventListener("searchEvent",searchResult);
		PopUpManager.addPopUp(property, this, true);
		PopUpManager.centerPopUp(property);	
	}
	private function export(event:Event):void{
		var array:ArrayCollection = auto_grid.dataProvider as ArrayCollection;
		if(array!=null&&array.length>0){
			var remote:RemoteObject = new RemoteObject("autoGrid");
			remote.endpoint = ModelLocator.END_POINT;
			remote.showBusyCursor = true;
			if(exportModel!=null){
				remote.exportExcel(exportModel);
			}else{
				var model:AutoGridModel = new AutoGridModel();
				model.start = 0;
				model.end = 50;
				model.tablename = tablename;
				remote.exportExcel(model);
			}
			remote.addEventListener(ResultEvent.RESULT,exportResultHandler);
			Application.application.faultEventHandler(remote);
		}else{
			Alert.show("没有可导出的数据,请您更换查询条件或者增加数据！","提示");
		}
	}
	private function exportResultHandler(event:ResultEvent):void{
		var url:String = ModelLocator.getURL();
		var path:String = url+event.result.toString();
		var request:URLRequest = new URLRequest(encodeURI(path)); 
		navigateToURL(request,"_blank");
	}
	private function importExcel(event:Event):void{
		if(useImportFunction){
			var importData:DataImportFirstStep = new DataImportFirstStep();
			MyPopupManager.addPopUp(importData,true);
			importData.setTemplateType(importType);
			importData.addEventListener("importCompleteEvent",importCompleteEventHanlder);
		}else{
			dispatchEvent(new Event('importAutoGridEvent'));
		}
	}
    private function importCompleteEventHanlder(event:Event):void{
		var model:AutoGridModel = new AutoGridModel();
		model.start = 0;
		model.end = 50;
		model.tablename = tablename;
		setGridValue(model);
	}
	private function searchResult(event:AutoGridEvent):void{
		var json:String = event.obj as String;
		var model:AutoGridModel = new AutoGridModel();
		model.start = 0;
		model.end = 50;
		model.tablename = tablename;
		model.json = json;
		exportModel = model;
		searchModel = model;
		auto_pagebar.navigateButtonClick("firstPage");
	}
	private function headerReleaseHandler(event:DataGridEvent):void{
		var dg:DataGrid = DataGrid(event.currentTarget);
		var dgm:DataGridColumn = dg.columns[event.columnIndex];
		var columnName:String=dgm.dataField;
		event.stopImmediatePropagation(); //阻止其自身的排序
		var model:AutoGridModel = new AutoGridModel();
		if(exportModel!=null){
			model.json = exportModel.json;
		}
		model.start = 0;
		model.end = 50;
		model.tablename = tablename;
		model.sortColumn = columnName;
		if(sortName == columnName){
			if(dir){
				model.sortOrder ="asc";
				dir=false;
			}else{
				model.sortOrder ="desc";
				dir=true;
			}
		}else{
			sortName=columnName;
			dir = false;
			model.sortOrder ="asc";
		}
		setGridValue(model);
	}