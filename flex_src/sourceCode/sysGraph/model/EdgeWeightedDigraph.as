package sourceCode.sysGraph.model
{
	/**
	 *xf 
	 * 用于求最短路径的数据类型
	 * 加权有向图
	 **/
	public class EdgeWeightedDigraph
	{
		private var V:int;         //点的数量
		private var E: int;        //边的数量
		private var adj:Array      //邻接表
		//Vector.<DirectedEdge>; 
		public function EdgeWeightedDigraph(v:int){
			this.V=v;
			this.E=0;
			adj=new Array(v);
			for(var i:int=0;i<V;i++){
				adj[i]=new Vector.<DirectedEdge>();
			}
		}
		/**
		 * 返回点的总数
		 **/ 
		public function getV():int{
			return V;
		}
		/**
		 * 返回边的总数
		 **/ 
		public function getE():int{
			return E;
		}
		/**
		 *将变加到邻接表中
		 * */
		public function addEdge(e:DirectedEdge):void{   //将边加到邻接表中
			adj[e.from()].push(e);
			E++;
		}
		/**
		 * 返回以点v为起始点的所有边
		 **/
		public function getAdj(v:int):Vector.<DirectedEdge>{     //返回以点v为起始点的所有边
			return adj[v]
		}
		/**
		 * 返回所有的边
		 **/ 
		public function edges():Vector.<DirectedEdge>{           //返回所有的边
			var edges:Vector.<DirectedEdge>=new Vector.<DirectedEdge>;
			for (var v:int=0;v<V;v++){
				for each(var e:DirectedEdge in adj[v]){
					edges.push(e);
				}
			}
			return edges;
		}
		
	}
}