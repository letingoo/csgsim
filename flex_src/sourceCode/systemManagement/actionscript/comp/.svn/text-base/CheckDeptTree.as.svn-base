// ActionScript file
import mx.collections.XMLListCollection;
import mx.controls.Alert;
import mx.controls.TextInput;
import mx.core.Application;

import sourceCode.systemManagement.model.OperateDepartModel;
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
import mx.rpc.remoting.RemoteObject;
public var XMLData:XMLList;
private var curIndex:int;
private var catalogsid:String; 
private var type:String;
private var selectedNode:XML;
[Bindable]   
public var folderList:XMLList= new XMLList();

[Bindable]   
public var folderCollection:XML;
public var page_parent:addUser;
public var user_id:String;

protected function App(event:FlexEvent):void
{
	var obj:RemoteObject = new RemoteObject("userManager");
	obj.endpoint = ModelLocator.END_POINT;
	obj.showBusyCursor = true;
	obj.getDept(1,"",user_id);
	obj.addEventListener(ResultEvent.RESULT,getDeptsTree);
}
//public function setValue(departs:Array):void
//{
//	
//	
//	for(var i:int=0;i<departs.length;i++)
//	{		
//		
//		forEachDepart(folderList.children(),departs[i]);
//	}
//	
//	
//}


//private function forEachDepart(xmlList:XMLList,code:String):String
//{
//	
//	
//	var departcode:String="";
//	
//	for(var i:int = 0; i < xmlList.length(); i++)
//	{
//		
//		if(xmlList[i].@code == code){
//			
//			xmlList[i].@checked='1';
//			departcode=code;
//		
//			break;
//		}
//		if(xmlList[i].children().length() > 0)
//		{
//			departcode= forEachDepart(xmlList[i].children(),code);
//			if(departcode!="")
//			{
//				break;
//			}	
//		}
//		
//	}
//	return departcode;
//}
public function getDeptsTree(e:ResultEvent):void{
	folderCollection = new XML(e.result.toString());

	deptsTree.dataProvider = folderCollection;
}
public function close():void{
	PopUpManager.removePopUp(this);
}
public function deptsTree_doubleClickHandler(event:MouseEvent):void
{
	try
	{
		if(deptsTree.selectedItem.@isBranch==false &&deptsTree.selectedItem.@leaf==true){
			
			page_parent.user_dept.text= deptsTree.selectedItem.@name;
			page_parent.user_deptcode = deptsTree.selectedItem.@code;
			
			this.close();
			
		}
	}
	catch(e:Error)
	{
		Alert.show(e.toString());
	}
}

private function save():void  
{  			
	var depts:String=getDeptCode(folderCollection);
	
	//				 page_parent.user_dept.text=depts;
	dispatchEvent(new Event("SaveDept"));
	closeWin();
} 
private function getDeptCode(xml:XML):String
{
	
	var depts:String="";
	if(xml.@leaf=='true')
	{
		if(xml.@checked=='1')
		{
			//						depts+="{"+xml.@code+","+xml.@name+"},";
			var departNotSeted:OperateDepartModel=new OperateDepartModel();
			departNotSeted.departCode = xml.@code;
			departNotSeted.departName = xml.@name;
			page_parent.operateDepart.addItem(departNotSeted);
		}
	}
	else
	{
		for(var i:int=0;i<xml.children().length();i++)
		{
			depts+=getDeptCode(xml.children()[i]);
		}
	}
	return depts;
}
private function closeWin():void
{
	this.closeButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
	deptsTree.expandChildrenOf(folderCollection,false);
	
}