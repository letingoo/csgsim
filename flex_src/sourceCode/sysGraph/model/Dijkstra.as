package sourceCode.sysGraph.model
{
	/**
	 *xf
	 * 用于求最短路径
	 * dijkstra算法
	 **/
	import mx.controls.Alert;
	import sourceCode.sysGraph.model.*;
	public class Dijkstra
	{
		private var edgeTo:Array;
		private var distTo:Array;
		private var mark:Array;
		/**
		 *初始化 
		 **/
		public function Dijkstra(G:EdgeWeightedDigraph,s:int)
		{
			edgeTo=new Array(G.getV());                           //标记到次点的最短路径的最后一条边
			distTo=new Array(G.getV());                           //存储到目标点的最短距离
			mark=new Array(G.getV());                             //标记位，为TRUE表示此点已加入到最短距离点集合中
			for(var v:int=0;v<G.getV();v++){
				distTo[v]=Number.POSITIVE_INFINITY;
				mark[v]=false;
				edgeTo[v]=null
			}
			/*
			for each(var e:DirectedEdge in G.getAdj(s) ){        //先把与目标点直接相连的点的距离初始化为最短距离 
				distTo[e.to()]=e.weight();                       //不必有这一步，之后自己会进行相关初始化
				edgeTo[e.to()]=e;
			}
			*/
			distTo[s]=0.0;
			mark[s]=true;
			edgeTo[s]=null;
			var newP:int=s;
			sp(G,newP);
		}
		private function sp(G:EdgeWeightedDigraph,newP:int):void         //求最短距离
		{
			for(var i:int=0;i<distTo.length;i++){
				for each(var e:DirectedEdge in G.getAdj(newP)){
					var to:int=e.to();
					if(mark[e.to()]==true) continue;
					if(distTo[to]==Number.POSITIVE_INFINITY||distTo[to]>distTo[newP]+e.weight()){
						distTo[to]=distTo[newP]+e.weight();
						edgeTo[to]=e;
					}
				}
			    var min:Number=Number.MAX_VALUE;
			    for(var j:int=0;j<G.getV();j++){
				    if(mark[j]==true) continue;
				    if(distTo[j]==Number.POSITIVE_INFINITY) continue;
				    if(distTo[j]<min){
					    min=distTo[j];
					    newP=j;
				    }
				}
				mark[newP]=true;
			}
		}
		/**
		 * 某一点到目标点的最短距离
		 **/ 
		public function getDistTo(v:int):Number{             //某一点到目标点的最短距离
			return distTo[v];
		}
		/**
		 * 判断是否有最短距离
		 **/ 
		public function hasPathTo(v:int):Boolean{           //判断是否有最短距离
			return distTo[v]<Number.POSITIVE_INFINITY;
		}
		/**
		 * 到某一点的最短路径数组
		 **/ 
		public function pathTo(v:int):Array{               //最短路径数组
			if(!hasPathTo) return null; 
			var path:Array=new Array();
			var e:DirectedEdge=edgeTo[v];
			while(e!=null){                   /////**/////条件判定错误两次！！直接判定e是否为null即可
				path.push(e);
				e=edgeTo[e.from()];
			}
			return path;
		}	
		public function getEdge():Array{                  //调试时 用的
			return edgeTo;
		}
	}
}
