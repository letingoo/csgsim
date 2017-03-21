package sourceCode.myDocument.model
{
	[Bindable]	
	[RemoteClass(alias="myDocument.model.FolderModel")]  
	public class FolderModel
	{
		public var text:String;
		public var shorttext:String;
		public var url:String;
		public var icon:String;
		public var iconsize:int;
		public function FolderModel()
		{
		}
	}
}