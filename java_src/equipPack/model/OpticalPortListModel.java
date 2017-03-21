package equipPack.model;
/**
 * 光口列表model
 *
 */
public class OpticalPortListModel{
	private String logicport;//端口编码
	private String x_capability;//速率编码
	private String logicportname;//端口名称
	private String systemcode;//系统名称
	private String portserial;
	private String status;
	
	
	public String getLogicport() {
		return logicport;
	}
	public void setLogicport(String logicport) {
		this.logicport = logicport;
	}
	public String getX_capability() {
		return x_capability;
	}
	public void setX_capability(String x_capability) {
		this.x_capability = x_capability;
	}
	public String getLogicportname() {
		return logicportname;
	}
	public void setLogicportname(String logicportname) {
		this.logicportname = logicportname;
	}
	public String getSystemcode() {
		return systemcode;
	}
	public void setSystemcode(String systemcode) {
		this.systemcode = systemcode;
	}
	public String getPortserial() {
		return portserial;
	}
	public void setPortserial(String portserial) {
		this.portserial = portserial;
	}
	
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
}