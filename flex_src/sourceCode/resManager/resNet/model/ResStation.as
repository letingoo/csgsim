package  sourceCode.resManager.resNode.model
{
	[Bindable]	
	[RemoteClass(alias="resManager.resNode.model.ResStationModel")] 
	public class ResStation
	{
		public var no:String = "";
		public var station_id:String= "";
		public var station_name:String= "";
		public var station_type:String= "";
		public var station_location_x:String= "";
		public var station_location_y:String= "";
		public var station_state:String= "";
		public var station_date:String= "";
		public var station_date_start:String= "";
		public var station_date_end:String= "";
		public var station_picture:String= "";
		public var version_id:String= "";
		public var update_man:String="";
		public var update_man_id:String= "";
		public var update_date:String= "";	
		public var isNumber:String="";
		public var start:String= "0";
		public var end:String= "50";
		public var sort:String= "station_id";
		public var dir:String= "asc";
		
		public function ResStation()
		{   
			
		}
	}
}