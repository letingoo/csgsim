package devicepanel.model;

public class PackInfoModel {
	private String equipname;
	private String frameserial ;
	private String slotserial;
	private String packmodel ;
	private String packserial;
	private String updatedate;
	private String remark ;
	private String updateperson ;
	private String packsn;
	private String software_version;
	private String hardware_version;
	
	//
	private String x_vendor;
	private String x_model;
	private String portnum;
	private String x_capability;
	
	public String getPacksn() {
		return packsn;
	}
	public void setPacksn(String packsn) {
		this.packsn = packsn;
	}
	public String getSoftware_version() {
		return software_version;
	}
	public void setSoftware_version(String softwareVersion) {
		software_version = softwareVersion;
	}
	public String getHardware_version() {
		return hardware_version;
	}
	public void setHardware_version(String hardwareVersion) {
		hardware_version = hardwareVersion;
	}
	public PackInfoModel()
	{
		equipname = "";//设备名称
		frameserial = "";//机框序号
		slotserial = "";//机槽型号
		packmodel = "";//机盘型号
		packserial = "";//机盘序号
		updatedate = "";//更新时间
		remark = "";//备注
		updateperson = "";//更新�?
		x_vendor="";
		x_model="";
		portnum="";
		x_capability="";
	}
		public String getEquipname() {
			return equipname;
		}

		public void setEquipname(String equipname) {
			this.equipname = equipname;
		}

		public String getFrameserial() {
			return frameserial;
		}

		public void setFrameserial(String frameserial) {
			this.frameserial = frameserial;
		}

		public String getSlotserial() {
			return slotserial;
		}

		public void setSlotserial(String slotserial) {
			this.slotserial = slotserial;
		}

		public String getPackserial() {
			return packserial;
		}

		public void setPackserial(String packserial) {
			this.packserial = packserial;
		}

		public String getPackmodel() {
			return packmodel;
		}

		public void setPackmodel(String packmodel) {
			this.packmodel = packmodel;
		}

		public String getRemark() {
			return remark;
		}

		public void setRemark(String remark) {
			this.remark = remark;
		}

		public String getUpdateperson() {
			return updateperson;
		}

		public void setUpdateperson(String updateperson) {
			this.updateperson = updateperson;
		}

		public String getUpdatedate() {
			return updatedate;
		}

		public void setUpdatedate(String updatedate) {
			this.updatedate = updatedate;
		}
		public String getX_vendor() {
			return x_vendor;
		}
		public void setX_vendor(String x_vendor) {
			this.x_vendor = x_vendor;
		}
		public String getX_model() {
			return x_model;
		}
		public void setX_model(String x_model) {
			this.x_model = x_model;
		}
		public String getPortnum() {
			return portnum;
		}
		public void setPortnum(String portnum) {
			this.portnum = portnum;
		}
		public String getX_capability() {
			return x_capability;
		}
		public void setX_capability(String x_capability) {
			this.x_capability = x_capability;
		}


	 }


