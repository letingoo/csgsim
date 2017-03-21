/**
 * 
 */
package alarmMgr.model;

/**
 * <p>方法说明:</p>
 * @author Haifeng Liu
 * @date 2011-1-12
 * @return 
 **/

public class FaultModel {
	private String no="";
	private String equipcode="";
	private String dealfaultunit="";
	private String gjobject="";
	private String faultresult;
	private String faulttime;
	private String resumetime="";
	private String start="";
	private String end="";
	public String getNo() {
		return no;
	}
	public void setNo(String no) {
		this.no = no;
	}
	public String getEquipcode() {
		return equipcode;
	}
	public void setEquipcode(String equipcode) {
		this.equipcode = equipcode;
	}
	public String getDealfaultunit() {
		return dealfaultunit;
	}
	public void setDealfaultunit(String dealfaultunit) {
		this.dealfaultunit = dealfaultunit;
	}
	public String getGjobject() {
		return gjobject;
	}
	public void setGjobject(String gjobject) {
		this.gjobject = gjobject;
	}
	public String getFaultresult() {
		return faultresult;
	}
	public void setFaultresult(String faultresult) {
		this.faultresult = faultresult;
	}
	public String getFaulttime() {
		return faulttime;
	}
	public void setFaulttime(String faulttime) {
		this.faulttime = faulttime;
	}
	public String getResumetime() {
		return resumetime;
	}
	public void setResumetime(String resumetime) {
		this.resumetime = resumetime;
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
	
}
