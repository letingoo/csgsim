/*
 * File: DevicePortStatsModel.java
 * Author: Zhang Hao
 * Date: 2010/07/16
*/

package devicepanel.model;

public class DevicePortStatsModel {
	private String equipcode;
	private String logicport;		
	private String x_capability;		
	private String allvc4;			
	private String usrvc4;	
	private String usrvc12;			
	private String freevc4;	
	private String rate;
	
	public String getEquipcode() {
		return equipcode;
	}
	public void setEquipcode(String equipcode) {
		this.equipcode = equipcode;
	}
	public String getLogicport() {
		return logicport;
	}
	public void setLogicport(String logicport) {
		this.logicport = logicport;
	}
	public String getX_capability() {
		return x_capability;
	}
	public void setX_capability(String xCapability) {
		x_capability = xCapability;
	}
	public String getAllvc4() {
		return allvc4;
	}
	public void setAllvc4(String allvc4) {
		this.allvc4 = allvc4;
	}
	public String getUsrvc4() {
		return usrvc4;
	}
	public void setUsrvc4(String usrvc4) {
		this.usrvc4 = usrvc4;
	}
	public String getUsrvc12() {
		return usrvc12;
	}
	public void setUsrvc12(String usrvc12) {
		this.usrvc12 = usrvc12;
	}
	public String getFreevc4() {
		return freevc4;
	}
	public void setFreevc4(String freevc4) {
		this.freevc4 = freevc4;
	}
	public String getRate() {
		return rate;
	}
	public void setRate(String rate) {
		this.rate = rate;
	}						

	
}
