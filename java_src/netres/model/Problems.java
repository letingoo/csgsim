package netres.model;

public class Problems {
	private String no;
	private String problemid;
	private String pmodule;
	private String pdescription;
	private String pdealer;
	private String pstatus;
	private String ptreatmethod;
	private String premark;
	private String ppopperson;
	private String pmakedate;
	private String phelper;
	private String start;
	private String end;
	private String sort;
	private String dir;
	private String pmakedate_start;
	private String pmakedate_end;
	private String pproperty;
	private String deadlinedate;
	private String finisheddate;
	private String reSort;

	public Problems() {
		this.no = "";
		this.problemid="";
		this.pmodule="";
		this.pdescription="";
		this.pdealer="";
		this.pstatus="";
		this.ptreatmethod="";
		this.premark="";
		this.ppopperson="";
		this.pmakedate="";
		this.phelper="";
		this.start = "0";
		this.end = "50";
		this.sort = "";
		this.dir = "asc";
		this.pproperty = "";
		this.deadlinedate = "";
		this.finisheddate = "";
		this.reSort = "pstatus";
	}

	/**
	 * @return the reSort
	 */
	public String getReSort() {
		return reSort;
	}

	/**
	 * @param reSort the reSort to set
	 */
	public void setReSort(String reSort) {
		this.reSort = reSort;
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
	 * @return the problemid
	 */
	public String getProblemid() {
		return problemid;
	}

	/**
	 * @param problemid the problemid to set
	 */
	public void setProblemid(String problemid) {
		this.problemid = problemid;
	}

	/**
	 * @return the pmodule
	 */
	public String getPmodule() {
		return pmodule;
	}

	/**
	 * @param pmodule the pmodule to set
	 */
	public void setPmodule(String pmodule) {
		this.pmodule = pmodule;
	}

	/**
	 * @return the pdescription
	 */
	public String getPdescription() {
		return pdescription;
	}

	/**
	 * @param pdescription the pdescription to set
	 */
	public void setPdescription(String pdescription) {
		this.pdescription = pdescription;
	}

	/**
	 * @return the pdealer
	 */
	public String getPdealer() {
		return pdealer;
	}

	/**
	 * @param pdealer the pdealer to set
	 */
	public void setPdealer(String pdealer) {
		this.pdealer = pdealer;
	}

	/**
	 * @return the pstatus
	 */
	public String getPstatus() {
		return pstatus;
	}

	/**
	 * @param pstatus the pstatus to set
	 */
	public void setPstatus(String pstatus) {
		this.pstatus = pstatus;
	}

	/**
	 * @return the ptreatmethod
	 */
	public String getPtreatmethod() {
		return ptreatmethod;
	}

	/**
	 * @param ptreatmethod the ptreatmethod to set
	 */
	public void setPtreatmethod(String ptreatmethod) {
		this.ptreatmethod = ptreatmethod;
	}

	/**
	 * @return the premark
	 */
	public String getPremark() {
		return premark;
	}

	/**
	 * @param premark the premark to set
	 */
	public void setPremark(String premark) {
		this.premark = premark;
	}

	/**
	 * @return the ppopperson
	 */
	public String getPpopperson() {
		return ppopperson;
	}

	/**
	 * @param ppopperson the ppopperson to set
	 */
	public void setPpopperson(String ppopperson) {
		this.ppopperson = ppopperson;
	}

	/**
	 * @return the pmakedate
	 */
	public String getPmakedate() {
		return pmakedate;
	}

	/**
	 * @param pmakedate the pmakedate to set
	 */
	public void setPmakedate(String pmakedate) {
		this.pmakedate = pmakedate;
	}

	/**
	 * @return the phelper
	 */
	public String getPhelper() {
		return phelper;
	}

	/**
	 * @param phelper the phelper to set
	 */
	public void setPhelper(String phelper) {
		this.phelper = phelper;
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
	 * @return the pmakedate_start
	 */
	public String getPmakedate_start() {
		return pmakedate_start;
	}

	/**
	 * @param pmakedateStart the pmakedate_start to set
	 */
	public void setPmakedate_start(String pmakedateStart) {
		pmakedate_start = pmakedateStart;
	}

	/**
	 * @return the pmakedate_end
	 */
	public String getPmakedate_end() {
		return pmakedate_end;
	}

	/**
	 * @param pmakedateEnd the pmakedate_end to set
	 */
	public void setPmakedate_end(String pmakedateEnd) {
		pmakedate_end = pmakedateEnd;
	}

	/**
	 * @return the pproperty
	 */
	public String getPproperty() {
		return pproperty;
	}

	/**
	 * @param pproperty the pproperty to set
	 */
	public void setPproperty(String pproperty) {
		this.pproperty = pproperty;
	}

	/**
	 * @return the deadlinedate
	 */
	public String getDeadlinedate() {
		return deadlinedate;
	}

	/**
	 * @param deadlinedate the deadlinedate to set
	 */
	public void setDeadlinedate(String deadlinedate) {
		this.deadlinedate = deadlinedate;
	}

	/**
	 * @return the finisheddate
	 */
	public String getFinisheddate() {
		return finisheddate;
	}

	/**
	 * @param finisheddate the finisheddate to set
	 */
	public void setFinisheddate(String finisheddate) {
		this.finisheddate = finisheddate;
	}
}
