package netres.model;

public class LogicPort {
	private String no;
	private String equipcode;
	private String gb_equipcode;
	private String gb_frameserial;
	private String gb_slotserial;
	private String gb_packserial;
	private String gb_portserial;
	private String equipname;
	private String frameserial;
	private String slotserial;
	private String packserial;
	private String portserial;
	private String y_porttype;
	private String x_capability;
	private String status;
	private String connport;
	private String remark;
	private String updatedate;
	private String updateperson;
	private String updatedate_start;
	private String updatedate_end;
	private String logicport;
	private String start;
	private String end;
	private String sort;
	private String dir;
	private String system;
	private String MARK;
	private String isNumber;

	public LogicPort() {
		this.equipcode = "";
		this.gb_equipcode = "";
		this.gb_frameserial = "";
		this.gb_slotserial = "";
		this.gb_packserial = "";
		this.gb_portserial = "";
		this.equipname = "";
		this.frameserial = "";
		this.slotserial = "";
		this.packserial = "";
		this.portserial = "";
		this.y_porttype = "";
		this.x_capability = "";
		this.status = "";
		this.connport = "";
		this.remark = "";
		this.updatedate = "";
		this.updateperson = "";
		this.updatedate_start = "";
		this.updatedate_end = "";
		this.logicport = "";
		this.start = "0";
		this.end = "50";
		this.sort = "";
		this.dir = "asc";
		this.setSystem("");
		this.setVender("");
		this.MARK = "";
		this.isNumber = "";
	}

	public String getIsNumber() {
		return isNumber;
	}

	public void setIsNumber(String isNumber) {
		this.isNumber = isNumber;
	}

	public String getSystem() {
		return system;
	}

	public void setSystem(String system) {
		this.system = system;
	}

	private String vender;

	public String getVender() {
		return vender;
	}

	public void setVender(String vender) {
		this.vender = vender;
	}

	public String getEquipcode() {
		return equipcode;
	}

	public void setEquipcode(String equipcode) {
		this.equipcode = equipcode;
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

	public String getPortserial() {
		return portserial;
	}

	public void setPortserial(String portserial) {
		this.portserial = portserial;
	}

	public String getY_porttype() {
		return y_porttype;
	}

	public void setY_porttype(String y_porttype) {
		this.y_porttype = y_porttype;
	}

	public String getX_capability() {
		return x_capability;
	}

	public void setX_capability(String x_capability) {
		this.x_capability = x_capability;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getConnport() {
		return connport;
	}

	public void setConnport(String connport) {
		this.connport = connport;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getUpdatedate() {
		return updatedate;
	}

	public void setUpdatedate(String updatedate) {
		this.updatedate = updatedate;
	}

	public String getUpdateperson() {
		return updateperson;
	}

	public void setUpdateperson(String updateperson) {
		this.updateperson = updateperson;
	}

	public String getUpdatedate_start() {
		return updatedate_start;
	}

	public void setUpdatedate_start(String updatedate_start) {
		this.updatedate_start = updatedate_start;
	}

	public String getUpdatedate_end() {
		return updatedate_end;
	}

	public void setUpdatedate_end(String updatedate_end) {
		this.updatedate_end = updatedate_end;
	}

	public String getLogicport() {
		return logicport;
	}

	public void setLogicport(String logicport) {
		this.logicport = logicport;
	}

	public String getStart() {
		return start;
	}

	public void setStart(String start) {
		this.start = start;
	}

	public String getEnd() {
		return end;
	}

	public void setEnd(String end) {
		this.end = end;
	}

	public String getSort() {
		return sort;
	}

	public void setSort(String sort) {
		this.sort = sort;
	}

	public String getDir() {
		return dir;
	}

	public void setDir(String dir) {
		this.dir = dir;
	}

	public String getGb_equipcode() {
		return gb_equipcode;
	}

	public void setGb_equipcode(String gb_equipcode) {
		this.gb_equipcode = gb_equipcode;
	}

	public String getGb_frameserial() {
		return gb_frameserial;
	}

	public void setGb_frameserial(String gb_frameserial) {
		this.gb_frameserial = gb_frameserial;
	}

	public String getGb_slotserial() {
		return gb_slotserial;
	}

	public void setGb_slotserial(String gb_slotserial) {
		this.gb_slotserial = gb_slotserial;
	}

	public String getGb_packserial() {
		return gb_packserial;
	}

	public void setGb_packserial(String gb_packserial) {
		this.gb_packserial = gb_packserial;
	}

	public String getGb_portserial() {
		return gb_portserial;
	}

	public void setGb_portserial(String gb_portserial) {
		this.gb_portserial = gb_portserial;
	}

	/**
	 * @param mARK
	 *            the mARK to set
	 */
	public void setMARK(String mARK) {
		MARK = mARK;
	}

	/**
	 * @return the mARK
	 */
	public String getMARK() {
		return MARK;
	}

	public void setNo(String no) {
		this.no = no;
	}

	public String getNo() {
		return no;
	}

}
