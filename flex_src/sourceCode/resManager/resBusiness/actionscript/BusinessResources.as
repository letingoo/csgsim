// ActionScript file

import common.actionscript.ModelLocator;
import common.actionscript.MyPopupManager;
import common.actionscript.Registry;

import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import mx.controls.Alert;
import mx.controls.DataGrid;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.Application;
import mx.events.CloseEvent;
import mx.events.DataGridEvent;
import mx.events.FlexEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

import sourceCode.autoGrid.view.ShowProperty;
import sourceCode.resManager.resBusiness.events.BusinessRessEvent;
import sourceCode.resManager.resBusiness.model.BusinessRessModel;
import sourceCode.resManager.resBusiness.model.ResultModel;
import sourceCode.resManager.resBusiness.titles.SearchCircuitTitle;
import sourceCode.resManager.resBusiness.titles.TitleRess;
import sourceCode.systemManagement.model.PermissionControlModel;
import sourceCode.tableResurces.Events.ToopEvent;
import sourceCode.tableResurces.views.DataImportFirstStep;
import sourceCode.tableResurces.views.FileExportFirstStep;

import twaver.DemoUtils;

public var e2Oracle:DataImportFirstStep = new DataImportFirstStep();
private var pageIndex:int=0;
private var pageSize:int=50;
private var datanumbers:int;
private var businessModel:BusinessRessModel = new BusinessRessModel();
private var dir:Boolean = true; //排序方式   true 升序 ，false 降序
private var sortName:String =""; //当前排序的列名

//权限控制
private var isAdd:Boolean = false;
private var isEdit:Boolean = false;
private var isDelete:Boolean = false;
private var isImport:Boolean = false;
private var isExport:Boolean = false;

private function preinitialize():void{
	if(ModelLocator.permissionList != null && ModelLocator.permissionList.length > 0){
		var model:PermissionControlModel;
		for(var i:int=0,max:int=ModelLocator.permissionList.length; i<max; i++){
			model = ModelLocator.permissionList[i];
			if(model.oper_name !=null && model.oper_name == "添加操作"){
				isAdd = true;
			}
			if(model.oper_name != null && model.oper_name == "修改操作"){
				isEdit = true;
			}
			if(model.oper_name != null && model.oper_name == "删除操作"){
				isDelete = true;
			}
			if(model.oper_name != null && model.oper_name == "导出操作"){
				isExport = true;
			}
			if(model.oper_name != null && model.oper_name == "导入操作"){
				isImport = true;
			}
		}
	}
} 

protected function intApp():void
{
	serverPagingBar_Ress.dataGrid = RessGrid;
	serverPagingBar_Ress.pagingFunction=pagingFunction;
	serverPagingBar_Ress.addEventListener("returnALL",showAllDataHandler);
	getBusinessRess("0",pageSize.toString());
	
	var contextMenu:ContextMenu=new ContextMenu();
	RessGrid.contextMenu=contextMenu;
	RessGrid.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,function(e:ContextMenuEvent):void{
		
		if (RessGrid.selectedItems.length> 0) {
			RessGrid.selectedItem=RessGrid.selectedItems[0];
		}
		//定制右键菜单
		var flexVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLEX_SDK_VERSION, false, false);
		var playerVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLASH_PLAYER_VERSION, false, false);
		
		if(RessGrid.selectedItems.length==0){//选中元素个数
			//						equipmentDg.contextMenu.customItems = [flexVersion, playerVersion];
			var item1:ContextMenuItem = new ContextMenuItem("添 加", true);
			item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
			item1.visible = isAdd;
			
			var item4:ContextMenuItem = new ContextMenuItem("查 询");
			item4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
			RessGrid.contextMenu.hideBuiltInItems();
			RessGrid.contextMenu.customItems = [item1,item4];
		}
		else{
			Alert.show("--");
			var item2:ContextMenuItem = new ContextMenuItem("修 改");
			item2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
			item2.visible = isEdit; 
			
			var item3:ContextMenuItem = new ContextMenuItem("删 除");
			item3.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
			item3.visible = isDelete
			
			var item5:ContextMenuItem = new ContextMenuItem("查看承载电路路由", true);
			item5.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, controlBar_CircuitRouteHandler);
			item5.visible=true;
			
			RessGrid.contextMenu.hideBuiltInItems();
			RessGrid.contextMenu.customItems = [item2,item3,item5];
		}
	})
}
private function getBusinessRess(start:String,end:String):void{
	var obj:RemoteObject = new RemoteObject("resBusinessDwr");
	Application.application.faultEventHandler(obj);
	businessModel.start = start;
	businessModel.end = end ;
	obj.endpoint = ModelLocator.END_POINT;
	obj.showBusyCursor = true;
	obj.getRess(businessModel);
	obj.addEventListener(ResultEvent.RESULT,setData);
}

