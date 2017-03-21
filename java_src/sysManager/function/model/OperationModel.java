package sysManager.function.model;

public class OperationModel{
	private String oper_id;
	private String oper_name;
	private String parent_id;
	private String oper_desc;
	private String ischilden;
	public String getIschilden() {
		return ischilden;
	}
	public void setIschilden(String ischilden) {
		this.ischilden = ischilden;
	}
	public String getOper_id() {
		return oper_id;
	}
	public void setOper_id(String oper_id) {
		this.oper_id = oper_id;
	}
	public String getOper_name() {
		return oper_name;
	}
	public void setOper_name(String oper_name) {
		this.oper_name = oper_name;
	}
	public String getParent_id() {
		return parent_id;
	}
	public void setParent_id(String parent_id) {
		this.parent_id = parent_id;
	}
	public String getOper_desc() {
		return oper_desc;
	}
	public void setOper_desc(String oper_desc) {
		this.oper_desc = oper_desc;
	}
}
