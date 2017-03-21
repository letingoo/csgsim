package sourceCode.ocableroute.model
{
	[Bindable]	
	[RemoteClass(alias="ocableroute.model.OcableEquipment")] 
	public class OcableEquipment
	{
		/** 设备或模块编码  */
		private var equipcode:String;
		
		/** 设备或模块名称 */
		private var equipname:String;
		
		public function OcableEquipment()
		{
			this.equipcode="";
			this.equipname="";
		}
	}
}