package sysManager.log.model;

public class LogModel {
	private String no;
	private Integer log_id;
	private String log_type;
	private String module_desc;
	private String func_desc;
	private String data_id;
	private String user_id;
	private String user_name;
	private String dept_name;
	private	String user_ip;
	private String log_time;
	private String start;
	private String end;
	public Integer getLog_id() {
		return log_id;
	}
	public void setLog_id(Integer logId) {
		log_id = logId;
	}
	public String getLog_type() {
		return log_type;
	}
	public void setLog_type(String logType) {
		log_type = logType;
	}
	public String getModule_desc() {
		return module_desc;
	}
	public void setModule_desc(String moduleDesc) {
		module_desc = moduleDesc;
	}
	public String getFunc_desc() {
		return func_desc;
	}
	public void setFunc_desc(String funcDesc) {
		func_desc = funcDesc;
	}
	public String getData_id() {
		return data_id;
	}
	public void setData_id(String dataId) {
		data_id = dataId;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String userId) {
		user_id = userId;
	}
	public String getUser_name() {
		return user_name;
	}
	public void setUser_name(String userName) {
		user_name = userName;
	}
	public String getDept_name() {
		return dept_name;
	}
	public void setDept_name(String deptName) {
		dept_name = deptName;
	}
	public String getUser_ip() {
		return user_ip;
	}
	public void setUser_ip(String userIp) {
		user_ip = userIp;
	}
	public String getLog_time() {
		return log_time;
	}
	public void setLog_time(String logTime) {
		log_time = logTime;
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
	public void setNo(String no) {
		this.no = no;
	}
	public String getNo() {
		return no;
	}

}
