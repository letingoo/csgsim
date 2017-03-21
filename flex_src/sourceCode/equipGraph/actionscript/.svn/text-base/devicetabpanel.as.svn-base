	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	import common.actionscript.Registry;
	
	import mx.collections.*;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.DataGrid;
	import mx.core.Application;
	import mx.events.DragEvent;
	import mx.events.IndexChangedEvent;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	import sourceCode.alarmmgrGraph.model.AlarmModel;
	import sourceCode.channelRoute.views.ViewChannelroute;
	import sourceCode.channelRoute.views.ViewChannelrouteForSys;
	import sourceCode.packGraph.views.UsageDescription;
	
	import twaver.*;
	import twaver.network.Network;

	private var indexRenderer:Class = SequenceItemRenderer;
	private var pageIndex:int=0;
	private var pageSize:int=5;
	private var XMLData:XML;
	private var tabid:String;
	public var equipname : String = "";		
	public var equipcode :String ="";
	[Bindable]			
	private var cm:ContextMenu;
	private var btnlabel:String="<<";
	
	//private var itemAcBoard:acboard; 
	
	
	
	
	public function initApp():void{
		addLinkButton();
		alarmgrid.alarmDataGrid.setStyle("headerColors",[0xFFFFFF,0xE6EEEE]);
		alarmrootgrid.alarmDataGrid.setStyle("headerColors",[0xFFFFFF,0xE6EEEE]);
		alarmgrid.controlBar.visible=false;
		alarmgrid.controlBar.includeInLayout=false;
		alarmgrid.queryCavas.visible=false;
		alarmgrid.queryCavas.includeInLayout=false;
		alarmrootgrid.controlBar.visible=false;
		alarmrootgrid.controlBar.includeInLayout=false;
		alarmrootgrid.queryCavas.visible=false;
		alarmrootgrid.queryCavas.includeInLayout=false;
		var cmi_add:ContextMenuItem = new ContextMenuItem("方式信息", true);				
		cmi_add.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, contextMenu_menuSelect);
		cm = new ContextMenu();
		cm.hideBuiltInItems();
		cm.customItems.push(cmi_add);
		
	}			
	public function ChangeEvent():void{
		if(equipcode!=null&&equipcode!=""){
			var flag : String = tabnavigator1.getTabAt(tabnavigator1.selectedIndex).label;
			tabid = flag;
			var rtobj:RemoteObject = new RemoteObject("devicePanel");
			rtobj.endpoint = ModelLocator.END_POINT;
			rtobj.showBusyCursor = true;
			if(flag =='承载电路')
			{
				rtobj.getCarryOperaFlex(pageIndex,pageSize,equipcode);
			}
			else if(flag =='光口时隙使用率'){
				
				rtobj.getStatisInfoFlex(pageIndex,pageSize,equipcode);
			}else if(flag=='电口使用率'){
				rtobj.getStatisPieFlex(pageIndex,pageSize,equipcode);
				
			}else if(flag=='当前根告警'){
				alarmrootgrid.alarmModel.belongequip=equipcode;
				alarmrootgrid.searchRefresh(alarmrootgrid.alarmModel);
			}else if(flag=='当前原始告警'){
				alarmgrid.alarmModel.belongequip=equipcode;
				alarmgrid.searchRefresh(alarmgrid.alarmModel);
			}
			rtobj.addEventListener(ResultEvent.RESULT, setDataProvide);
		}
	}
	
	private function callBackFunction(e:ResultEvent):void{
		ChangeEvent();
	}
	
	
	
	private function contextMenu_menuSelect(evt:ContextMenuEvent):void 
	{	
		
		Registry.register("para_circuitcode", carryoperagrid.selectedItem.@circuitcode);
		Application.application.openModel("方式信息", false);
		
	}
	
	private function  dragComplete(e:DragEvent):void{
		
	}
	private  function   setDataProvide(e:ResultEvent):void{
		XMLData = new XML(e.result.toString());				
		var orgData:ArrayCollection = new ArrayCollection();
		
		for each(var arrxml:XML in XMLData.children())
		{
			orgData.addItem(arrxml);
			
		}
		if(tabid=='承载电路'){
			
			carryoperagrid.dataProvider=orgData;
			carryoperagrid.invalidateList();
			clientPagingBar1.dataGrid=carryoperagrid;
			clientPagingBar1.orgData=orgData;
			clientPagingBar1.dataBind();
		}
		else if(tabid=='光口时隙使用率'){
			
			deviceportstatsgrid.dataProvider=orgData;
			deviceportstatsgrid.invalidateList();
			clientPagingBar2.dataGrid=deviceportstatsgrid;
			clientPagingBar2.orgData=orgData;
			clientPagingBar2.dataBind();
		}else if(tabid=='电口使用率'){
			
			portusestatsgrid.dataProvider=orgData;
			portusestatsgrid.invalidateList();
			clientPagingBar3.dataGrid=portusestatsgrid;
			clientPagingBar3.orgData=orgData;
			clientPagingBar3.dataBind();
		}
	}
	
	/**
	 * @author wangjinshan
	 * @date 2010.10.24
	 **/
	public function carryoperagrDoubleClickHandler(event:ListEvent):void{
		var routeMethod:ViewChannelrouteForSys = new ViewChannelrouteForSys();
		routeMethod.c_circuitcode =carryoperagrid.selectedItem.@circuitcode;//方式单编号
		MyPopupManager.addPopUp(routeMethod,true);
	}

	private function changeState():void{
		if(this.text.visible){
			this.percentWidth=100;
			this.text.visible=false;
			this.text.includeInLayout=false;
			this.tabnavigator1.visible=true;
			this.tabnavigator1.includeInLayout=true;
			this.linkButton.label=">>";
			this.mypanel.title="设备使用情况";
		}else{
			this.width=25;
			this.tabnavigator1.visible=false;
			this.tabnavigator1.includeInLayout=false;
			this.text.visible=true;
			this.text.includeInLayout=true;
			this.linkButton.label="<<";
			this.mypanel.title="";
		}
	}
	private function addLinkButton():void{
		clientPagingBar2.customLinkBtn.label="说明";
		clientPagingBar2.customLinkBtn.visible=true;
		clientPagingBar2.customLinkBtn.setStyle("icon",ModelLocator.help);
		clientPagingBar2.customLinkBtn.addEventListener(MouseEvent.CLICK,showUsageDesc);
		clientPagingBar3.customLinkBtn.label="说明";
		clientPagingBar3.customLinkBtn.visible=true;
		clientPagingBar3.customLinkBtn.setStyle("icon",ModelLocator.help);
		clientPagingBar3.customLinkBtn.addEventListener(MouseEvent.CLICK,showUsageDesc);
	}
	private function showUsageDesc(event:MouseEvent):void{
		var usagedesc:UsageDescription=new UsageDescription();
		PopUpManager.addPopUp(usagedesc,this.parent,true);
		PopUpManager.centerPopUp(usagedesc);
	}
