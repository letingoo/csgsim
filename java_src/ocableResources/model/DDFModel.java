package ocableResources.model;

/*
 * 北京市天元网络技术股份有限公司
 * @date:2011-3-18
 * @author:ynn
 */
public class DDFModel{
	private String no;                     //--序号
	private String isnumber;
	private String ddfddmcode;             //DDF模块编号
	private String name_std;               //DDF模块名称
	private String stationcode;            //所属局站编号
	private String roomcode;               //所属机房编号
	private String equipshelfcode;         //所属机架编号
	
	private String station_name_std;       //所属局站
	private String en_room_name_std;       //所属机房
	private String en_equipshelf_name_std; //所属机架
	private String vendor;                 //生产厂家
	private String ddfddmserial;           //DDF模块序号
	private String rowcount;               //行数
	private String col;                    //列数
	private String x_configcapacity;       //容量
	private String property;               //产权单位
	private String rundate;                //投运日期
	private String productdate;            //出厂日期
	private String x_model;                //规格型号
	private String asset_no;               //资产编号
	private String projectname;            //所属工程
	private String firsttestdate;          //初验日期
	private String lasttestdate;           //终验日期
	private String maintaindate;           //保修截止日期
	private String retiredate;             //退运日期
	private String dispatchunit;          //调度单位
	private String remark;                 //备注
	private String updateperson;
	private String updatedate;

	private String updatedate_start;      //更新时间  起始
	private String updatedate_end;        //更新时间  截至
	private String rundate_start;
	private String rundate_end;
	private String productdate_start;
	private String productdate_end;
	private String maintaindate_start;
	private String maintaindate_end;
	private String firsttestdate_start;
	private String firsttestdate_end;
	private String lasttestdate_start;
	private String lasttestdate_end;
	private String retiredate_start;
	private String retiredate_end;
	
	private String portcount;
	
