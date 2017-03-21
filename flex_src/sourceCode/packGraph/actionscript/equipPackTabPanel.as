		import common.actionscript.ModelLocator;
		import common.actionscript.MyPopupManager;
		import common.actionscript.Registry;
		import flash.events.Event;
		import flash.events.MouseEvent;
		import mx.collections.ArrayCollection;
		import mx.controls.Alert;
		import mx.controls.LinkButton;
		import mx.core.Application;
		import mx.events.ListEvent;
		import mx.managers.PopUpManager;
		import mx.rpc.events.ResultEvent;
		import mx.rpc.remoting.mxml.RemoteObject;
		import sourceCode.channelRoute.views.ViewChannelroute;
		import sourceCode.channelRoute.views.ViewChannelrouteForSys;
		import sourceCode.packGraph.views.*;
		import twaver.*;

		public var equipcode:String ="";
		public var frameserial:String ="";
		public var slotserial:String ="";
		public var packserial:String ="";
		public var logicport:String = "";
		private var XMLData:XML;
		private var indexRenderer:Class = SequenceItemRenderer;
		private var btnlabel:String="<<";
		private function init():void{
			addLinkButton();
			alarmgrid.alarmDataGrid.setStyle("headerColors",[0xFFFFFF,0xE6EEEE]);
			alarmrootgrid.alarmDataGrid.setStyle("headerColors",[0xFFFFFF,0xE6EEEE]);
			alarmgrid.btnExport.visible=false;
			alarmrootgrid.btnExport.visible=false;
			alarmgrid.controlBar.visible=false;
			alarmgrid.controlBar.includeInLayout=false;
			alarmgrid.queryCavas.visible=false;
			alarmgrid.queryCavas.includeInLayout=false;
			alarmrootgrid.controlBar.visible=false;
			alarmrootgrid.controlBar.includeInLayout=false;
			alarmrootgrid.queryCavas.visible=false;
			alarmrootgrid.queryCavas.includeInLayout=false;
			businessGrid.contextMenu=new ContextMenu();
			businessGrid.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,function(e:ContextMenuEvent):void{
				//定制右键菜单
				businessGrid.contextMenu.hideBuiltInItems();
				var flexVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLEX_SDK_VERSION, false, false);
				var playerVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLASH_PLAYER_VERSION, false, false);
				if(businessGrid.selectedItems.length==0){
					businessGrid.contextMenu.customItems=[flexVersion,playerVersion];
				}else{
					var item1:ContextMenuItem = new ContextMenuItem("方式信息", true);
					businessGrid.contextMenu.customItems=[item1];
					item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
				}
			});
		}
		
		private function itemSelectHandler(e:ContextMenuEvent):void{
			Registry.register("para_circuitcode", businessGrid.selectedItem.@circuitcode);
			Application.application.openModel("方式信息", false);
		}
		private function ChangeEvent():void
		{
			var label:String = tabnavigator.getTabAt(tabnavigator.selectedIndex).label;
			var rtobj:RemoteObject = new RemoteObject("equipPack");
			var frameserial:String = "1";//京安华桥的机框编号（测试参数）
			var packserial:String = "1";//京安华桥的机盘序号（测试参数）
			
			rtobj.endpoint = ModelLocator.END_POINT;
			rtobj.showBusyCursor = true;
			if(label == '承载业务'){
				//查询数据
				rtobj.getPackYewu(equipcode,frameserial,slotserial,packserial,logicport);
			}
			else if(label == '光口时隙使用率'){
				rtobj.getPackStatis(equipcode,frameserial,slotserial,packserial);
			}
			else if (label == '电口使用率')
			{
				rtobj.get2MPackStatus(equipcode,frameserial,slotserial,packserial);
			}else if(label=='当前根告警'){
				alarmrootgrid.alarmModel.belongequip=equipcode;
				alarmrootgrid.alarmModel.belongframe=frameserial;
				alarmrootgrid.alarmModel.belongslot=slotserial;
				alarmrootgrid.alarmModel.belongpack=packserial;
				alarmrootgrid.searchRefresh(alarmrootgrid.alarmModel);
			}else if(label=='当前原始告警'){
				alarmgrid.alarmModel.belongequip=equipcode;
				alarmgrid.alarmModel.belongframe=frameserial;
				alarmgrid.alarmModel.belongslot=slotserial;
				alarmgrid.alarmModel.belongpack=packserial;
				alarmgrid.searchRefresh(alarmgrid.alarmModel);
			}
			rtobj.addEventListener(ResultEvent.RESULT, setDataProvide);
			Application.application.faultEventHandler(rtobj);
		}
		private  function   setDataProvide(e:ResultEvent):void{
			var label:String = tabnavigator.getTabAt(tabnavigator.selectedIndex).label;
			XMLData = new XML(e.result.toString());				
			var orgData:ArrayCollection = new ArrayCollection();
			for each(var arrxml:XML in XMLData.children()){
				orgData.addItem(arrxml);
			}
			if(label=='承载业务'){
				businessGrid.dataProvider=orgData;
				businessGrid.invalidateList();
				clientPagingBar1.dataGrid=businessGrid;
				clientPagingBar1.orgData=orgData;
				clientPagingBar1.dataBind()
				
			}
			else if(label=='光口时隙使用率'){
				
				resGrid.dataProvider=orgData;
				resGrid.invalidateList();
				clientPagingBar3.dataGrid=resGrid;
				clientPagingBar3.orgData=orgData;
				clientPagingBar3.dataBind();
			}
			else if(label=='电口使用率'){
				
				portusestatsgrid.dataProvider=orgData;
				portusestatsgrid.invalidateList();
				clientPagingBar4.dataGrid=portusestatsgrid;
				clientPagingBar4.orgData=orgData;
				clientPagingBar4.dataBind();
			}
		}
		public function RowNum(ob:Object):String 
		{
			return String((businessGrid.dataProvider as ArrayCollection).getItemIndex(ob)); 
		}
		/**
		 * @author wangjinshan
		 * @date 2010.10.24
		 **/
		protected function businessGrid_itemDoubleClickHandler(event:ListEvent):void
		{	
			Registry.register("para_circuitcode", businessGrid.selectedItem.@circuitcode);
			Application.application.openModel("方式信息", false);
		}
		private function changeState():void{
			if(this.text.visible){
				this.percentWidth=100;
				this.text.visible=false;
				this.text.includeInLayout=false;
				this.tabnavigator.visible=true;
				this.tabnavigator.includeInLayout=true;
				this.linkButton.label=">>";
				this.mypanel.title="机盘使用情况";
			}else{
				this.width=25;
				this.tabnavigator.visible=false;
				this.tabnavigator.includeInLayout=false;
				this.text.visible=true;
				this.text.includeInLayout=true;
				this.linkButton.label="<<";
				this.mypanel.title="";
			}
		}

		private function addLinkButton():void{
			clientPagingBar3.customLinkBtn.label="说明";
			clientPagingBar3.customLinkBtn.visible=true;
			clientPagingBar3.customLinkBtn.setStyle("icon",ModelLocator.help);
			clientPagingBar3.customLinkBtn.addEventListener(MouseEvent.CLICK,showUsageDesc);
			clientPagingBar4.customLinkBtn.label="说明";
			clientPagingBar4.customLinkBtn.visible=true;
			clientPagingBar4.customLinkBtn.setStyle("icon",ModelLocator.help);
			clientPagingBar4.customLinkBtn.addEventListener(MouseEvent.CLICK,showUsageDesc2);
		}
		private function showUsageDesc(event:MouseEvent):void{
			var usagedesc:UsageDescription=new UsageDescription();
			PopUpManager.addPopUp(usagedesc,this.parent,true);
			PopUpManager.centerPopUp(usagedesc);
		}

		private function showUsageDesc2(event:MouseEvent):void{
			var usagedesc:UsageDescription=new UsageDescription();
			PopUpManager.addPopUp(usagedesc,this.parent,true);
			PopUpManager.centerPopUp(usagedesc);
			usagedesc.usage_description.text="电口使用率颜色说明:";
		}