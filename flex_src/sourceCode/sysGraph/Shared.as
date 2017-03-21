package sourceCode.sysGraph.actionscript
{
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import twaver.core.util.h._ED;
	
	public class Shared
	{
		
		public function Shared()
		{
		}//各种集合 用于数据处理 mawj
	//liao
		[Bindable]
		public static var business_n:Array=new Array();
		public static var topolink:Array=new Array();
		public static var from:Array=new Array();
		public static var to:Array=new Array();
		[Bindable]
		public static var str_new:String = new String();
		public static var net_type:String = new String();
		public static var reparedrate:String = new String();
		public static var import_flag:int = 0;
		public static var mark_flag:int = 0;
		public static var test_flag=0;
		[Bindable]
		public static var equipA:ArrayCollection=new ArrayCollection();
		public static var selectbusToRoute:Object = new Object();
		public static var sprinkle_list:Array=new Array();//
		public static var sprinkle_color_list:Array=new Array();
		[Bindable]
		public static var LinkDataA:ArrayCollection=new ArrayCollection();
		[Bindable]
		public static var equipB:ArrayCollection=new ArrayCollection();
		[Bindable]
		public static var LinkDataB:ArrayCollection=new ArrayCollection();
		public static var factory:ArrayCollection=new ArrayCollection();
		public static var equipModel:ArrayCollection=new ArrayCollection();
		public static var stationType:ArrayCollection=new ArrayCollection();
		public static var businessType:ArrayCollection=new ArrayCollection();
		public static var cableType:ArrayCollection=new ArrayCollection();
		public static var areaLocation:ArrayCollection=new ArrayCollection();
		
		public static var station:ArrayCollection=new ArrayCollection();
		public static var cable:ArrayCollection=new ArrayCollection();
		public static var port:ArrayCollection=new ArrayCollection();
		public static var slot:ArrayCollection=new ArrayCollection();
		//待删除 业务相关用到这三个 暂时不改了
		//		public static var business:ArrayCollection=new ArrayCollection();
		public static var circuit:ArrayCollection=new ArrayCollection();
		public static var circuitRoute:ArrayCollection=new ArrayCollection();
		
		public static var businessA:ArrayCollection=new ArrayCollection();
		public static var businessB:ArrayCollection=new ArrayCollection();
		public static var circuitA:ArrayCollection=new ArrayCollection();
		public static var circuitB:ArrayCollection=new ArrayCollection();
		public static var circuitRouteA:ArrayCollection=new ArrayCollection();
		public static var circuitRouteB:ArrayCollection=new ArrayCollection();
		public static var equipnamelist:Array=new Array();
		
		public static  var info_array:Array = new Array();
		public static var info_array1:Array = new Array();
		public static var equipname_array:Array = new Array();
		public static var equips:Array=new Array();
		public static var ocables:Array=new Array();
		public static var fibers:Array=new Array();
		public static var equipmentcodes:Array=new Array();        //李枝灵算法用
		public static var linkcodes:Array=new Array();             //李枝灵算法用
		//-- lil
		public static var visited:Array=new Array();
		public static var tempob:Object = new Object();
		/////ServCreate: BUSINESS_ID=link.id；PA起始设备EQUIP_ID； PB终止设备
		public static var BusinessToRoute:ArrayCollection = new ArrayCollection();
		/////ServRoute: BUSINESS_ID=粉色link.id；创建COMPLETE_DATE； ROUTE=Path； ROUTEID=PathID
		public static var BusinessToDeploy:ArrayCollection = new ArrayCollection();
		/////ServRoute: CIRCUIT_ID=BUSINESS_ID=粉色link.id; CIRCUIT_NAME, PORT_A, PORT_B
		public static var circuitToDataBase:ArrayCollection=new ArrayCollection();
		/////ServRoute创建
		/////ServDeploy更新
		public static var circuitRouteToDataBase:ArrayCollection=new ArrayCollection();
		//网络分析
		public static var equipid_array:Array = new Array();
		public static var equip_idlist:Array = new Array();
		public static var route_lst:Array= new Array();
		
		//
		public static var LinkDataToDataBase:ArrayCollection=new ArrayCollection();	
		[Bindable]
		public static var version_id_get:String = new String();
		[Bindable]
		public static var LinkDataCreate:ArrayCollection=new ArrayCollection();		
		[Bindable]
		public static var LinkDataDelete:ArrayCollection=new ArrayCollection();		
		[Bindable]
		public static var LinkDataUpdate:ArrayCollection=new ArrayCollection();
		[Bindable] 
		public static var BusinessToDataBase:ArrayCollection = new ArrayCollection();
		
		//-- lil
		[Bindable]
		public static var equipCreate:ArrayCollection=new ArrayCollection();
		[Bindable]
		public static var equipDelete:ArrayCollection=new ArrayCollection();
		[Bindable]
		public static var equipUpdate:ArrayCollection=new ArrayCollection();
		public static var equipToDataBase:ArrayCollection=new ArrayCollection();
		public static var portModify:ArrayCollection=new ArrayCollection();
		public static var stationModify:ArrayCollection=new ArrayCollection();
		public static var cableModify:ArrayCollection=new ArrayCollection();
		public static var stationTypeModify:ArrayCollection=new ArrayCollection();
		public static var areaLocationModify:ArrayCollection=new ArrayCollection();
		public static var cableTypeModify:ArrayCollection=new ArrayCollection();
		
		public static var equipTemp:ArrayCollection=new ArrayCollection();
		public static function refreshInfo():void{
			equipA = new ArrayCollection();
			LinkDataA = new ArrayCollection();
			equipB = new ArrayCollection();
			LinkDataB = new ArrayCollection();
			factory = new ArrayCollection();
			equipModel = new ArrayCollection();
			stationType = new ArrayCollection();
			businessType = new ArrayCollection();
			cableType = new ArrayCollection();
			areaLocation = new ArrayCollection();
			
			station = new ArrayCollection();
			cable = new ArrayCollection();
			port = new ArrayCollection();
			slot = new ArrayCollection();
			businessA = new ArrayCollection();
			circuitA = new ArrayCollection();
			circuitRouteA = new ArrayCollection();
			businessB = new ArrayCollection();
			circuitB = new ArrayCollection();
			circuitRouteB = new ArrayCollection();
			
			info_array = new Array();
			equipname_array = new Array();
			
			refreshModify();
			
			equipTemp = new ArrayCollection();
			//zj
			version_id_get = "";
		}
		public static function refreshModify():void{
			stationModify = new ArrayCollection();
			LinkDataToDataBase = new ArrayCollection();
			equipToDataBase = new ArrayCollection();
			portModify = new ArrayCollection();
			cableModify = new ArrayCollection();
			BusinessToDeploy = new ArrayCollection();
			circuitToDataBase = new ArrayCollection();
			circuitRouteToDataBase = new ArrayCollection();
			stationTypeModify=new ArrayCollection();
			areaLocationModify=new ArrayCollection();
			cableTypeModify=new ArrayCollection();
		}
		
		public static function stationCount():void{
			for(var i:int = 0;i<station.length; i++)
				station.getItemAt(i).COUNT = 0;
		}
		
		public static function addNewEquipANet(ob:Object):void{
			equipA.addItemAt(ob,0);
			ob.OPER = 1;
			equipToDataBase.addItem(ob);
		}
		public static function addNewEquipBNet(ob:Object):void{
			equipB.addItemAt(ob,0);
			ob.OPER = 1;
			equipToDataBase.addItem(ob);
		}
		public static function addNewLinkANet(ob:Object):void{
			LinkDataA.addItemAt(ob,0);
			ob.OPER = 1;
			LinkDataToDataBase.addItem(ob);
			addPortCableByLink(ob);
		}
		public static function addNewLinkBNet(ob:Object):void{
			LinkDataB.addItemAt(ob,0);
			ob.OPER = 1;
			LinkDataToDataBase.addItem(ob);
			addPortCableByLink(ob);
		}
		public static function delEquipANet(id:String):void{
			var ob:Object = new Object();
			for(var i:int = 0;i<equipA.length; i++){
				if(equipA.getItemAt(i).EQUIP_ID == id){
					ob = equipA.getItemAt(i);
					equipA.removeItemAt(i);
					i = equipA.length;
				}
			}
			ob.OPER = 2;
			equipToDataBase.addItem(ob);
		}
		public static function delEquipBNet(id:String):void{
			var ob:Object = new Object();
			for(var i:int = 0;i<equipB.length; i++){
				if(equipB.getItemAt(i).EQUIP_ID == id){
					ob = equipB.getItemAt(i);
					equipB.removeItemAt(i);
					i = equipB.length;
				}
			}
			ob.OPER = 2;
			equipToDataBase.addItem(ob);
		}
		public static function delLinkANet(id:String):void{
			var ob:Object = new Object();
			for(var i:int = 0;i<LinkDataA.length; i++){
				if(LinkDataA.getItemAt(i).LINK_ID == id){
					ob = LinkDataA.getItemAt(i);
					LinkDataA.removeItemAt(i);
					i = LinkDataA.length;
				}
			}
			ob.OPER = 2;
			LinkDataToDataBase.addItem(ob);
			delPortCableByLink(ob);
		}
		public static function delLinkBNet(id:String):void{
			var ob:Object = new Object();
			for(var i:int = 0;i<LinkDataB.length; i++){
				if(LinkDataB.getItemAt(i).LINK_ID == id){
					ob = LinkDataB.getItemAt(i);
					LinkDataB.removeItemAt(i);
					i = LinkDataB.length;
				}
			}
			ob.OPER = 2;
			LinkDataToDataBase.addItem(ob);
			delPortCableByLink(ob);
		}
		public static function delLinkByEquipANet(id:String):void{
			for(var i:int = 0;i<LinkDataA.length; i++){
				if(LinkDataA.getItemAt(i).FROM_EQUIP_ID == id || 
					LinkDataA.getItemAt(i).TO_EQUIP_ID == id){
					var ob:Object = LinkDataA.getItemAt(i);
					ob.OPER = 2;
					LinkDataToDataBase.addItem(ob);
					delPortCableByLink(ob);
					LinkDataA.removeItemAt(i);
					i -- ;
				}
			}
		}
		public static function delLinkByEquipBNet(id:String):void{
			for(var i:int = 0;i<LinkDataB.length; i++){
				if(LinkDataB.getItemAt(i).FROM_EQUIP_ID == id || 
					LinkDataB.getItemAt(i).TO_EQUIP_ID == id){
					var ob:Object = LinkDataB.getItemAt(i);
					ob.OPER = 2;
					LinkDataToDataBase.addItem(ob);
					delPortCableByLink(ob);
					LinkDataB.removeItemAt(i);
					i -- ;
				}
			}
		}
		private static function delPortCableByLink(ob:Object):void{
			var p1:Object = new Object;
			p1.PORT_ID = ob.FROM_PORT_ID;
			p1.VERSION_ID = ob.VERSION_ID;
			p1.PORT_USED = 0;
			p1.OPER = 3;
			portModify.addItem(p1);
			p1.PORT_ID = ob.TO_PORT_ID;
			portModify.addItem(p1);
			var arr:Array = IsHaveCable(ob.FROM_EQUIP_ID,ob.TO_EQUIP_ID);
			for(var i:int= 0;i<arr.length-1; i++){
				var str:String = IsInCable(arr[i],arr[i+1]);
				var c1:Object = new Object;
				c1.CABLE_ID = str;
				c1.OPER = 4;
				c1.VERSION_ID = ob.VERSION_ID;
				c1.CHANGE = -1;//optical_used -1
				cableModify.addItem(c1);
			}
		}
		public static function addPortCableByLink(ob:Object):void{
			var p1:Object = new Object;
			p1.PORT_ID = ob.FROM_PORT_ID;
			p1.VERSION_ID = ob.VERSION_ID;
			p1.PORT_USED = 1;
			p1.OPER = 3;
			portModify.addItem(p1);
			p1.PORT_ID = ob.TO_PORT_ID;
			portModify.addItem(p1);
			var arr:Array = Shared.IsHaveCable(ob.FROM_EQUIP_ID,ob.TO_EQUIP_ID);
			for(var i:int= 0;i<arr.length-1; i++){
				var str:String = IsInCable(arr[i],arr[i+1]);
				var c1:Object = new Object;
				c1.CABLE_ID = str;
				c1.VERSION_ID = ob.VERSION_ID;
				c1.OPER = 4;
				c1.CHANGE = 1;//optical_used -1
				cableModify.addItem(c1);
			}
		}
		public static function getEquipByIdANet(id:String):Object{
			for(var i:int = 0;i<equipA.length; i++){
				if(equipA.getItemAt(i).EQUIP_ID == id)
					return equipA.getItemAt(i);
			}
			return null;
		}
		public static function getEquipByIdBNet(id:String):Object{
			for(var i:int = 0;i<equipB.length; i++){
				if(equipB.getItemAt(i).EQUIP_ID == id)
					return equipB.getItemAt(i);
			}
			return null;
		}
		public static function getLinkByIdANet(id:String):Object{
			for(var i:int = 0;i<LinkDataA.length; i++){
				if(LinkDataA.getItemAt(i).LINK_ID == id)
					return LinkDataA.getItemAt(i);
			}
			return null;
		}
		public static function getLinkByIdBNet(id:String):Object{
			for(var i:int = 0;i<LinkDataB.length; i++){
				if(LinkDataB.getItemAt(i).LINK_ID == id)
					return LinkDataB.getItemAt(i);
			}
			return null;
		}
		public static function updateEquipANet(ob:Object):void{
			for(var i:int = 0;i<equipA.length; i++){
				if(equipA.getItemAt(i).EQUIP_ID == ob.EQUIP_ID){
					equipA.removeItemAt(i);
					equipA.addItemAt(ob,i);
					ob.OPER = 3;
					equipToDataBase.addItem(ob);
					i = equipA.length;
				}
			}
		}
		public static function updateEquipBNet(ob:Object):void{
			for(var i:int = 0;i<equipB.length; i++){
				if(equipB.getItemAt(i).EQUIP_ID == ob.EQUIP_ID){
					equipB.removeItemAt(i);
					equipB.addItemAt(ob,i);
					ob.OPER = 3;
					equipToDataBase.addItem(ob);
					i = equipB.length;
				}
			}
		}
		public static function updateLinkANet(ob:Object):void{
			for(var i:int = 0;i<LinkDataA.length; i++){
				if(LinkDataA.getItemAt(i).LINK_ID == ob.LINK_ID){
					LinkDataA.removeItemAt(i);
					LinkDataA.addItemAt(ob,i);
					ob.OPER = 3;
					LinkDataA.addItem(ob);
					i = LinkDataA.length;
				}
			}
		}
		public static function updateLinkBNet(ob:Object):void{
			for(var i:int = 0;i<LinkDataB.length; i++){
				if(LinkDataB.getItemAt(i).LINK_ID == ob.LINK_ID){
					LinkDataB.removeItemAt(i);
					LinkDataB.addItemAt(ob,i);
					ob.OPER = 3;
					LinkDataB.addItem(ob);
					i = LinkDataB.length;
				}
			}
		}
		public static function IsHaveCable(id1:String, id2:String):Array{
			var res:Array = new Array();
			var equip1:Object = getEquipByIdANet(id1);
			var equip2:Object = getEquipByIdANet(id2);
			if(equip1 == null){
				equip1 = getEquipByIdBNet(id1);
				equip2 = getEquipByIdBNet(id2);
			}
			var sid1:String = equip1.STATION_ID;
			var sid2:String = equip2.STATION_ID;
			if(sid1 == null || sid2 == null)
				return res;
			//不直接相连找到station1 的相连转接点  此时sid1上一次是-1 
			var ac:ArrayCollection = new ArrayCollection();
			var ob:Object = new Object();
			ob.id = sid1; 
			ob.index = -1;
			ac.addItem(ob);
			for(var i:int = 0; i< ac.length; i++){
				//每个object 包含相连的转接点
				var tieId:String = ac.getItemAt(i).id;
				if(IsInCable(tieId,sid2) != "null"){
					var count:int = 0;
					var result:Array = new Array();
					result[count] = sid2;
					count++;
					while(ac.getItemAt(i).index != -1){
						result[count] = ac.getItemAt(i).id;
						i = ac.getItemAt(i).index;
						count++;
					}
					result[count] = sid1;
					return result;
				}
				
				
				//继续找转接点的相邻转接点，它们上一次是i的index 1\2\3为0即sid1
				var ac2:ArrayCollection = getTiePoint(tieId,i);
				//不重复才加
				for(var j:int = 0; j< ac2.length; j++){
					for(var k:int = 0; k< ac.length; k++){
						if(ac2.getItemAt(j).id == ac.getItemAt(k).id || 
							ac2.getItemAt(j).id == null){
							ac2.removeItemAt(j);
							j--;
							k = ac.length;
						}
					}
				}
				ac.addAll(ac2);
			}Alert.show(ac.length.toString());
			//			Alert.show(ac.length.toString());
			return res;
		}
		public static function IsInCable(id1:String,id2:String):String{
			for(var i:int = 0;i<cable.length; i++){
				if(cable.getItemAt(i).STATION_A == id1 && 
					cable.getItemAt(i).STATION_B == id2)
					return cable.getItemAt(i).CABLE_ID;
				if(cable.getItemAt(i).STATION_A == id2 && 
					cable.getItemAt(i).STATION_B == id1)
					return cable.getItemAt(i).CABLE_ID;
			}
			return "null";
		}
		public static function getCableIndex(id1:String,id2:String):Number{
			for(var i:int = 0;i<cable.length; i++){
				if(cable.getItemAt(i).STATION_A == id1 && 
					cable.getItemAt(i).STATION_B == id2)
					return i;
				if(cable.getItemAt(i).STATION_A == id2 && 
					cable.getItemAt(i).STATION_B == id1)
					return i;
			}
			return 0;
		}
		public static function getTiePoint(id1:String,index:int):ArrayCollection{
			var ac:ArrayCollection = new ArrayCollection();
			for(var i:int = 0;i<cable.length; i++){
				var ob:Object = new Object();
				if(cable.getItemAt(i).STATION_A == id1 /*&& 
				cable.getItemAt(i).STATION_B_TYPE == 54*/){
					ob.id = cable.getItemAt(i).STATION_B;
					ob.index = index;
					if(int(cable.getItemAt(i).OPTICAL_NUM) > 
						int(cable.getItemAt(i).OPTICAL_USED)){
						ac.addItem(ob);
						//这两句是先去掉，省一些  最后结束了还会重新对cable赋值
						//						cable.removeItemAt(i);
						//						i--;
					}
				}else if(cable.getItemAt(i).STATION_B == id1 /*&& 
				cable.getItemAt(i).STATION_A_TYPE == 54*/){
					ob.id = cable.getItemAt(i).STATION_A;
					ob.index = index;
					if(int(cable.getItemAt(i).OPTICAL_NUM) > 
						int(cable.getItemAt(i).OPTICAL_USED)){
						ac.addItem(ob);
						//						cable.removeItemAt(i);
						//						i--;
					}
				}
			}
			for(var j:int = 0; j< ac.length; j++){
				for(var k:int = j+1; k< ac.length; k++){
					if(ac.getItemAt(j).id == ac.getItemAt(k).id){
						ac.removeItemAt(k);
						k--;
					}
				}
			}
			return ac;
		}
		public static function addNewPort(pid:String,eid:String,rate:String):void{
			var ob:Object = new Object();
			ob.OPER = 1;
			ob.PORT_ID = 1;
			ob.PORT_NAME = 1;
		}
		public static function updatePort(pid:String):void{
			
		}
		//注释ab
		public static function getConnectedEquipIndexANet(id:int):Object{
			var ob:Object = new Object();
			var id1:String = LinkDataA.getItemAt(id).FROM_EQUIP_ID,
				id2:String = LinkDataA.getItemAt(id).TO_EQUIP_ID;
			var count:int = 0;
			for(var i:int = 0; i<equipA.length && count<2 ; i++){
				if(equipA.getItemAt(i).EQUIP_ID == id1){
					ob.id1 = i;
					count++;
				}
				if(equipA.getItemAt(i).EQUIP_ID == id2){
					ob.id2 = i;
					count++;
				}
			}
			return ob;
		}
		//注释ab ocable
		public static function getConnectedEquipIndexOcables(id:int):Object{
			var ob:Object = new Object();
			var id1:String =ocables[id].equip_a,
				id2:String =ocables[id].equip_z;
			/*id3:String =ocables[id].equipa_z;*/
			var count:int = 0;
			for(var i:int = 0; i<equips.length && count<2 ; i++){
				if(equips[i].equipcode == id1){
					ob.id1 = i;
					count++;
				}
				if(equips[i].equipcode == id2){
					ob.id2 = i;
					count++;
				}
			}
			return ob;
		}
		
		public static function getConnectedEquipIndexFibers(id:int):Object{
			var ob:Object = new Object();
			var id1:String = fibers[id].equip_a1,
				id2:String = fibers[id].equip_z1;
			//var num:int= ocables[id].fibernum;
			/*id3:String =ocables[id].equipa_z;*/
			var count:int = 0;
			for(var i:int = 0; i<equips.length && count<2 ; i++){
				if(equips[i].equipcode == id1){
					ob.id1 = i;
					count++;
				}
				if(equips[i].equipcode == id2){
					ob.id2 = i;
					count++;
				}
			}
			return ob;
		}
		
		public static function getConnectedEquipIndexBNet(id:int):Object{
			var ob:Object = new Object();
			var id1:String = LinkDataB.getItemAt(id).FROM_EQUIP_ID,
				id2:String = LinkDataB.getItemAt(id).TO_EQUIP_ID;
			var count:int = 0;
			for(var i:int = 0; i<equipB.length && count<2 ; i++){
				if(equipB.getItemAt(i).EQUIP_ID == id1){
					ob.id1 = i;
					count++;
				}
				if(equipB.getItemAt(i).EQUIP_ID == id2){
					ob.id2 = i;
					count++;
				}
			}
			return ob;
		}
		public static function IsLinkHaveBusinessANet(id:String):Boolean{
			for(var i:int = 0; i< circuitRouteA.length; i++){
				if(circuitRouteA.getItemAt(i).LINK_ID == id && 
					circuitRouteA.getItemAt(i).GROUPNO == 0)
					return true;
			}
			return false;
		}
		public static function IsLinkHaveBusinessBNet(id:String):Boolean{
			for(var i:int = 0; i< circuitRouteB.length; i++){
				if(circuitRouteB.getItemAt(i).LINK_ID == id && 
					circuitRouteB.getItemAt(i).GROUPNO == 0)
					return true;
			}
			return false;
		}
		public static function IsEquipHaveBusinessANet(id:String):Boolean{
			for(var i:int = 0; i< circuitRouteA.length; i++){
				if(circuitRouteA.getItemAt(i).EQUIP_ID == id &&  
					circuitRouteA.getItemAt(i).GROUPNO == 0)
					return true;
			}
			return false;
		}
		public static function IsEquipHaveBusinessBNet(id:String):Boolean{
			for(var i:int = 0; i< circuitRouteB.length; i++){
				if(circuitRouteB.getItemAt(i).EQUIP_ID == id &&  
					circuitRouteB.getItemAt(i).GROUPNO == 0)
					return true;
			}
			return false;
		}
		public static function getEquipPrice(type:String):int{
			for(var i:int = 0; i< equipModel.length; i++){
				if(equipModel.getItemAt(i).EQUIP_MODEL_ID == type)
					return int(equipModel.getItemAt(i).PRICE);
			}
			return 10000;//以后可以改作用 默认价格[3].price
		}
		
		
		public static function getAreaEquipFromA(area:String):ArrayCollection{
			var stationArea:ArrayCollection = new ArrayCollection();
			var equipArea:ArrayCollection = new ArrayCollection();
			for(var i:int = 0; i< station.length; i++){
				if(station.getItemAt(i).STATION_AREA == area)
					stationArea.addItem(station.getItemAt(i));
			}
			for(var i:int = 0; i< equipA.length; i++){
				for(var j:int = 0; j< stationArea.length; j++){
					if(stationArea.getItemAt(j).STATION_ID == 
						equipA.getItemAt(i).STATION_ID)
						equipArea.addItem(equipA.getItemAt(i));
				}
			}
			return equipArea;
		}
		public static function getAreaEquipFromB(area:String):ArrayCollection{
			var stationArea:ArrayCollection = new ArrayCollection();
			var equipArea:ArrayCollection = new ArrayCollection();
			for(var i:int = 0; i< station.length; i++){
				if(station.getItemAt(i).STATION_AREA == area)
					stationArea.addItem(station.getItemAt(i));
			}
			for(var i:int = 0; i< equipB.length; i++){
				for(var j:int = 0; j< stationArea.length; j++){
					if(stationArea.getItemAt(j).STATION_ID == 
						equipB.getItemAt(i).STATION_ID)
						equipArea.addItem(equipB.getItemAt(i));
				}
			}
			return equipArea;
		}
		public static function getStationArea():ArrayCollection{
			var stationArea:ArrayCollection = new ArrayCollection();
			for(var i:int = 0; i< station.length; i++){
				var temp:int = 1;
				for(var j:int = 0; j< stationArea.length; j++){
					if(station.getItemAt(i).STATION_AREA == 
						stationArea.getItemAt(j).STATION_AREA){
						temp = 0;
						j = stationArea.length;
					}
				}
				if(temp == 1)
					stationArea.addItem(station.getItemAt(i));
			}
			return stationArea;
		}
		public static function selectEquipByNameANet(str:String):ArrayCollection{
			var arr:ArrayCollection = new ArrayCollection();
			for(var i:int = 0; i< equipA.length; i++){
				if(String(equipA.getItemAt(i).EQUIP_NAME).search(str) != -1)
					arr.addItem(equipA.getItemAt(i));
			}
			return arr;
		}
		public static function selectEquipByNameBNet(str:String):ArrayCollection{
			var arr:ArrayCollection = new ArrayCollection();
			for(var i:int = 0; i< equipB.length; i++){
				if(String(equipB.getItemAt(i).EQUIP_NAME).search(str) != -1)
					arr.addItem(equipB.getItemAt(i));
			}
			return arr;
		}
		public static function selectLinkByNameANet(str:String):ArrayCollection{
			var arr:ArrayCollection = new ArrayCollection();
			for(var i:int = 0; i< LinkDataA.length; i++){
				if(String(LinkDataA.getItemAt(i).LINK_NAME).search(str) != -1)
					arr.addItem(LinkDataA.getItemAt(i));
			}
			return arr;
		}
		public static function selectLinkByNameBNet(str:String):ArrayCollection{
			var arr:ArrayCollection = new ArrayCollection();
			for(var i:int = 0; i< LinkDataB.length; i++){
				if(String(LinkDataB.getItemAt(i).LINK_NAME).search(str) != -1)
					arr.addItem(LinkDataB.getItemAt(i));
			}
			return arr;
		}
		public static function selectBusByNameANet(str:String):ArrayCollection{
			var arr:ArrayCollection = new ArrayCollection();
			for(var i:int = 0; i< businessA.length; i++){
				if(String(businessA.getItemAt(i).BUSINESS_NAME).search(str) != -1)
					arr.addItem(businessA.getItemAt(i));
			}
			return arr;
		}
		public static function selectBusByNameBNet(str:String):ArrayCollection{
			var arr:ArrayCollection = new ArrayCollection();
			for(var i:int = 0; i< businessB.length; i++){
				if(String(businessB.getItemAt(i).BUSINESS_NAME).search(str) != -1)
					arr.addItem(businessB.getItemAt(i));
			}
			return arr;
		}
		public static function selectBusByNameAANet(str:String):ArrayCollection{
			var arr:ArrayCollection = new ArrayCollection();
			for(var i:int = 0; i< businessA.length; i++){
				if(String(businessA.getItemAt(i).BUSINESS_NAME).search(str) != -1)
					arr.addItem(businessA.getItemAt(i));
			}
			return arr;
		}
		public static function selectBusByNameABNet(str:String):ArrayCollection{
			var arr:ArrayCollection = new ArrayCollection();
			for(var i:int = 0; i< businessB.length; i++){
				if(String(businessB.getItemAt(i).BUSINESS_NAME).search(str) != -1)
					arr.addItem(businessB.getItemAt(i));
			}
			return arr;
		}
		public static function selectBusByNameB(str:String):ArrayCollection{
			var arr:ArrayCollection = new ArrayCollection();
			for(var i:int = 0; i< BusinessToRoute.length; i++){
				if(String(BusinessToRoute.getItemAt(i).BUSINESS_NAME).search(str) != -1)
					arr.addItem(BusinessToRoute.getItemAt(i));
			}
			return arr;
		}
		public static function selectStationByName(str:String):ArrayCollection{
			var arr:ArrayCollection = new ArrayCollection();
			for(var i:int = 0; i< station.length; i++){
				if(String(station.getItemAt(i).STATION_NAME).search(str) != -1)
					arr.addItem(station.getItemAt(i));
			}
			return arr;
		}
		public static function selectCableByName(str:String):ArrayCollection{
			var arr:ArrayCollection = new ArrayCollection();
			for(var i:int = 0; i< cable.length; i++){
				if(String(cable.getItemAt(i).CABLE_NAME).search(str) != -1)
					arr.addItem(cable.getItemAt(i));
			}
			return arr;
		}
		public static function getStationByArea(area:String):ArrayCollection{
			var stationArea:ArrayCollection = new ArrayCollection();
			var arr:ArrayCollection = new ArrayCollection();
			for(var i:int = 0; i< station.length; i++){
				if(station.getItemAt(i).STATION_AREA == area)
					stationArea.addItem(station.getItemAt(i));
			}
			for(var i:int = 0; i< station.length; i++){
				for(var j:int = 0; j< stationArea.length; j++){
					if(stationArea.getItemAt(j).STATION_ID == 
						station.getItemAt(i).STATION_ID)
						arr.addItem(station.getItemAt(i));
				}
			}
			return arr;
		}
		public static function getAreaByStation(stationId:String):Object{
			var arr:Object = new Object();
			for(var i:int = 0;i<station.length;i++){
				if(station.getItemAt(i).STATION_ID == stationId){
					return station.getItemAt(i);
				}
			}
			return arr;
		}
		public static function getEquipModelName(id:String):String{
			for(var i:int = 0;i<equipModel.length;i++){
				if(equipModel.getItemAt(i).EQUIP_MODEL_ID == id){
					return equipModel.getItemAt(i).EQUIP_MODEL_NAME;
				}
			}
			return "其他类型";
		}
		public static function getFactoryName(id:String):String{
			for(var i:int = 0;i<factory.length;i++){
				if(factory.getItemAt(i).FACTORY_ID == id){
					return factory.getItemAt(i).FACTORY_NAME;
				}
			}
			return "其他类型";
		}
		public static function getBusinessTypeName(id:String):String{
			for(var i:int = 0;i<businessType.length;i++){
				if(businessType.getItemAt(i).BUSINESS_TYPE_ID == id){
					return businessType.getItemAt(i).BUSINESS_TYPE_NAME;
				}
			}
			return "其他类型";
		}
		public static function getState(state:int):String{
			if(state == 0)
				return "正常";
			return "故障";
		}
		
		
	}
}