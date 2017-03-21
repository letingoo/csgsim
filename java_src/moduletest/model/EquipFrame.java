package moduletest.model;

public class EquipFrame implements Comparable {
	private String no;//序号
	private String equipcode;//机框编码
	private String frameserial;//机框序号
	private String state_code;//状态编码
	private String model_code;//型号编码
	private String s_framename;//机框名称
	private String shelfinfo;//所属设备名称
	private String xfront;//x坐标
	private String yfront;//Y坐标
	private String frontwidth;//宽度
	private String frontheight;//高度
	private String remark;//备注
	private String updatedate;//更新时间
	private String updatedate_start;//查询开始时间
	private String updatedate_end;//查询结束时间
	private String updateperson;//更新人
	private String frame_state;//机框状态
	private String start;//查询开始标签
	private String end;//查询条数
	private String sort;//排序字段
	private String dir;//排序模式
	private String vendor;//厂商
//	private String system;//所属系统
	private String isNumber;//是否是数字
	private String equipshelfcode;//设备编码
	private String framemodel;//机框型号
	private String frontviewpic;
	private String projectname;

	public EquipFrame() {
		this.equipcode = "";
		this.frameserial = "";
		this.s_framename = "";
		this.shelfinfo = "";
		this.xfront = "";
		this.yfront = "";
		this.frontwidth = "";
		this.frontheight = "";
		this.remark = "";
		this.updatedate = "";
		this.updatedate_start = "";
		this.updatedate_end = "";
		this.updateperson = "";
		this.start = "0";
		this.end = "50";
		this.sort = "";
		this.dir = "asc";
		this.isNumber="";
		this.equipshelfcode = "";
	}


	public String getIsNumber() {
		return isNumber;
	}


	public void setIsNumber(String isNumber) {
		this.isNumber = isNumber;
	}


	public int compareTo(Object o) {
		if (this.equals((EquipFrame) o));
		return 0;
	}

	public boolean equals(EquipFrame ef) {
		if (this.equipcode == ef.equipcode
				&& this.frameserial == ef.frameserial
				&& this.shelfinfo == ef.shelfinfo && this.xfront == ef.xfront
				&& this.yfront == ef.yfront
				&& this.frontheight == ef.frontheight
				&& this.frontwidth == ef.frontwidth && this.remark == ef.remark
				&& this.updatedate == ef.updatedate
				&& this.updatedate_start == ef.updatedate_start
				&& this.updatedate_end == ef.updatedate_end
				&& this.updateperson == ef.updateperson) {
			return true;
		}
		return false;
	}

	public String getVendor() {
		return vendor;
	}

	public void setVendor(String vendor) {
		this.vendor = vendor;
	}

	public String getEquipcode() {
		return equipcode;
	}

	public void setEquipcode(String equipcode) {
		this.equipcode = equipcode;
	}

	public String getFrameserial() {
		return frameserial;
	}

	public void setFrameserial(String frameserial) {
		this.frameserial = frameserial;
	}

	public String getShelfinfo() {
		return shelfinfo;
	}

	public void setShelfinfo(String shelfinfo) {
		this.shelfinfo = shelfinfo;
	}

	public String getXfront() {
		return xfront;
	}

	public void setXfront(String xfront) {
		this.xfront = xfront;
	}

	public String getYfront() {
		return yfront;
	}

	public void setYfront(String yfront) {
		this.yfront = yfront;
	}

	public String getFrontwidth() {
		return frontwidth;
	}

	public void setFrontwidth(String frontwidth) {
		this.frontwidth = frontwidth;
	}

	public String getFrontheight() {
		return frontheight;
	}

	public void setFrontheight(String frontheight) {
		this.frontheight = frontheight;
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

	public String getUpdateperson() {
		return updateperson;
	}

	public void setUpdateperson(String updateperson) {
		this.updateperson = updateperson;
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

	public void setNo(String no) {
		this.no = no;
	}

	public String getNo() {
		return no;
	}

	/**
	 * @return the equipshelfcode
	 */
	public String getEquipshelfcode() {
		return equipshelfcode;
	}

	/**
	 * @param equipshelfcode the equipshelfcode to set
	 */
	public void setEquipshelfcode(String equipshelfcode) {
		this.equipshelfcode = equipshelfcode;
	}

	public String getFrame_state() {
		return frame_state;
	}

	public void setFrame_state(String frame_state) {
		this.frame_state = frame_state;
	}


	public String getFramemodel() {
		return framemodel;
	}


	public void setFramemodel(String framemodel) {
		this.framemodel = framemodel;
	}


	public String getFrontviewpic() {
		return frontviewpic;
	}


	public void setFrontviewpic(String frontviewpic) {
		this.frontviewpic = frontviewpic;
	}


	public String getS_framename() {
		return s_framename;
	}


	public void setS_framename(String s_framename) {
		this.s_framename = s_framename;
	}


	public String getProjectname() {
		return projectname;
	}


	public void setProjectname(String projectname) {
		this.projectname = projectname;
	}


	public String getState_code() {
		return state_code;
	}


	public void setState_code(String state_code) {
		this.state_code = state_code;
	}


	public String getModel_code() {
		return model_code;
	}


	public void setModel_code(String model_code) {
		this.model_code = model_code;
	}

}