/**
 *查看电路路由 
 * 
 **/
private function controlBar_CircuitRouteHandler(event:Event):void{
	if(RessGrid.selectedItems.length>0){
		Registry.register("para_circuitcode", RessGrid.selectedItem.circuitcode);
		Registry.register("para_circuitype", RessGrid.selectedItem.business_type);
		Application.application.openModel("方式信息", false);
	}
}

private function setData(e:ResultEvent):void{
	var result:ResultModel = e.result as ResultModel;
	if(result!=null){
		this.datanumbers = result.totalCount;
		onResult(result);
	}
}
public function onResult(result:ResultModel):void 
{	
	serverPagingBar_Ress.orgData=result.orderList;
	serverPagingBar_Ress.totalRecord=result.totalCount;
	serverPagingBar_Ress.dataBind(true);					
}
private function showAllDataHandler(event:Event):void{
	getBusinessRess("0",serverPagingBar_Ress.totalRecord.toString());
}
private function pagingFunction(pageIndex:int,pageSize:int):void{
	this.pageSize=pageSize;
	this.pageIndex = pageIndex;
	getBusinessRess((pageIndex*pageSize).toString(),(pageIndex*pageSize+pageSize).toString());
}

/**
 * 添加
 * */
protected function toolbar1_toolEventAddHandler(event:Event):void//添加
{
	var property:ShowProperty = new ShowProperty();
	property.title = "添加";
	property.paraValue = null;
	property.tablename = "VIEW_BUSINESS_PROPERTY";
	property.key = "BUSINESS_ID";
	PopUpManager.addPopUp(property, this, true);
	PopUpManager.centerPopUp(property);		
	property.addEventListener("savePropertyComplete",function (event:Event):void{
		PopUpManager.removePopUp(property);
		
		refreshHandle(event);});
	property.addEventListener("initFinished",function (event:Event):void{
		//选择所属电路  自动填充A端站点和Z端站点
		(property.getElementById("USERNAME",property.propertyList) as mx.controls.TextInput).addEventListener(MouseEvent.CLICK,function(event:Object):void{
			var circuitsearch:SearchCircuitTitle=new SearchCircuitTitle();
			circuitsearch.page_parent=property;
			PopUpManager.addPopUp(circuitsearch,property,true);
			PopUpManager.centerPopUp(circuitsearch);
			circuitsearch.myCallBack=function(obj:Object){
				var clabel:String=obj.label;//从子页面传过来的电路的label
				var ccode:String = obj.code;//从子页面传过来的电路的id
				(property.getElementById("USERNAME",property.propertyList) as mx.controls.TextInput).text=clabel;
				(property.getElementById("USERNAME",property.propertyList) as mx.controls.TextInput).toolTip="点击弹出选择树";
				(property.getElementById("CIRCUITCODE",property.propertyList) as mx.controls.TextInput).data=ccode;
				var rt:RemoteObject=new RemoteObject("resBusinessDwr");
				rt.endpoint=ModelLocator.END_POINT;
				rt.showBusyCursor=true;
				rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent){
					var strTmp:String = (String)(event.result);
					var strStationA:String = strTmp.split("splite")[0];
					var strStationZ:String = strTmp.split("splite")[1];
					
					var StationAList:XMLList= new XMLList(strStationA);
					var strStationZList:XMLList= new XMLList(strStationZ);
					(property.getElementById("END_ID_A",property.propertyList) as mx.controls.ComboBox).dropdown.dataProvider=StationAList;
					(property.getElementById("END_ID_A",property.propertyList) as mx.controls.ComboBox).dataProvider=StationAList;
					(property.getElementById("END_ID_A",property.propertyList) as mx.controls.ComboBox).labelField="@label";
//					(property.getElementById("END_ID_A",property.propertyList) as mx.controls.ComboBox).text="";
					(property.getElementById("END_ID_A",property.propertyList) as mx.controls.ComboBox).selectedIndex=0;
					
					(property.getElementById("END_ID_Z",property.propertyList) as mx.controls.ComboBox).dropdown.dataProvider=strStationZList;
					(property.getElementById("END_ID_Z",property.propertyList) as mx.controls.ComboBox).dataProvider=strStationZList;
					(property.getElementById("END_ID_Z",property.propertyList) as mx.controls.ComboBox).labelField="@label";
//					(property.getElementById("END_ID_Z",property.propertyList) as mx.controls.ComboBox).text="";
					(property.getElementById("END_ID_Z",property.propertyList) as mx.controls.ComboBox).selectedIndex=0;
					
				});
				rt.getStationAAndStationZByCircuitcode(ccode);
			}
		});
	});
	
}
private function refreshHandle(event:Event):void{
	serverPagingBar_Ress.navigateButtonClick("firstPage");
}
public function itemSelectHandler(e:ContextMenuEvent):void{
	switch(e.target.caption){
		case "添 加":
			var property:ShowProperty = new ShowProperty();
			property.title = "添加";
			property.paraValue = null;
			property.tablename = "VIEW_BUSINESS_PROPERTY";
			property.key = "BUSINESS_ID";
			PopUpManager.addPopUp(property, this, true);
			PopUpManager.centerPopUp(property);		
			property.addEventListener("savePropertyComplete",function (event:Event):void{
				PopUpManager.removePopUp(property);
				
				refreshHandle(event);});
			property.addEventListener("initFinished",function (event:Event):void{
				//选择所属电路  自动填充A端站点和Z端站点
				(property.getElementById("USERNAME",property.propertyList) as mx.controls.TextInput).addEventListener(MouseEvent.CLICK,function(event:Object):void{
					var circuitsearch:SearchCircuitTitle=new SearchCircuitTitle();
					circuitsearch.page_parent=property;
					PopUpManager.addPopUp(circuitsearch,property,true);
					PopUpManager.centerPopUp(circuitsearch);
					circuitsearch.myCallBack=function(obj:Object){
						var clabel:String=obj.label;//从子页面传过来的电路的label
						var ccode:String = obj.code;//从子页面传过来的电路的id
						(property.getElementById("USERNAME",property.propertyList) as mx.controls.TextInput).text=clabel;
						(property.getElementById("USERNAME",property.propertyList) as mx.controls.TextInput).toolTip="点击弹出选择树";
						(property.getElementById("CIRCUITCODE",property.propertyList) as mx.controls.TextInput).data=ccode;
						var rt:RemoteObject=new RemoteObject("resBusinessDwr");
						rt.endpoint=ModelLocator.END_POINT;
						rt.showBusyCursor=true;
						rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent){
							var strTmp:String = (String)(event.result);
							var strStationA:String = strTmp.split("splite")[0];
							var strStationZ:String = strTmp.split("splite")[1];
							
							var StationAList:XMLList= new XMLList(strStationA);
							var strStationZList:XMLList= new XMLList(strStationZ);
							(property.getElementById("END_ID_A",property.propertyList) as mx.controls.ComboBox).dropdown.dataProvider=StationAList;
							(property.getElementById("END_ID_A",property.propertyList) as mx.controls.ComboBox).dataProvider=StationAList;
							(property.getElementById("END_ID_A",property.propertyList) as mx.controls.ComboBox).labelField="@label";
							//					(property.getElementById("END_ID_A",property.propertyList) as mx.controls.ComboBox).text="";
							(property.getElementById("END_ID_A",property.propertyList) as mx.controls.ComboBox).selectedIndex=0;
							
							(property.getElementById("END_ID_Z",property.propertyList) as mx.controls.ComboBox).dropdown.dataProvider=strStationZList;
							(property.getElementById("END_ID_Z",property.propertyList) as mx.controls.ComboBox).dataProvider=strStationZList;
							(property.getElementById("END_ID_Z",property.propertyList) as mx.controls.ComboBox).labelField="@label";
							//					(property.getElementById("END_ID_Z",property.propertyList) as mx.controls.ComboBox).text="";
							(property.getElementById("END_ID_Z",property.propertyList) as mx.controls.ComboBox).selectedIndex=0;
							
						});
						rt.getStationAAndStationZByCircuitcode(ccode);
					}
				});
			});
			break;
		case "修 改":
			if(RessGrid.selectedItems.length>0){
				
				var property:ShowProperty = new ShowProperty();
				property.title = "修改";
				property.paraValue = RessGrid.selectedItem.equipcode;
				property.tablename = "VIEW_BUSINESS_PROPERTY";
				property.key = "BUSINESS_ID";
				PopUpManager.addPopUp(property, this, true);
				PopUpManager.centerPopUp(property);		
				property.addEventListener("savePropertyComplete",function (event:Event):void{
					PopUpManager.removePopUp(property);
					
					refreshHandle(event);});
				
				property.addEventListener("initFinished",function (event:Event):void{
					//选择所属电路 自动填充A端站点和Z端站点
					(property.getElementById("USERNAME",property.propertyList) as mx.controls.TextInput).text="";
					(property.getElementById("USERNAME",property.propertyList) as mx.controls.TextInput).addEventListener(MouseEvent.CLICK,function(event:Object):void{
						var circuitsearch:SearchCircuitTitle=new SearchCircuitTitle();
						circuitsearch.page_parent=property;
						PopUpManager.addPopUp(circuitsearch,property,true);
						PopUpManager.centerPopUp(circuitsearch);
						circuitsearch.myCallBack=function(obj:Object){
							var clabel:String=obj.label;//从子页面传过来的电路的label
							var ccode:String = obj.code;//从子页面传过来的电路的id
							(property.getElementById("USERNAME",property.propertyList) as mx.controls.TextInput).text=clabel;
							(property.getElementById("USERNAME",property.propertyList) as mx.controls.TextInput).toolTip="点击弹出选择树";
							(property.getElementById("CIRCUITCODE",property.propertyList) as mx.controls.TextInput).data=ccode;
							var rt:RemoteObject=new RemoteObject("resBusinessDwr");
							rt.endpoint=ModelLocator.END_POINT;
							rt.showBusyCursor=true;
							rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent){
								var strTmp:String = (String)(event.result);
								var strStationA:String = strTmp.split("splite")[0];
								var strStationZ:String = strTmp.split("splite")[1];
								
								var StationAList:XMLList= new XMLList(strStationA);
								var strStationZList:XMLList= new XMLList(strStationZ);
								(property.getElementById("END_ID_A",property.propertyList) as mx.controls.ComboBox).dropdown.dataProvider=StationAList;
								(property.getElementById("END_ID_A",property.propertyList) as mx.controls.ComboBox).dataProvider=StationAList;
								(property.getElementById("END_ID_A",property.propertyList) as mx.controls.ComboBox).labelField="@label";
								//					(property.getElementById("END_ID_A",property.propertyList) as mx.controls.ComboBox).text="";
								(property.getElementById("END_ID_A",property.propertyList) as mx.controls.ComboBox).selectedIndex=0;
								
								(property.getElementById("END_ID_Z",property.propertyList) as mx.controls.ComboBox).dropdown.dataProvider=strStationZList;
								(property.getElementById("END_ID_Z",property.propertyList) as mx.controls.ComboBox).dataProvider=strStationZList;
								(property.getElementById("END_ID_Z",property.propertyList) as mx.controls.ComboBox).labelField="@label";
								//					(property.getElementById("END_ID_Z",property.propertyList) as mx.controls.ComboBox).text="";
								(property.getElementById("END_ID_Z",property.propertyList) as mx.controls.ComboBox).selectedIndex=0;
								
							});
							rt.getStationAAndStationZByCircuitcode(ccode);
						}
					});
				});
				
			}else{
				Alert.show("请先选中一条记录！","提示");
			}
			break;
		case "删 除":
			if(RessGrid.selectedItems.length>0){
				Alert.show("确定要删除这条记录吗？","请您确定",Alert.YES|Alert.NO,this,closeHandler,null,Alert.NO);	
			}else{
				Alert.show("请先选中一条记录！","提示");
			}
			break;
		case "查 询":
			var br:TitleRess = new TitleRess();
			br.title = "查询";
			br.currentState='search';
			PopUpManager.addPopUp(br,this,true);
			PopUpManager.centerPopUp(br);
			br.addEventListener("RessSearchEvent",searchRess);
			break;
		default:
			break;
		
	}
}

