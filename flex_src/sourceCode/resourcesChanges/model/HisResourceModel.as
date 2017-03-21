package sourceCode.resourcesChanges.model
{
	[Bindable]	
	[RemoteClass(alias="resourcesChanges.model.HisResourceModel")] 
	public class HisResourceModel
	{
		public var no:String;
		public var res_code:String;	
		public var sync_status:String;
		public var res_type:String;
		public var content:String;
		public var updatedate:String;
		public var acktime:String;
		public var ackperson:String;
		public var start:String;
		public var limit:String;
		public function HisResourceModel()
		{
			this.no="";
			this.res_code="";
			this.sync_status="";
			this.res_type="";
			this.content="";
			this.updatedate="";
			this.acktime="";
			this.ackperson="";
			this.start="";
			this.limit="";
		}
	}
}