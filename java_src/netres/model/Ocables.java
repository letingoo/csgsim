package netres.model;

public class Ocables {
	 private String no;
	 private String fiberid;
     private String region;
     private String transystem;
     private String relaysection;
     private String routing;
     private String section;
     private String cablelength;
     private String dept;
     private String start;
     private String end;
	 private String sort;
	 private String dir;
	
	public Ocables() {
	
		this.fiberid = "";
		this.region = "";
		this.transystem = "";
		this.relaysection = "";
		this.routing ="";
		this.section = "";
		this.cablelength = "";
		this.dept = "";
		this.start = "0";
		this.end = "50";
		this.sort = "fiberid";
		this.dir = "asc";
	}

	/**
	 * @return the fiberid
	 */
	public String getFiberid() {
		return fiberid;
	}

	/**
	 * @param fiberid the fiberid to set
	 */
	public void setFiberid(String fiberid) {
		this.fiberid = fiberid;
	}

	/**
	 * @return the region
	 */
	public String getRegion() {
		return region;
	}

	/**
	 * @param region the region to set
	 */
	public void setRegion(String region) {
		this.region = region;
	}

	/**
	 * @return the transystem
	 */
	public String getTransystem() {
		return transystem;
	}

	/**
	 * @param transystem the transystem to set
	 */
	public void setTransystem(String transystem) {
		this.transystem = transystem;
	}

	/**
	 * @return the relaysection
	 */
	public String getRelaysection() {
		return relaysection;
	}

	/**
	 * @param relaysection the relaysection to set
	 */
	public void setRelaysection(String relaysection) {
		this.relaysection = relaysection;
	}

	/**
	 * @return the routing
	 */
	public String getRouting() {
		return routing;
	}

	/**
	 * @param routing the routing to set
	 */
	public void setRouting(String routing) {
		this.routing = routing;
	}

	/**
	 * @return the section
	 */
	public String getSection() {
		return section;
	}

	/**
	 * @param section the section to set
	 */
	public void setSection(String section) {
		this.section = section;
	}

	/**
	 * @return the cablelength
	 */
	public String getCablelength() {
		return cablelength;
	}

	/**
	 * @param cablelength the cablelength to set
	 */
	public void setCablelength(String cablelength) {
		this.cablelength = cablelength;
	}

	/**
	 * @return the dept
	 */
	public String getDept() {
		return dept;
	}

	/**
	 * @param dept the dept to set
	 */
	public void setDept(String dept) {
		this.dept = dept;
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

	public void setNo(String no) {
		this.no = no;
	}

	public String getNo() {
		return no;
	}
	
     

}
