
package sourceCode.sysGraph.actionscript
{
	import mx.collections.ArrayCollection;

	public class Subgraph
	{   import mx.controls.Alert;
		private static var temp:int; 	
			public  static var visited:Array=new Array();				
			private static var e2:Array = new Array();
			//private  static var subn:Array = new Array();
			public  static var subn_sub:Array = new Array();
			public  static var subg_sub:Array = new Array();
			//private  static var sub_num:int = 0;
			public  static var sub_num_sub:int = 0;
			private  static var str:String="";
			public static function refesh(e:Array):void {
				//setzero(subn,e.length);
				setzero(subn_sub,e.length);
				setzero(visited,e.length);
				add_dimension(e2,e.length,2);
				subg_sub = new Array();
				str=""
				//sub_num=0;
				sub_num_sub=0;
			}
			public static function findsub(e:Array):void {
				for(var i:int=0;i<e2.length;i++){
					if(visited[i]==0){
						for(var j:int=0,flag:Boolean=true;j<e2.length && flag==true ;j++){
							if(e2[i][j]!=0)
								flag=false;
						}
						if(flag==false){
							temp=0;
							subg_sub[sub_num_sub]="";
							dfs(e2, i);
							subn_sub[sub_num_sub]=temp;
							//subn[sub_num]=temp;	
							sub_num_sub++;
							//str+=subg_sub[sub_num_sub]+"====";
							
						}/*else{							
							subn[sub_num]=1;
						}
						sub_num++;*/
					}		
				}
				return ;
			}
			public static function main(e:Array):void {
				refesh(e);
				copy(e, e2);			
				findsub(e2);

				return ;
			} 
			
			public static function dfs(array:Array,node:int):void{				
				visited[node]=1;				 
				subg_sub[sub_num_sub]+=node.toString()+",";
				temp++; 
				for(var i:int=0;i<array.length;i++){
					if(visited[i]==0 && array[node][i] >0 )
						dfs(array, i);						
				}    	    	
				return;
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
