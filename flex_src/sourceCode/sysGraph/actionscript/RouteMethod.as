package sourceCode.sysGraph.actionscript
{
	import mx.collections.ArrayCollection;
	
	public class RouteMethod
	{
		import mx.controls.Alert;
		public static var LinkData:ArrayCollection = new ArrayCollection();
		
		public static function id_to_node(id:String):int{	
			var nodeid_array:Array = Shared.equipid_array;
			var node:int;
			for(var i:int=0; i<nodeid_array.length; i++){
				if(nodeid_array[i]==id){
					node=i;
					break;
				}
			}
			return node;
		}
		public static function getbackGR(G:Array, p:Array):Array{
			var row:int = G.length;
			var backGR:Array = new Array();
			for(var i:int=0;i<row;i++)
				backGR[i]=new Array(); 
			for (var i:int = 0; i < row; i++)     
				for (var j:int = 0; j < row; j++)
					backGR[i][j] = G[i][j];				
			for (var i:int =0; i<p.length-1; i++){
				var a:int = p[i];
				var b:int = p[i+1];
				backGR[a][b]=0;
				backGR[b][a]=0;
			}
			return 	backGR;
		}
		
		/*public static function getRoutePath(Pathid:Array):Array{
			var Route:Array = new Array();
			var num:int = 0;
			for(var i:int=0; i<Pathid.length-1; i++){
				var id1:String=Pathid[i];
				var id2:String=Pathid[i+1];										
				Route[num++]=getlink(id1, id2);
			}
			return Route;
		}*/
		public static function getAlink(id1:String, id2:String, info:ArrayCollection):String{
			var linkid:String="";
			for(var i:int=0,flag:Boolean=false; i<info.length && flag==false; i++){
				var link:Object = info.getItemAt(i);
				if((link.FROM_EQUIP_ID == id1 && link.TO_EQUIP_ID == id2)||(link.FROM_EQUIP_ID == id2 && link.TO_EQUIP_ID == id1)){
					 linkid=link.LINK_ID;
					 flag=true;
				}	
			}
			return linkid;
		}
		public static  function getlink(id1:String, id2:String,info:ArrayCollection):ArrayCollection{	
			//var Path:Object = new Object();
			var Path:ArrayCollection = new ArrayCollection();
			//Alert.show(id1+"\n"+id2,"333");
			//var node1:int = RouteMethod.id_to_node(id1);
			//var node2:int = RouteMethod.id_to_node(id2);	
			//Alert.show(id1+"\n"+id2+"\n"+node1+"\n"+node2+"\n"+Shared.info_array[node1][node2].toString(),"333");
			for(var i:int=0; i<info.length; i++){
				var link:Object = LinkData.getItemAt(i);
				if(link.FROM_EQUIP_ID == id1 && link.TO_EQUIP_ID == id2)
					//return link;
					Path.addItem(link);
				if(link.FROM_EQUIP_ID == id2 && link.TO_EQUIP_ID == id1){						
					var link2:Object = new Object();
					link2.LINK_ID = link.LINK_ID;
					link2.FROM_EQUIP_ID=id1;
					link2.TO_EQUIP_ID=id2;
					link2.LINK_RATE = link.LINK_RATE;
					var from:String = link.TO_EQUIP_NAME;
					var to:String = link.FROM_EQUIP_NAME;
					link2.FROM_EQUIP_NAME=from;
					link2.TO_EQUIP_NAME=to;
					from =link.TO_PORT_ID;
					to = link.FROM_PORT_ID;
					link2.FROM_PORT_ID=from;
					link2.TO_PORT_ID=to;
					Path.addItem(link2);
					//return link2;
				}
			}
			return Path;
		}
		public static  function getRoutePath(Pathid:Array,info:ArrayCollection):ArrayCollection{
			LinkData.removeAll();
			LinkData.addAll(info);

			var Route:ArrayCollection = new ArrayCollection();
			Route.removeAll();
			for(var i:int=0; i<Pathid.length-1; i++){
				var id1:String=Pathid[i];
				var id2:String=Pathid[i+1];
				var link:ArrayCollection = getlink(id1, id2, info);					
				var ob:Object = link.getItemAt(0);
				//var ob:Object = getlink(id1, id2);	
				Route.addItem(ob);	
			}
			return Route;
		}

		public static  function getport(id:String):Object{
			var ob:Object = new Object();
			for each(var temp:Object in Shared.port){
				if(temp.PORT_ID == id){
					ob=temp;
					break;
				}						
			}
			return ob;
		}	
	}

}



				
		
		
		
		
	
