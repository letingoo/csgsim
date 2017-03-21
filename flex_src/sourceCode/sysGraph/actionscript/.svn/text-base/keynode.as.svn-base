
package sourceCode.sysGraph.actionscript
{

	public class keynode
	{   import mx.controls.Alert;
		private static var temp:int; 
			private static var POINT_NUM:int; 			
			public  static var visited:Array=new Array();			
			public static var crit_value:Array = new Array(); 	//	每个关键点的子网的规模，用逗号分隔的字符串表示，如：2,3,5
			private static var e2:Array = new Array();
			public  static var subn:Array = new Array();   //每个关键点的子网个数	
			public  static var singleNet:Array = new Array(); //每个关键点分隔出的独立节点的子网角标号，逗号分隔
			//public  static var subg:Array = new Array();
			
			public static function main(e:Array):void {
				refresh();
				POINT_NUM=e.length;
				setzero(subn,POINT_NUM);
				setzero(visited,POINT_NUM);
				add_dimension(e2,POINT_NUM,2);
				//add_dimension(subg,POINT_NUM,2);
								
				for(var i:int=0;i<POINT_NUM;i++){
					copy(e, e2);					
					crit_value[i]=calculate(e2, i);    	   
				}   
				
				return ;
			} 
			
			public static function dfs(array:Array,node:int):void{				
				visited[node]=1;
				temp++; 
				for(var i:int=0;i<array.length;i++){
					if(visited[i]==0 && array[node][i] >0 )
						dfs(array, i);						
				}    	    	
				return;
			}
			
			private static function calculate(array:Array,node:int):String{
				var i:int;
				temp=0;
				var str:String = ""; 
				var singleNode:String = ""; 
				
				for(i=0;i<array.length;i++)
					array[node][i]=array[i][node]=0;//kill node

				setzero(visited,0);
				
				for(i=0;i<array.length;i++){
					if(visited[i]==0 && i!=node){
						temp=0;
						dfs(array, i);
						subn[node]++;	
						str = str + temp.toString() + ", ";
						if(temp==1){
							singleNode = singleNode + i.toString() + ", ";
						}
					}		
				}
				if(singleNode==""){
					
				}else{
					singleNode=singleNode.substring(0,singleNode.length-2);
				}
				
				singleNet[node]=singleNode;
				return str;
			}
			
			public static function refresh():void{
				visited=new Array();			
				crit_value = new Array(); 			
				e2 = new Array();
				subn = new Array();
				singleNet = new Array();
			}
			
			private static function sum(array:Array):int{				
				var s:int=0;
				for(var i:int=0;i<array.length;i++)
					s+=array[i];
				return s;
			}
			
			private static function copy(a:Array,b:Array):void{				
				for(var i:int=0;i<a.length;i++)
					for(var j:int=0;j<a.length;j++)
						b[i][j]=a[i][j];
			}
			
			private static function setzero(array:Array,dummy:int):void{
				if(dummy==0)
					for(var i:int=0;i<array.length;i++)
						array[i]=0;
				else 
					for(var i:int=0;i<dummy;i++)
						array[i]=0;
			}
			
			private static function add_dimension(arr:Array,n:int,d:int):void{
				if(d==2){
					for(var i:int=0;i<n;i++) 
						arr[i]=new Array(); 
					return;
				}else return;
			}
		

	}
}
