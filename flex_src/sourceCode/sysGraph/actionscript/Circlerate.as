package sourceCode.sysGraph.actionscript{
	import flexlib.controls.textClasses.StringBoundaries;
	
	import mx.collections.ArrayCollection;
	
	import sourceCode.sysGraph.model.TopoModel;
	
	import twaver.core.twaver_internal;

	public class Circlerate{
		import mx.controls.Alert;
		public  static var circle_rate:Number;
		private static var POINT_NUM:int; 
		private static var if_circle:Array=new Array();
		public  static var visited:Array=new Array();	
		private static var namee:Array;
		public  static var C_NODE:String="";
		public  static var U_NODE:String="";
		public  static var U_NODEID:String="";
		public  static var C_TOTAL:int;
		public  static var U_TOTAL:int;
		private static var temp:int; 
		private static var root:int; 
		
		private static var if_doublenode:Boolean;
		//mawj 分析成环率
		public static function main(ee:Array,name:Array):Number { 
			
			//Alert.show("开始 分析");
			namee=name;
			POINT_NUM=ee.length;
			C_NODE="";
			U_NODE="";
			U_NODEID="";
			C_TOTAL=0;
			U_TOTAL=0;
			
			setzero(visited,POINT_NUM);	
			setzero(if_circle,POINT_NUM);
			//Alert.show("hh" + POINT_NUM.toString());
			findCycle(ee);
			//Alert.show("333");
			circle_rate=sum(if_circle,ee)/POINT_NUM;
			//Alert.show("C_TOTAL"+C_TOTAL.toString()+"\n"+"C_NODE"+C_NODE.toString()+"\n"+"U_NODE"+U_NODE.toString()+"\n"+"U_TOTAL"+U_TOTAL.toString()+";");
			
			return circle_rate;
		} 
		
		//判断是否成环以及是否为同缆假环。如果有环temp置1。无环不改变temp，存在假环且无环则将if_doublenode=true
		public static function dfs(array:Array,node:int,pre:int):void{	
			visited[node]=1; //Alert.show(pre.toString()+",,,"+node.toString());
			visited[root]=0;
			//for(var i:int=0;i<array.length;i++){
			for(var i:int=0;i<array.length && temp==0;i++){
				if(visited[i]==0 && array[node][i]>0 ){
					if(i==root){
						if(pre!= root){ //root-> others ->node ->root
							temp=1;
							if_doublenode =false;
							return;
						}else{//root->node->root
							if_doublenode =true;
							continue;	
						} 

					}else
						dfs(array, i, node);	
				}										
			} 
			return;
		}
		
		private static function findCycle(array:Array):void {
			//Alert.show("findCycle begin");
			
			//Alert.show("Shared:" + Shared.ocables.length.toString());
			for(var i:int=0;i<array.length;i++){
				if(if_circle[i]==0){
			//var i:int=1;
					setzero(visited,POINT_NUM);	
					if_doublenode = false; //root->node->root
					temp=0;
					root=i;
					dfs(array,i,-1);
					 //Alert.show(temp.toString()+",,,"+i.toString());
					if(temp==1)
						if_circle[i]=1;
					else{
						if(if_doublenode){  //root->node->root
						
							//判断是否同缆假环
							var is_same:Boolean = true;
							for(var j:int =0; j<array.length && is_same; j++){
								if(j!=i && array[i][j]>0){
									//判断标号为i的节点与标号为j的节点之间是否有分别属于两条不同光缆的复用段
									var links:ArrayCollection = new ArrayCollection();
									
//									for(var k:int = 0; k<Shared.ocables.length && is_same; k++){
//										var linkOb:Object = Shared.ocables[k];
//										var ob:Object = Shared.getConnectedEquipIndexOcables(k);
//										var id1:int = ob.id1,id2:int = ob.id2;
//										if((id1 == i && id2 ==j) ||(id1 == j && id2 ==i)) {
////											links.addItem(linkOb);
//											var cables_str:Object = linkOb.linkocable;
//											if(cables_str!=null&&cables_str!=""){
//												var ocablestr:String = cables_str as String;
//												if(ocablestr.indexOf(",")!=-1){
//													var cables:Array = cables_str.split(",");
//													if(cables.length>1){
//														is_same = false;
//													}
//												}
//											}
//										}
//									}
									
									var count:int = 0;
									var equip_a_id:String = Shared.equip_idlist[i];
									var equip_z_id:String = Shared.equip_idlist[j];
									for (var k:int = 0; k < Shared.route_lst.length && is_same; k++) {
										var linkOb:TopoModel = Shared.route_lst[k];
										//var ob:Object = Shared.getConnectedEquipIndexOcables(k);
										//var id1:int = ob.id1;
										//var id2:int = ob.id2;
										
										if ((equip_a_id == linkOb.Equip_a && equip_z_id == linkOb.Equip_z) || 
											(equip_a_id == linkOb.Equip_z && equip_z_id == linkOb.Equip_a))
											count++;
										
										if (count >= 2)
											is_same = false;
											
									}
									
								}
							}
							if(is_same){ //root->node->root同缆假环
								if_circle[i]=-1;
							}else{
								if_circle[i]=1;
							}
							
							
						}else{//root-> others
							if_circle[i]=-1;
						}
					}
						
				}		
			}
			
			//Alert.show("findCycle end");
		}
		
		private static function setzero(array:Array,dummy:int):void{
			for(var i:int=0;i<dummy;i++)
				array[i]=0;
		}	
		
		private static function sum(array:Array,ee:Array):int{
			var s:int=0;
			var num:int = array.length;
			
			if(ee.length<num){//wats the point of this?
				num = ee.length;
			}
			for(var i:int=0;i<num;i++){
				
				if(array[i]==1){
					s+=array[i];//统计环节点数？
					C_NODE=C_NODE+namee[i]+",";//统计环节点名称，用string类型保存然后传入前台list？
					C_TOTAL++;
				}else if(array[i]==-1){	//统计同缆假环？
					var n:int=0;
					for(var j:int=0; j<num && n<2; j++){
						if(ee[i][j]==1){
							n++;
						}							
					}
					if(n!=1){
						U_NODE=U_NODE+namee[i]+",";
						U_NODEID=U_NODEID+Shared.equipid_array[i]+",";
						U_TOTAL++;
					}
				}else
					s=-1;
			}
			return s;
		}							
	}
}