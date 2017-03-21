package sourceCode.equipGraph.model
{
	[Bindable]	
	[RemoteClass(alias="devicepanel.model.DevicePanelModel")] 
	public class DevicePanelModel
	{

		public var equipcode:String;//设备编码
		public var equipname:String;//设备名称
		public var frameserial:String;//机框序号
		public var slotserial:String;//机槽型号
		public var packmodel:String;//机盘型号
		public var packserial:String;//机盘序号
		public var updatedate:String;//更新时间
		public var remark:String;//备注
		public var updateperson:String;//更新人
		public function EquipInfo()
		{
			
			equipcode = "";//设备编码
			equipname = "";//设备名称
			frameserial = "";//机框序号
			slotserial = "";//机槽型号
			packmodel = "";//机盘型号
			packserial = "";//机盘序号
			updatedate = "";//更新时间
			remark = "";//备注
			updateperson = "";//更新人
			
		
		}
	}
}