/**
 * 删除
 * */
protected function toolbar1_toolEventDeleteHandler(event:Event):void//删除
{
	if(RessGrid.selectedItems.length>0){
		Alert.show("确定要删除这条记录吗？","请您确定",Alert.YES|Alert.NO,this,closeHandler,null,Alert.NO);	
	}else{
		Alert.show("请先选中一条记录！","提示");
	}
	
}
private function closeHandler(e:CloseEvent):void{
	if(e.detail == Alert.YES){
		var obj1:RemoteObject = new RemoteObject("resBusinessDwr");
		obj1.endpoint=ModelLocator.END_POINT;
		obj1.deletRess(RessGrid.selectedItem);
		obj1.addEventListener(ResultEvent.RESULT,resultHandler);
		Application.application.faultEventHandler(obj1);
	}
}
private function resultHandler(e:ResultEvent):void{
	if(e.result!=null){
		if(e.result.toString()=="success"){
			Alert.show("删除成功！","提示");
			serverPagingBar_Ress.navigateButtonClick("firstPage");
		}else{
			Alert.show("删除失败！","提示");
		}
	}
}

/**
 * 修改
 * */
protected function toolbar1_toolEventEditHandler(event:Event):void//修改
{
	if(RessGrid.selectedItems.length>0){
		var property:ShowProperty = new ShowProperty();
		property.title = "修改";
		property.paraValue = RessGrid.selectedItem.business_id;
		property.tablename = "VIEW_BUSINESS_PROPERTY";
		property.key = "BUSINESS_ID";
		PopUpManager.addPopUp(property, this, true);
		PopUpManager.centerPopUp(property);		
		property.addEventListener("savePropertyComplete",function (event:Event):void{
			PopUpManager.removePopUp(property);
			
			refreshHandle(event);});
		
		property.addEventListener("initFinished",function (event:Event):void{
			//选择所属电路 自动填充A端站点和Z端站点
			//(property.getElementById("USERNAME",property.propertyList) as mx.controls.TextInput).text="";
			
			var circode:String = (property.getElementById("CIRCUITCODE",property.propertyList) as mx.controls.TextInput).text ;
			var rt:RemoteObject=new RemoteObject("resBusinessDwr");
			rt.endpoint=ModelLocator.END_POINT;
			rt.showBusyCursor=true;
			rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent){
				var strTmp:String = (String)(event.result);
				var strStationA:String = strTmp.split("splite")[0];
				var strStationZ:String = strTmp.split("splite")[1];
				
				var StationAList:XMLList= new XMLList(strStationA);
				var strStationZList:XMLList= new XMLList(strStationZ);
				(property.getElementById("END_ID_A",property.propertyList) as mx.controls.ComboBox).dropdown.dataProvider=StationAList;
				(property.getElementById("END_ID_A",property.propertyList) as mx.controls.ComboBox).dataProvider=StationAList;
				(property.getElementById("END_ID_A",property.propertyList) as mx.controls.ComboBox).labelField="@label";
				//					(property.getElementById("END_ID_A",property.propertyList) as mx.controls.ComboBox).text="";
				(property.getElementById("END_ID_A",property.propertyList) as mx.controls.ComboBox).selectedIndex=0;
				
				(property.getElementById("END_ID_Z",property.propertyList) as mx.controls.ComboBox).dropdown.dataProvider=strStationZList;
				(property.getElementById("END_ID_Z",property.propertyList) as mx.controls.ComboBox).dataProvider=strStationZList;
				(property.getElementById("END_ID_Z",property.propertyList) as mx.controls.ComboBox).labelField="@label";
				//					(property.getElementById("END_ID_Z",property.propertyList) as mx.controls.ComboBox).text="";
				(property.getElementById("END_ID_Z",property.propertyList) as mx.controls.ComboBox).selectedIndex=0;
				
			});
			rt.getStationAAndStationZByCircuitcode(circode);
			
			
			(property.getElementById("USERNAME",property.propertyList) as mx.controls.TextInput).addEventListener(MouseEvent.CLICK,function(event:Object):void{
				var circuitsearch:SearchCircuitTitle=new SearchCircuitTitle();
				circuitsearch.page_parent=property;
				PopUpManager.addPopUp(circuitsearch,property,true);
				PopUpManager.centerPopUp(circuitsearch);
				circuitsearch.myCallBack=function(obj:Object){
					var clabel:String=obj.label;//从子页面传过来的电路的label
					var ccode:String = obj.code;//从子页面传过来的电路的id
					(property.getElementById("USERNAME",property.propertyList) as mx.controls.TextInput).text=clabel;
					(property.getElementById("USERNAME",property.propertyList) as mx.controls.TextInput).toolTip="点击弹出选择树";
					(property.getElementById("CIRCUITCODE",property.propertyList) as mx.controls.TextInput).data=ccode;
					var rt:RemoteObject=new RemoteObject("resBusinessDwr");
					rt.endpoint=ModelLocator.END_POINT;
					rt.showBusyCursor=true;
					rt.addEventListener(ResultEvent.RESULT,function(event:ResultEvent){
						var strTmp:String = (String)(event.result);
						var strStationA:String = strTmp.split("splite")[0];
						var strStationZ:String = strTmp.split("splite")[1];
						
						var StationAList:XMLList= new XMLList(strStationA);
						var strStationZList:XMLList= new XMLList(strStationZ);
						(property.getElementById("END_ID_A",property.propertyList) as mx.controls.ComboBox).dropdown.dataProvider=StationAList;
						(property.getElementById("END_ID_A",property.propertyList) as mx.controls.ComboBox).dataProvider=StationAList;
						(property.getElementById("END_ID_A",property.propertyList) as mx.controls.ComboBox).labelField="@label";
						//					(property.getElementById("END_ID_A",property.propertyList) as mx.controls.ComboBox).text="";
						(property.getElementById("END_ID_A",property.propertyList) as mx.controls.ComboBox).selectedIndex=0;
						
						(property.getElementById("END_ID_Z",property.propertyList) as mx.controls.ComboBox).dropdown.dataProvider=strStationZList;
						(property.getElementById("END_ID_Z",property.propertyList) as mx.controls.ComboBox).dataProvider=strStationZList;
						(property.getElementById("END_ID_Z",property.propertyList) as mx.controls.ComboBox).labelField="@label";
						//					(property.getElementById("END_ID_Z",property.propertyList) as mx.controls.ComboBox).text="";
						(property.getElementById("END_ID_Z",property.propertyList) as mx.controls.ComboBox).selectedIndex=0;
						
					});
					rt.getStationAAndStationZByCircuitcode(ccode);
				}
			});
		});
	}else{
		Alert.show("请先选中一条记录！","提示");
	}
}

