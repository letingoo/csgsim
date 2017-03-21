package resManager.resNet.model;

// TODO: Auto-generated Javadoc
/**
 * 时隙交叉对象.
 */
public class CCModel {

	private String no;

	/** 主键. */
	private String id;

	/** 电路编号. */
	private String circuitcode;
	
	/** 设备ID. */
	private String pid;
	
	/** 速率. */
	private String rate;
	
	/** 方向. */
	private String direction;
	
	/** a端端口. */
	private String aptp;
	
	/** a端时隙. */
	private String aslot;
	
	/** z端端口. */
	private String zptp;
	
	/** z端时隙. */
	private String zslot;
	
	/** 类型. */
	private String type;
	
	/** 更新人. */
	private String updateperson;
	/** 配置方式. */
	private String isdefault;
	/** 同步状态 */
	private String sync_status;
	/** 更新时间 */ 	
	private String updatedate;
	/** 实际速率*/
	private String real_rate;
	
	/** 实际时隙*/
	private String real_aslot;
	
	/** 实际时隙*/
	private String real_zslot;
	/** 查询开始*/
	private String start;
	/** 总共查询数目*/
	private String end;
	/** 排序字段*/
	private String sort;
	/** 排序方式*/
	private String dir;
	private String updatedate_start;//查询开始时间
    private String updatedate_end;//查询结束时间
    private String otherType;
	


	public String getNo() {
		return no;
	}

	public void setNo(String no) {
		this.no = no;
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

	public String getReal_rate() {
		return real_rate;
	}

	public void setReal_rate(String real_rate) {
		this.real_rate = real_rate;
	}

	public String getReal_aslot() {
		return real_aslot;
	}

	public void setReal_aslot(String real_aslot) {
		this.real_aslot = real_aslot;
	}

	public String getReal_zslot() {
		return real_zslot;
	}

	public void setReal_zslot(String real_zslot) {
		this.real_zslot = real_zslot;
	}

	/**
	 * Gets the id.
	 * 
	 * @return the id
	 */
	public String getId() {
		return id;
	}

	/**
	 * Sets the id.
	 * 
	 * @param id the id
	 */
	public void setId(String id) {
		this.id = id;
	}

	/**
	 * Gets the circuitcode.
	 * 
	 * @return the circuitcode
	 */
	public String getCircuitcode() {
		return circuitcode;
	}

	/**
	 * Sets the circuitcode.
	 * 
	 * @param circuitcode the circuitcode
	 */
	public void setCircuitcode(String circuitcode) {
		this.circuitcode = circuitcode;
	}

	/**
	 * Gets the pid.
	 * 
	 * @return the pid
	 */
	public String getPid() {
		return pid;
	}

	/**
	 * Sets the pid.
	 * 
	 * @param pid the pid
	 */
	public void setPid(String pid) {
		this.pid = pid;
	}

	/**
	 * Gets the rate.
	 * 
	 * @return the rate
	 */
	public String getRate() {
		return rate;
	}

	/**
	 * Sets the rate.
	 * 
	 * @param rate the rate
	 */
	public void setRate(String rate) {
		this.rate = rate;
	}

	/**
	 * Gets the direction.
	 * 
	 * @return the direction
	 */
	public String getDirection() {
		return direction;
	}

	/**
	 * Sets the direction.
	 * 
	 * @param direction the direction
	 */
	public void setDirection(String direction) {
		this.direction = direction;
	}

	/**
	 * Gets the aptp.
	 * 
	 * @return the aptp
	 */
	public String getAptp() {
		return aptp;
	}

	/**
	 * Sets the aptp.
	 * 
	 * @param aptp the aptp
	 */
	public void setAptp(String aptp) {
		this.aptp = aptp;
	}

	/**
	 * Gets the aslot.
	 * 
	 * @return the aslot
	 */
	public String getAslot() {
		return aslot;
	}

	/**
	 * Sets the aslot.
	 * 
	 * @param aslot the aslot
	 */
	public void setAslot(String aslot) {
		this.aslot = aslot;
	}

	/**
	 * Gets the zptp.
	 * 
	 * @return the zptp
	 */
	public String getZptp() {
		return zptp;
	}

	/**
	 * Sets the zptp.
	 * 
	 * @param zptp the zptp
	 */
	public void setZptp(String zptp) {
		this.zptp = zptp;
	}

	/**
	 * Gets the zslot.
	 * 
	 * @return the zslot
	 */
	public String getZslot() {
		return zslot;
	}

	/**
	 * Sets the zslot.
	 * 
	 * @param zslot the zslot
	 */
	public void setZslot(String zslot) {
		this.zslot = zslot;
	}

	/**
	 * Gets the type.
	 * 
	 * @return the type
	 */
	public String getType() {
		return type;
	}

	/**
	 * Sets the type.
	 * 
	 * @param type the type
	 */
	public void setType(String type) {
		this.type = type;
	}

	/**
	 * Gets the updateperson.
	 * 
	 * @return the updateperson
	 */
	public String getUpdateperson() {
		return updateperson;
	}

	/**
	 * Sets the updateperson.
	 * 
	 * @param updateperson the updateperson
	 */
	public void setUpdateperson(String updateperson) {
		this.updateperson = updateperson;
	}
    public String getIsdefault() {
		return isdefault;
	}

	public void setIsdefault(String isdefault) {
		this.isdefault = isdefault;
	}

	public String getSync_status() {
		return sync_status;
	}

	public void setSync_status(String sync_status) {
		this.sync_status = sync_status;
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

	public String getOtherType() {
		return otherType;
	}

	public void setOtherType(String otherType) {
		this.otherType = otherType;
	}
	
}