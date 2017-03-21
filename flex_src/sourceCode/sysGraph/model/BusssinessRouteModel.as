package sourceCode.sysGraph.model
/*
 * 业务路由模型
	busid 业务路由id
	mainroute 主路由
	backuproute 备用路由
	backuproute2 迂回路由	
	BusssinessRouteModel(name:String,route1:String,route2:String,route3:String):Boolean 创建一个路由表数据项
	toString() 返回一个特殊格式的字符串 
*/
{
	
	
	public final class BusssinessRouteModel
	{
		import mx.controls.Alert;
		private var busid:String;
		private var mainroute:String;
		private var backuproute1:String;
		private var backuproute2:String;
		private var busname:String;
		private var bustype:String;
		
		//private function BusssinessRouteModel(){}
		
		public function getbustype():String
		{
			return bustype;
		}

		public function setbustype(value:String):void
		{
			bustype = value;
		}


		public function getbusname():String
		{
			return busname;
		}

		public function setbusname(value:String):void
		{
			busname = value;
		}


		/*public function BusssinessRouteModel(name:String,route1:String,route2:String,route3:String):void{
			busid=new String();
			mainroute=new String();
			_backuproute1=new String();
			backuproute2=new String();
			if((name==""||name=="null")){ //业务id不可为空，主路由不能为空
				Alert.show("业务名称不能为空！");	
				
			}
			else if((route1==""||route1=="null")){
				Alert.show("主路由不能为空！");
			}
			else{
				this.setbusid(name);
				this.setmainroute(route1);
				this.setbackuproute1(route2);
				this.setbackuproute2(route3);
			}						
		}	*/
		
		
		public function BusssinessRouteModel(id:String,name:String,type:String,route1:String,route2:String,route3:String):void{
			busid=new String();
			busname=new String();
			bustype=new String();
			
			mainroute=new String();
			backuproute1=new String();
			backuproute2=new String();
			
			
//			if((id==""||id=="null")){ //业务id不可为空，主路由不能为空
//				Alert.show("业务id不能为空！");	
//			}
//			if((name==""||name=="null")){
//				Alert.show("业务名称不能为空！");	
//			}
//			else if((route1==""||route1=="null")){
////				Alert.show("主路由不/能为空！");
//			}
//		/	else{
				this.setbusid(id);
				this.setbusname(name);
				this.setbustype(type);
				this.setbackuproute1("");
				this.setbackuproute2("");
				this.setmainroute(route1);
				
				this.setbackuproute1(route2);
				
				
				this.setbackuproute2(route3);
				
//			}						
		}	
		
		
		/*
		//ToString类型
		public function toString():Sring{
		return (this.getbusid()+"//"+
		this.getbusname()+"//"+
		this.getbustype()+"//"+
		this.getbusunit()+"//"+
		this.getmainroute()+"//"+
		this.getbackuproute1()+"//"+
		this.getbackuproute2()+"//"+
		this.getbackuproute3()+"//"+
		this.getbackuproute4()+"//"+
		)
		}
		
		 * */
		//ToString类型，返回一个特殊格式的字符串 业务id/主路由/备用路由/迂回路由
		public function toString():String{
			return (this.getbusid()+"//"+this.getmainroute()+"//"+this.getbackuproute1()+"//"+this.getbackuproute2());
		}
		
		
		public function getbackuproute2():String
		{
			return backuproute2;
		}

		public function setbackuproute2(value:String):void
		{
			backuproute2 = value;
		}

		public function getbackuproute1():String
		{
			return backuproute1;
		}

		public function setbackuproute1(value:String):void
		{
			backuproute1 = value;
		}

		public function getmainroute():String
		{
			return mainroute;
		}

		public function setmainroute(value:String):void
		{
			mainroute = value;
		}

		public function getbusid():String
		{
			return busid;
		}

		private function setbusid(value:String):void //业务id不可由外部更改
		{
			busid = value;
		}

	}
}