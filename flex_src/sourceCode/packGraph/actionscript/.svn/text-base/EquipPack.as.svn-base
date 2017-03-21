		import common.actionscript.ModelLocator;
		import common.actionscript.MyPopupManager;
		import common.actionscript.Registry;
		
		import flash.events.ContextMenuEvent;
		import flash.events.Event;
		import flash.ui.ContextMenu;
		import flash.ui.ContextMenuItem;
		
		import flexlib.controls.SuperTabBar;
		import flexlib.controls.tabBarClasses.SuperTab;
		import flexlib.events.SuperTabEvent;
		import flexlib.events.TabReorderEvent;
		
		import flexunit.utils.ArrayList;
		
		import mx.collections.*;
		import mx.collections.ArrayCollection;
		import mx.containers.dividedBoxClasses.BoxDivider;
		import mx.controls.Alert;
		import mx.controls.CheckBox;
		import mx.controls.SWFLoader;
		import mx.controls.Tree;
		import mx.controls.treeClasses.TreeListData;
		import mx.core.Application;
		import mx.events.CloseEvent;
		import mx.events.IndexChangedEvent;
		import mx.events.ListEvent;
		import mx.events.MenuEvent;
		import mx.managers.PopUpManager;
		import mx.preloaders.Preloader;
		import mx.rpc.events.FaultEvent;
		import mx.rpc.events.ResultEvent;
		import mx.rpc.remoting.mxml.RemoteObject;
		
		import sourceCode.packGraph.model.*;
		import sourceCode.packGraph.views.checkedEquipPack;
		import sourceCode.packGraph.views.viewEquipPackDuanKouPropertiesInfo;
		
		import twaver.*;

		[Bindable]   
		public var folderList:XMLList= new XMLList(); 
		[Bindable]
		public var folderCollection:XMLList;
		private var duanKouProperties : viewEquipPackDuanKouPropertiesInfo;
		private var cm: ContextMenu;
		public var equipcode:String ="";//设备编码
		public var frameserial:String ="";//机框序号
		public var slotserial:String ="";//机槽序号
		public var packserial:String ="";//机盘序号
		private var packcode:String = "";//页面传递参数
		public function initApp():void  { 
			packcode=Registry.lookup("packcode");
			Registry.unregister("packcode");
			if(packcode != null){
				equipcode = packcode.split(",")[0];//正确接收参数 
				frameserial = packcode.split(",")[1];
				slotserial = packcode.split(",")[2];
				packserial = packcode.split(",")[3];
			}
			packtreeremote.getEquipName(equipcode,frameserial,slotserial,packserial);
			duanKouProperties=new viewEquipPackDuanKouPropertiesInfo();
			duanKouProperties.addEventListener("savePortInfo",saveportproperties);
		}
		private function saveportproperties(event:Event):void{
			var logicPort :LogicPort=new LogicPort();
			if(duanKouProperties.connport.text==""){
				logicPort.connport=" ";	
			}else{
				logicPort.connport=duanKouProperties.connport.text
			}
			logicPort.equipname=duanKouProperties.equipname.text;// 设备名称
			logicPort.frameserial=duanKouProperties.frameserial.text;//机框序号
			logicPort.packserial= duanKouProperties.packserial.text;
			logicPort.portserial=duanKouProperties.portserial.text;
			logicPort.slotserial=duanKouProperties.slotserial.text;
			logicPort.logicport=duanKouProperties.logicport.text;
			logicPort.remark=duanKouProperties.remark.text;
			logicPort.status=duanKouProperties.portstatus.selectedItem.@code;
			logicPort.updatedate=duanKouProperties.updatedate.text;
			logicPort.updateperson=duanKouProperties.updateperson.text;
			logicPort.x_capability=duanKouProperties.x_capability.selectedItem.@code;
			logicPort.y_porttype=duanKouProperties.y_porttype.selectedItem.@code;
			logicPort.equipcode=equipcode;
			var ppobj:RemoteObject = new RemoteObject("equipPack");
			ppobj.endpoint=ModelLocator.END_POINT;
			ppobj.showBusyCursor=true;
			ppobj.updatePortProperties(logicPort);
			Application.application.faultEventHandler(ppobj);
			ppobj.addEventListener(ResultEvent.RESULT, function (e: ResultEvent):void{
				if(e.result){
					Alert.show("更新成功","提示");
					MyPopupManager.removePopUp(duanKouProperties);  
				}else{
					Alert.show("后台发生错误，请重试","提示");
				}
			});
		}
