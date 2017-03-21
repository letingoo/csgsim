/**
 * 通道模型
 */
package resManager.resBusiness.model;

public class CircuitChannel{
	/**
	 * 序号
	 */
	private String no;
	/**
	 * 电路编号
	 */
	private String circuitcode;
	
	/**
	 * A端端口
	 */
	private String porta;
	/**
	 * A端端口编号
	 */
	private String portcode1;
	/**
	 * 业务名称
	 */
	private String circuit;
	/**
	 * 通道名称
	 */
	private String channelcode;
	/**
	 * A端时隙
	 */
	private String slot1;
	/**
	 * Z端端口
	 */
	private String portz;
	/**
	 * Z端端口编号
	 */
	private String portcode2;
	/**
	 * Z端时隙
	 */
	private String slot2;
	/**
	 * 速率
	 */
	private String rate;
	
	private String end;
	private String start;
	private String sort;
	private String dir;
	
	
	public CircuitChannel() {
		this.no="";
		this.circuitcode="";
		this.porta="";
		this.circuit="";
		this.channelcode="";
		this.slot1="";
		this.portz = "";
		this.slot2 ="";
		this.rate = "";
		this.portcode1 = "";
		this.portcode2 = "";
	}


	public String getNo() {
		return no;
	}


	public void setNo(String no) {
		this.no = no;
	}


	public String getCircuitcode() {
		return circuitcode;
	}


	public void setCircuitcode(String circuitcode) {
		this.circuitcode = circuitcode;
	}


	public String getPorta() {
		return porta;
	}


	public void setPorta(String porta) {
		this.porta = porta;
	}


	public String getCircuit() {
		return circuit;
	}


	public void setCircuit(String circuit) {
		this.circuit = circuit;
	}


	public String getChannelcode() {
		return channelcode;
	}


	public void setChannelcode(String channelcode) {
		this.channelcode = channelcode;
	}


	public String getSlot1() {
		return slot1;
	}


	public void setSlot1(String slot1) {
		this.slot1 = slot1;
	}


	public String getPortz() {
		return portz;
	}


	public void setPortz(String portz) {
		this.portz = portz;
	}


	public String getSlot2() {
		return slot2;
	}


	public void setSlot2(String slot2) {
		this.slot2 = slot2;
	}


	public String getRate() {
		return rate;
	}


	public void setRate(String rate) {
		this.rate = rate;
	}


	public String getEnd() {
		return end;
	}


	public void setEnd(String end) {
		this.end = end;
	}


	public String getStart() {
		return start;
	}


	public void setStart(String start) {
		this.start = start;
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


	public String getPortcode1() {
		return portcode1;
	}


	public void setPortcode1(String portcode1) {
		this.portcode1 = portcode1;
	}


	public String getPortcode2() {
		return portcode2;
	}


	public void setPortcode2(String portcode2) {
		this.portcode2 = portcode2;
	}

}