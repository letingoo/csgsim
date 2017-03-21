package ocableResources.model;

public class OcableSection {
	public String no;
	public String serialNO;
	public String sectioncode;
	public String a_point;
	public String a_pointtype;
	public String a_pointname;
	public String z_point;
	public String z_pointtype;
	public String z_pointname;
	public String ocablemodel;
	public String length ;
	public String property;	
	public String buildmode;
	public String laymode ;
	public String updateperson ;
	public String updatedate ;
	public String comcores;
	public String protectcores;
	public String fibercount;
	public String occupyfibercount ;
	public String rundate;
	public String agentvendor;
	public String one_name ;
	public String run_unit;
	public String check_unit;
	public String voltlevel;
	public String ocablesectionname;
	public String rule;
	public String isbuilding;
	public String laymodelen;
	public String function_unit;
	public String remark;
	public String sort;
	public String dir;
	public String start;
	public String end;
	private String updatedate_start;
    private String updatedate_end;
    public String secvolt;
    public String province;
    public String provincename;
	private String platelong;
    private String powerstationdate;
    private String money;
    private String user_id;

    public String getProvince() {
		return province;
	}


	public void setProvince(String province) {
		this.province = province;
	}
    public String getPlatelong() {
		return platelong;
	}


	public void setPlatelong(String platelong) {
		this.platelong = platelong;
	}


	public String getPowerstationdate() {
		return powerstationdate;
	}


	public void setPowerstationdate(String powerstationdate) {
		this.powerstationdate = powerstationdate;
	}

	public String getMoney() {
		return money;
	}


	public void setMoney(String money) {
		this.money = money;
	}
	
	public OcableSection(){
			this.no = "";
			this.serialNO="";
			this.sectioncode = "";
			this.a_point = "";
			this.a_pointtype = "";
			this.z_pointname = "";
			this.z_point = "";
			this.z_pointtype = "";
			this.a_pointname = "";
			this.ocablemodel = "";
			this.length = "";
			this.property = "";
			this.agentvendor="";
			this.check_unit="";
			this.comcores="";
			this.isbuilding="";
			this.laymodelen="";
			this.protectcores="";
			this.rule="";
			this.rundate="";
			this.laymode = "";
			this.fibercount ="";
			this.occupyfibercount="";
			this.run_unit="";
			this.one_name="";
			this.voltlevel="";
			this.ocablesectionname="";
			this.function_unit="";
			this.sort="ocablesectionname";
			this.end="";
			this.updatedate="";
			this.updateperson="";
			this.remark="";
			this.start="";
			this.dir ="asc";
			this.updatedate_start="";
			this.updatedate_end="";
			this.secvolt = "" ;
 	        this.platelong = "";
            this.powerstationdate = "";
            this.money = "";
		}


	public String getUpdatedate_start() {
		return updatedate_start;
	}

	public void setUpdatedate_start(String updatedateStart) {
		updatedate_start = updatedateStart;
	}

	public String getUpdatedate_end() {
		return updatedate_end;
	}

	public void setUpdatedate_end(String updatedateEnd) {
		updatedate_end = updatedateEnd;
	}


	public String getNo() {
		return no;
	}

	public void setNo(String no) {
		this.no = no;
	}

	public String getSerialNO() {
		return serialNO;
	}

	public void setSerialNO(String serialNO) {
		this.serialNO = serialNO;
	}

	public String getSectioncode() {
		return sectioncode;
	}

	public void setSectioncode(String sectioncode) {
		this.sectioncode = sectioncode;
	}

	public String getA_point() {
		return a_point;
	}

	public void setA_point(String aPoint) {
		a_point = aPoint;
	}

	public String getA_pointtype() {
		return a_pointtype;
	}

	public void setA_pointtype(String aPointtype) {
		a_pointtype = aPointtype;
	}

	public String getA_pointname() {
		return a_pointname;
	}

