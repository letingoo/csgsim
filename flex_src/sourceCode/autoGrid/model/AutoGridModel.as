package  sourceCode.autoGrid.model
{
	[Bindable]	
	[RemoteClass(alias="autoGrid.model.AutoGridModel")] 
	public class AutoGridModel
	{
		public var start:int= 0;
		public var end:int= 50;
		public var json:String ;
		public var tablename:String;
		public var sortColumn:String;
		public var sortOrder:String;
		public function AutoGridModel()
		{   
			json = "";
			tablename = "";
			sortColumn = "";
			sortOrder = "";
		}
	}
}