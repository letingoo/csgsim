	import com.adobe.serialization.json.JSON;
	
	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import mx.containers.Form;
	import mx.containers.FormItem;
	import mx.containers.HBox;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.ComboBox;
	import mx.controls.DateField;
	import mx.controls.Label;
	import mx.controls.Spacer;
	import mx.controls.Text;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.controls.ToolTip;
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.events.DropdownEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.events.ModuleEvent;
	import mx.managers.PopUpManager;
	import mx.managers.ToolTipManager;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	
	import org.flexunit.runner.Result;
	
	import sourceCode.autoGrid.actionscript.AutoGridEvent;
	import sourceCode.autoGrid.view.TreeWindow;
	import sourceCode.sysGraph.model.EquInfo;
	import sourceCode.systemManagement.views.comp.DeptTree;
	
	public var tablename:String;
	public var paraValue:String;
	public var key:String;
	public var propertyList:Array = new Array();
	private var obj_width:int = 180;
	private var dateArray:Array;
	[Bindable]public var boo:Boolean = true;
	private var native_json:String;
	public var arrayList:Array;
	public var insertKey:String;
	public var objectValues:Object = new Object();
	private var isHasDate:Boolean = false;
	[Bindable]public var isShowButton = true;
	private var setValues:Object;
	private function init():void
	{
		
		var showRT:RemoteObject = new RemoteObject("autoGrid");
		showRT.endpoint = ModelLocator.END_POINT;
		showRT.showBusyCursor = true;
		showRT.getShowProperty(tablename,'search');//根据系统编码查询对应信息(所属系统)
		showRT.addEventListener(ResultEvent.RESULT,show);
		
	}
	
	private function show(event:ResultEvent):void{
		if(event.result!=null&&event.result.toString()!=""){
			arrayList = new Array();
			var obj:Array = JSON.decode(event.result.toString()) as Array;
			var content:String = "";
			dateArray = new Array();
			var flag:Boolean = true;
			var objectArray:Array = new Array();
			var form:Form = new Form();
			form.percentHeight = 100;
			form.percentWidth  = 100;
			var form1:Form = new Form();
			form1.percentHeight = 100;
			form1.percentWidth  = 100;
			if(obj!=null){
				var count:int = obj.length;
				if(count<7){
					this.width = 320;
				}else if(count>14){
					this.height = 460;
				}
				for(var i:int=0;i<count;i++){
					var formitem:FormItem = new FormItem();
					formitem.label = obj[i].text;
					if(obj[i].relate!=null&&obj[i].relate!=""&&obj[i].relate!='null'){
						flag = false;
						objectArray.push(obj[i]);
					}else{
						flag = true;
					}
					if(obj[i].type!=null&&obj[i].type=='COMBOBOX'){
						var combox:ComboBox = new ComboBox();
						combox.id = obj[i].id;
						if(obj[i].restrict!=null&&obj[i].restrict!=""&&obj[i].restrict!="null"){
							combox.restrict = obj[i].restrict;
						}
						arrayList.push(combox);
						content+=obj[i].id;
						if(i<count-1){
							content+="@";
						}
						combox.width=obj_width;
						formitem.addChild(combox);
						
						if(obj[i].isvisible!=null&&obj[i].isvisible=='N'){
							formitem.visible = false;
							formitem.includeInLayout = formitem.visible;
							combox.visible = formitem.visible;
							combox.includeInLayout = formitem.visible;
						}
						
						if(obj[i].xmllist!=null&&obj[i].xmllist!=""){
							var tmp:String = obj[i].xmllist as String;
							var xml:XMLList = new XMLList(tmp);
							combox.labelField="@label";
							combox.dataProvider = xml;
							combox.selectedIndex = -1;
						}
						if(obj[i].isvalue!=null&&obj[i].isvalue!=""&&obj[i].isvalue!="null"&&obj[i].isvalue=="Y"){
							if(combox.dataProvider!=null&&objectValues!=null){
								for each(var element:XML in combox.dataProvider){
									if(element.@label==objectValues[combox.id]||element.@code==objectValues[combox.id]){
										combox.selectedItem=element as Object;
										break
									}
								}
								
							}
						}
						combox.addEventListener(ListEvent.ITEM_ROLL_OVER,fnCreToolTip);
						combox.addEventListener(ListEvent.ITEM_ROLL_OUT,fnCreToolTip);
						combox.addEventListener(DropdownEvent.CLOSE,function(event:DropdownEvent){
							if(null!=myTip)
								ToolTipManager.destroyToolTip(myTip);
							blnShowTip = true;
						});
					}else if(obj[i].type!=null&&obj[i].type=='DATEFIELD'){
						isHasDate = true;
						dateArray.push(obj[i]);
					}else if(obj[i].type!=null&&obj[i].type=='TREE'){
						var textinput:TextInput = new TextInput();
						textinput.id = obj[i].id;
						if(obj[i].restrict!=null&&obj[i].restrict!=""&&obj[i].restrict!="null"){
							textinput.restrict = obj[i].restrict;
						}
						if(obj[i].reality!=null&&obj[i].reality!=""&&obj[i].reality!="null"){
							textinput.name = obj[i].reality;
							content+=obj[i].reality;
							content+="@";
						}else{
							textinput.name = "";
						}
						arrayList.push(textinput);
						content+=obj[i].id;
						if(i<count-1){
							content+="@";
						}
						textinput.width =obj_width;
						formitem.addChild(textinput);
						if(obj[i].isvisible!=null&&obj[i].isvisible=='N'){
							formitem.visible = false;
							formitem.includeInLayout = formitem.visible;
							textinput.visible = formitem.visible;
							textinput.includeInLayout = formitem.visible;
							
						}
						
						if(obj[i].reality!=null&&obj[i].reality!=""&&obj[i].reality!="null"){
							if(obj[i].isvalue!=null&&obj[i].isvalue!=""&&obj[i].isvalue!="null"&&obj[i].isvalue=="Y"){
								if(objectValues!=null){
									textinput.text = objectValues[textinput.id];
									textinput.data = objectValues[textinput.name];
								}
							}
						}else{
							if(obj[i].isvalue!=null&&obj[i].isvalue!=""&&obj[i].isvalue!="null"&&obj[i].isvalue=="Y"){
								if(objectValues!=null){
									textinput.text = objectValues[textinput.id];
								}
							}   
						}
						var sql:String = obj[i].getrule;
						var treeWin:TreeWindow = new TreeWindow();
						treeWin.sql = sql;
						treeWin.objName = textinput;
						treeWin.title = formitem.label;
						textinput.addEventListener(MouseEvent.CLICK,function():void{
							openTreeWindow(treeWin);
						});
					}else if(obj[i].type!=null&&obj[i].type=='DEPT'){
						var textinput:TextInput = new TextInput();
						textinput.id = obj[i].id;
						if(obj[i].restrict!=null&&obj[i].restrict!=""&&obj[i].restrict!="null"){
							textinput.restrict = obj[i].restrict;
						}
						if(obj[i].reality!=null&&obj[i].reality!=""&&obj[i].reality!="null"){
							textinput.name = obj[i].reality;
							content+=obj[i].reality;
							content+="@";
						}else{
							textinput.name = "";
						}
						textinput.editable = false;
						arrayList.push(textinput);
						content+=obj[i].id;
						if(i<count-1){
							content+="@";
						}
						textinput.width =obj_width;
						formitem.addChild(textinput);
						if(obj[i].isvisible!=null&&obj[i].isvisible=='N'){
							formitem.visible = false;
							formitem.includeInLayout = formitem.visible;
							textinput.visible = formitem.visible;
							textinput.includeInLayout = formitem.visible;
							
						}
						if(obj[i].iseditable!=null&&obj[i].iseditable=='N'&& paraValue != null && paraValue != ""){
							textinput.editable = false;
							textinput.enabled = textinput.editable;
						}
						if(obj[i].reality!=null&&obj[i].reality!=""&&obj[i].reality!="null"){
							if(obj[i].isvalue!=null&&obj[i].isvalue!=""&&obj[i].isvalue!="null"&&obj[i].isvalue=="Y"){
								if(objectValues!=null){
									textinput.text = objectValues[textinput.id];
									textinput.data = objectValues[textinput.name];
								}
							}
						}else{
							if(obj[i].isvalue!=null&&obj[i].isvalue!=""&&obj[i].isvalue!="null"&&obj[i].isvalue=="Y"){
								if(objectValues!=null){
									textinput.text = objectValues[textinput.id];
								}
							}   
						}
						
						var dept:DeptTree = new DeptTree();
						textinput.addEventListener(MouseEvent.CLICK,function():void{
							openTreeWindow(dept);
						});
					}
					else if(obj[i].type!=null&&obj[i].type=='TEXTAREA'){
						var textarea:TextArea =new TextArea();
						textarea.id = obj[i].id;
						if(obj[i].restrict!=null&&obj[i].restrict!=""&&obj[i].restrict!="null"){
							textarea.restrict = obj[i].restrict;
						}
						if(obj[i].reality!=null&&obj[i].reality!=""&&obj[i].reality!="null"){
							textarea.name = obj[i].reality;
							content+=obj[i].reality;
							content+="@";
						}else{
							textarea.name = "";
						}
						arrayList.push(textarea);
						content+=obj[i].id;
						if(i<count-1){
							content+="@";
						}
						textarea.width =obj_width;
						formitem.addChild(textarea);
						if(obj[i].isvisible!=null&&obj[i].isvisible=='N'){
							formitem.visible = false;
							formitem.includeInLayout = formitem.visible;
							textarea.visible = formitem.visible;
							textarea.includeInLayout = formitem.visible;
						}
						
					}
					else{
						var textinput:TextInput = new TextInput();
						textinput.id = obj[i].id;
						if(obj[i].restrict!=null&&obj[i].restrict!=""&&obj[i].restrict!="null"){
							textinput.restrict = obj[i].restrict;
						}
						if(obj[i].reality!=null&&obj[i].reality!=""&&obj[i].reality!="null"){
							textinput.name = obj[i].reality;
							content+=obj[i].reality;
							content+="@";
						}else{
							textinput.name = "";
						}
						arrayList.push(textinput);
						content+=obj[i].id;
						if(i<count-1){
							content+="@";
						}
						textinput.width =obj_width;
						formitem.addChild(textinput);
						if(obj[i].isvisible!=null&&obj[i].isvisible=='N'){
							formitem.visible = false;
							formitem.includeInLayout = formitem.visible;
							textinput.visible = formitem.visible;
							textinput.includeInLayout = formitem.visible;
						}
						
						if(obj[i].reality!=null&&obj[i].reality!=""&&obj[i].reality!="null"){
							if(obj[i].isvalue!=null&&obj[i].isvalue!=""&&obj[i].isvalue!="null"&&obj[i].isvalue=="Y"){
								if(objectValues!=null){
									textinput.text = objectValues[textinput.id];
									textinput.data = objectValues[textinput.name];
								}
							}
						}else{
							if(obj[i].isvalue!=null&&obj[i].isvalue!=""&&obj[i].isvalue!="null"&&obj[i].isvalue=="Y"){
								if(objectValues!=null){
									textinput.text = objectValues[textinput.id];
								}
							}   
						}
					}
					if(obj[i].type!=null&&obj[i].type!='DATEFIELD'){
						if(count<7){
							form.addChild(formitem);
							propertychild.addChild(form);
							property.addChild(propertychild);
						}else{
							if(i<=(count/2-1)){
								form.addChild(formitem);
								propertychild.addChild(form);
								property.addChild(propertychild);
								
							}else{
								form1.addChild(formitem);
								propertychild.addChild(form1);
								property.addChild(propertychild);
							}
							
						}
					}
					if(!flag){
						var relateObj:Object = getElementById(obj[i].relate,arrayList);
						if(relateObj is TextInput){
							var tmptext:TextInput = relateObj as TextInput;
							tmptext.addEventListener(FlexEvent.UPDATE_COMPLETE,function():void{
								updateComPlete(tmptext,objectArray,arrayList);
							});
						}else if(relateObj is ComboBox){
							var tmpComBoBox:ComboBox = relateObj as ComboBox;
							tmpComBoBox.addEventListener(ListEvent.CHANGE,function():void{
								change(tmpComBoBox,objectArray,arrayList);
							});
						}
					}
				}
				if(isHasDate&&dateArray!=null){
					this.width = 620;
					if(dateArray.length>0){
						for(var k=0;k<dateArray.length;k++){
							var dateobj:Object = dateArray[k];
							var hbox:HBox = new HBox();
							hbox.styleName="searchhbox";
							hbox.percentWidth = 100;
							hbox.percentHeight = 5;
							var label:Label = new Label();
							label.text = dateobj.text;
							hbox.addChild(label);
							var hbox1:HBox = new HBox();
							hbox1.percentWidth = 100;
							hbox1.percentHeight = 10;
							var fom:Form = new Form();
							fom.percentWidth = 100;
							fom.percentHeight = 100;
							var fo:FormItem = new FormItem();
							fo.label = "从";
							var datef:DateField = new DateField();
							datef.id = dateobj.id;
							datef.width = 180;
							datef.dayNames = ModelLocator.days;
							datef.monthNames = ModelLocator.monthNames;
							datef.yearNavigationEnabled = true;
							datef.formatString = "YYYY-MM-DD";
							arrayList.push(datef);
							var fom1:Form = new Form();
							fom1.percentWidth = 100;
							fom1.percentHeight = 100;
							var fo1:FormItem = new FormItem();
							fo1.label = "至";
							var datef1:DateField = new DateField();
							datef1.id = dateobj.id+'&';
							datef1.width = 180;
							datef1.dayNames = ModelLocator.days;
							datef1.monthNames = ModelLocator.monthNames;
							datef1.yearNavigationEnabled = true;
							datef1.formatString = "YYYY-MM-DD";
							arrayList.push(datef1);
							fo.addChild(datef);
							fom.addChild(fo);
							fo1.addChild(datef1);
							fom1.addChild(fo1);
							
							hbox.addChild(fom);
							hbox.addChild(fom1);
							property.addChild(hbox);
							
						}
					}
				}
				if(isShowButton){
					var hboxbutton:HBox = new HBox();
					hboxbutton.percentWidth = 100;
					hboxbutton.percentHeight = 18;
					hboxbutton.styleName = 'HBoxButton';
					var button:Button = new Button();
					button.id = 'save';
					button.visible = boo;
					button.label = '查询';
					button.width = 80;
					button.styleName='loginprimary';
					button.addEventListener(MouseEvent.CLICK,function(event:Event){
						save(content,arrayList);
					});
//					button.enabled  = Application.application.isEdit;
					var button2:Button = new Button();
					button2.id = 'cancel';
					button2.visible = boo;
					button2.label = '清空';
					button2.width = 80;
					button2.styleName='loginsecondary';
					button2.addEventListener(MouseEvent.CLICK,setValueNull);
					//button2.enabled  = Application.application.isEdit;
					var spacer:Spacer = new Spacer();
					spacer.width = 10;
					hboxbutton.addChild(button);
					hboxbutton.addChild(spacer);
					hboxbutton.addChild(button2);
					property.addChild(hboxbutton);
				}
			}
			propertyList = new Array();
			propertyList = arrayList;
		}
	}
	
	private function setValueNull(event:Event):void{
		var count:int = arrayList.length;
		
		for(var i:int=0;i<count;i++){
			var obj:Object = arrayList[i] as Object;
			if(obj.text!=null&&obj.text!=""){
				obj.text = "";
			}
		}
	}
	
	private function change(tmpComBoBox:ComboBox,objArray:Array,arrayList:Array):void{
		var obj:Object = new Object();
		var id:String = null;
		if(objArray!=null&&objArray.length>0){
			for(var i:int=0;i<objArray.length;i++){
				if(tmpComBoBox.id==objArray[i].relate){
					id = objArray[i].id;
				}
			}
		}
		if(id!=null){
			obj = getElementById(id,arrayList);
			
			var remote:RemoteObject = new RemoteObject("autoGrid");
			remote.endpoint = ModelLocator.END_POINT;
			remote.showBusyCursor = true;
			var xtbm:String = tmpComBoBox.selectedItem.@code;
			var code:String = tmpComBoBox.id;
			remote.channgeProvider(xtbm,tablename,obj.id,code);
			remote.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
				updateResult(event,obj);
			});
			
		}
		
	}
	
	private function updateComPlete(tmptext:Object,objArray:Array,arrayList:Array):void{
		var obj:Object = new Object();
		var id:String = null;
		if(objArray!=null&&objArray.length>0){
			for(var i:int=0;i<objArray.length;i++){
				if(tmptext.id==objArray[i].relate){
					id = objArray[i].id;
				}
			}
		}
		if(id!=null){
			obj = getElementById(id,arrayList);
			var remote:RemoteObject = new RemoteObject("autoGrid");
			remote.endpoint = ModelLocator.END_POINT;
			remote.showBusyCursor = true;
			var xtbm:String = tmptext.text;
			var code:String = tmptext.id;
			if(tmptext.name!=""&&tmptext.name!='null'){
				code = tmptext.name;
				if(tmptext.data!=null)
					xtbm = tmptext.data.toString();
			}
			
			remote.channgeProvider(xtbm,tablename,obj.id,code);
			remote.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
				updateResult(event,obj);
			});
		}
	}
	
	private function updateResult(event:ResultEvent,obj:Object):void{
		
		if(obj is ComboBox){
			var combox:ComboBox = obj as ComboBox;
			if(event.result!=null){
				var xml:XMLList = new XMLList(event.result.toString());
				combox.dropdown.dataProvider = xml;
				combox.dataProvider = xml;
				combox.selectedIndex = -1;
				if(paraValue==null||paraValue==""){
					if(objectValues!=null&&objectValues[combox.id]!=null){
						for each(var element:XML in combox.dataProvider){
							if(element.@label==objectValues[combox.id]||element.@code==objectValues[combox.id]){
								combox.selectedItem=element as Object;
								break
							}
						}
						
					}	
				}else{
					if(setValues!=null){
						if(setValues[combox.id]!=null){
							for each(var element:XML in combox.dataProvider){
								if(element.@label==setValues[combox.id]||element.@code==setValues[combox.id]){
									combox.selectedItem=element as Object;
									break
								}
							}
							
						}
					}
					
				}
				
			}
		}
		
	}
	
	public function getElementById(id:String,arrayList:Array):Object{
		var obj:Object= new Object();
		if(arrayList!=null&&arrayList.length>0){
			for(var i:int=0;i<arrayList.length;i++){
				var object:Object = arrayList[i] as Object;
				if(id==object.id){
					obj = object;
					break;
				}
			}
			
		}
		
		return obj;
	}
	
	private function openTreeWindow(treeWin:IFlexDisplayObject):void{
		
		PopUpManager.addPopUp(treeWin, this, true);
		PopUpManager.centerPopUp(treeWin);
	}
	
	
	
	
	private function close():void  
	{  
		resetValue();
		MyPopupManager.removePopUp(this);
	}
	
	private function save(content:String,arrayList:Array):void  
	{  
		var saveValueRT:RemoteObject = new RemoteObject("autoGrid");
		saveValueRT.endpoint = ModelLocator.END_POINT;
		saveValueRT.showBusyCursor = true;
		var count:int = arrayList.length;
		var json:String = "";
		json+="[";
		for(var i:int=0;i<count;i++){
			var obj:Object = arrayList[i] as Object;
			var object:DisplayObjectContainer = obj.parent;
			var isDate:Boolean = obj is DateField;
			if((obj.text!=null && StringUtil.trim(obj.text)!="") || isDate){
				if(obj is TextInput){
					var textinput:TextInput = obj as TextInput;
					if(textinput.name!=null&&textinput.name!=""&&textinput.name!='null'){
						json +="{";
						json +="\"name\":\""+textinput.name;
						json +="\",";
						json +="\"value\":\""+textinput.data.toString();
						json +="\"}";
						json+=",";
					}
					json +="{";
					json +="\"name\":\""+textinput.id;
					json +="\",";
					json +="\"value\":\""+textinput.text;
					json +="\"}";
					if(i<(count-1)){
						json+=",";
					}
					
				}else if(obj is ComboBox){
					var combobox:ComboBox = obj as ComboBox;
					if(combobox.selectedIndex != -1){
						json +="{";
						json +="\"name\":\""+combobox.id;
						json +="\",";
						json +="\"value\":\""+combobox.selectedItem.@label;
						json +="\"}";
						if(i<(count-1)){
							json+=",";
						}
					}
				}else if(obj is DateField){
					var date:DateField = obj as DateField;
					var str:String = date.id;
					var T:Boolean = false;
					if(str.indexOf('&')!=-1){
						T = true;
					}
					if(date!=null&&!T){
						var dateid:String = date.id+'&';
						var date1:DateField = getElementById(dateid,arrayList) as DateField;
						if(date.text!=null&&StringUtil.trim(date.text)!=""&&date1.text!=null&&StringUtil.trim(date1.text)!=""){
							json +="{";
							json +="\"name\":\""+date.id;
							json +="\",";
							json +="\"value\":\"to_date('"+date.text;
							json +="','YYYY-MM-DD')"+'&&'+"to_date('"+date1.text+"','YYYY-MM-DD')\"}";
						}else if((date.text==null||StringUtil.trim(date.text)=="")&&(date1.text!=null&&StringUtil.trim(date1.text)!="")){
							json +="{";
							json +="\"name\":\""+date.id;
							json +="\",";
							json +="\"value\":\"<=to_date('"+date1.text;
							json +="','YYYY-MM-DD')\"}";
						}else if((date1.text==null||StringUtil.trim(date1.text)=="")&&(date.text!=null&&StringUtil.trim(date.text)!="")){
							json +="{";
							json +="\"name\":\""+date.id;
							json +="\",";
							json +="\"value\":\">=to_date('"+date.text;
							json +="','YYYY-MM-DD')\"}";
						}
						if(i<(count-1)){
							json+=",";
						}
					}
				}else if(obj is TextArea){
					var textarea:TextArea = obj as TextArea;
					json +="{";
					json +="\"name\":\""+textarea.id;
					json +="\",";
					json +="\"value\":\""+textarea.text;
					json +="\"}";
					if(i<(count-1)){
						json+=",";
					}
				}
			}
		}
//		var str:String = json.substring(json.length-1);
//		if(str!=null&&str==","){
//			json = json.substring(0,json.length-1);
//		}
                json = removeLastComma(json);
		json+="]";
		this.dispatchEvent(new AutoGridEvent("searchEvent",json));
		MyPopupManager.removePopUp(this);
       }
       /**
	 *  删除最后的逗号 
	 */
       private function removeLastComma(jsonStr:String):String{
		var resultStr:String = jsonStr;
		if(null == resultStr || StringUtil.trim(resultStr) == ""){ 
			return resultStr;
		}else{
			var str:String;
			var length:int = resultStr.length;
			for(var i:int = length - 1; i>=0; i--){
				str = resultStr.charAt(i);
			    if(null != str && str == ","){
					resultStr = resultStr.substring(0,i);
			    }else{
                    break;					
 				}
			}
		}
		return resultStr;
	}

	
	public function resetValue():void{
		this.dispatchEvent(new Event("closeProperty"));
	}
	private var myTip:ToolTip;
	private var blnShowTip:Boolean=true;
	private function fnCreToolTip(e:ListEvent):void
	{
		var obj:ComboBox = e.currentTarget as ComboBox;
		switch(e.type)
		{
			case ListEvent.ITEM_ROLL_OVER:
			{
				if(blnShowTip){
					myTip = ToolTipManager.createToolTip(obj.dataProvider[e.rowIndex].@label,stage.mouseX+10,stage.mouseY) as ToolTip;
					blnShowTip = false;
				}else{
					ToolTipManager.destroyToolTip(myTip);
					myTip = ToolTipManager.createToolTip(obj.dataProvider[e.rowIndex].@label,stage.mouseX+10,stage.mouseY) as ToolTip;
				}
				
				break;
			}
			case ListEvent.ITEM_ROLL_OUT:
			{
				ToolTipManager.destroyToolTip(myTip);
				blnShowTip = true;
				break;
			}
			case ListEvent.CHANGE:
			{
				ToolTipManager.destroyToolTip(myTip);
				blnShowTip = true;
				break;
			}
				
		}
	}