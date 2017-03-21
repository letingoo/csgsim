

package sourceCode.sysGraph.actionscript
{
	import mx.collections.ArrayCollection;
	
	public class Diameter
	{
		import mx.controls.Alert;
		
		private static var length:Array=new Array() ;
		private static var path:Array=new Array() ; 				
		private	static var nodea:int;
		private	static var nodeb:int;
		public	static var network_diameter:int=0;
		private static var MAX:int = 2147483647;
		private static var row:int ;
		private static var spot:Array=new Array() ;
		private  static var onePath:Array=new Array() ;	
		private static var point:int;
		public  static var longpath:Array=new Array() ;
		public  static var idlongpath:Array=new Array() ;
		public  static var longpath_num:int;
		public static var from:Array=new Array() ; 
		public static var to:Array=new Array() ; 
		
		public static function Floyd(G:Array):void { 
			network_diameter=0;
			for (var i:int = 0; i < row; i++)     
				for (var j:int = 0; j < row; j++) { 
					if (G[i][j] == 0){
						length[i][j] = MAX;
						spot[i][j] = -1;
					} else{
						length[i][j] = 1;
						spot[i][j] = j;
					}
											
					if (i == j) 
						length[i][j] = 0;					
				}
			
			for (var u :int= 0; u < row; u++)
				for (var v:int = 0; v < row; v++){
					if(v!=u){
						for (var w:int = v+1; w < row; w++) {
							if(w!=u){
								if (length[v][w] > length[v][u] + length[u][w]) { 
									length[v][w] = length[v][u] + length[u][w];
									length[w][v] = length[v][w];
									spot[v][w] = u;
									spot[w][v] = u;
								}
							}
						}
					}
				} 	
			

		}

		private static function outputPath(i:int, j:int):void {				
			if (i == j) 
				return;		
			if (spot[i][j] == j) 
				onePath[point++] = j; 
			else { 
				outputPath( i, spot[i][j]);
				outputPath( spot[i][j], j); 
			} 
		}
		
		public static function main(G:Array,name:Array,id:Array,input:int):int {				
			row=G.length;
			
			add_dimension(length,row,2);
			add_dimension(path,row,2);
			add_dimension(spot,row,2);
			
			refresh();
			Initialization();	
			
			Floyd(G);
			
			for (var i:int = 0; i < row; i++) {					
				for (var j:int = i+1; j < row; j++) { 
					if(length[i][j]>network_diameter) {
						network_diameter=length[i][j];				
					}
					if(length[i][j] >= input){						
						from[longpath_num]=i;
						to[longpath_num]=j;
						longpath_num++;
					}						
				}
			}


			for (var j:int = 0; j < longpath_num; j++){	
				nodea=from[j];
				nodeb=to[j];
				refresh();

				onePath[point++] = nodea; 				
				outputPath(nodea, nodeb); 
				longpath[j]="";
				idlongpath[j]="";
				for (var k:int=0;k<onePath.length;k++){
					longpath[j]+=name[onePath[k]]+"-->";
					idlongpath[j]+=id[onePath[k]]+"-->";
				}
				longpath[j]=longpath[j].substr(0,longpath[j].length-3);
				idlongpath[j]=idlongpath[j].substr(0,idlongpath[j].length-3);
			}
			
			return network_diameter;
		}
		private static function refresh():void{
			point = 0; 
			onePath = new Array();
		}
		private static function Initialization():void{
			longpath_num=0;
			longpath= new Array();
			idlongpath= new Array();
			from = new Array();
			to = new Array();								
		}
		
		private static function add_dimension(arr:Array,n:int,d:int):void
		{
		if(d==2)
		{
			for(var i:int=0;i<n;i++)
			{ 
				arr[i]=new Array(); 
			}
			return;
		}
		else if (d==3)
		{
			for(var i:int=0;i<n;i++)
			{ 
				arr[i]=new Array();
				for(var j:int=0;j<n;j++)
				{
					arr[i][j]= new Array();
				}
			}
		return;
		}
		else return;
		}
			
		
	}

}



				
		
		
		
		
	
