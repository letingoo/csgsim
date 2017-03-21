package sourceCode.tableResurces.model
{

	[Bindable]	
	[RemoteClass(alias="netres.model.DataImportResultModel")] 
	public class DataImportResultModel
	{
		public var badDataCounts:int;
		public var info:String;
		public var msgDetail:String;
		public function DataImportResultModel()
		{
			badDataCounts=0;
			info=null;
			msgDetail="";
		}
	}
}