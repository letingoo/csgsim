	
    import mx.collections.XMLListCollection;
    import mx.controls.Alert;
    import mx.controls.TextInput;
    
    import twaver.PermissionsTreeItemRenderer;
	[Embed('assets/images/file/fileLeaf.gif')]
	[Bindable]
	public var leafPic:Class;
	
	import common.actionscript.ModelLocator;
	import common.other.events.CustomEvent;
	import common.other.events.EventNames;
	
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	import mx.core.ClassFactory;
	import flash.events.Event;
	import mx.controls.Tree;

	public var XMLData:XMLList;
	private var curIndex:int;
	private var catalogsid:String;  
	private var type:int;
	private var selectedNode:XML;
	[Bindable]   
	public var folderList:XMLList= new XMLList(); 
	
	[Bindable]    
	public var folderCollection:XMLList;
	public var page_parent:Object;
	public var sql:String;
	public var objName:Object;
	public var objCode:Object;
	public var isCheckBox:Boolean = false;
	private var objec_name:String = "";
	private var object_code:String = "";
	protected function App(event:FlexEvent):void
	{
		if(isCheckBox){
			autoTree.itemRenderer = new ClassFactory(PermissionsTreeItemRenderer);
		}
		var obj:RemoteObject = new RemoteObject("autoGrid");
		obj.endpoint = ModelLocator.END_POINT;
		obj.showBusyCursor = true;
		obj.getTree(sql,0,null);
		obj.addEventListener(ResultEvent.RESULT,getAutoTree);
	}
	private function initEvent():void{  
		this.addEventListener(EventNames.CATALOGROW,gettree);
	}  
	private function gettree(e:Event):void{  
		
		var rt:RemoteObject = new RemoteObject("autoGrid");
		rt.endpoint = ModelLocator.END_POINT;
		rt.showBusyCursor =true;
		rt.getTree(sql,type,catalogsid);//获取树的数据
		rt.addEventListener(ResultEvent.RESULT, generateTreeInfo);
	}  
	private function generateTreeInfo(event:ResultEvent):void
	{
		var str:String = event.result as String;  
		
		if(str!=null&&str!="")
		{  
			var child:XMLList= new XMLList(str);
			if(selectedNode.children()==null||selectedNode.children().length()==0)
			{ 	
				selectedNode.appendChild(child);
				autoTree.callLater(openTree,[selectedNode]);
			}
		}  
	}
	private function openTree(xml:XML):void{
		if(autoTree.isItemOpen(xml))
			autoTree.expandItem(xml,false);
		autoTree.expandItem(xml,true);
	}
	public function getAutoTree(e:ResultEvent):void{
		folderList = new XMLList(e.result.toString());
		folderCollection=new XMLList(folderList); 
		autoTree.dataProvider = folderCollection;
	}
	
	
	protected function changeHandler():void
	{
		autoTree.selectedIndex = curIndex;
		if(autoTree.selectedItem.@isBranch==true){
			selectedNode = autoTree.selectedItem as XML; 
			catalogsid = this.autoTree.selectedItem.@code;
			type=this.autoTree.selectedItem.@type;
			this.dispatchEvent(new Event(EventNames.CATALOGROW));
		}
	}
	
	
	protected function itemClickHandler(e:ListEvent):void
	{
		var item:Object = autoTree.selectedItem;
		if (autoTree.dataDescriptor.isBranch(item)) {
			autoTree.expandItem(item, !autoTree.isItemOpen(item), true);
		}
	}
	private function clickSaveButton(event:Event):void{
		if(!isCheckBox){
			if(autoTree.selectedItem.@isBranch==false &&autoTree.selectedItem.@leaf==true){
				if(objName is TextInput){
					var textinput:TextInput = objName as TextInput;
					textinput.text =autoTree.selectedItem.@label;
					if(textinput.name!=null&&textinput.name!=""&&textinput.name!="null"){
						textinput.data = autoTree.selectedItem.@code;
					}
				}
				this.close();
			}
		}else{
			var xmlcollection:XMLListCollection = autoTree.dataProvider as XMLListCollection;
			var xmllist:XMLList = xmlcollection.children();
			getSelectItem(xmllist);
			if(objec_name!=null&&objec_name.substring(objec_name.length-1)==','){
				objec_name = objec_name.substring(0,objec_name.length-1);
			}
			if(object_code!=null&&object_code.substring(object_code.length-1)==','){
				object_code = object_code.substring(0,object_code.length-1);
			}
			if(objName is TextInput){
				var textinput:TextInput = objName as TextInput;
				textinput.text =objec_name;
				if(textinput.name!=null&&textinput.name!=""&&textinput.name!="null"){
					textinput.data = object_code;
				}
			}
			this.close();
		}
		
	}
	
	private function getSelectItem(xmllist:XMLList):void
	{
		if(xmllist!=null&&xmllist.children().length()>0){
			for (var i=0;i<xmllist.children().length();i++){
				var xml:XML = xmllist.children()[i];
				if(xmllist.children()[i]!=null){
					if(xmllist.children()[i].@leaf!=null&&xmllist.children()[i].@leaf=='true'&&xmllist.children()[i].@checked!=null&&xmllist.children()[i].@checked=='1'){
						objec_name += xmllist.children()[i].@label+",";
						object_code +=  xmllist.children()[i].@code+",";
					}
				}
			}
			getSelectItem(xmllist.children().children());
		}
		
	}
	
	public function close():void{
		PopUpManager.removePopUp(this);
	}
	private function tree_itemClick(evt:ListEvent):void {
		var item:Object = Tree(evt.currentTarget).selectedItem;
		if (autoTree.dataDescriptor.isBranch(item)) {
			autoTree.expandItem(item, !autoTree.isItemOpen(item), true);
		}
	} 
