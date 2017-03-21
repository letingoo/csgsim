package devicepanel.model;

public class SlotInfoModel {
	private String NUM;
	private String CHANNELCODE;
	private String CIRCUITCODE;
	private String RATE;
	private String PORTSERIALNO1;
	private String SLOT1;
	private String SLOT2;
	private String PORTSERIALNO2;
	private String PATH;
	
	public SlotInfoModel(){
		this.NUM = "";
		this.CHANNELCODE = "";
		this.CIRCUITCODE = "";
		this.RATE = "";
		this.PORTSERIALNO1 = "";
		this.SLOT1 = "";
		this.SLOT2 = "";
		this.PORTSERIALNO2 = "";
		this.PATH = "";
	}
	
	public String getNUM() {
		return NUM;
	}

	public void setNUM(String num) {
		NUM = num;
	}

	public String getCHANNELCODE() {
		return CHANNELCODE;
	}

	public void setCHANNELCODE(String channelcode) {
		CHANNELCODE = channelcode;
	}

	public String getCIRCUITCODE() {
		return CIRCUITCODE;
	}

	public void setCIRCUITCODE(String circuitcode) {
		CIRCUITCODE = circuitcode;
	}

	public String getRATE() {
		return RATE;
	}

	public void setRATE(String rate) {
		RATE = rate;
	}

	public String getPORTSERIALNO1() {
		return PORTSERIALNO1;
	}

	public void setPORTSERIALNO1(String portserialno1) {
		PORTSERIALNO1 = portserialno1;
	}

	public String getSLOT1() {
		return SLOT1;
	}

	public void setSLOT1(String slot1) {
		SLOT1 = slot1;
	}

	public String getSLOT2() {
		return SLOT2;
	}

	public void setSLOT2(String slot2) {
		SLOT2 = slot2;
	}

	public String getPORTSERIALNO2() {
		return PORTSERIALNO2;
	}

	public void setPORTSERIALNO2(String portserialno2) {
		PORTSERIALNO2 = portserialno2;
	}

	public String getPATH() {
		return PATH;
	}

	public void setPATH(String path) {
		PATH = path;
	}
	
}
