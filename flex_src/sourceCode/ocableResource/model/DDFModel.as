package sourceCode.ocableResource.model
{
	[Bindable]
	[RemoteClass(alias="ocableResources.model.DDFModel")]
	public class DDFModel
	{
		public var no:String;
		public var isnumber:String;
		
		public var ddfddmcode:String;             //DDF模块编号
		public var name_std:String;               //DDF模块名称
		public var stationcode:String;            //所属局站
		public var roomcode:String;               //所属机房
		public var equipshelfcode:String;         //所属机架
		
		public var station_name_std:String;       //所属局站标准名称		
		public var en_room_name_std:String;       //所属机房标准名称
		public var en_equipshelf_name_std:String; //所属机架标准名称
		public var vendor:String;                 //生产厂家
		public var ddfddmserial:String;           //DDF模块序号
		public var rowcount:String;               //行数
		public var property:String;               //产权单位
		public var col:String;                    //列数
		public var x_configcapacity:String;       //容量
		public var rundate:String;                //投运日期
		public var productdate:String;            //出厂日期
		public var x_model:String;                //规格型号
		public var asset_no:String;               //资产编号
		public var projectname:String;            //所属工程
		public var firsttestdate:String;          //初验日期
		public var lasttestdate:String;           //终验日期
		public var maintaindate:String;           //保修截止日期
		public var retiredate:String;             //退运日期
		public var dispatchunit:String;          //调度单位
		public var remark:String;                 //备注
		public var updateperson:String;           //更新人
		public var updatedate:String;             //更新时间
		
		public var updatedate_start:String;
		public var updatedate_end:String;
		
		public var rundate_start:String;
		public var rundate_end:String;
		
		public var productdate_start:String;
		public var productdate_end:String;
		
		public var maintaindate_start:String;
		public var maintaindate_end:String;
		
		public var firsttestdate_start:String;
		public var firsttestdate_end:String;
		
		public var lasttestdate_start:String;
		public var lasttestdate_end:String;
		
		public var retiredate_start:String;
		public var retiredate_end:String;
		
		public var portcount:String;               //DDFPort端口数量
		
		public var start:String;
		public var end:String;
		public var sort:String;
		public var dir:String;

		public function DDFModel()
		{
			no = "";
			isnumber = "";
			ddfddmcode = "";
			name_std = "";               
			stationcode = "";
			roomcode = "";
			equipshelfcode = "";
			
			station_name_std = "";       
			en_room_name_std = "";       
			en_equipshelf_name_std = ""; 
			
			vendor = "";                 
			ddfddmserial = "";             
			rowcount = "";               
			col = "";                    
			x_configcapacity = "";       
			property = "";
			rundate = "";                
			productdate = "";            
			x_model = "";           
            asset_no = "";               
			projectname = "";            
			firsttestdate = "";          
			lasttestdate = "";           
			maintaindate = "";           
			retiredate = "";             
			dispatchunit = "";
			remark = "";
			updateperson = "";
			updatedate = "";
			
			updatedate_start = "";
			updatedate_end = "";
			rundate_start = "";
			rundate_end = "";
			productdate_start = "";
			productdate_end = "";
			maintaindate_start = "";
			maintaindate_end = "";
			firsttestdate_start = "";
			firsttestdate_end = "";
			lasttestdate_start = "";
			lasttestdate_end = "";
			retiredate_start = "";
			retiredate_end = "";
			
			portcount = "";
			
			start= "0";            
			end= "50";             
			sort= "DDFDDMCODE";    
			dir= "asc";            
		}
	}
}