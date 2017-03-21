package  sourceCode.resManager.resNode.model
{
	[Bindable]	
	[RemoteClass(alias="resManager.resNode.model.StationModel")] 
	public class Station
	{
		public var no:String = "";
		public var serialNO:String= "";
		public var stationcode:String= "";
		public var stationname:String= "";
		public var x_stationtype:String= "";
		public var volt:String= "";
		public var province:String= "";
		public var provincecode:String= "";
		public var property:String= "";
		public var lng:String= "";
		public var lat:String= "";
		public var remark:String= "";
		public var powercondition:String="";
		public var updatedate:String= "";
		public var updateperson:String= "";	
		public var updatedate_start:String= "";
		public var updatedate_end:String= "";
		public var detailaddr:String= "";
		public var founddate:String= "";
		public var founddate_start:String= "";
		public var founddate_end:String= "";
		public var name_std:String= "";
		public var start:String= "0";
		public var end:String= "50";
		public var sort:String= "stationname";
		public var dir:String= "asc";
		public var tel:String;
		public var address:String;
		public var maintainunit:String;
		public var isNumber:String ="";
		
		public var zip:String="";
		public var fax:String="";
		public var roomcount:String="";
		public var system_name:String="";
		public function Station()
		{   
			
		}
	}
}