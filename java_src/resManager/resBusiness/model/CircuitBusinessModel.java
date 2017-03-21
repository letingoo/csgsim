package resManager.resBusiness.model;

public class CircuitBusinessModel{
	/**
	 * 序号
	 */
	private String no;
	/**
	 * 业务编号
	 */
	private String business_id;
	/**
	 *电路名称 
	 */
	private String circuitcode;
	/**
	 *电路名称 
	 */
	private String username;
	/**
	 *业务名称 
	 */
	private String business_name;
	/**
	 *更新人
	 */
	private String updateperson;
	private String business_id_bak;//用来修改主键
	private String circuitcode_bak;//用来修改主键
	private String sort;
	private String dir;
	private String index;
	private String end;
	public String getNo() {
		return no;
	}
	public void setNo(String no) {
		this.no = no;
	}
	public String getBusiness_id() {
		return business_id;
	}
	public void setBusiness_id(String business_id) {
		this.business_id = business_id;
	}
	public String getCircuitcode() {
		return circuitcode;
	}
	public void setCircuitcode(String circuitcode) {
		this.circuitcode = circuitcode;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getBusiness_name() {
		return business_name;
	}
	public void setBusiness_name(String business_name) {
		this.business_name = business_name;
	}
	public String getUpdateperson() {
		return updateperson;
	}
	public void setUpdateperson(String updateperson) {
		this.updateperson = updateperson;
	}
	public String getBusiness_id_bak() {
		return business_id_bak;
	}
	public void setBusiness_id_bak(String business_id_bak) {
		this.business_id_bak = business_id_bak;
	}
	public String getCircuitcode_bak() {
		return circuitcode_bak;
	}
	public void setCircuitcode_bak(String circuitcode_bak) {
		this.circuitcode_bak = circuitcode_bak;
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
	public String getIndex() {
		return index;
	}
	public void setIndex(String index) {
		this.index = index;
	}
	public String getEnd() {
		return end;
	}
	public void setEnd(String end) {
		this.end = end;
	}

}