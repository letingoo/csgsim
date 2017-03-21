package common.actionscript
{
	import common.actionscript.ModelLocator;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.FileReference;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Box;
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.ButtonBar;
	import mx.controls.ComboBox;
	import mx.controls.Image;
	import mx.controls.Spacer;
	import mx.controls.TextInput;
	import mx.controls.ToggleButtonBar;
	import mx.core.Application;
	import mx.core.Container;
	import mx.core.DragSource;
	import mx.core.IFlexDisplayObject;
	import mx.core.UIComponent;
	import mx.effects.AnimateProperty;
	import mx.effects.CompositeEffect;
	import mx.effects.Parallel;
	import mx.events.DragEvent;
	import mx.events.EffectEvent;
	import mx.events.ItemClickEvent;
	import mx.events.ListEvent;
	import mx.graphics.codec.PNGEncoder;
	import mx.managers.DragManager;
	import mx.managers.PopUpManager;
	import mx.messaging.channels.AMFChannel;
	import mx.messaging.channels.StreamingAMFChannel;
	import mx.printing.FlexPrintJob;
	import mx.printing.FlexPrintJobScaleType;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	import mx.utils.URLUtil;
	
	import twaver.*;
	import twaver.Alarm;
	import twaver.AlarmSeverity;
	import twaver.Collection;
	import twaver.Consts;
	import twaver.Group;
	import twaver.IAlarm;
	import twaver.ICollection;
	import twaver.IData;
	import twaver.IElement;
	import twaver.Node;
	import twaver.Styles;
	import twaver.Utils;
	import twaver.controls.Tree;
	import twaver.controls.TreeData;
	import twaver.network.Network;
	import twaver.network.Overview;
	import twaver.network.interaction.*;

	//AlarmImages
	public class DealAlarmUtil
	{
		
		public static var sdestination:String = "monitor";
		public static var smsgUrl:String;
		public static var streamingAMF:StreamingAMFChannel;
		public static var pollingAMF:AMFChannel;
		public static var consumers:Object;
		public static var titleWindow:ArrayCollection=new ArrayCollection();
		
		public static const DEFAULT_BUTTON_HEIGHT:int = 20;
		public static const DEFAULT_BUTTON_WIDTH:int = 28;
		
		public static var FLEX_SDK_VERSION:String;
		public static var FLASH_PLAYER_VERSION:String;
		
		public static var appconfig:XML = null
		public static var endpurl:String = ModelLocator.END_POINT;
		//public static var twaverLicense:String ="./org/bupt/initdata/license.xml";
		public static function createColor(r:int, g:int, b:int):int{
			return (r<<16)+(g<<8)+b;
		}
		
		public static function addButton(container:Container, name:String, icon:Class, f:Function, 
										 label:Boolean=false, maxWidth:Number = -1, space:Number = -1, height:int = -1):Button{
			var button:Button = new Button();
			if(f != null){
				button.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
					if(f.length == 0){
						f();
					}else{
						try{
							f(e);
						}catch(error:Error){
							f();
						}
					}
				});
			}
			if(icon != null){
				button.setStyle("icon", icon);
			}
			if(name != null){
				if(label || (icon==null)){
					button.label = name;
				}
				button.toolTip = name;
			}
			if(maxWidth > 0){
				button.maxWidth = maxWidth;
			}
			if(space > 0){
				var spacer:Spacer = new Spacer();
				spacer.width = space;
				container.addChild(spacer);
			}
			if(height<0){
				button.height = DEFAULT_BUTTON_HEIGHT;
			}else if(height>0){
				button.height = height;
			}
			if(icon && !label){
				button.width = DEFAULT_BUTTON_WIDTH;
			}
			if(container != null){
				container.addChild(button);
			}
			return button;
		}
		
		public static function addTextInput(container:Container, network:Network,label:Boolean=false,
											maxWidth:Number = -1, space:Number = -1, height:int = -1):TextInput{
			var button:RoundCornerTextInput = new RoundCornerTextInput();
			button.setStyle("icon",AlarmImages.search);
			if(maxWidth > 0){
				button.maxWidth = maxWidth;
			}
			if(space > 0){
				var spacer:Spacer = new Spacer();
				spacer.width = space;
				container.addChild(spacer);
			}
			if(height<0){
				button.height = DEFAULT_BUTTON_HEIGHT;
			}else if(height>0){
				button.height = height;
			}	
			button.width = DEFAULT_BUTTON_WIDTH*5;
			
			if(container != null){
				container.addChild(button);
			}
			button.addEventListener("textChanged", function():void{
				
				var box:ElementBox=network.elementBox;
				var finder:QuickFinder = new QuickFinder(box,"name",Consts.PROPERTY_TYPE_ACCESSOR);
				var ax:Array = finder.find(button.text.toString());
				for(var i:int=0;i<ax.length;i++)
				{     		
					var findie:IElement=ax[i] as IElement;
					network.selectionModel.setSelection(findie);
					network.makeVisibleOnSelected;
					findie.setStyle(Styles.VECTOR_FILL_COLOR,0x11ac26);
				}   
				
			});	
			return button;
		}
		
		public static function initTreeToolbar(toolbar:Box, tree:Tree):void{
			createButtonBar(toolbar, [
				createButtonInfo("Reset Order", AlarmImages.reset, function():void{
					tree.compareFunction = null;
				}),
				
				createButtonInfo("Descend Order", AlarmImages.descend, function():void{
					tree.compareFunction = function(d1:IData, d2:IData):int{
						if(d1.name < d2.name){
							return 1;
						}else if(d1.name == d2.name){
							return 0;
						}else{
							return -1;
						}
					};
					})
		], true);
					
					
					createButtonBar(toolbar, [
						createButtonInfo("Move Selection To Top", AlarmImages.top, function():void{
							tree.moveSelectionToTop();
						}),	
						createButtonInfo( "Move Selection Up", AlarmImages.up, function():void{
							tree.moveSelectionUp();
						}),
						createButtonInfo("Move Selection Down", AlarmImages.down, function():void{
							tree.moveSelectionDown();
						}),
						createButtonInfo("Move Selection To Bottom", AlarmImages.bottom, function():void{
							tree.moveSelectionToBottom();
						})
					]);
					
					createButtonBar(toolbar, [
						createButtonInfo("Expand", AlarmImages.expand, function():void{
							if(tree.selectionModel.count == 1){
								tree.expandData(tree.selectionModel.lastData, true);
							}else{
								tree.expandChildrenOf(tree.rootTreeData, true);	
							}				
							}),
							createButtonInfo("Collapse", AlarmImages.collapse, function():void{
								if(tree.selectionModel.count == 1){
									tree.collapse(tree.selectionModel.lastData, true);
								}else{
									tree.expandChildrenOf(tree.rootTreeData, false);	
								}				
							})]);
							} //end initTreeToolbar
							
							public static function initNetworkContextMenu(network:Network):void{
								network.contextMenu = new ContextMenu();
								network.contextMenu.hideBuiltInItems();														
							}
							
							public static function createDragAndDropButtonBar(toolbar:Box, buttonInfos:Array, showLabel:Boolean = false, perWidth:int = -1, height:int = -1, format:String = "twaverformat"):ButtonBar{
								var buttonBar:ButtonBar = createButtonBar(toolbar, buttonInfos, false, showLabel, perWidth, height);
								buttonBar.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void{
									if(e.target is Button){
										var button:Button = e.target as Button;
										var ds:DragSource = new DragSource();
										ds.addData(button, format);
										var dragImage:Image = null;
										var w:Number = 0, h:Number = 0;
										if(buttonBar.dataProvider is ArrayCollection){
											var index:int = buttonBar.getChildIndex(button);
											var item:* = (buttonBar.dataProvider as ArrayCollection).getItemAt(index);
											if(item){
												ds.addData(item, "data");
												dragImage = item.dragImage as Image;
												w = item.dragImageWidth;
												h = item.dragImageHeight;
											}
										}
										DragManager.doDrag(button, ds, e, dragImage, -e.localX+w/2, -e.localY+h/2);
									}
								});
								return buttonBar;
							} //end createDragAndDropButtonBar
							
							public static function createButtonBar(toolbar:Box, buttonInfos:Array, isToggleButtonBar:Boolean = false, showLabel:Boolean = false, perWidth:int = -1, height:int = -1):ButtonBar{
								var buttonBar:ButtonBar = isToggleButtonBar ? new ToggleButtonBar() : new ButtonBar();
								buttonBar.addEventListener(ItemClickEvent.ITEM_CLICK, function(e:ItemClickEvent):void{
									var button:* = e.item;
									if(button.click is Function){
										if((button.click as Function).length>0){
											try{
												button.click(e);
											}catch(error:Error){
												button.click();
											}
										}else{
											button.click();
										}
									}
								});
								buttonBar.dataProvider = buttonInfos;
								if(perWidth<0){
									perWidth = DEFAULT_BUTTON_WIDTH;
								}
								if(height<0){
									height = DEFAULT_BUTTON_HEIGHT;
								}
								if(!showLabel){
									buttonBar.width = buttonInfos.length*perWidth;
								}
								buttonBar.height = height;
								toolbar.addChild(buttonBar);
								return buttonBar;
							} //end createButton
							
							public static function createButtonInfo(name:String, icon:Class, click:Function):*{
								return {
									label:name,
									icon:icon,
									click:click
								};
							}
							
							public static function createElementButtonInfo(elementClass:Class, iconClass:Class, imageClass:Class=null, click:Function = null):*{
								if(elementClass == null){
									throw new ArgumentError("elementClass can't be null");
								}
								var label:* = (elementClass as Class).toString();
								var result:* = {
									label:label,
									icon:iconClass,
									click:click,
									elementClass:elementClass,
									type:"createElementButton"
								};
								imageClass = (imageClass == null ? iconClass : imageClass);
								if(imageClass){
									var dragImage:Image = new Image();
									dragImage.mouseChildren = false;
									dragImage.mouseEnabled = false;
									dragImage.source = imageClass;
									var bitmapData:BitmapData = new dragImage.source().bitmapData;
									result.dragImageWidth = bitmapData.width;
									result.dragImageHeight = bitmapData.height;
									result.dragImage = dragImage;
								}
								return result;
							}//createCreateElementButtonInfo
							
							public static function createNodeByButtonInfo(data:*):IElement{
								if(data.elementClass is Class){
									var node:IElement = new data.elementClass();
									node.name = data.label;
									return node;
								}
								return null;
							}
							
							public static function initTreeDragAndDropListener(tree:Tree, network:Network = null, dropedFunction:Function = null):void{
								tree.addEventListener(DragEvent.DRAG_ENTER,function(evt:DragEvent):void{
									if(evt.dragSource.hasFormat("twaverformat")){
										evt.preventDefault();
										DragManager.acceptDragDrop(tree);
									}
								});
								tree.addEventListener(DragEvent.DRAG_OVER,function(evt:DragEvent):void{
									if(evt.dragSource.hasFormat("twaverformat")){
										evt.preventDefault();
										DragManager.acceptDragDrop(tree);
									}
								});
								tree.addEventListener(DragEvent.DRAG_DROP,function (evt:DragEvent):void{
									var data:Object = evt.dragSource.dataForFormat("data");
									var dragImage:DisplayObject;
									var element:IElement;
									if(data){
										element = DealAlarmUtil.createNodeByButtonInfo(data);
										dragImage = data.dragImage;
									}else {
										return;
									}
									var index:int = tree.calculateDropIndex(evt);
									var treeData:TreeData = tree.getTreeDataByIndex(index);	
									if(element is Node && treeData != null && treeData.data is Group){
										Node(element).centerLocation = Group(treeData.data).centerLocation;
									}
									tree.dataBox.add(element);
									// set parent				
									if(treeData != null && treeData.data != null){
										element.parent = treeData.data;
									}else{
										if(network !=null){
											element.parent = network.currentSubNetwork;
										}
									} 
									
									if(dropedFunction!=null){
										dropedFunction(element);
									}
								});	
							} //end initTreeDragAndDropListener
							
							public static function initNetworkDragAndDropListener(network:Network, dropedFunction:Function = null):void{
								network.addEventListener(DragEvent.DRAG_ENTER,function(evt:DragEvent):void{
									if(evt.dragSource.hasFormat("twaverformat")){
										DragManager.acceptDragDrop(network);
									}
								});
								network.addEventListener(DragEvent.DRAG_DROP,function (evt:DragEvent):void{
									var centerLocation:Point = network.getLogicalPoint(evt);
									var element:IElement;
									var data:Object = evt.dragSource.dataForFormat("data");
									var dragImage:DisplayObject;
									if(data){
										element = DealAlarmUtil.createNodeByButtonInfo(data);
										dragImage = data.dragImage;
									}else {
										return;
									}
									if(element is Node){
										Node(element).centerLocation = centerLocation;
									}
									network.elementBox.add(element);
									
									// set parent
									var group:Group = null;
									if(element is Node && dragImage){
										Node(element).centerLocation = centerLocation;	
										var list:ICollection = network.getElementsByDisplayObject(dragImage);
										for(var i:int=0; i<list.count; i++){
											group = list.getItemAt(i) as Group;
											if(group != null){
												break;
											}
										}
									}
									if(group != null){
										element.parent = group;
									}else{
										element.parent = network.currentSubNetwork;
									}
									
									if(dropedFunction != null){
										if(dropedFunction.length == 0){
											dropedFunction();
										}else if(dropedFunction.length==1){
											dropedFunction(element);
										}else if(dropedFunction.length >1){
											dropedFunction(element, evt);
										}
									}
								});
							} //end initNetworkDragAndDropListener
							
							
							public static function initNetworkToolbar(toolbar:Box, network:Network, interaction:String = null, showLabel:Boolean = false, perWidth:int = -1, height:int = -1):void{
								toolbar.setStyle("horizontalGap", 4);
								if(perWidth<0){
									perWidth = DEFAULT_BUTTON_WIDTH;
								}
								if(height<0){
									height = DEFAULT_BUTTON_HEIGHT;
								}
								var ti:TextInput=addTextInput(toolbar,network); //增加搜索框
								var comboBox:ComboBox = addInteractionComboBox(toolbar, network, interaction, height);
								
								addButton(toolbar, "Default interaction", AlarmImages.select, network.setDefaultInteractionHandlers);
								createButtonBar(toolbar, [
									createButtonInfo("缩小", AlarmImages.zoomOut, function():void{network.zoomOut(true);}),
									createButtonInfo("放大", AlarmImages.zoomIn, function():void{network.zoomIn(true);}),
									createButtonInfo("还原", AlarmImages.zoomOverview, function():void{network.zoomReset(true);}),
									createButtonInfo("查看整图", AlarmImages.zoomReset, function():void{network.zoomOverview(true);})
								], false, showLabel, perWidth, height);
								
								createButtonBar(toolbar, [
									createButtonInfo("导出成图", AlarmImages.export,  function():void{
										var fr:Object = new FileReference();	
										if(fr.hasOwnProperty("save")){
											var bitmapData:BitmapData = network.exportAsBitmapData(); 
											var encoder:PNGEncoder = new PNGEncoder();
											var data:ByteArray = encoder.encode(bitmapData);
											fr.save(data, 'network.png');
										}else{
											Alert.show("install Flash Player 10 to run this feature", "Not Supported"); 
										}	
									}),
										createButtonInfo("打印", AlarmImages.print, function():void{
											var printJob:FlexPrintJob = new FlexPrintJob();              
											if (printJob.start()){
												var bitmapData:BitmapData = network.exportAsBitmapData(); 
												var component:UIComponent = new UIComponent();
												component.graphics.beginBitmapFill(bitmapData);
												component.graphics.drawRect(0, 0, bitmapData.width, bitmapData.height);
												component.graphics.endFill();
												component.width = bitmapData.width;
												component.height = bitmapData.height; 
												network.addChild(component);    
												try{
													printJob.printAsBitmap = true;
													printJob.addObject(component, FlexPrintJobScaleType.SHOW_ALL);						
												}
												catch (error:*){
													Alert.show(error, "Print Error"); 
												}
												printJob.send();
												network.removeChild(component);
											}			
										})	
			], false, showLabel, perWidth, height);
				//network.zoomOverview(true);	
				
			} //end initNetworkToolbar
										
										public static function addPrintButton(toolbar:Box, network:Network):Button{
											return addButton(toolbar, "Print...", AlarmImages.print, function():void{
												var printJob:FlexPrintJob = new FlexPrintJob();              
												if (printJob.start()){
													var bitmapData:BitmapData = network.exportAsBitmapData(); 
													var component:UIComponent = new UIComponent();
													component.graphics.beginBitmapFill(bitmapData);
													component.graphics.drawRect(0, 0, bitmapData.width, bitmapData.height);
													component.graphics.endFill();
													component.width = bitmapData.width;
													component.height = bitmapData.height; 
													network.addChild(component);    
													try{
														printJob.printAsBitmap = true;
														printJob.addObject(component, FlexPrintJobScaleType.SHOW_ALL);						
													}
													catch (error:*){
														Alert.show(error, "Print Error"); 
													}
													printJob.send();
													network.removeChild(component);
												}			
											});
										} //end addPrintButton
										
										public static function addExportButton(toolbar:Box, network:Network):Button{
											return addButton(toolbar, "Export Image", AlarmImages.export, function():void{
												var fr:Object = new FileReference();	
												if(fr.hasOwnProperty("save")){
													var bitmapData:BitmapData = network.exportAsBitmapData(); 
													var encoder:PNGEncoder = new PNGEncoder();
													var data:ByteArray = encoder.encode(bitmapData);
													fr.save(data, 'network.png');
												}else{
													Alert.show("install Flash Player 10 to run this feature", "Not Supported"); 
												}	
											});	
										}
										
										public static function addInteractionComboBox(toolbar:Box, network:Network, interaction:String = null, height:int = -1):ComboBox{
											var comboBox:ComboBox = new ComboBox();
											toolbar.addChild(comboBox);
											comboBox.dataProvider = ["鱼眼模式","放大镜模式","整图移动模式","只读模式"];
											comboBox.addEventListener(ListEvent.CHANGE, function(e:Event = null):void{
												var type:String = String(comboBox.selectedItem);
												if(type == "鱼眼模式"){
													network.interactionHandlers = new Collection([
														new SelectInteractionHandler(network),
														new EditInteractionHandler(network),
														new MoveInteractionHandler(network),
														new DefaultInteractionHandler(network),
														new MapFilterInteractionHandler(network),
													]);
												}
												else if(type == "放大镜模式"){
													network.interactionHandlers = new Collection([
														new SelectInteractionHandler(network),
														new EditInteractionHandler(network),
														new MoveInteractionHandler(network),
														new DefaultInteractionHandler(network),
														new MapFilterInteractionHandler(network, Consts.MAP_FILTER_MAGNIFY),
													]);
												}
												else if(type == "整图移动模式"){ 
													network.setPanInteractionHandlers();
												} 
												else if(type == "只读模式"){ 
													network.interactionHandlers = null;
												}							
											});
											if(interaction != null){
												comboBox.selectedItem = interaction;
												comboBox.dispatchEvent(new ListEvent("change"));
											}
											if(height<=0){
												height = DealAlarmUtil.DEFAULT_BUTTON_HEIGHT;
											}
											comboBox.height = height;
											return comboBox;
										} //end addInteractionComboBox
										
										public static function randomAlarm(alarmID:Object = null, elementID:Object = null, nonClearedSeverity:Boolean = false):IAlarm{
											var alarm:IAlarm = new Alarm(alarmID, elementID);
											alarm.acked = Utils.randomBoolean();
											alarm.cleared = Utils.randomBoolean();
											alarm.alarmSeverity = nonClearedSeverity ? Utils.randomNonClearedSeverity() : Utils.randomSeverity();
											alarm.setClient("raisedTime", new Date());
											return alarm;
										}
										
										public static function getConstsByPrefix(prefix:String):Array{
											var array:Array = new Array();
											var classInfo:XML = describeType(Consts);
											for each (var v:XML in classInfo..constant){
												var name:String = String(v.@name);
												if(name.indexOf(prefix) == 0){
													array.splice(array.length, 0, Consts[name]);
												}
											}
											return array;			
										}	
										
										/**
										 * 
										 * 动画功能
										 */
										private static function addAnimateProperty(effect:CompositeEffect, property:String, toValue:Number, isStyle:Boolean = true):AnimateProperty{
											var animateProperty:AnimateProperty = new AnimateProperty();
											animateProperty.isStyle = isStyle;
											animateProperty.property = property;
											animateProperty.toValue = toValue; 
											effect.addChild(animateProperty);
											return animateProperty;
										}
										
										/**
										 * 大纲眼图功能 
										 */								
										public static function addOverview(network:Network):void{
											var show:Parallel = new Parallel();
											show.duration = 250;
											addAnimateProperty(show, "alpha", 1, false);
											addAnimateProperty(show, "width", 100, false);
											addAnimateProperty(show, "height", 100, false);
											
											var hide:Parallel = new Parallel();
											hide.duration = 250;
											addAnimateProperty(hide, "alpha", 0, false);	
											addAnimateProperty(hide, "width", 0, false);
											addAnimateProperty(hide, "height", 0, false);
											
											var overview:Overview = new Overview();
											overview.visible = false;
											overview.width = 0;
											overview.height = 0;
											overview.backgroundColor = 0xAAAAAA;
											overview.backgroundAlpha = 0.7;
											overview.setStyle("right", 17);
											overview.setStyle("bottom", 17);
											overview.setStyle("showEffect", show);
											overview.setStyle("hideEffect", hide);
											
											var toggler:Button = new Button();
											toggler.width = 17;
											toggler.height = 17;
											toggler.setStyle("right", 0);
											toggler.setStyle("bottom", 0);
											toggler.setStyle("icon", AlarmImages.show);
											toggler.addEventListener(MouseEvent.CLICK, function(e:*):void{
												if(toggler.getStyle("icon") == AlarmImages.show){
													toggler.setStyle("icon", AlarmImages.hide);
													overview.network = network;
													overview.visible = true;
												}else{
													toggler.setStyle("icon", AlarmImages.show);
													overview.visible = false
												}					
											});	
											hide.addEventListener(EffectEvent.EFFECT_END, function(e:*):void{
												overview.network = null;
											});				
											network.parent.addChild(overview);
											network.parent.addChild(toggler);		
										}
										/**
										 * 设置弹出窗体最大化
										 * @param:childWind 弹出的子窗体
										 * @param:parent 父窗体
										 * @param:isMax 是否最大化
										 * @param:width 弹出窗体宽度
										 * @param:height 弹出窗体高度 
										 **/
										public static function PopWindowMaximise(childWind:IFlexDisplayObject,parent:DisplayObject,isMax:Boolean,width:int,height:int):void{
											
											PopUpManager.addPopUp(childWind,parent,true);
											if(isMax){
												childWind.width = width;
												childWind.height =height;
											}
											childWind.x=0;
											childWind.y=0;
										}
										/**
										 * 
										 * 复用段在拓扑图中定位
										 * @param:network:拓扑网络
										 * @param:equipName:设备名称
										 * 
										 * add by cl 2010-12-15
										 * */
										public static function topoNodePositioning(network:Network,equipName:String):void{
											var box:ElementBox=network.elementBox;
											var finder:QuickFinder = new QuickFinder(box,"name",Consts.PROPERTY_TYPE_ACCESSOR);
											var ax:Array = finder.find(equipName);
											for(var i:int=0;i<ax.length;i++)
											{     		
												var findie:IElement=ax[i] as IElement;
												findie.setStyle(Styles.SELECT_SHAPE,Consts.SHAPE_RECTANGLE);
												findie.setStyle(Styles.SELECT_DISTANCE,10);
												findie.setStyle(Styles.SELECT_COLOR,"0x4bf857");
												network.selectionModel.setSelection(findie);	
												network.makeVisibleOnSelected;
												
											} 
										}
										
										/**
										 * 
										 * 
										 * @param:network:拓扑网络
										 * @param:equipName:设备名称
										 * 
										 * add by cl 2010-12-15
										 * */
										public static function topoLinkPositioning(network:Network,layerID:String):void{
											var box:ElementBox=network.elementBox;
											var finder:QuickFinder = new QuickFinder(box,"layerID",Consts.PROPERTY_TYPE_ACCESSOR);
											var ax:Array = finder.find(layerID);
											
											for(var i:int=0;i<ax.length;i++)
											{     		
												var findie:IElement=ax[i] as IElement;
												findie.setStyle(Styles.SELECT_SHAPE,Consts.SHAPE_RECTANGLE);
												findie.setStyle(Styles.SELECT_DISTANCE,10);
												findie.setStyle(Styles.SELECT_COLOR,"0x4bf857");
												network.selectionModel.setSelection(findie);
												
												network.makeVisibleOnSelected;
												
											} 
										}
										/**
										 * 
										 * 
										 * */
										public static function addExceptionListener(remoteObject:RemoteObject):void{
											remoteObject.addEventListener(FaultEvent.FAULT,dealFault);
											
										}
										
										public static function getUrl():String{
											var url:String = Application.application.url;
											var port:int = URLUtil.getPort(url);
											var protocol:String = URLUtil.getProtocol(url);
											var serverName:String = URLUtil.getServerName(url);
											
											return protocol+"://"+serverName+":"+port+"/";
										
										}
										public static function initMessage():void{
											if(streamingAMF==null){
												smsgUrl = DealAlarmUtil.getUrl()+"adaptivemsg/";
												streamingAMF = new StreamingAMFChannel(smsgUrl+"my-streaming-amf",smsgUrl+"messagebroker/streamingamf");   
												pollingAMF = new AMFChannel(smsgUrl+"my-polling-amf", smsgUrl+"messagebroker/amfpolling");  
												consumers = new Object();
											}
										}
										
										public static function minimizeClickHandler(tw:TitleWindow):void {
											tw.width = 0;
											tw.height = 0;
											tw.x = 0;
											/*tw.y = screen.height;*/
											tw.y = 0;
										}

										
										
										// 错误处理
										public static function dealFault(event:FaultEvent):void {
											Alert.show(event.fault.toString());
											trace(event.fault);
										}
										
										} //end class
						}//end package