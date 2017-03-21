	import com.adobe.serialization.json.JSON;
	
	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	
	import mx.collections.*;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.controls.ComboBox;
	import mx.controls.Tree;
	import mx.core.Application;
	import mx.core.DragSource;
	import mx.events.CloseEvent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.events.IndexChangedEvent;
	import mx.events.ItemClickEvent;
	import mx.managers.PopUpManager;
	import mx.messaging.events.ChannelEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	import sourceCode.channelRoute.model.Circuit;
	import sourceCode.channelRoute.views.circuitTree;
	import sourceCode.channelRoute.views.tandemcircuit;
	import sourceCode.packGraph.views.OpticalPort;
	import sourceCode.packGraph.views.checkedEquipPack;
	
	import twaver.*;
	import twaver.ElementBox;
	import twaver.network.Network;
	
	private var XMLData_Rate:XMLList; 
	private var XMLData_InterfaceType:XMLList; 
	private var XMLData_Department:XMLList;
	private var XMLData_UserName:XMLList;
	private var XMLData_Opertion_type:XMLList;
	public var c_circuitcode:String=null;
	public var circuitcode:String=null;
	public var port_a:String=null;
	public var port_z:String=null;
	public var slot_a:String="";
	public var slot_z:String="";
	public var tandem:tandemcircuit;
	public var equippack:checkedEquipPack;
	public var opticalport:OpticalPort;
	public var follower:Follower;
    public var isReplace:Boolean = false;
    private var textcolor:uint;
    public var copy_circuitcode:String = null;

	[Bindable]
	public var Renabled:Boolean=false;

	public var 	circuit:Circuit = new Circuit();

	public function init():void
	{
		if(c_circuitcode!=null){//已有电路编号
			Renabled=false;
			var rtobj:RemoteObject = new RemoteObject("channelTree");
			Application.application.faultEventHandler(rtobj);
			rtobj.endpoint = ModelLocator.END_POINT;
			rtobj.showBusyCursor = true;
			rtobj.getCircuitDetail(c_circuitcode);//更新设备信息
			rtobj.addEventListener(ResultEvent.RESULT,function(e:ResultEvent):void{
				var obj:Array = JSON.decode(e.result.toString()) as Array;
//				Alert.show(e.result.toString());
				if(obj!=null){
					requestid.text = obj[0].circuitcode;
					circuitcode = obj[0].circuitcode;
					port_a = obj[0].port1;
					port_z = obj[0].port2;
					slot_a = obj[0].slot1;
					slot_z = obj[0].slot2;
					circuit.state = obj[0].username;//保存业务名称，用于更新电路业务关系表
					if(obj[0].createtime!=null)
						createTime.text=obj[0].createtime;
					if(obj[0].usetime!=null)
						useTime.text=obj[0].usetime;
					circuitName.text=obj[0].username;//业务名称
					remark.text=obj[0].remark!=null?obj[0].remark:"";
					leaser.text=obj[0].leaser!=null?obj[0].leaser:"";
					circuitLevel.value = obj[0].circuitlevel;
					if(obj[0].requestcom==null||obj[0].requestcom==""||obj[0].requestcom=="null"){
						requestCom.text ="";
					}else{
						requestCom.text = obj[0].requestcom;
					}
					
					var rtobj11:RemoteObject = new RemoteObject("equInfo");
					rtobj11.endpoint = ModelLocator.END_POINT;
					rtobj11.showBusyCursor = true;
					rtobj11.getFromXTBM('YW0102__');//根据系统编码查询对应信息(速率)
					rtobj11.addEventListener(ResultEvent.RESULT, function(e:ResultEvent):void{
						XMLData_Rate = new XMLList(e.result.toString())
						rate.dataProvider = XMLData_Rate.children();
						rate.selectedIndex = -1;
						rate.selectedItem = new XML("<name label =\""+obj[0].rate+"\" code=\""+obj[0].ratecode+"\" />");
					})	
					
					var rtobj12:RemoteObject = new RemoteObject("equInfo");
					rtobj12.endpoint = ModelLocator.END_POINT;
					rtobj12.showBusyCursor = true;
					rtobj12.getFromXTBM('JK01__');//根据系统编码查询对应信息(接口类型)
					rtobj12.addEventListener(ResultEvent.RESULT, function(e:ResultEvent):void{
						XMLData_InterfaceType = new XMLList(e.result.toString())
						interfaceType.dataProvider = XMLData_InterfaceType.children();
						interfaceType.selectedIndex = -1;
						interfaceType.selectedItem = new XML("<name label =\""+obj[0].interfacetype+"\" code=\""+obj[0].interfacetypecode+"\" />");
					})
					
					var rtobj13:RemoteObject = new RemoteObject("equInfo");
					rtobj13.endpoint = ModelLocator.END_POINT;
					rtobj13.showBusyCursor = true;
					rtobj13.getFromXTBM('XZ0701__');//根据系统编码查询对应信息(使用单位)
					rtobj13.addEventListener(ResultEvent.RESULT, function(e:ResultEvent):void{
						XMLData_Department = new XMLList(e.result.toString())
						userCom.dataProvider=XMLData_Department.children();
						userCom.selectedIndex = -1;
						userCom.selectedItem = new XML("<name label =\""+obj[0].usercom+"\" code=\""+obj[0].usercomcode+"\" />");
					})	
					var rtobj14:RemoteObject = new RemoteObject("equInfo");
					rtobj14.endpoint = ModelLocator.END_POINT;
					rtobj14.showBusyCursor = true;
					rtobj14.getFromXTBM('YW120915__');//根据系统编码查询对应信息(业务类型)
					rtobj14.addEventListener(ResultEvent.RESULT, function(e:ResultEvent):void{
						XMLData_UserName = new XMLList(e.result.toString())
						userName.dataProvider = XMLData_UserName.children();
						userName.selectedIndex = -1;
						userName.selectedItem = new XML("<name label =\""+obj[0].busitype+"\" code=\""+obj[0].busitypecode+"\" />");
					})	
				}
			})			
		}else {//
			//自动生成电路编号
			var ret:RemoteObject = new RemoteObject("equInfo");
			Application.application.faultEventHandler(ret);
			ret.endpoint = ModelLocator.END_POINT;
			ret.showBusyCursor = true;
			ret.getMaxCircuitcode();//获取当前最大电路编号
			ret.addEventListener(ResultEvent.RESULT, function(e:ResultEvent):void{
				requestid.text = e.result.toString();
			});
			
			var rtobj11:RemoteObject = new RemoteObject("equInfo");
			Application.application.faultEventHandler(rtobj11);
			rtobj11.endpoint = ModelLocator.END_POINT;
			rtobj11.showBusyCursor = true;
			rtobj11.getFromXTBM('YW0102__');//根据系统编码查询对应信息(速率)
			rtobj11.addEventListener(ResultEvent.RESULT, function(e:ResultEvent):void{
				XMLData_Rate = new XMLList(e.result.toString());
				rate.dataProvider = XMLData_Rate.children();
			});
			
			var rtobj12:RemoteObject = new RemoteObject("equInfo");
			Application.application.faultEventHandler(rtobj12);
			rtobj12.endpoint = ModelLocator.END_POINT;
			rtobj12.showBusyCursor = true;
			rtobj12.getFromXTBM('JK01__');//根据系统编码查询对应信息(接口类型)
			rtobj12.addEventListener(ResultEvent.RESULT, function(e:ResultEvent):void{
				XMLData_InterfaceType = new XMLList(e.result.toString());
				interfaceType.dataProvider = XMLData_InterfaceType.children();
			});
			
			var rtobj13:RemoteObject = new RemoteObject("equInfo");
			Application.application.faultEventHandler(rtobj13);
			rtobj13.endpoint = ModelLocator.END_POINT;
			rtobj13.showBusyCursor = true;
			rtobj13.getFromXTBM('XZ0701__');//根据系统编码查询对应信息(使用单位)
			rtobj13.addEventListener(ResultEvent.RESULT, function(e:ResultEvent):void{
				XMLData_Department = new XMLList(e.result.toString());
				userCom.dataProvider=XMLData_Department.children();
			});	
			var rtobj14:RemoteObject = new RemoteObject("equInfo");
			Application.application.faultEventHandler(rtobj14);
			rtobj14.endpoint = ModelLocator.END_POINT;
			rtobj14.showBusyCursor = true;
			rtobj14.getFromXTBM('YW120915__');//根据系统编码查询对应信息(业务类型)
			rtobj14.addEventListener(ResultEvent.RESULT, function(e:ResultEvent):void{
				XMLData_UserName = new XMLList(e.result.toString());
				userName.dataProvider = XMLData_UserName.children();
			});	
		}
		
	}


	private function close():void{  
	   MyPopupManager.removePopUp(this);  
	}


	
	private function checkCircuitName(circuitName:String):void{
		var rtobj:RemoteObject = new RemoteObject("channelTree");
		Application.application.faultEventHandler(rtobj);
		rtobj.endpoint = ModelLocator.END_POINT;
		rtobj.showBusyCursor = true;
		rtobj.checkCircuitName(circuitName);//验证业务名称
		rtobj.addEventListener(ResultEvent.RESULT,function(e:ResultEvent):void{
//			if(e.result.toString()=="Success"&&){
//				Alert.show("业务名称已存在，请重新填写！","提示");
//			}else{
			if(e.result.toString()=="Fail"){
				isReplace=true;//表示新建
			}
				if(useTime.text!=null)
					circuit.usetime=useTime.text;
				else{
					Alert.show("请填写开通时间");
					return;
				}
				if(userName.selectedIndex == -1){
					Alert.show("业务类型不能为空！","提示");
					return;
				}else{
					circuit.username=userName.text;
				}
				
				if(rate.selectedIndex == -1){
					Alert.show("速率不能为空！","提示");
					return;
				}else{
					circuit.rate=rate.selectedItem.@label;
				}
				if(userCom.selectedIndex == -1){
					Alert.show("使用单位不能为空！","提示");
					return;
				}else{
					circuit.usercom=userCom.selectedItem.@code;
				}
				circuit.circuitLevel=circuitLevel.value;
				circuit.powerline=circuitcode;//保存电路编号
				circuit.requisitionid=requestid.text;
				circuit.requestcom=requestCom.text;
				if(createTime.text!=null)
					circuit.createtime=createTime.text;
				if(interfaceType.selectedIndex!=-1){
					circuit.interfacetype=interfaceType.selectedItem.@code;
				}else{
					circuit.interfacetype=interfaceType.text;
				}
				circuit.check1=check_personOfRequestFinish.text;
				circuit.check2=response_person.text;
				circuit.beizhu=remark.text;
				circuit.leaser = leaser.text;
				circuit.portserialno1 = port_a;
				circuit.portserialno2 = port_z;
				circuit.portcode1 = port_a;
				circuit.portcode2 = port_z;
				circuit.slot1 = slot_a;
				circuit.slot2 = slot_z;
//				var serializer:XMLSerializer = new XMLSerializer(tandem.channelPic.elementBox);
//				var xml:String = serializer.serialize();
				var rtobj:RemoteObject = new RemoteObject("channelTree");
				Application.application.faultEventHandler(rtobj);
				rtobj.endpoint = ModelLocator.END_POINT;
				rtobj.showBusyCursor = true;
				rtobj.relateCircuit(circuit,"",isReplace);//更新设备信息
				rtobj.addEventListener(ResultEvent.RESULT,function(e:ResultEvent):void{
					Alert.show("关联成功!电路编号为："+e.result.toString(),"提示");
					close();
				});
//			}
		});
	}

	private function checkCircuitId(circuitcode:String):void{
		var rtobj:RemoteObject = new RemoteObject("channelTree");
		Application.application.faultEventHandler(rtobj);
		rtobj.endpoint = ModelLocator.END_POINT;
		rtobj.showBusyCursor = true;
		rtobj.checkCircuitId(circuitcode);//验证电路编号是否存在
		rtobj.addEventListener(ResultEvent.RESULT,function(e:ResultEvent):void{
			if(e.result.toString()=="Success"&&Renabled){
				requestid.text="";
				Alert.show("申请的编号已存在，请重新填写","提示");
				
			}else{
				if(circuitName.text==""){
					Alert.show("请填写业务名称！");
					return;
				}else{
					circuit.remark=circuitName.text;
					//验证业务名称是否存在
					checkCircuitName(circuitName.text);
				}
			}
		});
	}

	private function save():void{
		
		//
		if(requestid.text!=null&&requestid.text!="")
		{
			circuit.circuitcode = requestid.text;
			//判断电路ID是否存在
			checkCircuitId(requestid.text);
		}
		else{
			Alert.show("请填写申请单号！");
			return;
		}
		
	}
	