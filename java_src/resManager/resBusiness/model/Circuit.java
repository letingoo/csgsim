package resManager.resBusiness.model;

public class Circuit{
	/**
	 * 序号
	 */
	private String no;
	/**
	 * 电路编号
	 */
	private String circuitcode;
	
	/**
	 * 起始局站
	 */
	private String station1;
	/**
	 * 电路名称
	 */
	private String username;
	/**
	 * 终止局站
	 */
	private String station2;
	/**
	 * 起始设备
	 */
	private String city1;
	/**
	 * 终止设备
	 */
	private String city2;
	private String serial;
	/**
	 * 业务类型
	 */
	private String x_purpose;
	private String createtime;
	/**
	 * 开通时间
	 */
	private String usetime;
	/**
	 * 速率
	 */
	private String rate;
	private String property;
	private String hirecircuitcode;
	private String path;
	/**
	 * 网管A端端口 
	 */
	private String portserialno1;
	/**
	 * A端时隙
	 */
	private String slot1;
	/**
	 * 网管Z端端口 
	 */
	private String portserialno2;
	/**
	 * Z端时隙
	 */
	private String slot2;
	private String area;
	private String systemcode;
	private String leaser;
	private String hiredate;
	private String schedulerid;
	private String requisitionid;
	private String state;
	private String remark;
	private String updateperson;
	private String updatedate;
	private String circuitserial;
	private String circuitlevel;
	private String operationtype;
	private String interfacetype;
	private String netmanagerid;
	/**
	 *资源A端端口 
	 */
	private String portcode1;
	/**
	 * 资源A端端口名称
	 */
	private String portname1;
	/**
	 *资源Z端端口 
	 */
	private String portcode2;
	/**
	 * 资源Z端端口名称
	 */
	private String portname2;
	/**
	 * 方式单编号
	 */
	
	private String circuitcode_bak;//用来修改主键
//	private String area;
//	private String leaser;
	private int form_id;
	private int circuitLevel;
//	private String operationtype;
    private String usercom;
    private String requestcom;
//    private String createtime;
    private String check1;
    private String check2;
    private String beizhu;
    private String cooperateDepartment;
    private String newcircuitcode;
    private String powerline;
    private String protectdevicetype;
	private String implementation_units;
	private String requestfinish_time;
	private String approver;
	private String sort;
	private String dir;
	private String index;
	private String delay1;
	private String delay2;
	
	public Circuit() {
		this.circuitcode="";
		this.station1="";
		this.station2="";
		this.username="";
		this.city1="";
		this.city2="";
		this.serial = "";
		this.x_purpose ="";
		this.usetime = "";
		this.rate = "";
		this.property = "";
		this.portserialno1 = "";
		this.slot1 = "";
		this.portserialno2 = "";
		this.slot2 = "";
		this.remark = "";
		this.area ="";
		this.leaser ="";
		this.requisitionid="";
    	this.state="";
		this.form_id = 0;
		this.circuitLevel = 0;
		this.operationtype = "";
		this.usercom = "";
		this.requestcom ="";
		this.createtime = "";
		this.check1 = "";
		this.check2="";
		this.beizhu="";
		this.cooperateDepartment="";
		this.interfacetype="";
		this.newcircuitcode="";
		this.powerline="";
		this.protectdevicetype="";
		this.implementation_units="";
		this.delay1="";
		this.delay2="";
	}
	public String getIndex() {
		return index;
	}

	public void setIndex(String index) {
		this.index = index;
	}

	private String end;
    public String getApprover() {
		return approver;
	}

	public void setApprover(String approver) {
		this.approver = approver;
	}

	public String getRequestfinish_time() {
		return requestfinish_time;
	}

	public void setRequestfinish_time(String requestfinish_time) {
		this.requestfinish_time = requestfinish_time;
	}

	public String getImplementation_units() {
		return implementation_units;
	}

	public void setImplementation_units(String implementation_units) {
		this.implementation_units = implementation_units;
	}

	
    
    public String getFormName() {
        return formName;
    }

    public void setFormName(String formName) {
        this.formName = formName;
    }

    private String formName;
    public String getCooperateDepartment() {
        return cooperateDepartment;
    }

