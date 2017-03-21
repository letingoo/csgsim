package sourceCode.resManager.resNode.model
{
	[Bindable]	
	[RemoteClass(alias="resManager.resNode.model.testframe")] 
	public class Testframe
	{
		public var no:String = "";
		public var serialNO:String= "";
		public var ocablecode:String= "";
		public var ocablename:String= "";
		public var fibercode:String= "";
		public var length:String= "";
		public var fiberserial:String= "";
		public var property:String= "";
		public var status:String= "";
		public var remark:String= "";
		public var aendeqport:String="";
		public var zendeqport:String= "";
		
		public var opticalbusiness:String="";
		public var toplinkbusiness:String="";
		
		public var updateperson:String= "";	
		public var updatedate:String= "";
		public var name_std:String= "";
		public var updatedate_start:String= "";
		public var updatedate_end:String= "";
		public var start:String= "0";
		public var end:String= "50";
		public var sort:String= "ocablename";
		public var dir:String= "asc";
		
	}
}