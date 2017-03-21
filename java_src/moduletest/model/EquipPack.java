package moduletest.model;

public class EquipPack {
	private String no;
	private String equipcode;
	private String equipname;
	private String frameserial;
	private String slotserial;
	private String packserial;
	private String packmodel;
	private String remark;
	private String updatedate;
	private String updateperson;
	private String updatedate_start;
    private String updatedate_end;
    private String gb_equipcode;
	private String gb_frameserial;
	private String gb_slotserial;
	private String gb_packserial;
	private String start;
	private String end;
	private String sort;
	private String dir;
	private String vender;
	private String system;
	private String isNumber;
	
	private String portrate;
	private String id;
	
	public EquipPack()
	{
		this.equipcode="";
		this.equipname="";
		this.frameserial="";
		this.slotserial="";
		this.packserial="";
		this.packmodel="";
		this.remark="";
		this.updatedate="";
		this.updateperson="";
		this.updatedate_start="";
		this.updatedate_end="";
		this.start="0";
		this.end="50";
		this.sort="";
		this.dir="asc";
		this.gb_equipcode="";
		this.gb_frameserial="";
		this.gb_slotserial="";
		this.gb_packserial="";
		this.vender = "";
		this.system = "";
		this.isNumber = "";
	}
	
	public String getVender() {
		return vender;
	}

	public void setVender(String vender) {
		this.vender = vender;
	}

	public String getSystem() {
		return system;
	}

	public void setSystem(String system) {
		this.system = system;
	}

	public String getIsNumber() {
		return isNumber;
	}

	public void setIsNumber(String isNumber) {
		this.isNumber = isNumber;
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
	public void setNo(String no) {
		this.no = no;
	}
	public String getNo() {
		return no;
	}

	public String getPortrate() {
		return portrate;
	}

	public void setPortrate(String portrate) {
		this.portrate = portrate;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	

}