/**
 * 导出数据
 * */
protected function toolbar1_toolEventEmpExcelHandler(event:Event):void//导出
{
	var fefs:FileExportFirstStep = new FileExportFirstStep();
	var model:BusinessRessModel = new BusinessRessModel();
	fefs.dataNumber = this.datanumbers;
	fefs.exportTypes = "业务";
	fefs.titles = new Array("序号","业务名称","所属电路", "业务起点", "业务终点","业务类别","业务速率","业务状态","业务版本"/*,"配置容量","设备容量","工程名称","使用情况","用途","设备标签","备注" ,"更新时间"*/);
	fefs.labels = "业务信息列表";
	model = businessModel;
	model.start = "0";
	model.end = this.datanumbers.toString();
	fefs.model = model;
	MyPopupManager.addPopUp(fefs, true);
}

/**
 * 导入
 * */
protected function toolbar1_toolEventImpExcelHandler(event:Event):void//导入
{
	MyPopupManager.addPopUp(e2Oracle,true);
	e2Oracle.setTemplateType("业务");
}

/**
 * 在桌面添加快捷方式
 * */
protected function toolbar1_toolEventAddShortcutHandler(event:Event):void//添加桌面快捷方式
{
	parentApplication.addShorcut('业务','resBusinessDwr');
}