	private String start;
	private String end;
	private String sort;
	private String dir;
	
	
	/**
	 * @return the isnumber
	 */
	public String getIsnumber() {
		return isnumber;
	}
	/**
	 * @param isnumber the isnumber to set
	 */
	public void setIsnumber(String isnumber) {
		this.isnumber = isnumber;
	}
	/**
	 * @return the ddfddmcode
	 */
	public String getDdfddmcode() {
		return ddfddmcode;
	}
	/**
	 * @param ddfddmcode the ddfddmcode to set
	 */
	public void setDdfddmcode(String ddfddmcode) {
		this.ddfddmcode = ddfddmcode;
	}
	/**
	 * @return the stationcode
	 */
	public String getStationcode() {
		return stationcode;
	}
	/**
	 * @param stationcode the stationcode to set
	 */
	public void setStationcode(String stationcode) {
		this.stationcode = stationcode;
	}
	/**
	 * @return the roomcode
	 */
	public String getRoomcode() {
		return roomcode;
	}
	/**
	 * @param roomcode the roomcode to set
	 */
	public void setRoomcode(String roomcode) {
		this.roomcode = roomcode;
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
	/**
	 * @return the updateperson
	 */
	public String getUpdateperson() {
		return updateperson;
	}
	/**
	 * @param updateperson the updateperson to set
	 */
	public void setUpdateperson(String updateperson) {
		this.updateperson = updateperson;
	}
	/**
	 * @return the updatedate
	 */
	public String getUpdatedate() {
		return updatedate;
	}
	/**
	 * @param updatedate the updatedate to set
	 */
	public void setUpdatedate(String updatedate) {
		this.updatedate = updatedate;
	}
	
	/**
	 * @return the no
	 */
	public String getNo() {
		return no;
	}
	/**
	 * @param no the no to set
	 */
	public void setNo(String no) {
		this.no = no;
	}
	/**
	 * @return the name_std
	 */
	public String getName_std() {
		return name_std;
	}
	/**
	 * @param nameStd the name_std to set
	 */
	public void setName_std(String nameStd) {
		name_std = nameStd;
	}
	/**
	 * @return the station_name_std
	 */
	public String getStation_name_std() {
		return station_name_std;
	}
	/**
	 * @param stationNameStd the station_name_std to set
	 */
	public void setStation_name_std(String stationNameStd) {
		station_name_std = stationNameStd;
	}
	/**
	 * @return the en_room_name_std
	 */
	public String getEn_room_name_std() {
		return en_room_name_std;
	}
	/**
	 * @param enRoomNameStd the en_room_name_std to set
	 */
	public void setEn_room_name_std(String enRoomNameStd) {
		en_room_name_std = enRoomNameStd;
	}
	/**
	 * @return the en_equipshelf_name_std
	 */
	public String getEn_equipshelf_name_std() {
		return en_equipshelf_name_std;
	}
	/**
	 * @param enEquipshelfNameStd the en_equipshelf_name_std to set
	 */
	public void setEn_equipshelf_name_std(String enEquipshelfNameStd) {
		en_equipshelf_name_std = enEquipshelfNameStd;
	}
	/**
	 * @return the vendor
	 */
	public String getVendor() {
		return vendor;
	}
	/**
	 * @param vendor the vendor to set
	 */
	public void setVendor(String vendor) {
		this.vendor = vendor;
	}
	
	/**
	 * @return the ddfddmserial
	 */
	public String getDdfddmserial() {
		return ddfddmserial;
	}
	/**
	 * @param ddfddmserial the ddfddmserial to set
	 */
	public void setDdfddmserial(String ddfddmserial) {
		this.ddfddmserial = ddfddmserial;
	}
	/**
	 * @return the rowcount
	 */
	public String getRowcount() {
		return rowcount;
	}
	/**
	 * @param rowcount the rowcount to set
	 */
	public void setRowcount(String rowcount) {
		this.rowcount = rowcount;
	}
	/**
	 * @return the col
	 */
	public String getCol() {
		return col;
	}
	/**
	 * @param col the col to set
	 */
	public void setCol(String col) {
		this.col = col;
	}
	/**
	 * @return the x_configcapacity
	 */
	public String getX_configcapacity() {
		return x_configcapacity;
	}
	/**
	 * @param xConfigcapacity the x_configcapacity to set
	 */
	public void setX_configcapacity(String xConfigcapacity) {
		x_configcapacity = xConfigcapacity;
	}
	/**
	 * @return the rundate
	 */
	public String getRundate() {
		return rundate;
	}
	/**
	 * @param rundate the rundate to set
	 */
	public void setRundate(String rundate) {
		this.rundate = rundate;
	}
	/**
	 * @return the productdate
	 */
	public String getProductdate() {
		return productdate;
	}
	/**
	 * @param productdate the productdate to set
	 */
	public void setProductdate(String productdate) {
		this.productdate = productdate;
	}
	/**
	 * @return the property
	 */
	public String getProperty() {
		return property;
	}
	/**
	 * @param property the property to set
	 */
	public void setProperty(String property) {
		this.property = property;
	}
	/**
	 * @return the x_model
	 */
	public String getX_model() {
		return x_model;
	}
	/**
	 * @param xModel the x_model to set
	 */
	public void setX_model(String xModel) {
		x_model = xModel;
	}
	/**
	 * @return the dispatchunit
	 */
	public String getDispatchunit() {
		return dispatchunit;
	}
	/**
	 * @param dispatchunit the dispatchunit to set
	 */
	public void setDispatchunit(String dispatchunit) {
		this.dispatchunit = dispatchunit;
	}
	/**
	 * @return the asset_no
	 */
	public String getAsset_no() {
		return asset_no;
	}
	/**
	 * @param assetNo the asset_no to set
	 */
	public void setAsset_no(String assetNo) {
		asset_no = assetNo;
	}
	/**
	 * @return the projectname
	 */
	public String getProjectname() {
		return projectname;
	}
	/**
	 * @param projectname the projectname to set
	 */
	public void setProjectname(String projectname) {
		this.projectname = projectname;
	}
	/**
	 * @return the firsttestdate
	 */
	public String getFirsttestdate() {
		return firsttestdate;
	}
	/**
	 * @param firsttestdate the firsttestdate to set
	 */
	public void setFirsttestdate(String firsttestdate) {
		this.firsttestdate = firsttestdate;
	}
	/**
	 * @return the lasttestdate
	 */
	public String getLasttestdate() {
		return lasttestdate;
	}
	/**
	 * @param lasttestdate the lasttestdate to set
	 */
	public void setLasttestdate(String lasttestdate) {
		this.lasttestdate = lasttestdate;
	}
	/**
	 * @return the maintaindate
	 */
	public String getMaintaindate() {
		return maintaindate;
	}
	/**
	 * @param maintaindate the maintaindate to set
	 */
	public void setMaintaindate(String maintaindate) {
		this.maintaindate = maintaindate;
	}
	/**
	 * @return the retiredate
	 */
	public String getRetiredate() {
		return retiredate;
	}
	/**
	 * @param retiredate the retiredate to set
	 */
	public void setRetiredate(String retiredate) {
		this.retiredate = retiredate;
	}
	/**
	 * @return the remark
	 */
	public String getRemark() {
		return remark;
	}
	/**
	 * @param remark the remark to set
	 */
	public void setRemark(String remark) {
		this.remark = remark;
	}
	/**
	 * @return the updatedate_start
	 */
	public String getUpdatedate_start() {
		return updatedate_start;
	}
	/**
	 * @param updatedateStart the updatedate_start to set
	 */
	public void setUpdatedate_start(String updatedateStart) {
		updatedate_start = updatedateStart;
	}
	/**
	 * @return the updatedate_end
	 */
	public String getUpdatedate_end() {
		return updatedate_end;
	}
	/**
	 * @param updatedateEnd the updatedate_end to set
	 */
	public void setUpdatedate_end(String updatedateEnd) {
		updatedate_end = updatedateEnd;
	}
	/**
	 * @return the start
	 */
	public String getStart() {
		return start;
	}
	/**
	 * @param start the start to set
	 */
	public void setStart(String start) {
		this.start = start;
	}
	/**
	 * @return the end
	 */
	public String getEnd() {
		return end;
	}
	/**
	 * @param end the end to set
	 */
	public void setEnd(String end) {
		this.end = end;
	}
	/**
	 * @return the sort
	 */
	public String getSort() {
		return sort;
	}
	/**
	 * @param sort the sort to set
	 */
	public void setSort(String sort) {
		this.sort = sort;
	}
	/**
	 * @return the dir
	 */
	public String getDir() {
		return dir;
	}
	/**
	 * @param dir the dir to set
	 */
	public void setDir(String dir) {
		this.dir = dir;
	}
	/**
	 * @return the rundate_start
	 */
	public String getRundate_start() {
		return rundate_start;
	}
	/**
	 * @param rundateStart the rundate_start to set
	 */
	public void setRundate_start(String rundateStart) {
		rundate_start = rundateStart;
	}
	/**
	 * @return the rundate_end
	 */
	public String getRundate_end() {
		return rundate_end;
	}
	/**
	 * @param rundateEnd the rundate_end to set
	 */
	public void setRundate_end(String rundateEnd) {
		rundate_end = rundateEnd;
	}
	
	/**
	 * @return the productdate_start
	 */
	public String getProductdate_start() {
		return productdate_start;
	}
	/**
	 * @param productdateStart the productdate_start to set
	 */
	public void setProductdate_start(String productdateStart) {
		productdate_start = productdateStart;
	}
	/**
	 * @return the productdate_end
	 */
	public String getProductdate_end() {
		return productdate_end;
	}
	/**
	 * @param productdateEnd the productdate_end to set
	 */
	public void setProductdate_end(String productdateEnd) {
		productdate_end = productdateEnd;
	}
	/**
	 * @return the maintaindate_start
	 */
	public String getMaintaindate_start() {
		return maintaindate_start;
	}
	/**
	 * @param maintaindateStart the maintaindate_start to set
	 */
	public void setMaintaindate_start(String maintaindateStart) {
		maintaindate_start = maintaindateStart;
	}
	/**
	 * @return the maintaindate_end
	 */
	public String getMaintaindate_end() {
		return maintaindate_end;
	}
	/**
	 * @param maintaindateEnd the maintaindate_end to set
	 */
	public void setMaintaindate_end(String maintaindateEnd) {
		maintaindate_end = maintaindateEnd;
	}
	/**
	 * @return the firsttestdate_start
	 */
	public String getFirsttestdate_start() {
		return firsttestdate_start;
	}
	/**
	 * @param firsttestdateStart the firsttestdate_start to set
	 */
	public void setFirsttestdate_start(String firsttestdateStart) {
		firsttestdate_start = firsttestdateStart;
	}
	/**
	 * @return the firsttestdate_end
	 */
	public String getFirsttestdate_end() {
		return firsttestdate_end;
	}
	/**
	 * @param firsttestdateEnd the firsttestdate_end to set
	 */
	public void setFirsttestdate_end(String firsttestdateEnd) {
		firsttestdate_end = firsttestdateEnd;
	}
	/**
	 * @return the lasttestdate_start
	 */
	public String getLasttestdate_start() {
		return lasttestdate_start;
	}
	/**
	 * @param lasttestdateStart the lasttestdate_start to set
	 */
	public void setLasttestdate_start(String lasttestdateStart) {
		lasttestdate_start = lasttestdateStart;
	}
	/**
	 * @return the lasttestdate_end
	 */
	public String getLasttestdate_end() {
		return lasttestdate_end;
	}
	/**
	 * @param lasttestdateEnd the lasttestdate_end to set
	 */
	public void setLasttestdate_end(String lasttestdateEnd) {
		lasttestdate_end = lasttestdateEnd;
	}
	/**
	 * @return the retiredate_start
	 */
	public String getRetiredate_start() {
		return retiredate_start;
	}
	/**
	 * @param retiredateStart the retiredate_start to set
	 */
	public void setRetiredate_start(String retiredateStart) {
		retiredate_start = retiredateStart;
	}
	/**
	 * @return the retiredate_end
	 */
	public String getRetiredate_end() {
		return retiredate_end;
	}
	/**
	 * @param retiredateEnd the retiredate_end to set
	 */
	public void setRetiredate_end(String retiredateEnd) {
		retiredate_end = retiredateEnd;
	}
	
	/**
	 * @return the portcount
	 */
	public String getPortcount() {
		return portcount;
	}
	/**
	 * @param portcount the portcount to set
	 */
	public void setPortcount(String portcount) {
		this.portcount = portcount;
	}
}
