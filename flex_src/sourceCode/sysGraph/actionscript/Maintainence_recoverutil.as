package sourceCode.sysGraph.actionscript
{	
	
	import sourceCode.sysGraph.model.BusRouteModel;
	import sourceCode.sysGraph.model.BussinessRoute;
	import sourceCode.sysGraph.model.BusssinessRouteModel;
	import sourceCode.sysGraph.actionscript.Shared;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	public final  class Maintainence_recoverutil
	{

		
		
		private var recv_list:Array;
		private var count_list:Array;
		private var info_array_log:Array;
		//private static var recv_log:Object;={recv_list:new Array(),count_list:new Array(),info_array_log:new Array()};
		public function Maintainence_recoverutil()
		{
			recv_list=new Array();
			count_list=new Array();
			info_array_log=new Array();
		}
		
		/**
		 * 
		 * @param recv_list_info
		 * @param count_list_info
		 * @param info_array_log
		 * @return 
		 * 恢复记录添加条目
		 */
		public function add_log(recv_list_info:Array,count_list_info:Object,info_temp:Array,mapobj:BussinessRoute):Boolean{
			count_list.push(count_list_info);
			info_array_log.push(info_temp);
			for(var temp:int =0;temp<recv_list_info.length;temp++){
				if(recv_list_info[temp]!=""){
					recv_list.push(mapobj.getBusrouteByID(recv_list_info[temp].slice(3)));//error】此处需要将记录存储和恢复记录都移动至用户选择完路由之后
				}
			}
			return true;
		}
		
		public function Recover_process(ele_name:String,mapobj:BussinessRoute):Array {
				var recoverd_list:Array=new Array();
				var node_name:String=ele_name;
				var temp:int=0;
				var flag:int=0;
				var tempobj:Object;
				while(flag==0){
					tempobj=count_list.pop();
					Shared.info_array=info_array_log.pop();
					if(tempobj.node==node_name){
						flag=1;
					}
					for(temp=0;temp<tempobj.count;temp++){
						var routeobj:BusssinessRouteModel=recv_list.pop();
						mapobj.updateBusroute(routeobj);
					}
//					var temp_node:Node=systemorgmap.elementBox.getDataByID(tempobj.node) as Node;
//					temp_node.setClient("incheck",false);
					recoverd_list.push(tempobj.node);
				}
				//Alert.show(recoverd_list.toString(),"recvlist");
				return recoverd_list;
		}
	}
}