/**
 * 删除桌面的快捷方式
 * */
protected function toolbar1_toolEventDelShortcutHandler(event:Event):void//删除桌面快捷方式
{
	parentApplication.delShortcut('业务');
}

/**
 * 查询
 * */
protected function toolbar1_toolEventSearchHandler(event:Event):void//查询
{
	var br:TitleRess = new TitleRess();
	br.title = "查询";
	br.currentState='search';
	PopUpManager.addPopUp(br,this,true);
	PopUpManager.centerPopUp(br);
	br.addEventListener("RessSearchEvent",searchRess);
}
private function searchRess(e:BusinessRessEvent):void{
	businessModel = e.model;
	businessModel.start = "0";
	businessModel.end = pageSize.toString();
	businessModel.dir = "asc";
	serverPagingBar_Ress.navigateButtonClick("firstPage");
}

protected function RessGrid_headerReleaseHandler(event:DataGridEvent):void
{
	var dg:DataGrid = DataGrid(event.currentTarget);
	var dgm:DataGridColumn = dg.columns[event.columnIndex];
	var columnName:String=dgm.dataField;
	event.stopImmediatePropagation(); //阻止其自身的排序
	businessModel.sort = columnName;
	businessModel.start="0";
	if(sortName == columnName){
		if(dir){
			businessModel.dir="asc";
			dir=false;
		}else{
			businessModel.dir="desc";
			dir=true;
		}
	}else{
		sortName=columnName;
		dir = false;
		businessModel.dir="asc";
	}
	serverPagingBar_Ress.navigateButtonClick("firstPage");
}
