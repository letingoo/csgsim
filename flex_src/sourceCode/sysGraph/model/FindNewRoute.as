package sourceCode.sysGraph.model
{
	import VButtonEvents.selectedItemEvent;
	
	import com.adobe.serialization.json.JSON;
	import com.amcharts.amcharts_com_internal;
	import com.as3xls.xls.ExcelFile;
	import com.as3xls.xls.Sheet;
	
	import flash.display.DisplayObject;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.collections.XMLListCollection;
	import mx.containers.TitleWindow;
	import mx.containers.utilityClasses.ConstraintColumn;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.ButtonBar;
	import mx.controls.CheckBox;
	import mx.controls.ComboBox;
	import mx.controls.Spacer;
	import mx.controls.TextArea;
	import mx.core.Application;
	import mx.core.DragSource;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.events.DragEvent;
	import mx.events.ListEvent;
	import mx.events.ScrollEvent;
	import mx.events.StateChangeEvent;
	import mx.formatters.DateFormatter;
	import mx.managers.DragManager;
	import mx.managers.PopUpManager;
	import mx.messaging.channels.StreamingAMFChannel;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	import mx.utils.StringUtil;
	
	import sourceCode.sysGraph.model.*;
	import sourceCode.sysGraph.views.UpdateRoute;
	
	import twaver.AlarmSeverity;
	import twaver.Consts;
	import twaver.DataBox;
	import twaver.DemoImages;
	import twaver.DemoUtils;
	import twaver.Element;
	import twaver.ElementBox;
	import twaver.Grid;
	import twaver.ICollection;
	import twaver.IElement;
	import twaver.Layer;
	import twaver.Link;
	import twaver.Node;
	import twaver.SelectionChangeEvent;
	import twaver.SerializationSettings;
	import twaver.Styles;
	import twaver.Utils;
	import twaver.XMLSerializer;
	import twaver.network.layout.AutoLayouter;
	import twaver.network.layout.SpringLayouter;

	public class FindNewRoute
	{
		private var topoData: Array=new Array();    //拓扑图邻接数组
		private var equipData: Array=new Array();   //设备列表
		private var busRoute:BussinessRoute;        //业务设备表
		private var foundRoute:Array=new Array();   //以找到的新路由
		public function FindNewRoute(equipName:Array,equipLink:Array,busRoute:BussinessRoute)
		{
			//this.topoData=topo;
			//this.equipData=equipData;
//			this.routeDataHandler(equipName,equipLink);
//			this.busRoute=busRoute;
		}
		/**
		 *xf
		 *最短路径 
		 * 参数为邻接矩阵、起点、终点
		 **/
		private function dijkstra(topo:Array,start:int,end:int):Array{                  
			var arr:Array=topo;
			var v:int= arr.length;
			var graph:EdgeWeightedDigraph=new EdgeWeightedDigraph(v);                //构建邻接表
			for(var i:int=0;i<v;i++){
				for(var j:int=0;j<v;j++){
					if(arr[i][j]>0){
						var e:DirectedEdge=new DirectedEdge(i,j,arr[i][j]);
						graph.addEdge(e);
					}
				}
			}
			var sp:Dijkstra=new Dijkstra(graph,start);                     //求出最短路径
			var edge:Array=sp.getEdge();
			var path:Array=sp.pathTo(end);                                   //返回最短路径数组
			return path;
		}
		/**
		 * xf
		 * 构造查找路由的数据源 邻接矩阵 ，及路由信息
		 **/
		private function routeDataHandler(equipName:Array,equipLink:Array):void               
		{  
			var j:int=0;
			for(var i:int=0;i<equipName.length;i++){
				if(equipName[i]!="")
				{
					topoData[j]=new Array();                                                   //邻接数组
					equipData[j]=equipName[i];                                                 //初始化设备数组
					j=j+1;
				}
			}
			for(var i:int=0;i<equipData.length;i++){
				for(var k:int=0;k<equipData.length;k++){
					if(k==i) topoData[i][k]=0;                                                //邻接数组中的点到自身距离为0
					else topoData[i][k]=-1;                                                   //-1表示两个点距离为无穷大
				}
			}
			for(var i:int=0;i<equipLink.length;i++){                                           //找到两个点的相连关系并把距离设为1
				if(equipLink[i]!=""&&equipLink[i]!=null)
				{
					var linkspot:Array=new Array();
					linkspot=equipLink[i].toString().split("-");
					topoData[equipData.indexOf(linkspot[0])][equipData.indexOf(linkspot[1])]=1;///现在按照拓扑为无向图处理
					topoData[equipData.indexOf(linkspot[1])][equipData.indexOf(linkspot[0])]=1;
				}
			}
		}
		/**
		 * xf 
		 * 根据业务ID和不可检修站点找出一条新路由
		 * 参数为业务ID以及不可检修点名称
		 **/
		private function findRoute(busId:String,station:String):Array{         
			if(equipData.length==0) Alert.show("设备数据未加载");
			else{
				var p:int= equipData.indexOf(station);                               //找出不可检修点的序号
				var topoDataTmp:Array;
				topoDataTmp=topoData.concat();                                       //克隆邻接表
				for(var i:int=0;i<topoDataTmp.length;i++){                           //将点p从邻接矩阵中去掉，即将所有与之相连的点的距离设置为-1
					topoDataTmp[i][p]=-1;
					topoDataTmp[p][i]=-1;
				}
				topoDataTmp[p][p]=0;                                                 //p点到自身距离为0
				var busNeedChange:BusssinessRouteModel=busRoute.getBusrouteByID(busId);        //获得业务模型
				var route:Array=busNeedChange.getmainroute().split("-");                       //模型里路由改波浪线了？
				//var route:Array=mainBusData.get(busId) as Array;      //根据业务ID返回路由数组
				//var index:int=route.indexOf(equipData[p]);   //标记位不可用的设备在路由数组中的下标	
				//var flag:Boolean=true;                       //标记寻找节点时start+1还是end-1,
				var start:int=equipData.indexOf(route[0]);
				var end:int=equipData.indexOf(route[route.length-1]);
				var path:Array;
				path=dijkstra(topoDataTmp,start,end);
			}
			return path;
		}
		/**
		 * 参数为选中的设备节点
		 * 返回值为二维数组，子数组第一项为业务ID，第二项为路由字符串,现在只能返回一条路由
		 */
		private function findRouteResultHandler(node:Node){
			var equipname:String=node.name;                                                 //得到名称属性
			var isOk:int=busRoute.isItemOK(equipname);                                      //查找可检修状态
			var busNeedChange:Array=busRoute.busidNeedChange(equipname);
			if(isOk==4){
				Alert.show("不可检修且找不到新路由");
				return foundRoute;
			} 
			else if(isOk==0){
				Alert.show("可以检修");
				return foundRoute;
			} 
			else
			{
				for (var i:int=0;i<busNeedChange.length;i++)
				{
					var bus:String=busNeedChange[i];
					var isok:String=bus.slice(0,3);   
					var busId:String=bus.slice(3);		
					if(isok=="1##"||isok=="11#"||isok=="111")
					{
						var routeChanged:Array=new Array();
						var path: Array=findRoute(busId,equipname);
						if(path.length==0)
						{
							Alert.show("不可检修，且未找到新路由！");
							return foundRoute;
						}
						var tmp:String="";
					//	Alert.show(path.length.toString()+path+"");
					//	tmp=tmp+ equipData[Number((path[path.length-1].toString().split("->"))[0])];
						for(var j:int=0;j<path.length;j++)
						{
							var num:int=Number((path[j].toString().split("->"))[0]);
							tmp=equipData[num]+"-"+tmp;
						}
						tmp=tmp+equipData[Number((path[0].toString().split("->"))[1])];
						routeChanged[0]=busId;
						routeChanged[1]=tmp;
						foundRoute.push(routeChanged);
					}	
				}
				//Alert.show(foundRoute[0].toString());
			}
			//dispatchEvent(new Event("findRouteSuccess"));
			
			//findRouteResoultHandler();
			return foundRoute;
		}
		/**
		 * 更新路由
		 * **/
		public function updateRouteHandler():void
		{
			for each(var arr:Array in foundRoute)
			{
				//var busModel:BusssinessRouteModel=new BusssinessRouteModel(arr[0],arr[1],"","");
				//busRoute.updateBusroute(busModel);
			}
		}
		public function findRouteHandler(node:Node):Array
		{
			//Alert.show("ds");
			/*
			var dataarr:ArrayCollection=new ArrayCollection();
			for each(var arr:Array in foundRoute)
			{
				dataarr.addItem({busId:arr[0],mainRoute:arr[1]});
			}
			*/
			var updateRoute:UpdateRoute=new UpdateRoute();
			updateRoute.foundroute=this;
			//updateRoute.dataArr=dataarr;
			//Alert.show(updateRoute.dataArr+"");
			PopUpManager.addPopUp(updateRoute,Application.application as DisplayObject,true);
			PopUpManager.centerPopUp(updateRoute);
			//Alert.show("ss");
			//updateRoute.addEventListener(dispatchEvent("findRouteSuccess",)
			return foundRoute;
		}
	}
}