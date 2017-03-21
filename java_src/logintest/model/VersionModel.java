package logintest.model;

public class VersionModel {
	
	private String no;
	
	private String vid;
	
	private String vname;
	
	private String vdesc;
	
	private String fill_time;
	
	private String fill_man;
	
	private String fill_man_id;
	
	private String remark;

	private String from_vid;
	
	private String from_vname;
	private String xtbm;
	private String xtxx;
	private String vtype;
	private String oper_id;
	private String parent_id;
	private String start;
	private String end;
	private String sort;
	private String dir;
	private String isnumber;
	
	public VersionModel() {
		
	}
	

	public VersionModel(String no, String vid, String vname, String vdesc,
			String fill_time, String fill_man, String fill_man_id,
			String remark, String from_vid, String from_vname, String start,
			String end, String sort, String dir, String isnumber,String oper_id,String parent_id,String xtbm,String xtxx,String vtype) {
		super();
		this.no = no;
		this.vid = vid;
		this.vname = vname;
		this.vdesc = vdesc;
		this.fill_time = fill_time;
		this.fill_man = fill_man;
		this.fill_man_id = fill_man_id;
		this.remark = remark;
		this.from_vid = from_vid;
		this.from_vname = from_vname;
		this.oper_id = oper_id;
		this.parent_id = parent_id;
		this.start="0";
		this.end="50";
		this.sort="";
		this.dir="asc";
		this.isnumber = isnumber;
		this.xtbm=xtbm;
		this.xtxx=xtxx;
		this.vtype=vtype;
	}
	
	public String getNo() {
		return no;
	}

	public void setNo(String no) {
		this.no = no;
	}

	public String getVid() {
		return vid;
	}

	public void setVid(String vid) {
		this.vid = vid;
	}

	public String getVname() {
		return vname;
	}

	public void setVname(String vname) {
		this.vname = vname;
	}

	public String getVdesc() {
		return vdesc;
	}

	public void setVdesc(String vdesc) {
		this.vdesc = vdesc;
	}

	public String getFill_time() {
		return fill_time;
	}

	public void setFill_time(String fill_time) {
		this.fill_time = fill_time;
	}

	public String getFill_man() {
		return fill_man;
	}

	public void setFill_man(String fill_man) {
		this.fill_man = fill_man;
	}

	public String getFill_man_id() {
		return fill_man_id;
	}

	public void setFill_man_id(String fill_man_id) {
		this.fill_man_id = fill_man_id;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
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

	public String getIsnumber() {
		return isnumber;
	}

	public void setIsnumber(String isnumber) {
		this.isnumber = isnumber;
	}

	public String getFrom_vid() {
		return from_vid;
	}
	public void setFrom_vid(String from_vid) {
		this.from_vid = from_vid;
	}
	public String getFrom_vname() {
		return from_vname;
	}
	public void setFrom_vname(String from_vname) {
		this.from_vname = from_vname;
	}


	public String getOper_id() {
		return oper_id;
	}


	public void setOper_id(String oper_id) {
		this.oper_id = oper_id;
	}


	public String getParent_id() {
		return parent_id;
	}


	public void setParent_id(String parent_id) {
		this.parent_id = parent_id;
	}


	public String getXtbm() {
		return xtbm;
	}


	public void setXtbm(String xtbm) {
		this.xtbm = xtbm;
	}


	public String getXtxx() {
		return xtxx;
	}


	public void setXtxx(String xtxx) {
		this.xtxx = xtxx;
	}


	public String getVtype() {
		return vtype;
	}


	public void setVtype(String vtype) {
		this.vtype = vtype;
	}

	
	
}
