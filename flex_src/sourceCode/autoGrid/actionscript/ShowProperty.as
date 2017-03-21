	
    import com.adobe.serialization.json.JSON;
    
    import common.actionscript.ModelLocator;
    import common.actionscript.MyPopupManager;
    
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.net.getClassByAlias;
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
    import mx.formatters.DateFormatter;
    import mx.managers.PopUpManager;
    import mx.managers.ToolTipManager;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.remoting.mxml.RemoteObject;
    import mx.utils.ObjectUtil;
    
    import org.flexunit.runner.Result;
    
    import sourceCode.autoGrid.actionscript.AutoGridEvent;
    import sourceCode.autoGrid.view.TreeWindow;
    import sourceCode.systemManagement.views.comp.DeptTree;
	
	public var tablename:String;
	public var paraValue:String;
	public var key:String;
	public var propertyList:Array = new Array();
	private var obj_width:int = 180;
	[Bindable]public var boo:Boolean = true;
	private var ch_dayNames:Array = ['日','一','二','三','四','五','六'];
	private var ch_monthNames:Array = ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'];
	private var native_json:String;
	public var arrayList:Array;
	public var insertKey:String;
	public var objectValues:Object = new Object();
	public var isCheckTree:Boolean = false;
    public var isNeedCheck:Boolean = false;
	
	//and by xgyin
	public var isVisible = true;
 
    public var isSuperWide:Boolean = false;

    private var saveContent:String;
	[Bindable]public var isShowButton:Boolean = true;
	private var setValues:Object;
	private var obectArrays:Array;

    private static const TEXTAREA_HEIGHT_DEFAULT:int = 44;
    private static const TEXTAREA_HEIGHT:int = 200;
    private static const TEXTINPUT_HEIGHT_DEFAULT:int = 22;
    private static const SINGLE_COL_WINDOW_WIDTH:int = 500;
    private static const DOUBLE_COL_WINDOW_WIDTH:int = 640;
    private static const DOUBLE_COL_SUPER_WIDTH:int = 740;
	public function getSaveContent():String{
		return saveContent;
	}
	private function init():void
	{
		var showRT:RemoteObject = new RemoteObject("autoGrid");
		showRT.endpoint = ModelLocator.END_POINT;
		showRT.showBusyCursor = true;
		showRT.getShowProperty(tablename,null);//根据系统编码查询对应信息(所属系统)
		showRT.addEventListener(ResultEvent.RESULT,show);
	}
	
	private function show(event:ResultEvent):void{
		var textAreaCount:int = 0;
		var totalCount:int = 0;
		if(event.result!=null&&event.result.toString()!=""){
			arrayList = new Array();
			var obj:Array = JSON.decode(event.result.toString()) as Array;
			var content:String = "";
			obectArrays = new Array();
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
				totalCount = count;
				if(count<7){
//				    this.width = 320;
//					this.width = 470;
					obj_width = 300;
				}
//				else if(count>16){
////					this.height = 500;
//				}
				for(var i:int=0;i<count;i++){
					obectArrays.push(obj[i]);
					var formitem:FormItem = new FormItem();
					formitem.label = obj[i].text;
					if(obj[i].relate!=null&&obj[i].relate!=""&&obj[i].relate!='null'){
						flag = false;
						objectArray.push(obj[i]);
					}else{
						flag = true;
					}
					if(obj[i].isnull!=null&&obj[i].isnull=='N'){
						formitem.required = true;
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
						if(obj[i].iseditable!=null&&obj[i].iseditable=='N'&& paraValue != null && paraValue != ""){
							combox.editable = false;
							combox.enabled = textinput.editable;
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
						combox.addEventListener(DropdownEvent.CLOSE,function(event:DropdownEvent):void{
							if(null!=myTip)
								ToolTipManager.destroyToolTip(myTip);
							blnShowTip = true;
						});
						
					}else if(obj[i].type!=null&&obj[i].type=='DATEFIELD'){
						var datefile:DateField = new DateField();
						datefile.id = obj[i].id;
						if(obj[i].restrict!=null&&obj[i].restrict!=""&&obj[i].restrict!="null"){
							datefile.restrict = obj[i].restrict;
						}
						datefile.yearNavigationEnabled = true;
						datefile.dayNames=ch_dayNames;
						datefile.monthNames=ch_monthNames;
						datefile.showToday = true;
						if(obj[i].id =="UPDATEDATE"){
							datefile.formatString = "YYYY-MM-DD JJ:NN:SS";
							arrayList.push(datefile);
							content+=obj[i].id;//lian
						}else{
							datefile.formatString = "YYYY-MM-DD";
							arrayList.push(datefile);
							content+=obj[i].id;//lian
						}
						if(i<(count-1)){
							content+="@";
						}
						datefile.width = obj_width;
						formitem.addChild(datefile);
						if(obj[i].isvisible!=null&&obj[i].isvisible=='N'){
							formitem.visible = false;
							formitem.includeInLayout = formitem.visible;
							datefile.visible = formitem.visible;
							datefile.includeInLayout = formitem.visible;
						}
						if(obj[i].iseditable!=null&&obj[i].iseditable=='N'&& paraValue != null && paraValue != ""){
							datefile.editable = false;
							datefile.enabled = textinput.editable;
						}
						var format:DateFormatter=new DateFormatter();
						format.formatString="YYYY-MM-DD JJ:NN:SS";
						if (obj[i].id =="UPDATEDATE"){
							var date:Date=new Date();
							datefile.text=format.format(date);
							datefile.editable = false;
							datefile.enabled = false;
						}
					}else if(obj[i].type!=null&&obj[i].type=='TREE'){
						var textinput:TextInput = new TextInput();
						textinput.id = obj[i].id;
						formitem.toolTip = "单击输入框，弹出选择树！"
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
						if(obj[i].getrule!=null&&obj[i].getrule!=""&&obj[i].getrule!="null"){
							textinput.addEventListener(MouseEvent.CLICK,function(event:MouseEvent):void{
								var tx:TextInput = event.currentTarget as TextInput;
								var treeWin:TreeWindow = new TreeWindow();
								var sql:String = "";
								
								if(obectArrays!=null&&obectArrays.length>0){
									var count:int = obectArrays.length;
									for(var k:int=0;k<count;k++){
										if(obectArrays[k].id==tx.id){
											sql = obectArrays[k].getrule;
											treeWin.title =  obectArrays[k].text;
										}  
									}
								}
								treeWin.sql = sql;
								treeWin.isCheckBox = isCheckTree;
								treeWin.objName = tx;
								openTreeWindow(treeWin);
							});
						}else{
							textinput.addEventListener(MouseEvent.CLICK,function(event:MouseEvent):void{
								var tx:TextInput = event.currentTarget as TextInput;
								dispatchEvent(new AutoGridEvent("clickTree",tx));
							});
						}
					}else if(obj[i].type!=null&&obj[i].type=='DEPT'){
						var textinput:TextInput = new TextInput();
						formitem.toolTip = "单击输入框，弹出选择树！"
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
						textAreaCount++;
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
						//设置textarea 高度
						if(count < 7){
						    textarea.height = TEXTAREA_HEIGHT;  //
						}
						formitem.addChild(textarea);
						if(obj[i].isvisible!=null&&obj[i].isvisible=='N'){
							formitem.visible = false;
							formitem.includeInLayout = formitem.visible;
							textarea.visible = formitem.visible;
							textarea.includeInLayout = formitem.visible;
						}
						if(obj[i].iseditable!=null&&obj[i].iseditable=='N'){
							textarea.editable = false;
							textarea.enabled = textarea.editable;
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
						if(obj[i].iseditable!=null&&obj[i].iseditable=='N'){
							if ( paraValue == null || paraValue == ""){
								if (obj[i].id =="UPDATEPERSON"){
									textinput.text=this.parentApplication.curUser;
									textinput.editable = false;
									textinput.enabled = false;
								}
							}else{
								textinput.editable = false;
								textinput.enabled = textinput.editable;
							}
							
						}
//						if(obj[i].iseditable!=null&&obj[i].iseditable=='N'&& paraValue != null && paraValue != ""){
//							textinput.editable = false;
//							textinput.enabled = textinput.editable;
//						}
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
					if(count<7){
						form.addChild(formitem);
						propertychild.addChild(form);
						property.addChild(propertychild);
					}else{
						if(judgeIsEvenNumber(count)){
							if(i<=(count/2-1)){
								form.addChild(formitem);
								propertychild.addChild(form);
								property.addChild(propertychild);
								
							}else{
								form1.addChild(formitem);
								propertychild.addChild(form1);
								property.addChild(propertychild);
							}
						}else{
							if(i<=(count/2)){
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
				if(isShowButton){
					var hboxbutton:HBox = new HBox();
					hboxbutton.percentWidth = 100;
					hboxbutton.percentHeight = 18;
					hboxbutton.styleName = 'HBoxButton';
					hboxbutton.setStyle("horizontalAlign","center");
					var button:Button = new Button();
					button.id = 'save';
					button.visible = boo;
					button.label = '保存';
					button.visible = isVisible;
					button.width = 80;
					button.styleName='loginprimary';
					button.addEventListener(MouseEvent.CLICK,function(event:Event):void{
						saveContent = content;
					   if(isNeedCheck){
						   dispatchEvent(new Event("checkEvent"));
					   }else{
						   save(content,arrayList);
					   }
					});
					//button.enabled  = Application.application.isEdit;
					var button2:Button = new Button();
					button2.id = 'cancel';
					button2.visible = boo;
					button2.label = '关闭';
					button2.width = 80;
					button2.styleName='loginsecondary';
					button2.addEventListener(MouseEvent.CLICK,function (event:Event):void{
						close();
					});
					//button2.enabled  = Application.application.isEdit;
					var spacer:Spacer = new Spacer();
					spacer.width = 10;
					if(isVisible){
						hboxbutton.addChild(button);
						hboxbutton.addChild(spacer);
						hboxbutton.addChild(button2);
					}
					else{
						hboxbutton.addChild(button2);
					}
					property.addChild(hboxbutton);
				}
			}
			propertyList = new Array();
			propertyList = arrayList;
			var setValueRT:RemoteObject = new RemoteObject("autoGrid");
			setValueRT.endpoint = ModelLocator.END_POINT;
			setValueRT.showBusyCursor = true; 
			setValueRT.setPropertyValue(tablename,content,key,paraValue);
			setValueRT.addEventListener(ResultEvent.RESULT,function (event:ResultEvent):void{
				setPropertyValue(event,content,arrayList);
			});
		}
		
		if(isSuperWide){
		    this.width = (totalCount<7)? SINGLE_COL_WINDOW_WIDTH:DOUBLE_COL_SUPER_WIDTH;
		}else{
		    this.width = (totalCount<7)? SINGLE_COL_WINDOW_WIDTH:DOUBLE_COL_WINDOW_WIDTH;
		}
		//设置窗体高度   高度=(间隙高度+textinput框高*个数+textarea框高*个数+按钮区域高度)
		if(totalCount<7){
			this.height = (totalCount -1)*4 + (totalCount - textAreaCount)*TEXTINPUT_HEIGHT_DEFAULT 
				                            + textAreaCount*TEXTAREA_HEIGHT + 130;
		}else{
		    textAreaCount = (textAreaCount%2) == 0 ? (textAreaCount/2) : (textAreaCount/2+1);
			this.height = (totalCount/2 -1)*4 + (totalCount/2 - textAreaCount)*TEXTINPUT_HEIGHT_DEFAULT 
				                              + (textAreaCount/2)*TEXTAREA_HEIGHT_DEFAULT + 160; 			
		}
	}
	
    private function UniqueFunction(str:String):void{
		Alert.show(str);
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
	private function setPropertyValue(event:ResultEvent,content:String,arrayList:Array):void{
		
		if(event.result!=null&&event.result.toString()!=""){
			var json:Object = JSON.decode(event.result.toString());
			native_json = event.result.toString();
			setValues = new Object();
			setValues = json;
			if(json!=null){
				
				var count:int = arrayList.length;
				for(var i:int=0;i<count;i++){
					var obj:Object = arrayList[i] as Object;
					if(obj is TextInput){
						var textinput:TextInput = obj as TextInput;
						if(textinput.name!=null&&textinput.name!=""&&textinput.name!='null'){
							var name:String = textinput.name.toString();
							textinput.data = json[textinput.name];
						}
						var str:String = textinput.id;
						textinput.text = json[str];
						if(textinput.id=="UPDATEPERSON"){
							textinput.text = this.parentApplication.curUser;
						}
					}else if(obj is TextArea){
						var textarea:TextArea = obj as TextArea;
						if(textarea.name!=null&&textarea.name!=""&&textarea.name!='null'){
							var name:String = textarea.name.toString();
							textinput.data = json[textarea.name];
						}
						var str:String = textarea.id;
						textarea.text = json[str];
					}
					else if(obj is ComboBox){
						var combox:ComboBox = obj as ComboBox;
						var str:String = combox.id;
						for each(var element:XML in combox.dataProvider){
							if(element.@label==json[str]||element.@code==json[str]){
								combox.selectedItem=element as Object;
								break
							}
						}
					}else if(obj is DateField){
						var datefield:DateField = obj as DateField;
						var str:String = datefield.id;
						datefield.text = json[str]; 
						if(datefield.id=="UPDATEDATE"){
							var now:Date = new Date();
							var dateFormatter:DateFormatter = new DateFormatter();  
							dateFormatter.formatString = "YYYY-MM-DD JJ:NN:SS";
							datefield.text = dateFormatter.format(now);
						}
					}
				}
			}
		}
		
		dispatchEvent(new Event("initFinished"));
		
	}
	
	
	
	private function close():void  
	{  
		resetValue();
		MyPopupManager.removePopUp(this);
	}
	//添加局站信息
	public function save(content:String,arrayList:Array):void  
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
			if(object is FormItem){
				var formitem:FormItem = object as FormItem;
				if(formitem.required&&obj.id!=key&&obj.name!=key){
					if(obj.text==null||obj.text==""){
						obj.setFocus();
						Alert.show(formitem.label+"不能为空！","提示");
						return;
					}
				}
			}
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
					json +="\"value\":\""+combobox.selectedItem.@code;
					json +="\"}";
					if(i<(count-1)){
						json+=",";
					}
				}
			}else if(obj is DateField){
				var date:DateField = obj as DateField;
				if(date.id == "UPDATEDATE"){
					json +="{";
					json +="\"name\":\""+date.id;
					json +="\",";
					json +="\"value\":\"to_date('"+date.text;
					json +="','YYYY-MM-DD hh24:mi:ss')\"}";
				}else{
					json +="{";
					json +="\"name\":\""+date.id;
					json +="\",";
					json +="\"value\":\"to_date('"+date.text;
					json +="','YYYY-MM-DD')\"}";
				}
				if(i<(count-1)){
					json+=",";
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
		json+="]";
		if(paraValue!=null&&paraValue!="")
			saveValueRT.savePropertyValue(tablename,key,paraValue,json,native_json);
		else
			saveValueRT.insertPropertyValue(tablename,key,paraValue,json,native_json);
		saveValueRT.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
			if(event.result!=null && "" != event.result){
				Alert.show("保存成功！","提示");
				insertKey = event.result.toString();
			}else{
				Alert.show("保存失败！","提示");
			}
			dispatchEvent(new Event("savePropertyComplete"));
		});
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
   private function judgeIsEvenNumber(num:int):Boolean{
      var T:Boolean = false;
	   if(num%2==0){
	      T = true;
	  }else{
	     T = false;
	  }
	  return T;
   }