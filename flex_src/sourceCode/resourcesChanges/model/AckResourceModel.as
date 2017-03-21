package sourceCode.resourcesChanges.model
{
	[Bindable]	
	[RemoteClass(alias="resourcesChanges.model.AckResourceModel")] 
	public class AckResourceModel
	{
		public var res_type:String;
		public var res_code:String;
		public var res_ackperson:String;
		public var sync_status:String;
		public function AckResourceModel()
		{
			this.res_type="";
			this.res_code="";
			this.res_ackperson="";
			this.sync_status="";
		}
	}
}