    public void setCooperateDepartment(String cooperateDepartment) {
        this.cooperateDepartment = cooperateDepartment;
    }
	public String getOperationtype() {
		return operationtype;
	}
	public void setOperationtype(String operationtype) {
		this.operationtype = operationtype;
	}
	public String getCircuitcode() {
		return circuitcode;
	}
	public void setCircuitcode(String circuitcode) {
		this.circuitcode = circuitcode;
	}
	public String getStation1() {
		return station1;
	}
	public void setStation1(String station1) {
		this.station1 = station1;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getStation2() {
		return station2;
	}
	public void setStation2(String station2) {
		this.station2 = station2;
	}
	public String getCity1() {
		return city1;
	}
	public void setCity1(String city1) {
		this.city1 = city1;
	}
	public String getCity2() {
		return city2;
	}
	public void setCity2(String city2) {
		this.city2 = city2;
	}
	public String getSerial() {
		return serial;
	}
	public void setSerial(String serial) {
		this.serial = serial;
	}
	public String getX_purpose() {
		return x_purpose;
	}
	public void setX_purpose(String x_purpose) {
		this.x_purpose = x_purpose;
	}
	public String getUsetime() {
		return usetime;
	}
	public void setUsetime(String usetime) {
		this.usetime = usetime;
	}
	public String getRate() {
		return rate;
	}
	public void setRate(String rate) {
		this.rate = rate;
	}
	public String getProperty() {
		return property;
	}
	public void setProperty(String property) {
		this.property = property;
	}
	public String getPortserialno1() {
		return portserialno1;
	}
	public void setPortserialno1(String portserialno1) {
		this.portserialno1 = portserialno1;
	}
	public String getSlot1() {
		return slot1;
	}
	public void setSlot1(String slot1) {
		this.slot1 = slot1;
	}
	public String getPortserialno2() {
		return portserialno2;
	}
	public void setPortserialno2(String portserialno2) {
		this.portserialno2 = portserialno2;
	}
	public String getSlot2() {
		return slot2;
	}
	public void setSlot2(String slot2) {
		this.slot2 = slot2;
	}
	public String getArea() {
		return area;
	}
	public void setArea(String area) {
		this.area = area;
	}
	public String getLeaser() {
		return leaser;
	}
	public void setLeaser(String leaser) {
		this.leaser = leaser;
	}
	public String getRequisitionid() {
		return requisitionid;
	}
	public void setRequisitionid(String requisitionid) {
		this.requisitionid = requisitionid;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public int getForm_id() {
		return form_id;
	}
	public void setForm_id(int form_id) {
		this.form_id = form_id;
	}
	public int getCircuitLevel() {
		return circuitLevel;
	}
	public void setCircuitLevel(int circuitLevel) {
		this.circuitLevel = circuitLevel;
	}

    public String getUsercom() {
        return usercom;
    }

    public void setUsercom(String usercom) {
        this.usercom = usercom;
    }

    public String getRequestcom() {
        return requestcom;
    }

    public void setRequestcom(String requestcom) {
        this.requestcom = requestcom;
    }

    public String getCreatetime() {
        return createtime;
    }

    public void setCreatetime(String createtime) {
        this.createtime = createtime;
    }

    public String getCheck1() {
        return check1;
    }

    public void setCheck1(String check1) {
        this.check1 = check1;
    }

    public String getCheck2() {
        return check2;
    }

    public void setCheck2(String check2) {
        this.check2 = check2;
    }

    public String getBeizhu() {
        return beizhu;
    }

    public void setBeizhu(String beizhu) {
        this.beizhu = beizhu;
    }

	public String getInterfacetype() {
		return interfacetype;
	}

	public void setInterfacetype(String interfacetype) {
		this.interfacetype = interfacetype;
	}

	public String getNewcircuitcode() {
		return newcircuitcode;
	}

	public void setNewcircuitcode(String newcircuitcode) {
		this.newcircuitcode = newcircuitcode;
	}

	public String getPowerline() {
		return powerline;
	}

	public void setPowerline(String powerline) {
		this.powerline = powerline;
	}

	public String getProtectdevicetype() {
		return protectdevicetype;
	}

	public void setProtectdevicetype(String protectdevicetype) {
		this.protectdevicetype = protectdevicetype;
	}

	public String getPortcode1() {
		return portcode1;
	}

	public void setPortcode1(String portcode1) {
		this.portcode1 = portcode1;
	}

	public String getPortcode2() {
		return portcode2;
	}

	public void setPortcode2(String portcode2) {
		this.portcode2 = portcode2;
	}

	public String getPortname1() {
		return portname1;
	}

	public void setPortname1(String portname1) {
		this.portname1 = portname1;
	}

	public String getPortname2() {
		return portname2;
	}

	public void setPortname2(String portname2) {
		this.portname2 = portname2;
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


	public String getEnd() {
		return end;
	}

	public void setEnd(String end) {
		this.end = end;
	}

	public String getNo() {
		return no;
	}

	public void setNo(String no) {
		this.no = no;
	}
	
	public String getSchedulerid() {
		return schedulerid;
	}

	public void setSchedulerid(String schedulerid) {
		this.schedulerid = schedulerid;
	}
	public String getCircuitcode_bak() {
		return circuitcode_bak;
	}

	public void setCircuitcode_bak(String circuitcode_bak) {
		this.circuitcode_bak = circuitcode_bak;
	}
	public String getHirecircuitcode() {
		return hirecircuitcode;
	}

	public void setHirecircuitcode(String hirecircuitcode) {
		this.hirecircuitcode = hirecircuitcode;
	}
	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public String getSystemcode() {
		return systemcode;
	}

	public void setSystemcode(String systemcode) {
		this.systemcode = systemcode;
	}

	public String getHiredate() {
		return hiredate;
	}

	public void setHiredate(String hiredate) {
		this.hiredate = hiredate;
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

	public String getCircuitserial() {
		return circuitserial;
	}

	public void setCircuitserial(String circuitserial) {
		this.circuitserial = circuitserial;
	}

	public String getCircuitlevel() {
		return circuitlevel;
	}

	public void setCircuitlevel(String circuitlevel) {
		this.circuitlevel = circuitlevel;
	}

	public String getNetmanagerid() {
		return netmanagerid;
	}

	public void setNetmanagerid(String netmanagerid) {
		this.netmanagerid = netmanagerid;
	}
	public String getDelay1() {
		return delay1;
	}
	public void setDelay1(String delay1) {
		this.delay1 = delay1;
	}
	public String getDelay2() {
		return delay2;
	}
	public void setDelay2(String delay2) {
		this.delay2 = delay2;
	}

}