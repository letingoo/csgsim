package sourceCode.sysGraph.model
/*  ?insertBusroute(BusssinessRouteModel BusRouteModel):Boolean 插入业务路由
	?updateBusroute(BusssinessRouteModel BusRouteModel):Boolean 更新业务路由
	?getBusrouteByID(String busid):BusssinessRouteModel 根据业务id找业务路由
	?getBusrouteByItem(String itemid):Array 根据设备/复用段id找业务id
	?isItemOK(String itemid):int	根据设备/复用段id查看该设备是否可以检修
	?busidNeedChange 根据设备/复用段id，返回一个该设备或复用段下需要更改主路由的业务id
	?itemList():Array 返回设备/复用段列表
	?busidList():Array 返回业务id列表
	?deleteall():Boolean 删除全部存储内容
	?topoLink():Array 返回拓扑数据
	?topoEquip():Array 返回设备数据
	?checkInDanger(busid:Sring):Array 检查该业务id中存在的重合设备
	?update_time :2016/12/28_02
	
*/	
	
{
	import common.actionscript.ModelLocator;
	import common.actionscript.MyPopupManager;
	import common.actionscript.Registry;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.DataGridEvent;
	import mx.events.FlexEvent;
	import mx.events.ItemClickEvent;
	import mx.formatters.DateFormatter;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	import mx.utils.ObjectProxy;
	
	import sourceCode.sysGraph.model.BusResultModel;
	import sourceCode.sysGraph.model.BusRouteModel;
	import sourceCode.sysGraph.model.BusssinessRouteModel;
	import sourceCode.sysGraph.model.EquipModel;
	import sourceCode.sysGraph.model.Map;
	import sourceCode.sysGraph.model.TopoModel;

	public final class BussinessRoute
	{
		private var _EquipList:Array;
		private var _TopoList:Array;
		private var _BusrouteList:Array;
		private var _BusByItemTabel:Map;//所需设备/复用段与经过其的业务信息表
		private var _BusByRouteTabel:Map;//业务路由表
		private var _EquipTable:Map;
		public function BussinessRoute():void{
			_BusByItemTabel=new Map();
			_BusByRouteTabel=new Map();
			_EquipTable=new Map();
			_EquipList=new Array();
			_TopoList=new Array();
			_BusrouteList=new Array();
			this.getEquip1();
			
			
			
			
		}
		
		public function topoLink():Array{
			return _TopoList;
		}
		public function topoEquip():Array{
			return _EquipList;
		}
		//初始化函数
		private var ii:int=20;
		private function init():void{
			for each(var equip:EquipModel in _EquipList){
				if(_EquipTable.containsKey(equip.equipcode)){}
				else{
					_EquipTable.put(equip.equipcode,equip);
				}
			}
			
			for each(var busRoute:BusRouteModel in _BusrouteList){
				var route1:String=busRoute.mainroute;
				var route2:String=busRoute.backuproute1;
				var route3:String=busRoute.backuproute2;
				route1=this.translate(route1);	
				route2=this.translate(route2);
				route3=this.translate(route3);
				if(route1!=""){
//					if(ii>0){
//						ii--;
//						Alert.show(busRoute.busid+"  TE:::"+route1+" **"+route2+" **"+route3+"");
//					}
					var temp:BusssinessRouteModel=new BusssinessRouteModel(busRoute.busid.toString(),busRoute.busname.toString(),busRoute.bustype.toString(),route1.toString(),route2.toString(),route3.toString());
//					if(ii>0){	
//						Alert.show("2344"+temp.toString());
//						
//						ii--;
//						//				Alert.show("  TE:::"+route.toString());
//						//				var item2:Array=route[2].split("~");
//						//				Alert.show("  TE222:::"+item2.toString());
//					}
					if(this.insertBusRoute(temp)){
						//					Alert.show("31"+busRoute.busid.toString());
					}
				}				
			}
		}
		
		//转换业务路由的函数
		private function translate(tempRoute:String):String{
			var result:String=new String();
			result="";
			if(tempRoute==null||tempRoute==""||tempRoute=="null"){
				return result;
			}
			var node_array:Array=tempRoute.split('~');			
			for each(var temp:String in node_array){
				if(_EquipTable.containsKey(temp)){
					var equip:EquipModel=_EquipTable.get(temp) as EquipModel;
					result=result.toString()+equip.equipname.toString()+"~";
				}
			}
			return result.slice(0,result.length-1);		
		}
		
		//从后台获取设备信息
		private function getEquip1():void{
			
			var roBus:RemoteObject=new RemoteObject("Bussiness_Route");
			roBus.addEventListener(ResultEvent.RESULT,equipresulthandler);
			roBus.endpoint = ModelLocator.END_POINT;
			roBus.showBusyCursor = true;
			roBus.getEquip();
		}
		private function equipresulthandler(event:ResultEvent):void{
			var result:BusResultModel=event.result as BusResultModel;
			_EquipList=result.orderList.source;
			this.getBusRoute1();
			
		}
		//从后台获取拓扑信息
		private function getTopo1():void{
			var roBus:RemoteObject=new RemoteObject("Bussiness_Route");
			roBus.addEventListener(ResultEvent.RESULT,toporesulthandler);
			roBus.endpoint = ModelLocator.END_POINT;
			roBus.showBusyCursor = true;
			roBus.getTopolink();
		}
		private function toporesulthandler(event:ResultEvent):void{
			var result:BusResultModel=event.result as BusResultModel;
			var temp:TopoModel=new TopoModel();
			_TopoList=result.orderList.source;
		}
		//从后台获取业务路由信息
		private function getBusRoute1():void{
			var roBus:RemoteObject=new RemoteObject("Bussiness_Route");
			roBus.addEventListener(ResultEvent.RESULT,busrouteresulthandler);
			roBus.endpoint = ModelLocator.END_POINT;
			roBus.showBusyCursor = true;
			roBus.getBusRoute();
		}
		private function busrouteresulthandler(event:ResultEvent):void{
			var result:BusResultModel=event.result as BusResultModel;
			_BusrouteList=result.orderList.source;
			this.getTopo1();
			this.init();
		}
		//检查该业务id中存在的重合设备
		public function checkInDanger(busid:String):Array{
			if(_BusByRouteTabel.containsKey(busid)){
				var result_array:Array=new Array();
				var temp_model:Array=this.getBusrouteByID(busid).toString().split('//');
						var item_array:Array=temp_model[1].toString().split('~');
						for each(var item:String in item_array){
							var busByitem:Array=this.getBusrouteByItem(item);
							for each(var bus:String in busByitem){
								if(bus.indexOf(busid)!=-1&&(bus.indexOf('1##')!=-1||bus.indexOf('11#')!=-1||bus.indexOf('111')!=-1)){
									result_array.push(item);
								}
							}
						}
				return result_array;
			}
			else {
				Alert.show("checkInDanger:不能查找业务列表中没有的业务!");
				return null;
			}
			
		}
		
		//插入业务路由表
//		public var i:int=1;
		public function insertBusRoute(BusRouteModel:BusssinessRouteModel):Boolean{
//			if(ii>0){	
//				Alert.show("2344"+BusRouteModel.toString());
//				ii--;
////				Alert.show("  TE:::"+route.toString());
////				var item2:Array=route[2].split("~");
////				Alert.show("  TE222:::"+item2.toString());
//			}
			if(_BusByRouteTabel.containsKey(BusRouteModel.getbusid())){//不能插入已经存在的项
//				Alert.show("不能插入已经存在的项!");
				return false;
			}
			else{
				if(BusRouteModel.getbusid()!="null"&&BusRouteModel.getbusid()!=""&&BusRouteModel.getmainroute()!="null"&&BusRouteModel.getmainroute()!=""){
					
					_BusByRouteTabel.put(BusRouteModel.getbusid(),BusRouteModel);
					
					var route:Array=BusRouteModel.toString().split("//");
				
					var routeNumber:int=3;//该业务下的路由数量
					//Alert.show(BusRouteModel.toString());
					if(route[2]==""||route[2]=="null") {routeNumber--;} 
					if(route[3]==""||route[3]=="null") {routeNumber--;} 
//					if(ii>0){	
//						Alert.show("2344");
//												ii--;
//												Alert.show("  TE:::"+route.toString());
//												var item2:Array=route[2].split("~");
//												Alert.show("  TE222:::"+item2.toString());
//											}
					//Alert.show(route[0]+"l="+routeNumber+"****"+BusRouteModel.toString());
					for (var i:int=1;i<route.length;i++){
						if(route[i].toString()!=""&&route[i].toString()!="null"){
							var item:Array=route[i].split("~");//将每一条路由拆解，其中的每一个item（设备或者复用段）插入item表
							for each(var temp:String in item){
								if(this.insertBusByItem(temp,route[0],i,routeNumber)) continue;
								else return false;
							}
						}
					}
					//将每一条业务路由的起点和终点打上标记字段
					var item:Array=route[1].split("~");
					var start:String=item[0];//起点终点设备名
					var end:String=item[item.length-1];
					var temp1:String=_BusByItemTabel.get(start).toString()
					var index1:int=temp1.search(route[0]);
					var temp2:String=_BusByItemTabel.get(end).toString()
					var index2:int=temp2.search(route[0]);
					_BusByItemTabel.put(start,temp1.slice(0,index1-4)+"!"+temp1.slice(index1-3));
					_BusByItemTabel.put(end,temp2.slice(0,index2-4)+"!"+temp2.slice(index2-3));
					return true;
				}
				else return false;
				
			}	
			return true;
		}
		//更新业务路由，返回一个布尔类型		
		public function updateBusroute(BusRouteModel:BusssinessRouteModel):Boolean{
			if(_BusByRouteTabel.containsKey(BusRouteModel.getbusid())){//业务路由表中存在才可更新
				if(this.deleteItemBusByBusid(BusRouteModel.getbusid())){//删除业务记录
					if(BusRouteModel.getbusid()!="null"&&BusRouteModel.getbusid()!=""&&BusRouteModel.getmainroute()!="null"&&BusRouteModel.getmainroute()!=""){
						_BusByRouteTabel.put(BusRouteModel.getbusid(),BusRouteModel);
						var route:Array=BusRouteModel.toString().split("//");
						var routeNumber:int=3;//该业务下的路由数量
						//Alert.show(BusRouteModel.toString());
						if(route[2]==""||route[2]=="null") routeNumber--;
						if(route[3]==""||route[3]=="null") routeNumber--;
						//Alert.show(route[0]+"l="+routeNumber+"****"+BusRouteModel.toString());
						for (var i:int=1;i<route.length;i++){
							if(route[i].toString()!=""&&route[i].toString()!="null"){
								var item:Array=route[i].split("~");//将每一条路由拆解，其中的每一个item（设备或者复用段）插入item表
								for each(var temp:String in item){
									if(this.insertBusByItem(temp,route[0],i,routeNumber)) continue;
									else return false;
								}
							}
						}
						//将每一条业务路由的起点和终点打上标记字段
						var item:Array=route[1].split("~");
						var start:String=item[0];//起点终点设备名
						var end:String=item[item.length-1];
						var temp1:String=_BusByItemTabel.get(start).toString()
						var index1:int=temp1.search(route[0]);
						var temp2:String=_BusByItemTabel.get(end).toString()
						var index2:int=temp2.search(route[0]);
						_BusByItemTabel.put(start,temp1.slice(0,index1-4)+"!"+temp1.slice(index1-3));
						_BusByItemTabel.put(end,temp2.slice(0,index2-4)+"!"+temp2.slice(index2-3));
						return true;
					}
					else return false;
				}
				else {
//					Alert.show("3");
					return false;}
			}
			else {
//				Alert.show("4");
				return false;}
		}
		
		//插入设备/复用段所含的业务表,返回一个布尔类型
		private function insertBusByItem(item:String,busid:String,i:int,l:int):Boolean{
			//Alert.show("insertBusByItem 1"+item+" "+busid+" "+i.toString()+" "+l.toString());
			if(_BusByItemTabel.containsKey(item)){//设备表中已有此设备/复用段
				var index:int=_BusByItemTabel.get(item).toString().search(busid);
			//	Alert.show("insertBusByItem 2"+index.toString());
				if(index==-1){//该设备表项中没有这个业务id；
					var mark:String=i.toString()+l.toString();//mark为插入的不同情况标识
					switch(mark){//根据不同情况创建并插入此业务id到该设备/复用段中
						case"11":
							_BusByItemTabel.put(item,_BusByItemTabel.get(item).toString()+"/?1##"+busid);
							return true;
							break;
						case"12":
							_BusByItemTabel.put(item,_BusByItemTabel.get(item).toString()+"/?10#"+busid);
							return true;
							break;
						case"13":
							_BusByItemTabel.put(item,_BusByItemTabel.get(item).toString()+"/?100"+busid);
							return true;
							break;
						case"21":
							return false;
							break;
						case"22":
							_BusByItemTabel.put(item,_BusByItemTabel.get(item).toString()+"/?01#"+busid);
							return true;
							break;
						case"23":
							_BusByItemTabel.put(item,_BusByItemTabel.get(item).toString()+"/?010"+busid);
							return true;
							break;
						case"31":
							return false;
							break;
						case"32":
							return false;
							break;
						case"33":
							_BusByItemTabel.put(item,_BusByItemTabel.get(item).toString()+"/?001"+busid);
							return true;
							break;
					}
				}
				else{
				//	Alert.show("insertBusByItem 3");
					_BusByItemTabel.put(item,_BusByItemTabel.get(item).toString().slice(0,index-(3-i)-1)+"1"+
						_BusByItemTabel.get(item).toString().slice(index-(3-i)));
					return true;
				}				
			}
			else{//设备/复用段表中没有此设备3
				//Alert.show("insertBusByItem 4");
				var mark:String=i.toString()+l.toString();//mark为插入的不同情况标识
				switch(mark){//根据不同情况创建并插入此业务id到该设备/复用段中
					case"11":
						_BusByItemTabel.put(item,"/?1##"+busid);
						return true;
						break;
					case"12":
						_BusByItemTabel.put(item,"/?10#"+busid);
						return true;
						break;
					case"13":
						_BusByItemTabel.put(item,"/?100"+busid);
						return true;
						break;
					case"21":
						return false;
						break;
					case"22":
						_BusByItemTabel.put(item,"/?01#"+busid);
						return true;
						break;
					case"23":
						_BusByItemTabel.put(item,"/?010"+busid);
						return true;
						break;
					case"31":
						return false;
						break;
					case"32":
						return false;
						break;
					case"33":
						_BusByItemTabel.put(item,"/?001"+busid);
						return true;
						break;
				}
			}
			return false;
		}
		
		//根据业务id删除设备表中的该业务记录
		private function deleteItemBusByBusid(busid:String):Boolean{
			var item:Array=this.itemList();
			for each(var temp:String in item){
				var index:int=_BusByItemTabel.get(temp).toString().search(busid);
				if(index!=-1){
					_BusByItemTabel.put(temp,_BusByItemTabel.get(temp).toString().slice(0,index-5)+
						_BusByItemTabel.get(temp).toString().slice(index+busid.length));
				}
			}
			return true;
		}
		
		//删除全部存储的内容
		public function deleteall():Boolean{
			_BusByItemTabel.clear();
			_BusByRouteTabel.clear();
			return true;
		}
		
		
		//根据业务id找业务路由，返回该id业务路由模型
		public function getBusrouteByID(busid:String):BusssinessRouteModel{
			if(busid==""||busid=="null") {
				Alert.show("getBusrouteByID传入参数不能为空");
				return null;
			}
			else return BusssinessRouteModel(_BusByRouteTabel.get(busid));
		}
		
		
		//根据设备/复用段id找业务id，返回一个数组，数组里面存有该设备/复用段所在的所有业务ID
		/*返回的业务id格式如下：三个标记位+业务id 标记为由三个字母组成，1表示该设备/复用段在此路由中，0表示不在此路由，#表示该位置路由表项为空
			例如  10#11212  表示业务id为11212 该业务有主备用路由没有迂回路由，且该设备在主路由中不在备用路由
				 ##111214 表示业务id为11214 该业务只有迂回路由没有主备用路由。且该设备只在迂回路由中
		* */
		public function getBusrouteByItem(itemid:String):Array{
			if(itemid==""||itemid=="null")
			{	Alert.show("getBusrouteByItem传入参数不能为空！");
				return null;
			}				
			else if(_BusByItemTabel.containsKey(itemid)){
				var temp_array:Array=_BusByItemTabel.get(itemid).toString().split('/');
				//Alert.show(_BusByItemTabel.get(itemid).toString());
				for(var i:int=0;i<temp_array.length;i++){
					temp_array[i]=temp_array[i].toString().slice(1);
				}
				return temp_array.slice(1);
			}
			else{
				var temp_array:Array=new Array();
				return temp_array;
			}			
		}
		
		//根据设备id查看该设备是否可以检修，返回一个整数类型
		//1表示主路由经过这里且没有备用路由
		//2表示主路由和备用路由都经过这里
		//3表示主路由，备用路由，迂回路由经过这里
		//4表示该设备是某条路由的起点或终点
		//0表示该设备可以检修
		public function isItemOK(itemid:String):int{
			if(itemid==""||itemid=="null"){
				Alert.show("isItemOK传入参数不能为空！");
				return null;
			}
			else{
				if(_BusByItemTabel.containsKey(itemid)){
					var temp:String=_BusByItemTabel.get(itemid).toString();
					if(temp.search("!")!=-1) return 4;
					else if(temp.search("1##")!=-1) return 3;
					else if(temp.search("11#")!=-1) return 2;
					else if(temp.search("111")!=-1) return 1;
				}
				return 0;		
			}
				
		}
		
		
		//根据设备/复用段id，返回一个该设备或复用段下需要更改主路由的业务id数组，包含标记字段。
		public function busidNeedChange(itemid:String):Array{
			if(itemid==""||itemid=="null"){
				Alert.show("busidNeedChange传入参数不能为空！");
				return null;
			}
			else if(_BusByItemTabel.get(itemid).toString()=="null") return null; 
			else if(_BusByItemTabel.get(itemid).toString().search("!")!=-1){
				return null;
			}
			else{
				var temp:Array=_BusByItemTabel.get(itemid).toString().split("/");
				var result:Array=new Array();
				for each(var item:String in temp){
					item=item.slice(1);
					if(item.search("1##")!=-1||item.search("11#")!=-1||item.search("111")!=-1||item.search("100")!=-1||
					item.search("110")!=-1||item.search("101")!=-1||item.search("10#")!=-1)  result.push(item);
				}
				return result;
			}			
		}
		
		public function itemString(item:String):String{
			return _BusByItemTabel.get(item).toString();
		}
		
		//返回设备/复用段列表，返回一个数组
		public function itemList():Array{
			return _BusByItemTabel.keySet();
		}
		public function temp():Array{
			return _BusByItemTabel.values();
		}
		
		//返回业务id列表，返回一个数组
		public function busidList():Array{
			return _BusByRouteTabel.keySet();
		}
	}
}