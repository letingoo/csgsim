package fiberwire.model;

public class EquInfoModel {
	private String systemcode;
	private String sysname;
	private String province;
	private String province_name;
	private String stationcode;
	private String stationname;
	private String roomcode;
	private String roomname;
    private String x_vendor;
    private String vendor_name;
    private String equipcode;
    private String equipname;
    private String x_model;
    private String equiptype ;
    private String equiptype_name;
    private String property;
    private String property_name;
    private String nename;
    private String price;
    private String purpose;
    private String purpose_name;
    private String status;
    private String status_name;
    private String projectname ;
    private String nsap ;
    private String equiplabel ;
    private String remark;    
    private String shelfinfo;	
	private String updatedate ;
	private String updateperson;		
	private String x;
	private String y;
	private String version;
	private String hardware_version;
	private String name_std;	
	public String getName_std() {
		return name_std;
	}
	public void setName_std(String nameStd) {
		name_std = nameStd;
	}
	private String alarmlevel;
	private String alarmcount;
	private String rootalarm;
	public EquInfoModel()
	{
		equipcode="";
		equipname="";
		x_vendor="";
		x_model="";
		equiptype="";
		nename="";
		systemcode="";
		projectname="";
		equiplabel="";
		shelfinfo="";
		nsap="";
		property="";
		updatedate="";
		updateperson="";
		this.stationcode="";
		this.stationname="";
		this.roomcode="";
		this.roomname="";
		this.alarmlevel="";
		this.alarmcount="";
		this.hardware_version="";
	}
	public String getHardware_version() {
		return hardware_version;
	}
	public void setHardware_version(String hardware_version) {
		this.hardware_version = hardware_version;
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

	public String getX() {
		return x;
	}
	public void setX(String x) {
		this.x = x;
	}
	public String getY() {
		return y;
	}
	public void setY(String y) {
		this.y = y;
	}
	public String getSysname() {
		return sysname;
	}
	public void setSysname(String sysname) {
		this.sysname = sysname;
	}
	public String getProvince() {
		return province;
	}
	public void setProvince(String province) {
		this.province = province;
	}
	public String getProvince_name() {
		return province_name;
	}
	public void setProvince_name(String province_name) {
		this.province_name = province_name;
	}
	public String getStationcode() {
		return stationcode;
	}
	public void setStationcode(String stationcode) {
		this.stationcode = stationcode;
	}
	
	public String getStationname() {
		return stationname;
	}
	public void setStationname(String stationname) {
		this.stationname = stationname;
	}
	public String getRoomcode() {
		return roomcode;
	}
	public void setRoomcode(String roomcode) {
		this.roomcode = roomcode;
	}
	public String getRoomname() {
		return roomname;
	}
	public void setRoomname(String roomname) {
		this.roomname = roomname;
	}
	public String getVendor_name() {
		return vendor_name;
	}
	public void setVendor_name(String vendor_name) {
		this.vendor_name = vendor_name;
	}
	public String getEquiptype_name() {
		return equiptype_name;
	}
	public void setEquiptype_name(String equiptype_name) {
		this.equiptype_name = equiptype_name;
	}
	public String getProperty_name() {
		return property_name;
	}
	public void setProperty_name(String property_name) {
		this.property_name = property_name;
	}
	public String getPrice() {
		return price;
	}
	public void setPrice(String price) {
		this.price = price;
	}
	public String getPurpose() {
		return purpose;
	}
	public void setPurpose(String purpose) {
		this.purpose = purpose;
	}
	public String getPurpose_name() {
		return purpose_name;
	}
	public void setPurpose_name(String purpose_name) {
		this.purpose_name = purpose_name;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getStatus_name() {
		return status_name;
	}
	public void setStatus_name(String status_name) {
		this.status_name = status_name;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getAlarmlevel() {
		return alarmlevel;
	}
	public void setAlarmlevel(String alarmlevel) {
		this.alarmlevel = alarmlevel;
	}
	public String getAlarmcount() {
		return alarmcount;
	}
	public void setAlarmcount(String alarmcount) {
		this.alarmcount = alarmcount;
	}
	public String getRootalarm() {
		return rootalarm;
	}
	public void setRootalarm(String rootalarm) {
		this.rootalarm = rootalarm;
	}
	
}