//		protected function intContexMenu():void{
//			cm  = new ContextMenu();
//			cm.hideBuiltInItems(); 
//			var contextMenuItem : ContextMenuItem = new ContextMenuItem("本端口属性",true);
//			var contextMenuItem_z : ContextMenuItem = new ContextMenuItem("对端口属性",true);
//			cm.customItems.push(contextMenuItem);
//			cm.customItems.push(contextMenuItem_z);
//			contextMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, ContexMenuItemSelect);
//			contextMenuItem_z.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, ContexMenuItemZSelect);
//			tabPanel.contextMenu = cm; 
//		}
//		private function ContexMenuItemSelect(evt:ContextMenuEvent):void{
//			openDuanKouPropertiesWindow(treepower.selectedItem.@code);
//		}
//		private function ContexMenuItemZSelect(evt:ContextMenuEvent):void{
//			var a_port:String = treepower.selectedItem.@code;
//			var z_port:String;
//			var portPropertiesRO:RemoteObject = new RemoteObject("equipPack");
//			portPropertiesRO.endpoint=ModelLocator.END_POINT;
//			z_port = portPropertiesRO.getZPort(a_port);
//			Application.application.faultEventHandler(portPropertiesRO);
//			openDuanKouPropertiesWindow(z_port);
//		}
		private function openDuanKouPropertiesWindow(logicPort:String):void{
			var portPropertiesRO:RemoteObject = new RemoteObject("equipPack");
			portPropertiesRO.endpoint=ModelLocator.END_POINT;
			portPropertiesRO.getPortProperty(logicPort);
			Application.application.faultEventHandler(portPropertiesRO);
			portPropertiesRO.addEventListener(ResultEvent.RESULT, generatePortProperties);
			
		}
		// 给端口属性赋值
		private function generatePortProperties(event:ResultEvent):void{
			MyPopupManager.addPopUp(duanKouProperties, true);
			
			duanKouProperties.equipname.text=event.result.equipname;
			duanKouProperties.portserial.text=event.result.portserial
			duanKouProperties.frameserial.text=event.result.frameserial;
			duanKouProperties.remark.text=event.result.remark;
			duanKouProperties.slotserial.text=event.result.slotserial;
			duanKouProperties.updatedate.text=event.result.updatedate;
			duanKouProperties.updateperson.text=event.result.updateperson;
			duanKouProperties.logicport.text=event.result.logicport;
			duanKouProperties.connport.text=event.result.connport;
			duanKouProperties.packserial.text=event.result.packserial;
			var ppobj1:RemoteObject = new RemoteObject("equipPack");
			ppobj1.endpoint=ModelLocator.END_POINT;
			ppobj1.showBusyCursor=true;
			ppobj1.getFromXTBM("ZY030704_%");//查看端口类型
			Application.application.faultEventHandler(ppobj1);
			ppobj1.addEventListener(ResultEvent.RESULT, function (e: ResultEvent):void{generatePortTypeInfo(e,event.result.y_porttype)});
			var ppobj2:RemoteObject = new RemoteObject("equipPack");
			ppobj2.endpoint=ModelLocator.END_POINT;
			ppobj2.showBusyCursor=true;
			ppobj2.getFromXTBM("ZY0701_%")// 端口速率
			Application.application.faultEventHandler(ppobj2);
			ppobj2.addEventListener(ResultEvent.RESULT, function (e:ResultEvent):void{generatePortRateInfo(	e,event.result.x_capability)});
			var ppobj3:RemoteObject = new RemoteObject("equipPack");
			ppobj3.endpoint=ModelLocator.END_POINT;
			ppobj3.showBusyCursor=true;
			ppobj3.getFromXTBM("ZY131002_%")// 端口状态
			Application.application.faultEventHandler(ppobj3);
			ppobj3.addEventListener(ResultEvent.RESULT, function(e:ResultEvent):void{generatePortStatusInfo(e,event.result.status)});
		}
		private function generatePortTypeInfo(event:ResultEvent,type:String):void{
			var XMLData:XMLList = new XMLList(event.result.toString());
			duanKouProperties.y_porttype.dataProvider = XMLData.children();
			duanKouProperties.y_porttype.labelField = "@label";
			for each (var element:XML in duanKouProperties.y_porttype.dataProvider) {
				if(element.@label==type){
					duanKouProperties.y_porttype.selectedItem = element as Object;
				}
			}
		}
		private function generatePortRateInfo(event:ResultEvent,rate:String):void{
			var XMLData:XMLList = new XMLList(event.result.toString());
			duanKouProperties.x_capability.dataProvider = XMLData.children();
			duanKouProperties.x_capability.labelField = "@label";	
			for each (var element:XML in duanKouProperties.x_capability.dataProvider) {
				
				if(element.@label==rate){
					
					duanKouProperties.x_capability.selectedItem = element as Object;
				}
			}
		}
		private function generatePortStatusInfo(event:ResultEvent,status:String):void{
			var XMLData:XMLList = new XMLList(event.result.toString());
			duanKouProperties.portstatus.dataProvider = XMLData.children();
			duanKouProperties.portstatus.labelField = "@label";
			for each (var element:XML in duanKouProperties.portstatus.dataProvider) {
				
				if(element.@label==status){
					
					duanKouProperties.portstatus.selectedItem = element as Object;
				}
			}
		} 
			/**
		 *处理从后台请求返回的机盘管理视图左侧树数据 
		 * @param event
		 * 
		 */
		private function resultHandler(event:ResultEvent):void {
			
			folderList = new XMLList(event.result.toString());
			folderCollection=new XMLList(folderList); 
			treepower.dataProvider = folderCollection;
			var temp_element:XML;
			for each (var element:XML in folderList.elements()) 
			{
				if(element.@launch == true){
					element.@checked = "1";
					treepower.validateNow();
					treepower.expandItem(element.parent(),true);
					treepower.expandItem(element,true);
					checkedPanel(element);
				}
			}
		}
		public function DealFault(event:FaultEvent):void {
			trace(event.fault);
		}

		private var slottemp:String = "";
		private var arr:flexunit.utils.ArrayList = new flexunit.utils.ArrayList();
		private function treeCheck(e:Event):void{
			if(e!=null&&e.target!=null&&e.target is CheckBox){
				if(e.target.hasOwnProperty('selected')){
					if(e.target.selected){
						var item:XML = treepower.selectedItem as XML;
						slottemp = item.@code;
						if(arr.contains(slottemp)){
							if(treepower.dataDescriptor.isBranch(treepower.selectedItem)){
								checkedPanel(treepower.selectedItem as XML);
							}
						}else{
						   if(treepower.selectedItem)
						   			checkedPanel(treepower.selectedItem as XML);
						}
					}
					else//取消勾选机盘
					{
						var child1 = tabPanel.getChildByName("tabpanel"+treepower.selectedItem.@label);
						if(child1 != null)
						{
							tabPanel.removeChild(child1);
						}	
					}
				}
			}
		}
		
		private function treeResultHandler(e:ResultEvent):void{
			var item:XMLList = new XMLList(e.result.toString());
			folderCollection.folder.(@code == slottemp).appendChild(item);
			if(treepower.dataDescriptor.isBranch(treepower.selectedItem)){
				checkedPanel(treepower.selectedItem as XML);
			}
			else if(treepower.selectedItem.@leaf ==true){
				//叶子节点且可以选择
			}
		}

		/**
		 *添加某个机盘的机盘管理视图 
		 * @param item
		 * 
		 */
		private function checkedPanel(item:XML):void{
			var child:checkedEquipPack = new checkedEquipPack();
			child.label=item.@label;
			child.id="tabpanel"+item.@label;
			child.name="tabpanel"+item.@label;
			child.slotserial=item.@code;//机槽序号
			child.equipcode=item.@equipcode;//设备编码
			child.frameserial = item.@frameserial;//机框序号
			child.packserial = item.@packserial;//机盘序号
			child.alarmpack.belongequip=child.equipcode;
			child.alarmpack.belongframe=child.frameserial;
			child.alarmpack.belongslot=child.slotserial;
			child.alarmpack.belongpack=child.packserial;
			child.x_capability = item.@rate;//速率					
			child.setStyle("tabCloseButtonStyleName","document_icon");
			tabPanel.addChild(child);
			var index:int = tabPanel.getChildIndex(child);
			tabPanel.selectedIndex=index;
		}
		private function deleteTab(event:flexlib.events.SuperTabEvent):void{
			var child = tabPanel.getChildAt(event.tabIndex);
			var name = child.label;
			var xmllist= treepower.dataProvider;
			var xml:XMLListCollection = xmllist;
			readXMLCollection(xml,name);
		}
		/**
		 *取消该机盘在设备树种的选中状态 
		 * @param node
		 * @param name
		 * 
		 */
		private function readXMLCollection(node:XMLListCollection,name:String):void {
			for each (var element:XML in node.elements()) {
				if(element.@leaf==false){//分支节点
					if(element.@label==name){
						element.@checked = "0";
						treepower.expandItem(element,false);
					}
				}
			}
		}
		private function readXML(node:XML):void {
			for each (var element:XML in node.elements()) {
				readXML(element);
			}
		}	
			/**
		 * 点击树节点事件
		 * @param evt
		 * 
		 */	
		private function tree_itemClick(evt:ListEvent):void {
			if(evt.target is CheckBox)
			{
				var item:Object = Tree(evt.currentTarget).selectedItem;
				if (treepower.dataDescriptor.isBranch(item)) {
					treepower.expandItem(item, !treepower.isItemOpen(item), true);
				}else if(item.parent().parent() != undefined){
					openDuanKouPropertiesWindow(treepower.selectedItem.@code);				
				}
				var nonSelectable:Boolean = ((item.hasOwnProperty("@clickable")) && (item.(@clickable == "false")));
				if (nonSelectable)
				{
					treepower.selectedItem = null;
				} 
			}
		}


