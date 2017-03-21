/*
 * File: PortUseStatsModel.java
 * Author: Zhang Hao
 * Date: 2010/07/16
*/

package devicepanel.model;

import java.text.NumberFormat; 

public class PortUseStatsModel {
	private String equipcode;
	private double portnum;
	private double portusenum;
	private String rate;
	public String getRate() {
		return rate;
	}
	public void setRate(String rate) {
		this.rate = rate;
	}
	private String portuserate;
	
	public String getEquipcode() {
		return equipcode;
	}
	public void setEquipcode(String equipcode) {
		this.equipcode = equipcode;
	}
	public double getPortnum() {
		return portnum;
	}
	public void setPortnum(double portnum) {
		this.portnum = portnum;
	}
	public double getPortusenum() {
		return portusenum;
	}
	public void setPortusenum(double portusenum) {
		this.portusenum = portusenum;
	}
	public String getPortuserate() {
        NumberFormat nf = NumberFormat.getPercentInstance();
        nf.setMaximumIntegerDigits(3); 
        nf.setMaximumFractionDigits(2);

		if (portnum == 0) portuserate = nf.format(0);
		else portuserate = nf.format(portusenum/portnum);
		return portuserate;
	}
	public void setPortuserate(String portuserate) {
		this.portuserate = portuserate;
	}


}
