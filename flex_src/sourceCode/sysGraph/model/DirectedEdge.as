package  sourceCode.sysGraph.model
{
	/**
	 *xf 
	 * 用于求最短路径的数据类型
	 * 加权有向边 
	 **/
	public class DirectedEdge
	{
		private var start: int;   //起点
		private var end: int;     //终点
		private var w: Number;    //权重
		public function DirectedEdge(start:int ,end:int,weight:Number){
			this.start=start;
			this.end=end;
			this.w=weight;
		}
	    /**
		 * 返回起点
		 **/ 
		public function from():int{
			return start;
		}
		/**
		 * 返回终点
		 **/ 
		public function to():int{
			return end;
		}
		/**
		 * 返回权重
		 **/ 
		public function weight():Number{
			return this.w;
		}
		public function toString():String{
			return ""+start+"->"+end;
		} 
	}
}