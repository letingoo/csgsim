package sourceCode.resManager.resNode.model
{
	[Bindable]	
	[RemoteClass(alias="resManager.resNode.model.OcableModel")] 
	public class Ocable
		
	{   
		public var no:String = "";
		public var serialNO:String= "";
		public var ocablecode:String= "";
		public var ocablename:String= "";
		public var ocablemodel:String= "";
		public var length:String= "";
		public var builddate:String= "";
		public var property:String= "";
		public var buildmode:String= "";
		public var laymode:String= "";
		public var remark:String= "";
		public var rule:String= "";
		public var station_a:String="";
		public var station_z:String= "";
		public var updateperson:String= "";	
		public var updatedate:String= "";
		public var name_std:String= "";
		public var circuitname:String= "";
		public var province:String= "";
		public var ocableserial:String= "";
		public var fibercount:String= "";
		public var occupyfibercount:String= "";
		public var rundate:String= "";
		public var builddate_:String= "";
		public var builddate_start:String= "";
		public var builddate_end:String= "";
		public var voltlevel:String="";
		
		public var a_area:String="";
		public var z_area:String="";
		
		public var start:String= "0";
		public var end:String= "50";
		public var sort:String= "a_area";
		public var dir:String= "asc";
		
		public function Ocable()
		{
		}
	}
}



