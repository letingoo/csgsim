package twaver{
	
	import common.actionscript.CustomInteractionHandler;
	
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
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.ButtonBar;
	import mx.controls.ComboBox;
	import mx.controls.Image;
	import mx.controls.Spacer;
	import mx.controls.ToggleButtonBar;
	import mx.core.Container;
	import mx.core.DragSource;
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
	import mx.printing.FlexPrintJob;
	import mx.printing.FlexPrintJobScaleType;
	
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
	
	public class DemoUtils{
		
		public static const DEFAULT_BUTTON_HEIGHT:int = 20;
		public static const DEFAULT_BUTTON_WIDTH:int = 28;
		
		public static var FLEX_SDK_VERSION:String;
		public static var FLASH_PLAYER_VERSION:String;
		
		public static var statesXML:XML = null;
		public static var demoTree:Tree = null;		
		
		[Embed(source='assets/ttf/Helvetica.ttf',
				fontName="demoFont",
				advancedAntiAliasing="false",
				mimeType="application/x-font")]
		private var demoFont:Class;
		
		
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
		
		public static function initTreeToolbar(toolbar:Box, tree:Tree):void{
			createButtonBar(toolbar, [
				createButtonInfo("Reset Order", DemoImages.reset, function():void{
					tree.compareFunction = null;
				}),
				createButtonInfo( "Ascend Order", DemoImages.ascend, function():void{
					tree.compareFunction = function(d1:IData, d2:IData):int{
						if(d1.name > d2.name){
							return 1;
						}else if(d1.name == d2.name){
							return 0;
						}else{
							return -1;
						}
					};
					}),
					createButtonInfo("Descend Order", DemoImages.descend, function():void{
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
						createButtonInfo("Move Selection To Top", DemoImages.top, function():void{
							tree.moveSelectionToTop();
						}),	
						createButtonInfo( "Move Selection Up", DemoImages.up, function():void{
							tree.moveSelectionUp();
						}),
						createButtonInfo("Move Selection Down", DemoImages.down, function():void{
							tree.moveSelectionDown();
						}),
						createButtonInfo("Move Selection To Bottom", DemoImages.bottom, function():void{
							tree.moveSelectionToBottom();
						})
					]);
					
					createButtonBar(toolbar, [
						createButtonInfo("Expand", DemoImages.expand, function():void{
							if(tree.selectionModel.count == 1){
								tree.expandData(tree.selectionModel.lastData, true);
							}else{
								tree.expandChildrenOf(tree.rootTreeData, true);	
							}				
							}),
							createButtonInfo("Collapse", DemoImages.collapse, function():void{
								if(tree.selectionModel.count == 1){
									tree.collapse(tree.selectionModel.lastData, true);
								}else{
									tree.expandChildrenOf(tree.rootTreeData, false);	
								}				
							})]);
							}
							
							public static function initNetworkContextMenu(network:Network,flag:String):void{
								network.contextMenu = new ContextMenu();
								network.contextMenu.hideBuiltInItems();	
								
								var handler:Function = function(e:ContextMenuEvent):void{
									var i:int = 0;
									var element:IElement = null;
									var severity:AlarmSeverity = Utils.randomNonClearedSeverity();
									var item:ContextMenuItem = ContextMenuItem(e.target);
									if(item.caption == "Remove Selection"){
										network.removeSelection();					
									}
									else if(item.caption == "Random Inner Color"){
										for(i=0; i<network.selectionModel.selection.count; i++){
											element = network.selectionModel.selection.getItemAt(i);
											if(element.getStyle(Styles.INNER_COLOR) == null){
												element.setStyle(Styles.INNER_COLOR, Utils.randomColor());
											}else{
												element.setStyle(Styles.INNER_COLOR, null);
											}																
										}
									}
									else if(item.caption == "Random Outer Color"){
										for(i=0; i<network.selectionModel.selection.count; i++){
											element = network.selectionModel.selection.getItemAt(i);
											if(element.getStyle(Styles.OUTER_COLOR) == null){
												element.setStyle(Styles.OUTER_COLOR, Utils.randomColor());
											}else{
												element.setStyle(Styles.OUTER_COLOR, null);
											}																
										}
									}
									else{
										for(i=0; i<network.selectionModel.selection.count; i++){
											element = network.selectionModel.selection.getItemAt(i);
											if(item.caption == "Add New Alarm"){
												element.alarmState.increaseNewAlarm(severity);
											}
											else if(item.caption == "Add Acked Alarm"){
												element.alarmState.increaseAcknowledgedAlarm(severity);
											}
											else{
												element.alarmState.clear();
											}																	
										}					
									}
								}; 
								//			if(flag==null){
								//			network.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, function(e:ContextMenuEvent):void{
								//				var flexVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLEX_SDK_VERSION, false, false);
								//            	var playerVersion:ContextMenuItem = new ContextMenuItem(DemoUtils.FLASH_PLAYER_VERSION, false, false);
								//				
								//	        	if(network.selectionModel.count == 0){
								//	        		network.contextMenu.customItems = [flexVersion, playerVersion];
								//	        	}else{
								//	        		var item1:ContextMenuItem = new ContextMenuItem("设备面板图", true);
								//	        		item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handler);
								//					var item2:ContextMenuItem = new ContextMenuItem("设备业务", true);
								//					item2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handler);
								//					var item3:ContextMenuItem = new ContextMenuItem("设备告警", true);
								//					item3.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handler);
								//	        		           		
								//	        		network.contextMenu.customItems = [flexVersion, playerVersion, item1, item2, item3];        		
								//	        	}		        			
								//			});	
								//			}
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
							}
							
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
							}
							
							public static function createButtonInfo(name:String, icon:Class, click:Function):*{
								return {
									label:name,
									icon:icon,
									click:click
								};
							}
							
							public static function createCreateElementButtonInfo(elementClass:Class, iconClass:Class, imageClass:Class=null, click:Function = null):*{
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
							}
							
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
										element = DemoUtils.createNodeByButtonInfo(data);
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
							}
							
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
										element = DemoUtils.createNodeByButtonInfo(data);
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
							}

							 						
							public  function reSetFontSize(network:Network):void{
								var zoom:Number=network.zoom;
								var fontsize:int=20; //字号	
								if(zoom<=1.0){
									fontsize=parseInt((fontsize/zoom).toString());
									Alert.show(fontsize.toString());
									var count:int=network.elementBox.datas.count;
									for(var i:int=0;i<count;i++){				
										(network.elementBox.datas.getItemAt(i) as Element).setStyle(Styles.LABEL_SIZE,fontsize);
									}
								}
							}								
							
							public static function initNetworkToolbarForSysGraph(toolbar:Box, network:Network, interaction:String = null, showLabel:Boolean = false, perWidth:int = -1, height:int = -1):void{
								toolbar.setStyle("horizontalGap", 4);
								if(perWidth<0){
									perWidth = DEFAULT_BUTTON_WIDTH;
								}
								if(height<0){
									height = DEFAULT_BUTTON_HEIGHT;
								}
								
								//	addButton(toolbar, "默认设置", DemoImages.select, network.setDefaultInteractionHandlers);
								
								createButtonBar(toolbar, [
				createButtonInfo("默认模式", DemoImages.select, function():void{
										network.interactionHandlers=new Collection([  
											new CustomInteractionHandler(network),  
											new MoveInteractionHandler(network),
											new DefaultInteractionHandler(network),]);
											comboBox.selectedItem = "默认模式";
				}),
									createButtonInfo("放大", DemoImages.zoomIn, function():void{
										network.zoomIn(true);
//										Alert.show(network.zoom.toString());
										
										var zoom:Number=network.zoom;
										var fontsize:int=10; //字号	
										if(zoom<1.0){
//											network.zoomIn(false);	
											fontsize=parseInt((fontsize/zoom).toString());
//											Alert.show(fontsize.toString());
											var count:int=network.elementBox.datas.count;
											for(var i:int=0;i<count;i++){				
												(network.elementBox.datas.getItemAt(i) as Element).setStyle(Styles.LABEL_SIZE,fontsize);  
											}
										}											
									}),
									createButtonInfo("缩小", DemoImages.zoomOut, function():void{
										network.zoomOut(true);
//										Alert.show(network.zoom.toString());
										
										var zoom:Number=network.zoom;
										var fontsize:int=17; //字号	
										if(zoom>0.36){
//											network.zoomOut(false); 
											fontsize=parseInt((fontsize/zoom).toString());
//											Alert.show(fontsize.toString());
											var count:int=network.elementBox.datas.count;
											for(var i:int=0;i<count;i++){				
												(network.elementBox.datas.getItemAt(i) as Element).setStyle(Styles.LABEL_SIZE,fontsize);  
											}
										}										
									}),
									createButtonInfo("重置", DemoImages.zoomReset, function():void{
										network.zoomReset(true);
										var fontsize:int=12; //字号	
										fontsize=parseInt((fontsize/1).toString());		
										var count:int=network.elementBox.datas.count; 
										for(var i:int=0;i<count;i++){				
											(network.elementBox.datas.getItemAt(i) as Element).setStyle(Styles.LABEL_SIZE,fontsize);  
										}									
									
									}),
									createButtonInfo("全局预览", DemoImages.zoomOverview, function():void{network.zoomOverview(true);})
								], false, showLabel, perWidth, height);
								
								createButtonBar(toolbar, [
									createButtonInfo("导出图片", DemoImages.export,  function():void{
										var fr:Object = new FileReference();	
										if(fr.hasOwnProperty("save")){
											var bitmapData:BitmapData = network.exportAsBitmapData(); 
											var encoder:PNGEncoder = new PNGEncoder();
											var data:ByteArray = encoder.encode(bitmapData);
											fr.save(data, 'network.png');
										}else{
											Alert.show("install Flash Player 10 to run this feature", "Not Supported"); 
										}	
									})
										//					createButtonInfo("打印...", DemoImages.print, function():void{
										//						var printJob:FlexPrintJob = new FlexPrintJob();              
										//						if (printJob.start()){
										//							var bitmapData:BitmapData = network.exportAsBitmapData(); 
										//							var component:UIComponent = new UIComponent();
										//							component.graphics.beginBitmapFill(bitmapData);
										//							component.graphics.drawRect(0, 0, bitmapData.width, bitmapData.height);
										//							component.graphics.endFill();
										//							component.width = bitmapData.width;
										//							component.height = bitmapData.height; 
										//							network.addChild(component);    
										//							try{
										//								printJob.printAsBitmap = true;
										//								printJob.addObject(component, FlexPrintJobScaleType.SHOW_ALL);						
										//							}
										//							catch (error:*){
										//								Alert.show(error, "Print Error"); 
										//							}
										//							printJob.send();
										//							network.removeChild(component);
										//						}			
										//					})
										
			], false, showLabel, perWidth, height);					
										var comboBox:ComboBox = addInteractionComboBox(toolbar, network, interaction, height);	
										}
										public static function initNetworkToolbar(toolbar:Box, network:Network, interaction:String = null, showLabel:Boolean = false, perWidth:int = -1, height:int = -1):void{
											toolbar.setStyle("horizontalGap", 4);
											if(perWidth<0){
												perWidth = DEFAULT_BUTTON_WIDTH;
											}
											if(height<0){
												height = DEFAULT_BUTTON_HEIGHT;
											}
											
											//	addButton(toolbar, "默认设置", DemoImages.select, network.setDefaultInteractionHandlers);
											
											createButtonBar(toolbar, [
												createButtonInfo("默认模式", DemoImages.select, function():void{
													network.interactionHandlers=new Collection([  
														
														new CustomInteractionHandler(this),  
														
														new DefaultInteractionHandler(network),]); }),
												createButtonInfo("放大", DemoImages.zoomIn, function():void{network.zoomIn(true);}),
												createButtonInfo("缩小", DemoImages.zoomOut, function():void{network.zoomOut(true);}),
												createButtonInfo("重置", DemoImages.zoomReset, function():void{network.zoomReset(true);}),
												createButtonInfo("全局预览", DemoImages.zoomOverview, function():void{network.zoomOverview(true);})
											], false, showLabel, perWidth, height);
											
											createButtonBar(toolbar, [
												createButtonInfo("导出图片", DemoImages.export,  function():void{
													var fr:Object = new FileReference();	
													if(fr.hasOwnProperty("save")){
														var bitmapData:BitmapData = network.exportAsBitmapData(); 
														var encoder:PNGEncoder = new PNGEncoder();
														var data:ByteArray = encoder.encode(bitmapData);
														fr.save(data, 'network.png');
													}else{
														Alert.show("install Flash Player 10 to run this feature", "Not Supported"); 
													}	
												})
													//				createButtonInfo("打印...", DemoImages.print, function():void{
													//					var printJob:FlexPrintJob = new FlexPrintJob();              
													//					if (printJob.start()){
													//						var bitmapData:BitmapData = network.exportAsBitmapData(); 
													//						var component:UIComponent = new UIComponent();
													//						component.graphics.beginBitmapFill(bitmapData);
													//						component.graphics.drawRect(0, 0, bitmapData.width, bitmapData.height);
													//						component.graphics.endFill();
													//						component.width = bitmapData.width;
													//						component.height = bitmapData.height; 
													//						network.addChild(component);    
													//						try{
													//							printJob.printAsBitmap = true;
													//							printJob.addObject(component, FlexPrintJobScaleType.SHOW_ALL);						
													//						}
													//						catch (error:*){
													//							Alert.show(error, "Print Error"); 
													//						}
													//						printJob.send();
													//						network.removeChild(component);
													//					}			
													//				})
													
			], false, showLabel, perWidth, height);
													
													var comboBox:ComboBox = addInteractionComboBox(toolbar, network, interaction, height);
													}
													
													
													public static function initNetworkToolbarForWireConfig(toolbar:Box, network:Network, interaction:String = null, showLabel:Boolean = false, perWidth:int = -1, height:int = -1):void{
														toolbar.setStyle("horizontalGap", 4);
														if(perWidth<0){
															perWidth = DEFAULT_BUTTON_WIDTH;
														}
														if(height<0){
															height = DEFAULT_BUTTON_HEIGHT;
														}
														
														//	addButton(toolbar, "默认设置", DemoImages.select, network.setDefaultInteractionHandlers);
														
														createButtonBar(toolbar, [
															createButtonInfo("默认模式", DemoImages.select, function():void{
																network.interactionHandlers=new Collection([  
																	
																	new CustomInteractionHandler(network),  
																	new MoveInteractionHandler(network),
																	new DefaultInteractionHandler(network),]); }),
															createButtonInfo("放大", DemoImages.zoomIn, function():void{network.zoomIn(true);}),
															createButtonInfo("缩小", DemoImages.zoomOut, function():void{network.zoomOut(true);}),
															createButtonInfo("重置", DemoImages.zoomReset, function():void{network.zoomReset(true);}),
															createButtonInfo("全局预览", DemoImages.zoomOverview, function():void{network.zoomOverview(true);})
														], false, showLabel, perWidth, height);
														
														createButtonBar(toolbar, [
															createButtonInfo("导出图片", DemoImages.export,  function():void{
																var fr:Object = new FileReference();	
																if(fr.hasOwnProperty("save")){
																	var bitmapData:BitmapData = network.exportAsBitmapData(); 
																	var encoder:PNGEncoder = new PNGEncoder();
																	var data:ByteArray = encoder.encode(bitmapData);
																	fr.save(data, 'network.png');
																}else{
																	Alert.show("install Flash Player 10 to run this feature", "Not Supported"); 
																}	
															})
																//				createButtonInfo("打印...", DemoImages.print, function():void{
																//					var printJob:FlexPrintJob = new FlexPrintJob();              
																//					if (printJob.start()){
																//						var bitmapData:BitmapData = network.exportAsBitmapData(); 
																//						var component:UIComponent = new UIComponent();
																//						component.graphics.beginBitmapFill(bitmapData);
																//						component.graphics.drawRect(0, 0, bitmapData.width, bitmapData.height);
																//						component.graphics.endFill();
																//						component.width = bitmapData.width;
																//						component.height = bitmapData.height; 
																//						network.addChild(component);    
																//						try{
																//							printJob.printAsBitmap = true;
																//							printJob.addObject(component, FlexPrintJobScaleType.SHOW_ALL);						
																//						}
																//						catch (error:*){
																//							Alert.show(error, "Print Error"); 
																//						}
																//						printJob.send();
																//						network.removeChild(component);
																//					}			
																//				})
																
			], false, showLabel, perWidth, height);
			}	
																
																public static function initNetworkToolbarLite(toolbar:Box, network:Network, interaction:String = null, showLabel:Boolean = false, perWidth:int = -1, height:int = -1):void
																{
																	toolbar.setStyle("horizontalGap", 4);
																	if(perWidth<0){
																		perWidth = DEFAULT_BUTTON_WIDTH;
																	}
																	if(height<0){
																		height = DEFAULT_BUTTON_HEIGHT;
																	}
																	
																	//	addButton(toolbar, "默认设置", DemoImages.select, network.setDefaultInteractionHandlers);
																	
																	createButtonBar(toolbar, [
																		createButtonInfo("默认模式", DemoImages.select, function():void{
																			network.interactionHandlers=new Collection([  
																				
																				new CustomInteractionHandler(network),  
																				new MoveInteractionHandler(network),
																				new DefaultInteractionHandler(network),]); }),
																		createButtonInfo("放大", DemoImages.zoomIn, function():void{network.zoomIn(true);}),
																		createButtonInfo("缩小", DemoImages.zoomOut, function():void{network.zoomOut(true);}),
																		createButtonInfo("重置", DemoImages.zoomReset, function():void{network.zoomReset(true);}),
																		createButtonInfo("全局预览", DemoImages.zoomOverview, function():void{network.zoomOverview(true);})
																	], false, showLabel, perWidth, height);
																	
																	createButtonBar(toolbar, [
																		createButtonInfo("导出图片", DemoImages.export,  function():void{
																			var fr:Object = new FileReference();	
																			if(fr.hasOwnProperty("save")){
																				var bitmapData:BitmapData = network.exportAsBitmapData(); 
																				var encoder:PNGEncoder = new PNGEncoder();
																				var data:ByteArray = encoder.encode(bitmapData);
																				fr.save(data, 'network.png');
																			}else{
																				Alert.show("install Flash Player 10 to run this feature", "Not Supported"); 
																			}	
																		})
																			//						createButtonInfo("打印...", DemoImages.print, function():void{
																			//							var printJob:FlexPrintJob = new FlexPrintJob();              
																			//							if (printJob.start()){
																			//								var bitmapData:BitmapData = network.exportAsBitmapData(); 
																			//								var component:UIComponent = new UIComponent();
																			//								component.graphics.beginBitmapFill(bitmapData);
																			//								component.graphics.drawRect(0, 0, bitmapData.width, bitmapData.height);
																			//								component.graphics.endFill();
																			//								component.width = bitmapData.width;
																			//								component.height = bitmapData.height; 
																			//								network.addChild(component);    
																			//								try{
																			//									printJob.printAsBitmap = true;
																			//									printJob.addObject(component, FlexPrintJobScaleType.SHOW_ALL);						
																			//								}
																			//								catch (error:*){
																			//									Alert.show(error, "Print Error"); 
																			//								}
																			//								printJob.send();
																			//								network.removeChild(component);
																			//							}			
																			//						})
																			
			], false, showLabel, perWidth, height);
				
				//						var comboBox:ComboBox = addInteractionComboBox(toolbar, network, interaction, height);
			}
																			
																			public static function addPrintButton(toolbar:Box, network:Network):Button{
																				return addButton(toolbar, "Print...", DemoImages.print, function():void{
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
																			}
																			
																			public static function addExportButton(toolbar:Box, network:Network):Button{
																				return addButton(toolbar, "Export Image", DemoImages.export, function():void{
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
																				comboBox.name="模式";
																				toolbar.addChild(comboBox);
																				comboBox.dataProvider = ["默认模式","放大镜模式"];
																				
																				comboBox.addEventListener(ListEvent.CHANGE, function(e:Event = null):void{
																					var type:String = String(comboBox.selectedItem);
																					
																					if(type == "默认模式"){
																						network.interactionHandlers=new Collection([  
																							
																							new CustomInteractionHandler(network),  
																							new MoveInteractionHandler(network),
																							new DefaultInteractionHandler(network),]); 
																						//network.setDefaultInteractionHandlers();
																					}
																					else if(type == "默认延迟模式"){
																						network.setDefaultInteractionHandlers(true);
																					}
																					else if(type == "编辑模式"){
																						network.setEditInteractionHandlers();
																					}
																					else if(type == "编辑延迟模式"){
																						network.setEditInteractionHandlers(true);
																					}
																					else if(type == "鱼眼模式"){
																						network.interactionHandlers = new Collection([
																							new SelectInteractionHandler(network),
																							new EditInteractionHandler(network),
																							new MoveInteractionHandler(network),
																							new DefaultInteractionHandler(network),
																							new MapFilterInteractionHandler(network),
																						]);
																					}
																					else if(type == "放大镜模式")
																					{
																						network.interactionHandlers = new Collection([
																							new SelectInteractionHandler(network),
																							new MoveInteractionHandler(network),
																							new DefaultInteractionHandler(network),
																							new MapFilterInteractionHandler(network, Consts.MAP_FILTER_MAGNIFY),
																						]);
																					}
																					else if(type == "无")
																					{ 
																						network.interactionHandlers = null;
																					}	
																					
																				});
																				if(interaction != null){
																					comboBox.selectedItem = interaction;				
																					comboBox.dispatchEvent(new ListEvent("change"));
																				}
																				if(height<=0){
																					height = DemoUtils.DEFAULT_BUTTON_HEIGHT;
																				}
																				comboBox.height = height;
																				return comboBox;
																			}
																			
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
																			
																			public static function addAnimateProperty(effect:CompositeEffect, property:String, toValue:Number, isStyle:Boolean = true):AnimateProperty{
																				var animateProperty:AnimateProperty = new AnimateProperty();
																				animateProperty.isStyle = isStyle;
																				animateProperty.property = property;
																				animateProperty.toValue = toValue; 
																				effect.addChild(animateProperty);
																				return animateProperty;
																			}
																			
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
																				toggler.setStyle("icon", DemoImages.show);
																				toggler.addEventListener(MouseEvent.CLICK, function(e:*):void{
																					if(toggler.getStyle("icon") == DemoImages.show){
																						toggler.setStyle("icon", DemoImages.hide);
																						overview.network = network;
																						overview.visible = true;
																					}else{
																						toggler.setStyle("icon", DemoImages.show);
																						overview.visible = false
																					}					
																				});	
																				hide.addEventListener(EffectEvent.EFFECT_END, function(e:*):void{
																					overview.network = null;
																				});				
																				network.parent.addChild(overview);
																				network.parent.addChild(toggler);		
																			}
																			
																			}
																
																}