	public void setA_pointname(String aPointname) {
		a_pointname = aPointname;
	}

	public String getZ_point() {
		return z_point;
	}

	public void setZ_point(String zPoint) {
		z_point = zPoint;
	}

	public String getZ_pointtype() {
		return z_pointtype;
	}

	public void setZ_pointtype(String zPointtype) {
		z_pointtype = zPointtype;
	}

	public String getZ_pointname() {
		return z_pointname;
	}

	public void setZ_pointname(String zPointname) {
		z_pointname = zPointname;
	}

	public String getOcablemodel() {
		return ocablemodel;
	}

	public void setOcablemodel(String ocablemodel) {
		this.ocablemodel = ocablemodel;
	}

	public String getLength() {
		return length;
	}

	public void setLength(String length) {
		this.length = length;
	}

	public String getProperty() {
		return property;
	}

	public void setProperty(String property) {
		this.property = property;
	}

	public String getBuildmode() {
		return buildmode;
	}

	public void setBuildmode(String buildmode) {
		this.buildmode = buildmode;
	}

	public String getLaymode() {
		return laymode;
	}

	public void setLaymode(String laymode) {
		this.laymode = laymode;
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

	public String getComcores() {
		return comcores;
	}

	public void setComcores(String comcores) {
		this.comcores = comcores;
	}

	public String getProtectcores() {
		return protectcores;
	}

	public void setProtectcores(String protectcores) {
		this.protectcores = protectcores;
	}

	public String getFibercount() {
		return fibercount;
	}

	public void setFibercount(String fibercount) {
		this.fibercount = fibercount;
	}

	public String getOccupyfibercount() {
		return occupyfibercount;
	}

	public void setOccupyfibercount(String occupyfibercount) {
		this.occupyfibercount = occupyfibercount;
	}

	public String getRundate() {
		return rundate;
	}

	public void setRundate(String rundate) {
		this.rundate = rundate;
	}

	public String getAgentvendor() {
		return agentvendor;
	}

	public void setAgentvendor(String agentvendor) {
		this.agentvendor = agentvendor;
	}

	public String getOne_name() {
		return one_name;
	}

	public void setOne_name(String oneName) {
		one_name = oneName;
	}

	public String getRun_unit() {
		return run_unit;
	}

	public void setRun_unit(String runUnit) {
		run_unit = runUnit;
	}

	public String getCheck_unit() {
		return check_unit;
	}

	public void setCheck_unit(String checkUnit) {
		check_unit = checkUnit;
	}

	public String getVoltlevel() {
		return voltlevel;
	}

	public void setVoltlevel(String voltlevel) {
		this.voltlevel = voltlevel;
	}

	public String getOcablesectionname() {
		return ocablesectionname;
	}

	public void setOcablesectionname(String ocablesectionname) {
		this.ocablesectionname = ocablesectionname;
	}

	public String getRule() {
		return rule;
	}

	public void setRule(String rule) {
		this.rule = rule;
	}

	public String getIsbuilding() {
		return isbuilding;
	}

	public void setIsbuilding(String isbuilding) {
		this.isbuilding = isbuilding;
	}

	public String getLaymodelen() {
		return laymodelen;
	}

	public void setLaymodelen(String laymodelen) {
		this.laymodelen = laymodelen;
	}

	public String getFunction_unit() {
		return function_unit;
	}

	public void setFunction_unit(String functionUnit) {
		function_unit = functionUnit;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
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


	public String getSecvolt() {
		return secvolt;
	}


	public void setSecvolt(String secvolt) {
		this.secvolt = secvolt;
	}


	public String getUser_id() {
		return user_id;
	}


	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}


	/**
	 * @return the provincename
	 */
	public String getProvincename() {
		return provincename;
	}


	/**
	 * @param provincename the provincename to set
	 */
	public void setProvincename(String provincename) {
		this.provincename = provincename;
	}
	

}
