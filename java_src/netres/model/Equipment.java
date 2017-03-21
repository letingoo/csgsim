package netres.model;

public class Equipment {
	private String no;
	private String equipcode;
	private String equipname;
	private String x_vendor ;
	private String x_model;
	private String equiptype ;
	private String nename;
	private String systemcode ;
	private String projectname ;
	private String equiplabel ;
	private String shelfinfo;
	private String stationcode;
	private String roomcode;
	private String stationname;
	private String roomname;
	private String nsap ;
	private String property;
	private String updatedate ;
	private String updateperson;
	private String remark;
	private String purpose;
	private String province;
	private String status;
	private String x_configcapacity;
	private String x_sbcapacity;
	private String updatedate_start;
    private String updatedate_end;
	private String start;
	private String end;
	private String sort;
	private String dir;
	private String version;
//	private String user_id;
	public Equipment()
	{
		this.remark = "";
		this.purpose = "";
		this.province="";
		this.status = "";
		this.equipcode="";
		this.equipname="";
		this.x_vendor="";
		this.x_model="";
		this.equiptype="";
		this.nename="";
		this.systemcode="";
		this.projectname="";
		this.equiplabel="";
		this.shelfinfo="";
		this.nsap="";
		this.property="";
		this.updatedate="";
		this.updateperson="";
		this.updatedate_start="";
		this.updatedate_end="";
		this.start="0";
		this.end="50";
		this.sort="";
		this.dir="asc";
		this.version="";
	}
	
	
	public String getVersion() {
		return version;
	}


	public void setVersion(String version) {
		this.version = version;
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
	public String getEquiptype() {
		return equiptype;
	}
	public void setEquiptype(String equiptype) {
		this.equiptype = equiptype;
	}
	public String getNename() {
		return nename;
	}
	public void setNename(String nename) {
		this.nename = nename;
	}
	public String getSystemcode() {
		return systemcode;
	}
	public void setSystemcode(String systemcode) {
		this.systemcode = systemcode;
	}
	public String getProjectname() {
		return projectname;
	}
	public void setProjectname(String projectname) {
		this.projectname = projectname;
	}
	public String getEquiplabel() {
		return equiplabel;
	}
	public void setEquiplabel(String equiplabel) {
		this.equiplabel = equiplabel;
	}
	
	public String getShelfinfo() {
		return shelfinfo;
	}
	public void setShelfinfo(String shelfinfo) {
		this.shelfinfo = shelfinfo;
	}
	public String getNsap() {
		return nsap;
	}
	public void setNsap(String nsap) {
		this.nsap = nsap;
	}
	public String getProperty() {
		return property;
	}
	public void setProperty(String property) {
		this.property = property;
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
	/**
	 * @param roomname the roomname to set
	 */
	public void setRoomname(String roomname) {
		this.roomname = roomname;
	}
	/**
	 * @return the roomname
	 */
	public String getRoomname() {
		return roomname;
	}
	/**
	 * @param stationname the stationname to set
	 */
	public void setStationname(String stationname) {
		this.stationname = stationname;
	}
	/**
	 * @return the stationname
	 */
	public String getStationname() {
		return stationname;
	}
	/**
	 * @param stationcode the stationcode to set
	 */
	public void setStationcode(String stationcode) {
		this.stationcode = stationcode;
	}
	/**
	 * @return the stationcode
	 */
	public String getStationcode() {
		return stationcode;
	}
	/**
	 * @param roomcode the roomcode to set
	 */
	public void setRoomcode(String roomcode) {
		this.roomcode = roomcode;
	}
	/**
	 * @return the roomcode
	 */
	public String getRoomcode() {
		return roomcode;
	}
	/**
	 * @param province the province to set
	 */
	public void setProvince(String province) {
		this.province = province;
	}
	/**
	 * @return the province
	 */
	public String getProvince() {
		return province;
	}
	/**
	 * @param purpose the purpose to set
	 */
	public void setPurpose(String purpose) {
		this.purpose = purpose;
	}
	/**
	 * @return the purpose
	 */
	public String getPurpose() {
		return purpose;
	}
	/**
	 * @param remark the remark to set
	 */
	public void setRemark(String remark) {
		this.remark = remark;
	}
	/**
	 * @return the remark
	 */
	public String getRemark() {
		return remark;
	}
	/**
	 * @param status the status to set
	 */
	public void setStatus(String status) {
		this.status = status;
	}
	/**
	 * @return the status
	 */
	public String getStatus() {
		return status;
	}
	/**
	 * @param x_sbcapacity the x_sbcapacity to set
	 */
	public void setX_sbcapacity(String x_sbcapacity) {
		this.x_sbcapacity = x_sbcapacity;
	}
	/**
	 * @return the x_sbcapacity
	 */
	public String getX_sbcapacity() {
		return x_sbcapacity;
	}
	/**
	 * @param x_configcapacity the x_configcapacity to set
	 */
	public void setX_configcapacity(String x_configcapacity) {
		this.x_configcapacity = x_configcapacity;
	}
	/**
	 * @return the x_configcapacity
	 */
	public String getX_configcapacity() {
		return x_configcapacity;
	}
	public void setNo(String no) {
		this.no = no;
	}
	public String getNo() {
		return no;
	}


//	public String getUser_id() {
//		return user_id;
//	}
//
//
//	public void setUser_id(String user_id) {
//		this.user_id = user_id;
//	}
//	

}
