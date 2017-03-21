	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.controls.Tree;
	import mx.core.Application;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	import sourceCode.systemManagement.views.RoleManager;
	
	[Bindable]
	public var _treeXML:XML;
	
	[Bindable]
	private var copyXML:XML = new XML();
	
	public var roleManager:RoleManager;
	
	public function init():void{
		if(parentApplication.funcXML == null){
			roFuncMgr.getAllFunctions();
		}else{
			var xml:XML = parentApplication.funcXML.copy();
			copyXML = parentApplication.funcXML.copy();
			var arrFunc:Array = String(roleManager.treeRole.selectedItem.@funcs).split(',');
			_treeXML = disposeTreeNode(arrFunc,xml);
			treeFunc.callLater(openTreeNode,[true,1]);
		}
	}
	
	private function closeWin():void{
		this.closeButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		treeFunc.expandChildrenOf(_treeXML,false);
		_treeXML = copyXML.copy();
	}
	
	private function iconFunction(item:Object):*{ 
		var xml:XML = item as XML;
		if(xml.attribute("icon") != "" && xml.attribute("icon") != null)
			return ModelLocator.funcIcon;
		else if(treeFunc.isItemOpen(item))
			return ModelLocator.openIcon;
		else if(!treeFunc.isItemOpen(item))
			return ModelLocator.closeIcon;
	}
	
	private function funcResult(event:ResultEvent):void{
		var xml:XML = new XML(event.result);
		copyXML = xml.copy();
		parentApplication.funcXML = xml.copy();
		var arrFunc:Array = String(roleManager.treeRole.selectedItem.@funcs).split(',');
		_treeXML = disposeTreeNode(arrFunc,xml);
		treeFunc.callLater(openTreeNode,[true,1]);
	}
	
	public function disposeTreeNode(arrFuncs:Array,xml:XML):XML{
		for(var i:int = 0; i < xml.children().children().length(); i++){
			if(nameIsInFuncs(arrFuncs,xml.children().children()[i].@parentid,xml.children().children()[i].@name)){
				xml.children().children()[i].@checked = 1;
			}
			if(xml.children().children()[i].children().length() > 0){
				for(var j:int = 0; j < xml.children().children()[i].children().length(); j++){
					if(nameIsInFuncs(arrFuncs,xml.children().children()[i].children()[j].@parentid,xml.children().children()[i].children()[j].@name))
						xml.children().children()[i].children()[j].@checked = 1;
					for(var h:int = 0; h < xml.children().children()[i].children()[j].children().length(); h++){
						if(nameIsInFuncs(arrFuncs,xml.children().children()[i].children()[j].children()[h].@parentid,xml.children().children()[i].children()[j].children()[h].@name))
							xml.children().children()[i].children()[j].children()[h].@checked = 1;
					}
				}
			}
		}
		return xml;
	}
	
	private function nameIsInFuncs(arrFuncs:Array,id:String,name:String):Boolean{
		for(var i:int = 0;i < arrFuncs.length; i++){
			var _id:String = arrFuncs[i].toString().split(":")[0];
			var _name:String = arrFuncs[i].toString().split(":")[1];
			if(_id == id && _name == name)
				return true;
		}
		return false;
	}
	
	private function forEachTree(xmllist:XMLList,bool:Boolean):void{
		for(var i:int = 0; i < xmllist.length(); i++){
			if(xmllist[i].children().length() > 0){
//				if(xmllist[i].@checked == "1")
				treeFunc.expandItem(xmllist[i],bool);
				forEachTree(xmllist[i].children(),bool);
			}else{
				if(xmllist[i].@checked == "1"){
					xmllist[i].parent().@checked = "1";
					treeFunc.expandItem(xmllist[i].parent(),bool);
				}
			}
		}
	}

	public function openTreeNode(bool:Boolean,checked:String):void{
		treeFunc.expandItem(_treeXML,bool);
		forEachTree(_treeXML.children(),bool);
	}
	
	private function treeClick(event:MouseEvent):void{
		if(event.target is CheckBox){
			var operId:String = treeFunc.selectedItem.@id;
			var roleId:String = roleManager.treeRole.selectedItem.@id;
		}
	}
	
	private function saveRoleOper():void{
		var operIds:String = "";
		var roleId:String = roleManager.treeRole.selectedItem.@id;
		var delShortcutNames:String = "";
		for(var i:int = 0; i < _treeXML.children().length(); i++){
			for(var j:int = 0; j < _treeXML.children()[i].children().length(); j++){
				if(_treeXML.children()[i].children()[j].@checked == '1')
					operIds += _treeXML.children()[i].children()[j].@id+",";
				else
					delShortcutNames += _treeXML.children()[i].children()[j].@name+",";
				for(var k:int = 0; k < _treeXML.children()[i].children()[j].children().length(); k++){
					_treeXML.children()[i].children()[j].children()[k].@checked == '1' ? operIds += _treeXML.children()[i].children()[j].children()[k].@id+"," : operIds += "";
					for(var h:int = 0; h < _treeXML.children()[i].children()[j].children()[k].children().length(); h++){
						_treeXML.children()[i].children()[j].children()[k].children()[h].@checked == '1' ? operIds += _treeXML.children()[i].children()[j].children()[k].children()[h].@id+"," : operIds += "";
					}
				}
			}
		}
		
		var roRoleMgr:RemoteObject = new RemoteObject("roleManager");
		roRoleMgr.showBusyCursor = true;
		roRoleMgr.endpoint = ModelLocator.END_POINT;
		roRoleMgr.addEventListener(ResultEvent.RESULT,addRoleOperResult);
		//parentApplication.faultEventHandler(roRoleMgr);
		roRoleMgr.addRoleOper(roleId,operIds);
		
		var ro:RemoteObject = new RemoteObject("login");
		ro.endpoint = ModelLocator.END_POINT;
		ro.delShortcutByRole(delShortcutNames);
		//parentApplication.faultEventHandler(ro);
	}
	
	public var tempIndex:int;
	private function addRoleOperResult(event:ResultEvent):void{
		closeWin();
		Alert.show("角色配置修改成功!","提示");
		var roRoleManager:RemoteObject = new RemoteObject("roleManager");
		roRoleManager.showBusyCursor = true;
		roRoleManager.endpoint = ModelLocator.END_POINT;
		roRoleManager.addEventListener(ResultEvent.RESULT,resultCallBack);
		//parentApplication.faultEventHandler(roRoleManager);
		roRoleManager.getRoles();
	}
	private var xml:XML;
	private function resultCallBack(event:ResultEvent):void{
		xml = new XML(event.result.toString());
		roleManager.treeRole.dataProvider = xml;
		roleManager.treeRole.callLater(openTree);
	}
	
	private function openTree():void{
		roleManager.treeRole.expandChildrenOf(xml,true);
		roleManager.treeRole.selectedIndex = tempIndex;
		roleManager.treeRole.dispatchEvent(new ListEvent(ListEvent.ITEM_CLICK));
	}
	
	private function tree_itemClick(evt:ListEvent):void {
		var item:Object = Tree(evt.currentTarget).selectedItem;
		if (treeFunc.dataDescriptor.isBranch(item)) {
			treeFunc.expandItem(item, !treeFunc.isItemOpen(item), true);
		}
	}
	
	private function faultCallBack(event:FaultEvent):void{
		Alert.show(event.message.toString(),"错误");
	}