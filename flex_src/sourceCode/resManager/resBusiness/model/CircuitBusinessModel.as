package sourceCode.resManager.resBusiness.model
{
	[Bindable]	
	[RemoteClass(alias="resManager.resBusiness.model.CircuitBusinessModel")] 
	public class CircuitBusinessModel
	{
		public var no:String;
		public var business_id:String;
		/**
		 *电路编号 
		 */
		public var circuitcode:String;

		/**
		 *电路名称 
		 */
		public var username:String;
		/**
		 *业务名称 
		 */
		public var business_name:String;
		/**
		 *更新人
		 */
		public var updateperson:String;
		public var sort:String;
		public var dir:String;
		public var index:String;
		public var end:String;
		//用来确定需要修改表中哪行数据
		public var business_id_bak:String;
		public var circuitcode_bak:String;
		
		public function CircuitBusinessModel()
		{
			no="";
			business_id="";
			circuitcode="";
			username="";
			updateperson="";
			business_name="";
			business_id_bak="";
			circuitcode_bak="";
			sort = "circuitcode";
			dir = "asc";
			index = "0";
			end = "50";
		}
		public function clear():void
		{
			no="";
			business_id="";
			circuitcode="";
			username="";
			updateperson="";
			business_name="";
			business_id_bak="";
			circuitcode_bak="";
		}
	}
}